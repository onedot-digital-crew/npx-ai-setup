#!/bin/bash
# Update/reinstall logic: version detection, smart update, clean reinstall
# Requires: core.sh, detect.sh, tui.sh, generate.sh

# Handle version check and route to update, reinstall, or exit
# Called when .ai-setup.json exists. May exit the script.
handle_version_check() {
  INSTALLED_VERSION=$(get_installed_version)
  PACKAGE_VERSION=$(get_package_version)

  if [ -n "$INSTALLED_VERSION" ] && [ "$INSTALLED_VERSION" = "$PACKAGE_VERSION" ]; then
    # Same version — already up to date
    echo ""
    echo "✅ Already up to date (v${PACKAGE_VERSION})."
    echo ""
    if command -v claude &>/dev/null; then
      if ask_regen_parts; then
        if [ -z "$SYSTEM" ]; then
          select_system
        fi
        detect_system
        run_generation
        write_metadata
        echo ""
        echo "✅ Regeneration complete!"
      fi
    fi
    exit 0

  elif [ -n "$INSTALLED_VERSION" ]; then
    # Different version — offer update options
    echo ""
    echo "🔄 Update available: v${INSTALLED_VERSION} → v${PACKAGE_VERSION}"
    echo ""
    echo "   1) Update       — smart update (backup modified files, update templates)"
    echo "   2) Reinstall    — delete managed files, fresh install from scratch"
    echo "   3) Skip         — exit without changes"
    echo ""
    read -p "   Choose [1/2/3]: " UPDATE_CHOICE

    case "$UPDATE_CHOICE" in
      1)
        run_smart_update
        exit 0
        ;;
      2)
        run_clean_reinstall
        # Fall through to normal setup below (caller continues)
        ;;
      *)
        echo "   Skipped. No changes made."
        exit 0
        ;;
    esac
  fi
}

