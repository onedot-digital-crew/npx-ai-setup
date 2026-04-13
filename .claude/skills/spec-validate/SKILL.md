---
name: spec-validate
description: "Validate a draft spec before execution."
effort: low
model: haiku
argument-hint: "<NNN spec number>"
---

Validates spec $ARGUMENTS against 10 quality metrics. Run before `/spec-work` to catch weak specs early.

## Process

### 1. Find and validate the spec
If `$ARGUMENTS` is a number, open `specs/NNN-*.md`. If empty, list draft specs and ask. Only validate `Status: draft` — otherwise report status and stop.

### 2. Run prep script
```bash
bash .claude/scripts/spec-validate-prep.sh "$ARGUMENTS"
```
Use output to populate scoring. If script missing, read spec directly.

### 3. Load context
Read `.agents/context/CONVENTIONS.md` if it exists for calibration.

### 4. Score the spec

Score 0–10 per criterion. Be strict — unanswered questions score ≤5.

| # | Metric | Weight | Question |
|---|--------|--------|----------|
| 1 | Goal Clarity | 12% | Specific, bounded, measurable goal? |
| 2 | Step Decomposition | 12% | Atomic steps, no megasteps? |
| 3 | Coverage Completeness | 12% | Steps cover entire goal? |
| 4 | Acceptance Criteria | 12% | Testable YES/NO criteria? |
| 5 | File Coverage | 12% | All changed files listed? |
| 6 | Integration Awareness | 12% | Integration with existing code addressed? |
| 7 | Dependency ID | 7% | External deps named? |
| 8 | Scope Coherence | 7% | Realistic scope for one spec? |
| 9 | Risk & Blockers | 7% | Risks/ambiguities mentioned? |
| 10 | Out of Scope | 7% | Precise enough to prevent creep? |

### 5. Present results

```
Spec Validation — NNN: [title]
──────────────────────────────────────────────────────────
 #  Criterion                    Raw (0–10)  Weight  Score
──────────────────────────────────────────────────────────
 1  Goal Clarity                    X.X       12%     X.X
...
──────────────────────────────────────────────────────────
   Total weighted score: XX.X / 100     Grade: X
```

### 6. Technical Preflight (Pass 2 — Sonnet subagent)

Spawn a Sonnet subagent to verify technical claims against the actual codebase.

```
Agent(subagent_type="Explore", model="sonnet", prompt="""
Technical preflight for spec: <spec file path>

Spec content (Files to Modify + Context + Steps sections):
<paste relevant sections>

Tasks:
1. File existence: For every file in "Files to Modify", check if it exists (Glob). Report EXISTS or MISSING.
2. Premise check: Extract 2-3 factual claims from Context/Steps (e.g. "X is set to Y", "file Z uses pattern W"). Verify each with Grep. Report CONFIRMED (file:line) or UNVERIFIED.
3. Risk surface: Grep for imports/usages of listed files. Flag any unlisted files that import them and may need updating.

Output format:
Files to Modify
  path/to/file.ts     EXISTS
  path/to/other.ts    MISSING ← blocker

Premise Checks
  "claim text"   CONFIRMED (file.ts:42)
  "claim text"   UNVERIFIED

Risks
  - path/unlisted.ts imports foo.ts — may need updating (not listed)

Preflight: PASS / WARN / FAIL
""")
```

Preflight result:
- **PASS** — all files exist, premises confirmed
- **WARN** — minor gaps, proceed with caution
- **FAIL** — missing files or false premises → fix spec before `/spec-work`

### 7. Verdict

| Grade | Threshold | Action |
|-------|-----------|--------|
| A | ≥ 85 | "Run `/spec-work NNN`." |
| B | ≥ 70 | "Run `/spec-work NNN`." |
| C | ≥ 55 | List criteria <7 with fixes. "Revision recommended." |
| F | < 55 | List criteria <7 with fixes. "Fix and re-run `/spec-validate NNN`." |

Preflight FAIL overrides Grade A/B — do not proceed to `/spec-work` until resolved.

## Next Step

- Grade A/B + Preflight PASS: `> Naechster Schritt: /spec-work NNN — Spec implementieren`
- Grade A/B + Preflight WARN: `> Naechster Schritt: /spec-work NNN — Preflight-Warnings im Blick behalten`
- Grade A/B + Preflight FAIL: `> Naechster Schritt: Spec korrigieren (fehlende Dateien / falsche Praemissen), dann /spec-validate NNN`
- Grade C: `> Naechster Schritt: Kriterien <7 fixen, dann /spec-validate NNN erneut`
- Grade F: `> Naechster Schritt: Spec ueberarbeiten, dann /spec-validate NNN erneut`

## Rules
- **Read-only** — never modify the spec or any file.
- Score honestly. Only report metrics that fail.
- Preflight FAIL blocks `/spec-work` recommendation, not the user.
- Pass 1 (Haiku): structural scoring only — no file reads beyond spec + CONVENTIONS.md.
- Pass 2 (Sonnet subagent): codebase verification — Glob/Grep, no full-file reads unless unavoidable.
