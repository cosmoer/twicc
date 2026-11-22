#!/usr/bin/env bash
# Install (or upgrade) TwiCC from this offline bundle. No network needed.
#
#   ./install.sh [--prefix DIR] [--python PATH] [--bundled-python] [--data-dir DIR]
#                [--no-codex-runtime] [--no-env] [--systemd]
#
#   --prefix DIR        virtualenv to create/update        (default: ~/.twicc-venv)
#   --python PATH       Python 3.13+ interpreter to use    (default: python3.13 / python3
#                       when >= 3.13, else the bundled one)
#   --bundled-python    always use the bundled portable CPython (extracted to DIR-python)
#   --data-dir DIR      TwiCC data dir for the .env        (default: $TWICC_DATA_DIR or ~/.twicc)
#   --no-codex-runtime  do not pre-install the Codex CLI runtime into ~/.cache/twicc
#   --no-env            do not touch <data dir>/.env (by default TWICC_OFFLINE=1 is added
#                       when the file has no TWICC_OFFLINE line)
#   --systemd           install a systemd *user* service (~/.config/systemd/user/twicc.service)
#
# Idempotent: re-running reuses the venv and (re)installs exactly this bundle's version.
set -euo pipefail

BUNDLE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${HOME}/.twicc-venv"
PYTHON=""
FORCE_BUNDLED=0
DATA_DIR="${TWICC_DATA_DIR:-$HOME/.twicc}"
CODEX_RUNTIME=1
WRITE_ENV=1
SYSTEMD=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --prefix) PREFIX="$2"; shift 2 ;;
        --python) PYTHON="$2"; shift 2 ;;
        --bundled-python) FORCE_BUNDLED=1; shift ;;
        --data-dir) DATA_DIR="$2"; shift 2 ;;
        --no-codex-runtime) CODEX_RUNTIME=0; shift ;;
        --no-env) WRITE_ENV=0; shift ;;
        --systemd) SYSTEMD=1; shift ;;
        -h|--help) sed -n '2,19p' "$0"; exit 0 ;;
        *) echo "Unknown option: $1 (see --help)" >&2; exit 2 ;;
    esac
done

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

[[ "$(uname -s)" == Linux && "$(uname -m)" == x86_64 ]] || die "this bundle is for Linux x86_64 only"
VERSION="$(cat "$BUNDLE/VERSION")"
PREFIX="${PREFIX%/}"
mkdir -p "$(dirname "$PREFIX")"
PREFIX="$(cd "$(dirname "$PREFIX")" && pwd)/$(basename "$PREFIX")"

if command -v ldd >/dev/null 2>&1; then
    glibc="$(ldd --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+$' || true)"
    [[ -n "$glibc" ]] && log "glibc $glibc detected (see BUNDLE-INFO.txt for the minimum)"
fi

py_ok() { "$1" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 13) else 1)' >/dev/null 2>&1; }

# --- 1. Python ---------------------------------------------------------------------------
if [[ -x "$PREFIX/bin/python" ]] && py_ok "$PREFIX/bin/python"; then
    log "Reusing the virtualenv $PREFIX"
else
    if [[ -n "$PYTHON" ]]; then
        py_ok "$PYTHON" || die "$PYTHON is not Python >= 3.13"
    elif [[ $FORCE_BUNDLED == 0 ]] && command -v python3.13 >/dev/null 2>&1 && py_ok python3.13; then
        PYTHON="$(command -v python3.13)"
    elif [[ $FORCE_BUNDLED == 0 ]] && command -v python3 >/dev/null 2>&1 && py_ok python3; then
        PYTHON="$(command -v python3)"
    fi
    if [[ -z "$PYTHON" ]] || ! "$PYTHON" -c 'import venv, ensurepip' >/dev/null 2>&1; then
        tarball="$(ls "$BUNDLE"/python/cpython-3.13*-x86_64-unknown-linux-gnu-install_only*.tar.gz 2>/dev/null | head -1 || true)"
        [[ -n "$tarball" ]] || die "no usable Python >= 3.13 (with venv/ensurepip) and no bundled Python; pass --python"
        PY_HOME="$PREFIX-python"
        if [[ ! -x "$PY_HOME/bin/python3" ]]; then
            log "Extracting the bundled Python to $PY_HOME"
            mkdir -p "$PY_HOME"
            tar -xzf "$tarball" -C "$PY_HOME" --strip-components=1
        fi
        PYTHON="$PY_HOME/bin/python3"
    fi
    log "Creating the virtualenv $PREFIX with $PYTHON ($("$PYTHON" --version))"
    "$PYTHON" -m venv "$PREFIX"
