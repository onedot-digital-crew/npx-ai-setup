# Brainstorm: Superpowers Adaptionen fuer npx-ai-setup

> **Source**: https://github.com/obra/superpowers
> **Erstellt**: 2026-03-22
> **Zweck**: Evaluierung welche Patterns aus obra/superpowers adaptierbar sind
> **Status**: Completed

---

## Executive Summary

Superpowers ist ein Skills-basiertes Workflow-System fuer Claude Code (und andere Coding Agents) von Jesse Vincent. Es definiert einen opinionierten End-to-End Development Workflow: Brainstorming → Design Doc → Implementation Plan → Subagent-Driven Execution → Code Review → Branch Finish.

**Version**: 5.0.4 | **14 Skills** | **3 Commands** (deprecated) | **1 Agent** (code-reviewer) | **Hooks** (session-start)

---

## Bestandsvergleich: Was haben wir schon?

### Commands (Superpowers → Unsere)

| Superpowers | Unser Equivalent | Status |
|-------------|-----------------|--------|
| brainstorm (deprecated → skill) | `/spec` (Draft Interview Mode) | ⚠️ Partial — SP hat Design-Doc-First + Visual Companion |
| write-plan (deprecated → skill) | `/spec` + `/spec-work` | ✅ Covered — unsere Specs sind Plans |
| execute-plan (deprecated → skill) | `/spec-work`, `/spec-work-all` | ✅ Covered — wir haben parallele Worktree Execution |

### Skills (Superpowers → Unsere)

| Superpowers Skill | Unser Equivalent | Status |
|-------------------|-----------------|--------|
| **brainstorming** | `/spec` (Phase 1 Interview) | ⚠️ Partial |
| **writing-plans** | `/spec` (Output ist der Plan) | ✅ Covered |
| **executing-plans** | `/spec-work` | ✅ Covered |
| **subagent-driven-development** | `/spec-work` + `/spec-work-all` | ⚠️ Partial |
| **test-driven-development** | `testing.md` Rule | ⚠️ Partial |
| **systematic-debugging** | `/debug` Command | ⚠️ Partial |
| **dispatching-parallel-agents** | `/spec-work-all` (Wave System) | ✅ Covered |
| **using-git-worktrees** | `/spec-work-all` (Worktree Isolation) | ✅ Covered |
| **finishing-a-development-branch** | Nicht vorhanden | ❌ Missing |
| **requesting-code-review** | `/review` Command | ✅ Covered |
| **receiving-code-review** | Nicht vorhanden | ❌ Missing |
| **verification-before-completion** | CLAUDE.md Verification Section | ⚠️ Partial |
| **using-superpowers** (Meta) | Nicht noetig (wir haben Skill-First Rule) | ✅ Covered |
| **writing-skills** | Nicht vorhanden | ❌ Missing |

### Agents

| Superpowers | Unser Equivalent | Status |
|-------------|-----------------|--------|
| code-reviewer | `code-reviewer.md` Agent | ✅ Covered |
| (spec-reviewer subagent prompt) | `spec-review` Command | ✅ Covered |
| (implementer subagent prompt) | `spec-work` Command | ✅ Covered |

### Hooks

| Superpowers | Unser Equivalent | Status |
|-------------|-----------------|--------|
| session-start (Skill-Loading) | SessionStart Hook (Update-Check) | ⚠️ Different purpose |

---

## Kandidaten fuer Adaption

### 1. ❌ NEW: Finishing-a-Development-Branch Skill

**Was es macht**: Strukturierter Workflow nach Implementation: Tests verifizieren → 4 Optionen praesentieren (Merge / PR / Keep / Discard) → Worktree Cleanup.

**Unsere Luecke**: Nach `/spec-work` endet der Workflow abrupt. Es gibt kein standardisiertes "Was jetzt?" Gate.

**Aufwand**: Klein (neue Regel oder Command, ~30 Zeilen)

