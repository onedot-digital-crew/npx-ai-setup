#!/bin/bash

# ==============================================================================
# @onedot/ai-setup - AI infrastructure for projects
# ==============================================================================
# Installs Claude Code hooks, project context, and AI-curated skills
# Usage: npx @onedot/ai-setup [--with-gsd] [--no-gsd] [--with-claude-mem] [--no-claude-mem]
#        [--with-plugins] [--no-plugins] [--with-context7] [--no-context7]
#        [--with-playwright] [--no-playwright] [--system <name>]
#        npx @onedot/ai-setup --regenerate [--system <name>]
# Auto-detects updates: if .ai-setup.json exists with older version, offers update/reinstall
# ==============================================================================

set -e

# Package root (one level above bin/)
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TPL="$SCRIPT_DIR/templates"

# Parse flags
WITH_GSD=""
WITH_CLAUDE_MEM=""
WITH_PLUGINS=""
WITH_CONTEXT7=""
WITH_PLAYWRIGHT=""
SYSTEM=""
REGENERATE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-gsd) WITH_GSD="yes"; shift ;;
    --no-gsd) WITH_GSD="no"; shift ;;
    --with-claude-mem) WITH_CLAUDE_MEM="yes"; shift ;;
    --no-claude-mem) WITH_CLAUDE_MEM="no"; shift ;;
    --with-plugins) WITH_PLUGINS="yes"; shift ;;
    --no-plugins) WITH_PLUGINS="no"; shift ;;
    --with-context7) WITH_CONTEXT7="yes"; shift ;;
    --no-context7) WITH_CONTEXT7="no"; shift ;;
    --with-playwright) WITH_PLAYWRIGHT="yes"; shift ;;
    --no-playwright) WITH_PLAYWRIGHT="no"; shift ;;
    --regenerate) REGENERATE="yes"; shift ;;
    --system)
      if [[ $# -lt 2 ]]; then
        echo "❌ --system requires a value (auto|shopify|nuxt|next|laravel|shopware|storyblok)"
        exit 1
      fi
      SYSTEM="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# ==============================================================================
# UPDATE SYSTEM HELPERS
# ==============================================================================

# Template mapping: "source_in_package:target_in_project"
TEMPLATE_MAP=(
  "templates/CLAUDE.md:CLAUDE.md"
  "templates/claude/settings.json:.claude/settings.json"
  "templates/claude/hooks/protect-files.sh:.claude/hooks/protect-files.sh"
  "templates/claude/hooks/post-edit-lint.sh:.claude/hooks/post-edit-lint.sh"
  "templates/claude/hooks/circuit-breaker.sh:.claude/hooks/circuit-breaker.sh"
  "templates/claude/hooks/context-freshness.sh:.claude/hooks/context-freshness.sh"
  "templates/github/copilot-instructions.md:.github/copilot-instructions.md"
  "templates/specs/TEMPLATE.md:specs/TEMPLATE.md"
  "templates/specs/README.md:specs/README.md"
  "templates/commands/spec.md:.claude/commands/spec.md"
  "templates/commands/spec-work.md:.claude/commands/spec-work.md"
  "templates/commands/spec-work-all.md:.claude/commands/spec-work-all.md"
  "templates/commands/commit.md:.claude/commands/commit.md"
  "templates/commands/pr.md:.claude/commands/pr.md"
  "templates/commands/review.md:.claude/commands/review.md"
  "templates/commands/test.md:.claude/commands/test.md"
  "templates/commands/techdebt.md:.claude/commands/techdebt.md"
  "templates/commands/grill.md:.claude/commands/grill.md"
  "templates/agents/verify-app.md:.claude/agents/verify-app.md"
  "templates/agents/build-validator.md:.claude/agents/build-validator.md"
  "templates/agents/staff-reviewer.md:.claude/agents/staff-reviewer.md"
  "templates/agents/context-refresher.md:.claude/agents/context-refresher.md"
)

# Get package version from package.json
get_package_version() {
  jq -r '.version' "$SCRIPT_DIR/package.json" 2>/dev/null || echo "unknown"
}

# Get installed version from .ai-setup.json
get_installed_version() {
  if [ -f .ai-setup.json ] && jq -e . .ai-setup.json >/dev/null 2>&1; then
    jq -r '.version // empty' .ai-setup.json 2>/dev/null || echo ""
  else
    echo ""
  fi
}

# Compute checksum for a file (cksum outputs: checksum size filename)
compute_checksum() {
  if [ -f "$1" ]; then
    cksum "$1" 2>/dev/null | awk '{print $1, $2}' || echo ""
  else
    echo ""
  fi
}

# Write .ai-setup.json with current version and checksums
write_metadata() {
  local version
  version=$(get_package_version)
  local timestamp
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Preserve original install time if updating
  local install_time="$timestamp"
  if [ -f .ai-setup.json ] && jq -e . .ai-setup.json >/dev/null 2>&1; then
    local prev
    prev=$(jq -r '.installed_at // empty' .ai-setup.json 2>/dev/null)
    [ -n "$prev" ] && install_time="$prev"
  fi

  # Build JSON with jq
  local json
  json=$(jq -n \
    --arg ver "$version" \
    --arg inst "$install_time" \
    --arg upd "$timestamp" \
    --arg sys "${SYSTEM:-}" \
    '{version: $ver, installed_at: $inst, updated_at: $upd, system: $sys, files: {}}')

  for mapping in "${TEMPLATE_MAP[@]}"; do
    local tpl="${mapping%%:*}"
    local target="${mapping#*:}"
    if [ -f "$target" ]; then
      local cs
      cs=$(compute_checksum "$target")
      json=$(echo "$json" | jq --arg f "$target" --arg c "$cs" '.files[$f] = $c')
    fi
  done

  echo "$json" > .ai-setup.json
}

# Backup a file to .ai-setup-backup/ with timestamp
backup_file() {
  local file="$1"
  local ts
  ts=$(date +"%Y%m%d_%H%M%S")
  mkdir -p .ai-setup-backup

  # Use flat filename with path separators replaced
  local safe_name
  safe_name=$(echo "$file" | tr '/' '_')
  local backup_path=".ai-setup-backup/${safe_name}.${ts}"
  cp "$file" "$backup_path"
  echo "$backup_path"
}

# Efficiently collect project files (git-aware with fallback)
collect_project_files() {
  local max_files=${1:-80}

  # Try git first (10x faster)
  if git rev-parse --git-dir >/dev/null 2>&1; then
    git ls-files -z '*.js' '*.ts' '*.jsx' '*.tsx' '*.vue' '*.svelte' \
      '*.css' '*.scss' '*.liquid' '*.php' '*.html' '*.twig' \
      '*.blade.php' '*.erb' '*.py' '*.rb' '*.go' '*.rs' '*.astro' \
      2>/dev/null | tr '\0' '\n' | head -n "$max_files"
  else
    # Fallback: optimized find with early pruning
    find . -maxdepth 4 \
      \( -name node_modules -o -name .git -o -name dist -o -name build \
         -o -name assets -o -name .next -o -name vendor -o -name .nuxt \) -prune -o \
      -type f \( \
        -iname '*.js' -o -iname '*.ts' -o -iname '*.jsx' -o -iname '*.tsx' \
        -o -iname '*.vue' -o -iname '*.svelte' -o -iname '*.css' -o -iname '*.scss' \
        -o -iname '*.liquid' -o -iname '*.php' -o -iname '*.html' -o -iname '*.twig' \
        -o -iname '*.blade.php' -o -iname '*.erb' -o -iname '*.py' -o -iname '*.rb' \
        -o -iname '*.go' -o -iname '*.rs' -o -iname '*.astro' \
      \) -print | head -n "$max_files"
  fi
}

VALID_SYSTEMS=(auto shopify nuxt next laravel shopware storyblok)

# Validate --system value (supports comma-separated list)
if [ -n "$SYSTEM" ]; then
  IFS=',' read -ra SYSTEMS_TO_VALIDATE <<< "$SYSTEM"
  for sys in "${SYSTEMS_TO_VALIDATE[@]}"; do
    VALID=false
    for s in "${VALID_SYSTEMS[@]}"; do
      [ "$sys" = "$s" ] && VALID=true
    done
    if [ "$VALID" = false ]; then
      echo "❌ Unknown system: $sys"
      echo "   Valid options: ${VALID_SYSTEMS[*]}"
      exit 1
    fi
  done
  # Ensure "auto" is not combined with other systems
  if [[ "$SYSTEM" == *"auto"* ]] && [[ "$SYSTEM" == *","* ]]; then
    echo "❌ 'auto' cannot be combined with other systems"
    exit 1
  fi
fi

# System/framework selection menu (multiselect with arrow-key navigation)
select_system() {
  local options=("auto" "shopify" "nuxt" "next" "laravel" "shopware" "storyblok")
  local descriptions=("Claude detects automatically" "Shopify Theme" "Nuxt 4 / Vue" "Next.js / React" "Laravel / PHP" "Shopware 6" "Storyblok CMS")
  local selected=0
  local count=${#options[@]}
  local -a checked=()

  # Initialize all as unchecked
  for ((i=0; i<count; i++)); do
    checked[$i]=0
  done

  echo ""
  echo "Which system/framework does this project use?"
  echo "  (Use ↑↓ arrows, Space to toggle, Enter to confirm)"
  echo ""

  # Hide cursor
  printf '\033[?25l'
  # Restore cursor on exit
  trap 'printf "\033[?25h"' RETURN 2>/dev/null || true

  # Print initial menu
  for ((i=0; i<count; i++)); do
    local checkbox="[ ]"
    [ "${checked[$i]}" -eq 1 ] && checkbox="[✓]"

    if [ $i -eq $selected ]; then
      printf '  \033[7m ▸ %s %-12s %s \033[0m\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
    else
      printf '    %s %-12s %s\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
    fi
  done

  while true; do
    # Read a single keypress
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')  # Escape sequence (arrow keys)
        read -rsn2 seq
        case "$seq" in
          '[A') # Up
            selected=$(( (selected - 1 + count) % count ))
            ;;
          '[B') # Down
            selected=$(( (selected + 1) % count ))
            ;;
        esac
        ;;
      " ")  # Space - toggle selection
        if [ "${options[$selected]}" = "auto" ]; then
          # Auto is exclusive - uncheck all others
          for ((i=0; i<count; i++)); do
            checked[$i]=0
          done
          checked[$selected]=1
        else
          # Toggle current selection
          if [ "${checked[$selected]}" -eq 1 ]; then
            checked[$selected]=0
          else
            checked[$selected]=1
            # If any other is selected, uncheck "auto"
            checked[0]=0
          fi
        fi
        ;;
      "")  # Enter
        break
        ;;
    esac

    # Redraw menu (move cursor up)
    printf "\033[${count}A"
    for ((i=0; i<count; i++)); do
      local checkbox="[ ]"
      [ "${checked[$i]}" -eq 1 ] && checkbox="[✓]"

      if [ $i -eq $selected ]; then
        printf '  \033[7m ▸ %s %-12s %s \033[0m\033[K\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
      else
        printf '    %s %-12s %s\033[K\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
      fi
    done
  done

  # Show cursor
  printf '\033[?25h'

  # Build comma-separated list of selected systems
  local selected_systems=()
  for ((i=0; i<count; i++)); do
    if [ "${checked[$i]}" -eq 1 ]; then
      selected_systems+=("${options[$i]}")
    fi
  done

  # If nothing selected, default to auto
  if [ ${#selected_systems[@]} -eq 0 ]; then
    SYSTEM="auto"
  else
    SYSTEM=$(IFS=,; echo "${selected_systems[*]}")
  fi

  echo ""
  echo "  Selected: $SYSTEM"
}

# Detect system from codebase signals when SYSTEM="auto"
# Updates SYSTEM in-place if a concrete signal is found
detect_system() {
  [ "$SYSTEM" != "auto" ] && return 0

  if find . -maxdepth 4 -name "theme.liquid" -not -path "*/node_modules/*" 2>/dev/null | grep -q .; then
    SYSTEM="shopify"
  elif [ -f composer.json ] && [ -f artisan ]; then
    SYSTEM="laravel"
  elif [ -f composer.json ] && [ -d vendor/shopware ]; then
    SYSTEM="shopware"
  elif [ -f package.json ] && grep -q '"nuxt"' package.json 2>/dev/null; then
    SYSTEM="nuxt"
  elif [ -f package.json ] && grep -q '"next"' package.json 2>/dev/null; then
    SYSTEM="next"
  elif [ -f package.json ] && grep -q '"@storyblok' package.json 2>/dev/null; then
    SYSTEM="storyblok"
  fi

  if [ "$SYSTEM" != "auto" ]; then
    echo "  🔍 Detected system: $SYSTEM"
  fi
}

# Kill process + all child processes (Claude spawns sub-agents)
kill_tree() {
  local pid=$1
  pkill -P "$pid" 2>/dev/null || true
  kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
}

# Progress bar for a single process
# Usage: progress_bar <pid> <label> [est_seconds] [max_seconds]
progress_bar() {
  local pid=$1 label=$2 est=${3:-120} max=${4:-600}
  local width=30 elapsed=0
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$elapsed" -ge "$max" ]; then
      kill_tree "$pid"
      printf "\r  ⚠️  %s cancelled after %ds (timeout)%*s\n" "$label" "$elapsed" 20 ""
      return 0
    fi
    local pct=$((elapsed * 100 / est))
    [ "$pct" -gt 95 ] && pct=95
    local filled=$((pct * width / 100))
    local empty=$((width - filled))
    local bar=$(printf '█%.0s' $(seq 1 $filled 2>/dev/null) ; printf '░%.0s' $(seq 1 $empty 2>/dev/null))
    printf "\r  %s %s [%s] %d%% (%ds)" "⏳" "$label" "$bar" "$pct" "$elapsed"
    sleep 1
    elapsed=$((elapsed + 1))
  done
  local bar=$(printf '█%.0s' $(seq 1 $width))
  printf "\r  ✅ %s [%s] 100%% (%ds)\n" "$label" "$bar" "$elapsed"
}

# Parallel progress bars for multiple processes
# Usage: wait_parallel "PID:Label:Est:Max" "PID:Label:Est:Max" ...
wait_parallel() {
  local specs=("$@")
  local count=${#specs[@]}
  local width=30

  # Parse specs
  local pids=() labels=() ests=() maxes=() done_at=()
  for spec in "${specs[@]}"; do
    IFS=: read -r pid label est max <<< "$spec"
    pids+=("$pid")
    labels+=("$label")
    ests+=("$est")
    maxes+=("$max")
    done_at+=(0)
  done

  # Reserve lines
  for ((i=0; i<count; i++)); do echo ""; done

  local elapsed=0

  while true; do
    local running=0
    # Move cursor up to overwrite
    printf "\033[${count}A"

    for ((i=0; i<count; i++)); do
      local pid=${pids[$i]}
      local label=${labels[$i]}
      local est=${ests[$i]}
      local max=${maxes[$i]}

      if [ "${done_at[$i]}" -gt 0 ]; then
        # Already finished
        local bar=$(printf '█%.0s' $(seq 1 $width))
        printf "\r  ✅ %-25s [%s] 100%% (%ds)%*s\n" "$label" "$bar" "${done_at[$i]}" 5 ""
      elif ! kill -0 "$pid" 2>/dev/null; then
        # Just finished
        done_at[$i]=$((elapsed > 0 ? elapsed : 1))
        local bar=$(printf '█%.0s' $(seq 1 $width))
        printf "\r  ✅ %-25s [%s] 100%% (%ds)%*s\n" "$label" "$bar" "$elapsed" 5 ""
      elif [ "$elapsed" -ge "$max" ]; then
        # Timeout
        kill_tree "$pid"
        done_at[$i]=$elapsed
        printf "\r  ⚠️  %-25s cancelled after %ds (timeout)%*s\n" "$label" "$elapsed" 10 ""
      else
        # Still running
        running=$((running + 1))
        local pct=$((elapsed * 100 / est))
        [ "$pct" -gt 95 ] && pct=95
        local filled=$((pct * width / 100))
        local empty=$((width - filled))
        local bar=$(printf '█%.0s' $(seq 1 $filled 2>/dev/null) ; printf '░%.0s' $(seq 1 $empty 2>/dev/null))
        printf "\r  ⏳ %-25s [%s] %d%% (%ds)%*s\n" "$label" "$bar" "$pct" "$elapsed" 5 ""
      fi
    done

    [ "$running" -eq 0 ] && break
    sleep 1
    elapsed=$((elapsed + 1))
  done
}

# ==============================================================================
# GENERATION: Claude populates CLAUDE.md + generates project context + skills
# ==============================================================================
# Called by both normal setup (Section 9) and --regenerate mode.
# Requires: $SYSTEM is set, claude CLI is available
# Sets: $INSTALLED (number of skills installed)
run_generation() {
  # Disable errexit — background processes, wait, and command substitutions
  # cause silent exits with set -e (especially bash 3.2 on macOS).
  # This function has comprehensive error handling for all steps.
  set +e

  echo "🚀 Generating project context (System: $SYSTEM)..."

  # Cache file list once (avoid running collect_project_files 3x)
  CACHED_FILES=$(collect_project_files 80)

  # Gather all context upfront
  CONTEXT="--- package.json ---
$(cat package.json 2>/dev/null)
--- package.json scripts ---
$(jq -r '.scripts | to_entries[] | "- \(.key): \(.value)"' package.json 2>/dev/null)
--- Directory structure (max 80 files) ---
$CACHED_FILES
--- ESLint Config ---
$(cat eslint.config.* .eslintrc* 2>/dev/null | head -100)
--- Prettier Config ---
$(cat .prettierrc* 2>/dev/null)
--- CLAUDE.md (current) ---
$(cat CLAUDE.md 2>/dev/null)"

  # Extended context for project context generation
  CTX_PKG=$(cat package.json 2>/dev/null || echo "No package.json")
  CTX_TSCONFIG=$(cat tsconfig.*.json 2>/dev/null; [ -f tsconfig.json ] && cat tsconfig.json 2>/dev/null || echo "No tsconfig")
  CTX_TSCONFIG=$(echo "$CTX_TSCONFIG" | head -80)
  CTX_DIRS=$(find . -maxdepth 3 -type d \
    \( -name node_modules -o -name .git -o -name dist -o -name build \
       -o -name .next -o -name vendor -o -name .nuxt -o -name .output \) -prune -o \
    -type d -print 2>/dev/null | head -60)
  CTX_FILES="$CACHED_FILES"
  CTX_CONFIGS=$(ls -1 *.config.* .eslintrc* .prettierrc* tailwind.config.* \
    vite.config.* nuxt.config.* next.config.* astro.config.* \
    webpack.config.* rollup.config.* docker-compose* Dockerfile \
    Makefile Cargo.toml go.mod requirements.txt pyproject.toml \
    biome.json 2>/dev/null || echo "No config files found")
  CTX_README=$(head -50 README.md 2>/dev/null || echo "No README")

  # Sample source files (generic: first 3 project files)
  CTX_SAMPLE=""
  for f in $(echo "$CACHED_FILES" | head -3); do
    CTX_SAMPLE+="
--- $f (first 50 lines) ---
$(head -50 "$f" 2>/dev/null)"
  done

  # Temp files for error capture (cleaned up on exit/interrupt)
  ERR_CM=$(mktemp)
  ERR_CTX=$(mktemp)
  trap "rm -f '$ERR_CM' '$ERR_CTX'" RETURN

  # Detect test framework for conditional TDD rule
  HAS_TESTS=""
  if cat package.json 2>/dev/null | grep -qE '"(jest|vitest|mocha|jasmine|ava)"'; then
    HAS_TESTS="jest/vitest/mocha"
  elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] && grep -q "pytest" pyproject.toml 2>/dev/null; then
    HAS_TESTS="pytest"
  elif [ -f "requirements.txt" ] && grep -qi "pytest" requirements.txt 2>/dev/null; then
    HAS_TESTS="pytest"
  fi

  TDD_INSTRUCTION=""
  if [ -n "$HAS_TESTS" ]; then
    TDD_INSTRUCTION="
## TDD Workflow ($HAS_TESTS detected)
If a test framework is present, add a 'TDD Workflow' subsection under Critical Rules:
- Before implementing ANY logic, write a failing test first (Red)
- Implement minimum code to make the test pass (Green)
- Refactor if needed, keep tests green (Refactor)
- Never write implementation code without a test first"
  fi

  # Step 1: Extend CLAUDE.md (sonnet, background)
  CLAUDE_MD_BEFORE=$(cksum CLAUDE.md 2>/dev/null || echo "none")

  claude -p --model claude-sonnet-4-6 --permission-mode acceptEdits --max-turns 3 "IMPORTANT: All project context is provided below. Do NOT read any files. Directly edit CLAUDE.md in a single turn.

Replace the ## Commands and ## Critical Rules sections in CLAUDE.md (remove any HTML comments in those sections).

## Commands
Based on the package.json scripts below, document the most important ones (dev, build, lint, test, etc.) as a bullet list.

## Critical Rules
Based on the eslint/prettier config below and the framework/system ($SYSTEM), write concrete, actionable rules. Max 5 sections, 3-5 bullet points each.
Cover these categories where evidence exists: code style (formatting, naming), TypeScript (strict mode, type patterns), imports (path aliases, barrel files), framework-specific (SSR, routing, state), testing (commands, patterns). Omit categories where no evidence exists in the config — do not fabricate rules.
$TDD_INSTRUCTION

Rules:
- Edit CLAUDE.md directly. Replace both sections including any <!-- comments -->.
- No umlauts. English only.
- Keep CLAUDE.md content stable and static — it is a prompt cache layer. Do not add timestamps, random IDs, or session-specific data.

$CONTEXT" >"$ERR_CM" 2>&1 &
  PID_CM=$!

  # Step 2: Generate project context (sonnet, background, parallel with Step 1)
  mkdir -p .agents/context

  claude -p --model claude-sonnet-4-6 --permission-mode acceptEdits --max-turns 4 "IMPORTANT: All project context is provided below. Do NOT read any files. Create all 3 files directly in a single turn.

Create exactly 3 files in .agents/context/ using the Write tool:

- **.agents/context/STACK.md** — runtime, framework (with versions), key dependencies (categorized: UI, state, data, testing, build), package manager, build tooling, and libraries/patterns to avoid
- **.agents/context/ARCHITECTURE.md** — project type, directory structure, entry points, data flow, key patterns
- **.agents/context/CONVENTIONS.md** — naming patterns, import style, component structure, error handling, TypeScript usage, testing patterns

Project system/framework: $SYSTEM

Rules:
- Create all 3 files in one turn using the Write tool.
- Base ALL content on the provided context. Do not invent details.
- Keep each file concise: 30-60 lines max.
- Use markdown headers and bullet points.
- If information is not available, write 'Not determined from available context.'
- No umlauts. English only.

--- package.json ---
$CTX_PKG
--- tsconfig ---
$CTX_TSCONFIG
--- Directory tree ---
$CTX_DIRS
--- File list ---
$CTX_FILES
--- Config files present ---
$CTX_CONFIGS
--- README (first 50 lines) ---
$CTX_README
--- Sample source files ---
$CTX_SAMPLE" >"$ERR_CTX" 2>&1 &
  PID_CTX=$!

  # Wait for both steps with parallel progress bars
  echo ""
  wait_parallel "$PID_CM:CLAUDE.md:30:120" "$PID_CTX:Project context:45:180"

  # Verify Step 1: CLAUDE.md was actually modified
  EXIT_CM=0
  wait "$PID_CM" 2>/dev/null || EXIT_CM=$?
  CLAUDE_MD_AFTER=$(cksum CLAUDE.md 2>/dev/null || echo "none")
  if [ "$EXIT_CM" -ne 0 ] || [ "$CLAUDE_MD_BEFORE" = "$CLAUDE_MD_AFTER" ]; then
    echo ""
    echo "  ⚠️  CLAUDE.md was not updated (exit code $EXIT_CM)."
    if [ -s "$ERR_CM" ]; then
      echo "  Output: $(tail -5 "$ERR_CM")"
    fi
    echo "  Fix: Run 'claude' in your terminal to check authentication, then re-run."
  fi

  # Verify Step 2: context files were created
  EXIT_CTX=0
  wait "$PID_CTX" 2>/dev/null || EXIT_CTX=$?
  CTX_COUNT=0
  [ -f .agents/context/STACK.md ] && CTX_COUNT=$((CTX_COUNT + 1))
  [ -f .agents/context/ARCHITECTURE.md ] && CTX_COUNT=$((CTX_COUNT + 1))
  [ -f .agents/context/CONVENTIONS.md ] && CTX_COUNT=$((CTX_COUNT + 1))

  if [ "$CTX_COUNT" -eq 3 ]; then
    echo "  ✅ All 3 context files created in .agents/context/"
  elif [ "$CTX_COUNT" -gt 0 ]; then
    echo "  ⚠️  $CTX_COUNT of 3 context files created (partial, exit code $EXIT_CTX)"
    if [ -s "$ERR_CTX" ]; then
      echo "  Output: $(tail -5 "$ERR_CTX")"
    fi
  else
    echo "  ⚠️  Context generation failed (exit code $EXIT_CTX)."
    if [ -s "$ERR_CTX" ]; then
      echo "  Output: $(tail -5 "$ERR_CTX")"
    fi
    echo "  Fix: Check 'claude' works, then run: npx @onedot/ai-setup --regenerate"
  fi

  # Save state for freshness detection
  STATE_FILE=".agents/context/.state"
  if [ -d ".agents/context" ]; then
    echo "PKG_HASH=$(cksum package.json 2>/dev/null | cut -d' ' -f1,2)" > "$STATE_FILE"
    echo "TSCONFIG_HASH=$(cksum tsconfig.json 2>/dev/null | cut -d' ' -f1,2)" >> "$STATE_FILE"
    echo "DIR_HASH=$(echo "$CACHED_FILES" | cksum | cut -d' ' -f1,2)" >> "$STATE_FILE"
    echo "GENERATED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$STATE_FILE"
  fi

  # Step 3: Search and install skills (AI-curated, haiku for ranking)
  echo ""
  echo "🔌 Searching and installing skills..."
  INSTALLED=0
  SKIPPED=0

  if [ -f package.json ]; then
    DEPS=$(jq -r '(.dependencies // {} | keys[]) , (.devDependencies // {} | keys[])' package.json 2>/dev/null | sort -u)
    KEYWORDS=()

    for dep in $DEPS; do
      case "$dep" in
        # Frontend frameworks (specific patterns before general globs)
        vue|vue-router|@vue/*) [[ ! " ${KEYWORDS[*]} " =~ " vue " ]] && KEYWORDS+=("vue") ;;
        @nuxt/ui|@nuxt/ui-pro) [[ ! " ${KEYWORDS[*]} " =~ " nuxt-ui " ]] && KEYWORDS+=("nuxt-ui") ;;
        nuxt|@nuxt/*) [[ ! " ${KEYWORDS[*]} " =~ " nuxt " ]] && KEYWORDS+=("nuxt") ;;
        react|react-dom|@react/*) [[ ! " ${KEYWORDS[*]} " =~ " react " ]] && KEYWORDS+=("react") ;;
        next|@next/*) [[ ! " ${KEYWORDS[*]} " =~ " next " ]] && KEYWORDS+=("next") ;;
        svelte|@sveltejs/*) [[ ! " ${KEYWORDS[*]} " =~ " svelte " ]] && KEYWORDS+=("svelte") ;;
        astro|@astrojs/*) [[ ! " ${KEYWORDS[*]} " =~ " astro " ]] && KEYWORDS+=("astro") ;;
        # UI libraries
        tailwindcss|@tailwindcss/*) [[ ! " ${KEYWORDS[*]} " =~ " tailwind " ]] && KEYWORDS+=("tailwind") ;;
        @shadcn/*|shadcn-ui) [[ ! " ${KEYWORDS[*]} " =~ " shadcn " ]] && KEYWORDS+=("shadcn") ;;
        @radix-ui/*) [[ ! " ${KEYWORDS[*]} " =~ " radix " ]] && KEYWORDS+=("radix") ;;
        @headlessui/*) [[ ! " ${KEYWORDS[*]} " =~ " headless-ui " ]] && KEYWORDS+=("headless-ui") ;;
        # Languages & runtimes
        typescript) [[ ! " ${KEYWORDS[*]} " =~ " typescript " ]] && KEYWORDS+=("typescript") ;;
        # Backend
        express) [[ ! " ${KEYWORDS[*]} " =~ " express " ]] && KEYWORDS+=("express") ;;
        @nestjs/*) [[ ! " ${KEYWORDS[*]} " =~ " nestjs " ]] && KEYWORDS+=("nestjs") ;;
        @hono/*|hono) [[ ! " ${KEYWORDS[*]} " =~ " hono " ]] && KEYWORDS+=("hono") ;;
        # E-commerce
        @shopify/*|shopify-*) [[ ! " ${KEYWORDS[*]} " =~ " shopify " ]] && KEYWORDS+=("shopify") ;;
        @angular/*|angular) [[ ! " ${KEYWORDS[*]} " =~ " angular " ]] && KEYWORDS+=("angular") ;;
        # Databases & ORMs
        prisma|@prisma/*) [[ ! " ${KEYWORDS[*]} " =~ " prisma " ]] && KEYWORDS+=("prisma") ;;
        drizzle-orm|drizzle-kit) [[ ! " ${KEYWORDS[*]} " =~ " drizzle " ]] && KEYWORDS+=("drizzle") ;;
        # BaaS
        supabase|@supabase/*) [[ ! " ${KEYWORDS[*]} " =~ " supabase " ]] && KEYWORDS+=("supabase") ;;
        firebase|@firebase/*|firebase-admin) [[ ! " ${KEYWORDS[*]} " =~ " firebase " ]] && KEYWORDS+=("firebase") ;;
        # Testing
        vitest) [[ ! " ${KEYWORDS[*]} " =~ " vitest " ]] && KEYWORDS+=("vitest") ;;
        playwright|@playwright/*) [[ ! " ${KEYWORDS[*]} " =~ " playwright " ]] && KEYWORDS+=("playwright") ;;
        # State management
        pinia) [[ ! " ${KEYWORDS[*]} " =~ " pinia " ]] && KEYWORDS+=("pinia") ;;
        @tanstack/*) [[ ! " ${KEYWORDS[*]} " =~ " tanstack " ]] && KEYWORDS+=("tanstack") ;;
        zustand) [[ ! " ${KEYWORDS[*]} " =~ " zustand " ]] && KEYWORDS+=("zustand") ;;
      esac
    done

    if [ ${#KEYWORDS[@]} -eq 0 ]; then
      echo "  No technologies detected."
    else
      echo "  Detected: ${KEYWORDS[*]}"

      # Phase 1: Collect all available skills (30s timeout per search)
      TIMEOUT_CMD=""
      command -v timeout &>/dev/null && TIMEOUT_CMD="timeout 30"
      command -v gtimeout &>/dev/null && TIMEOUT_CMD="gtimeout 30"

      SKILL_PATTERN='^[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+@[a-zA-Z0-9_.-]+'

      # Search function with retry
      search_skills() {
        local kw=$1
        local result=""
        if [ -n "$TIMEOUT_CMD" ]; then
          result=$($TIMEOUT_CMD npx -y skills@latest find "$kw" 2>/dev/null \
            | sed 's/\x1b\[[0-9;]*m//g' \
            | grep -E "$SKILL_PATTERN" || true)
        else
          local tmp=$(mktemp)
          npx -y skills@latest find "$kw" > "$tmp" 2>/dev/null &
          local pid=$!
          local wait_s=0
          while kill -0 "$pid" 2>/dev/null && [ "$wait_s" -lt 30 ]; do
            sleep 1
            wait_s=$((wait_s + 1))
          done
          if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null || true
            wait "$pid" 2>/dev/null || true
          else
            wait "$pid" 2>/dev/null || true
            result=$(sed 's/\x1b\[[0-9;]*m//g' "$tmp" \
              | grep -E "$SKILL_PATTERN" || true)
          fi
          rm -f "$tmp"
        fi
        echo "$result"
      }

      ALL_SKILLS=""
      for kw in "${KEYWORDS[@]}"; do
        printf "  🔍 Searching: %s ..." "$kw"
        FOUND=$(search_skills "$kw")

        # Retry once on failure
        if [ -z "$FOUND" ]; then
          printf " (retrying)"
          sleep 1
          FOUND=$(search_skills "$kw")
        fi

        if [ -n "$FOUND" ]; then
          COUNT=$(echo "$FOUND" | wc -l | tr -d ' ')
          printf "\r  ✅ %-20s %s skills found%*s\n" "$kw:" "$COUNT" 15 ""
          ALL_SKILLS="${ALL_SKILLS}${FOUND}"$'\n'
        else
          printf "\r  ⚠️  %-20s no skills found%*s\n" "$kw:" 20 ""
        fi
      done

      # Remove duplicates
      ALL_SKILLS=$(echo "$ALL_SKILLS" | sort -u | sed '/^$/d')

      if [ -n "$ALL_SKILLS" ]; then
        TOTAL_FOUND=$(echo "$ALL_SKILLS" | wc -l | tr -d ' ')

        # Cache search results for fallback
        ALL_SKILLS_CACHE=$(mktemp)
        echo "$ALL_SKILLS" > "$ALL_SKILLS_CACHE"

        # Phase 1.5: Fetch weekly install counts from skills.sh (parallel)
        echo ""
        echo "  📊 Fetching popularity metrics from skills.sh..."
        echo "     (Used to rank skills by real-world usage)"
        INSTALLS_DIR=$(mktemp -d)
        while IFS= read -r sid; do
          if [ -n "$sid" ]; then
            URL_PATH=$(echo "$sid" | sed 's/@/\//')
            (
              COUNT=$(curl -s --max-time 5 "https://skills.sh/$URL_PATH" 2>/dev/null \
                | grep -oE '[0-9]+\.[0-9]+K|[0-9]+K' | head -1)
              echo "${COUNT:-0}" > "$INSTALLS_DIR/$(echo "$sid" | tr '/' '_')"
            ) &
          fi
        done <<< "$ALL_SKILLS"
        wait

        # Build skills list with install counts
        SKILLS_WITH_COUNTS=""
        while IFS= read -r sid; do
          if [ -n "$sid" ]; then
            SAFE_NAME=$(echo "$sid" | tr '/' '_')
            COUNT=$(cat "$INSTALLS_DIR/$SAFE_NAME" 2>/dev/null || echo "0")
            SKILLS_WITH_COUNTS="${SKILLS_WITH_COUNTS}${sid} (${COUNT} weekly installs)"$'\n'
          fi
        done <<< "$ALL_SKILLS"
        rm -rf "$INSTALLS_DIR"

        echo "  🤖 Claude selecting best skills ($TOTAL_FOUND found)..."

        # Phase 2: Claude selects the most relevant skills (haiku, 60s timeout)
        CLAUDE_TMP=$(mktemp)
        claude -p --model haiku --max-turns 1 "You are a skill curator for AI coding agents. Select the best skills for this project.

Project technologies: ${KEYWORDS[*]}

Available skills (with weekly install counts from skills.sh):
$SKILLS_WITH_COUNTS

Rules:
- Select EXACTLY the top 5 most relevant skills (or fewer if less available)
- Prefer skills with HIGHER install counts (more popular = better quality)
- Avoid duplicates (e.g. not 3x vue-best-practices from different authors)
- Prefer skills from well-known maintainers (antfu, vercel-labs, vuejs-ai, etc.)
- Reply ONLY with skill IDs, one per line, no other text. Format: owner/repo@skill-name" > "$CLAUDE_TMP" 2>/dev/null &
        CLAUDE_PID=$!
        CLAUDE_WAIT=0
        while kill -0 "$CLAUDE_PID" 2>/dev/null && [ "$CLAUDE_WAIT" -lt 60 ]; do
          sleep 1
          CLAUDE_WAIT=$((CLAUDE_WAIT + 1))
        done
        if kill -0 "$CLAUDE_PID" 2>/dev/null; then
          kill_tree "$CLAUDE_PID"
          echo "  ⚠️  Claude timed out (${CLAUDE_WAIT}s). Using fallback..."
          SELECTED=""
        else
          wait "$CLAUDE_PID" 2>/dev/null || true
          SELECTED=$(cat "$CLAUDE_TMP")
        fi
        rm -f "$CLAUDE_TMP"

        if [ -n "$SELECTED" ]; then
          # Extract only valid skill IDs, clean whitespace, strip backticks, enforce max 5
          SELECTED=$(echo "$SELECTED" \
            | sed 's/`//g' \
            | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
            | grep -E '^[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+@[a-zA-Z0-9_.-]+$' \
            | head -5)
        fi

        # Install a single skill with duplicate detection (uses $TIMEOUT_CMD if available)
        install_skill() {
          local sid=$1
          local skill_name="${sid##*@}"  # Extract skill name after @
          local owner_repo="${sid%@*}"
          local owner="${owner_repo%/*}"
          local repo="${owner_repo#*/}"

          # Check if already installed (local or global)
          if [ -d ".claude/skills/$skill_name" ] || [ -d "${HOME}/.claude/skills/$skill_name" ]; then
            printf "     ⏭️  %s (already installed)\n" "$sid"
            SKIPPED=$((SKIPPED + 1))
            return 0
          fi

          # Verify skill exists on skills.sh registry before attempting install
          if command -v curl >/dev/null 2>&1; then
            local status
            status=$(curl -s -o /dev/null -w "%{http_code}" \
              "https://skills.sh/$owner/$repo/$skill_name" 2>/dev/null)
            if [ "$status" != "200" ]; then
              printf "     ⚠️  %s (not in registry, skipping)\n" "$sid"
              return 0
            fi
          fi

          printf "     ⏳ %s ..." "$sid"
          if ${TIMEOUT_CMD:-} npx -y skills@latest add "$sid" --agent claude-code --agent github-copilot -y </dev/null >/dev/null 2>&1; then
            printf "\r     ✅ %s\n" "$sid"
            return 0
          else
            printf "\r     ❌ %s (install failed)\n" "$sid"
            return 1
          fi
        }

        if [ -n "$SELECTED" ]; then
          SELECTED_COUNT=$(echo "$SELECTED" | wc -l | tr -d ' ')
          echo "  ✨ $SELECTED_COUNT skills selected:"
          echo ""

          # Phase 3: Install selected skills (30s timeout per install)
          while IFS= read -r skill_id; do
            skill_id=$(echo "$skill_id" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            if [ -n "$skill_id" ]; then
              install_skill "$skill_id" && INSTALLED=$((INSTALLED + 1))
            fi
          done <<< "$SELECTED"
          echo ""
          if [ $SKIPPED -gt 0 ]; then
            echo "  Total: $INSTALLED installed, $SKIPPED skipped (already present)"
          else
            echo "  Total: $INSTALLED skills installed"
          fi
        else
          echo "  ⚠️  Claude could not select skills. Installing top 3 per technology..."
          # Fallback: Top 3 per keyword using cached results
          for kw in "${KEYWORDS[@]}"; do
            SKILL_IDS=$(grep -iE "$kw" "$ALL_SKILLS_CACHE" 2>/dev/null | head -3)
            if [ -n "$SKILL_IDS" ]; then
              while IFS= read -r skill_id; do
                skill_id=$(echo "$skill_id" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                if [ -n "$skill_id" ]; then
                  install_skill "$skill_id" && INSTALLED=$((INSTALLED + 1))
                fi
              done <<< "$SKILL_IDS"
            fi
          done
          echo ""
          if [ $SKIPPED -gt 0 ]; then
            echo "  Total: $INSTALLED installed, $SKIPPED skipped (fallback)"
          else
            echo "  Total: $INSTALLED skills installed (fallback)"
          fi
        fi
        rm -f "$ALL_SKILLS_CACHE"
      fi
    fi
  else
    echo "  No package.json found."
  fi

  # System-specific default skills (always installed for known systems)
  # Support multiple systems (comma-separated)
  SYSTEM_SKILLS=()
  IFS=',' read -ra SYSTEMS <<< "$SYSTEM"
  for sys in "${SYSTEMS[@]}"; do
    case "$sys" in
      shopify)
        SYSTEM_SKILLS+=(
          "sickn33/antigravity-awesome-skills@shopify-development"
          "jeffallan/claude-skills@shopify-expert"
          "henkisdabro/wookstar-claude-code-plugins@shopify-theme-dev"
        ) ;;
      nuxt)
        SYSTEM_SKILLS+=(
          "antfu/skills@nuxt"
          "onmax/nuxt-skills@nuxt"
          "onmax/nuxt-skills@vue"
          "onmax/nuxt-skills@vueuse"
        ) ;;
      next)
        SYSTEM_SKILLS+=(
          "vercel-labs/agent-skills@vercel-react-best-practices"
          "jeffallan/claude-skills@nextjs-developer"
          "wshobson/agents@nextjs-app-router-patterns"
        ) ;;
      laravel)
        SYSTEM_SKILLS+=(
          "jeffallan/claude-skills@laravel-specialist"
          "iserter/laravel-claude-agents@eloquent-best-practices"
        ) ;;
      shopware)
        SYSTEM_SKILLS+=(
          "bartundmett/skills@shopware6-best-practices"
        ) ;;
      storyblok)
        SYSTEM_SKILLS+=(
          "bartundmett/skills@storyblok-best-practices"
        ) ;;
    esac
  done

  if [ ${#SYSTEM_SKILLS[@]} -gt 0 ]; then
    echo ""
    echo "  📦 Installing system-specific skills ($SYSTEM)..."

    TIMEOUT_CMD=""
    command -v timeout &>/dev/null && TIMEOUT_CMD="timeout 30"
    command -v gtimeout &>/dev/null && TIMEOUT_CMD="gtimeout 30"

    for skill_id in "${SYSTEM_SKILLS[@]}"; do
      install_skill "$skill_id" && INSTALLED=$((INSTALLED + 1))
    done
  fi

  set -e
}

# ==============================================================================
# REGENERATE MODE (--regenerate flag)
# ==============================================================================
if [ "$REGENERATE" = "yes" ]; then
  if ! command -v claude &>/dev/null; then
    echo "❌ Claude CLI required for regeneration."
    echo "   Install: npm i -g @anthropic-ai/claude-code"
    exit 1
  fi

  # Select system if not provided via --system flag
  if [ -z "$SYSTEM" ]; then
    # Try to restore from previous run stored in .ai-setup.json
    if [ -f .ai-setup.json ] && jq -e . .ai-setup.json >/dev/null 2>&1; then
      STORED_SYSTEM=$(jq -r '.system // empty' .ai-setup.json 2>/dev/null)
      if [ -n "$STORED_SYSTEM" ] && [ "$STORED_SYSTEM" != "auto" ]; then
        SYSTEM="$STORED_SYSTEM"
        echo "  🔍 Restored system from previous run: $SYSTEM"
      fi
    fi
  fi
  if [ -z "$SYSTEM" ]; then
    select_system
  fi
  detect_system

  run_generation

  echo ""
  echo "✅ Regeneration complete! (System: $SYSTEM)"
  echo "   - CLAUDE.md updated"
  [ -d .agents/context ] && echo "   - .agents/context/ regenerated"
  [ ${INSTALLED:-0} -gt 0 ] && echo "   - $INSTALLED skills installed"
  exit 0
fi

# ==============================================================================
# AUTO-DETECT: UPDATE / REINSTALL / FRESH INSTALL
# ==============================================================================
if [ -f .ai-setup.json ] && jq -e . .ai-setup.json >/dev/null 2>&1; then
  INSTALLED_VERSION=$(get_installed_version)
  PACKAGE_VERSION=$(get_package_version)

  if [ -n "$INSTALLED_VERSION" ] && [ "$INSTALLED_VERSION" = "$PACKAGE_VERSION" ]; then
    # Same version — already up to date
    echo ""
    echo "✅ Already up to date (v${PACKAGE_VERSION})."
    echo ""
    if command -v claude &>/dev/null; then
      read -p "   Regenerate AI content (CLAUDE.md, context, skills)? (y/N) " REGEN_CHOICE
      if [[ "$REGEN_CHOICE" =~ ^[Yy]$ ]]; then
        if [ -z "$SYSTEM" ]; then
          select_system
        fi
        detect_system
        run_generation
        write_metadata
        echo ""
        echo "✅ Regeneration complete!"
      fi
    fi
    exit 0

  elif [ -n "$INSTALLED_VERSION" ]; then
    # Different version — offer update options
    echo ""
    echo "🔄 Update available: v${INSTALLED_VERSION} → v${PACKAGE_VERSION}"
    echo ""
    echo "   1) Update       — smart update (backup modified files, update templates)"
    echo "   2) Reinstall    — delete managed files, fresh install from scratch"
    echo "   3) Skip         — exit without changes"
    echo ""
    read -p "   Choose [1/2/3]: " UPDATE_CHOICE

    case "$UPDATE_CHOICE" in
      1)
        # ----------------------------------------------------------------
        # SMART UPDATE
        # ----------------------------------------------------------------
        echo ""
        echo "🔍 Analyzing templates..."
        echo ""

        UPD_UPDATED=0
        UPD_SKIPPED=0
        UPD_NEW=0
        UPD_BACKED_UP=0

        for mapping in "${TEMPLATE_MAP[@]}"; do
          tpl="${mapping%%:*}"
          target="${mapping#*:}"

          # Target doesn't exist — install as new
          if [ ! -f "$target" ]; then
            if [ -f "$SCRIPT_DIR/$tpl" ]; then
              mkdir -p "$(dirname "$target")"
              cp "$SCRIPT_DIR/$tpl" "$target"
              [[ "$target" == *.sh ]] && chmod +x "$target"
              echo "  ✨ $target (new)"
              UPD_NEW=$((UPD_NEW + 1))
            fi
            continue
          fi

          # Compare template to installed file
          tpl_cs=$(compute_checksum "$SCRIPT_DIR/$tpl")
          cur_cs=$(compute_checksum "$target")

          if [ "$tpl_cs" = "$cur_cs" ]; then
            # Template and installed file are identical — skip
            echo "  ⏭️  $target (unchanged)"
            UPD_SKIPPED=$((UPD_SKIPPED + 1))
            continue
          fi

          # Template differs — check if user modified the file
          stored_cs=$(jq -r --arg f "$target" '.files[$f] // empty' .ai-setup.json 2>/dev/null)

          if [ -n "$stored_cs" ] && [ "$stored_cs" != "$cur_cs" ]; then
            # User modified — backup first
            bp=$(backup_file "$target")
            cp "$SCRIPT_DIR/$tpl" "$target"
            [[ "$target" == *.sh ]] && chmod +x "$target"
            echo "  ⚠️  $target (user-modified — backed up to $bp)"
            UPD_BACKED_UP=$((UPD_BACKED_UP + 1))
          else
            # Not modified by user — silent update
            cp "$SCRIPT_DIR/$tpl" "$target"
            [[ "$target" == *.sh ]] && chmod +x "$target"
            echo "  ✅ $target (updated)"
          fi
          UPD_UPDATED=$((UPD_UPDATED + 1))
        done

        echo ""
        echo "📊 Update summary:"
        echo "   Updated:   $UPD_UPDATED"
        [ $UPD_NEW -gt 0 ] && echo "   New:       $UPD_NEW"
        [ $UPD_SKIPPED -gt 0 ] && echo "   Unchanged: $UPD_SKIPPED"
        [ $UPD_BACKED_UP -gt 0 ] && echo "   Backed up: $UPD_BACKED_UP (see .ai-setup-backup/)"

        # Update metadata
        write_metadata

        # Offer regeneration
        if command -v claude &>/dev/null; then
          echo ""
          read -p "   Regenerate AI content? (Y/n) " REGEN_CHOICE
          if [[ ! "$REGEN_CHOICE" =~ ^[Nn]$ ]]; then
            if [ -z "$SYSTEM" ]; then
              select_system
            fi
            detect_system
            run_generation
            write_metadata
          fi
        fi

        echo ""
        echo "✅ Update complete! (v${INSTALLED_VERSION} → v${PACKAGE_VERSION})"
        exit 0
        ;;

      2)
        # ----------------------------------------------------------------
        # CLEAN REINSTALL
        # ----------------------------------------------------------------
        echo ""
        echo "🗑️  Removing managed files..."

        for mapping in "${TEMPLATE_MAP[@]}"; do
          target="${mapping#*:}"
          if [ -f "$target" ]; then
            rm -f "$target"
            echo "   Removed: $target"
          fi
        done

        # Remove metadata and backup dir
        rm -f .ai-setup.json
        echo ""
        echo "   Clean slate ready. Running fresh install..."
        echo ""
        # Fall through to normal setup below
        ;;

      *)
        echo "   Skipped. No changes made."
        exit 0
        ;;
    esac
  fi
