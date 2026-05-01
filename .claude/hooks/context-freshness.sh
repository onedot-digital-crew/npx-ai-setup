#!/usr/bin/env bash
# context-freshness.sh — SessionStart + UserPromptSubmit hook
# Reads .agents/context/index-manifest.json (Spec 655), compares source hashes
# and source-file-count delta, marks artifacts stale, prints a one-line warning
# plus a compact skill-routing map. Token budget: <300 total.
#
# Never rebuilds. Only annotates. /index --refresh is the user's job.

set -o pipefail

MANIFEST=".agents/context/index-manifest.json"

# Skill-Map (loaded every SessionStart, ~150 tokens)
print_skill_map() {
  cat << 'MAP' >&2
[SKILLS] /index (refresh ctx) /explore (read-only thinking) /spec (multi-file plan) /spec-work NNN (impl) /review (uncommitted diff) /commit /pr
MAP
}

# Bail early if manifest missing — print only skill map
if [ ! -f "$MANIFEST" ]; then
  print_skill_map
  echo "[CONTEXT] no index-manifest. run /index to build .agents/context/." >&2
  exit 0
fi

have_jq=0
command -v jq > /dev/null 2>&1 && have_jq=1

_sha() {
  if command -v sha256sum > /dev/null 2>&1; then
    sha256sum "$1" 2> /dev/null | awk '{print $1}'
  else
    shasum -a 256 "$1" 2> /dev/null | awk '{print $1}'
  fi
}

stale_sources=""
stale_artifacts=""

if [ "$have_jq" = "1" ]; then
  # Source hash comparison
  while IFS=$'\t' read -r path stored_hash; do
    [ -z "$path" ] && continue
    [ ! -f "$path" ] && continue
    current=$(_sha "$path")
    if [ -n "$current" ] && [ "$current" != "$stored_hash" ]; then
      stale_sources="${stale_sources}${path} "
    fi
  done < <(jq -r '.sources | to_entries[] | "\(.key)\t\(.value.hash)"' "$MANIFEST" 2> /dev/null)

  # Stack profile to gate artifact mapping
  stack=$(jq -r '.stack // "default"' "$MANIFEST" 2> /dev/null)

  # Map source change to affected artifact
  for src in $stale_sources; do
    case "$src" in
      package.json | package-lock.json | pnpm-lock.yaml | yarn.lock)
        case "$stack" in
          nuxt-storyblok | nuxtjs | nextjs) stale_artifacts="${stale_artifacts}graph.json " ;;
        esac
        ;;
      composer.json | composer.lock) stale_artifacts="${stale_artifacts}context " ;;
      shopify.theme.toml | config/settings_schema.json) stale_artifacts="${stale_artifacts}liquid-graph.json " ;;
      nuxt.config.* | vite.config.*) stale_artifacts="${stale_artifacts}graph.json " ;;
    esac
  done

  # Liquid file change → liquid-graph stale (Shopify only)
  if [ "$stack" = "shopify-liquid" ] && command -v git > /dev/null 2>&1; then
    liquid_changes=$(git diff --name-only HEAD 2> /dev/null | grep -c '\.liquid$' || echo 0)
    if [ "${liquid_changes:-0}" -gt 0 ]; then
      stale_artifacts="${stale_artifacts}liquid-graph.json "
    fi
  fi

  # 20% file-count delta heuristic for graph.json (semantic drift)
  case "$stack" in
    nuxt-storyblok | nuxtjs | nextjs)
      if command -v git > /dev/null 2>&1; then
        # Stored count from manifest if present (top-level optional key)
        stored_count=$(jq -r '.source_file_count // empty' "$MANIFEST" 2> /dev/null)
        if [ -n "$stored_count" ] && [ "$stored_count" -gt 0 ] 2> /dev/null; then
          current_count=$(git ls-files 2> /dev/null | grep -cE '\.(ts|tsx|js|jsx|vue)$' || echo 0)
          delta=$((current_count - stored_count))
          [ "$delta" -lt 0 ] && delta=$((-delta))
          threshold=$((stored_count / 5))
          [ "$threshold" -lt 5 ] && threshold=5
          if [ "$delta" -ge "$threshold" ]; then
            stale_artifacts="${stale_artifacts}graph.json(delta>20%) "
          fi
        fi
      fi
      ;;
  esac
fi

# Always print skill map first
print_skill_map

# Stale warning (one line if any)
if [ -n "$stale_artifacts" ] || [ -n "$stale_sources" ]; then
  # Dedupe artifacts (intentional word-split on spaces)
  # shellcheck disable=SC2086
  uniq_art=$(echo $stale_artifacts | tr ' ' '\n' | awk 'NF && !seen[$0]++' | tr '\n' ' ')
  echo "[CONTEXT STALE] run /index --refresh — affects: ${uniq_art:-context}" >&2
fi

exit 0