**Empfehlung**: ★★★★☆ — Sinnvoll als Post-Spec-Work Gate. Koennte als Erweiterung von `/spec-review` oder als eigenes `/finish` Command implementiert werden.

### 2. ❌ NEW: Receiving-Code-Review Skill

**Was es macht**: Definiert wie Agent auf Code Review Feedback reagieren soll. Kernpunkte:
- Keine performative Zustimmung ("You're absolutely right!")
- Technische Verifikation VOR Implementierung
- YAGNI-Check fuer vorgeschlagene Features
- Pushback mit technischer Begruendung wenn Reviewer falsch liegt
- Prioritaetsreihenfolge: Blocking → Simple → Complex

**Unsere Luecke**: Wir haben `/review` zum Erstellen von Reviews, aber keine Anleitung wie der Agent auf empfangenes Feedback reagieren soll.

**Aufwand**: Klein (neue Rule, ~40 Zeilen)

**Empfehlung**: ★★★★★ — Extrem wertvoll. Verhindert sycophantic Behavior und erzwingt technische Rigorositaet. Koennte direkt als `.claude/rules/code-review-reception.md` adaptiert werden.

### 3. ⚠️ PARTIAL: Verification-Before-Completion (Upgrade)

**Was es macht**: "Iron Law" — keine Completion-Claims ohne frische Verifikation. Konkrete Gate-Function mit 5 Steps. Rationalisierungs-Prevention-Tabelle.

**Unsere Luecke**: Wir haben in CLAUDE.md eine Verification Section, aber:
- SP hat explizite "Forbidden Phrases" ("should work", "probably passes")
- SP hat Rationalisierungs-Tabelle gegen Ausreden
- SP betont: "Agent reports success" ist NICHT ausreichend — unabhaengig verifizieren

**Spezifische Zeilen zum Adaptieren**:
```
"Claiming work is complete without verification is dishonesty, not efficiency."
"If you haven't run the verification command in this message, you cannot claim it passes."
"Trusting agent success reports" → Red Flag
```

**Aufwand**: Minimal (erweitere bestehende CLAUDE.md Section)

**Empfehlung**: ★★★★★ — Direkt uebernehmbar. Unsere Verification-Section ist zu mild formuliert.

### 4. ⚠️ PARTIAL: Systematic-Debugging (Upgrade fuer /debug)

**Was es macht**: 4-Phasen System (Root Cause → Pattern Analysis → Hypothesis → Implementation). Highlights:
- "3+ Fixes Failed = Question Architecture" Eskalationsregel
- Multi-Component Evidence Gathering (Logging an jeder Schicht-Grenze)
- Supporting Techniques als separate Files (root-cause-tracing, defense-in-depth, condition-based-waiting)

**Unsere Luecke**: Unser `/debug` Command ist weniger strukturiert. SP hat:
- Explizite Phase-Gates ("if you haven't completed Phase 1, you cannot propose fixes")
- "3+ Fix Attempts → Architectural Discussion" Eskalation
- Multi-Component Instrumentation Pattern

**Spezifische Zeilen zum Adaptieren**:
```
"If you catch yourself thinking 'Quick fix for now, investigate later' → STOP"
"3+ fixes failed: Question architecture, don't attempt Fix #4 without discussion"
"Add diagnostic instrumentation at EACH component boundary BEFORE proposing fixes"
```

**Aufwand**: Mittel (Debug-Command ueberarbeiten)

**Empfehlung**: ★★★★☆ — Die Eskalationsregel und Phase-Gates sind starke Ergaenzungen.

### 5. ⚠️ PARTIAL: Test-Driven-Development (Upgrade fuer testing.md)

**Was es macht**: Kompromissloser TDD mit "Iron Law" und Rationalisierungs-Prevention.

