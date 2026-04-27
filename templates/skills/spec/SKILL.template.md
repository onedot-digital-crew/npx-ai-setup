---
name: spec
description: "Creates a validated, production-ready spec before implementation. Trigger: 'let\\'s spec this', 'plan this out', 'new feature'."
user-invocable: true
disable-model-invocation: true
effort: high
model: opus
argument-hint: "<task description>"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
  - Agent
---

Creates a structured, self-validated spec for: $ARGUMENTS. Use before any multi-file or architectural change.

## Tool & Context Matrix

Read this matrix once at start. Skip silently if a file doesn't exist.

**Foundation (read every spec):**

| File | Phase | Why |
|---|---|---|
| `.agents/context/STACK.md` | 1b | Frameworks, versions, build tooling |
| `.agents/context/ARCHITECTURE.md` | 1d | System boundaries, layers |
| `.agents/context/CONVENTIONS.md` | 2.3 | Code style for step descriptions |
| `.agents/context/CONCEPT.md` | 1c | REJECT spec if misaligned |
| `.agents/context/graph.json` | 1d | jq top-hubs query (saves grep tokens) |
| `decisions.md` | 1e | Conflict check vs prior decisions |

**Adaptive (trigger by spec content):**

| Tool / File | Trigger | Phase |
|---|---|---|
| Context7 MCP | new dep, version bump, lib/API/SDK/cloud-service mentioned | 1e |
| `@references/code-flow.md` | refactor / integration / behavior change in existing functions | 1d |
| `@references/challenge.md` (heavy gate) | heavy spec (definition in Phase 1c) | 1c |
| Assumptions table | heavy spec only | 1e |
| `templates/context-bundles/<profile>/` | single-stack spec + bundle exists for profile | 2.2 |
| `.agents/context/PATTERNS.md` | spec adds component/hook/route where patterns apply | 2.3 |
| `.agents/context/LEARNINGS.md` | spec touches area with prior learnings (keyword grep) | 1d |
| **Graph-adjacent reads** | after picking a file from graph top-hubs, also read its direct importers via `jq '.edges[] \| select(.target==$f) \| .source' \| head -5`. Skip if >10 importers (hub too central). | 1d / 2.2 |

**Anti-bloat guards:**
- One read per file. No re-reads.
- Context7: max 2 lookups per spec. More → split spec (also triggers Phase 2.4 split).
- File-count cap per spec: light max 4 context files, heavy max 7.
- Adaptive rows fire only when trigger matches spec content — never default-on.

## Phase 0 — Preflight

If `$ARGUMENTS` is empty: AskUserQuestion mandatory `Was soll diese Spec erreichen?` (no default), or abort. Do not proceed with empty goal.
Run `mkdir -p specs specs/completed` to ensure directories exist.

## Phase 1 — Triage

### 1a. Load skills
Glob `.claude/skills/*/SKILL.md`, read first 5 lines each. Apply relevant guidance.

### 1b. Context-Scan (mandatory)
Spawn `context-scanner` subagent (model: haiku). See `@references/context-scan.md`.
**On subagent failure** (timeout, quota, parse error): degrade to inline Glob for stack markers (`nuxt.config.*`, `next.config.*`, `artisan`, `composer.json`, `package.json`) and proceed with `stack_profile=unknown`.
Read STACK.md (matrix above). SUMMARY.md is auto-imported via CLAUDE.md tier-1.
Present the scan summary in chat, then ask one consolidated AskUserQuestion call:

```
AskUserQuestion({
  questions: [
    { question: "Was soll diese Spec erreichen?", header: "Anforderung",
      options: [plain text from $ARGUMENTS as default, "Other / eigene Eingabe"] },
    { question: "Scope-Grenze?", header: "Scope",
      options: ["Nur dieses Feature", "Feature + Refactor", "Breaking Change", "Other"] },
    { question: "Stack-Coverage?", header: "Stack",
      options: ["Single: <detected_profile>", "Multi: alle Stacks", "Spezifisch wählen", "Other"] },
    { question: "Was ist explizit Out of Scope?", header: "OoS",
      options: ["Tests", "Doku", "Migration", "Other"] }
  ]
})
```