fi

# ==============================================================================
# NORMAL SETUP MODE
# ==============================================================================
echo "🚀 Starting AI Setup (Claude Code + Skills)..."

# ------------------------------------------------------------------------------
# 0. REQUIREMENTS CHECK
# ------------------------------------------------------------------------------
MISSING=()
! command -v node &>/dev/null && MISSING+=("node (>= 18)")
! command -v npm &>/dev/null && MISSING+=("npm")
! command -v jq &>/dev/null && MISSING+=("jq (brew install jq)")

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "❌ Missing requirements:"
  for m in "${MISSING[@]}"; do echo "   - $m"; done
  echo ""
  echo "Install the missing tools and try again."
  exit 1
fi

# Node.js version check (>= 18)
NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//' | cut -d. -f1)
if [ -n "$NODE_VERSION" ] && [ "$NODE_VERSION" -lt 18 ]; then
  echo "❌ Node.js >= 18 required (found v$NODE_VERSION)"
  exit 1
fi

# Template directory validation
if [ ! -d "$TPL" ]; then
  echo "❌ Template directory not found: $TPL"
  echo "   The package may be corrupted. Try: npm cache clean --force && npx @onedot/ai-setup"
  exit 1
fi

# AI CLI detection (optional, for Auto-Init)
AI_CLI=""
if command -v claude &>/dev/null; then
  AI_CLI="claude"
