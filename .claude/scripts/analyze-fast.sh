#!/bin/bash
# analyze-fast.sh — repomix-powered structural snapshot for /analyze Fast-Path
# Usage: bash .claude/scripts/analyze-fast.sh [project-dir]
# Output: compressed XML to stdout (repomix --compress --style xml)
# Returns exit 1 if repomix unavailable or output empty; caller falls back to agent mode.
set -e

PROJECT_DIR="${1:-${CLAUDE_PROJECT_DIR:-$PWD}}"

if ! command -v repomix > /dev/null 2>&1; then
  echo "[analyze-fast] repomix not found — install: brew install repomix" >&2
  exit 1
fi

# Detect stack for ignore patterns
stack_profile="default"
_detect_script="$(cd "$(dirname "$0")" && pwd)/../../lib/detect-stack.sh"
if [ -f "$_detect_script" ]; then
  stack_profile=$(bash "$_detect_script" "$PROJECT_DIR" 2> /dev/null | grep "^stack_profile=" | cut -d= -f2 || echo "default")
fi

# Stack-aware ignore patterns
base_ignore="node_modules,vendor,.git,.nuxt,.output,.next,dist,build,coverage,.cache"
case "$stack_profile" in
  nuxt-storyblok | nuxtjs)
    extra_ignore=".nuxt,.output,public/assets"
    ;;
  shopify-liquid)
    extra_ignore="assets/compiled,config/settings_data.json"
    ;;
  laravel)
    extra_ignore="vendor,storage,bootstrap/cache,public/build"
    ;;
  nextjs)
    extra_ignore=".next,out,public/_next"
    ;;
  *)
    extra_ignore=""
    ;;
esac

ignore_patterns="${base_ignore}"
[ -n "$extra_ignore" ] && ignore_patterns="${ignore_patterns},${extra_ignore}"

# Run repomix — compress strips function bodies, keeps signatures (70-80% token reduction)
output=$(repomix \
  --compress \
  --style xml \
  --ignore "$ignore_patterns" \
  --stdout \
  "$PROJECT_DIR" 2> /dev/null || true)

if [ -z "$output" ]; then
  echo "[analyze-fast] repomix returned empty output" >&2
  exit 1
fi

# Write structural hash for drift-detection in context-freshness hook
# Format: timestamp:file_count (cheap proxy, avoids re-running repomix on every prompt)
_file_count=$(git ls-files "$PROJECT_DIR" 2> /dev/null | grep -cE '\.(ts|tsx|js|jsx|vue|php|sh|py)$' || echo "0")
mkdir -p "${PROJECT_DIR}/.agents/context" 2> /dev/null || true
echo "$(date +%s):${_file_count}" > "${PROJECT_DIR}/.agents/context/.repomix-hash" 2> /dev/null || true

echo "$output"
