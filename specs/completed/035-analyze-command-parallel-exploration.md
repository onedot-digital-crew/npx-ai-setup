# Spec: /analyze Command with Parallel Codebase Exploration

> **Spec ID**: 035 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/035-analyze-command-parallel-exploration

## Goal
Add an /analyze command that uses 3 parallel Explore agents to produce a structured codebase overview in minutes instead of hours.

## Context
Projects have no fast way to get a full codebase overview. feature-dev shows the pattern: launch parallel specialized agents (architecture, hotspots, risks) simultaneously and synthesize results. Our /analyze command delivers this as a reusable, generic command installed in every project. Replaces the manual "explain this codebase" session-start pattern.

## Steps
- [x] Step 1: Create `templates/commands/analyze.md` with model: sonnet, allowed-tools including Task
- [x] Step 2: Agent 1 focus: Architecture — entry points, data flow, module boundaries, key abstractions (reads `.agents/context/ARCHITECTURE.md` first if exists, then explores)
- [x] Step 3: Agent 2 focus: Hotspots — most-changed files (`git log --format="%f" | sort | uniq -c | sort -rn | head -20`), largest files, complex areas
- [x] Step 4: Agent 3 focus: Risks — TODOs/FIXMEs/HACKs, dead code patterns, missing error handling, inconsistent naming
- [x] Step 5: Orchestrator synthesizes all 3 results into a structured report: `## Architecture`, `## Hotspots`, `## Risks`, `## Recommendations`
- [x] Step 6: Verify that `analyze.md` is auto-discovered and installed during setup (templates/commands/ is auto-scanned — no code change in ai-setup.sh needed)
- [x] Step 7: Run smoke tests (`./tests/smoke.sh`) to verify the new template deploys correctly

## Acceptance Criteria
- [x] `/analyze` spawns 3 agents simultaneously (visible in output as parallel launches)
- [x] Report has 4 structured sections: Architecture, Hotspots, Risks, Recommendations
- [x] Command is installed to `.claude/commands/analyze.md` during `npx @onedot/ai-setup`
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/analyze.md` — create new command (only file needed; ai-setup.sh auto-discovers templates/commands/)

## Out of Scope
- Project-specific agent customization (generic command only)
- Persistent storage of analysis results (report is output only)
- Integration with spec creation (separate concern)
