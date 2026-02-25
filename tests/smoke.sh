#!/usr/bin/env bash
# Smoke test for bin/ai-setup.sh and lib/ modules
# Checks syntax and key function presence — does NOT execute the script interactively.

set -euo pipefail

PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "=== Smoke test: modular ai-setup ==="

# Step 1: Verify all lib modules exist
echo ""
echo "--- Module existence ---"
MODULES=("_loader.sh" "core.sh" "process.sh" "detect.sh" "tui.sh" "skills.sh" "generate.sh" "update.sh" "setup.sh" "plugins.sh")
for mod in "${MODULES[@]}"; do
  if [ -f "lib/$mod" ]; then
    pass "lib/$mod exists"
  else
    fail "lib/$mod missing"
  fi
done

# Step 2: Syntax check all files
echo ""
echo "--- Syntax checks (bash -n) ---"
if bash -n bin/ai-setup.sh 2>&1; then
  pass "bin/ai-setup.sh syntax"
else
  fail "bin/ai-setup.sh syntax"
fi

for mod in "${MODULES[@]}"; do
  if [ -f "lib/$mod" ]; then
    if bash -n "lib/$mod" 2>&1; then
      pass "lib/$mod syntax"
    else
      fail "lib/$mod syntax"
    fi
  fi
done

# Step 3: Key function presence in expected modules
echo ""
echo "--- Function location checks ---"
CHECKS=(
  "core.sh:build_template_map"
  "core.sh:get_package_version"
  "core.sh:compute_checksum"
  "core.sh:write_metadata"
  "core.sh:backup_file"
  "core.sh:collect_project_files"
  "process.sh:kill_tree"
  "process.sh:progress_bar"
  "process.sh:wait_parallel"
  "detect.sh:detect_system"
  "detect.sh:should_update_template"
  "tui.sh:select_system"
  "tui.sh:ask_regen_parts"
  "tui.sh:ask_update_parts"
  "skills.sh:search_skills"
  "skills.sh:get_keyword_skills"
  "skills.sh:install_skill"
  "generate.sh:run_generation"
  "update.sh:handle_version_check"
  "update.sh:run_smart_update"
  "update.sh:run_clean_reinstall"
  "setup.sh:check_requirements"
  "setup.sh:cleanup_legacy"
  "setup.sh:install_hooks"
  "setup.sh:install_commands"
  "setup.sh:install_agents"
  "setup.sh:update_gitignore"
  "plugins.sh:install_gsd"
  "plugins.sh:install_claude_mem"
  "plugins.sh:install_context7"
  "plugins.sh:install_playwright"
  "plugins.sh:show_installation_summary"
  "plugins.sh:show_next_steps"
)

for check in "${CHECKS[@]}"; do
  IFS=':' read -r mod fn <<< "$check"
  if grep -q "${fn}()" "lib/$mod" 2>/dev/null; then
    pass "${fn}() in lib/$mod"
  else
    fail "${fn}() missing from lib/$mod"
  fi
done

# Step 4: Verify main script sources modules
echo ""
echo "--- Module sourcing in bin/ai-setup.sh ---"
for mod in "${MODULES[@]}"; do
  if grep -q "$mod" bin/ai-setup.sh 2>/dev/null; then
    pass "bin/ai-setup.sh sources $mod"
  else
    fail "bin/ai-setup.sh does not source $mod"
  fi
done

# Step 5: Verify package.json includes lib/
echo ""
echo "--- Distribution checks ---"
if grep -q '"lib/"' package.json 2>/dev/null; then
  pass "package.json includes lib/ in files"
else
  fail "package.json missing lib/ in files"
fi

# Summary
echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
