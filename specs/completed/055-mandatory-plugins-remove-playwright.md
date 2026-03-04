# Spec: Mandatory Plugins, Remove Playwright & GSD

> **Spec ID**: 055 | **Created**: 2026-03-04 | **Status**: completed | **Branch**: spec/055-mandatory-plugins-remove-playwright

## Goal
Remove Playwright MCP and GSD from setup, make context7 and claude-mem always install, and install all official plugins without prompts. GSD moves to README as optional extension.

## Context
The current plugin system asks 5 interactive prompts during setup, contradicting the "zero configuration" philosophy. Playwright is niche and rarely needed. GSD is a separate ecosystem that should be documented as an extension, not bundled. Context7 (docs lookup) and claude-mem (persistent memory) are core features that should always be present. Official plugins provide proven value and should install by default.

## Steps
- [ ] Step 1: Remove `install_playwright()` and `install_gsd()` functions from `lib/plugins.sh` and their calls in `bin/ai-setup.sh`
- [ ] Step 2: Remove all `--with-*` / `--no-*` CLI flags from `bin/ai-setup.sh` (playwright, context7, claude-mem, plugins, gsd)
- [ ] Step 3: Modify `install_claude_mem()` in `lib/plugins.sh` — remove interactive prompt, always install
- [ ] Step 4: Modify `install_official_plugins()` in `lib/plugins.sh` — remove selection UI, install all plugins
- [ ] Step 5: Modify `install_context7()` in `lib/plugins.sh` — remove interactive prompt, always install
- [ ] Step 6: Update `.agents/context/CONCEPT.md` — remove "Optional integrations" references to GSD/Playwright
- [ ] Step 7: Add GSD to `README.md` as optional extension with install instructions
- [ ] Step 8: Verify: `./bin/ai-setup.sh --help` shows no removed flags, dry-run has zero plugin prompts

## Acceptance Criteria
- [ ] Playwright MCP and GSD are completely removed from setup code
- [ ] Running setup installs context7, claude-mem, and all official plugins without any prompts
- [ ] GSD is documented in README as optional extension
- [ ] All existing idempotency checks (skip if already installed) still work

## Files to Modify
- `lib/plugins.sh` — remove playwright + gsd, remove prompts from context7/claude-mem/official-plugins
- `bin/ai-setup.sh` — remove CLI flags, remove playwright + gsd calls
- `.agents/context/CONCEPT.md` — update integrations text
- `README.md` — add GSD as optional extension section

## Out of Scope
- Adding new plugins or MCP servers
- Changing the MCP merge logic in plugins.sh
