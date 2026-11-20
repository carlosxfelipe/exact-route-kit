#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ -z "${ANDROID_HOME:-}" && -d "$HOME/Android/Sdk" ]]; then
  export ANDROID_HOME="$HOME/Android/Sdk"
fi

if [[ -z "${ANDROID_SDK_ROOT:-}" && -n "${ANDROID_HOME:-}" ]]; then
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
fi

if [[ -x "$HOME/.bun-1.4.2/bin/bun" ]]; then
  BUN_BIN="$HOME/.bun-1.4.2/bin/bun"
elif command -v bun >/dev/null 2>&1; then
  BUN_BIN="$(command -v bun)"
else
  echo "Error: Bun was not found. Install Bun >= 1.4.2 or ~/.bun-1.4.2/bin/bun." >&2
  exit 1
fi

cd "$ROOT_DIR"
EXACT_UPDATE_TRUST="${EXACT_UPDATE_TRUST:-production}" "$BUN_BIN" exact.mjs android --release --no-install "$@"
