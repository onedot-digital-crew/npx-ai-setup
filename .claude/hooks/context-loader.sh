#!/bin/bash
# context-loader.sh — SessionStart hook
# Loads L0 abstracts from the most relevant .agents/context/ files.
# Parses YAML frontmatter (abstract + sections) for token-efficient context injection.
# Priority order keeps SessionStart short and stable as context grows.
# Target: <320 tokens total.

CONTEXT_DIR="${CLAUDE_PROJECT_DIR:-.}/.agents/context"
MAX_FILES=4
MAX_SECTIONS_PER_FILE=3

output=""
processed=""
processed_count=0

append_context_file() {
  local filepath="$1"
  local filename
  local first_line
  local abstract=""
  local sections=""
  local in_sections=0
  local section_count=0
  local line_num=0
  local entry

  [ -f "$filepath" ] || return 0
  [ "$processed_count" -lt "$MAX_FILES" ] || return 0

  filename=$(basename "$filepath")
  case " $processed " in
    *" $filename "*) return 0 ;;
  esac

  first_line=$(head -1 "$filepath")
  [ "$first_line" = "---" ] || return 0

  while IFS= read -r line; do
    line_num=$((line_num + 1))
    [ "$line_num" -eq 1 ] && continue

    if [ "$line" = "---" ]; then
      break
    fi

    case "$line" in
      abstract:*)
        abstract="${line#abstract: }"
        abstract="${abstract#\"}"
        abstract="${abstract%\"}"
        ;;
      sections:)
        in_sections=1
        ;;
      "  - "*)
        if [ "$in_sections" -eq 1 ] && [ "$section_count" -lt "$MAX_SECTIONS_PER_FILE" ]; then
          entry="${line#  - }"
          entry="${entry#\"}"
          entry="${entry%\"}"
          sections="${sections:+$sections\n}  - $entry"
          section_count=$((section_count + 1))
        fi
        ;;
      *)
        in_sections=0
        ;;
    esac
  done < "$filepath"

  [ -n "$abstract" ] || return 0

  output="${output:+$output\n\n}=== $filename ==\n$abstract"
  [ -n "$sections" ] && output="$output\n$sections"
  processed="${processed}${filename} "
  processed_count=$((processed_count + 1))
}

append_context_file "$CONTEXT_DIR/STACK.md"
append_context_file "$CONTEXT_DIR/ARCHITECTURE.md"
append_context_file "$CONTEXT_DIR/CONVENTIONS.md"
append_context_file "$CONTEXT_DIR/CONCEPT.md"

for filepath in $(find "$CONTEXT_DIR" -maxdepth 1 -name "*.md" 2>/dev/null | sort); do
  append_context_file "$filepath"
done

if [ -n "$output" ] && command -v jq >/dev/null 2>&1; then
  printf '%b' "$output" | jq -Rs '{"additionalContext": .}'
fi
