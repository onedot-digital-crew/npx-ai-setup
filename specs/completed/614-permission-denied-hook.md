# Spec: PermissionDenied Hook

> **Spec ID**: 614 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: low | **Branch**: —
> **Execution Order**: after 613

## Goal
Implement a `PermissionDenied` hook that logs blocked permission requests with enough context to explain what happened, without guessing the wrong remediation path.

## Context
If the target Claude environment supports `PermissionDenied`, it is a good runtime complement to Spec 610: governance defines the rules, while this hook explains denials when they happen. The important constraint is accuracy. A denial can come from multiple sources, so the hook should only print source-specific remediation guidance when the event payload provides that source explicitly.

### Verified Assumptions
- `PermissionDenied` exists as a hook event type in decompiled Claude Code v2.1.88. Whether it fires in the public release is unverified. — Evidence: Spec 611 Research, `hooksConfigManager.ts` | Confidence: Medium | If Wrong: Hook gets registered but never fires — no damage, no benefit.
- The repo currently logs generic tool failures but has no dedicated permission-denial log path. — Evidence: `templates/claude/hooks/post-tool-failure-log.sh`, current hook set | Confidence: High | If Wrong: this spec is lower value
- A permission denial may come from allow/deny rules, global settings, or other settings layers, so a static “add to permissions.allow” hint would be misleading. — Evidence: `templates/claude/settings.json`, `lib/global-settings.sh` | Confidence: High | If Wrong: the event payload would need to guarantee a narrower source
- The hook should remain advisory and log-oriented rather than mutating permissions automatically. — Evidence: current governance direction | Confidence: High | If Wrong: automation belongs in a different spec

## Steps
- [x] Step 1: Create `templates/claude/hooks/permission-denied-log.sh` that reads whatever context fields the event provides, appends a structured line to `.claude/permission-denied.log`, and degrades safely when fields are missing.
- [x] Step 2: Make the hook emit a user-visible stderr hint only when the event includes enough information to describe the denial source accurately; otherwise print a generic explanation without a prescriptive fix.
- [x] Step 3: Register the hook in `templates/claude/settings.json` and mirror it to the local `.claude/` copies for repo verification.
- [x] Step 4: Document the hook in `templates/claude/hooks/README.md`, including the rule that source-specific remediation is conditional on event payload quality.

## Implementation Note

`PermissionDenied` event availability remains unverified in this terminal environment. The hook is implemented as an experimental logger and does not change any permission behavior.

## Acceptance Criteria

### Truths
- [x] Each permission denial appends a structured entry to `.claude/permission-denied.log`.
- [x] Missing or partial event fields do not crash the hook.
- [x] Source-specific remediation is shown only when the payload supports it; otherwise the hint stays generic.
- [x] The hook does not mutate permissions or change denial behavior.

### Artifacts
- [x] `templates/claude/hooks/permission-denied-log.sh` — denial logging hook (min 30 lines)
- [x] `templates/claude/settings.json` — `PermissionDenied` registration (includes PermissionDenied registration)
- [x] `templates/claude/hooks/README.md` — documents denial logging behavior

### Key Links
- [x] `templates/claude/settings.json` → `templates/claude/hooks/permission-denied-log.sh` via `PermissionDenied`
- [x] `templates/claude/hooks/permission-denied-log.sh` → `.claude/permission-denied.log` via structured logging

## Files to Modify
- `templates/claude/hooks/permission-denied-log.sh` - add structured denial logging
- `templates/claude/settings.json` - register the hook
- `.claude/hooks/permission-denied-log.sh` - local parity copy
- `.claude/settings.json` - local parity registration
- `templates/claude/hooks/README.md` - document hook behavior and limitations

## Out of Scope
- Automatically adjusting permissions
- Blocking, overriding, or retrying denied actions
- Solving the broader governance model defined in Spec 610
