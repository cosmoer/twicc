"""Outbound network switches (twicc.network_switches, docs/offline-mode.md).

No network: every outbound helper is replaced by one that fails the test if called.
"""

import asyncio
import os

import pytest
from django.test import override_settings

import twicc.synced_settings as ss
from twicc import network_switches
from twicc.network_switches import SWITCHES, is_offline, network_feature_enabled, network_switches_state

SWITCHABLE = {feature: env for feature, env in SWITCHES.items() if env}


def _forbidden(*args, **kwargs):
    raise AssertionError("outbound network call made while its switch is off")


async def _forbidden_async(*args, **kwargs):
    _forbidden()


# --- the switches themselves -------------------------------------------------------------


def test_every_feature_is_on_by_default():
    assert not is_offline()
    assert network_switches_state() == {feature: True for feature in SWITCHES}


@pytest.mark.parametrize("feature,env", sorted(SWITCHABLE.items()))
def test_each_switch_turns_off_only_its_feature(monkeypatch, feature, env):
    monkeypatch.setenv(env, "1")
    state = network_switches_state()
    assert state.pop(feature) is False
    assert all(state.values())


@pytest.mark.parametrize("value", ["1", "true", "YES", " yes "])
def test_offline_turns_every_feature_off(monkeypatch, value):
    monkeypatch.setenv("TWICC_OFFLINE", value)
    assert is_offline()
    assert network_switches_state() == {feature: False for feature in SWITCHES}


@pytest.mark.parametrize("value", ["", "0", "false", "no"])
def test_falsy_values_keep_features_on(monkeypatch, value):
    monkeypatch.setenv("TWICC_OFFLINE", value)
    monkeypatch.setenv("TWICC_NO_VERSION_CHECK", value)
    assert all(network_switches_state().values())


def test_unknown_feature_is_an_error():
    with pytest.raises(KeyError):
        network_feature_enabled("no_such_feature")


def test_offline_asks_claude_code_to_skip_nonessential_traffic(monkeypatch):
    monkeypatch.delenv("CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC", raising=False)
    network_switches.apply_offline_environment()
    assert "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC" not in os.environ
    monkeypatch.setenv("TWICC_OFFLINE", "1")
    network_switches.apply_offline_environment()
    assert os.environ["CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC"] == "1"


def test_offline_keeps_an_explicit_claude_code_value(monkeypatch):
    monkeypatch.setenv("TWICC_OFFLINE", "1")
    monkeypatch.setenv("CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC", "0")
    network_switches.apply_offline_environment()
    assert os.environ["CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC"] == "0"


# --- each feature honours its switch -----------------------------------------------------


@pytest.mark.parametrize("env", ["TWICC_NO_VERSION_CHECK", "TWICC_OFFLINE"])
def test_version_check_task_never_queries_pypi(monkeypatch, env):
    from twicc import version_check_task

    monkeypatch.setenv(env, "1")
    monkeypatch.setattr(version_check_task, "_check_pypi_version", _forbidden_async)
    asyncio.run(asyncio.wait_for(version_check_task.start_version_check_task(), timeout=5))


@pytest.mark.parametrize("env", ["TWICC_NO_STATUS_PAGE", "TWICC_OFFLINE"])
def test_statuspage_is_never_polled(monkeypatch, env):
    from twicc.core.enums import Provider
    from twicc.providers import statuspage_task

    monkeypatch.setenv(env, "1")
    monkeypatch.setattr(statuspage_task, "fetch_component_status", _forbidden_async)
    for provider in (Provider.CLAUDE_CODE, Provider.CODEX):
        assert asyncio.run(statuspage_task.check_once(provider)) is None
        asyncio.run(asyncio.wait_for(statuspage_task.start_statuspage_task(provider), timeout=5))


@pytest.mark.parametrize("env", ["TWICC_NO_PRICE_SYNC", "TWICC_OFFLINE"])
def test_price_sync_never_fetches_openrouter(monkeypatch, env):
    from twicc import pricing_task

    monkeypatch.setenv(env, "1")
    monkeypatch.setattr(pricing_task, "fetch_openrouter_models", _forbidden)
    assert asyncio.run(pricing_task.sync_all_providers()) == {}

    async def loop():
        await asyncio.wait_for(pricing_task.start_price_sync_task(asyncio.Event()), timeout=5)

    asyncio.run(loop())


@pytest.mark.parametrize("env", ["TWICC_NO_USAGE_SYNC", "TWICC_OFFLINE"])
def test_usage_sync_loops_never_fetch(monkeypatch, env):
    from twicc.providers.claude_code import usage_task as claude_usage_task
    from twicc.providers.codex import usage_task as codex_usage_task

    monkeypatch.setenv(env, "1")
    for module in (claude_usage_task, codex_usage_task):
        monkeypatch.setattr(module, "fetch_and_save_usage", _forbidden_async)
        asyncio.run(asyncio.wait_for(module.start_usage_sync_task(), timeout=5))


