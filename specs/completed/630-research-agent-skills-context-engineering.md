# Brainstorm: muratcankoylan/Agent-Skills-for-Context-Engineering Adaptionen
> Source: https://github.com/muratcankoylan/agent-skills-for-context-engineering | Date: 2026-04-13
> **Status**: completed

## Repo-Übersicht

13 SKILL.md-Dateien für Claude Code / Cursor / Open Plugins. Fokus: Theorie und Prinzipien
des Context Engineering, NICHT operative Automatisierung. Plug-in-Manifest für `/plugin marketplace`.
Zitiert in akademischer Forschung (Peking University, 2026).

## Bestandsvergleich

### EXTERNAL: 13 skills

| Skill | Kategorie | Unser Äquivalent | Status |
|-------|-----------|-----------------|--------|
| `context-fundamentals` | Foundational | — | ❌ Missing |
| `context-degradation` | Foundational | quality.md (Debugging-Section) | ⚠️ Partial |
| `context-compression` | Foundational | precompact-guidance.sh (Hook) | ⚠️ Partial |
| `multi-agent-patterns` | Architectural | agents.md (Rules) | ⚠️ Partial |
| `memory-systems` | Architectural | claude-mem Plugin | ⚠️ Partial |
| `tool-design` | Architectural | — | ❌ Missing |
| `filesystem-context` | Architectural | workflow.md (Hints) | ⚠️ Partial |
| `hosted-agents` | Architectural | — | ❌ Missing |
| `context-optimization` | Operational | token-optimizer Skill | ⚠️ Partial |
| `evaluation` | Operational | — | ❌ Missing |
| `advanced-evaluation` | Operational | — | ❌ Missing |
| `project-development` | Methodology | spec Workflow | ⚠️ Partial |
| `bdi-mental-states` | Cognitive | — | ❌ Missing |

**EXTERNAL:** 13 skills (0 vollständig covered, 7 partial, 6 fehlend)
**OURS:** ~30 skills (operativ: commit, test, lint, review, spec, debug, scan, analyze, etc.)

### Systematischer Gap

**Unser Fokus:** Operative Automatisierung — CI, Qualitätsgates, Commit-Workflow, Spec-Pipeline.
**Ihr Fokus:** Konzeptuelles Wissen — Context Engineering Theorie, Memory-Architekturen, Evaluation-Frameworks.

Das ist ein **orthogonaler** Ansatz, kein Wettbewerb.

## Kandidaten für Adaption

### 1. context-fundamentals — SKILL.md als Referenz-Skill

**Gap:** Wir haben nirgends erklärt, WIE Claude Code selbst seinen Kontext effizient nutzen soll.
Unser token-optimizer Skill optimiert den Setup, aber nicht das In-Session-Verhalten.

**Kern-Zitat aus ihrem Skill:**
> "Treat context as a finite attention budget, not a storage bin. Every token added competes for
> the model's attention... U-shaped attention curve that penalizes information placed in the middle."
> "Place critical constraints at the beginning and end of context, where recall accuracy runs 85-95%"

**Was wir adaptieren könnten:** CLAUDE.md-Strukturierungsregel — kritische Regeln immer OBEN und UNTEN.
Aufwand: Klein. Wert: Hoch (direkt auf unsere Kernaufgabe — CLAUDE.md Qualität — anwendbar).

**Empfehlung:** GO — aber als Ergänzung zu token-optimizer, nicht als eigenständiger Skill.

---

### 2. context-compression — PreCompact-Hook-Verbesserung

**Gap:** Unser precompact-guidance.sh gibt Claude generische Hinweise vor AutoCompact.
Ihr Skill erklärt 3 Produktions-Compression-Strategien:
- **Anchored Iterative Summarization** (für file-tracking Sessions)
- **Opaque Compression** (max Savings, kein Debugging)
- **Regenerative Full Summary** (lesbar, aber kumulative Verluste)

**Kern-Zitat:**
> "Maintain structured, persistent summaries with explicit sections for session intent, file
> modifications, decisions, and next steps. When compression triggers, summarize only the
> newly-truncated span and merge with the existing summary rather than regenerating from scratch."

**Was wir adaptieren könnten:** precompact-guidance.sh um strukturierte Summary-Vorlage erweitern.
Aufwand: Klein. Wert: Mittel (verbessert bestehenden Hook direkt).

