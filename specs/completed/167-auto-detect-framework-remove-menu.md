# Spec: Replace interactive framework menu with auto-detection

> **Spec ID**: 167 | **Created**: 2026-03-23 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal
Remove the interactive framework selection menu from installation and replace it with automatic detection based on config files.

## Context
`select_boilerplate_system()` shows a 6-option menu during every fresh install. External users have no access to the boilerplate repos, and internal users can be auto-detected. The auto-detection pattern already exists in `customize_settings_for_stack()` (Spec 166). Boilerplate pull via `gh` stays intact — just triggered automatically instead of interactively.

### Verified Assumptions
- Boilerplate repos (onedot-digital-crew/sp-*) remain active — Evidence: `lib/boilerplate.sh:6` | Confidence: High | If Wrong: pull silently fails, no breakage
- Auto-detection is reliable for nuxt/next via config files — Evidence: `nuxt.config.*`/`next.config.*` are standard | Confidence: High | If Wrong: those frameworks won't get auto-pulled
- Shopware/Storyblok lack unique config file markers — Evidence: no standard `shopware.config.*` | Confidence: High | If Wrong: could add detection later
- Silent fallback (no detection = no pull) is acceptable — Evidence: user confirmation | Confidence: High

## Steps
- [x] Step 1: Rewrite `select_boilerplate_system()` in `lib/boilerplate.sh` — remove interactive menu, add auto-detection (`nuxt.config.*` → nuxt, `next.config.*` → next, `theme.liquid` or `shopify.` in config → shopify), set `SELECTED_SYSTEM`, call `pull_boilerplate_files` if detected and `gh` available
- [x] Step 2: Remove the `tui_section "Framework Files"` and `ask_single_choice_menu` imports/calls — verify no other callers depend on the interactive flow
- [x] Step 3: Update smoke test in `tests/smoke.sh` — verify `select_boilerplate_system` function still exists (it does, just non-interactive now)
- [x] Step 4: Run `bash tests/smoke.sh` and verify all tests pass

## Acceptance Criteria

### Truths
- [ ] `npx @onedot/ai-setup` no longer shows a framework selection menu
- [ ] `SELECTED_SYSTEM` is correctly set via auto-detection when `nuxt.config.ts` exists
- [ ] `customize_settings_for_stack()` still works (uses same `SELECTED_SYSTEM` variable)
- [ ] Smoke tests pass (287+ tests)

### Artifacts
- [ ] `lib/boilerplate.sh` — `select_boilerplate_system()` uses auto-detection, no interactive menu

## Files to Modify
- `lib/boilerplate.sh` — rewrite `select_boilerplate_system()` to auto-detect

## Out of Scope
- Adding CLI flag `--framework <name>` (separate spec if needed)
- Shopware/Storyblok auto-detection (no unique config file markers)
- Removing `pull_boilerplate_files()` or the boilerplate repo mechanism
