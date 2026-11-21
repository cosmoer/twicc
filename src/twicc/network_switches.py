"""Switches for every outbound network call TwiCC makes on its own.

TwiCC talks to a few third-party services in the background (PyPI, GitHub,
the telemetry collector, the providers' status pages, OpenRouter, …). Each
feature can be turned off with its own ``TWICC_NO_<FEATURE>=1`` environment
variable (in the shell or in the data dir's ``.env``), and ``TWICC_OFFLINE=1``
(or ``twicc --offline``) turns all of them off at once. Everything is on by
default, so an unconfigured instance behaves exactly as before.

Values are read from ``os.environ`` at call time (the data dir's ``.env`` is
loaded into it at startup), so this module stays Django-free and usable from
the Codex runtime provisioning too. See ``docs/offline-mode.md``.
"""

from __future__ import annotations

import os

_TRUE = ("1", "true", "yes")

OFFLINE_ENV = "TWICC_OFFLINE"

# feature -> its own opt-out variable (None: only TWICC_OFFLINE turns it off,
# because a softer opt-out already exists elsewhere — see "telemetry").
SWITCHES: dict[str, str | None] = {
    # PyPI JSON API polled every 15 min for a newer TwiCC (twicc.version_check_task).
    "version_check": "TWICC_NO_VERSION_CHECK",
    # CHANGELOG.md read from raw.githubusercontent.com by the "What's new" dialog;
    # when off, the frontend reads the copy shipped with the build instead.
    "changelog_fetch": "TWICC_NO_CHANGELOG_FETCH",
    # Anonymous telemetry POSTs. The user-facing opt-out is the synced
    # ``telemetryEnabled`` setting (initialized off by TWICC_NO_TELEMETRY);
    # TWICC_OFFLINE additionally forces it off whatever the setting says.
    "telemetry": None,
    # Claude / OpenAI Statuspage polling every 2 min (twicc.providers.statuspage_task).
    "status_page": "TWICC_NO_STATUS_PAGE",
    # OpenRouter public model catalogue fetched daily for model prices (twicc.pricing_task).
    "price_sync": "TWICC_NO_PRICE_SYNC",
    # Background quota polling of the Anthropic / ChatGPT usage endpoints (usage_task).
    "usage_sync": "TWICC_NO_USAGE_SYNC",
    # Every OpenRouter API call made with the user's key: summaries, titles, the
    # speech adaptation and text-to-speech. When off, the key is treated as unset.
    "openrouter": "TWICC_NO_OPENROUTER",
    # First-launch download of the Codex CLI runtime from GitHub Releases.
    "codex_runtime_download": "TWICC_NO_CODEX_RUNTIME_DOWNLOAD",
}


def _flag(name: str) -> bool:
    return os.environ.get(name, "").strip().lower() in _TRUE


def is_offline() -> bool:
    """Whether the master switch ``TWICC_OFFLINE`` is set."""
    return _flag(OFFLINE_ENV)


def network_feature_enabled(feature: str) -> bool:
    """Whether the outbound *feature* (a :data:`SWITCHES` key) may run."""
    env = SWITCHES[feature]  # KeyError on a typo, on purpose
    if is_offline():
        return False
    return not (env and _flag(env))


def network_switches_state() -> dict[str, bool]:
    """``{feature: enabled}`` for every switch (bootstrap payload, logs)."""
    return {feature: network_feature_enabled(feature) for feature in SWITCHES}


def apply_offline_environment() -> None:
    """In offline mode, ask the spawned Claude Code CLI to skip its own
    non-essential traffic (telemetry, error reporting, auto-update checks).

    ``setdefault``: an explicit value in the environment always wins.
    """
    if is_offline():
        os.environ.setdefault("CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC", "1")
