# Spec: Claude Permissions And Governance Hardening

> **Spec ID**: 610 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: high | **Branch**: —
> **Execution Order**: after 609

## Goal
Replace implicit, partially documented Claude operating modes with explicit governance defaults for permissions, scope, migrations, and global-vs-project ownership.

## Context
The audit shows a structural mismatch: project-local settings are carefully curated, but global settings and migration helpers still use broader or less consistent rules. This spec hardens that layer by making permission scope, ownership boundaries, and migration behavior more explicit in the current repo, without trying to mirror internal-Claude permission internals that do not exist here.

### Verified Assumptions
- Global Claude settings currently merge broad permissions into `~/.claude/settings.json`. — Evidence: `lib/global-settings.sh` | Confidence: High | If Wrong: the governance risk is smaller than observed
- Project docs already describe multiple permission modes and safer operating patterns, but setup does not ship clear profiles or ownership guidance that map to those docs. — Evidence: `templates/CLAUDE.md`, `templates/claude/settings.json` | Confidence: High | If Wrong: preset work would be redundant
- Migration helpers are less robust than fresh install helpers because settings mutations in `lib/migrate.sh` require `jq` instead of following the setup fallback strategy. — Evidence: `lib/migrate.sh`, `lib/setup.sh` | Confidence: High | If Wrong: migration parity only needs documentation
- The repo already relies on `permissions.allow` / `permissions.deny` and project-local hooks, so governance should clarify those existing layers rather than introducing a parallel enforcement system. — Evidence: `templates/claude/settings.json`, `templates/claude/hooks/protect-files.sh` | Confidence: High | If Wrong: governance would need a broader architecture change

## Steps
- [x] Step 1: Design and document explicit permission profiles in `docs/claude-governance.md`, covering at minimum project-local baseline behavior, stricter team-safe operation, and power-user/automation mode, plus ownership rules for global versus project settings.
- [x] Step 2: Refactor `templates/claude/settings.json` so the shipped baseline is clearly documented and maps cleanly to the governance document without requiring readers to infer behavior from raw arrays.
- [x] Step 3: Refactor `lib/global-settings.sh` to use gated or explicitly optional behavior for broad workstation-wide grants instead of silently treating them as baseline policy.
- [x] Step 4: Update `lib/migrate.sh` to support resilient settings mutations that preserve and evolve the governance model during version upgrades with the same robustness standard as setup-time edits.
- [x] Step 5: Update `templates/CLAUDE.md` and `templates/WORKFLOW-GUIDE.md` so permission modes, `dontAsk`, `auto`, and `bypassPermissions` are clearly presented as operator choices rather than assumed defaults.

## Acceptance Criteria

### Truths
- [x] Governance docs define clear ownership boundaries and concrete permission profiles for this repo.
- [x] Project-local settings map cleanly to a documented baseline profile.
- [x] Global settings are gated and do not silently grant broad scopes by default.
- [x] Migration-time settings edits are brought up to the same robustness standard as fresh installs.

### Artifacts
- [x] `docs/claude-governance.md` — source of truth for permission profiles and ownership boundaries (min 80 lines)
- [x] `templates/claude/settings.json` — baseline profile reflected in shipped defaults (includes baseline profile documentation and hook registrations)
- [x] `lib/global-settings.sh` — gated global permission grants (min 150 lines)
- [x] `lib/migrate.sh` — resilient governance-aware mutation path (min 200 lines)

### Key Links
- [x] `docs/claude-governance.md` → `templates/claude/settings.json` via baseline profile definition
- [x] `docs/claude-governance.md` → `lib/global-settings.sh` via global-vs-project ownership rules
- [x] `lib/setup.sh` → `lib/migrate.sh` via shared settings mutation strategy

## Files to Modify
- `docs/claude-governance.md` - define governance model and permission profiles
- `templates/claude/settings.json` - express the baseline profile clearly
- `.claude/settings.json` - sync local verification copy if this repo remains a generated target
- `lib/global-settings.sh` - reduce or gate broad global permission grants
- `lib/migrate.sh` - add resilient settings mutation fallback or shared helper usage
- `lib/setup.sh` - route settings installation through the clarified governance model where needed
- `templates/CLAUDE.md` - align operator guidance with shipped profiles
- `templates/WORKFLOW-GUIDE.md` - reflect profile-based governance in workflow docs

## Out of Scope
- Replacing the current hook system with managed remote settings
- Rewriting spec/worktree orchestration logic
- Full plugin-first migration of all Claude runtime assets
