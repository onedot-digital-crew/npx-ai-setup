#!/bin/bash
# Core utilities: template map, version management, checksums, backup
# Requires: SCRIPT_DIR, TPL

# Files with special handling excluded from generic TEMPLATE_MAP (e.g. mcp.json uses merge logic)
TEMPLATE_EXCLUDES=("mcp.json")

# Build TEMPLATE_MAP dynamically from templates/ directory.
# Applies consistent prefix rules:
#   claude/    -> .claude/
#   github/    -> .github/
#   commands/  -> .claude/commands/
#   agents/    -> .claude/agents/
#   specs/     -> specs/
#   (root)     -> (root, e.g. CLAUDE.md)
build_template_map() {
  TEMPLATE_MAP=()
  local tpl_dir="$SCRIPT_DIR/templates"

  while IFS= read -r -d '' file; do
    local rel="${file#$tpl_dir/}"
    local filename="${rel##*/}"

    # Skip excluded filenames
    local excluded=false
    for excl in "${TEMPLATE_EXCLUDES[@]}"; do
      [ "$filename" = "$excl" ] && excluded=true && break
    done
    [ "$excluded" = "true" ] && continue

    # Skip skills/ — handled explicitly by SHOPIFY_SKILLS_MAP with system check
    [[ "$rel" == skills/* ]] && continue

    # Skip typescript.md — handled conditionally by TS_RULES_MAP in install_rules()
    [[ "$rel" == "claude/rules/typescript.md" ]] && continue

    # Map source path to install target path
    local target
    case "$rel" in
      claude/*)   target=".${rel}" ;;
      github/*)   target=".${rel}" ;;
      commands/*) target=".claude/${rel}" ;;
      agents/*)   target=".claude/${rel}" ;;
      specs/*)    target="${rel}" ;;
      *)          target="${rel}" ;;
    esac

    TEMPLATE_MAP+=("templates/${rel}:${target}")
  done < <(find "$tpl_dir" -type f -print0 | sort -z)
}

# Populate TEMPLATE_MAP at startup
build_template_map

# Shopify-specific skills (only added when system includes shopify)
SHOPIFY_SKILLS_MAP=(
  "templates/skills/shopify-theme-dev/SKILL.md:.claude/skills/shopify-theme-dev/SKILL.md"
  "templates/skills/shopify-liquid/SKILL.md:.claude/skills/shopify-liquid/SKILL.md"
  "templates/skills/shopify-app-dev/SKILL.md:.claude/skills/shopify-app-dev/SKILL.md"
  "templates/skills/shopify-graphql-api/SKILL.md:.claude/skills/shopify-graphql-api/SKILL.md"
  "templates/skills/shopify-hydrogen/SKILL.md:.claude/skills/shopify-hydrogen/SKILL.md"
  "templates/skills/shopify-checkout/SKILL.md:.claude/skills/shopify-checkout/SKILL.md"
  "templates/skills/shopify-functions/SKILL.md:.claude/skills/shopify-functions/SKILL.md"
  "templates/skills/shopify-cli-tools/SKILL.md:.claude/skills/shopify-cli-tools/SKILL.md"
)

# TypeScript-specific rules (only added when *.ts or *.tsx files are detected)
TS_RULES_MAP=(
  "templates/claude/rules/typescript.md:.claude/rules/typescript.md"
)

VALID_SYSTEMS=(auto shopify nuxt next laravel shopware storyblok)

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

  # Include Shopify skills if system includes shopify
  if [[ "${SYSTEM:-}" == *shopify* ]]; then
    for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
      local tpl="${mapping%%:*}"
      local target="${mapping#*:}"
      if [ -f "$target" ]; then
        local cs
        cs=$(compute_checksum "$target")
        json=$(echo "$json" | jq --arg f "$target" --arg c "$cs" '.files[$f] = $c')
      fi
    done
  fi

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
