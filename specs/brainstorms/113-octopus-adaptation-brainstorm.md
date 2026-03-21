# Brainstorm: claude-octopus Adaptionen für npx-ai-setup

> **Source**: https://github.com/nyldn/claude-octopus
> **Erstellt**: 2026-03-21
> **Zweck**: Evaluierung welche Agents, Commands, Skills und Patterns adaptierbar sind

## Kontext

Claude-Octopus ist ein Multi-AI Orchestrator (Codex + Gemini + Perplexity + Claude).
Das Multi-AI Kernkonzept ist MISALIGNED mit unserem Single-Claude-Ansatz.
Einzelne Patterns, Agents und Prompt-Techniken sind aber providerunabhängig und adaptierbar.

---

## A. /review + /grill Migration ★★★★★

### Problem
Wir haben zwei getrennte Commands für Code Review:
- `/review` (35 Zeilen) — analysiert Changes, reportet Bugs/Security/Performance
- `/grill` (69 Zeilen) — adversarial Review mit Scope Challenge, Issue Resolution, Self-Verification

**Redundanz:** Beide lesen denselben Diff, beide prüfen Security, beide prüfen Bugs. Nutzer müssen entscheiden welches sie brauchen.

### Octopus-Ansatz
Octopus hat EIN `review.md` mit Autonomy Detection + Multi-Stage Pipeline. Plus `staged-review.md` als optionale 2-Stufen-Variante.

### Vorschlag: Merge zu einem `/review` mit Intensitäts-Stufen

```
/review          → Quick Review (aktuelles /review Verhalten)
/review --deep   → Full Adversarial (aktuelles /grill Verhalten)
```

**Oder via AskUserQuestion am Start:**
- Quick Scan (Bugs + Security, 2 Min)
- Standard Review (+ Performance, Readability, Tests, 5 Min)
- Adversarial Grill (Scope Challenge, Issue Resolution, Self-Verification Table)

**Was aus /grill übernehmen:**
- Step 0 Scope Challenge (AskUserQuestion: Reduce / Full / Compressed)
- Self-Verification Table (jede Claim verifiziert mit File:Line)
- "NOT reviewed" Sektion (explizit was ausgelassen wurde)

**Was aus /review behalten:**
- Duplicate Detection via Grep ("Similar pattern already exists at...")
- Confidence Levels (HIGH/MEDIUM — kein LOW Noise)

**Aufwand:** Mittel (1 Command zusammenführen, /grill deprecaten)
**Empfehlung:** **SPEC ANLEGEN** — reduziert Tooling-Surface, vereinfacht Entscheidung

---

## B. Command-Vergleich: Einzelne Sätze/Patterns zum Adaptieren

### Aus Octopus `/review` adaptieren:
- **Autonomous Codegen Risk Detection**: "Check for stub code, placeholder implementations, TODO-marked incomplete code that AI may have generated" → in unseren `/review` einbauen
- **CVE Lookup**: Octopus prüft Dependencies gegen CVE-Datenbanken via Perplexity. Wir könnten `npm audit` / `snyk` als Schritt in `/review` aufnehmen

### Aus Octopus `/debug` adaptieren:
- **Red Flag Detection**: "Check for: silent exception swallowing, bare except/catch blocks, missing error propagation" → als Checkliste in `/bug` Step 2 aufnehmen
- **"NO FIXES WITHOUT ROOT CAUSE INVESTIGATION"** als Mandatory Contract → `/bug` hat das implizit, aber nicht als harten Gate

### Aus Octopus `/plan` adaptieren:
- **Intent Contract**: Session-Ziel in 1 Satz festhalten bevor Arbeit beginnt → nützlich für `/spec-work`
- **Workflow Routing Table**: Keywords → Command Mapping → unser `/auto` Router fehlt, aber für Onboarding-Guide nützlich

### Aus Octopus `/embrace` adaptieren:
- **Autonomy Modes**: "Supervised / Semi-autonomous / Autonomous" als Setting → könnte in `/spec-work-all` als Option
- **Parallel Verification**: "2 Agents parallel (Code Review + E2E Test)" am Ende jeder Phase → in `/spec-work` Step "Verify" einbauen

