---
name: index
description: "Stack-aware project indexing. Builds and refreshes context + graph artifacts and writes a freshness manifest. Trigger: 'index project', 'rebuild context', 'refresh graph'."
user-invocable: true
effort: medium
model: sonnet
allowed-tools:
  - Read
  - Bash
---

`/index [--refresh] [--graphify] [--no-graphify] [--dry-run]`

Single entry point for project knowledge. Detects stack, builds graph artifacts, writes a manifest used by reviewers and routing skills.

## When to use

- First clone of an existing project (no `.agents/context/index-manifest.json` yet)
- After large refactors or many new files (manifest sources stale)
- Before `/analyze`, `/spec`, or `/review --spec` on an unfamiliar codebase

## Process

### 1. Run prep

```bash
! bash .claude/scripts/index-prep.sh "$@"
```

Pass user flags through. Script handles stack detection, freshness checks, artifact builders.

### 2. Read manifest

```bash
test -f .agents/context/index-manifest.json && jq '{stack, generated_at, artifacts: (.artifacts | keys)}' .agents/context/index-manifest.json
```

### 3. Report

Return short summary:

```markdown
## Index

- Stack: <profile>
- Manifest: `.agents/context/index-manifest.json`
- Artifacts:
  - graph.json — <built_at | missing>
  - liquid-graph.json — <built_at | missing>
  - graphify-out/graph.json — <built_at | skipped>
- Sources tracked: <N>
```

If an artifact is missing because of stack (e.g. liquid-graph on a Nuxt project), say "skipped (stack)" instead of "missing".

## Flags

- `--refresh` — force rebuild even if artifacts present
- `--graphify` — also run `graphify build .` (requires binary on `$PATH`)
- `--no-graphify` — never run graphify even if installed
- `--dry-run` — print plan + manifest preview, write nothing

## Rules

- Idempotent. Re-running without `--refresh` is cheap (freshness check only).
- Never deletes existing artifacts. Builders may overwrite their own outputs.
- If a builder fails, log a warning and continue — partial manifest is better than none.
- Graphify is opt-in. Auto-runs only when `graphify-out/` already exists.

## Next Step

After indexing: `/analyze` for structured overview, or `/spec` for planning a change.
