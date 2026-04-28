# Spec: Sync Drift Between `.claude/` and `templates/claude/`

> **Spec ID**: 649 | **Created**: 2026-04-29 | **Status**: draft | **Complexity**: medium | **Branch**: —

## Goal

Re-establish source-of-truth between local `.claude/` (this repo's working dotfolder) and `templates/claude/` (what gets shipped to target projects via `npx ai-setup`). For each drifted file, decide direction (template→local, local→template, or accept divergence) and sync. Going forward, prevent silent drift via a CI check.

## Context

Format-enforcement spec (commit `c5fa67f`) revealed structural drift between `.claude/` and `templates/`. Background-fragestellung war: "Müsste nicht fast alles gleich sein?" — Antwort: ja, aber 6 files differieren inhaltlich, 6 scripts existieren nur lokal, 1 nur im Template, 4 skills nur lokal, 1 skill nur im Template. Das bedeutet:

1. Verbesserungen, die wir lokal an Rules/Hooks-README/Settings vornehmen, propagieren nicht zu Target-Projekten
2. Lokal nützliche Scripts (z.B. `quality-gate.sh`, `liquid-graph-refresh.sh`) fehlen in Target-Projekten
3. Templates dürften nicht in Target-Projekten verwendete Inhalte haben (z.B. `graphify` skill)

Strukturhinweis (wichtig für Sync):

- `templates/scripts/` → wird nach `.claude/scripts/` kopiert (nicht `templates/claude/scripts/`)
- `templates/claude/hooks/` → kopiert nach `.claude/hooks/`
- `templates/skills/` → kopiert (mit Template-Processing) nach `.claude/skills/`
- `templates/agents/` → kopiert nach `.claude/agents/`

## Stack Coverage

- **Profiles affected**: all (this is repo-meta, not stack-specific)
- **Per-stack difference**: none — affects every target project setup

## Drift Inventory

### Inhaltliche Diffs (6 files)

| File (local) | Template counterpart | Action TBD |
| --- | --- | --- |
| `.claude/hooks/README.md` | `templates/claude/hooks/README.md` | diff review |
| `.claude/rules/agents.md` | `templates/claude/rules/agents.md` | diff review |
| `.claude/rules/general.md` | `templates/claude/rules/general.md` | diff review |
| `.claude/rules/mcp.md` | `templates/claude/rules/mcp.md` | diff review |
| `.claude/rules/workflow.md` | `templates/claude/rules/workflow.md` | diff review |
| `.claude/settings.json` | `templates/claude/settings.json` | likely intentional (extra local hooks) — confirm |

### Scripts (`.claude/scripts/` vs `templates/scripts/`)

Local-only (6):

- `build-summary.sh`
- `codeburn-metrics.sh`
- `liquid-graph-refresh.sh`
- `quality-gate.sh`
- `session-deep-dive.sh`
- `session-extract.sh`

Template-only (1):

- `build-graph.sh`

### Skills (`.claude/skills/` vs `templates/skills/`)

Local-only (4):

- `bash-defensive-patterns/`
- `claude-changelog/`
- `gh-cli/`
- `orchestrate/`

Template-only (1):

- `graphify/`

### Template-only (rules, no local counterpart — likely OK)

- `templates/claude/rules/hooks-token-policy.md` (this repo has no Claude hooks-token policy)
- `templates/claude/rules/typescript.md` (this repo is bash, no TS)

### Hooks

- All 11 hook `.sh` files identical ✅
- Only `README.md` differs (already in inhaltliche Diffs above)

### Agents

- 7 files identical ✅

## Steps

- [ ] Step 1: `specs/649-claude-template-drift-sync.md` — review this inventory, mark each TBD with intended direction
- [ ] Step 2: `.claude/rules/*.md` ↔ `templates/claude/rules/*.md` — diff each pair, decide source-of-truth, sync (4 files)
- [ ] Step 3: `.claude/hooks/README.md` ↔ `templates/claude/hooks/README.md` — diff, sync
- [ ] Step 4: `.claude/settings.json` ↔ `templates/claude/settings.json` — diff, separate "lokal-only" hooks (logging, dev tools) from "should-ship" hooks; confirm intentional divergence list
- [ ] Step 5: Local-only scripts — for each, decide: ship to template (move to `templates/scripts/`) or keep lokal-only (document in `.claude/scripts/README.md`)
- [ ] Step 6: `templates/scripts/build-graph.sh` — verify usage, copy to `.claude/scripts/` if used here, otherwise leave template-only
- [ ] Step 7: Local-only skills — for each, decide: ship as template (create `templates/skills/<skill>/SKILL.template.md`) or keep lokal-only
- [ ] Step 8: `templates/skills/graphify/` — confirm intentional template-only or also install locally
- [ ] Step 9: `scripts/template-drift-check.sh` — new script that runs `diff -rq` between `.claude/` and the corresponding template paths, flagging unexpected drift (with allowlist for genuinely local-only files: `agents/`, `commands/`, `plans/`, `skills/`, `worktrees/`, `*.log`, `settings.local.json`, `agent-memory/`, `claude-powerline.json`, `changelog-audit.json`)
- [ ] Step 10: `.githooks/pre-commit` — call drift-check (skippable via `SKIP_PRECOMMIT_DRIFT=1`)
- [ ] Step 11: `.github/workflows/ci-smoke.yml` — add drift-check to CI (non-blocking warn first, blocking after grace period)

## Acceptance Criteria

- [ ] `bash scripts/template-drift-check.sh` exits 0 on a clean repo and 1 on unexpected drift
- [ ] All 6 inhaltliche Diffs resolved (either synced or explicitly allowlisted as intentional)
- [ ] All local-only scripts and skills are either shipped via templates or documented as lokal-only with rationale
- [ ] Pre-commit hook blocks new drift without explicit allowlist entry
- [ ] CI runs drift-check
- [ ] `npm run test:smoke` continues to pass (420/420)

## Files to Modify

- `.claude/rules/agents.md`, `general.md`, `mcp.md`, `workflow.md` — sync
- `.claude/hooks/README.md` — sync
- `.claude/settings.json` and/or `templates/claude/settings.json` — partial sync, allowlist the rest
- `templates/scripts/` — add 0–6 scripts depending on Step 5 decisions
- `.claude/scripts/` — add `build-graph.sh` if used
- `templates/skills/` — add 0–4 skills depending on Step 7
- `.claude/skills/graphify/` — add if Step 8 says so
- `scripts/template-drift-check.sh` — new
- `.githooks/pre-commit` — add drift-check call
- `.github/workflows/ci-smoke.yml` — add drift-check step

## Out of Scope

- Refactoring scripts or rules content (sync only — improvements are separate work)
- Changing the install pipeline in `lib/setup.sh` (just sync sources, not the copy logic)
- Format-enforcement (already shipped in commit `c5fa67f`)
- The `.sh` consolidation question ("brauchen wir wirklich alle?") — that is a separate audit, after sync is done
