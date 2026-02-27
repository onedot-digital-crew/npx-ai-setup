# Spec: Expand .claude/rules/ template system with modular rules and memory docs

> **Spec ID**: 044 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/044-rules-template-expansion

## Goal
Add modular rule templates, conditional TypeScript rules, opusplan model, and enrich template CLAUDE.md with memory docs, power-user tips, and @imports pattern.

## Context
The `.claude/rules/` directory is Claude Code's official modular instruction system. We already ship `general.md` and have `install_rules()` infrastructure. This spec adds two universal rule files (testing, git), one conditional rule file (TypeScript), sets `opusplan` as default model, and enriches template CLAUDE.md with the memory clarification, `ultrathink:` prefix, `!command` shortcut, and `@imports` pattern. `CLAUDE.local.md` is also added to gitignore for personal project preferences.

## Steps
- [x] Step 1: Create `templates/claude/rules/testing.md` — test-first rules, assertion expectations, edge case coverage, no mocks-by-default
- [x] Step 2: Create `templates/claude/rules/git.md` — commit message format, branch naming, no force-push, no --no-verify
- [x] Step 3: Create `templates/claude/rules/typescript.md` — strict types, no `any`, prefer inference, use existing project patterns
- [x] Step 4: Add `TS_RULES_MAP` to `lib/core.sh` — conditional map for TypeScript rules, skip `claude/rules/typescript.md` in `build_template_map()`
- [x] Step 5: Extend `install_rules()` in `lib/setup.sh` to install conditional TS rules when `*.ts`/`*.tsx` files detected; also add `CLAUDE.local.md` to `update_gitignore()`
- [x] Step 6: Add `"model": "opusplan"` to `templates/claude/settings.json` — Opus in plan mode, Sonnet in execution
- [x] Step 7: Update `templates/CLAUDE.md` — (a) replace "Required Plugins" with "Memory" section (Built-in Auto Memory + claude-mem), (b) add Tips section: `ultrathink:` prefix for deep reasoning, `!command` for instant bash, `@path` imports, one-conversation-per-task rule
- [x] Step 8: Verify idempotency — run setup twice on a test project, confirm no duplicates or overwrites

## Acceptance Criteria
- [x] `general.md`, `testing.md`, `git.md` installed for all projects; `typescript.md` only when TS detected
- [x] `CLAUDE.local.md` present in `.gitignore` after install
- [x] `opusplan` set in installed `.claude/settings.json`
- [x] Template CLAUDE.md has Memory section and Tips section with ultrathink/!/@ hints
- [x] Running setup twice produces identical results (idempotent)

## Files to Modify
- `templates/claude/rules/testing.md` — new file
- `templates/claude/rules/git.md` — new file
- `templates/claude/rules/typescript.md` — new file (conditional)
- `lib/core.sh` — add TS_RULES_MAP + exclude pattern
- `lib/setup.sh` — conditional TS rules + CLAUDE.local.md in gitignore
- `templates/claude/settings.json` — add opusplan model
- `templates/CLAUDE.md` — memory section + tips section

## Out of Scope
- Path-specific rules with YAML frontmatter (teams add these themselves)
- Additional language-specific rules (Python, Go) — future spec
- Changes to claude-mem plugin itself