If `$ARGUMENTS` is an existing `.md` file: read it first, skip question 1.

### 1c. Complexity triage
Read `.agents/context/CONCEPT.md` if present. REJECT only if CONCEPT.md contains an `## Out of Scope` or `## Anti-Goals` section the spec violates. Missing sections → skip rejection.

**Heavy** (single source of truth for matrix triggers): >5 files OR new dep OR cross-layer arch OR breaking change.
**Light**: everything else.

Heavy → run `@references/challenge.md` (4 challenges + AskUserQuestion). Stop on abort, adjust on scope change.
Light → skip challenge gate.

### 1d. Think it through
Read ARCHITECTURE.md (matrix). If `graph.json` exists:
```bash
jq -r '.stats.top_hubs[] | "\(.imported_by)x \(.file)"' .agents/context/graph.json | head -10
```
Using scan + STACK + ARCHITECTURE + 1b answers, sketch:
- Files/systems touched per stack profile
- Integration path, data flow, what calls what
- Edge cases, failure behavior, recoverability
- Impact surface + risk

Code-flow analysis (trigger from matrix, max 5 functions): see `@references/code-flow.md`.

### 1e. Decisions + assumptions
Read `decisions.md` (matrix) — flag conflicts before proceeding.
External libs/APIs: query Context7 per matrix trigger. Never guess versions from training data.
Heavy: scan 3-5 files, capture `Statement / Evidence / Confidence / If Wrong`. Confirm only material-scope assumptions.
Light: skip assumptions table. Decisions + Context7 still apply.

## Phase 2 — Draft the spec

1. **Spec number**: Scan `specs/` + `specs/completed/` for highest `NNN-*.md`, increment by 1. After Write, verify uniqueness: `ls specs/NNN-*.md | wc -l` — if >1, increment NNN and re-write (race-condition guard for parallel sessions).
2. **Analyze**: Read 2-3 most relevant source files. Reuse Phase 1 sketch.
3. **Create**: Use template from `@references/template.md`. Apply CONVENTIONS-style (already loaded via matrix). Include **Stack Coverage** section. Each step must introduce a NEW code change — remove redundant steps, add steps for blocked flows.
4. **Auto-split**: When >12 steps OR cross-layer architecture (frontend + backend + DB) OR >2 Context7 lookups required. Length alone is not a trigger — coherent specs may be long.

## Phase 3 — Structural check (automatic, zero tokens)

Aligned with Anthropic Plan Mode: structure verified by script, content reviewed by user.

1. **Run prep**: `bash .claude/scripts/spec-validate-prep.sh NNN`.
2. **Read structural score** from output (sections present, steps >0, AC >0, files >0).
3. **Auto-fix on FAIL** (score <80): re-edit the spec to add missing sections / fill empty Steps, AC, or Files lists. Re-run prep once. Still FAIL → proceed to Phase 4 with banner `⚠ Structural FAIL — manual review required`.
4. PASS → continue. No content scoring, no rubric — that's the user's job in Phase 4.

## Phase 4 — User review + branch

1. **Present**: Show final spec (include FAIL banner from Phase 3 if any).
2. **Approve**: AskUserQuestion — `Approve / Refine / Abort`. Refine → edit spec per feedback, re-run Phase 3, return here. Abort → stop.
3. **Refine cap**: max 3 refine iterations. After 3rd: AskUserQuestion `Approve as-is / Abort / Continue (acknowledge cost)`.
4. **Branch**: AskUserQuestion — create `spec/NNN-<slug>` now / later / skip.

## Next Step

> ⚡ Naechster Schritt: `/spec-work NNN` — Spec implementieren
