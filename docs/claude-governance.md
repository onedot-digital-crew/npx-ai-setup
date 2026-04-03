# Claude Governance

This document is the source of truth for Claude permission governance in this repo.
It defines which settings belong to the project, which belong to the workstation,
and which operator choices are optional rather than baseline policy.

## Ownership Boundaries

Project-local settings live in `.claude/settings.json`.
They define the baseline profile that is safe to commit with the repo:

- Repo-scoped hooks
- Repo-scoped allow and deny patterns
- Context-budget defaults
- Project plugin and MCP references

Global settings live in `~/.claude/settings.json`.
They must stay narrowly scoped because they affect every repository on the workstation.
Global settings should own only:

- Optional workstation UX defaults such as `statusLine`
- Optional broad shell grants that the operator explicitly opts into
- User-specific preferences that are not safe to commit into a project repo

Migration code must preserve these boundaries.
Fresh installs and upgrades should evolve project-local settings automatically,
but they must not silently widen workstation-wide permissions.

## Profiles

### 1. Project Baseline

This is the shipped default for this setup.
It is encoded in `templates/claude/settings.json`.

- Sandboxed by default
- Narrow `permissions.allow` entries for common repo tasks
- Explicit `permissions.deny` entries for destructive commands and wasteful reads
- Repo-local hooks for advisory warnings, edit-time gates, and workflow hygiene
- No assumption that `dontAsk`, `auto`, or `bypassPermissions` are active

This profile is the minimum policy the team can rely on.

### 2. Team-Safe

This is an operator choice built on top of the baseline profile.

- Keep the baseline project settings unchanged
- Prefer `default` or `plan` permission modes
- Avoid workstation-wide shell grants unless they are truly needed
- Keep project hooks enabled and do not bypass `permissions.deny`

### 3. Power User / Automation

This is explicitly opt-in.
It is not the baseline and should not be inferred from docs alone.

- May enable broader global shell permissions
- May use `acceptEdits`, `dontAsk`, or automation-specific execution modes
- May relax interactive friction for trusted local workflows

## Policy Layers

The repo relies on two different enforcement layers:

- `permissions.deny` in settings is the hard enforcement layer for reads and destructive commands
- Hooks are local runtime guardrails for edit flows, warnings, and operator feedback

That distinction must stay explicit in docs and scripts.

## Baseline Mapping

Project settings carry governance metadata fields that point back to this document
and identify the active baseline profile.

The baseline profile currently means:

- Project-owned settings are committed in the repo
- Framework-specific setup may narrow deny patterns where needed
- Migration helpers may update the same project-owned settings during upgrades
- Global settings must remain opt-in for broad shell grants

## Migration Rules

Migration-time JSON mutations must be as robust as setup-time edits.
That means:

- Prefer `jq` when available
- Fall back to `node` when `jq` is missing
- Preserve valid JSON formatting
- Avoid silent no-ops when the target file exists and is parseable

## Operator Guidance

Permission modes are operator choices, not hidden repo defaults.

- `default` and `plan` are the safe default recommendation
- `acceptEdits` is useful when the operator wants faster trusted edits
- `dontAsk` should be presented as a deliberate local choice, not a team baseline
- `auto` and `bypassPermissions` are advanced modes and must be documented that way

## Review Checklist

- `docs/claude-governance.md` still matches the shipped project settings
- `templates/claude/settings.json` still identifies the baseline profile
- `lib/global-settings.sh` does not silently broaden workstation-wide grants
- `lib/migrate.sh` still supports `jq` and `node` fallback mutation paths
- `templates/CLAUDE.md` and `templates/WORKFLOW-GUIDE.md` still describe modes as operator choices