**Unsere Luecke**: Unsere `testing.md` Rule definiert Prinzipien, aber SP geht weiter:
- "Write code before test? Delete it. Start over." — Konsequenzen-Mechanik
- Konkrete Good/Bad Code-Beispiele mit Erklaerung
- "Rationalisierungs-Tabelle" gegen 11 haeufige Ausreden
- Red-Green-Refactor als visueller Flowchart

**Aufwand**: Klein (testing.md erweitern)

**Empfehlung**: ★★★☆☆ — Die Rationalisierungs-Tabelle ist wertvoll. Der Rest haengt davon ab, ob wir strikt TDD durchsetzen wollen (nicht alle Projekte brauchen das).

### 6. ⚠️ PARTIAL: Subagent-Driven-Development (Two-Stage Review)

**Was es macht**: Pro Task: Implementer Subagent → Spec Compliance Review → Code Quality Review. Zwei getrennte Review-Stufen.

**Unsere Luecke**: Unser `/spec-work` hat einen einzelnen Review-Step. SP trennt:
1. Spec Compliance ("Tut es was die Spec sagt?")
2. Code Quality ("Ist es gut gebaut?")

Zusaetzlich: Model Selection per Task-Komplexitaet (cheap → standard → capable).

**Spezifische Zeilen zum Adaptieren**:
```
"Two-stage review: spec compliance first, then code quality"
"Start code quality review BEFORE spec compliance is ✅ = wrong order"
"Mechanical implementation tasks: use a fast, cheap model"
```

**Aufwand**: Mittel (spec-work Command ueberarbeiten)

**Empfehlung**: ★★★☆☆ — Two-Stage Review ist elegant, aber erhoeht Token-Kosten signifikant.

### 7. ❌ NEW: Writing-Skills Meta-Skill

**Was es macht**: TDD-basierte Skill-Erstellung. Test = Pressure-Scenario mit Subagent. Includes CSO (Claude Search Optimization) fuer Skill-Discovery.

**Unsere Luecke**: Wir haben kein dokumentiertes Verfahren fuer Skill-Erstellung. Die CSO-Insights sind besonders wertvoll:
- Description darf NICHT den Workflow zusammenfassen (sonst ueberspringt Claude den Body)
- "Use when..." Format fuer Trigger-Conditions
- Token-Budgets pro Skill-Typ

**Aufwand**: Klein (neues Dokument, ~50 Zeilen)

**Empfehlung**: ★★★☆☆ — Nischig, aber die CSO-Insights sind Gold wert fuer jeden der Skills schreibt.

---

## Einzelne Saetze/Patterns zum Adaptieren

Auch aus "Covered" Items gibt es spezifische Formulierungen die unsere bestehenden Files verbessern:

### Fuer CLAUDE.md / Verification Section
1. `"Claiming work is complete without verification is dishonesty, not efficiency."`
2. `"If you haven't run the verification command in this message, you cannot claim it passes."`
3. `"Using 'should', 'probably', 'seems to' → Red Flag"`

### Fuer testing.md Rule
4. `"Write code before test? Delete it. Start over."`
5. `"Tests written after code pass immediately. Passing immediately proves nothing."`

### Fuer agents.md Rule
6. `"They should never inherit your session's context or history — you construct exactly what they need."`
7. `"Use the least powerful model that can handle each role to conserve cost and increase speed."`

### Fuer /debug Command
8. `"If you catch yourself thinking 'Quick fix for now' → STOP. Return to Phase 1."`
9. `"3+ fixes failed: Question the architecture, don't attempt Fix #4 without discussion."`

### Fuer /review Command
10. `"Technical correctness over social comfort." (anti-sycophancy)`

---

## Architektur-Patterns

### 1. Skill-basierte Architektur vs. Command-basierte

SP organisiert Logik als "Skills" (auto-triggernd via Description Matching), wir als "Commands" (explizit via `/command`). Beide Ansaetze haben Vor-/Nachteile:

