# Spec: Pre-Release Validation Script

> **Spec ID**: 127 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

## Goal
Add a validation script that checks version consistency, changelog entries, and template integrity before publishing a new release.

## Context
Manual release checks are error-prone. Octopus has `validate-release.sh` that verifies version consistency across files, changelog presence, and git tag existence. We need the same for @onedot/ai-setup releases. Adapted from claude-octopus scripts/validate-release.sh.

## Steps
- [ ] Step 1: Create `scripts/validate-release.sh` with checks: version matches in package.json + CHANGELOG.md, git tag exists, no uncommitted changes
- [ ] Step 2: Add template integrity check: all files in `templates/` are valid (no empty files, no broken symlinks)
- [ ] Step 3: Add command/agent count validation: templates/commands/ count matches expected, no orphaned files
- [ ] Step 4: Integrate into `/release` command as pre-flight check (run before version bump)

## Acceptance Criteria
- [ ] Script validates version consistency across package.json and CHANGELOG.md
- [ ] Script checks template directory integrity (no empty/broken files)
- [ ] Script exits 1 with clear error messages on any validation failure
- [ ] `/release` command runs validation before proceeding

## Files to Modify
- `scripts/validate-release.sh` — new
- `templates/commands/release.md` — add pre-flight validation step

## Out of Scope
- GitHub Actions CI integration
- Automated publishing to npm
