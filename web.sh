#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ -x "$HOME/.bun-1.4.2/bin/bun" ]]; then
  BUN_BIN="$HOME/.bun-1.4.2/bin/bun"
elif command -v bun >/dev/null 2>&1; then
  BUN_BIN="$(command -v bun)"
else
  echo "Error: Bun was not found. Install Bun >= 1.4.2 or ~/.bun-1.4.2/bin/bun." >&2
  exit 1
fi

PORT="${EXACT_PORT:-8765}"
args=("$@")
for ((i = 0; i < ${#args[@]}; i++)); do
  case "${args[$i]}" in
  --port=*)
    PORT="${args[$i]#--port=}"
    ;;
  --port)
    if ((i + 1 < ${#args[@]})); then
      PORT="${args[$((i + 1))]}"
    fi
    ;;
  esac
done

stop_pid() {
  local pid="$1"
  [[ -n "$pid" && "$pid" =~ ^[0-9]+$ ]] || return 0
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      kill -0 "$pid" 2>/dev/null || return 0
      sleep 0.2
    done
    kill -9 "$pid" 2>/dev/null || true
  fi
}

LOOP_FILE="$ROOT_DIR/.exact/web-js-loop.json"
if [[ -f "$LOOP_FILE" ]]; then
  LOOP_PID="$(sed -n 's/.*"pid":[[:space:]]*\([0-9][0-9]*\).*/\1/p' "$LOOP_FILE" | head -n 1 || true)"
  if [[ -n "$LOOP_PID" ]]; then
    stop_pid "$LOOP_PID"
  fi
  rm -f "$LOOP_FILE" "$LOOP_FILE.lock"
fi

if command -v lsof >/dev/null 2>&1; then
  PORT_PIDS="$(lsof -tiTCP:"$PORT" -sTCP:LISTEN 2>/dev/null || true)"
  for pid in $PORT_PIDS; do
    stop_pid "$pid"
  done
elif command -v fuser >/dev/null 2>&1; then
  fuser -k "${PORT}/tcp" >/dev/null 2>&1 || true
  sleep 0.3
fi

cd "$ROOT_DIR"
exec "$BUN_BIN" exact.mjs web "$@"
