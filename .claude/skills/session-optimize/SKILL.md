---
name: session-optimize
description: Analyzes past sessions via claude-mem to surface quality, efficiency, and token-saving improvements for this project's Claude Code setup. Produces a prioritized optimization report. Triggers: /session-optimize, 'analyze sessions', 'optimize setup from sessions'.
model: sonnet
allowed-tools: Read, Glob, Grep, mcp__plugin_claude-mem_mcp-search__search, mcp__plugin_claude-mem_mcp-search__get_observations, mcp__plugin_claude-mem_mcp-search__timeline
---

Analyzes the last 30 days of claude-mem sessions for this project and outputs a prioritized list of setup improvements focused on **Qualität, Effizienz und Tokenersparnis**.

## Process

### 1. Gather session data (parallel — use model: haiku conceptually, minimize calls)

Run these 4 searches in parallel via `mcp__plugin_claude-mem_mcp-search__search`:

- Query: `"skill broken incomplete failed blocked"` — finds skill/workflow failures
- Query: `"token expensive slow model routing"` — finds token-waste patterns
- Query: `"repeated asked same question twice"` — finds recurring friction
- Query: `"workaround manual fallback missing"` — finds capability gaps

All with `project: npx-ai-setup`, `limit: 10`, `dateStart: 30 days ago`.

### 2. Fetch key observations

From the results, identify the 5–8 most signal-rich observations (type: bugfix, decision, refactor preferred). Fetch with `mcp__plugin_claude-mem_mcp-search__get_observations`.

### 3. Analyze patterns

For each finding, classify into one of three categories:

- **Q** (Qualität) — skill produces wrong output, spec workflow breaks, status inconsistencies
- **E** (Effizienz) — repeated manual steps, workflow friction, missing automations
- **T** (Tokenersparnis) — Explore agents without haiku, large file reads, redundant searches

### 4. Read current state of implicated files

For each finding that references a specific skill or config file, read the current file to verify the issue still exists. Skip if the fix is already in place.

### 5. Output report

```
# Session Optimize Report — <date>

## Summary
<1-2 sentences on dominant pattern found>

## Findings

### [Priority] [Q/E/T] <Title>
**Sessions:** #ID1, #ID2
**Impact:** <what breaks or costs tokens>
**Fix:** <concrete 1-line change>
**File:** <path>
---
```

Priority: 🔴 High (recurring + high impact) / 🟡 Medium / ⚪ Low

Sort by priority descending. Max 8 findings — cut noise below ⚪.

## Rules

- Never make changes — report only.
- If a finding references a file, verify the issue still exists before including it.
- If claude-mem returns no results, report: "No signal in last 30 days — setup looks clean."
- Skip findings that duplicate what's already in `.agents/memory/MEMORY.md` feedback entries.
- Haiku for all MCP searches; Sonnet only for pattern synthesis.

## Next Step

Review findings and pick top items to address. For each fix: open a spec (`/spec-create`) or apply directly if it's a single-line change.
