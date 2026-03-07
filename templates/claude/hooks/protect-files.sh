#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED=(".env" "package-lock.json" "pnpm-lock.yaml" "yarn.lock" "bun.lockb" "composer.lock" ".git/")

for pattern in "${PROTECTED[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH is protected ('$pattern')" >&2
    exit 2
  fi
done

# Block direct edits to assets/ in Vite-based projects (build output)
if [[ "$FILE_PATH" == */assets/* ]]; then
  for cfg in vite.config.js vite.config.ts vite.config.mjs vite.config.mts; do
    if [ -f "$cfg" ]; then
      echo "Blocked: $FILE_PATH is in assets/ (build output — edit src/ instead)" >&2
      exit 2
    fi
  done
fi

exit 0
