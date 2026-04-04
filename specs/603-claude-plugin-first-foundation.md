# Spec: Claude Plugin-First Foundation

> **Spec ID**: 603 | **Created**: 2026-03-31 | **Status**: draft | **Complexity**: high | **Branch**: —

## Goal
Define and scaffold a Claude-only plugin-first architecture that replaces most runtime `.claude/*` template drift with a bundled plugin, while keeping a thin repo init for bootstrap-only files.

## Context
`@onedot/ai-setup` currently mixes two responsibilities: repo bootstrap and Claude runtime behavior. The current setup copies many Claude-facing files into projects and updates them via template sync, while plugin enablement is handled imperatively in setup scripts. This spec creates the foundation for a controlled migration to `plugin-first, init-thin`, without attempting the full artifact migration in one step.

### Verified Assumptions
- Runtime Claude behavior is currently installed via repo-local templates and setup scripts. — Evidence: `bin/ai-setup.sh`, `lib/setup.sh`, `lib/plugins.sh` | Confidence: High | If Wrong: plugin scope would be smaller than expected
- Template drift is caused by copied `.claude/*` files being updated through checksum/merge logic. — Evidence: `lib/setup.sh`, `lib/update.sh` | Confidence: High | If Wrong: plugin-first would not materially reduce maintenance
- Marketplace/plugin enablement already exists as a supported project-level mechanism. — Evidence: `.claude/docs/claude-code-settings.md`, `lib/plugins.sh` | Confidence: High | If Wrong: distribution model must stay CLI-only
- Auto-updates can be disabled in Claude environments. — Evidence: `.claude/docs/claude-code-env-vars.md` (`DISABLE_AUTOUPDATER`, `FORCE_AUTOUPDATE_PLUGINS`) | Confidence: Medium | If Wrong: plugin freshness guarantees need less operator guidance

## Steps
- [ ] Step 1: Add a design doc at `docs/claude-plugin-first.md` that defines the target split between plugin-managed runtime assets and thin-init bootstrap assets, including explicit rules for what stays out of the plugin.
- [ ] Step 2: Inventory current Claude-facing artifacts from `.claude/`, `templates/claude/`, `templates/skills/`, `templates/agents/`, and `lib/plugins.sh` into a machine-readable mapping file at `config/plugin-migration-map.json`.
- [ ] Step 3: Scaffold a local Claude plugin directory with `plugin.json` and the minimal folder layout for bundled skills, agents, hooks, and optional MCP config, without migrating behavior yet.
- [ ] Step 4: Refactor setup code so `bin/ai-setup.sh` and `lib/plugins.sh` can register or enable the local plugin as one unit instead of imperatively installing multiple runtime pieces.
- [ ] Step 5: Define a thin-init contract in code and docs for the bootstrap-only responsibilities that remain repo-managed, including `AGENTS.md`, `.agents/context/*`, and stack/context generation.
- [ ] Step 6: Add an update strategy section covering pinned vs auto-updated plugin behavior, including the explicit caveat that `DISABLE_AUTOUPDATER=1` prevents assuming all users are on the latest plugin state.
- [ ] Step 7: Add a migration checklist for existing projects that detects legacy repo-local Claude assets and defines which ones become plugin-owned, preserved, or deprecated.

## Acceptance Criteria

### Truths
- [ ] Running the setup in a test project produces a single documented plugin registration path instead of multiple ad-hoc runtime install steps.
- [ ] The repo contains one authoritative mapping that says for each Claude-facing artifact whether it moves to the plugin, remains in thin-init, or is deprecated.

### Artifacts
- [ ] `docs/claude-plugin-first.md` — target architecture, boundaries, update model, migration phases (min 40 lines)
- [ ] `config/plugin-migration-map.json` — artifact-to-owner mapping used by follow-up specs (min 20 lines)
- [ ] `claude-plugin/plugin.json` — initial plugin manifest and structure placeholder (min 10 lines)

### Key Links
- [ ] `bin/ai-setup.sh` → `lib/plugins.sh` via plugin registration flow
- [ ] `config/plugin-migration-map.json` → `docs/claude-plugin-first.md` via shared ownership vocabulary

## Files to Modify
- `bin/ai-setup.sh` - route Claude runtime setup through the new plugin-first path
- `lib/plugins.sh` - replace imperative multi-plugin setup with plugin registration logic
- `lib/update.sh` - document or codify how plugin-first updates differ from template sync
- `docs/claude-plugin-first.md` - architecture and migration source of truth
- `config/plugin-migration-map.json` - migration inventory for follow-up specs
- `claude-plugin/plugin.json` - initial plugin manifest

## Out of Scope
- Migrating all existing skills, agents, hooks, and commands into the plugin in this spec
- Removing current template assets before the plugin path is verified
- Supporting non-Claude tools during this migration