elif command -v gh &>/dev/null && gh copilot --version &>/dev/null 2>&1; then
  AI_CLI="copilot"
fi
echo "✅ Requirements OK (AI CLI: ${AI_CLI:-none detected})"

# ------------------------------------------------------------------------------
# 1. CLEANUP (detect and remove legacy AI structures)
# ------------------------------------------------------------------------------
FOUND=()
[ -d ".ai" ] && FOUND+=(".ai/")
[ -d ".claude/skills/create-spec" ] && FOUND+=(".claude/skills/create-spec/")
[ -d ".claude/skills/spec-work" ] && FOUND+=(".claude/skills/spec-work/")
[ -d ".claude/skills/template-skill" ] && FOUND+=(".claude/skills/template-skill/")
[ -d ".claude/skills/learn" ] && FOUND+=(".claude/skills/learn/")
[ -f ".claude/INIT.md" ] && FOUND+=(".claude/INIT.md")
[ -d "skills/" ] && FOUND+=("skills/")
[ -d ".skillkit/" ] && FOUND+=(".skillkit/")
[ -f "skillkit.yaml" ] && FOUND+=("skillkit.yaml")

if [ ${#FOUND[@]} -gt 0 ]; then
  echo "⚠️  Legacy AI structures found:"
  for f in "${FOUND[@]}"; do echo "   - $f"; done
  echo ""
  read -p "Delete? (Y/n) " CLEANUP
  if [[ ! "$CLEANUP" =~ ^[Nn]$ ]]; then
    for f in "${FOUND[@]}"; do rm -rf "$f"; done
    echo "✅ Cleanup done."
  else
    echo "⏭️  Cleanup skipped."
  fi
else
  echo "✅ No legacy structures found."
fi

# ------------------------------------------------------------------------------
# 2. CLAUDE.md
# ------------------------------------------------------------------------------
echo "📝 Writing CLAUDE.md..."

if [ ! -f CLAUDE.md ]; then
  cp "$TPL/CLAUDE.md" CLAUDE.md
  echo "  CLAUDE.md created (template — customize as needed)."
else
  echo "  CLAUDE.md already exists, skipping."
fi

# ------------------------------------------------------------------------------
# 3. SETTINGS.JSON (granular permissions)
# ------------------------------------------------------------------------------
echo "⚙️  Writing .claude/settings.json..."
mkdir -p .claude

if [ ! -f .claude/settings.json ]; then
  cp "$TPL/claude/settings.json" .claude/settings.json
else
  echo "  .claude/settings.json already exists, skipping."
fi

# ------------------------------------------------------------------------------
# 4. HOOKS
# ------------------------------------------------------------------------------
echo "🛡️  Creating hooks..."
mkdir -p .claude/hooks

for hook in protect-files.sh post-edit-lint.sh circuit-breaker.sh context-freshness.sh; do
  if [ ! -f ".claude/hooks/$hook" ]; then
    cp "$TPL/claude/hooks/$hook" ".claude/hooks/$hook"
    chmod +x ".claude/hooks/$hook"
  else
    echo "  .claude/hooks/$hook already exists, skipping."
  fi
done

# ------------------------------------------------------------------------------
# 5. COPILOT INSTRUCTIONS
# ------------------------------------------------------------------------------
mkdir -p .github

if [ ! -f .github/copilot-instructions.md ]; then
  cp "$TPL/github/copilot-instructions.md" .github/copilot-instructions.md
else
  echo "  .github/copilot-instructions.md already exists, skipping."
fi

# ------------------------------------------------------------------------------
# 6. AGENTS DIRECTORY
# ------------------------------------------------------------------------------
mkdir -p .agents

# ------------------------------------------------------------------------------
# 6b. SPECS DIRECTORY (spec-driven development)
# ------------------------------------------------------------------------------
echo "📋 Setting up spec-driven workflow..."
mkdir -p specs/completed
[ ! -f specs/TEMPLATE.md ] && cp "$TPL/specs/TEMPLATE.md" specs/TEMPLATE.md
[ ! -f specs/README.md ] && cp "$TPL/specs/README.md" specs/README.md
[ ! -f specs/completed/.gitkeep ] && touch specs/completed/.gitkeep

# ------------------------------------------------------------------------------
# 6c. SLASH COMMANDS
# ------------------------------------------------------------------------------
echo "⚡ Installing slash commands..."
mkdir -p .claude/commands
for cmd in spec.md spec-work.md commit.md pr.md review.md test.md techdebt.md grill.md; do
  if [ ! -f ".claude/commands/$cmd" ]; then
    cp "$TPL/commands/$cmd" ".claude/commands/$cmd"
  else
    echo "  .claude/commands/$cmd already exists, skipping."
  fi
done

# ------------------------------------------------------------------------------
# 6d. SUBAGENT TEMPLATES
# ------------------------------------------------------------------------------
echo "🤖 Installing subagent templates..."
mkdir -p .claude/agents
for agent in verify-app.md build-validator.md staff-reviewer.md context-refresher.md; do
  if [ ! -f ".claude/agents/$agent" ]; then
    cp "$TPL/agents/$agent" ".claude/agents/$agent"
  else
    echo "  .claude/agents/$agent already exists, skipping."
  fi
done

# ------------------------------------------------------------------------------
# 6e. METADATA TRACKING
# ------------------------------------------------------------------------------
echo "📋 Writing installation metadata..."
write_metadata

# ------------------------------------------------------------------------------
# 7. GITIGNORE
# ------------------------------------------------------------------------------
if [ -f .gitignore ]; then
  if ! grep -q "claude/settings.local" .gitignore 2>/dev/null; then
    echo "" >> .gitignore
    echo "# Claude Code / AI Setup" >> .gitignore
    echo ".claude/settings.local.json" >> .gitignore
    echo ".ai-setup.json" >> .gitignore
    echo ".ai-setup-backup/" >> .gitignore
    echo ".agents/context/.state" >> .gitignore
  else
    # Add new entries if missing from existing block
    grep -q "\.ai-setup\.json" .gitignore 2>/dev/null || echo ".ai-setup.json" >> .gitignore
    grep -q "\.ai-setup-backup" .gitignore 2>/dev/null || echo ".ai-setup-backup/" >> .gitignore
    grep -q "\.agents/context/\.state" .gitignore 2>/dev/null || echo ".agents/context/.state" >> .gitignore
  fi
else
  echo "# Claude Code / AI Setup" > .gitignore
  echo ".claude/settings.local.json" >> .gitignore
  echo ".ai-setup.json" >> .gitignore
  echo ".ai-setup-backup/" >> .gitignore
  echo ".agents/context/.state" >> .gitignore
fi

# ------------------------------------------------------------------------------
# 8. GSD INSTALL (optional — opt-in)
# ------------------------------------------------------------------------------
if [ "$WITH_GSD" = "" ]; then
  echo ""
  echo "📦 GSD (Get Shit Done) is a workflow engine for structured AI development."
  echo "   It adds phase planning, codebase mapping, and session management."
  echo "   More info: https://github.com/get-shit-done-cc/get-shit-done-cc"
  echo ""
  read -p "   Install GSD? (y/N) " INSTALL_GSD
  [[ "$INSTALL_GSD" =~ ^[Yy]$ ]] && WITH_GSD="yes" || WITH_GSD="no"
fi

if [ "$WITH_GSD" = "yes" ]; then
  GSD_GLOBAL_DIR="${HOME}/.claude/commands/gsd"
  if [ -d "$GSD_GLOBAL_DIR" ] || [ -d ".claude/commands/gsd" ] || [ -d ".claude/get-shit-done" ]; then
    echo "🎯 GSD already installed, skipping."
  else
    echo "🎯 Installing GSD (Get Shit Done) globally..."

    # Run in background with progress spinner
    npx -y get-shit-done-cc@latest --claude --global >/dev/null 2>&1 &
    GSD_PID=$!

    # Simple spinner
    SPIN='-\|/'
    i=0
    while kill -0 $GSD_PID 2>/dev/null; do
      i=$(( (i+1) %4 ))
      printf "\r  ${SPIN:$i:1} Installing... (may take 30-60 seconds)"
      sleep 0.2
    done

    GSD_EXIT=0
    wait $GSD_PID 2>/dev/null || GSD_EXIT=$?

    if [ $GSD_EXIT -eq 0 ]; then
      printf "\r  ✅ GSD installed successfully%*s\n" 40 ""
    else
      printf "\r  ⚠️  GSD installation failed. Manual: npx get-shit-done-cc@latest --claude --global\n"
    fi
  fi

  # GSD Companion Skill (global)
  GSD_SKILL_GLOBAL="${HOME}/.claude/skills/gsd"
  if [ -d "$GSD_SKILL_GLOBAL" ] || [ -d ".claude/skills/gsd" ]; then
    echo "  GSD Companion Skill already installed, skipping."
  else
    npx skills add https://github.com/ctsstc/get-shit-done-skills --skill gsd --agent claude-code --agent github-copilot -g -y 2>/dev/null || echo "  Skills CLI not available, skipping."
  fi

  # Append GSD workflow to CLAUDE.md
  if [ -f CLAUDE.md ] && ! grep -q "Workflow (GSD)" CLAUDE.md 2>/dev/null; then
    cat >> CLAUDE.md << 'GSDEOF'

## Workflow (GSD)
1. `/gsd:map-codebase` - Analyze existing code (brownfield)
2. `/gsd:new-project` - Initialize project planning
3. `/gsd:plan-phase N` - Plan next phase
4. `/gsd:execute-phase N` - Execute phase
5. `/gsd:verify-work N` - User acceptance testing
GSDEOF
  fi

  # Append GSD lines to copilot-instructions.md
  if [ -f .github/copilot-instructions.md ] && ! grep -q "planning/PROJECT" .github/copilot-instructions.md 2>/dev/null; then
    echo "- **MUST READ**: \`.planning/PROJECT.md\` for project identity and goals" >> .github/copilot-instructions.md
    echo "- GSD workflow in \`.planning/\` for task management" >> .github/copilot-instructions.md
  fi
else
  echo "⏭️  GSD skipped."
fi

# ------------------------------------------------------------------------------
# 9. PLUGINS & EXTENSIONS
# ------------------------------------------------------------------------------
echo ""
echo "================================================================"
echo "PLUGINS & EXTENSIONS"
echo "================================================================"

# --- 9a. Claude-Mem (Marketplace Plugin — persistent memory) -----------------
CLAUDE_MEM_DIR="${HOME}/.claude/plugins/cache/thedotmack/claude-mem"
PENDING_PLUGINS=""

if [ "$WITH_CLAUDE_MEM" = "" ]; then
  echo ""
  echo "🧠 Claude-Mem adds persistent memory across Claude Code sessions."
  echo "   Every decision, bug fix, and architectural choice — remembered automatically."
  echo "   More info: https://claude-mem.ai"
  echo ""
  read -p "   Install Claude-Mem? (y/N) " INSTALL_CMEM
  [[ "$INSTALL_CMEM" =~ ^[Yy]$ ]] && WITH_CLAUDE_MEM="yes" || WITH_CLAUDE_MEM="no"
fi

if [ "$WITH_CLAUDE_MEM" = "yes" ]; then
  if [ -d "$CLAUDE_MEM_DIR" ]; then
    echo "  🧠 Claude-Mem already installed, skipping."
  else
    # Merge extraKnownMarketplaces + enabledPlugins into .claude/settings.json
    if command -v jq &>/dev/null && [ -f .claude/settings.json ]; then
      CLAUDE_MEM_MERGE='{
        "extraKnownMarketplaces": {
          "thedotmack": {
            "source": { "source": "github", "repo": "thedotmack/claude-mem" }
          }
        },
        "enabledPlugins": {
          "claude-mem@thedotmack": true
        }
      }'
      TMP_SETTINGS=$(mktemp)
      jq --argjson merge "$CLAUDE_MEM_MERGE" '. * $merge' .claude/settings.json > "$TMP_SETTINGS" && mv "$TMP_SETTINGS" .claude/settings.json
      echo "  🧠 Claude-Mem marketplace registered in .claude/settings.json"
    fi

    # Try CLI install (works if claude is available)
    if command -v claude &>/dev/null; then
      echo "  🧠 Attempting Claude-Mem install via CLI..."
      if claude plugin install claude-mem@thedotmack --scope project 2>/dev/null; then
        echo "  ✅ Claude-Mem installed via CLI"
      else
        PENDING_PLUGINS="${PENDING_PLUGINS}claude-mem "
        echo "  📋 Claude-Mem registered — will be prompted on next Claude Code session"
      fi
    else
      PENDING_PLUGINS="${PENDING_PLUGINS}claude-mem "
      echo "  📋 Claude-Mem registered — teammates will be prompted to install when they trust this project"
    fi
  fi
else
  echo "⏭️  Claude-Mem skipped."
fi

# --- 9b. Official Claude Code Plugins (code-review, feature-dev, etc.) -------
OFFICIAL_PLUGINS=(
  "code-review:Automated PR review with 4 parallel agents + confidence scoring"
  "feature-dev:7-phase feature workflow (discovery → architecture → review)"
  "frontend-design:Anti-generic design guidance for frontend projects"
)

if [ "$WITH_PLUGINS" = "" ]; then
  echo ""
  echo "🔌 Official Claude Code Plugins (from Anthropic):"
  echo ""
  for i in "${!OFFICIAL_PLUGINS[@]}"; do
    IFS=':' read -r pname pdesc <<< "${OFFICIAL_PLUGINS[$i]}"
    printf "   [%d] %-18s %s\n" "$((i+1))" "$pname" "$pdesc"
  done
  echo ""
  echo "   [a] All plugins    [n] None"
  echo ""
  read -p "   Select plugins (comma-separated numbers, a=all, n=none): " PLUGIN_CHOICE
  case "$PLUGIN_CHOICE" in
    [Nn]) WITH_PLUGINS="no" ;;
    [Aa]) WITH_PLUGINS="yes"; SELECTED_PLUGINS="1,2,3,4" ;;
    *)    WITH_PLUGINS="yes"; SELECTED_PLUGINS="$PLUGIN_CHOICE" ;;
  esac