### Aus Octopus `/loop` adaptieren:
- **Stall Detection**: "If output of iteration N is substantially similar to N-1, abort" → direkt in unser `/loop` Skill übernehmen
- **Max Iterations Cap**: Default 5, Max 20 → wir haben kein Limit

### Aus Octopus `/factory` adaptieren:
- **Holdout Test Split**: Acceptance Criteria in "training" (zum Coden) und "holdout" (zum Testen) aufteilen → clever, verhindert Overfitting auf AC
- **Scoring**: behavior(40%) + constraints(20%) + holdout(25%) + quality(15%) → in `/spec-review` integrierbar

### Aus Octopus `/doctor` adaptieren:
- **12-Punkt Check**: Hooks, Auth, Config, Skills, Agents, Scheduler → direkt 1:1 übernehmen für unser Setup
- **Filter**: `doctor providers`, `doctor hooks` → Teildiagnosen

### Aus Octopus `/prd-score` adaptieren:
- **100-Punkte Framework**: A (AI Optimization 25pt) + B (Traditional Core 25pt) + C (Implementation Clarity 30pt) + D (Completeness 20pt) → Inspiration für Spec 112 (spec-validate scoring)

### Aus Octopus `/staged-review` adaptieren:
- **Stage 1 Intent Check**: "Does the code do what the spec says?" als Gate BEVOR Quality Review → Token-Spar-Trick

### Aus Octopus Principles adaptieren:
- **`general.md`**: Correctness, Reliability, Code Quality Checklisten → als `.claude/rules/quality-principles.md` Template
- **`performance.md`**: N+1, Caching, I/O, Frontend, Algorithmic → als Checkliste für `perf-reviewer` Agent
- **`security.md`**: Input/Output, Auth, Data Protection, Infra → als Checkliste für `/scan` und `code-reviewer`
- **`maintainability.md`**: SRP, DRY, Error Handling, Testability → als Checkliste für `staff-reviewer` Agent

---

## C. Neue Agents für Agentur-Arbeit ★★★★☆

### Warum relevant?
one-dot.de ist eine Digitalagentur (Shopify, Shopware, Vue/Nuxt, Storyblok). Octopus hat Personas die direkt auf Agenturarbeit passen — nicht als generisches Setup-Tool, sondern als **optionale Agent-Templates** die per Stack-Detection installiert werden.

### Kandidaten

#### C1. `frontend-developer` Agent ★★★★★
**Octopus**: React 19, Next.js App Router, Tailwind, WCAG 2.1 AA, Core Web Vitals.
**Unser Bedarf**: Vue/Nuxt + React/Next.js Projekte. Accessibility und Performance sind Agentur-Anforderungen.
**Adaption**: Stack-spezifisch machen (Vue/Nuxt statt nur React). Als Template-Agent installierbar.
**Aufwand**: Klein (1 Agent-Datei, ~40 Zeilen)

#### C2. `performance-engineer` Agent ★★★★☆
**Octopus**: OpenTelemetry, Profiling, Core Web Vitals, Caching, Load Testing.
**Unser Bedarf**: Unser `perf-reviewer` prüft nur bestehenden Code. Octopus-Version ist proaktiver (Baselines, Bottleneck-Analyse, Monitoring-Setup).
**Adaption**: Erweitert `perf-reviewer` um proaktive Optimierung statt nur Review.
**Aufwand**: Klein (bestehenden Agent erweitern oder 2. Agent hinzufügen)

#### C3. `debugger` Agent ★★★★☆
**Octopus**: Scientific method, Hypothesis-first, Regression Test Pflicht.
**Unser Bedarf**: `/bug` Command existiert, aber kein dedizierter Debug-Agent. Commands delegieren an `verify-app` + `code-reviewer`, nicht an einen spezialisierten Debugger.
**Adaption**: Als Agent der von `/bug` aufgerufen werden kann für komplexe Debugging-Fälle.
**Aufwand**: Klein (1 Agent-Datei)

#### C4. `security-auditor` Agent ★★★★☆
**Octopus**: OWASP Top 10, SAST/DAST, OAuth, Compliance (GDPR, HIPAA).
**Unser Bedarf**: `/scan` prüft nur Dependencies. Kein Agent der Code-Level Security prüft.
**Adaption**: Agent der von `/scan` aufgerufen wird für Deep Security Analysis.
**Aufwand**: Klein (1 Agent-Datei)

