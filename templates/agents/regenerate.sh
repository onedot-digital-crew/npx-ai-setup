#!/bin/bash
# Regenerate .agents/context/ files (STACK.md, ARCHITECTURE.md, CONVENTIONS.md)
# Run this when codebase changes significantly or context files are outdated.

set -e

if ! command -v claude &>/dev/null; then
  echo "❌ Claude CLI required. Install: npm i -g @anthropic-ai/claude-code"
  exit 1
fi

# Helper: extract filenames without path/extension, comma-separated
list_names() {
  local dir="$1" ext="$2"
  ls -1 "$dir"/*."$ext" 2>/dev/null | sed "s|$dir/||;s|\.$ext||" | tr '\n' ', ' | sed 's/, $//'
}
count_files() {
  local dir="$1" ext="$2"
  ls -1 "$dir"/*."$ext" 2>/dev/null | wc -l | tr -d ' '
}

# Efficiently collect project files (git-aware with fallback)
collect_files() {
  local max=${1:-120}
  if git rev-parse --git-dir >/dev/null 2>&1; then
    git ls-files -z '*.js' '*.ts' '*.jsx' '*.tsx' '*.vue' '*.svelte' \
      '*.css' '*.scss' '*.liquid' '*.php' '*.html' '*.twig' \
      '*.blade.php' '*.erb' '*.py' '*.rb' '*.go' '*.rs' '*.astro' \
      2>/dev/null | tr '\0' '\n' | head -n "$max"
  else
    find . -maxdepth 4 \
      \( -name node_modules -o -name .git -o -name dist -o -name build \
         -o -name .next -o -name vendor -o -name .nuxt \) -prune -o \
      -type f \( -iname '*.js' -o -iname '*.ts' -o -iname '*.jsx' -o -iname '*.tsx' \
        -o -iname '*.vue' -o -iname '*.svelte' -o -iname '*.py' -o -iname '*.go' \
        -o -iname '*.rs' -o -iname '*.rb' -o -iname '*.php' \
      \) -print | head -n "$max"
  fi
}

echo "📊 Regenerating .agents/context/..."
mkdir -p .agents/context

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

# Gather context
CTX_PKG=$(cat package.json 2>/dev/null || echo "No package.json")
CTX_TSCONFIG=$(cat tsconfig.json tsconfig.*.json 2>/dev/null | head -80 || echo "No tsconfig")
CTX_DIRS=$(find . -maxdepth 3 -type d \
  \( -name node_modules -o -name .git -o -name dist -o -name build \
     -o -name .next -o -name vendor -o -name .nuxt -o -name .output \) -prune -o \
  -type d -print 2>/dev/null | head -60)
# Reduce generic files when platform detected
if [ ${#PLATFORMS[@]} -gt 0 ]; then
  CTX_FILES=$(collect_files 60)
else
  CTX_FILES=$(collect_files 120)
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
  for f in $(collect_files 5 | head -3); do
    CTX_SAMPLE+="
--- $f (first 50 lines) ---
$(head -50 "$f" 2>/dev/null)"
  done
fi

# Platform-specific context (bash-analyzed summaries, token-efficient)
CTX_PLATFORM=""
PLATFORM_PROMPT=""

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
      ;;
    shopware)
      CTX_PLATFORM+="
--- Platform: Shopware ---
Core modules: $(ls -1d src/*/ 2>/dev/null | sed 's|src/||;s|/||' | tr '\n' ', ' | sed 's/, $//')
Custom plugins: $(find custom/plugins -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sed 's|.*/||' | tr '\n' ', ' | sed 's/, $//')
Custom apps: $(find custom/apps -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sed 's|.*/||' | tr '\n' ', ' | sed 's/, $//')"
      PLATFORM_PROMPT+="
This is a SHOPWARE project. In ARCHITECTURE.md: document core modules, custom plugins, entity definitions, storefront theme, admin extensions. In CONVENTIONS.md: include plugin patterns, entity/DAL conventions, Twig patterns."
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
$CTX_PLATFORM"

# Verify
CTX_COUNT=0
[ -f .agents/context/STACK.md ] && CTX_COUNT=$((CTX_COUNT + 1))
[ -f .agents/context/ARCHITECTURE.md ] && CTX_COUNT=$((CTX_COUNT + 1))
[ -f .agents/context/CONVENTIONS.md ] && CTX_COUNT=$((CTX_COUNT + 1))

if [ "$CTX_COUNT" -eq 3 ]; then
  echo "✅ All 3 context files regenerated in .agents/context/"
elif [ "$CTX_COUNT" -gt 0 ]; then
  echo "⚠️  $CTX_COUNT of 3 context files created (partial)"
else
  echo "❌ Context generation failed."
  exit 1
fi
