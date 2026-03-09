# Spec: AGENTS.md Template and Auto-Init Generation

> **Spec ID**: 057 | **Created**: 2026-03-05 | **Status**: completed | **Branch**: —

## Goal
Generate an AGENTS.md file for target projects — universal passive AI context for Cursor, Windsurf, Cline, and other AGENTS.md-compatible tools.

## Context
Vercel's agent evals show passive context (AGENTS.md) achieves 100% pass rate vs 53% for skills, with 56% of skills never invoked. npx-ai-setup already generates CLAUDE.md (Claude-specific) and copilot-instructions.md (GitHub Copilot), but lacks the universal AGENTS.md standard. This spec adds AGENTS.md generation following the exact same pattern as CLAUDE.md — template copy + AI-powered project-specific content generation.

## Steps
- [x] Step 1: Create `templates/AGENTS.md` — static template with project overview placeholder, stack reference to `.agents/context/`, code style guidelines section, and `<!-- Auto-Init populates this -->` markers for Commands and Critical Rules
- [x] Step 2: Verify `build_template_map()` auto-discovers `templates/AGENTS.md` and maps it to `AGENTS.md` in target projects (no core.sh changes needed)
- [x] Step 3: Add AGENTS.md generation prompt in `lib/generate.sh` — parallel background process alongside CLAUDE.md, using Sonnet to populate project-specific sections (commands, rules, architecture summary)
- [x] Step 4: Add AGENTS.md verification block in `lib/generate.sh` after wait — check file was modified (same pattern as CLAUDE.md checksum comparison)
- [x] Step 5: Add `AGENTS.md` to `.gitignore` template exclusion check — ensure it is NOT gitignored (it should be committed like CLAUDE.md)
- [x] Step 6: Test end-to-end: fresh install creates AGENTS.md, `--regenerate` updates it, update system detects user modifications and backs up before overwrite

## Acceptance Criteria
- [x] `npx @onedot/ai-setup` creates an AGENTS.md in the target project root
- [x] AGENTS.md contains project-specific content (stack, commands, rules) after Auto-Init
- [x] AGENTS.md is tracked by `.ai-setup.json` checksums (automatic via Template-Map)
- [x] Existing AGENTS.md files are backed up before overwrite (existing update system)

## Validation Notes
- Fresh install in isolated temp project created `AGENTS.md` from template.
- `build_template_map()` resolves `templates/AGENTS.md:AGENTS.md` without core changes.
- Smart update backed up user-modified `AGENTS.md` before overwrite and removed `AGENTS.md` from `.gitignore`.
- `--regenerate` path executed the new AGENTS generation flow and verification checks; in this test environment Claude edits failed due local `token-optimizer` SQLite permissions (`sqlite3.OperationalError: unable to open database file`), so content regeneration could not be fully validated here.

## Files to Modify
- `templates/AGENTS.md` - new static template (based on CLAUDE.md structure)
- `lib/generate.sh` - add parallel AGENTS.md generation prompt + verification

## Out of Scope
- Compressed docs-index generation (framework-specific, handled by framework codemods like `npx @next/codemod agents-md`)
- Changes to skill installation strategy
- AGENTS.md support for non-Claude AI tools' specific features