#### C5. `database-architect` Agent ★★★☆☆
**Octopus**: SQL/NoSQL, Migration Planning, Query Optimization.
**Unser Bedarf**: Eher nischig — Shopify-Projekte haben keine eigene DB. Relevant für Shopware/Custom.
**Adaption**: Optional, nur bei erkanntem DB-Stack installieren.
**Aufwand**: Klein (1 Agent-Datei)

#### C6. `docs-architect` Agent ★★★☆☆
**Octopus**: ADRs, API-Specs, Mermaid-Diagramme, Runbooks.
**Unser Bedarf**: `/analyze` + Context-Files decken vieles ab. ADR-Generierung wäre Mehrwert.
**Aufwand**: Klein (1 Agent-Datei)

### Nicht relevant für Agenturarbeit:
- `cloud-architect` — Wir deployen auf Shopify/Vercel/Netlify, kein AWS/GCP
- `tdd-orchestrator` — TDD-Enforcement zu dogmatisch für Agentur-Tempo
- `backend-architect` — Microservices/CQRS/Event-Driven passt nicht zu Shopify/Shopware

---

## D. Droids / Personas / Principles Architektur ★★★★☆

### Octopus 3-Stufen System

| Ebene | Ordner | Anzahl | Zweck |
|-------|--------|--------|-------|
| **Droids** | `agents/droids/` | 10 | Kompakte Agent-Defs für `.claude/agents/` |
| **Personas** | `agents/personas/` | 32 | Erweiterte Rollen mit `when_to_use`, `avoid_if`, Hooks |
| **Principles** | `agents/principles/` | 4 | Wiederverwendbare Qualitäts-Checklisten |

### Was davon übernehmen?

#### D1. `when_to_use` / `avoid_if` in Agent Frontmatter ★★★★★
Octopus-Agents haben:
```yaml
when_to_use: Failing tests, cryptic errors, race conditions
avoid_if: Infrastructure issues (use devops-troubleshooter), performance
```
**Unser Status**: Unsere Agents haben nur `description`. Kein Routing-Hinweis wann welcher Agent passt.
**Adaption**: `when_to_use` und `avoid_if` in alle Agent-Templates aufnehmen. Hilft sowohl dem Haupt-Claude bei der Agent-Auswahl als auch Nutzern beim Verständnis.
**Aufwand**: Klein (2 Zeilen pro Agent-Template)

#### D2. Principles als wiederverwendbare Rules ★★★★☆
Octopus hat 4 Principle-Files die von verschiedenen Agents referenziert werden.
**Unser Status**: Unsere Rules liegen in `.claude/rules/` (general.md, git.md, agents.md). Aber keine spezialisierten Quality-Checklisten.
**Adaption**: `principles/` als neue Template-Kategorie:
- `templates/rules/quality-general.md` — Correctness, Reliability
- `templates/rules/quality-performance.md` — N+1, Caching, Memory
- `templates/rules/quality-security.md` — OWASP, Input Validation, Auth
- `templates/rules/quality-maintainability.md` — SRP, DRY, Error Handling
**Aufwand**: Klein (4 Dateien, je ~20 Zeilen aus Octopus Principles extrahiert)

#### D3. Personas mit Hooks (PostToolUse Gates) ★★★☆☆
Octopus-Personas haben PostToolUse Hooks:
```yaml
hooks:
  PostToolUse:
    matcher: {tool: Bash}
    command: "${CLAUDE_PLUGIN_ROOT}/hooks/architecture-gate.sh"
```
**Unser Status**: Hooks sind in settings.json, nicht in Agents. Agent-spezifische Hooks existieren nicht in Claude Code nativ.
**Adaption**: Nicht direkt übertragbar — Claude Code unterstützt keine Agent-level Hooks. SKIP.

