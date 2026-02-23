# Spec: /release command with git tagging and CHANGELOG versioning

> **Spec ID**: 021 | **Created**: 2026-02-23 | **Status**: in-progress

## Goal
Add a `/release` command that bumps the version, formats CHANGELOG under version headings, updates README, commits, and creates a git tag — plus backfill tags for all historical versions.

## Context
The project is at v1.1.4 with zero git tags and an inconsistent CHANGELOG (duplicate dates, missing version numbers). Version bumps happen ad-hoc inside specs. A dedicated `/release` command standardizes this: entries accumulate under `[Unreleased]`, then `/release` moves them into a versioned block, bumps package.json, commits, and tags. The template is auto-discovered via the dynamic template map (spec 013).

## Steps
- [x] Step 1: Create `templates/commands/release.md` — Sonnet command that reads git log + CHANGELOG, asks version type (patch/minor/major), bumps `package.json`, moves `[Unreleased]` entries under `## [vX.Y.Z] — YYYY-MM-DD`, checks README command table count against actual templates, commits as `release: vX.Y.Z`, creates git tag `vX.Y.Z`
- [x] Step 2: Reformat `CHANGELOG.md` — add `## [Unreleased]` section at top, retroactively group existing entries under version headings (`[v1.1.4]`, `[v1.1.3]`, etc.) based on commit messages and dates
- [x] Step 3: Update `templates/commands/spec-work.md` — change CHANGELOG instructions to prepend entries under the `## [Unreleased]` heading instead of date headings
- [x] Step 4: Update `README.md` — add `/release` to the Slash Commands table (13 commands), add version badge or indicator at top
- [x] Step 5: Backfill git tags — create tags `v1.1.0`, `v1.1.1`, `v1.1.2`, `v1.1.3`, `v1.1.4` on the correct historical commits
- [x] Step 6: Bump version to `1.1.5` in `package.json`, add CHANGELOG entry for this spec

## Acceptance Criteria
- [x] `/release` command template exists and follows project command patterns (Sonnet, allowed-tools)
- [x] CHANGELOG uses `## [vX.Y.Z] — date` headings with `## [Unreleased]` at top
- [x] All historical versions (v1.1.0–v1.1.4) have git tags on correct commits
- [x] README command table reflects 13 commands including `/release`
- [x] `/spec-work` template targets `[Unreleased]` section for new entries

## Files to Modify
- `templates/commands/release.md` — new file (release command template)
- `CHANGELOG.md` — reformat with version headings + [Unreleased]
- `templates/commands/spec-work.md` — update CHANGELOG instructions
- `README.md` — add /release to command table, update count
- `package.json` — version bump to 1.1.5

## Out of Scope
- npm publish automation
- GitHub Releases (API integration)
- Automatic version detection from conventional commits (user picks)