fi

if [ "$WITH_PLUGINS" = "yes" ]; then
  # Default to all if flag used without interactive selection
  [ -z "$SELECTED_PLUGINS" ] && SELECTED_PLUGINS="1,2,3,4"

  INSTALLED_PLUGINS=""
  for idx in $(echo "$SELECTED_PLUGINS" | tr ',' ' '); do
    idx=$(echo "$idx" | tr -d ' ')
    [ -z "$idx" ] && continue
    PIDX=$((idx - 1))
    [ $PIDX -lt 0 ] || [ $PIDX -ge ${#OFFICIAL_PLUGINS[@]} ] && continue

    IFS=':' read -r PNAME PDESC <<< "${OFFICIAL_PLUGINS[$PIDX]}"

    # Check if already installed (plugin cache or .claude/settings.json)
    if [ -d "${HOME}/.claude/plugins/cache/anthropics/${PNAME}" ] 2>/dev/null; then
      echo "  🔌 ${PNAME} already installed, skipping."
      continue
    fi

    # Try CLI install
    if command -v claude &>/dev/null; then
      echo "  🔌 Installing ${PNAME}..."
      if claude plugin install "${PNAME}" --scope project 2>/dev/null; then
        INSTALLED_PLUGINS="${INSTALLED_PLUGINS}${PNAME} "
        echo "  ✅ ${PNAME} installed"
      else
        PENDING_PLUGINS="${PENDING_PLUGINS}${PNAME} "
        echo "  📋 ${PNAME} — install manually: /plugin install ${PNAME}"
      fi
    else
      PENDING_PLUGINS="${PENDING_PLUGINS}${PNAME} "
      echo "  📋 ${PNAME} — install manually: /plugin install ${PNAME}"
    fi
  done
elif [ "$WITH_PLUGINS" = "no" ]; then
  echo "⏭️  Official plugins skipped."
fi

# --- 9c. Context7 MCP Server (up-to-date library docs) ----------------------
if [ "$WITH_CONTEXT7" = "" ]; then
  echo ""
  echo "📚 Context7 fetches up-to-date library docs directly into Claude's context."
  echo "   No more hallucinated APIs or outdated code examples. 45k+ ⭐ on GitHub."
  echo "   Works via MCP Server — add \"use context7\" to any prompt."
  echo ""
  read -p "   Install Context7? (y/N) " INSTALL_CTX7
  [[ "$INSTALL_CTX7" =~ ^[Yy]$ ]] && WITH_CONTEXT7="yes" || WITH_CONTEXT7="no"
fi

if [ "$WITH_CONTEXT7" = "yes" ]; then
  # Create or merge .mcp.json
  CTX7_CONFIG='{"mcpServers":{"context7":{"command":"npx","args":["-y","@upstash/context7-mcp"]}}}'

  if [ -f .mcp.json ]; then
    if grep -q '"context7"' .mcp.json 2>/dev/null; then
      echo "  📚 Context7 already configured in .mcp.json, skipping."
    elif command -v jq &>/dev/null; then
      TMP_MCP=$(mktemp)
      jq --argjson ctx "$CTX7_CONFIG" '.mcpServers += $ctx.mcpServers' .mcp.json > "$TMP_MCP" && mv "$TMP_MCP" .mcp.json
      echo "  📚 Context7 MCP server added to .mcp.json"
    else
      echo "  ⚠️  .mcp.json exists but jq not available to merge. Add manually."
    fi
  else
    echo "$CTX7_CONFIG" | jq '.' > .mcp.json 2>/dev/null || echo "$CTX7_CONFIG" > .mcp.json
    echo "  📚 Context7 MCP server configured in .mcp.json"
  fi

  # Add Context7 rule to CLAUDE.md
  if [ -f CLAUDE.md ] && ! grep -q "context7" CLAUDE.md 2>/dev/null; then
    cat >> CLAUDE.md << 'CTX7EOF'

## Documentation Lookup
Always use Context7 MCP when you need library/API documentation, code generation,
setup or configuration steps. Add "use context7" to prompts or it will be auto-invoked.
CTX7EOF
    echo "  📚 Context7 rule added to CLAUDE.md"
  fi
else
  echo "⏭️  Context7 skipped."
fi

# --- 9c2. Playwright MCP Server (UI verification via browser automation) ------
if [ "$WITH_PLAYWRIGHT" = "" ]; then
  echo ""
  echo "🎭 Playwright MCP enables Claude to interact with web browsers for UI verification."
  echo "   Useful for testing UI changes, taking screenshots, and validating frontend behavior."
  echo ""
  read -p "   Install Playwright MCP? (y/N) " INSTALL_PW
  [[ "$INSTALL_PW" =~ ^[Yy]$ ]] && WITH_PLAYWRIGHT="yes" || WITH_PLAYWRIGHT="no"
fi

if [ "$WITH_PLAYWRIGHT" = "yes" ]; then
  PW_CONFIG='{"mcpServers":{"playwright":{"command":"npx","args":["-y","@anthropic-ai/mcp-playwright"]}}}'

  if [ -f .mcp.json ]; then
    if grep -q '"playwright"' .mcp.json 2>/dev/null; then
      echo "  🎭 Playwright already configured in .mcp.json, skipping."
    elif command -v jq &>/dev/null; then
      TMP_MCP=$(mktemp)
      jq --argjson pw "$PW_CONFIG" '.mcpServers += $pw.mcpServers' .mcp.json > "$TMP_MCP" && mv "$TMP_MCP" .mcp.json
      echo "  🎭 Playwright MCP server added to .mcp.json"
    else
      echo "  ⚠️  .mcp.json exists but jq not available to merge. Add manually."
    fi
  else
    echo "$PW_CONFIG" | jq '.' > .mcp.json 2>/dev/null || echo "$PW_CONFIG" > .mcp.json
    echo "  🎭 Playwright MCP server configured in .mcp.json"
  fi
else
  echo "⏭️  Playwright MCP skipped."
fi

# --- 9d. Plugin summary -----------------------------------------------------
if [ -n "$PENDING_PLUGINS" ]; then
  echo ""
  echo "  ⚡ Pending plugin installations (run in a Claude Code session):"
  for PP in $PENDING_PLUGINS; do
    case "$PP" in
      claude-mem)
        echo "     /plugin marketplace add thedotmack/claude-mem"
        echo "     /plugin install claude-mem"
        ;;
      *)
        echo "     /plugin install ${PP}"
        ;;
    esac
  done
  echo ""
  echo "  Then restart Claude Code."