fi

# --- 2. TwiCC and its dependencies, from the bundled wheels only --------------------------
log "Installing twicc $VERSION (offline: --no-index)"
"$PREFIX/bin/python" -m pip install --quiet --disable-pip-version-check --no-index \
    --find-links "$BUNDLE/wheels" --upgrade "twicc==$VERSION"
"$PREFIX/bin/twicc" --version

# --- 3. Codex CLI runtime (otherwise downloaded from GitHub at first launch) -------------
if [[ $CODEX_RUNTIME == 1 ]]; then
    codex_whl="$(ls "$BUNDLE"/codex-runtime/openai_codex_cli_bin-*manylinux*x86_64.whl 2>/dev/null | head -1 || true)"
    if [[ -n "$codex_whl" ]]; then
        log "Installing the Codex runtime into the TwiCC cache"
        # TwiCC's own provisioning (sha256 check, extraction, .ready marker), fed with the
        # local wheel instead of a download. TWICC_OFFLINE must not block this local step.
        env -u TWICC_OFFLINE -u TWICC_NO_CODEX_RUNTIME_DOWNLOAD CODEX_WHEEL="$codex_whl" \
            "$PREFIX/bin/python" - <<'PY'
import os, shutil
from twicc.providers.codex import runtime
if runtime.is_runtime_ready():
    print(f"    already present: {runtime.codex_binary_path()}")
else:
    runtime._download = lambda url, dest: shutil.copyfile(os.environ["CODEX_WHEEL"], dest)
    runtime.ensure_codex_runtime_sync()
    print(f"    ready: {runtime.codex_binary_path()}")
PY
    fi
fi

# --- 4. <data dir>/.env with TWICC_OFFLINE=1 ---------------------------------------------
if [[ $WRITE_ENV == 1 ]]; then
    mkdir -p "$DATA_DIR"
    env_file="$DATA_DIR/.env"
    if [[ -f "$env_file" ]] && grep -qE '^[[:space:]]*(export[[:space:]]+)?TWICC_OFFLINE=' "$env_file"; then
        log "$env_file already sets TWICC_OFFLINE, left unchanged"
    else
        log "Adding TWICC_OFFLINE=1 to $env_file"
        { [[ -s "$env_file" && -n "$(tail -c1 "$env_file")" ]] && echo; echo "TWICC_OFFLINE=1"; } >> "$env_file"
        chmod 600 "$env_file"
    fi
fi

# --- 5. Optional systemd user service ---------------------------------------------------
if [[ $SYSTEMD == 1 ]]; then
    unit_dir="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
    mkdir -p "$unit_dir"
    sed -e "s#@TWICC_BIN@#$PREFIX/bin/twicc#g" -e "s#@DATA_DIR@#$DATA_DIR#g" \
        "$BUNDLE/twicc.service.example" > "$unit_dir/twicc.service"
    log "Installed $unit_dir/twicc.service"
    if command -v systemctl >/dev/null 2>&1 && systemctl --user daemon-reload 2>/dev/null; then
        echo "    Start it:            systemctl --user enable --now twicc"
        echo "    Keep it after logout: sudo loginctl enable-linger $USER"
    else
        echo "    systemctl --user is not available in this session; run 'systemctl --user daemon-reload' later."
    fi
fi

cat <<MSG

TwiCC $VERSION is installed in $PREFIX.
  Start:   $PREFIX/bin/twicc --offline
  Open:    http://localhost:${TWICC_PORT:-3500}
  Tip:     ln -s $PREFIX/bin/twicc ~/.local/bin/twicc   (to type just 'twicc')
MSG
