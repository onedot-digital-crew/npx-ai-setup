#!/bin/bash
# System detection and template filtering
# Requires: $SYSTEM, $UPD_* flags

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

# Returns 0 (true) if the given mapping's target path matches the selected update categories.
# Returns 1 (false) if the category is deselected — caller should skip this file.
# Defaults to "yes" for all categories when UPD_* flags are unset (fresh install / reinstall paths).
should_update_template() {
  local mapping="$1"
  local target="${mapping#*:}"
  if [[ "$target" == .claude/hooks/* ]] || [[ "$target" == .claude/rules/* ]]; then
    [ "${UPD_HOOKS:-yes}" = "yes" ] && return 0 || return 1
  elif [[ "$target" == .claude/settings* ]]; then
    [ "${UPD_SETTINGS:-yes}" = "yes" ] && return 0 || return 1
  elif [[ "$target" == .claude/commands/* ]]; then
    [ "${UPD_COMMANDS:-yes}" = "yes" ] && return 0 || return 1
  elif [[ "$target" == .claude/agents/* ]]; then
    [ "${UPD_AGENTS:-yes}" = "yes" ] && return 0 || return 1
  else
    [ "${UPD_OTHER:-yes}" = "yes" ] && return 0 || return 1
  fi
}
