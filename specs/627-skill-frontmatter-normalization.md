# Spec: Skill Frontmatter Normalization

> **Spec ID**: 627 | **Created**: 2026-04-06 | **Status**: draft | **Complexity**: medium | **Branch**: --

## Goal
Normalize all 30 skill template frontmatter fields to match Claude Code docs best practices.

## Context
External audit + docs review revealed: `name:` uses non-standard `ais:` prefix, `description:` is overloaded with Triggers-lists, `effort:`/`disable-model-invocation:`/`argument-hint:` are missing on most skills. All changes are frontmatter-only -- zero install logic changes needed.

### Verified Assumptions
- `name:` field determines slash command name; `ais:` prefix creates `/ais:spec` instead of `/spec` -- Evidence: Claude Code docs "lowercase, numbers, hyphens only" | Confidence: High | If Wrong: directory name takes precedence anyway
- `effort:` field is supported in current Claude Code -- Evidence: docs frontmatter reference | Confidence: High | If Wrong: field silently ignored

## Steps
- [ ] Step 1: Remove `ais:` prefix from all `name:` fields across `templates/skills/*/SKILL.template.md` -- use kebab-case only
- [ ] Step 2: Trim `description:` to max 220 chars per skill -- remove "Triggers:" lists, front-load natural use-case phrases
- [ ] Step 3: Add `effort:` field -- `high` for spec/research/challenge/analyze/debug, `low` for explore/doctor/scan/spec-validate
- [ ] Step 4: Add `disable-model-invocation: true` for side-effect skills: release, commit, pause, spec-run, spec-run-all, spec-work-all
- [ ] Step 5: Add `argument-hint:` to all skills that use $ARGUMENTS (spec, challenge, debug, research, build-fix, spec-work, spec-run, spec-review, spec-validate)
- [ ] Step 6: Regenerate installed `.claude/skills/*/SKILL.md` from updated templates (run install_skills or /update)

## Acceptance Criteria
- [ ] `grep -r "ais:" templates/skills/*/SKILL.template.md` returns zero matches
- [ ] No `description:` field exceeds 220 characters
- [ ] All side-effect skills have `disable-model-invocation: true`
- [ ] `/update` installs updated skills without error

## Files to Modify
- `templates/skills/*/SKILL.template.md` (all 30 files) -- frontmatter only

## Out of Scope
- Supporting files / Progressive Disclosure (see Spec 628)
- Install logic changes
- Skill content/body changes
