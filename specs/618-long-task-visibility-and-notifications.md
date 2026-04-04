# Spec: Long-Task Visibility And Notifications

> **Spec ID**: 618 | **Created**: 2026-04-01 | **Status**: parked | **Complexity**: low | **Branch**: —
> **Parked**: Zu vage — "selected long-running scripts" ohne konkrete Targets, `templates/scripts/` existiert nicht. Nachschärfen wenn konkreter Auslöser kommt.

## Goal
Improve operator visibility during long-running tasks using the hook types and notification paths the repo already has, without inventing a new heartbeat event system.

## Context
Research from the leaked Claude Code architecture highlights proactive visibility as a useful pattern for long autonomous runs, but this repo does not have an internal tick loop or custom mid-tool hook type. What it does already have is `notify.sh`, `TaskCompleted`, `PostToolUseFailure`, `context-monitor`, and multiple long-running scripted flows. This spec keeps the goal practical: make long tasks more visible using existing hooks, logs, and wrapper scripts instead of building a new scheduler.

### Verified Assumptions
- Current hooks only trigger on defined Claude lifecycle events, so there is no existing generic mid-tool tick hook in this repo. — Evidence: `templates/claude/settings.json` | Confidence: High | If Wrong: this spec could use an existing event rather than wrapper logic
- The repo already has notification and logging paths that can be reused for better long-task visibility. — Evidence: `templates/claude/hooks/notify.sh`, `templates/claude/hooks/post-tool-failure-log.sh`, `templates/claude/hooks/task-completed-gate.sh` | Confidence: High | If Wrong: the solution would need a larger plumbing change
- The useful gap is operator visibility, not autonomous process interruption. — Evidence: current hook surface and practical usage | Confidence: High | If Wrong: a different spec should handle process supervision explicitly

## Steps
- [ ] Step 1: Inventory current long-running flows and identify which ones already emit visible start/end/failure signals versus which ones go silent for too long.
- [ ] Step 2: Add lightweight visibility improvements to selected long-running scripts or flows, such as explicit start notifications, completion notifications, and structured progress log lines that do not require a new Claude hook type.
- [ ] Step 3: Reuse existing notification surfaces like `notify.sh`, `TaskCompleted`, or task-specific wrappers where possible instead of inventing a generic background heartbeat daemon.
- [ ] Step 4: Update hook and workflow docs to explain what operators can expect during long tasks and which signals indicate progress versus failure.
- [ ] Step 5: Ensure the added visibility remains advisory and non-disruptive, with no attempt to interrupt or kill running tasks automatically.

## Acceptance Criteria

### Truths
- [ ] Selected long-running flows emit clearer visible start/end/progress signals than they do today.
- [ ] The solution uses existing hook and notification surfaces rather than a new custom hook event.
- [ ] Operator awareness improves without introducing automatic interruption of running tasks.

### Artifacts
- [ ] selected long-running script(s) or hook(s) — improved visibility behavior
- [ ] `templates/claude/hooks/README.md` — documented long-task visibility model
- [ ] `templates/WORKFLOW-GUIDE.md` — operator-facing expectations for long tasks

### Key Links
- [ ] selected script or hook → `notify.sh` via visibility updates
- [ ] `templates/WORKFLOW-GUIDE.md` → selected script or hook via operator guidance

## Files to Modify
- selected long-running script(s) under `templates/scripts/` or `templates/claude/hooks/` - add visible progress or notifications
- `templates/claude/hooks/README.md` - document long-task visibility behavior
- `templates/WORKFLOW-GUIDE.md` - set operator expectations for long tasks

## Out of Scope
- Adding a new generic `Heartbeat` hook type
- Automatic interruption or killing of running tasks
- Reproducing internal KAIROS autonomy behavior
