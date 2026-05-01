#!/usr/bin/env bash
# index-prep.sh — orchestrate context + graph artifacts and write a freshness manifest.
#
# Usage:
#   bash .claude/scripts/index-prep.sh                # build/refresh artifacts for current stack
#   bash .claude/scripts/index-prep.sh --refresh      # force rebuild even if artifacts up to date
#   bash .claude/scripts/index-prep.sh --graphify     # also run graphify build (if installed)
#   bash .claude/scripts/index-prep.sh --no-graphify  # never run graphify
#   bash .claude/scripts/index-prep.sh --dry-run      # report what would happen
#
# Outputs:
#   .agents/context/index-manifest.json   — manifest with sources + artifact freshness
#   .agents/context/graph.json            — JS/TS/Vue import graph (when applicable)
#   .agents/context/liquid-graph.json     — Shopify Liquid section/snippet graph (when applicable)
#   graphify-out/graph.json               — semantic graph (opt-in, only if graphify available)

set -o pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJECT_DIR" || exit 2

REFRESH=0
GRAPHIFY_FLAG=auto # auto | force | skip
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --refresh) REFRESH=1 ;;
    --graphify) GRAPHIFY_FLAG=force ;;
    --no-graphify) GRAPHIFY_FLAG=skip ;;
    --dry-run) DRY_RUN=1 ;;
    -h | --help)
      sed -n '2,16p' "$0"
      exit 0
      ;;
  esac
done

CTX_DIR="${PROJECT_DIR}/.agents/context"
MANIFEST="${CTX_DIR}/index-manifest.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

mkdir -p "$CTX_DIR"

log() { echo "[index] $*" >&2; }

# ---------------------------------------------------------------------------
# 1. Stack detection. Prefer ai-setup metadata, fall back to lib/detect-stack.sh
# ---------------------------------------------------------------------------
detect_stack() {
  local stack=""
  if [ -f ".ai-setup.json" ] && command -v jq > /dev/null 2>&1; then
    stack=$(jq -r '.stack_profile // .system // empty' .ai-setup.json 2> /dev/null)
  fi
  if [ -z "$stack" ] || [ "$stack" = "null" ]; then
    if [ -x ".claude/scripts/detect-stack.sh" ]; then
      stack=$(bash .claude/scripts/detect-stack.sh "$PROJECT_DIR" 2> /dev/null | grep '^stack_profile=' | cut -d= -f2)
    fi
  fi
  [ -z "$stack" ] && stack="default"
  echo "$stack"
}

STACK=$(detect_stack)
log "stack: $STACK"

# ---------------------------------------------------------------------------
# 2. Source hash/mtime collection — feeds the manifest and freshness checks
# ---------------------------------------------------------------------------
SOURCES_TO_TRACK=(
  "package.json"
  "package-lock.json"
  "pnpm-lock.yaml"
  "yarn.lock"
  "composer.json"
  "composer.lock"
  "nuxt.config.ts"
  "nuxt.config.js"
  "vite.config.ts"
  "vite.config.js"
  "shopify.theme.toml"
  "config/settings_schema.json"
)

_sha() {
  local f="$1"
  if command -v sha256sum > /dev/null 2>&1; then
    sha256sum "$f" 2> /dev/null | awk '{print $1}'
  else
    shasum -a 256 "$f" 2> /dev/null | awk '{print $1}'
  fi
}

_mtime() {
  local f="$1"
  if stat -f '%m' "$f" > /dev/null 2>&1; then
    stat -f '%m' "$f"
  else
    stat -c '%Y' "$f" 2> /dev/null
  fi
}

build_sources_json() {
  local out="{"
  local first=1 src hash mtime
  for src in "${SOURCES_TO_TRACK[@]}"; do
    [ -f "$src" ] || continue
    hash=$(_sha "$src")
    mtime=$(_mtime "$src")
    [ -z "$hash" ] && continue
    [ "$first" = "1" ] || out="${out},"
    out="${out}\"${src}\":{\"hash\":\"${hash}\",\"mtime\":${mtime:-0}}"
    first=0
  done
  out="${out}}"
  echo "$out"
}

# ---------------------------------------------------------------------------
# 3. Artifact builders (idempotent — each script handles its own freshness)
# ---------------------------------------------------------------------------
ARTIFACT_KEYS=()
ARTIFACT_VALUES=()

_record_artifact() {
  local key="$1"
  local stale="${2:-false}"
  local present="${3:-true}"
  ARTIFACT_KEYS+=("$key")
  ARTIFACT_VALUES+=("{\"built_at\":\"${TIMESTAMP}\",\"stale\":${stale},\"present\":${present}}")
}

