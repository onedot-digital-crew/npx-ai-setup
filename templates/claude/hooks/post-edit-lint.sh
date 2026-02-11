#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ "$FILE_PATH" == *.js || "$FILE_PATH" == *.ts ]]; then
  OUTPUT=$(npx eslint "$FILE_PATH" --fix 2>&1)
  if [ $? -ne 0 ]; then
    echo "Lint failed:" && echo "$OUTPUT" | head -20
    exit 1
  fi
fi

exit 0