**Empfehlung:** GO — konkrete Vorlage in Hook-Output einbauen.

---

### 3. filesystem-context — Context-Offloading Pattern für unsere Skills

**Gap:** Unsere Skills geben Claude keinen expliziten Hinweis, Tool-Outputs in Dateien auszulagern.
RTK macht das implizit (via persisted-output), aber kein Skill erklärt das Muster.

**Kern-Zitat:**
> "Prefer dynamic context discovery -- pulling relevant context on demand -- over static inclusion,
> because static context consumes tokens regardless of relevance."
> "Diagnose context failures: Missing | Under-retrieved | Over-retrieved | Buried"

**Was wir adaptieren könnten:** Regel in agents.md oder quality.md: Sub-Agent-Outputs >2KB
immer in Datei schreiben, Pfad zurückgeben.
Aufwand: Klein (eine Zeile in agents.md). Wert: Hoch (direkte Token-Ersparnis).

**Empfehlung:** GO — in agents.md als Delegation-Regel.

---

### 4. multi-agent-patterns — Model-Routing Rules verfeinern

**Gap:** Unsere agents.md hat Model-Routing-Tabelle (Haiku/Sonnet/Opus), aber keine
Entscheidungslogik für Pattern-Auswahl (Supervisor vs. Peer-to-peer vs. Hierarchical).

**Kern-Zitat:**
> "Choose among three dominant patterns based on coordination needs, not organizational metaphor"
> "Sub-agents exist primarily to isolate context, not to anthropomorphize role division."
> "Context isolation is the primary benefit — each agent operates in a clean context without
> accumulated noise from other subtasks."

**Was wir adaptieren könnten:** agents.md-Erweiterung: Wann welches Pattern? 1-2 Zeilen Entscheidungsregel.
Aufwand: Klein. Wert: Mittel.

**Empfehlung:** PIVOT — Kerngedanke ("isolate context, not anthropomorphize") in bestehende
agents.md-Dokumentation einbauen. Kein eigener Skill nötig.

---

### 5. context-optimization — KV-Cache Optimierung

**Gap:** token-optimizer Skill kennt KV-Cache nicht. Skill fokussiert auf Setup-Dateien, nicht
auf Inference-Optimierung.

**Kern-Zitat:**
> "Reorder and stabilize prompt structure so the inference engine reuses cached Key/Value tensors.
> This is the cheapest optimization: zero quality risk, immediate cost and latency savings."
> "Apply it first and unconditionally."

**Was wir adaptieren könnten:** KV-Cache-Sektion in token-optimizer SKILL.md: System-Prompt-Stabilität
= statische Teile zuerst, dynamische zuletzt.
Aufwand: Klein. Wert: Mittel (nur für API-Nutzer relevant, nicht Claude Code CLI).

**Empfehlung:** SKIP für CLI-Kontext. Relevant nur für eigene API-Apps (Alpensattel MCP etc.).
Note für API-Skill: claude-api.md könnte davon profitieren.

---

### 6. evaluation / advanced-evaluation — Eval-Framework für unsere Skills

**Gap:** Wir haben skill-creator-workspace mit Evals (evals.json, grading.json), aber kein
standardisiertes Eval-Framework als Skill.

**Kern-Zitat aus evaluation:**
> "Focus evaluation on outcomes rather than execution paths"
> "Use multi-dimensional rubrics instead of single scores"
> "'Performance Drivers: The 95% Finding' — context window size, system prompt clarity,
> tool description quality account for 95% of performance variance"

**Was wir adaptieren könnten:** Standardisiertes Eval-Template für neue Skills in
skill-creator-workspace. Die 3-Eval-Struktur (without/with skill) haben wir schon — aber
kein formales Rubrik-System.
Aufwand: Mittel. Wert: Hoch (verbessert Skill-Qualität systematisch).

**Empfehlung:** GO — aber als Erweiterung des bestehenden skill-creator-workspace, nicht
als separater User-Skill.

---

### 7. hosted-agents — SKIP

**Gap:** Komplett fehlend, aber irrelevant für unser Projekt.
Wir bauen kein Remote-Sandbox-Infrastruktur — das ist für Teams die Claude-as-a-Service bauen.

