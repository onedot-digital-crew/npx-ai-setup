#!/bin/bash
# Template filtering utilities
# Requires: $UPD_* flags

# Returns the category name for a given template mapping target path.
# Used by scan_template_changes() and should_update_template().
get_template_category() {
  local target="${1#*:}"
  if [[ "$target" == .claude/hooks/* ]] || [[ "$target" == .claude/rules/* ]]; then
    echo "hooks"
  elif [[ "$target" == .claude/settings* ]]; then
    echo "settings"
  elif [[ "$target" == "CLAUDE.md" ]]; then
    echo "claude_md"
  elif [[ "$target" == "AGENTS.md" ]]; then
    echo "agents_md"
  elif [[ "$target" == .claude/commands/* ]]; then
    echo "commands"
  elif [[ "$target" == .claude/agents/* ]]; then
    echo "agents"
  else
    echo "other"
  fi
}

# Returns 0 (true) if the given mapping's target path matches the selected update categories.
# Returns 1 (false) if the category is deselected — caller should skip this file.
# Defaults to "yes" for all categories when UPD_* flags are unset (fresh install / reinstall paths).
should_update_template() {
  local cat
  cat=$(get_template_category "$1")
  case "$cat" in
    hooks)     [ "${UPD_HOOKS:-yes}" = "yes" ] ;;
    settings)  [ "${UPD_SETTINGS:-yes}" = "yes" ] ;;
    claude_md) [ "${UPD_CLAUDE_MD:-yes}" = "yes" ] ;;
    agents_md) [ "${UPD_AGENTS_MD:-yes}" = "yes" ] ;;
    commands)  [ "${UPD_COMMANDS:-yes}" = "yes" ] ;;
    agents)    [ "${UPD_AGENTS:-yes}" = "yes" ] ;;
    *)         [ "${UPD_OTHER:-yes}" = "yes" ] ;;
  esac
}
