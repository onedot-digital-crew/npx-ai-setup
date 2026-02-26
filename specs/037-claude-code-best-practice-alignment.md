# Spec: Align with Official Claude Code Best Practices

> **Spec ID**: 037 | **Created**: 2026-02-27 | **Status**: in-review | **Branch**: spec/037-claude-code-best-practice-alignment

## Goal
Close 8 gaps between our templates and official Claude Code standards: SKILL.md rename, enriched frontmatter, settings schema, sandbox, attribution, disable-model-invocation, and cross-platform notification hook.

## Context
Audit against code.claude.com/docs found our skills use the legacy `prompt.md` filename (official is now `SKILL.md`), skills lack `description` needed for auto-discovery, settings.json misses `$schema`/sandbox/attribution, destructive commands allow model self-invocation, and the notification hook is macOS-only. All gaps are fixable without architectural changes.

## Steps
- [x] Step 1: Rename all `templates/skills/*/prompt.md` to `SKILL.md` and add `name` + `description` frontmatter to each; update `bin/ai-setup.sh` template map (~lines 104-111) to reference `SKILL.md` instead of `prompt.md`
- [x] Step 2: Add `disable-model-invocation: true` frontmatter to destructive commands: `commit.md`, `release.md`, `pr.md`, `spec-work.md`, `spec-work-all.md`
- [x] Step 3: Add `argument-hint` to commands that take arguments: `spec.md` (`[task description]`), `bug.md` (`[bug description]`), `spec-work.md` (`[spec number]`), `spec-review.md` (`[spec number]`)
- [x] Step 4: In `templates/claude/settings.json`: add `"$schema": "https://json.schemastore.org/claude-code-settings.json"`, add `"respectGitignore": true`, add `"attribution"` block with Co-Authored-By
- [x] Step 5: In `templates/claude/settings.json`: add `"sandbox": {"enabled": true}` with network allowlist for common domains (github.com, npmjs.org, skills.sh)
- [x] Step 6: Replace macOS-only `osascript` notification hook with a cross-platform script that detects OS and uses `osascript` on macOS, `notify-send` on Linux, or silent fallback
- [x] Step 7: In `bin/ai-setup.sh`, update the skill install path to copy `SKILL.md` to `.claude/skills/<name>/SKILL.md`; add backwards-compat: if target has old `prompt.md`, rename it
- [x] Step 8: Run `./tests/smoke.sh` to verify all renamed/modified templates deploy correctly

## Acceptance Criteria
- [x] All skill templates use `SKILL.md` with `name` and `description` in frontmatter
- [x] Destructive commands have `disable-model-invocation: true`
- [x] `settings.json` has `$schema`, `sandbox`, `attribution`, `respectGitignore`
- [x] Notification hook works on macOS and Linux
- [x] Smoke tests pass

## Files to Modify
- `templates/skills/*/prompt.md` → rename to `SKILL.md` + update frontmatter (8 files)
- `templates/commands/{commit,release,pr,spec-work,spec-work-all,spec,bug,spec-review}.md` — add frontmatter fields
- `templates/claude/settings.json` — add schema, sandbox, attribution, respectGitignore
- `bin/ai-setup.sh` — update skill template paths and add backwards-compat migration

## Out of Scope
- Migrating commands from `.claude/commands/` to `.claude/skills/` (both work, no urgency)
- Adding `context: fork` to existing commands (requires per-command design)
- Plugin system configuration (not enough adoption yet)
