#!/bin/bash
# Interactive TUI menus: system selection, regeneration parts, update parts
# Sets: $SYSTEM, $REGEN_*, $UPD_*

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

# ==============================================================================
# REGENERATION PART SELECTOR
# ==============================================================================
# Sets REGEN_CLAUDE_MD, REGEN_CONTEXT, REGEN_COMMANDS, REGEN_SKILLS globals.
# Returns 1 if the user selected nothing (skip).
ask_regen_parts() {
  # Arrow keys + Space to toggle + Enter to confirm (same style as select_system)
  local options=("CLAUDE.md" "Context" "Commands" "Skills")
  local descriptions=("Commands & Critical Rules" ".agents/context/ (STACK, ARCHITECTURE, CONVENTIONS)" "Slash commands & agents (spec, commit, grill...)" "External skills from skills.sh")
  local count=4
  local selected=0
  local checked=(1 1 1 1)  # all pre-selected

  echo ""
  echo "  Select what to regenerate:"
  echo "  (Use ↑↓ arrows, Space to toggle, Enter to confirm)"
  echo ""

  printf '\033[?25l'
  trap 'printf "\033[?25h"' RETURN 2>/dev/null || true

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
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')
        read -rsn2 seq
        case "$seq" in
          '[A') selected=$(( (selected - 1 + count) % count )) ;;
          '[B') selected=$(( (selected + 1) % count )) ;;
        esac
        ;;
      " ")
        [ "${checked[$selected]}" -eq 1 ] && checked[$selected]=0 || checked[$selected]=1
        ;;
      "")
        break
        ;;
    esac

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

  printf '\033[?25h'

  REGEN_CLAUDE_MD="no"; REGEN_CONTEXT="no"; REGEN_COMMANDS="no"; REGEN_SKILLS="no"
  [ "${checked[0]}" -eq 1 ] && REGEN_CLAUDE_MD="yes"
  [ "${checked[1]}" -eq 1 ] && REGEN_CONTEXT="yes"
  [ "${checked[2]}" -eq 1 ] && REGEN_COMMANDS="yes"
  [ "${checked[3]}" -eq 1 ] && REGEN_SKILLS="yes"

  if [ "$REGEN_CLAUDE_MD" = "no" ] && [ "$REGEN_CONTEXT" = "no" ] && [ "$REGEN_COMMANDS" = "no" ] && [ "$REGEN_SKILLS" = "no" ]; then
    echo ""
    return 1
  fi
  return 0
}

# ==============================================================================
# UPDATE PART SELECTOR
# ==============================================================================
# Sets UPD_HOOKS, UPD_SETTINGS, UPD_COMMANDS, UPD_AGENTS, UPD_OTHER globals.
# Returns 1 if the user selected nothing (skip template update).
ask_update_parts() {
  local options=("Hooks" "Settings" "Commands" "Agents" "Other")
  local descriptions=(".claude/hooks/ (protect-files, lint, circuit-breaker...)" ".claude/settings.json" ".claude/commands/ (spec, commit, grill, pr...)" ".claude/agents/ (verify-app, build-validator, code-reviewer, code-architect...)" "specs/, github/, CLAUDE.md template")
  local count=5
  local selected=0
  local checked=(1 1 1 1 1)  # all pre-selected

  echo ""
  echo "  Select which categories to update:"
  echo "  (Use ↑↓ arrows, Space to toggle, Enter to confirm)"
  echo ""

  printf '\033[?25l'
  trap 'printf "\033[?25h"' RETURN 2>/dev/null || true

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
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')
        read -rsn2 seq
        case "$seq" in
          '[A') selected=$(( (selected - 1 + count) % count )) ;;
          '[B') selected=$(( (selected + 1) % count )) ;;
        esac
        ;;
      " ")
        [ "${checked[$selected]}" -eq 1 ] && checked[$selected]=0 || checked[$selected]=1
        ;;
      "")
        break
        ;;
    esac

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

  printf '\033[?25h'

  UPD_HOOKS="no"; UPD_SETTINGS="no"; UPD_COMMANDS="no"; UPD_AGENTS="no"; UPD_OTHER="no"
  [ "${checked[0]}" -eq 1 ] && UPD_HOOKS="yes"
  [ "${checked[1]}" -eq 1 ] && UPD_SETTINGS="yes"
  [ "${checked[2]}" -eq 1 ] && UPD_COMMANDS="yes"
  [ "${checked[3]}" -eq 1 ] && UPD_AGENTS="yes"
  [ "${checked[4]}" -eq 1 ] && UPD_OTHER="yes"

  if [ "$UPD_HOOKS" = "no" ] && [ "$UPD_SETTINGS" = "no" ] && [ "$UPD_COMMANDS" = "no" ] && [ "$UPD_AGENTS" = "no" ] && [ "$UPD_OTHER" = "no" ]; then
    echo ""
    return 1
  fi
  return 0
}

# ==============================================================================
# OVERWRITE CONFIRMATION
# ==============================================================================
# Prompts user to confirm overwriting a user-modified file.
# Returns 0 if user confirms overwrite, 1 to keep user's version.
ask_overwrite_modified() {
  local file="$1"
  printf "  ⚠️  %s (user-modified) — Overwrite with template? [y/N]: " "$file"
  local answer
  IFS= read -r answer </dev/tty
  case "$answer" in
    y|Y|yes|YES|Yes) return 0 ;;
    *)               return 1 ;;
  esac
}
