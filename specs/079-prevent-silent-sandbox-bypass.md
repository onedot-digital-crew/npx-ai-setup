# Spec 079 — Prevent Silent Sandbox Bypass

**Status:** in-review
**Issue:** https://github.com/onedot-digital-crew/npx-ai-setup/issues/4

## Goal

Prevent Claude from silently retrying commands with `dangerouslyDisableSandbox: true` without explicit user confirmation. Enforce this via a rule in the general rules template.

## Context

Claude bypassed sandbox restrictions by autonomously retrying failing commands with `dangerouslyDisableSandbox: true`. This is a behavioral violation — the sandbox exists to protect the user's system. No hook can intercept this parameter (it is a tool argument, not a shell command), so the fix is a hard rule in the project rules files.

The rule must state: never set `dangerouslyDisableSandbox: true` without first explaining why the sandbox blocks the command and receiving explicit user confirmation.

## Steps

1. **Edit** `templates/claude/rules/general.md`: add a new `## Sandbox Safety` section with the rule against silent bypass.

2. **Edit** `.claude/rules/general.md`: apply the identical section.

## Acceptance Criteria

- `templates/claude/rules/general.md` contains a `## Sandbox Safety` section
- The rule explicitly prohibits using `dangerouslyDisableSandbox: true` without user confirmation
- `.claude/rules/general.md` contains the identical section
- No other content in either file is changed

## Files to Modify

- `templates/claude/rules/general.md`
- `.claude/rules/general.md`

## Out of Scope

- PreToolUse hook blocking `dangerouslyDisableSandbox` (hook payloads do not expose tool parameters reliably)
- Changes to `settings.json` sandbox config
- Retroactive enforcement in existing installed projects
