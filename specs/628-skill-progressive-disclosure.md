# Spec: Skill Progressive Disclosure + Install Refactor

> **Spec ID**: 628 | **Created**: 2026-04-06 | **Status**: draft | **Complexity**: high | **Branch**: --
> **Depends on**: Spec 627 (frontmatter normalization)

## Goal
Enable multi-file skills with supporting files and add a skill lint script for structural validation.

## Context
Install system (`lib/setup.sh:653`) only copies `SKILL.template.md` per skill. Skills like analyze (237L), research (189L), reflect (167L) exceed the recommended 500-line soft limit and pack everything into one file. Supporting files (`references/*.md`) need install logic changes. A lint script prevents regression.

### Verified Assumptions
- `install_skills()` uses `find -maxdepth 1 -type d` and only copies SKILL.template.md -- Evidence: `lib/setup.sh:657-664` | Confidence: High | If Wrong: supporting files may already be copied
- Claude Code loads files referenced from SKILL.md on demand -- Evidence: docs "Reference supporting files from SKILL.md" | Confidence: High | If Wrong: files must be in context at load time

## Steps
- [ ] Step 1: Extend `install_skills()` in `lib/setup.sh` to copy `references/*.md` files alongside SKILL.md
- [ ] Step 2: Extend `scan_template_changes()` in `lib/update.sh` to track checksums for supporting files
- [ ] Step 3: Split `templates/skills/analyze/SKILL.template.md` -- move detail content to `references/`
- [ ] Step 4: Split `templates/skills/research/SKILL.template.md` -- move scraper/synthesis details to `references/`
- [ ] Step 5: Create `scripts/skill-lint.sh` -- validate name kebab-case, description <=220 chars, required sections (Goal/Workflow/Rules)
- [ ] Step 6: Add skill-lint to doctor.sh health checks

## Acceptance Criteria
- [ ] `references/*.md` files are installed to `.claude/skills/*/references/` on fresh setup
- [ ] `/update` detects and syncs changed supporting files
- [ ] `bash scripts/skill-lint.sh` passes on all templates
- [ ] Split skills still function correctly (manual test: `/analyze`, `/research`)

## Files to Modify
- `lib/setup.sh` -- extend install_skills() glob
- `lib/update.sh` -- extend scan_template_changes() checksums
- `templates/skills/analyze/` -- split into SKILL.md + references/
- `templates/skills/research/` -- split into SKILL.md + references/
- `scripts/skill-lint.sh` -- new file

## Out of Scope
- Skill archetype templates (workflow/knowledge/forked variants)
- CI enforcement of lint (future)
- Splitting all 30 skills (only analyze + research initially)
