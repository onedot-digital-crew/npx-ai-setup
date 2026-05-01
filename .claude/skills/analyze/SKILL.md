---
name: analyze
description: "Produces a structured codebase overview via parallel agents. Trigger: 'analyze codebase', 'audit risks', 'find hotspots'."
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

> Indexing/graph building lives in `/index`. `/analyze` consumes existing artifacts and produces narrative findings (Architecture, Hotspots, Risks). Run `/index` first if `.agents/context/index-manifest.json` is missing or stale.

## Process

### 0a. Context scan

If `.agents/context/STACK.md` exists and is newer than 24 hours, read it directly and skip the scanner:

```bash
find .agents/context/STACK.md -mtime -1 -print 2>/dev/null
```

Otherwise spawn `context-scanner` (model: haiku) before mode selection. Pass its `stack`, `conventions`, and `key_paths` output to every analysis agent as `Stack hint`.

### 0b. Load existing context (alignment check)

Read `.agents/context/CONCEPT.md` if present — analysis must respect documented project boundaries.
Read `.agents/context/SUMMARY.md` if present — avoid duplicating fields that already exist.

### 0c. Load graph artifacts

Probe `graphify-out/graph.json` and `.agents/context/STACK.md` once before mode selection:

```bash
test -f graphify-out/graph.json && jq '.communities | length' graphify-out/graph.json 2>/dev/null
test -f .agents/context/STACK.md && sed -n '1,80p' .agents/context/STACK.md
```

If `graphify-out/graph.json` exists and has 2 or more communities, use community mode instead of fast or batch mode.

### 0d. repomix Fast-Path (opt-in, non-community path only)

Check if repomix is available:

```bash
which repomix 2>/dev/null && echo "AVAILABLE" || echo "FALLBACK"
```

**If AVAILABLE** and community mode is not selected: run `bash .claude/scripts/analyze-fast.sh` — returns compressed structural snapshot as XML. Skip to step 2 using this snapshot as input instead of spawning agents. This replaces the agent read-loop, not supplements it.

**If FALLBACK** (or if `analyze-fast.sh` returns empty): continue with step 0e.

### 0e. Count source files (fallback path only)

```bash
git ls-files 2>/dev/null | grep -E '\.(ts|tsx|js|jsx|py|go|rs|rb|php|java|kt|swift|vue|svelte|sh|sql)$' | grep -v -E '(\.lock|\.min\.|dist/|build/|node_modules/|vendor/|\.next/|\.nuxt/)' | wc -l
```

- **Community mode** (`graphify-out/graph.json` with ≥2 communities): use community batches from `@references/agents-community-mode.md`
- **Fast mode** (≤30 files): use 3 parallel agents
- **Batch mode** (>30 files): use batched haiku agents plus one synthesizer
- **Effort** (`${CLAUDE_EFFORT}`): if `xhigh` or `max`, use sonnet (not haiku) for all batch agents and run a synthesizer opus pass at the end.

### 1. Run the analysis (fallback path only)

**Fast mode**:

- Use `@references/agents-fast-mode.md`
- Spawn all 3 agents simultaneously

**Batch mode**:

- Use `@references/agents-batch-mode.md`
- Split into batches of 8 files
- Process in waves of 3 concurrent haiku agents
- Finish with one sonnet synthesizer

**Community mode**:

- Use `@references/agents-community-mode.md`
- Extract files per community from `graphify-out/graph.json`
- Process one community per batch, preserving graph community boundaries
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

**repomix path**: derive Architecture from XML `<directory_structure>`, Hotspots from file sizes and signature density, Risks from patterns in compressed signatures.

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