| Aspekt | SP Skills | Unsere Commands |
|--------|----------|-----------------|
| Trigger | Auto (Description Match) | Explizit (`/command`) |
| Kontrolle | Weniger (Agent entscheidet) | Mehr (User entscheidet) |
| Discovery | Besser (Agent findet passenden Skill) | Schlechter (User muss `/command` kennen) |
| Token-Kosten | Hoeher (Description in jedem Context) | Niedriger (nur bei Aufruf) |

**Bewertung**: Unsere Command-Architektur ist fuer einen Power-User besser geeignet. SPs Skill-Auto-Trigger macht Sinn fuer Anfaenger.

### 2. Two-Stage Review Pattern

SP trennt konsequent: Spec Compliance Review → Code Quality Review. Das ist ein starkes Pattern das verhindert, dass Code-Quality-Issues die Spec-Compliance-Pruefung ueberlagern.

**Empfehlung**: Adaptierbar als optionaler Modus in `/spec-work`.

### 3. Subagent Context Isolation

SP betont: "Never inherit session context/history — construct exactly what they need." Das ist ein fundamentales Prinzip das wir in `agents.md` staerker betonen sollten.

### 4. Eskalations-Mechanik

SP hat klare Eskalations-Regeln:
- 3+ Fix-Versuche → Architektur-Diskussion
- Spec Review Loop > 3 Iterationen → Human Escalation
- Implementer BLOCKED → Model Upgrade oder Task Split

**Empfehlung**: Adaptierbar als generelles Pattern in CLAUDE.md oder agents.md.

---

## Gesamtranking nach Aufwand/Nutzen

| # | Item | Value | Aufwand | Empfehlung |
|---|------|-------|---------|------------|
| 1 | Receiving-Code-Review Rule | ★★★★★ | Klein | **Sofort umsetzen** — Anti-Sycophancy + technische Rigorositaet |
| 2 | Verification Upgrade | ★★★★★ | Minimal | **Sofort umsetzen** — Iron Law + Forbidden Phrases |
| 3 | Finishing-Branch Workflow | ★★★★☆ | Klein | **Spec erstellen** — Post-Implementation Gate |
| 4 | Systematic-Debugging Upgrade | ★★★★☆ | Mittel | **Spec erstellen** — Phase-Gates + 3-Fix Eskalation |
| 5 | TDD Rationalisierungs-Tabelle | ★★★☆☆ | Klein | **Optional** — nur wenn strikt TDD gewuenscht |
| 6 | Two-Stage Review in spec-work | ★★★☆☆ | Mittel | **Optional** — Token-Kosten-Erhoehung bedenken |
| 7 | Writing-Skills Meta-Dokument | ★★★☆☆ | Klein | **Optional** — CSO-Insights extrahieren |
| 8 | Subagent Context Isolation Rule | ★★★★☆ | Minimal | **Sofort umsetzen** — 1 Satz in agents.md |

---

## Token-Economics

| Adaption | Token-Impact |
|----------|-------------|
| Rules hinzufuegen (Code-Review, Verification) | +200-400 Tokens/Session (immer geladen) |
| Debug-Command erweitern | +0 (nur bei Aufruf) |
| spec-work Two-Stage Review | +50-100% Token-Kosten pro Spec-Step (2 Reviews statt 1) |
| Finishing-Branch Command | +0 (nur bei Aufruf) |

**Gesamtbewertung**: Die "Sofort umsetzen" Items kosten ~400 Tokens/Session extra bei signifikantem Qualitaetsgewinn. Akzeptabel.

---

## Nicht uebernehmen

| Item | Grund |
|------|-------|
| Auto-Trigger Skills | Unsere explizite Command-Architektur ist besser fuer Power-User |
| Visual Companion (Browser Mockups) | Wir haben agent-browser, braeuchten eigenes System |
| Graphviz Flowcharts in Skills | Nuetzlich aber Overhead, Markdown reicht |
| using-superpowers Meta-Skill | Wir haben Skill-First Rule in general.md |
| SP Plugin/Marketplace System | Wir haben eigenes Plugin-System via lib/plugins.sh |