**Empfehlung:** SKIP — outside scope.

---

### 8. bdi-mental-states — SKIP

**Gap:** BDI-Ontologie für RDF-Context. Sehr akademisch, kein praktischer Nutzen für
Agentur-/E-Commerce-Workloads.

**Empfehlung:** SKIP — akademisches Pattern, kein Mehrwert für npx-ai-setup.

---

### 9. tool-design — Interessantes Prinzip

**Kern-Zitat:**
> "Design every tool as a contract between a deterministic system and a non-deterministic agent."
> "If a human engineer cannot definitively say which tool should be used in a given situation,
> an agent cannot be expected to do better."
> "Write descriptions that answer what the tool does, when to use it, and what it returns"

**Was wir adaptieren könnten:** Skill-Design-Guideline für SKILL.md-Erstellung. Unsere Skills
haben trigger conditions — aber keine explizite "tool contract" Struktur.
Aufwand: Klein. Wert: Mittel.

**Empfehlung:** PIVOT — als Teil des skill-creator-workspace Workflow, nicht als User-Skill.

---

### 10. memory-systems — claude-mem Integration

**Gap:** claude-mem Plugin deckt das ab. Ihr Skill erklärt Memory-Framework-Vergleich
(Mem0, Zep/Graphiti, Letta, LangMem, Cognee) und Benchmarks (LoCoMo, LongMemEval).

**Kern-Zitat:**
> "Benchmark evidence shows tool complexity matters less than reliable retrieval —
> Letta's filesystem agents scored 74% on LoCoMo using basic file operations,
> beating Mem0's specialized tools at 68.5%."

**Was wir adaptieren könnten:** Nichts — claude-mem ist unsere Memory-Lösung und funktioniert.
**Empfehlung:** SKIP — bereits solved.

---

### 11. project-development — task-model fit

**Kern-Zitat:**
> "Evaluate task-model fit before writing any code, because building automation on a
> fundamentally mismatched task wastes days of effort."

**Was wir adaptieren könnten:** challenge-Skill hat bereits "Scope-Check" — aber kein
formales Task-Model-Fit-Raster. Könnte in explore oder challenge eingebaut werden.
Aufwand: Klein. Wert: Mittel.

**Empfehlung:** PIVOT — 2-3 Zeilen in challenge/SKILL.md als Checkliste.

---

## Progressive Disclosure Pattern (strukturelles Learning)

**Das interessanteste Muster** des Repos ist nicht der Inhalt einzelner Skills, sondern
die Architektur:

> "At startup, agents load only skill names and descriptions. Full content loads only when
> a skill is activated for relevant tasks."

Das macht Claude Code Plugins bereits nativ — aber ihr `.plugin/plugin.json` Manifest
formalisiert es für den Marketplace. Interessant für unsere Plugin-Distribution-Strategie:
Unser npx-ai-setup könnte als `/plugin install` Package registriert werden.

**Empfehlung:** PIVOT — als separate Recherche-Initiative für Plugin-Distribution-Kanal.

---

## Ranking nach Aufwand/Nutzen

| Item | Wert ★ | Aufwand | Empfehlung | Target |
|------|--------|---------|-----------|--------|
| Filesystem context → agents.md Regel | ★★★★★ | XS (1 Zeile) | GO | agents.md |
| context-compression → precompact Hook | ★★★★ | S (5-10 Zeilen) | GO | precompact-guidance.sh |
| context-fundamentals → CLAUDE.md Position-Regel | ★★★★ | S (2-3 Zeilen) | GO | global CLAUDE.md |
| eval-framework → skill-creator-workspace | ★★★ | M (neues Template) | GO | skill-creator-workspace |
| multi-agent "isolate context" → agents.md | ★★★ | XS (1-2 Sätze) | PIVOT | agents.md |
| tool-design contract → skill-creator workflow | ★★★ | S | PIVOT | skill-creator-workspace |
| task-model-fit → challenge Skill | ★★ | XS | PIVOT | challenge/SKILL.md |
| context-optimization KV-Cache → claude-api | ★★ | S | SKIP/API-only | claude-api.md |
| hosted-agents | ★ | XL | SKIP | — |
| bdi-mental-states | ★ | L | SKIP | — |
| memory-systems | ★★ | — | SKIP (solved) | — |