fi

# ------------------------------------------------------------------------------
# 10. AUTO-INIT (Claude populates CLAUDE.md + generates project context)
# ------------------------------------------------------------------------------
echo ""
echo "✅ Setup complete!"
echo ""

if [ "$AI_CLI" = "claude" ]; then
  read -p "🤖 Run Auto-Init now? (Y/n) " RUN_INIT
  if [[ ! "$RUN_INIT" =~ ^[Nn]$ ]]; then
    # Select system if not provided via --system flag
    if [ -z "$SYSTEM" ]; then
      select_system
    fi
    detect_system

    run_generation

    echo ""
    echo "✅ Auto-Init complete!"
    if [ "$WITH_GSD" = "yes" ]; then
      osascript -e 'display notification "Auto-Init complete. Run /gsd:map-codebase for deeper analysis" with title "AI Setup" sound name "Glass"' 2>/dev/null
    else
      osascript -e 'display notification "Auto-Init complete!" with title "AI Setup" sound name "Glass"' 2>/dev/null
    fi
  fi
elif [ "$AI_CLI" = "copilot" ]; then
  echo "💡 GitHub Copilot detected (no claude CLI)."
  echo "   Manual steps required:"
  echo ""
  echo "   1. Open VS Code / GitHub Copilot Chat"
  echo "   2. Ask Copilot to extend CLAUDE.md with Commands and Critical Rules"
  if [ "$WITH_GSD" = "yes" ]; then
    echo "   3. Run /gsd:map-codebase and /gsd:new-project"
  fi
