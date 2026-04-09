---
name: analyze
description: Produces a structured codebase overview via parallel agents. Use when exploring or preparing for major changes.
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

### 0. Count source files

```bash
git ls-files 2>/dev/null | grep -E '\.(ts|tsx|js|jsx|py|go|rs|rb|php|java|kt|swift|vue|svelte|sh|sql)$' | grep -v -E '(\.lock|\.min\.|dist/|build/|node_modules/|vendor/|\.next/|\.nuxt/)' | wc -l
```

- **Fast mode** (≤30 files): Step 2A — 3 parallel agents
- **Batch mode** (>30 files): Step 2B — batched haiku agents + synthesizer

### 2A. Fast mode

Agent prompts: `@references/agents-fast-mode.md` — spawn all 3 simultaneously.

### 2B. Batch mode

Agent prompts: `@references/agents-batch-mode.md`
- Split into batches of 8 files; process in waves of 3 concurrent haiku agents
- After all batches: one Synthesizer agent (model: sonnet)

### 3. Report

```
## Architecture
## Hotspots
## Risks
## Recommendations (3-5 actionable)
```

### 4. Persist artifacts

Check existing files:
```bash
ls .agents/context/PATTERNS.md .agents/context/AUDIT.md 2>/dev/null
```
If exist: ask user to confirm regeneration. If no → stop.

Write `PATTERNS.md` (Architecture section) and `AUDIT.md` (Hotspots + Risks + Recommendations).

Build dependency graph:
```bash
bash .claude/scripts/build-graph.sh 2>&1 | tail -5
```
If successful, append graph stats to `.agents/context/ARCHITECTURE.md`:
```bash
python3 -c "
import json; g=json.load(open('.agents/context/graph.json')); s=g.get('stats',{})
hubs=s.get('top_hubs',[]); isolated=[n['id'] for n in g.get('nodes',[]) if not any(e['source']==n['id'] or e['target']==n['id'] for e in g.get('edges',[]))]
print('## Dependency Graph'); print(f\"{s.get('files',0)} files, {s.get('edges',0)} edges, {s.get('circular_count',0)} circular\")
if hubs: print('Hubs: '+', '.join(f\"{h['file']} ({h['imported_by']}x)\" for h in hubs[:3]))
" >> .agents/context/ARCHITECTURE.md 2>/dev/null || true
```

Optional — Storyblok schema:
```bash
[ -f scripts/storyblok.sh ] && bash scripts/storyblok.sh pull 2>/dev/null && \
  cp .storyblok/components.json .agents/context/storyblok-schema.json 2>/dev/null || true
```

Commit:
```bash
git add .agents/context/PATTERNS.md .agents/context/AUDIT.md .agents/context/graph.json .agents/context/graph-manifest.json
[ -f .agents/context/storyblok-schema.json ] && git add .agents/context/storyblok-schema.json
git commit -m "chore: update project analysis artifacts"
```

## Rules

- Agents run in parallel — no sequential waiting
- Write PATTERNS.md + AUDIT.md — primary deliverable
- Batch agent failure: continue with remaining batches, note gap

## Next Step

`/spec "task"` for identified improvements, or `/context-refresh` if context files are stale.
