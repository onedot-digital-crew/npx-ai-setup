#!/bin/bash
# Regenerate .agents/context/ files (STACK.md, ARCHITECTURE.md, CONVENTIONS.md)
# Run this when codebase changes significantly or context files are outdated.

set -e

if ! command -v claude &>/dev/null; then
  echo "❌ Claude CLI required. Install: npm i -g @anthropic-ai/claude-code"
  exit 1
fi

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

# Gather context
CTX_PKG=$(cat package.json 2>/dev/null || echo "No package.json")
CTX_TSCONFIG=$(cat tsconfig.json tsconfig.*.json 2>/dev/null | head -80 || echo "No tsconfig")
CTX_DIRS=$(find . -maxdepth 3 -type d \
  \( -name node_modules -o -name .git -o -name dist -o -name build \
     -o -name .next -o -name vendor -o -name .nuxt -o -name .output \) -prune -o \
  -type d -print 2>/dev/null | head -60)
CTX_FILES=$(collect_files 120)
CTX_CONFIGS=$(ls -1 *.config.* .eslintrc* .prettierrc* tailwind.config.* \
  vite.config.* nuxt.config.* next.config.* astro.config.* \
  webpack.config.* rollup.config.* docker-compose* Dockerfile \
  Makefile Cargo.toml go.mod requirements.txt pyproject.toml \
  biome.json 2>/dev/null || echo "No config files found")
CTX_README=$(head -50 README.md 2>/dev/null || echo "No README")

CTX_SAMPLE=""
for f in $(collect_files 5 | head -3); do
  CTX_SAMPLE="${CTX_SAMPLE}
--- $f (first 50 lines) ---
$(head -50 "$f" 2>/dev/null)"
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
--- File list (120 files) ---
$CTX_FILES
--- Config files present ---
$CTX_CONFIGS
--- README (first 50 lines) ---
$CTX_README
--- Sample source files ---
$CTX_SAMPLE"

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