else
  echo "⚠️  No AI CLI detected (neither claude nor gh copilot)."
  echo "   Install Claude Code: npm i -g @anthropic-ai/claude-code"
  echo "   Then run the setup steps in NEXT STEPS below"
fi

echo ""
echo "🎉 AI Setup complete! Your project is ready for AI-assisted development."
echo ""
echo "================================================================"
echo "INSTALLATION SUMMARY"
echo "================================================================"
echo ""
echo "✅ Files created:"
[ -f CLAUDE.md ] && echo "   - CLAUDE.md (project rules)"
[ -f .claude/settings.json ] && echo "   - .claude/settings.json (permissions)"
[ -f .github/copilot-instructions.md ] && echo "   - .github/copilot-instructions.md"
echo "   - .claude/hooks/ (protect-files, post-edit-lint, circuit-breaker, context-freshness)"
[ -f .mcp.json ] && echo "   - .mcp.json (MCP server config)"
[ -d specs ] && echo "   - specs/ (spec-driven workflow)"
[ -d .claude/commands ] && echo "   - .claude/commands/ (spec, spec-work, commit, pr, review, test, techdebt, grill)"
[ -d .claude/agents ] && echo "   - .claude/agents/ (verify-app, build-validator, staff-reviewer, context-refresher)"

