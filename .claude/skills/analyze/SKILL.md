---
name: analyze
description: "Produces a structured codebase overview via parallel agents. Trigger: 'analyze codebase', 'rebuild graph', 'context refresh'."
user-invocable: true
effort: high
model: sonnet
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Agent
---

Produces a structured codebase overview via parallel agents. Use when exploring or preparing for major changes.

## Process

### 0a. Load existing context (alignment check)
Read `.agents/context/CONCEPT.md` if present — analysis must respect documented project boundaries.
Read `.agents/context/SUMMARY.md` if present — avoid duplicating fields that already exist.

### 0b. Count source files

```bash
git ls-files 2>/dev/null | grep -E '\.(ts|tsx|js|jsx|py|go|rs|rb|php|java|kt|swift|vue|svelte|sh|sql)$' | grep -v -E '(\.lock|\.min\.|dist/|build/|node_modules/|vendor/|\.next/|\.nuxt/)' | wc -l
```

- **Fast mode** (≤30 files): use 3 parallel agents
- **Batch mode** (>30 files): use batched haiku agents plus one synthesizer

### 1. Run the analysis

**Fast mode**:
- Use `@references/agents-fast-mode.md`
- Spawn all 3 agents simultaneously

**Batch mode**:
- Use `@references/agents-batch-mode.md`
- Split into batches of 8 files
- Process in waves of 3 concurrent haiku agents
- Finish with one sonnet synthesizer

### 2. Output report

Return:

```markdown
## Architecture
## Hotspots
## Risks
## Recommendations
## Suggested Questions
```

Include only follow-up questions that match actual findings.

### 3. Persist artifacts

Check:

```bash
ls .agents/context/PATTERNS.md .agents/context/AUDIT.md 2>/dev/null
```

If files already exist, ask before regenerating. If the user declines, stop after the report.

Write:
- `PATTERNS.md` from Architecture
- `AUDIT.md` from Hotspots, Risks, Recommendations

Build dependency graph:

```bash
bash .claude/scripts/build-graph.sh 2>&1 | tail -5
```

If graph generation succeeds, append graph stats to `.agents/context/ARCHITECTURE.md`.

Optional Storyblok export:

```bash
[ -f scripts/storyblok.sh ] && bash scripts/storyblok.sh pull 2>/dev/null && \
  cp .storyblok/components.json .agents/context/storyblok-schema.json 2>/dev/null || true
```

Commit artifacts:

```bash
git add .agents/context/PATTERNS.md .agents/context/AUDIT.md .agents/context/graph.json .agents/context/graph-manifest.json
[ -f .agents/context/storyblok-schema.json ] && git add .agents/context/storyblok-schema.json
git commit -m "chore: update project analysis artifacts"
```

## Rules
- Run analysis agents in parallel.
- `PATTERNS.md` and `AUDIT.md` are the primary deliverables.
- If a batch fails, continue and note the gap.

## Next Step

Run `/spec "task"` for follow-up work or `/context-refresh` if context is stale.
