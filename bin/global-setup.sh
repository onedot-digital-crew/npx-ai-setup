#!/bin/bash

# ==============================================================================
# @onedot/ai-setup-global - Global developer workstation setup
# ==============================================================================
# Installs CLI tools, global Claude settings, and developer workstation config.
# Independent of any project — run once per developer machine.
# Usage: npx @onedot/ai-setup-global [--check]
# ==============================================================================

set -euo pipefail

# Package root (one level above bin/)
# Resolve symlinks so npx installs work correctly (macOS-compatible, no readlink -f)
_SCRIPT="${BASH_SOURCE[0]}"
while [ -L "$_SCRIPT" ]; do
  _DIR="$(cd -P "$(dirname "$_SCRIPT")" && pwd)"
  _SCRIPT="$(readlink "$_SCRIPT")"
  [[ "$_SCRIPT" != /* ]] && _SCRIPT="$_DIR/$_SCRIPT"
done
SCRIPT_DIR="$(cd -P "$(dirname "$_SCRIPT")/.." && pwd)"
unset _SCRIPT _DIR

# Parse flags
CHECK_MODE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)
      CHECK_MODE="yes"
      shift
      ;;
    *) shift ;;
  esac
done

# Load modules
source "$SCRIPT_DIR/lib/_loader.sh"
source_lib "tui.sh"
source_lib "cli-tools.sh"
source_lib "global-settings.sh"
trap 'tui_cleanup' EXIT INT TERM

ensure_valid_working_directory || exit 1

# ==============================================================================
# PHASE HEADER
# ==============================================================================
_phase() {
  local num="$1"
  local title="$2"
  tui_section "Phase ${num}: ${title}"
}

# ==============================================================================
# PHASE 1: SYSTEM CHECK
# ==============================================================================
phase_system_check() {
  _phase 1 "System Check"

  local ok=true

  # macOS / Linux
  local platform
  platform="$(uname -s)"
  case "$platform" in
    Darwin) echo "   Platform : macOS ($(sw_vers -productVersion 2> /dev/null || echo 'unknown'))" ;;
    Linux) echo "   Platform : Linux" ;;
    *) echo "   Platform : $platform (untested)" ;;
  esac

  # Node.js
  if command -v node &> /dev/null; then
    local node_ver
    node_ver="$(node -v 2> /dev/null)"
    tui_key_value "Node.js" "${node_ver}"
  else
    tui_error "Node.js not found (install from https://nodejs.org)"
    ok=false
  fi

  # npm
  if command -v npm &> /dev/null; then
    tui_key_value "npm" "$(npm -v 2> /dev/null)"
  else
    tui_error "npm not found"
    ok=false
  fi

  # cargo (optional — needed for agent-browser)
  if command -v cargo &> /dev/null; then
    tui_key_value "cargo" "$(cargo -V 2> /dev/null | awk '{print $2}')"
  else
    tui_warn "cargo not found (optional - needed for agent-browser)"
  fi

  if [ "$ok" = "false" ]; then
    echo ""
    tui_error "Required tools missing. Install them and re-run."
    exit 1
  fi
}

# ==============================================================================
# PHASE 2: CLI TOOLS
# ==============================================================================
phase_cli_tools() {
  _phase 2 "CLI Tools"
  if [ "$CHECK_MODE" = "yes" ]; then
    check_cli_tools
  else
    install_cli_tools
  fi
}

# ==============================================================================
# PHASE 3: GLOBAL SETTINGS
# ==============================================================================
phase_global_settings() {
  _phase 3 "Global Claude Settings"
  if [ "$CHECK_MODE" = "yes" ]; then
    check_global_settings
  else
    install_global_settings
  fi
}

# ==============================================================================
# PHASE 4: API KEYS CHECK
# ==============================================================================
phase_api_keys() {
  _phase 4 "API Keys"

  local any_missing=false

  _check_key() {
    local name="$1"
    local var="$2"
    local hint="$3"
    if [ -n "${!var:-}" ]; then
      tui_success "$name ($var)"
    else
      tui_warn "$name ($var) - not set"
      if [ "$CHECK_MODE" != "yes" ]; then
        echo "      Add to ~/.zshrc:  export ${var}=\"your-key-here\""
        [ -n "$hint" ] && echo "      Get key: $hint"
      fi
      any_missing=true
    fi
  }

  _check_key "Anthropic" "ANTHROPIC_API_KEY" "https://console.anthropic.com/settings/keys"
  _check_key "OpenAI" "OPENAI_API_KEY" "https://platform.openai.com/api-keys"
  _check_key "Gemini" "GEMINI_API_KEY" "https://aistudio.google.com/app/apikey"

  if [ "$any_missing" = "true" ] && [ "$CHECK_MODE" != "yes" ]; then
    echo ""
    echo "   After adding keys, reload shell:  source ~/.zshrc"
  fi
}

# ==============================================================================
# MAIN
# ==============================================================================
main() {
  if [ "$CHECK_MODE" = "yes" ]; then
    tui_banner "Developer Workstation Check" "Review the tools and settings used on this machine"
    tui_info "Dry-run mode: no changes will be made"
  else
    tui_banner "Developer Workstation Setup" "Install the shared tools and settings used on this machine"
  fi

  phase_system_check
  phase_cli_tools
  phase_global_settings
  phase_api_keys

  echo ""
  if [ "$CHECK_MODE" = "yes" ]; then
    tui_success "Check complete"
  else
    tui_success "Setup complete"
    echo ""
    echo "   Reload your shell to activate all tools:"
    echo "     source ~/.zshrc"
  fi
  echo ""
}

main