if [ "$WITH_GSD" = "yes" ] || [ "$WITH_CLAUDE_MEM" = "yes" ] || [ "$WITH_PLUGINS" = "yes" ] || [ "$WITH_CONTEXT7" = "yes" ] || [ "$WITH_PLAYWRIGHT" = "yes" ]; then
  echo ""
  echo "✅ Tools & Plugins:"
  [ "$WITH_GSD" = "yes" ] && [ -d "${HOME}/.claude/commands/gsd" ] && echo "   - GSD (Get Shit Done) - globally in ~/.claude/"
  [ "$WITH_GSD" = "yes" ] && [ -d "${HOME}/.claude/skills/gsd" ] && echo "   - GSD Companion Skill"
  if [ "$WITH_CLAUDE_MEM" = "yes" ]; then
    if [ -d "$CLAUDE_MEM_DIR" ]; then
      echo "   - Claude-Mem (persistent memory) ✅"
    else
      echo "   - Claude-Mem (pending — run install commands in Claude Code)"
    fi
  fi
  [ -n "$INSTALLED_PLUGINS" ] && echo "   - Plugins: ${INSTALLED_PLUGINS}"
  [ "$WITH_CONTEXT7" = "yes" ] && [ -f .mcp.json ] && echo "   - Context7 MCP server (.mcp.json)"
  [ "$WITH_PLAYWRIGHT" = "yes" ] && [ -f .mcp.json ] && echo "   - Playwright MCP server (.mcp.json)"
  if [ -n "$PENDING_PLUGINS" ]; then
    echo "   - ⚠️  Pending plugins: ${PENDING_PLUGINS}(see install commands above)"
  fi
