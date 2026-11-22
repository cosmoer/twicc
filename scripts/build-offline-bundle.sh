#!/usr/bin/env bash
# Build a self-contained offline install bundle of TwiCC for Linux x86_64.
#
#   scripts/build-offline-bundle.sh [--local-version offline1] [--out DIR] [--no-python]
#
# Needs network, uv, npm and git on the BUILD machine. The result installs on an
# air-gapped Linux x86_64 machine (glibc, see BUNDLE-INFO.txt) with
# scripts/offline-bundle/install.sh — no network, no npm, Python 3.13 optional.
#
# Contents: the TwiCC wheel (frontend built in, PEP 440 local version
# <version>+<local>, built from the committed HEAD), every runtime dependency
# wheel pinned by uv.lock (CPython 3.13, manylinux x86_64), the Codex CLI runtime
# wheel TwiCC would otherwise download from GitHub at first launch, and
# optionally a portable CPython 3.13 (python-build-standalone).
set -euo pipefail

LOCAL_VERSION="offline1"
OUT_DIR=""
WITH_PYTHON=1
PBS_TAG="${PBS_TAG:-20261110}"        # python-build-standalone release
PBS_PYTHON="${PBS_PYTHON:-3.13.18}"
# Oldest first: pip prefers the earlier platform, so the bundle needs the
# oldest glibc each package allows.
PLATFORMS=(manylinux2014_x86_64 manylinux_2_17_x86_64 manylinux_2_24_x86_64 manylinux_2_26_x86_64
           manylinux_2_27_x86_64 manylinux_2_28_x86_64 manylinux_2_31_x86_64 manylinux_2_34_x86_64)

while [[ $# -gt 0 ]]; do
    case "$1" in
        --local-version) LOCAL_VERSION="$2"; shift 2 ;;
        --out) OUT_DIR="$2"; shift 2 ;;
        --no-python) WITH_PYTHON=0; shift ;;
        -h|--help) sed -n '2,16p' "$0"; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 2 ;;
    esac
done

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${OUT_DIR:-$REPO/../dist-offline}"
mkdir -p "$OUT_DIR"
OUT_DIR="$(cd "$OUT_DIR" && pwd)"

BASE_VERSION="$(sed -n 's/^version = "\(.*\)"/\1/p' "$REPO/pyproject.toml" | head -1)"
VERSION="$BASE_VERSION${LOCAL_VERSION:++$LOCAL_VERSION}"
NAME="twicc-offline-$BASE_VERSION-linux-x86_64"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
STAGE="$WORK/$NAME"
mkdir -p "$STAGE/wheels" "$STAGE/codex-runtime"

echo "==> TwiCC $VERSION from $(git -C "$REPO" rev-parse --short HEAD)"
if [[ -n "$(git -C "$REPO" status --porcelain --untracked-files=no)" ]]; then
    echo "    warning: uncommitted changes are NOT included (the bundle is built from HEAD)" >&2
fi

# 1. The TwiCC wheel, from a clean export of HEAD (hatch_build.py runs npm ci + build).
echo "==> Building the wheel"
git -C "$REPO" archive --format=tar HEAD | tar -x -C "$WORK" --one-top-level=src-tree
sed -i "s/^version = \"$BASE_VERSION\"/version = \"$VERSION\"/" "$WORK/src-tree/pyproject.toml"
(cd "$WORK/src-tree" && uv build --wheel --out-dir "$STAGE/wheels")

# 2. Runtime dependencies pinned by uv.lock (no dev group, no project itself).
echo "==> Downloading dependency wheels"
(cd "$REPO" && uv export --frozen --no-dev --no-hashes --no-emit-project --no-header \
    --format requirements-txt) > "$STAGE/requirements.txt"
platform_args=()
for p in "${PLATFORMS[@]}"; do platform_args+=(--platform "$p"); done
# Packages uv.lock knows only as an sdist (no wheel on PyPI, e.g. http-ece): built
# here into wheels, accepted only if pure Python (py3-none-any), so they install anywhere.
python3 - "$REPO/uv.lock" "$STAGE/requirements.txt" "$WORK/sdist-only.txt" <<'PY'
import re, sys, tomllib
lock, reqs, out = sys.argv[1:]
sdist_only = {p["name"] for p in tomllib.load(open(lock, "rb"))["package"]
              if not p.get("wheels") and "registry" in p.get("source", {})}
binary, sdist = [], []
for line in open(reqs):
    m = re.match(r"([A-Za-z0-9_.-]+)==", line)
    if m:
        (sdist if re.sub(r"[-_.]+", "-", m.group(1).lower()) in sdist_only else binary).append(line)
open(reqs + ".binary", "w").writelines(binary)
open(out, "w").writelines(sdist)
PY
# pip evaluates markers against the build host (Linux), so darwin-only deps are skipped.
uvx --quiet --from pip pip download --disable-pip-version-check --no-deps \
    --only-binary=:all: --implementation cp --python-version 3.13 --abi cp313 --abi abi3 --abi none \
    "${platform_args[@]}" -r "$STAGE/requirements.txt.binary" -d "$STAGE/wheels"
