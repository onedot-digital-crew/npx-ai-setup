#!/bin/bash
# measure-context-cost.sh — Token-cost estimate for .agents/context/ files
# Usage: bash .claude/scripts/measure-context-cost.sh [context-dir]
# Output: per-file line count + token estimate (4 chars/token approximation)
# Zero LLM calls. Use before/after /analyze to verify token reduction.
set -e

CONTEXT_DIR="${1:-${CLAUDE_PROJECT_DIR:-.}/.agents/context}"

if [ ! -d "$CONTEXT_DIR" ]; then
  echo "Context dir not found: $CONTEXT_DIR" >&2
  exit 1
fi

# Load phase: which files are loaded at session start vs on-demand
# ALWAYS = loaded via @-import in CLAUDE.md (every session)
# ON_DEMAND = referenced in CLAUDE.md hint, loaded when explicitly asked
# SKILL = written/read by specific skill only
# HOOK = consumed by hooks (0 LLM tokens)
classify_file() {
  local base="$1"
  case "$base" in
    SUMMARY) echo "ALWAYS" ;;
    graph) echo "HOOK (0 tokens)" ;;
    STACK | ARCHITECTURE | CONVENTIONS | DESIGN-DECISIONS) echo "ON_DEMAND" ;;
    PATTERNS | AUDIT) echo "SKILL (/analyze)" ;;
    LEARNINGS) echo "SKILL (/reflect)" ;;
    *) echo "ON_DEMAND" ;;
  esac
}

# Approximate token count: 1 token ≈ 4 chars (conservative, real is ~3.5 for code)
estimate_tokens() {
  local file="$1"
  local chars
  chars=$(wc -c < "$file" 2> /dev/null || echo "0")
  echo $((chars / 4))
}

total_always=0
total_ondmand=0
total_skill=0

printf "%-30s %6s %8s  %s\n" "File" "Lines" "~Tokens" "Load-phase"
echo "----------------------------------------------------------------------"

for file in "$CONTEXT_DIR"/*.md "$CONTEXT_DIR"/*.json; do
  [ -f "$file" ] || continue
  base=$(basename "$file")
  base_noext="${base%.*}"
  lines=$(wc -l < "$file" 2> /dev/null | tr -d ' ')
  tokens=$(estimate_tokens "$file")
  phase=$(classify_file "$base_noext")

  printf "%-30s %6s %8s  %s\n" "$base" "$lines" "$tokens" "$phase"

  case "$phase" in
    ALWAYS) total_always=$((total_always + tokens)) ;;
    ON_DEMAND) total_ondmand=$((total_ondmand + tokens)) ;;
    SKILL*) total_skill=$((total_skill + tokens)) ;;
  esac
done

echo "----------------------------------------------------------------------"
printf "%-30s %6s %8s  %s\n" "TOTAL always-loaded" "" "$total_always" "(every session)"
printf "%-30s %6s %8s  %s\n" "TOTAL on-demand" "" "$total_ondmand" "(when asked)"
printf "%-30s %6s %8s  %s\n" "TOTAL skill-only" "" "$total_skill" "(specific skill)"
echo ""
echo "Session baseline cost: ~${total_always} tokens (always-loaded files only)"
echo "Tip: ALWAYS-loaded files drive session cost. Keep SUMMARY.md under 150 tokens."
