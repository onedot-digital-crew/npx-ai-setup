#!/bin/bash
# file-index.sh — SessionStart hook
# Generates a compact file index for common project structures.
# Helps agents locate files without broad Glob/Grep scanning.
# Target: <220 tokens, always fresh.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
output=""

# Helper: list files in a dir, basenames only, comma-separated.
list_files() {
  local dir="$1"
  local mode="$2"

  [ -d "$dir" ] || return 0

  case "$mode" in
    liquid)
      find "$dir" -maxdepth 1 -type f -name "*.liquid" 2>/dev/null
      ;;
    css)
      find "$dir" -maxdepth 1 -type f -name "*.css" 2>/dev/null
      ;;
    js)
      find "$dir" -maxdepth 1 -type f \( -name "*.js" -o -name "*.ts" -o -name "*.tsx" \) 2>/dev/null
      ;;
    sh)
      find "$dir" -maxdepth 1 -type f -name "*.sh" 2>/dev/null
      ;;
    md)
      find "$dir" -maxdepth 1 -type f -name "*.md" 2>/dev/null
      ;;
    *)
      find "$dir" -maxdepth 1 -type f 2>/dev/null
      ;;
  esac \
    | xargs -I{} basename "{}" \
    | grep -v '^gp-' \
    | sort \
    | head -n 6 \
    | tr '\n' ',' \
    | sed 's/,$//'
}

append_line() {
  local line="$1"
  [ -n "$line" ] || return 0
  output="${output}${line}\n"
}

dir_file_count() {
  local dir="$1"

  [ -d "$dir" ] || {
    echo "0"
    return 0
  }

  find "$dir" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' '
}

# Shopify theme detection
if [ -d "$PROJECT_DIR/sections" ] && [ -d "$PROJECT_DIR/snippets" ]; then
  sections=$(list_files "$PROJECT_DIR/sections" "liquid")
  blocks=$(list_files "$PROJECT_DIR/blocks" "liquid")
  snippet_count=$(find "$PROJECT_DIR/snippets" -maxdepth 1 -name "*.liquid" -type f 2>/dev/null | wc -l | tr -d ' ')
  [ -n "$sections" ] && append_line "sections/: $sections"
  [ "$snippet_count" -gt 0 ] && append_line "snippets/: $snippet_count liquid files"
  [ -n "$blocks" ] && append_line "blocks/: $blocks"
fi

# CSS components
for css_dir in \
  "$PROJECT_DIR/src/css/components" \
  "$PROJECT_DIR/src/entrypoints/components" \
  "$PROJECT_DIR/src/styles/components"; do
  [ -d "$css_dir" ] || continue
  files=$(list_files "$css_dir" "css")
  rel="${css_dir#$PROJECT_DIR/}"
  [ -n "$files" ] && append_line "${rel}/: $files"
done

# JS components
for js_dir in \
  "$PROJECT_DIR/src/js/components" \
  "$PROJECT_DIR/src/components"; do
  [ -d "$js_dir" ] || continue
  files=$(list_files "$js_dir" "js")
  rel="${js_dir#$PROJECT_DIR/}"
  [ -n "$files" ] && append_line "${rel}/: $files"
done

# Bash CLI / setup repos
if [ -d "$PROJECT_DIR/bin" ] || [ -d "$PROJECT_DIR/lib" ] || [ -d "$PROJECT_DIR/templates" ]; then
  bin_files=$(list_files "$PROJECT_DIR/bin" "sh")
  lib_files=$(list_files "$PROJECT_DIR/lib" "sh")
  template_count=$(dir_file_count "$PROJECT_DIR/templates")
  spec_count=$(find "$PROJECT_DIR/specs" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
  context_files=$(list_files "$PROJECT_DIR/.agents/context" "md")

  [ -n "$bin_files" ] && append_line "bin/: $bin_files"
  [ -n "$lib_files" ] && append_line "lib/: $lib_files"
  [ "$template_count" -gt 0 ] && append_line "templates/: $template_count top-level files"
  [ "$spec_count" -gt 0 ] && append_line "specs/: $spec_count draft files"
  [ -n "$context_files" ] && append_line ".agents/context/: $context_files"
fi

if [ -n "$output" ]; then
  label="=== File Index =="
  escaped=$(printf '%s' "$label\n$output" | sed 's/\\/\\\\/g; s/"/\\"/g; s/	/\\t/g')
  printf '{"additionalContext": "%s"}\n' "$escaped"
fi
