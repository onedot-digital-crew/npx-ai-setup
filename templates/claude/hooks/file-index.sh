#!/bin/bash
# file-index.sh — SessionStart hook
# Generates a compact file index for common project structures.
# Helps agents locate files without Glob/Grep scanning.
# Target: <200 tokens, always fresh.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
output=""

# Helper: list files in a dir, basenames only, comma-separated
# Excludes auto-generated files (gp-* GemPages sections, numeric IDs)
list_files() {
  local dir="$1" ext="$2"
  find "$dir" -maxdepth 1 -name "*.$ext" -type f 2>/dev/null \
    | xargs -I{} basename {} \
    | grep -v '^gp-' \
    | sort \
    | tr '\n' ',' \
    | sed 's/,$//'
}

# Shopify theme detection
if [ -d "$PROJECT_DIR/sections" ] && [ -d "$PROJECT_DIR/snippets" ]; then
  sections=$(list_files "$PROJECT_DIR/sections" "liquid")
  blocks=$(list_files "$PROJECT_DIR/blocks" "liquid")
  snippet_count=$(find "$PROJECT_DIR/snippets" -maxdepth 1 -name "*.liquid" -type f 2>/dev/null | wc -l | tr -d ' ')
  [ -n "$sections" ] && output="${output}sections/: $sections\n"
  [ "$snippet_count" -gt 0 ] && output="${output}snippets/: $snippet_count files (Glob snippets/*.liquid)\n"
  [ -n "$blocks" ]   && output="${output}blocks/: $blocks\n"
fi

# CSS components
for css_dir in \
  "$PROJECT_DIR/src/css/components" \
  "$PROJECT_DIR/src/entrypoints/components" \
  "$PROJECT_DIR/src/styles/components"; do
  [ -d "$css_dir" ] || continue
  files=$(list_files "$css_dir" "css")
  rel="${css_dir#$PROJECT_DIR/}"
  [ -n "$files" ] && output="${output}${rel}/: $files\n"
done

# JS components
for js_dir in \
  "$PROJECT_DIR/src/js/components" \
  "$PROJECT_DIR/src/components"; do
  [ -d "$js_dir" ] || continue
  files=$(list_files "$js_dir" "js")
  rel="${js_dir#$PROJECT_DIR/}"
  [ -n "$files" ] && output="${output}${rel}/: $files\n"
done

if [ -n "$output" ]; then
  label="=== File Index =="
  escaped=$(printf '%s' "$label\n$output" | sed 's/\\/\\\\/g; s/"/\\"/g; s/	/\\t/g')
  printf '{"additionalContext": "%s"}\n' "$escaped"
fi
