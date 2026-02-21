# Spec: Auto-Detect System from Codebase Signals

> **Spec ID**: 009 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Resolve `--system auto` to a concrete system (shopify/nuxt/laravel/shopware/storyblok) via shell-based codebase signals so system-specific skills are actually installed.

## Context
When a user runs `npx @onedot/ai-setup` without `--system`, they select "auto" and Claude detects the stack in generation prompts — but system-specific skill installation uses a `case` statement that only matches concrete system names. Result: `auto` users never get system-specific skills. The fix is a shell-based detect function that resolves `auto` to a concrete system before skill installation.

## Steps
- [x] Step 1: Add `detect_system()` function in `bin/ai-setup.sh` after `select_system()` (~line 310)
- [x] Step 2: Detection signals (in priority order):
  - `theme.liquid` present → `shopify`
  - `composer.json` + `artisan` file → `laravel`
  - `composer.json` + `vendor/shopware` dir → `shopware`
  - `package.json` containing `"nuxt"` → `nuxt`
  - `package.json` containing `"@storyblok"` → `storyblok`
  - No match → keep `auto` (let generation prompts handle it)
- [x] Step 3: Call `detect_system` immediately after `select_system` resolves `SYSTEM="auto"`
- [x] Step 4: If resolved, print `"  🔍 Detected system: $SYSTEM"` and continue
- [x] Step 5: System-specific skills install with resolved system (existing case statement unchanged)
- [x] Step 6: Store resolved system in `.ai-setup.json` so `--regenerate` reuses it

## Acceptance Criteria
- [x] A Shopify repo with `theme.liquid` auto-resolves to `shopify` and installs Shopify skills
- [x] A Laravel repo with `artisan` auto-resolves to `laravel` and installs Laravel skills
- [x] Unknown stacks keep `SYSTEM=auto`, no skills installed, no crash
- [x] Detection is pure shell — no LLM call, no network request, <50ms

## Files to Modify
- `bin/ai-setup.sh` — add `detect_system()`, call it after system selection

## Out of Scope
- No changes to generation prompts (they already handle `$SYSTEM`)
- No new systems beyond the 5 already supported
- No UI changes to `select_system()` menu