#### D4. 32 Personas als optionaler Katalog ★★☆☆☆
Octopus hat 32 spezialisierte Personas (academic-writer, finance-analyst, marketing-strategist, etc.)
**Unser Status**: Wir haben 9 Agents, alle development-fokussiert.
**Bedenken**: Business-Personas (Strategy, Marketing, Finance) gehören nicht in ein Dev-Setup-Tool.
**Adaption**: Nur die Development-relevanten Personas als optionale Agent-Templates. Rest ignorieren.

---

## E. Hook-Vergleich (38 Octopus Hooks vs. unsere 12)

### Was wir schon haben (identisch/besser):

| Unser Hook | Octopus Äquivalent | Status |
|------------|-------------------|--------|
| `context-monitor.sh` (≤35%/≤25%) | `context-awareness.sh` (65%/75%/80%) | ✅ Wir haben's, Octopus hat bessere Schwellen |
| `protect-files.sh` | — | ✅ Wir haben's, Octopus hat's nicht |
| `circuit-breaker.sh` | — | ✅ Wir haben's, Octopus hat's nicht |
| `pre-compact` (auto-commit) | `pre-compact.sh` (state snapshot) | ✅ Beide Ansätze, wir committen, sie snapshotten |
| `update-check.sh` | — | ✅ Wir haben's |
| `context-freshness.sh` | — | ✅ Wir haben's |
| `post-edit-lint.sh` | — | ✅ Wir haben's |

### Adaptierbare Hook-Patterns:

#### E1. Context Reinforcement nach Compaction ★★★★★
**Octopus `context-reinforcement.sh`**: SessionStart-Hook der "Iron Laws" nach Kompaktierung re-injiziert.
**Bei uns**: Nach Kompaktierung verliert Claude manchmal Regeln. Wir haben keinen Re-Injection-Mechanismus.
**Adaption**: SessionStart-Hook der kritische Rules (`general.md`, `git.md`, `agents.md`) als `additionalContext` injiziert wenn Context kompaktiert wurde.
**Aufwand**: Klein (1 Hook-Datei, ~30 Zeilen)
**Empfehlung**: **JA** — löst echtes Problem, verhindert Rule-Drift nach Compaction

#### E2. Output Quality Gates (PostToolUse) ★★★★☆
**Octopus hat 4 spezialisierte Gates:**
- `code-quality-gate.sh` — Prüft ob Agent-Output ≥2 Findings mit Severity hat
- `frontend-gate.sh` — Prüft ob Frontend-Output Accessibility + Responsive erwähnt
- `perf-gate.sh` — Prüft ob Perf-Output quantifizierte Metriken (ms/MB/req/s) hat
- `security-gate.sh` — Prüft ob Security-Output ≥2 OWASP Kategorien + Remediation hat

**Bei uns**: Keine Output-Validierung. Agents können oberflächliche Antworten liefern.
**Adaption**: 1 generischer `agent-output-gate.sh` der je nach Agent-Typ (via env var) prüft ob Output Substanz hat.
**Aufwand**: Mittel (1 Hook + Persona-Routing)
**Bedenken**: Kann false positives erzeugen. Muss gut kalibriert sein.
**Empfehlung**: **OPTIONAL** — nützlich aber komplex zu kalibrieren

#### E3. Budget Gate ★★★★☆
**Octopus `budget-gate.sh`**: PreToolUse-Hook der Session-Kosten gegen OCTOPUS_MAX_COST_USD prüft und blockt.
**Bei uns**: Kein Kosten-Limit. rtk trackt Savings aber blockt nicht.
**Adaption**: Hook der `CLAUDE_MAX_COST_USD` env var liest und bei Überschreitung warnt/blockt.
**Aufwand**: Klein (1 Hook-Datei, ~40 Zeilen)
**Empfehlung**: **JA** — sinnvoller Schutz gegen versehentliche Token-Explosion

#### E4. User Prompt Intent Classification ★★★☆☆
**Octopus `user-prompt-submit.sh`**: Klassifiziert User-Input und injiziert Persona-Routing-Hints.
**Bei uns**: Kein Intent-Routing. Claude entscheidet selbst welchen Agent er spawnt.
**Adaption**: Hook der bei erkanntem Intent (security, performance, frontend) den passenden Agent als `additionalContext` vorschlägt.
**Aufwand**: Mittel (Pattern-Matching in bash, muss schnell sein <50ms)
**Empfehlung**: **EHER NICHT** — `when_to_use`/`avoid_if` in Agent-Defs löst das eleganter ohne Hook-Overhead