run_or_dry() {
  if [ "$DRY_RUN" = "1" ]; then
    log "dry-run: $*"
    return 0
  fi
  "$@"
}

build_js_graph() {
  case "$STACK" in
    nuxt-storyblok | nuxtjs | nextjs) ;;
    *) return 0 ;;
  esac

  local graph_path=".agents/context/graph.json"
  local builder=""
  for cand in "scripts/build-graph.sh" ".claude/scripts/build-graph.sh"; do
    if [ -f "$cand" ]; then
      builder="$cand"
      break
    fi
  done
  if [ -z "$builder" ]; then
    log "no build-graph.sh found, skipping JS/TS graph"
    return 0
  fi

  if [ "$REFRESH" = "1" ] || [ ! -f "$graph_path" ]; then
    run_or_dry bash "$builder" "$PROJECT_DIR" || log "build-graph.sh failed (continuing)"
  else
    log "graph.json present (use --refresh to rebuild)"
  fi
  if [ -f "$graph_path" ]; then
    _record_artifact "graph.json" "false" "true"
  fi
}

build_liquid_graph() {
  [ "$STACK" = "shopify-liquid" ] || return 0

  local script=""
  for cand in ".claude/scripts/liquid-graph-refresh.sh"; do
    [ -f "$cand" ] && script="$cand" && break
  done
  if [ -z "$script" ]; then
    log "liquid-graph-refresh.sh missing, skipping"
    return 0
  fi
  run_or_dry bash "$script" "$PROJECT_DIR" || log "liquid-graph-refresh failed (continuing)"
  if [ -f ".agents/context/liquid-graph.json" ]; then
    _record_artifact "liquid-graph.json" "false" "true"
  fi
}

build_graphify() {
  case "$GRAPHIFY_FLAG" in
    skip) return 0 ;;
  esac
  if ! command -v graphify > /dev/null 2>&1; then
    [ "$GRAPHIFY_FLAG" = "force" ] && log "graphify requested but not installed — skipping"
    return 0
  fi
  if [ "$GRAPHIFY_FLAG" != "force" ]; then
    # Only auto-run if a graphify-out already exists (project opted in earlier)
    [ -d "graphify-out" ] || return 0
  fi
  run_or_dry graphify build . || log "graphify build failed (continuing)"
  if [ -f "graphify-out/graph.json" ]; then
    _record_artifact "graphify-out/graph.json" "false" "true"
  fi
}

build_js_graph
build_liquid_graph
build_graphify

# ---------------------------------------------------------------------------
# 4. Manifest write
# ---------------------------------------------------------------------------
sources_json=$(build_sources_json)

# Source file count for semantic drift heuristic (20% rule)
SOURCE_FILE_COUNT=0
if command -v git > /dev/null 2>&1; then
  case "$STACK" in
    nuxt-storyblok | nuxtjs | nextjs)
      SOURCE_FILE_COUNT=$(git ls-files 2> /dev/null | grep -cE '\.(ts|tsx|js|jsx|vue)$' || echo 0)
      ;;
    shopify-liquid)
      SOURCE_FILE_COUNT=$(git ls-files 2> /dev/null | grep -cE '\.liquid$' || echo 0)
      ;;
    *)
      SOURCE_FILE_COUNT=$(git ls-files 2> /dev/null | wc -l | tr -d ' ')
      ;;
  esac
fi

artifacts_json="{"
for i in "${!ARTIFACT_KEYS[@]}"; do
  [ "$i" = "0" ] || artifacts_json="${artifacts_json},"
  artifacts_json="${artifacts_json}\"${ARTIFACT_KEYS[$i]}\":${ARTIFACT_VALUES[$i]}"
done
artifacts_json="${artifacts_json}}"

manifest=$(
  cat << JSON
{
  "version": 1,
  "stack": "${STACK}",
  "generated_at": "${TIMESTAMP}",
  "source_file_count": ${SOURCE_FILE_COUNT},
  "sources": ${sources_json},
  "artifacts": ${artifacts_json}
}
JSON
)

if [ "$DRY_RUN" = "1" ]; then
  echo "$manifest"
  log "dry-run: would write $MANIFEST"
  exit 0
fi

if command -v jq > /dev/null 2>&1; then
  echo "$manifest" | jq '.' > "$MANIFEST"
else
  echo "$manifest" > "$MANIFEST"
fi

log "manifest: $MANIFEST"
log "artifacts: ${#ARTIFACT_KEYS[@]} tracked"
exit 0
