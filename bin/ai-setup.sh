#!/bin/bash

# ==============================================================================
# @onedot/ai-setup - AI infrastructure for projects
# ==============================================================================
# Installs Claude Code hooks, project context, and AI-curated skills
# Usage: npx @onedot/ai-setup [--with-gsd] [--no-gsd]
# ==============================================================================

set -e

# Package root (one level above bin/)
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TPL="$SCRIPT_DIR/templates"

# Parse flags
WITH_GSD=""
for arg in "$@"; do
  case "$arg" in
    --with-gsd) WITH_GSD="yes" ;;
    --no-gsd) WITH_GSD="no" ;;
  esac
done

# Extract filenames without path/extension, comma-separated
list_names() {
  local dir="$1" ext="$2"
  ls -1 "$dir"/*."$ext" 2>/dev/null | sed "s|$dir/||;s|\.$ext||" | tr '\n' ', ' | sed 's/, $//'
}
count_files() {
  local dir="$1" ext="$2"
  ls -1 "$dir"/*."$ext" 2>/dev/null | wc -l | tr -d ' '
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
[ -d ".claude/skills/work-spec" ] && FOUND+=(".claude/skills/work-spec/")
[ -d ".claude/skills/template-skill" ] && FOUND+=(".claude/skills/template-skill/")
[ -d ".claude/skills/learn" ] && FOUND+=(".claude/skills/learn/")
[ -f ".claude/INIT.md" ] && FOUND+=(".claude/INIT.md")
[ -f "specs/TEMPLATE.md" ] && FOUND+=("specs/TEMPLATE.md")
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

for hook in protect-files.sh post-edit-lint.sh circuit-breaker.sh; do
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
# 6. AGENTS DIRECTORY (regenerate script)
# ------------------------------------------------------------------------------
mkdir -p .agents
if [ ! -f .agents/regenerate.sh ]; then
  cp "$TPL/agents/regenerate.sh" .agents/regenerate.sh
  chmod +x .agents/regenerate.sh
fi

# ------------------------------------------------------------------------------
# 7. GITIGNORE
# ------------------------------------------------------------------------------
# (renumbered: sections 6=agents, 7=gitignore, 8=gsd, 9=auto-init)
if [ -f .gitignore ]; then
  if ! grep -q "claude/settings.local" .gitignore 2>/dev/null; then
    echo "" >> .gitignore
    echo "# Claude Code local settings" >> .gitignore
    echo ".claude/settings.local.json" >> .gitignore
  fi
else
  echo "# Claude Code local settings" > .gitignore
  echo ".claude/settings.local.json" >> .gitignore
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

    wait $GSD_PID
    GSD_EXIT=$?

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
# 9. AUTO-INIT (Claude populates CLAUDE.md + generates project context)
# ------------------------------------------------------------------------------

# Kill process + all child processes (Claude spawns sub-agents)
kill_tree() {
  local pid=$1
  pkill -P "$pid" 2>/dev/null
  kill "$pid" 2>/dev/null
  wait "$pid" 2>/dev/null
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

echo ""
echo "✅ Setup complete!"
echo ""

if [ "$AI_CLI" = "claude" ]; then
  read -p "🤖 Run Auto-Init now? (Y/n) " RUN_INIT
  if [[ ! "$RUN_INIT" =~ ^[Nn]$ ]]; then
    echo "🚀 Scanning project structure..."

    # Detect project platforms
    PLATFORMS=()
    [ -f shopify.theme.toml ] || ([ -d sections ] && [ -d snippets ]) && PLATFORMS+=("shopify")
    [ -f nuxt.config.ts ] || [ -f nuxt.config.js ] && PLATFORMS+=("nuxt")
    [ -f artisan ] && PLATFORMS+=("laravel")
    ([ -d src/Core ] && [ -d src/Storefront ]) && PLATFORMS+=("shopware")
    (grep -q '@storyblok/' package.json 2>/dev/null || [ -d storyblok ]) && PLATFORMS+=("storyblok")

    if [ ${#PLATFORMS[@]} -gt 0 ]; then
      echo "  🔍 Detected: ${PLATFORMS[*]}"
    fi

    # Gather all context upfront (both steps share some data)
    CONTEXT="--- package.json ---
$(cat package.json 2>/dev/null)
--- package.json scripts ---
$(jq -r '.scripts | to_entries[] | "- \(.key): \(.value)"' package.json 2>/dev/null)
--- Directory structure (max 80 files) ---
$(collect_project_files 80)
--- ESLint Config ---
$(cat eslint.config.* .eslintrc* 2>/dev/null | head -100)
--- Prettier Config ---
$(cat .prettierrc* 2>/dev/null)
--- CLAUDE.md (current) ---
$(cat CLAUDE.md 2>/dev/null)"

    # Extended context for project context generation
    CTX_PKG=$(cat package.json 2>/dev/null || echo "No package.json")
    CTX_TSCONFIG=$(cat tsconfig.json tsconfig.*.json 2>/dev/null | head -80 || echo "No tsconfig")
    CTX_DIRS=$(find . -maxdepth 3 -type d \
      \( -name node_modules -o -name .git -o -name dist -o -name build \
         -o -name .next -o -name vendor -o -name .nuxt -o -name .output \) -prune -o \
      -type d -print 2>/dev/null | head -60)
    # Reduce generic files when platform detected (platform summary covers key files)
    if [ ${#PLATFORMS[@]} -gt 0 ]; then
      CTX_FILES=$(collect_project_files 60)
    else
      CTX_FILES=$(collect_project_files 120)
    fi
    CTX_CONFIGS=$(ls -1 *.config.* .eslintrc* .prettierrc* tailwind.config.* \
      vite.config.* nuxt.config.* next.config.* astro.config.* \
      webpack.config.* rollup.config.* docker-compose* Dockerfile \
      Makefile Cargo.toml go.mod requirements.txt pyproject.toml \
      biome.json 2>/dev/null || echo "No config files found")
    CTX_README=$(head -50 README.md 2>/dev/null || echo "No README")

    # Platform-specific sample files (smarter than random 3)
    CTX_SAMPLE=""
    if [[ " ${PLATFORMS[*]} " == *" shopify "* ]]; then
      SAMPLE_FILE=$(ls -1 sections/*.liquid 2>/dev/null | head -1)
      [ -n "$SAMPLE_FILE" ] && CTX_SAMPLE+="
--- $SAMPLE_FILE (first 40 lines) ---
$(head -40 "$SAMPLE_FILE" 2>/dev/null)"
      SAMPLE_FILE=$(ls -1 snippets/*.liquid 2>/dev/null | head -1)
      [ -n "$SAMPLE_FILE" ] && CTX_SAMPLE+="
--- $SAMPLE_FILE (first 40 lines) ---
$(head -40 "$SAMPLE_FILE" 2>/dev/null)"
    elif [[ " ${PLATFORMS[*]} " == *" nuxt "* ]]; then
      SAMPLE_FILE=$(ls -1 app/composables/*.ts composables/*.ts 2>/dev/null | head -1)
      [ -n "$SAMPLE_FILE" ] && CTX_SAMPLE+="
--- $SAMPLE_FILE (first 40 lines) ---
$(head -40 "$SAMPLE_FILE" 2>/dev/null)"
      SAMPLE_FILE=$(find app/pages pages -name '*.vue' 2>/dev/null | head -1)
      [ -n "$SAMPLE_FILE" ] && CTX_SAMPLE+="
--- $SAMPLE_FILE (first 40 lines) ---
$(head -40 "$SAMPLE_FILE" 2>/dev/null)"
    elif [[ " ${PLATFORMS[*]} " == *" laravel "* ]]; then
      SAMPLE_FILE=$(ls -1 app/Http/Controllers/*.php 2>/dev/null | head -1)
      [ -n "$SAMPLE_FILE" ] && CTX_SAMPLE+="
--- $SAMPLE_FILE (first 40 lines) ---
$(head -40 "$SAMPLE_FILE" 2>/dev/null)"
      SAMPLE_FILE=$(ls -1 app/Models/*.php 2>/dev/null | head -1)
      [ -n "$SAMPLE_FILE" ] && CTX_SAMPLE+="
--- $SAMPLE_FILE (first 40 lines) ---
$(head -40 "$SAMPLE_FILE" 2>/dev/null)"
    else
      for f in $(collect_project_files 5 | head -3); do
        CTX_SAMPLE+="
--- $f (first 50 lines) ---
$(head -50 "$f" 2>/dev/null)"
      done
    fi

    # Platform-specific context (bash-analyzed summaries, token-efficient)
    CTX_PLATFORM=""
    PLATFORM_PROMPT=""
    PLATFORM_RULES=""

    for platform in "${PLATFORMS[@]}"; do
      case "$platform" in
        shopify)
          CTX_PLATFORM+="
--- Platform: Shopify Theme ---
Sections ($(count_files sections liquid)): $(list_names sections liquid)
Blocks ($(count_files blocks liquid)): $(list_names blocks liquid)
Snippets ($(count_files snippets liquid)): $(list_names snippets liquid)
Templates: $(ls -1 templates/*.json templates/*.liquid 2>/dev/null | sed 's|templates/||' | tr '\n' ', ' | sed 's/, $//')
Layouts: $(list_names layout liquid)
Locales: $(ls -1 locales/*.json 2>/dev/null | sed 's|locales/||' | tr '\n' ', ' | sed 's/, $//')
Settings schema: $(jq -r '.[].name // empty' config/settings_schema.json 2>/dev/null | tr '\n' ', ' | sed 's/, $//')"
          PLATFORM_PROMPT+="
This is a SHOPIFY THEME. In ARCHITECTURE.md: document sections, blocks, snippets, templates, settings schema, and JS entrypoints. In CONVENTIONS.md: include Liquid patterns (render vs include), section/block naming, CSS patterns."
          PLATFORM_RULES+="Shopify theme: Never edit settings_data.json or config/settings_data.json. Use render over include. "
          ;;
        nuxt)
          CTX_PLATFORM+="
--- Platform: Nuxt ---
Modules: $(grep -oP "'\K[^']+(?=')" nuxt.config.ts nuxt.config.js 2>/dev/null | grep -E '^@|^nuxt' | sort -u | tr '\n' ', ' | sed 's/, $//')
Pages ($(find app/pages pages -name '*.vue' 2>/dev/null | wc -l | tr -d ' ')): $(find app/pages pages -name '*.vue' 2>/dev/null | sed 's|.*/||;s|\.vue||' | tr '\n' ', ' | sed 's/, $//')
Composables: $(ls -1 app/composables/*.ts composables/*.ts 2>/dev/null | sed 's|.*/||;s|\.ts||' | tr '\n' ', ' | sed 's/, $//')
Stores: $(ls -1 app/stores/*.ts stores/*.ts 2>/dev/null | sed 's|.*/||;s|\.ts||' | tr '\n' ', ' | sed 's/, $//')
Middleware: $(ls -1 app/middleware/*.ts middleware/*.ts 2>/dev/null | sed 's|.*/||;s|\.ts||' | tr '\n' ', ' | sed 's/, $//')
Plugins: $(ls -1 app/plugins/*.ts plugins/*.ts 2>/dev/null | sed 's|.*/||;s|\.ts||' | tr '\n' ', ' | sed 's/, $//')
Server routes: $(find server/api server/routes -name '*.ts' 2>/dev/null | sed 's|server/||' | tr '\n' ', ' | sed 's/, $//')"
          PLATFORM_PROMPT+="
This is a NUXT project. In ARCHITECTURE.md: document modules, page routing, composables, stores, middleware, plugins, server routes. In CONVENTIONS.md: include composable naming (use*), store patterns, auto-import conventions."
          PLATFORM_RULES+="Nuxt: Use composables for shared logic. Follow auto-import conventions. "
          ;;
        laravel)
          CTX_PLATFORM+="
--- Platform: Laravel ---
Controllers: $(ls -1 app/Http/Controllers/*.php 2>/dev/null | sed 's|.*/||;s|\.php||' | tr '\n' ', ' | sed 's/, $//')
Models: $(ls -1 app/Models/*.php 2>/dev/null | sed 's|.*/||;s|\.php||' | tr '\n' ', ' | sed 's/, $//')
Migrations: $(ls -1 database/migrations/*.php 2>/dev/null | wc -l | tr -d ' ') files
Route files: $(ls -1 routes/*.php 2>/dev/null | sed 's|routes/||;s|\.php||' | tr '\n' ', ' | sed 's/, $//')
Config: $(ls -1 config/*.php 2>/dev/null | sed 's|config/||;s|\.php||' | tr '\n' ', ' | sed 's/, $//')"
          PLATFORM_PROMPT+="
This is a LARAVEL project. In ARCHITECTURE.md: document routes, controllers, Eloquent models, migrations, service layer, middleware. In CONVENTIONS.md: include controller naming, model conventions, validation patterns."
          PLATFORM_RULES+="Laravel: Follow PSR-12. Use Eloquent relationships over raw queries. "
          ;;
        shopware)
          CTX_PLATFORM+="
--- Platform: Shopware ---
Core modules: $(ls -1d src/*/ 2>/dev/null | sed 's|src/||;s|/||' | tr '\n' ', ' | sed 's/, $//')
Custom plugins: $(find custom/plugins -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sed 's|.*/||' | tr '\n' ', ' | sed 's/, $//')
Custom apps: $(find custom/apps -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sed 's|.*/||' | tr '\n' ', ' | sed 's/, $//')"
          PLATFORM_PROMPT+="
This is a SHOPWARE project. In ARCHITECTURE.md: document core modules, custom plugins, entity definitions, storefront theme, admin extensions. In CONVENTIONS.md: include plugin patterns, entity/DAL conventions, Twig patterns."
          PLATFORM_RULES+="Shopware: Follow plugin development standards. Use DAL for data access. "
          ;;
        storyblok)
          CTX_PLATFORM+="
--- Platform: Storyblok ---
Components ($(count_files storyblok vue)): $(list_names storyblok vue)"
          PLATFORM_PROMPT+="
This project uses STORYBLOK CMS. In ARCHITECTURE.md: document component schemas, content structure, visual editor integration. In CONVENTIONS.md: include component naming, bridge/preview setup."
          ;;
      esac
    done

    # Check if context generation should be skipped
    SKIP_CTX=false
    if [ -f .agents/context/STACK.md ] && [ -f .agents/context/ARCHITECTURE.md ] && [ -f .agents/context/CONVENTIONS.md ]; then
      SKIP_CTX=true
    fi

    # Temp files for error capture
    ERR_CM=$(mktemp)
    ERR_CTX=$(mktemp)

    # Step 1: Extend CLAUDE.md (background)
    STEP1_PLATFORM=""
    [ -n "$PLATFORM_RULES" ] && STEP1_PLATFORM="
Platform-specific rules to include in Critical Rules: $PLATFORM_RULES"

    CLAUDE_MD_BEFORE=$(cksum CLAUDE.md 2>/dev/null || echo "none")

    claude -p --model sonnet --max-turns 3 "Add two sections to CLAUDE.md:

## Commands
Read package.json scripts, document the most important ones (dev, build, lint, test).

## Critical Rules
Analyze linting config (eslint, prettier). Identify framework patterns.
Write concrete, actionable rules. Max 5 sections, 3-5 bullet points each.
$STEP1_PLATFORM

Rules: ONLY use what is in the context. No umlauts. Reply 'Done'.

$CONTEXT" >/dev/null 2>"$ERR_CM" &
    PID_CM=$!

    # Step 2: Generate project context (background, parallel with Step 1)
    if [ "$SKIP_CTX" = "false" ]; then
      mkdir -p .agents/context

      claude -p --model haiku --max-turns 5 "You are analyzing a codebase to create project context documentation.
Create exactly 3 files in .agents/context/ using the Write tool.

## File 1: .agents/context/STACK.md
Document the technology stack:
- Runtime & language (with versions from config files)
- Framework (with version from package.json)
- Key dependencies (categorized: UI, state, data, testing, build)
- Package manager
- Build tooling

## File 2: .agents/context/ARCHITECTURE.md
Document the architecture:
- Project type (SPA, SSR, API, monorepo, library, etc.)
- Directory structure overview (what each top-level dir contains)
- Entry points (main files, route definitions)
- Data flow (state management, API layer, data fetching pattern)
- Key patterns (composition API vs options API, server components, etc.)

## File 3: .agents/context/CONVENTIONS.md
Document coding conventions found in the codebase:
- Naming patterns (files, components, variables, CSS classes)
- Import style (absolute vs relative, barrel files)
- Component structure (script-template-style order, composition patterns)
- Error handling patterns
- TypeScript usage (strict mode, type vs interface preference)

$PLATFORM_PROMPT

Rules:
- Base ALL content on the provided context. Do not invent details.
- Keep each file concise: 30-60 lines max.
- Use markdown headers and bullet points.
- Include file paths where relevant.
- If information is not available, write 'Not determined from available context.'
- No umlauts. All content in English.
- Reply 'Done' after creating all 3 files.

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
$CTX_SAMPLE
$CTX_PLATFORM" >/dev/null 2>"$ERR_CTX" &
      PID_CTX=$!
    fi

    # Wait for both steps with parallel progress bars
    echo ""
    if [ "$SKIP_CTX" = "false" ]; then
      wait_parallel "$PID_CM:CLAUDE.md:30:120" "$PID_CTX:Project context:30:90"
    else
      progress_bar $PID_CM "CLAUDE.md" 30 120
      echo "  📊 .agents/context/ already populated, skipping."
    fi

    # Verify Step 1: CLAUDE.md was actually modified
    wait "$PID_CM" 2>/dev/null
    EXIT_CM=$?
    CLAUDE_MD_AFTER=$(cksum CLAUDE.md 2>/dev/null || echo "none")
    if [ "$EXIT_CM" -ne 0 ] || [ "$CLAUDE_MD_BEFORE" = "$CLAUDE_MD_AFTER" ]; then
      echo ""
      echo "  ⚠️  CLAUDE.md was not updated."
      if [ -s "$ERR_CM" ]; then
        echo "  Error: $(head -3 "$ERR_CM")"
      fi
      echo "  Fix: Run 'claude' in your terminal to check authentication, then re-run the setup."
    fi

    # Verify Step 2: context files were created
    if [ "$SKIP_CTX" = "false" ]; then
      wait "$PID_CTX" 2>/dev/null
      EXIT_CTX=$?
      CTX_COUNT=0
      [ -f .agents/context/STACK.md ] && CTX_COUNT=$((CTX_COUNT + 1))
      [ -f .agents/context/ARCHITECTURE.md ] && CTX_COUNT=$((CTX_COUNT + 1))
      [ -f .agents/context/CONVENTIONS.md ] && CTX_COUNT=$((CTX_COUNT + 1))

      if [ "$CTX_COUNT" -eq 3 ]; then
        echo "  ✅ All 3 context files created in .agents/context/"
      elif [ "$CTX_COUNT" -gt 0 ]; then
        echo "  ⚠️  $CTX_COUNT of 3 context files created (partial)"
        if [ -s "$ERR_CTX" ]; then
          echo "  Error: $(head -3 "$ERR_CTX")"
        fi
      else
        echo "  ⚠️  Context generation failed."
        if [ -s "$ERR_CTX" ]; then
          echo "  Error: $(head -3 "$ERR_CTX")"
        fi
        echo "  Fix: Check 'claude' works, then run: .agents/regenerate.sh"
      fi
    fi

    rm -f "$ERR_CM" "$ERR_CTX"

    # Step 3: Search and install skills (AI-curated)
    echo ""
    echo "🔌 Searching and installing skills..."
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
              kill "$pid" 2>/dev/null
              wait "$pid" 2>/dev/null
            else
              wait "$pid" 2>/dev/null
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
          trap "rm -f '$ALL_SKILLS_CACHE'" EXIT INT TERM

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

          # Phase 2: Claude selects the most relevant skills (60s timeout)
          CLAUDE_TMP=$(mktemp)
          claude -p --model sonnet --max-turns 1 "You are a skill curator for AI coding agents. Select the best skills for this project.

Project technologies: ${KEYWORDS[*]}

Available skills (with weekly install counts from skills.sh):
$SKILLS_WITH_COUNTS

Rules:
- Select EXACTLY the top 5 most relevant skills (or fewer if less available)
- Prefer skills with HIGHER install counts (more popular = better quality)
- Avoid duplicates (e.g. not 3x vue-best-practices from different authors)
- Prefer skills from well-known maintainers (antfu, vercel-labs, vuejs-ai, etc.)
- Reply ONLY with skill IDs, one per line, absolutely no other text
- Format: owner/repo@skill-name
- Example response:
antfu/skills@vue
antfu/skills@nuxt" > "$CLAUDE_TMP" 2>/dev/null &
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
            wait "$CLAUDE_PID" 2>/dev/null
            SELECTED=$(cat "$CLAUDE_TMP")
          fi
          rm -f "$CLAUDE_TMP"

          if [ -n "$SELECTED" ]; then
            # Extract only valid skill IDs, clean whitespace, strip backticks, enforce max 5
            SELECTED=$(echo "$SELECTED" \
              | sed 's/`//g' \
              | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
              | grep -E '^[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+@[a-zA-Z0-9_.-]+' \
              | head -5)
          fi

          if [ -n "$SELECTED" ]; then
            SELECTED_COUNT=$(echo "$SELECTED" | wc -l | tr -d ' ')
            echo "  ✨ $SELECTED_COUNT skills selected:"
            echo ""

            # Phase 3: Install selected skills (30s timeout per install)
            INSTALLED=0
            while IFS= read -r skill_id; do
              skill_id=$(echo "$skill_id" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
              if [ -n "$skill_id" ]; then
                printf "     ⏳ %s ..." "$skill_id"
                if [ -n "$TIMEOUT_CMD" ]; then
                  if $TIMEOUT_CMD npx -y skills@latest add "$skill_id" --agent claude-code --agent github-copilot -y</dev/null >/dev/null 2>&1; then
                    printf "\r     ✅ %s\n" "$skill_id"
                    INSTALLED=$((INSTALLED + 1))
                  else
                    printf "\r     ❌ %s (install failed)\n" "$skill_id"
                  fi
                else
                  if npx -y skills@latest add "$skill_id" --agent claude-code --agent github-copilot -y</dev/null >/dev/null 2>&1; then
                    printf "\r     ✅ %s\n" "$skill_id"
                    INSTALLED=$((INSTALLED + 1))
                  else
                    printf "\r     ❌ %s (install failed)\n" "$skill_id"
                  fi
                fi
              fi
            done <<< "$SELECTED"
            echo ""
            echo "  Total: $INSTALLED skills installed"
          else
            echo "  ⚠️  Claude could not select skills. Installing top 3 per technology..."
            # Fallback: Top 3 per keyword using cached results
            INSTALLED=0
            for kw in "${KEYWORDS[@]}"; do
              # Use cached results instead of re-searching
              SKILL_IDS=$(grep -iE "$kw" "$ALL_SKILLS_CACHE" 2>/dev/null | head -3)
              if [ -n "$SKILL_IDS" ]; then
                while IFS= read -r skill_id; do
                  skill_id=$(echo "$skill_id" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                  if [ -n "$skill_id" ]; then
                    printf "     ⏳ %s ..." "$skill_id"
                    if npx -y skills@latest add "$skill_id" --agent claude-code --agent github-copilot -y</dev/null >/dev/null 2>&1; then
                      printf "\r     ✅ %s\n" "$skill_id"
                      INSTALLED=$((INSTALLED + 1))
                    else
                      printf "\r     ❌ %s (install failed)\n" "$skill_id"
                    fi
                  fi
                done <<< "$SKILL_IDS"
              fi
            done
            echo ""
            echo "  Total: $INSTALLED skills installed (fallback)"
          fi
        fi
      fi
    else
      echo "  No package.json found."
    fi

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
echo "   - .claude/hooks/ (protect-files, post-edit-lint, circuit-breaker)"

if [ "$WITH_GSD" = "yes" ]; then
  echo ""
  echo "✅ Tools installed:"
  [ -d "${HOME}/.claude/commands/gsd" ] && echo "   - GSD (Get Shit Done) - globally in ~/.claude/"
  [ -d "${HOME}/.claude/skills/gsd" ] && echo "   - GSD Companion Skill"
fi

if [ "$AI_CLI" = "claude" ] && [[ ! "$RUN_INIT" =~ ^[Nn]$ ]]; then
  echo ""
  echo "✅ Auto-Init completed:"
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
echo "  Claude:   https://docs.anthropic.com/en/docs/claude-code"
echo "  Hooks:    https://docs.anthropic.com/en/docs/claude-code/hooks"
echo ""
echo "================================================================"