# Smart update: checksum diffing, selective category update, backup user-modified files
run_smart_update() {
  echo ""
  echo "🔍 Analyzing templates..."
  echo ""

  UPD_UPDATED=0
  UPD_SKIPPED=0
  UPD_NEW=0
  UPD_BACKED_UP=0

  # Ask which template categories to update
  ask_update_parts || echo "  ⏭️  No categories selected — skipping template updates"
  echo ""

  for mapping in "${TEMPLATE_MAP[@]}"; do
    should_update_template "$mapping" || continue
    tpl="${mapping%%:*}"
    target="${mapping#*:}"

    # Target doesn't exist — install as new
    if [ ! -f "$target" ]; then
      if [ -f "$SCRIPT_DIR/$tpl" ]; then
        mkdir -p "$(dirname "$target")"
        cp "$SCRIPT_DIR/$tpl" "$target"
        [[ "$target" == *.sh ]] && chmod +x "$target"
        echo "  ✨ $target (new)"
        UPD_NEW=$((UPD_NEW + 1))
      fi
      continue
    fi

    # Compare template to installed file
    tpl_cs=$(compute_checksum "$SCRIPT_DIR/$tpl")
    cur_cs=$(compute_checksum "$target")

    if [ "$tpl_cs" = "$cur_cs" ]; then
      # Template and installed file are identical — skip
      echo "  ⏭️  $target (unchanged)"
      UPD_SKIPPED=$((UPD_SKIPPED + 1))
      continue
    fi

    # Template differs — check if user modified the file
    stored_cs=$(jq -r --arg f "$target" '.files[$f] // empty' .ai-setup.json 2>/dev/null)

    if [ -n "$stored_cs" ] && [ "$stored_cs" != "$cur_cs" ]; then
      # User modified — backup first
      bp=$(backup_file "$target")
      cp "$SCRIPT_DIR/$tpl" "$target"
      [[ "$target" == *.sh ]] && chmod +x "$target"
      echo "  ⚠️  $target (user-modified — backed up to $bp)"
      UPD_BACKED_UP=$((UPD_BACKED_UP + 1))
    else
      # Not modified by user — silent update
      cp "$SCRIPT_DIR/$tpl" "$target"
      [[ "$target" == *.sh ]] && chmod +x "$target"
      echo "  ✅ $target (updated)"
    fi
    UPD_UPDATED=$((UPD_UPDATED + 1))
  done

  # Also update Shopify-specific skills if system includes shopify
  if [[ "${SYSTEM:-}" == *shopify* ]]; then
    for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
      should_update_template "$mapping" || continue
      tpl="${mapping%%:*}"
      target="${mapping#*:}"
      if [ ! -f "$target" ]; then
        if [ -f "$SCRIPT_DIR/$tpl" ]; then
          mkdir -p "$(dirname "$target")"
          cp "$SCRIPT_DIR/$tpl" "$target"
          echo "  ✨ $target (new)"
          UPD_NEW=$((UPD_NEW + 1))
        fi
        continue
      fi
      tpl_cs=$(compute_checksum "$SCRIPT_DIR/$tpl")
      cur_cs=$(compute_checksum "$target")
      if [ "$tpl_cs" = "$cur_cs" ]; then
        echo "  ⏭️  $target (unchanged)"
        UPD_SKIPPED=$((UPD_SKIPPED + 1))
        continue
      fi
      stored_cs=$(jq -r --arg f "$target" '.files[$f] // empty' .ai-setup.json 2>/dev/null)
      if [ -n "$stored_cs" ] && [ "$stored_cs" != "$cur_cs" ]; then
        bp=$(backup_file "$target")
        cp "$SCRIPT_DIR/$tpl" "$target"
        echo "  ⚠️  $target (user-modified — backed up to $bp)"
        UPD_BACKED_UP=$((UPD_BACKED_UP + 1))
      else
        cp "$SCRIPT_DIR/$tpl" "$target"
        echo "  ✅ $target (updated)"
      fi
      UPD_UPDATED=$((UPD_UPDATED + 1))
    done
  fi

  echo ""
  echo "📊 Update summary:"
  echo "   Updated:   $UPD_UPDATED"
  [ $UPD_NEW -gt 0 ] && echo "   New:       $UPD_NEW"
  [ $UPD_SKIPPED -gt 0 ] && echo "   Unchanged: $UPD_SKIPPED"
  [ $UPD_BACKED_UP -gt 0 ] && echo "   Backed up: $UPD_BACKED_UP (see .ai-setup-backup/)"
  _upd_cats=""
  [ "${UPD_HOOKS:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Hooks"
  [ "${UPD_SETTINGS:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Settings"
  [ "${UPD_COMMANDS:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Commands"
  [ "${UPD_AGENTS:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Agents"
  [ "${UPD_OTHER:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Other"
  [ -n "$_upd_cats" ] && echo "   Categories: $_upd_cats"

  # Update metadata
  write_metadata

  # Check context files and offer AI regeneration
  if command -v claude &>/dev/null; then
    echo ""
    # Count existing .agents/context/ files (Steps 1-2)
    CTX_EXISTING=0
    [ -f ".agents/context/STACK.md" ] && CTX_EXISTING=$((CTX_EXISTING + 1))
    [ -f ".agents/context/ARCHITECTURE.md" ] && CTX_EXISTING=$((CTX_EXISTING + 1))
    [ -f ".agents/context/CONVENTIONS.md" ] && CTX_EXISTING=$((CTX_EXISTING + 1))
    CTX_MISSING=$((3 - CTX_EXISTING))
    if [ "$CTX_MISSING" -gt 0 ]; then
      echo "  ⚠️  $CTX_MISSING of 3 context files missing in .agents/context/ — regeneration recommended"
      echo ""
    fi
    # Use granular selector instead of binary y/N (Steps 3-4)
    if ask_regen_parts; then
      if [ -z "$SYSTEM" ]; then
        select_system
      fi
      detect_system
      run_generation
      write_metadata
      echo ""
      echo "✅ Regeneration complete!"
    fi
  fi

  echo ""
  echo "✅ Update complete! (v${INSTALLED_VERSION} → v${PACKAGE_VERSION})"
}

# Clean reinstall: remove all managed files, reset metadata
run_clean_reinstall() {
  echo ""
  echo "🗑️  Removing managed files..."

  for mapping in "${TEMPLATE_MAP[@]}"; do
    target="${mapping#*:}"
    if [ -f "$target" ]; then
      rm -f "$target"
      echo "   Removed: $target"
    fi
  done

  # Also remove Shopify-specific skills
  for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
    target="${mapping#*:}"
    if [ -f "$target" ]; then
      rm -f "$target"
      echo "   Removed: $target"
    fi
  done

  # Remove metadata and backup dir
  rm -f .ai-setup.json
  echo ""
  echo "   Clean slate ready. Running fresh install..."
  echo ""
  # Caller continues to normal setup
}
