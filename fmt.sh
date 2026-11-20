#!/usr/bin/env bash
set -e

for arg in "$@"; do
  case "$arg" in
  -a | --all)
    ;;
  -h | --help)
    echo "Usage: $0"
    echo "  Format TypeScript/JavaScript/CSS, Markdown (except AGENTS.md/CLAUDE.md), and shell scripts in the repository"
    exit 0
    ;;
  *)
    echo "Unknown option: $arg" >&2
    echo "Usage: $0" >&2
    exit 1
    ;;
  esac
done

run_prettier() {
  local files=()
  while IFS= read -r -d '' file; do
    files+=("$file")
  done < <(
    find . \
      \( -path "*/.*" -o -path "*/node_modules" -o -path "./dist" -o -path "./dev-dist" -o -path "./target" \) -prune -o \
      \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.mjs" -o -name "*.cjs" -o -name "*.css" -o -name "*.md" \) \
      ! -path "./AGENTS.md" \
      ! -path "./CLAUDE.md" \
      ! -path "./exact.mjs" \
      ! -path "./app.contract.d.ts" \
      -type f -print0
  )

  if [ ${#files[@]} -eq 0 ]; then
    echo "ℹ️  No matching files found for Prettier."
    return 0
  fi

  "$@" --write "${files[@]}"
}

# 1. Format TypeScript, JavaScript, CSS, and Markdown files with Prettier
if command -v prettier >/dev/null 2>&1; then
  PRETTIER_CMD=(prettier)
elif [ -x "./node_modules/.bin/prettier" ]; then
  PRETTIER_CMD=(./node_modules/.bin/prettier)
elif command -v npx >/dev/null 2>&1; then
  PRETTIER_CMD=(npx --yes prettier)
else
  PRETTIER_CMD=()
fi

if [ ${#PRETTIER_CMD[@]} -eq 0 ]; then
  echo "⚠️  Neither 'prettier' nor 'npx' found. Skipping TypeScript/JavaScript/CSS/Markdown formatting."
else
  echo "✨ Formatting repository files with ${PRETTIER_CMD[*]} (excluding generated files)..."
  run_prettier "${PRETTIER_CMD[@]}"
fi

# 2. Format Shell scripts (prefers native shfmt from brew, falls back to uvx)
if command -v shfmt >/dev/null 2>&1; then
  echo "📜 Formatting shell scripts (shfmt)..."
  shopt -s globstar 2>/dev/null || true
  if shopt -q globstar 2>/dev/null; then
    shfmt -i 2 -w **/*.sh
  else
    find . -name "*.sh" -not -path "*/.*" -not -path "*/node_modules/*" -exec shfmt -i 2 -w {} +
  fi
elif command -v uvx >/dev/null 2>&1; then
  echo "📜 Formatting shell scripts (uvx shfmt-py)..."
  shopt -s globstar 2>/dev/null || true
  if shopt -q globstar 2>/dev/null; then
    uvx --from shfmt-py shfmt -i 2 -w **/*.sh
  else
    find . -name "*.sh" -not -path "*/.*" -not -path "*/node_modules/*" -exec uvx --from shfmt-py shfmt -i 2 -w {} +
  fi
else
  echo "⚠️  Neither 'shfmt' nor 'uvx' found. Install with: brew install shfmt"
fi

echo "✅ Done!"