rm "$STAGE/requirements.txt.binary"
if [[ -s "$WORK/sdist-only.txt" ]]; then
    echo "    building pure-Python wheels for sdist-only packages: $(cut -d' ' -f1 "$WORK/sdist-only.txt" | tr '\n' ' ')"
    uvx --quiet --python 3.13 --from pip pip wheel --disable-pip-version-check --no-deps \
        --no-binary=:all: -r "$WORK/sdist-only.txt" -w "$WORK/sdist-wheels"
    for whl in "$WORK"/sdist-wheels/*.whl; do
        [[ "$whl" == *-py3-none-any.whl || "$whl" == *-py2.py3-none-any.whl ]] \
            || { echo "not a pure-Python wheel: $whl" >&2; exit 1; }
        cp "$whl" "$STAGE/wheels/"
    done
fi

# 3. The Codex CLI runtime TwiCC downloads at first launch (same URL and sha256).
echo "==> Downloading the Codex runtime"
read -r CODEX_URL CODEX_SHA < <(cd "$REPO/src" && python3 - <<'PY'
import re, pathlib
src = pathlib.Path("twicc/providers/codex/runtime.py").read_text()
tag = re.search(r'CODEX_RELEASE_TAG = "([^"]+)"', src).group(1)
ver = re.search(r'CODEX_VERSION = "([^"]+)"', src).group(1)
name, sha = re.search(r'"manylinux_2_17_x86_64": \(\s*f"([^"]+)",\s*"([0-9a-f]{64})"', src).groups()
print(f"https://github.com/openai/codex/releases/download/{tag}/{name.replace('{CODEX_VERSION}', ver)}", sha)
PY
)
curl -fL --retry 3 -o "$STAGE/codex-runtime/$(basename "$CODEX_URL")" "$CODEX_URL"
echo "$CODEX_SHA  $STAGE/codex-runtime/$(basename "$CODEX_URL")" | sha256sum -c -

# 4. Optional portable CPython 3.13.
if [[ $WITH_PYTHON == 1 ]]; then
    echo "==> Downloading python-build-standalone CPython $PBS_PYTHON"
    mkdir -p "$STAGE/python"
    PBS_FILE="cpython-$PBS_PYTHON+$PBS_TAG-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz"
    PBS_BASE="https://github.com/astral-sh/python-build-standalone/releases/download/$PBS_TAG"
    curl -fL --retry 3 -o "$STAGE/python/$PBS_FILE" "$PBS_BASE/$PBS_FILE"
    curl -fsL --retry 3 "$PBS_BASE/SHA256SUMS" | grep " $PBS_FILE\$" | sed "s#  #  $STAGE/python/#" | sha256sum -c -
fi

# 5. Installer, docs, metadata.
cp "$REPO/scripts/offline-bundle/install.sh" "$REPO/scripts/offline-bundle/README-OFFLINE.md" \
   "$REPO/scripts/offline-bundle/twicc.service.example" "$STAGE/"
chmod +x "$STAGE/install.sh"
echo "$VERSION" > "$STAGE/VERSION"

# glibc the bundle needs: per wheel the OLDEST manylinux tag it carries (any one
# suffices), then the highest of those across wheels.
max_glibc="$(python3 - "$STAGE/wheels" <<'PY'
import os, re, sys
legacy = {"manylinux1": (2, 5), "manylinux2010": (2, 12), "manylinux2014": (2, 17)}
need, who = (0, 0), "-"
for name in os.listdir(sys.argv[1]):
    tags = [legacy[t] if t in legacy else tuple(map(int, t.split("_")[1:3]))
            for t in re.findall(r"(manylinux1|manylinux2010|manylinux2014|manylinux_\d+_\d+)_x86_64", name)]
    if tags and min(tags) > need:
        need, who = min(tags), name.split("-")[0]
print(f"{need[0]}.{need[1]} ({who})")
PY
)"
claude_glibc="$(cd "$WORK" && unzip -o -q "$STAGE"/wheels/claude_agent_sdk-*.whl 'claude_agent_sdk/_bundled/claude' -d claude-x \
    && objdump -T claude-x/claude_agent_sdk/_bundled/claude | grep -oE 'GLIBC_[0-9.]+' | sort -V | tail -1 || true)"
{
    echo "TwiCC offline bundle"
    echo "version:        $VERSION"
    echo "commit:         $(git -C "$REPO" rev-parse HEAD)"
    echo "built:          $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "target:         Linux x86_64, glibc, CPython 3.13"
    echo "wheels need:    glibc >= $max_glibc"
    echo "claude binary:  needs ${claude_glibc:-unknown} (bundled in claude-agent-sdk)"
    echo "codex runtime:  static binaries (no glibc requirement)"
    echo "python:         $( [[ $WITH_PYTHON == 1 ]] && echo "python-build-standalone $PBS_PYTHON ($PBS_TAG), glibc 2.17+" || echo "not bundled" )"
    echo "wheels:         $(ls "$STAGE/wheels" | wc -l)"
} > "$STAGE/BUNDLE-INFO.txt"
(cd "$STAGE" && find . -type f ! -name SHA256SUMS -print0 | sort -z | xargs -0 sha256sum > SHA256SUMS)

echo "==> Packing"
tar -C "$WORK" -czf "$OUT_DIR/$NAME.tar.gz" "$NAME"
(cd "$OUT_DIR" && sha256sum "$NAME.tar.gz" > "$NAME.tar.gz.sha256")
cat "$STAGE/BUNDLE-INFO.txt"
ls -l "$OUT_DIR/$NAME.tar.gz"
cat "$OUT_DIR/$NAME.tar.gz.sha256"
