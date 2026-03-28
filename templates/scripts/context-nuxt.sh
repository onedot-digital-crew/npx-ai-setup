#!/bin/bash
# context-nuxt.sh — Nuxt project context scanner
# Generates .agents/context/NUXT.md with zero LLM tokens.
# Run: bash .claude/scripts/context-nuxt.sh
# Triggered by: /context-refresh skill when nuxt.config.* is detected

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
OUTPUT="$PROJECT_DIR/.agents/context/NUXT.md"

# --- Pages ---
page_count=$(find "$PROJECT_DIR/pages" -name "*.vue" 2>/dev/null | wc -l | tr -d ' ')
pages=$(find "$PROJECT_DIR/pages" -name "*.vue" 2>/dev/null \
  | sed "s|$PROJECT_DIR/pages/||" | sed 's/\.vue$//' | sort | tr '\n' ',' | sed 's/,$//')

# --- Components ---
component_count=$(find "$PROJECT_DIR/components" -name "*.vue" 2>/dev/null | wc -l | tr -d ' ')

# --- Composables ---
composables=$(find "$PROJECT_DIR/composables" -name "use*.ts" -o -name "use*.js" 2>/dev/null \
  | xargs -I{} basename {} | sed 's/\.\(ts\|js\)$//' | sort | tr '\n' ',' | sed 's/,$//')

# --- Stores ---
stores=$(find "$PROJECT_DIR/stores" -name "*.ts" -o -name "*.js" 2>/dev/null \
  | xargs -I{} basename {} | sed 's/\.\(ts\|js\)$//' | sort | tr '\n' ',' | sed 's/,$//')

# --- Layouts ---
layouts=$(find "$PROJECT_DIR/layouts" -name "*.vue" 2>/dev/null \
  | xargs -I{} basename {} .vue | sort | tr '\n' ',' | sed 's/,$//')

# --- Server routes ---
server_routes=$(find "$PROJECT_DIR/server/api" -name "*.ts" -o -name "*.js" 2>/dev/null \
  | sed "s|$PROJECT_DIR/server/api/||" | sed 's/\.\(ts\|js\)$//' | sort | tr '\n' ',' | sed 's/,$//')

# --- Build abstract ---
abstract="Nuxt: ${page_count} pages | ${component_count} components${stores:+ | stores: $(echo "$stores" | tr ',' '\n' | grep -c . 2>/dev/null || echo 0)}${server_routes:+ | server/api routes}"

# --- Write output ---
mkdir -p "$(dirname "$OUTPUT")"
cat > "$OUTPUT" << NUXT_EOF
---
abstract: "${abstract}"
---

# Nuxt Project Context

## Pages (${page_count})
${pages:-none}

## Components (${component_count})
$([ "$component_count" -gt 0 ] && echo "See components/ — use /context-load for full list" || echo "none")
${composables:+
## Composables
${composables}}
${stores:+
## Stores (Pinia)
${stores}}
${layouts:+
## Layouts
${layouts}}
${server_routes:+
## Server API Routes
${server_routes}}
NUXT_EOF

echo "✓ NUXT.md written to $OUTPUT"
wc -l < "$OUTPUT" | xargs -I{} echo "  {} lines"
