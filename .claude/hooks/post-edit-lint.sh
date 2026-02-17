#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# ESLint for JS/TS files
if [[ "$FILE_PATH" == *.js || "$FILE_PATH" == *.ts || "$FILE_PATH" == *.jsx || "$FILE_PATH" == *.tsx ]]; then
  OUTPUT=$(npx eslint "$FILE_PATH" --fix 2>&1)
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