fi

if [ "$AI_CLI" = "claude" ] && [[ ! "$RUN_INIT" =~ ^[Nn]$ ]]; then
  echo ""
  echo "✅ Auto-Init completed (System: ${SYSTEM:-not set}):"
  echo "   - CLAUDE.md extended with Commands & Critical Rules"
  [ -d .agents/context ] && echo "   - .agents/context/ (STACK.md, ARCHITECTURE.md, CONVENTIONS.md)"
  if [ ${INSTALLED:-0} -gt 0 ]; then
    echo "   - ${INSTALLED} skills installed"
  fi
fi

echo ""
echo "📂 Project structure ready for AI development"
echo ""
echo "================================================================"
echo "NEXT STEPS"
echo "================================================================"
echo ""
if [ "$WITH_GSD" = "yes" ]; then
  if [ "$AI_CLI" = "claude" ]; then
    echo "Run this in a Claude Code session to complete the setup:"
    echo ""
    echo "  /gsd:map-codebase        Deep codebase analysis (enhances .agents/context/)"
    echo ""
    echo "When you're ready to start building:"
    echo ""
    echo "  /gsd:new-project         Define project, requirements & roadmap"
  else
    echo "  1. /gsd:map-codebase     Deep codebase analysis"
    echo ""
    echo "  When ready to start building:"
    echo "  2. /gsd:new-project      Define project, requirements & roadmap"
  fi
else
  echo "Start a Claude Code session and begin working."
  echo "Your project context and CLAUDE.md are ready."
  echo ""
  echo "Spec-driven workflow:"
  echo "  /spec \"task description\"    Create a structured spec before coding"
  echo "  /spec-work 001              Execute a spec step by step"
  echo ""
  echo "To regenerate context files later:"
  echo "  npx @onedot/ai-setup --regenerate"
  echo ""
  echo "Optional: Install GSD later for structured workflow management:"
  echo "  npx get-shit-done-cc@latest --claude --global"
fi

if [ "$WITH_GSD" = "yes" ]; then
  echo ""
  echo "================================================================"
  echo "GSD WORKFLOW CHEAT SHEET"
  echo "================================================================"
  echo ""
  echo "  Core Loop:"
  echo "  /gsd:discuss-phase N      Clarify requirements before planning"
  echo "  /gsd:plan-phase N         Create step-by-step plan"
  echo "  /gsd:execute-phase N      Write code & commit atomically"
  echo "  /gsd:verify-work N        User acceptance testing"
  echo ""
  echo "  Quick Tasks:"
  echo "  /gsd:quick \"task\"          Fast fix (typos, CSS, config)"
  echo "  /gsd:debug                Systematic debugging"
  echo ""
  echo "  Session Management:"
  echo "  /gsd:pause-work           Save context for later"
  echo "  /gsd:resume-work          Restore previous session"
  echo "  /gsd:progress             Status & next action"
  echo ""
  echo "  Roadmap:"
  echo "  /gsd:add-phase            Add phase to roadmap"
  echo "  /gsd:insert-phase         Insert urgent work (e.g. 3.1)"
  echo "  /gsd:add-todo             Capture idea as todo"
  echo "  /gsd:check-todos          Show open todos"
fi

echo ""
echo "================================================================"
echo "LINKS"
echo "================================================================"
echo ""
echo "  Skills:   https://skills.sh/"
[ "$WITH_GSD" = "yes" ] && echo "  GSD:      https://github.com/get-shit-done-cc/get-shit-done-cc"
[ "$WITH_CLAUDE_MEM" = "yes" ] && echo "  Memory:   https://claude-mem.ai"
echo "  Claude:   https://docs.anthropic.com/en/docs/claude-code"
echo "  Hooks:    https://docs.anthropic.com/en/docs/claude-code/hooks"
echo ""
echo "================================================================"