@pytest.mark.parametrize("env", ["TWICC_NO_OPENROUTER", "TWICC_OFFLINE"])
def test_openrouter_key_reads_as_unset(monkeypatch, env):
    from twicc import openrouter_text
    from twicc.tts import config as tts_config
    from twicc.tts import openrouter as tts_openrouter

    monkeypatch.setattr(openrouter_text, "get_env_secret", lambda key: "sk-test")
    monkeypatch.setattr(tts_config, "get_env_secret", lambda key: "sk-test")
    assert openrouter_text.openrouter_key_set() is True
    assert tts_config.openrouter_api_key() == "sk-test"

    monkeypatch.setenv(env, "1")
    monkeypatch.setattr(openrouter_text, "_make_client", _forbidden)
    monkeypatch.setattr(tts_openrouter, "_make_client", _forbidden)
    monkeypatch.setattr(tts_openrouter, "_models_cache", None)
    assert openrouter_text.openrouter_key_set() is False
    assert tts_config.openrouter_api_key() is None
    with pytest.raises(openrouter_text.OpenRouterTextError) as error:
        asyncio.run(openrouter_text.complete_openrouter_text(openrouter_text.OPENROUTER_TEXT_MODEL, "hi", timeout_seconds=5))
    assert error.value.reason == "no_key"
    assert asyncio.run(tts_openrouter.fetch_speech_models()) == []


@pytest.mark.parametrize("env", ["TWICC_NO_CODEX_RUNTIME_DOWNLOAD", "TWICC_OFFLINE"])
def test_codex_runtime_is_not_downloaded(monkeypatch, tmp_path, env):
    from twicc.providers.codex import runtime

    monkeypatch.setattr(runtime, "_cache_root", lambda: tmp_path)
    monkeypatch.setattr(runtime, "_download", _forbidden)
    monkeypatch.setenv(env, "1")
    with pytest.raises(runtime.CodexRuntimeError, match="download is disabled"):
        runtime.ensure_codex_runtime_sync()


def test_offline_forces_telemetry_off_whatever_the_setting(tmp_path, monkeypatch):
    from twicc.telemetry import task

    path = tmp_path / "settings.json"
    monkeypatch.setattr(ss, "get_synced_settings_path", lambda: path)
    ss._cache.clear()
    ss.write_synced_settings({**ss.read_synced_settings(), "telemetryNoticeSeen": True, "telemetryEnabled": True})
    assert task.is_telemetry_active() is True
    monkeypatch.setenv("TWICC_OFFLINE", "1")
    assert task.is_telemetry_active() is False
    assert task.build_pending_payload() is None


# --- local changelog ---------------------------------------------------------------------


def _get_changelog(rf):
    from twicc.views import changelog

    return asyncio.run(changelog(rf.get("/api/changelog/")))


@override_settings(DEV_MODE=False)
def test_changelog_endpoint_hidden_while_github_fetch_is_on(rf):
    from django.http import Http404

    with pytest.raises(Http404):
        _get_changelog(rf)


@pytest.mark.parametrize("env", ["TWICC_NO_CHANGELOG_FETCH", "TWICC_OFFLINE"])
@override_settings(DEV_MODE=False)
def test_changelog_endpoint_serves_local_copy_when_fetch_is_off(rf, monkeypatch, env):
    monkeypatch.setenv(env, "1")
    response = _get_changelog(rf)
    assert response.status_code == 200
    assert b"## [" in response.content


def test_changelog_falls_back_to_the_copy_shipped_with_the_build(monkeypatch, tmp_path, settings):
    from twicc import views

    package = tmp_path / "src" / "twicc"
    shipped = package / "static" / "frontend" / "CHANGELOG.md"
    shipped.parent.mkdir(parents=True)
    shipped.write_text("## [1.0.0] - 2026-01-01\n")
    settings.PACKAGE_DIR = package
    assert views._local_changelog_path() == shipped
    (tmp_path / "CHANGELOG.md").write_text("root")
    assert views._local_changelog_path() == tmp_path / "CHANGELOG.md"


# --- CLI ---------------------------------------------------------------------------------


def test_cli_offline_flag_sets_the_master_switch(monkeypatch):
    from twicc import cli

    monkeypatch.delenv("TWICC_OFFLINE", raising=False)
    cli._apply_offline_flag(False)
    assert not is_offline()
    cli._apply_offline_flag(True)
    assert is_offline()