#### Nicht relevant:
- `provider-routing-validator.sh` — Multi-AI (Codex/Gemini Detection)
- `agent-teams-phase-gate.sh` — Octopus-spezifisches Phase-System
- `scheduler-security-gate.sh` — Cron-Scheduler-spezifisch
- `sysadmin-safety-gate.sh` — OpenClaw-spezifisch
- `telemetry-webhook.sh` — Externer Webhook, nicht unser Modell
- `session-sync.sh` / `worktree-setup.sh` / `worktree-teardown.sh` — Multi-AI Session-Management
- `octopus-hud.mjs` / `octopus-statusline.sh` — Wir haben claude-hud

---

## F. MCP Server Analyse

**Octopus hat einen eigenen MCP Server** (`@octo-claw/mcp-server`):
- TypeScript, MCP SDK 1.26.0, 433 Zeilen
- Wrapped `orchestrate.sh` Commands als MCP Tools
- 11 Tools: discover, define, develop, deliver, embrace, debate, review, security, set_editor_context, list_skills, status
- IDE-Integration (VSCode, Cursor, Zed, Windsurf) via `ide-attach.sh`
- Skill-Schema für Cross-Platform Portabilität

### Für uns relevant?
**NEIN** — Octopus MCP Server ist ein Wrapper um ihr Multi-AI orchestrate.sh. Wir brauchen keinen MCP Server da Claude Code selbst der Orchestrator ist. Unsere MCP-Integrationen (Context7, claude-mem, Crewbuddy) sind externe Datenquellen, nicht Workflow-Wrapper.

**Einzige Ausnahme**: Das `skill-schema.json` (JSON Schema für Skill-Metadaten) ist ein interessantes Konzept für Skill-Portabilität. Niedrige Priorität.

---

## G. Scripts-Analyse: Was sollte bei uns Script statt Claude sein?

### Octopus Script-Architektur
- `orchestrate.sh` — 903 KB Hauptdatei (Multi-AI Orchestrator). **Nicht relevant.**
- `agent-registry.sh` — Agent-Lifecycle-Tracking (446 Zeilen)
- `reactions.sh` — Auto-Responses auf CI/PR Events (620 Zeilen)
- `metrics-tracker.sh` — Token/Cost Tracking (442 Zeilen)
- `scheduler/` — Vollständiger Cron-Daemon (6 Dateien, ~1200 Zeilen)
- `lib/routing.sh` — Task-Klassifikation (623 Zeilen)
- `validate-no-hardcoded-paths.sh` — CI-Check (83 Zeilen)

### Strategische Frage: Script vs. Claude

**Bash gewinnt bei:**
- **Deterministische Validierung**: Hooks, Gates, Format-Checks → immer gleich, <50ms, 0 Token
- **State Persistence**: JSON Files lesen/schreiben → kein LLM nötig
- **CI/CD Checks**: Release-Validation, Hardcoded-Path-Check → muss offline laufen
- **Kosten-Tracking**: Metriken aggregieren → arithmetisch, nicht kreativ

**Claude gewinnt bei:**
- **Analyse**: Code Review, Bug Investigation, Architecture Decisions
- **Generierung**: Specs, Docs, Tests, Code
- **Entscheidungen**: Agent-Routing, Complexity-Einschätzung, Scope-Challenge
- **Natural Language**: User-Interaktion, Erklärungen, Reports

### Konkrete Kandidaten für Scripts bei uns:

#### G1. `/doctor` als Bash-Script ★★★★★
**Statt Claude-Command**: Ein `scripts/doctor.sh` das deterministische Checks ausführt:
- `[ -f .claude/settings.json ]` → Hooks installiert?
- `jq '.hooks' settings.json` → Alle erwarteten Hooks da?
- `ls .agents/context/` → Context-Files vorhanden?
- `wc -l CLAUDE.md` → Nicht zu groß (>500 Zeilen = Warnung)?
- `claude mcp list 2>/dev/null` → MCP Server erreichbar?

