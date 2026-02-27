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

# Load modules
source "$SCRIPT_DIR/lib/_loader.sh"
source_lib "core.sh"
source_lib "process.sh"
source_lib "detect.sh"
source_lib "tui.sh"
source_lib "skills.sh"
source_lib "generate.sh"
source_lib "update.sh"
source_lib "setup.sh"
source_lib "plugins.sh"

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
  handle_version_check
fi

# ==============================================================================
# NORMAL SETUP MODE
# ==============================================================================
echo "🚀 Starting AI Setup (Claude Code + Skills)..."

check_requirements
cleanup_legacy
install_claude_md
install_settings
install_hooks
install_rules
install_copilot
mkdir -p .agents
install_specs
install_commands
install_shopify_skills
install_agents
echo "📋 Writing installation metadata..."
write_metadata
update_gitignore
generate_repomix_snapshot

# Plugins & extensions
echo ""
echo "🔌 Plugins & Extensions"
echo "   ──────────────────────────────────────────────────────────"

install_gsd
install_claude_mem
install_official_plugins
install_context7
install_playwright
show_plugin_summary

# Auto-Init
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
      _NOTIFY_MSG="Auto-Init complete. Run /gsd:map-codebase for deeper analysis"
    else
      _NOTIFY_MSG="Auto-Init complete!"
    fi
    case "$(uname -s)" in
      Darwin) osascript -e "display notification \"$_NOTIFY_MSG\" with title \"AI Setup\" sound name \"Glass\"" 2>/dev/null || true ;;
      Linux) command -v notify-send >/dev/null 2>&1 && notify-send "AI Setup" "$_NOTIFY_MSG" 2>/dev/null || true ;;
    esac
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

show_installation_summary
show_next_steps
