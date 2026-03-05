#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

# Ignore events without a concrete file (or deleted/moved files).
[ -n "$FILE_PATH" ] || exit 0
[ -f "$FILE_PATH" ] || exit 0

# Optional project formatter script.
# Try file-scoped format first; on failure, continue with per-file fallback below.
if [ -f "package.json" ] && jq -e '.scripts.format' package.json >/dev/null 2>&1; then
  if command -v bun >/dev/null 2>&1 && bun run format -- "$FILE_PATH" >/dev/null 2>&1; then
    exit 0
  fi
  if command -v npm >/dev/null 2>&1 && npm run -s format -- "$FILE_PATH" >/dev/null 2>&1; then
    exit 0
  fi
fi

# ESLint for JS/TS files
if [[ "$FILE_PATH" == *.js || "$FILE_PATH" == *.ts || "$FILE_PATH" == *.jsx || "$FILE_PATH" == *.tsx ]]; then
  if [ -x "node_modules/.bin/eslint" ]; then
    OUTPUT=$(./node_modules/.bin/eslint "$FILE_PATH" --fix 2>&1)
  else
    OUTPUT=$(npx eslint "$FILE_PATH" --fix 2>&1)
  fi
  if [ $? -ne 0 ]; then
    echo "Lint failed:" && echo "$OUTPUT" | head -20
    exit 1
  fi
fi

# Prettier for other supported files (css, html, json, md, yaml, vue, svelte)
if [[ "$FILE_PATH" == *.css || "$FILE_PATH" == *.html || "$FILE_PATH" == *.json || "$FILE_PATH" == *.md || "$FILE_PATH" == *.yaml || "$FILE_PATH" == *.yml || "$FILE_PATH" == *.vue || "$FILE_PATH" == *.svelte ]]; then
  if [ -x "node_modules/.bin/prettier" ]; then
    ./node_modules/.bin/prettier --write "$FILE_PATH" 2>/dev/null
  fi
fi

exit 0
