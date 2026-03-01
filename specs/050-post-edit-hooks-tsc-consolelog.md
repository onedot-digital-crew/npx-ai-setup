# Spec: Extend post-edit-lint.sh with TSC Check and Console.log Warning

> **Spec ID**: 050 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/050-post-edit-hooks-tsc-consolelog

## Goal
Add TypeScript compile-check and console.log warning to the existing `post-edit-lint.sh` hook so type errors and debug leaks are caught automatically on every file edit.

## Context
`post-edit-lint.sh` already runs ESLint (line 6) and Prettier (line 14) on every Edit/Write. Two gaps: (1) no `tsc --noEmit` for TS files — type errors only surface at build time; (2) no console.log detection — debug leaks ship silently. Both fire automatically with zero user action required, making them ideal for teams that won't use manual commands.

## Steps
- [ ] Step 1: After the ESLint block (line 12) in `templates/claude/hooks/post-edit-lint.sh`, add a `tsc --noEmit` block that runs only for `.ts`/`.tsx` files AND only when `tsconfig.json` exists in `$PWD`
- [ ] Step 2: Capture tsc output, exit 1 with truncated output on failure (same pattern as ESLint block lines 7-11)
- [ ] Step 3: After the Prettier block, add a console.log detection block for `.js`/`.ts`/`.jsx`/`.tsx` files using `grep -n "console\.log"` — print a warning to stderr (not exit 1, non-blocking)
- [ ] Step 4: Verify the script still exits 0 cleanly on a file with no issues

## Acceptance Criteria
- [ ] `tsc --noEmit` runs after ESLint for TS files when `tsconfig.json` is present
- [ ] TSC failure exits 1 and blocks the edit (same as ESLint)
- [ ] console.log detection prints `⚠️ console.log found` warning but does NOT block
- [ ] Script is still POSIX-compatible bash (no bash4+ syntax)

## Files to Modify
- `templates/claude/hooks/post-edit-lint.sh` - add tsc and console.log blocks

## Out of Scope
- Configuring which tsconfig to use (always use project root `tsconfig.json`)
- Making console.log a hard error (warning only — projects may have legitimate uses)
- ESLint `no-console` rule configuration
