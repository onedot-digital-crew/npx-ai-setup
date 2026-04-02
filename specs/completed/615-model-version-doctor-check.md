# Spec: Model Version Doctor Check

> **Spec ID**: 615 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: low | **Branch**: —
> **Execution Order**: independent (no dependencies, can run anytime)

## Goal
Extend the local `doctor.sh` health check so this repo warns when its configured Claude model identifier appears stale or unexpectedly pinned.

## Context
This repo currently has a local doctor script at `.claude/scripts/doctor.sh`, and its source-of-truth copy lives in `templates/scripts/doctor.sh`, but there is no template-distributed Claude doctor script under `templates/claude/scripts/`. That means the runtime health check stays repo-local even though the parity script also needs to stay in sync. The useful outcome here is operational awareness for maintainers when pinned model IDs drift, not a generalized shipped setup feature.

### Verified Assumptions
- A local doctor script exists at `.claude/scripts/doctor.sh`. — Evidence: `.claude/scripts/doctor.sh` | Confidence: High | If Wrong: this spec has no implementation target
- There is currently no `templates/claude/scripts/doctor.sh` to update in parallel, but `templates/scripts/doctor.sh` remains the parity source-of-truth for the repo-local script. — Evidence: `templates/claude/scripts/doctor.sh` absent, `templates/scripts/doctor.sh` present | Confidence: High | If Wrong: the scope would change again
- The value of the check is repo-maintainer awareness, since the current distribution path is still local-only. — Evidence: existing script locations | Confidence: High | If Wrong: this should be folded into a template-distributed health command later

## Steps
- [x] Step 1: Add a model-version check block to `.claude/scripts/doctor.sh` that reads the configured `model` from `.claude/settings.json`, compares it against a maintained `KNOWN_CURRENT_MODELS` list, and emits a warning when the configured ID is not recognized as current.
- [x] Step 2: Make the check graceful when `.claude/settings.json` is missing, invalid, or omits the `model` field.
- [x] Step 3: Update the script header or inline comments to state clearly that the check is repo-local until a template-distributed doctor script exists.

## Acceptance Criteria

### Truths
- [x] `.claude/scripts/doctor.sh` warns when the configured model ID is older or otherwise not present in the maintained current-model list.
- [x] The script does not fail if `settings.json` is missing or does not specify `model`.
- [x] The scope is explicitly documented as repo-local.

### Artifacts
- [x] `.claude/scripts/doctor.sh` — local doctor script with model-version awareness (min 120 lines)

### Key Links
- [x] `.claude/scripts/doctor.sh` → `.claude/settings.json` via model health check

## Files to Modify
- `.claude/scripts/doctor.sh` - add repo-local model-version health check
- `templates/scripts/doctor.sh` - keep script source-of-truth parity intact

## Out of Scope
- Automatically updating model IDs
- Calling external APIs to discover current models
- Creating a new template-distributed doctor script