Claude wird nur für die Zusammenfassung/Empfehlung am Ende gebraucht.
**Vorteil**: 0 Token für die Checks, sofortige Ergebnisse, offline nutzbar.
**Aufwand**: Mittel (1 Script, ~100 Zeilen)

#### G2. `validate-no-hardcoded-paths.sh` ★★★★☆
**Direkt übernehmen**: Prüft alle git-tracked Files auf `/Users/*`, `/home/*`. Perfekt für CI.
**Aufwand**: Klein (1 Script, ~80 Zeilen, fast 1:1 kopierbar)

#### G3. Pre-Release Validation Script ★★★★☆
**Aus Octopus `validate-release.sh`**: Version-Konsistenz, CHANGELOG-Entry, Tag-Check.
**Adaption für uns**: Prüft dass `package.json` Version, `CHANGELOG.md`, git tag konsistent sind.
**Aufwand**: Klein (1 Script, ~100 Zeilen)

#### G4. Agent Output Quality Check als Script ★★★☆☆
**Statt Claude-basierter Prüfung**: Einfache grep-Checks ob Agent-Output Substanz hat.
**Bedenken**: grep-basierte Qualitätsprüfung hat viele false positives.
**Empfehlung**: Besser als Hook (E2) denn als eigenständiges Script.

#### G5. Metrics/Cost Tracking Script ★★★☆☆
**Aus Octopus `metrics-tracker.sh`**: Session-Kosten tracken, Reports generieren.
**Bei uns**: rtk macht Token-Tracking. Ein Cost-Summary-Script wäre Ergänzung.
**Empfehlung**: **OPTIONAL** — rtk deckt das meiste ab.

