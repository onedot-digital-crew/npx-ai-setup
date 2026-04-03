#!/usr/bin/env bash
# tdd-checker.sh — PostToolUse hook
# Advisory only: warns when source files are edited without nearby test files.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)
[ -n "$FILE_PATH" ] || exit 0

FILE_PATH="${FILE_PATH#./}"

case "$FILE_PATH" in
  *.md|*.json|*.yaml|*.yml|*.toml|*.sh|*.css|*.scss|*.less|*.svg)
    exit 0
    ;;
  node_modules/*|*/node_modules/*|dist/*|*/dist/*|build/*|*/build/*|coverage/*|*/coverage/*|.next/*|*/.next/*|.nuxt/*|*/.nuxt/*|.output/*|*/.output/*|storybook-static/*|*/storybook-static/*|vendor/*|*/vendor/*)
    exit 0
    ;;
  *.test.*|*.spec.*|*/__tests__/*|*/tests/*|*/test_*.py|*_test.go)
    exit 0
    ;;
esac

EXT="${FILE_PATH##*.}"
BASE_NAME=$(basename "$FILE_PATH")
NAME="${BASE_NAME%.*}"
DIR_NAME=$(dirname "$FILE_PATH")
[ "$DIR_NAME" = "." ] && DIR_NAME=""

case "$EXT" in
  py|js|jsx|ts|tsx|go) ;;
  *) exit 0 ;;
esac

has_match() {
  local pattern
  for pattern in "$@"; do
    compgen -G "$pattern" >/dev/null 2>&1 && return 0
  done
  return 1
}

if [ "$EXT" = "py" ]; then
  has_match \
    "${DIR_NAME:+$DIR_NAME/}test_${NAME}.py" \
    "${DIR_NAME:+$DIR_NAME/}tests/test_${NAME}.py" \
    "tests/test_${NAME}.py" \
    "tests/**/test_${NAME}.py" \
    || MISSING=1
elif [ "$EXT" = "go" ]; then
  has_match "${DIR_NAME:+$DIR_NAME/}${NAME}_test.go" "tests/${NAME}_test.go" || MISSING=1
else
  has_match \
    "${DIR_NAME:+$DIR_NAME/}${NAME}.test.*" \
    "${DIR_NAME:+$DIR_NAME/}${NAME}.spec.*" \
    "${DIR_NAME:+$DIR_NAME/}__tests__/${NAME}.test.*" \
    "${DIR_NAME:+$DIR_NAME/}__tests__/${NAME}.spec.*" \
    "tests/${NAME}.test.*" \
    "tests/${NAME}.spec.*" \
    || MISSING=1
fi

[ "${MISSING:-0}" -eq 1 ] || exit 0

MESSAGE="TDD warning: edited '${FILE_PATH}' but no nearby matching test file was found. Add or update a test before considering the change complete."
jq -n --arg msg "$MESSAGE" '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":$msg}}'

exit 0
