# Spec: Rules-Dateien Token-Reduktion

> **Spec ID**: 624 | **Created**: 2026-04-06 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal
Reduce always-on token cost of rule files by ~890 tokens per message by trimming generic content and removing duplication.

## Context
Rule files inject ~3,658 tokens into every message (always-on cost). Analysis shows ~24% is either generic CS knowledge Claude already has or content duplicated from global CLAUDE.md. This spec targets only always-on rule file costs — not event-based hook costs, which were analyzed and found already well-optimized (debounce, conditional output).

### Non-Goals (explicitly excluded)
- **Hook optimization**: session-length.sh, context-monitor.sh, tdd-checker.sh all have effective debounce/conditional output already. Follow-up only with own measurement.
- **git.md + code-review-reception.md merge**: Plausible but adds scope and review risk for minimal token gain. Separate spec if needed.
- **tool-redirect.sh registration**: Useful but not "token reduction" — separate change.

### Verified Assumptions
- quality.md lines 1-36 are generic standards Claude follows by default — Evidence: standard LLM training data | Confidence: High | If Wrong: minor quality regression, easily re-added
- agents.md model routing table duplicates global CLAUDE.md — Evidence: identical table in `~/.claude/CLAUDE.md` Model Routing section | Confidence: High | If Wrong: none, global CLAUDE.md is always loaded in Claude Code runtime
- testing.md Assertions/Isolation/Naming/Anti-Patterns sections restate testing basics — Evidence: file read | Confidence: Medium | If Wrong: test quality dips, detectable via CI

### Preserve List (hard-won lessons — do NOT remove)
- **quality.md**: Fix Strategy, Revert-First, Investigation Budget, Diagnose-Fix gate, Constraint Classification
- **testing.md**: TDD Cycle, Zero Tolerance, Mock Audit, targeted Mocking rules
- **agents.md**: Spawn thresholds, Re-check/Escalation rules, "model: always set" rule, Agent Selection rules

## Steps
- [ ] Step 1: Measure baseline — `wc -c` on each rule file, record per-file and total
- [ ] Step 2: Trim `quality.md` — remove Correctness, Reliability, Security, Performance, Maintainability, Code Quality (lines 1-36). Keep Fix Strategy + Debugging (lines 38-60) unchanged.
- [ ] Step 3: Trim `agents.md` — remove Model Routing table (lines 7-11), keep prose rule "Always set model:" on lines 5-6. Add one line: "Routing details: see global CLAUDE.md Model Routing section." Verify global CLAUDE.md actually contains the table.
- [ ] Step 4: Trim `testing.md` — remove Assertions (lines 43-45), Isolation (lines 47-54), Test Naming (lines 56-58), Anti-Patterns (lines 60-66). Keep TDD Cycle, Zero Tolerance, Mock Audit, Mocking intact.
- [ ] Step 5: Measure after — `wc -c` on each modified file, compare per-file and total delta

## Acceptance Criteria
- [ ] "Total rule file size decreased by ≥3,200 chars (~800 tokens), measured via `wc -c`"
- [ ] "Every removed passage is either generic CS knowledge or duplicated from global CLAUDE.md — manual review confirms no project-specific instruction was deleted"
- [ ] "All items on the Preserve List are still present in their respective files"
- [ ] "Diff is semantically reviewable — each removal has a clear rationale (generic or duplicate)"

## Files to Modify
- `.claude/rules/quality.md` — remove generic sections (lines 1-36)
- `.claude/rules/agents.md` — remove duplicate routing table (lines 7-11)
- `.claude/rules/testing.md` — remove basic testing knowledge (4 sections)

## Out of Scope
- Hook script modifications (already optimized)
- CLAUDE.md changes (already trimmed)
- git.md / code-review-reception.md consolidation (separate spec)
- tool-redirect.sh registration (separate change)
- MCP server cleanup (separate concern)