### Was NICHT als Script:
- Spec-Workflow (braucht Claude für Analyse + Generierung)
- Code Review (braucht Verständnis, nicht Pattern-Matching)
- Agent-Routing (Claude's Agent-Tool ist besser als bash Keyword-Matching)
- Challenge/Evaluate (braucht kritisches Denken)

---

## H. Skill-Vergleich: Was ist adaptierbar?

### Aus Octopus Skills übernehmen:

| Octopus Skill | Adaptierbar? | Was übernehmen |
|---------------|-------------|----------------|
| `skill-verify.md` | ★★★★★ | "NO COMPLETION WITHOUT FRESH VERIFICATION EVIDENCE" — als Pattern in `/spec-work` |
| `skill-iterative-loop.md` | ★★★★☆ | Stall Detection + Max Iterations — in unser `/loop` Skill |
| `skill-rollback.md` | ★★★★☆ | Automated Rollback Orchestration — als neuer Agent oder `/undo` Command |
| `skill-finish-branch.md` | ★★★☆☆ | Branch Cleanup + Merge — unser `/pr` deckt das teilweise ab |
| `skill-issues.md` | ★★★☆☆ | `.octo/ISSUES.md` Tracking — wir haben Specs stattdessen |
| `skill-status.md` | ★★★☆☆ | Workflow Dashboard — unser `/spec-board` ähnlich |
| `skill-thought-partner.md` | ★★★☆☆ | Pattern Spotting, Paradox Hunting — in `/challenge` einbaubar |
| `skill-factory.md` | ★★☆☆☆ | Holdout Test Split — clever aber komplex |
| `skill-debate.md` | ★☆☆☆☆ | Multi-AI Debate — nicht ohne externe Provider |
| `skill-content-pipeline.md` | ★☆☆☆☆ | URL Content Analysis — zu nischig |
| `skill-deck.md` | ★☆☆☆☆ | PPTX Generation — nicht unser Scope |

---

## J. Script-First Strategie ★★★★★ (TOP-PRIORITÄT)

### Kernidee
Deterministische Command-Teile als Bash-Scripts auslagern. Claude nur für Analyse/Generierung.
Geschätzte Einsparung: **~60% der Command-Tokens** (~90.000 Tokens/Tag bei 50 Aufrufen).

### Spec 1: Pure Scripts (100% Bash, 0 Token)
| Command | Was das Script tut |
|---------|-------------------|
| `/spec-board` | Alle Specs lesen, Status parsen, Kanban-Tabelle als Markdown ausgeben |
| `/doctor` | 12 Checks (Hooks, Settings, Context-Files, MCP, CLAUDE.md Größe), Ergebnis-Tabelle |
| `/release` | Version bump in package.json, CHANGELOG-Entry, git tag, git push |

### Spec 2: Hybrid Scripts (Script-Prep + Claude-Finish)
| Command | Script-Prep (0 Token) | Claude-Finish (Token) |
|---------|----------------------|----------------------|
| `/scan` | `npm audit --json`, Severity-Filter, Gruppierung | Empfehlungen, Priorisierung |
| `/commit` | `git diff --staged` + `git log --oneline -5` sammeln | Commit-Message generieren |
| `/test` | Tests ausführen, grün → fertig (0 Token). Rot → Output sammeln | Failures analysieren + fixen |

### Spec 3: Review-Prep Scripts
| Command | Script-Prep | Claude-Analyse |
|---------|------------|---------------|
| `/review` | Diff sammeln, Duplicate-Grep vorab, Changed-Files-Liste | Code Review |
| `/spec-validate` | Spec parsen (Zeilen, Felder, Struktur-Check), Rohdaten aufbereiten | Inhaltliche 0-10 Bewertung |

### Implementierungspfad
Scripts landen in `templates/scripts/` und werden bei Setup nach `.claude/scripts/` kopiert.
Commands rufen Scripts via `!.claude/scripts/spec-board.sh` auf oder als Hook-Prep.

---

## K. Gesamtranking nach Aufwand/Nutzen (alle Bereiche)

| Rang | Item | Bereich | Value | Aufwand | Empfehlung |
|------|------|---------|-------|---------|------------|
| 1 | **J1. Pure Scripts (spec-board, doctor, release)** | Scripts | ★★★★★ | Mittel | **SPEC** |
| 2 | **J2. Hybrid Scripts (scan, commit, test)** | Scripts | ★★★★★ | Mittel | **SPEC** |
| 3 | **J3. Review-Prep Scripts** | Scripts | ★★★★★ | Klein | **SPEC** |
| 4 | **A. /review + /grill Merge** | Commands | ★★★★★ | Mittel | **SPEC** |
| 5 | **A2. /bug → /debug Enhanced** | Commands | ★★★★★ | Klein | **SPEC** |
| 6 | **E1. Context Reinforcement Hook** | Hooks | ★★★★★ | Klein | **SPEC** |
| 7 | **D1. when_to_use/avoid_if** | Agents | ★★★★★ | Klein | **SPEC** |
| 8 | **C1. frontend-developer Agent** | Agents | ★★★★★ | Klein | **SPEC** |
| 9 | **B2. Stall Detection** | Patterns | ★★★★☆ | Klein | **SPEC** |
| 10 | **D2. Quality Principles Rules** | Agents | ★★★★☆ | Klein | **SPEC** |
| 11 | **G3. Pre-Release Validation** | Scripts | ★★★★☆ | Klein | SPEC |
| 12 | **C2. performance-engineer Agent** | Agents | ★★★★☆ | Klein | SPEC |
| 13 | **C4. security-auditor Agent** | Agents | ★★★★☆ | Klein | SPEC |
| 14 | **B3. Mandatory Exec. Gates** | Patterns | ★★★★☆ | Mittel | SPEC |
| 15 | **B4. Stub/AI-Code Detection** | Patterns | ★★★★☆ | Klein | In Review-Merge |
| 16 | **E2. Output Quality Gates** | Hooks | ★★★★☆ | Mittel | Optional |
| 17 | **B5. Holdout Test Split** | Patterns | ★★★☆☆ | Mittel | Optional |
| 18 | **C5. database-architect Agent** | Agents | ★★★☆☆ | Klein | Optional |
| 19 | **C6. docs-architect Agent** | Agents | ★★★☆☆ | Klein | Optional |
| 20 | **G5. Metrics/Cost Script** | Scripts | ★★★☆☆ | Klein | Optional (rtk) |
| 21 | **B6. Intent Contract** | Patterns | ★★★☆☆ | Klein | Redundant |
| 22 | **E4. Intent Classification Hook** | Hooks | ★★★☆☆ | Mittel | when_to_use löst das |
| 23 | **B7. Status Contracts** | Patterns | ★★★☆☆ | Mittel | Eher nicht |
| 24 | **D4. 32 Personas Katalog** | Agents | ★★☆☆☆ | Hoch | Nein |
| 25 | **B8. meta-prompt** | Patterns | ★★☆☆☆ | Klein | Nein |
| 26 | **F. MCP Server** | Infra | ★☆☆☆☆ | Hoch | Nein |

---

## Nächste Schritte

### Empfohlen als Specs (Top 12):

**Script-First (3 Specs — TOP-PRIORITÄT, ~60% Token-Einsparung):**
1. Pure Scripts: `/spec-board`, `/doctor`, `/release` als 100% Bash
2. Hybrid Scripts: `/scan`, `/commit`, `/test` mit Script-Prep + Claude-Finish
3. Review-Prep: `/review`, `/spec-validate` Diff/Context als Script vorsammeln

**Commands (2 Specs):**
4. `/review` + `/grill` Merge → ein Command mit Intensitäts-Stufen
5. `/bug` → `/debug` Enhanced mit Hypothesis-first + Regression Test Pflicht

**Hooks (1 Spec):**
6. Context Reinforcement nach Compaction (SessionStart Hook)

**Agents & Rules (4 Specs):**
7. `when_to_use` / `avoid_if` in alle Agent-Templates
8. `frontend-developer` Agent Template
9. Quality Principles als Rules-Templates (4 Dateien)
10. Stall Detection in `/loop` + `/spec-work`

**CI/Validation (2 Specs):**
11. `validate-no-hardcoded-paths.sh` für CI
12. Pre-Release Validation Script

### Zweite Welle:
13. `performance-engineer` Agent
14. `security-auditor` Agent
15. Mandatory Execution Gates in bestehende Commands

### Phase 2: Multi-Agent Delegation (nach Script-First)

**Strategie**: Script-First (Specs 114-116) ist Priorität 1 mit 60% Ersparnis bei 0 Risiko.
Multi-Agent ist Priorität 2 mit ~20-40% zusätzlicher Ersparnis bei mittlerem Qualitätsrisiko.

**Verfügbare CLIs**: codex (OpenAI), gemini (Google), aider (Open Source, Multi-Model), opencode (Go CLI).
Nicht geeignet: gh copilot (kein Coding-Agent), Copilot CLI (deprecated).

**Routing-Strategie:**
- Priorität 1: Script-First (60% Ersparnis, 0 Risiko)
- Priorität 2: Codex für Template-Tasks (20% extra) — nur gut definierte, einfache Steps
- Priorität 3: Gemini für Analyse (10% extra) — große Kontexte, Research

**3-Stufen Quality Gate (kritisch!):**
- Stufe 1: Deterministic Check (0 Token) — Datei erstellt? Syntax valid? Nicht leer?
- Stufe 2: Convention Check (0 Token) — Shellcheck/Linter passed? Tests grün?
- Stufe 3: Claude Quick-Review (nur bei Bedarf) — "Passt das zum Projekt?" (~$0.02)

**Auto-Detect mit Fallback:**
- `command -v codex` → verfügbar → nutzen. Nicht installiert → Claude macht es.
- User-Override: `AI_PROVIDERS=claude` in `settings.local.json` deaktiviert alles.
- Zero-Config by Default: Wer nichts installiert hat, merkt keinen Unterschied.

**Ehrliche Einschätzung:** Delegation lohnt sich NUR für einfache, gut definierte Tasks.
Für alles was Projekt-Kontext oder Urteilsvermögen braucht → Claude bleibt besser.
Rework-Kosten bei schlechtem Output können die Ersparnis auffressen.

**Nächste Schritte:** Codex + Gemini CLI hands-on testen, dann Spec 126 anlegen.

### Bewusst verworfen:
- Octopus MCP Server — wir brauchen keinen Workflow-Wrapper
- Business Personas (Strategy, Finance, Marketing) — nicht Dev-Setup Scope
- Agent-level Hooks — CC unterstützt das nicht nativ
- PPTX/DOCX Generation — nicht unser Scope
- 903 KB orchestrate.sh — Multi-AI Orchestrator, zu komplex für unseren Ansatz
- Scheduler/Cron Daemon — `/loop` Skill + CronCreate reicht
