# Brainstorm: OpenSpec Evaluation for npx-ai-setup Spec System

> **Source**: https://github.com/Fission-AI/OpenSpec
> **Erstellt**: 2026-03-22
> **Zweck**: Evaluierung ob OpenSpec-Patterns unser Spec-Template und -Workflow verbessern

## Bestandsvergleich

| Funktion | OpenSpec | Unsere Skills | Status |
|----------|---------|---------------|--------|
| Spec erstellen | `/opsx:propose` (4 Artifacts) | `/spec` (1 File, Challenge-Phase) | ✅ Anders, unseres einfacher |
| Spec ausfuehren | `/opsx:apply` | `/spec-work` (step-by-step, commits) | ✅ Unseres besser (Git-Integration) |
| Spec validieren | CLI `openspec validate` | `/spec-validate` (10 Kriterien) | ✅ Covered |
| Spec reviewen | `/opsx:verify` (3 Checks) | `/spec-review` (Truths/Artifacts/Links) | ⚠️ Partial — ihre 3-Check-Struktur ist klarer |
| Board/Status | `openspec list/view` | `/spec-board` (Kanban) | ✅ Covered |
| Parallel-Execution | — | `/spec-work-all` (Worktrees) | ✅ Wir haben mehr |
| Explore/Think | `/opsx:explore` (read-only) | `/challenge` (aber darf schreiben) | ⚠️ Partial |
| Idea Challenge | — | `/spec` Phase 1 (Challenge) | ✅ Wir haben, sie nicht |
| Delta-Specs | ADDED/MODIFIED/REMOVED | — | ❌ Missing (aber YAGNI?) |
| Source-of-Truth Specs | `openspec/specs/` (persistent) | `.agents/context/` | ⚠️ Partial (anderer Zweck) |
| Schema-Customization | YAML-defined, forkable | Festes Template | ❌ Missing (aber YAGNI) |
| Multi-Tool | 24+ Tools | Claude + Gemini + Codex | ⚠️ Partial |
| Complexity Routing | — | low/medium/high → Model-Wahl | ✅ Wir haben mehr |
| Crash Resilience | — | Commit-per-step, Resume | ✅ Wir haben mehr |

## Was OpenSpec besser macht

### 1. Strukturierte Verification (3 Checks)
OpenSpec `/opsx:verify` prueft systematisch:
- **Completeness**: Alle Tasks erledigt?
- **Correctness**: Code entspricht Specs? (liest Code, vergleicht mit Requirements)
- **Coherence**: Logisch konsistent? Edge Cases? Tests?

Unser `/spec-review` hat diese Struktur implizit, aber nicht explizit benannt.

### 2. Explore Mode (Read-Only Thinking)
`/opsx:explore` ist ein reiner Denkpartner: DARF Codebase lesen, DARF NICHT Code schreiben.
Unser `/challenge` darf theoretisch schreiben. Ein reiner Think-Mode fehlt.

### 3. WHEN/THEN Scenarios in Specs
OpenSpec-Specs nutzen formale Szenarien:
```
### Requirement: User can log in
#### Scenario: Valid credentials
- WHEN user submits correct email and password
- THEN session is created
- AND redirect to dashboard
```
Unsere Acceptance Criteria sind freier formuliert (Truths/Artifacts/Key Links).

### 4. Artifact-Dependency-Graph
OpenSpec hat einen expliziten Dependency-Graph: proposal → specs → design → tasks.
Jedes Artifact weiss was es braucht. Status wird programmatisch getrackt.

## Was wir besser machen

### 1. Single-File Simplicity
OpenSpec: 4 Dateien pro Change (proposal, specs, design, tasks) + YAML-Config.
Wir: 1 Datei pro Spec. Weniger Overhead, schneller zu lesen, weniger Token.

### 2. Challenge Phase (Built-In)
Unser `/spec` hat Phase 1 mit Concept Fit, Necessity, Alternatives, Overhead-Analyse.
OpenSpec hat KEINEN Challenge-Schritt — geht direkt zum Proposal.

### 3. Git-First Execution
Commit nach jedem Step, Branch pro Spec, Worktree-Isolation.
OpenSpec hat keine Git-Integration — Tasks werden abgehakt, aber nicht committet.

### 4. Complexity-Based Model Routing
low → direkt, medium → sonnet, high → opus.
OpenSpec hat keine Model-Awareness.

### 5. Crash Resilience
Resume von `[x]`-markierten Steps, Context-Budget-Awareness.
OpenSpec hat kein Resume-Konzept.

### 6. Token Economics
Unsere Specs sind ~30-60 Zeilen. OpenSpec-Changes sind 4+ Dateien mit Templates.
Unser prep-script Pattern (zero-token green path) hat kein Equivalent.

## Gesamtranking: Adaptionskandidaten

| # | Pattern | Value | Aufwand | Empfehlung |
|---|---------|-------|---------|------------|
| 1 | Explore Mode (read-only) | ★★★ | Klein | ADOPT — als `/explore` Skill |
| 2 | 3-Check Verification | ★★★ | Klein | ADOPT — in spec-review einbauen |
| 3 | WHEN/THEN Scenarios | ★★ | Klein | CONSIDER — als optionales AC-Format |
| 4 | Delta-Specs | ★★ | Gross | SKIP — unser Task-Spec-Modell passt besser |
| 5 | Schema-Customization | ★ | Gross | SKIP — YAGNI, ein Format reicht |
| 6 | Multi-Artifact Pipeline | ★ | Gross | SKIP — Single-File ist unsere Staerke |
| 7 | Source-of-Truth Specs | ★★ | Mittel | SKIP — .agents/context/ deckt das ab |

## Fazit

Unser Spec-System ist fuer unseren Usecase (Claude-Code-zentriert, token-effizient, Git-first) **besser als OpenSpec**. OpenSpec optimiert fuer Multi-Tool-Support und formale Requirement-Dokumentation — ein anderer Fokus.

Zwei Patterns sind klar uebernehmenswert: **Explore Mode** und **strukturierte Verification**. Der Rest ist entweder YAGNI oder widerspricht unseren Prinzipien (Single-File, Zero-Dependency, Token-Effizienz).
