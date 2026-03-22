# Brainstorm: agency-agents Adaptionen fuer npx-ai-setup

> **Source**: https://github.com/msitarzewski/agency-agents
> **Erstellt**: 2026-03-22
> **Zweck**: Evaluierung welche Patterns aus der 170+ Agent-Bibliothek adaptierbar sind

---

## Was ist agency-agents?

Eine Open-Source-Bibliothek (MIT) mit 170+ spezialisierten AI-Agent-Personas ueber 16 Business-Bereiche. Multi-Tool-kompatibel (Claude Code, Copilot, Cursor, Aider, Windsurf). Jeder Agent hat:
- YAML Frontmatter (name, description, color, emoji, vibe)
- Strukturierte Sektionen: Identity, Core Mission, Critical Rules, Technical Deliverables, Workflow, Communication Style
- Durchschnittlich 80-150 Zeilen pro Agent

Dazu: NEXUS-Orchestrierungssystem (Phase 0-6), Workflow-Beispiele, Runbooks, Install/Convert/Lint-Scripts.

---

## Bestandsvergleich: Was haben wir schon?

### Agents (Unsere 12 vs. ihre 170+)

| Bereich | Ihre Agents | Unser Aequivalent | Status |
|---------|-------------|-------------------|--------|
| Code Review | engineering-code-reviewer | code-reviewer.md | ✅ Covered — unserer ist Claude-Code-optimiert mit Diff-Analyse + Spec-Check |
| Frontend Dev | engineering-frontend-developer | frontend-developer.md | ⚠️ Partial — ihrer hat detailliertere Deliverable-Templates |
| Architecture | engineering-software-architect | code-architect.md | ⚠️ Partial — ihrer hat ADR-Template + Architektur-Selektions-Matrix |
| Security | engineering-security-engineer + threat-detection-engineer | security-reviewer.md | ✅ Covered — unserer ist OWASP-fokussiert und praxisnaher |
| Performance | testing-performance-benchmarker | perf-reviewer.md | ✅ Covered |
| Testing | testing-reality-checker + testing-evidence-collector | verify-app.md | ⚠️ Partial — "Reality Checker" Pattern (default NEEDS WORK) ist stark |
| Build | (kein Aequivalent) | build-validator.md | ✅ Besser — wir haben einen dedizierten Build-Validator |
| Liquid | (kein Aequivalent) | liquid-linter.md | ✅ Besser — Shopify-spezifisch, sie haben nichts |
| Staff Review | (kein Aequivalent) | staff-reviewer.md | ✅ Besser — skeptischer Staff-Engineer-Review |
| Test Gen | (kein Aequivalent) | test-generator.md | ✅ Besser — Framework-Erkennung + Test-Generierung |
| Context | (kein Aequivalent) | context-refresher.md | ✅ Besser — automatische Context-Regenerierung |
| Project Audit | (kein Aequivalent) | project-auditor.md | ✅ Besser — Codebase-Onboarding |
| DevOps | engineering-devops-automator | ❌ Missing | Fehlt bei uns |
| MCP Builder | specialized-mcp-builder | ❌ Missing | Fehlt bei uns |
| Workflow Architect | specialized-workflow-architect | ❌ Missing | Fehlt bei uns |
| Agents Orchestrator | specialized/agents-orchestrator | ❌ Missing | Spec-work-all ist aehnlich, aber kein Agent |
| Technical Writer | engineering-technical-writer | ❌ Missing | Fehlt bei uns |
| Git Workflow | engineering-git-workflow-master | ❌ Missing | Wir haben Rules, keinen Agent |
| SEO Specialist | marketing-seo-specialist | ❌ Missing | Wir haben Skills (seo-audit, ai-seo), keine Agents |
| Incident Response | engineering-incident-response-commander | ❌ Missing | Fehlt komplett |

### Nicht-Engineering Agents (Marketing, Sales, Design, etc.)

Ihre Marketing-Agents (27), Sales (8), Design (8), Product (5), PM (6), Support (6) — diese sind **ausserhalb unseres Scopes**. npx-ai-setup ist ein Developer-Tool, keine Agentur-Management-Suite.

### Strategy / NEXUS System

| Ihr Feature | Unser Aequivalent | Status |
|-------------|-------------------|--------|
| NEXUS Pipeline (Phase 0-6) | spec-work-all (parallele Spec-Waves) | ⚠️ Partial — anderes Konzept |
| Workflow Examples | Spec-System + Commands | ⚠️ Partial |
| Handoff Templates | (nichts) | ❌ Missing |
| Playbooks (Phase-spezifisch) | (nichts) | ❌ Missing |
| Runbooks (Szenario-basiert) | (nichts) | ❌ Missing |
| Lint Script fuer Agents | (nichts) | ❌ Missing |

### Scripts / Tooling

| Ihr Feature | Unser Aequivalent | Status |
|-------------|-------------------|--------|
| install.sh (Multi-Tool) | bin/ai-setup.sh (Claude-only) | ⚠️ Anders — wir sind Claude-fokussiert |
| convert.sh (Multi-Format) | (nicht noetig) | N/A |
| lint-agents.sh | (nichts) | ❌ Missing — waere nuetzlich |

---

## Kandidaten fuer Adaption

### Prio 1: Hoher Wert, Niedriger Aufwand

#### 1. Agent-Frontmatter-Standard (YAML)
**Was**: Einheitliches YAML-Frontmatter fuer alle Agent-Dateien (name, description, model, emoji, tools)
**Unser Gap**: Unsere Agents haben heterogene Header. Kein maschinenlesbares Format.
**Aufwand**: Klein — nur Frontmatter zu bestehenden Agents hinzufuegen
**Empfehlung**: ✅ Adaptieren — ermoeglicht spaeter automatische Agent-Discovery

#### 2. "Reality Checker" Pattern (Default-NEEDS-WORK)
**Was**: QA-Agent der standardmaessig "NEEDS WORK" sagt und ueberwiegende Beweise fuer Production-Readiness verlangt
**Unser Gap**: verify-app.md ist neutral, nicht skeptisch. staff-reviewer.md ist skeptisch, aber kein QA-Agent.
**Aufwand**: Klein — 1-2 Saetze in verify-app.md ergaenzen
**Empfehlung**: ✅ Adaptieren — Zeile "Default to NEEDS WORK — require overwhelming evidence for production readiness" in verify-app.md

#### 3. ADR-Template im Code-Architect
**Was**: Architecture Decision Record Template direkt im Architect-Agent
**Unser Gap**: code-architect.md hat kein ADR-Template
**Aufwand**: Klein — Template-Block ergaenzen
**Empfehlung**: ✅ Adaptieren — ADR-Template ist ein konkreter Deliverable

#### 4. Agent-Lint-Script
**Was**: Validiert Agent-Markdown-Dateien (Frontmatter vorhanden, Pflicht-Sektionen, Mindest-Inhalt)
**Unser Gap**: Keine Validierung fuer unsere Agent-Dateien
**Aufwand**: Mittel — Bash-Script ~50 Zeilen
**Empfehlung**: ✅ Adaptieren — verhindert kaputte Agent-Dateien bei Contributions

### Prio 2: Mittlerer Wert, Mittlerer Aufwand

#### 5. Architektur-Selektions-Matrix
**Was**: Tabelle "Pattern | Use When | Avoid When" im Software-Architect
**Unser Gap**: code-architect.md hat keine Entscheidungshilfe fuer Architektur-Patterns
**Aufwand**: Klein — Tabelle ergaenzen
**Empfehlung**: ✅ Adaptieren

#### 6. MCP-Builder Agent
**Was**: Spezialist fuer MCP-Server-Entwicklung mit TypeScript/Zod-Skeleton
**Unser Gap**: Kein Agent fuer MCP-Entwicklung, obwohl wir selbst MCP-Server nutzen
**Aufwand**: Mittel — neuer Agent ~60 Zeilen
**Empfehlung**: ⚠️ Evaluieren — nuetzlich, aber Nischen-Usecase

#### 7. Workflow-Beispiele als Agent-Aktivierungs-Templates
**Was**: Copy-paste-faehige Prompts die mehrere Agents orchestrieren (Landing Page Sprint, MVP Workflow)
**Unser Gap**: Wir haben Commands, aber keine vorgefertigten Multi-Agent-Workflows
**Aufwand**: Mittel — 2-3 Template-Dateien
**Empfehlung**: ⚠️ Evaluieren — interessant fuer Onboarding, aber Token-Overhead

### Prio 3: Niedriger Wert oder Hoher Aufwand

#### 8. NEXUS Pipeline-System (Phase 0-6)
**Was**: Komplettes Orchestrierungs-Framework mit Playbooks, Runbooks, Handoffs
**Unser Gap**: spec-work-all deckt Build-Phase ab, aber keine Discovery/Strategy/Launch-Phasen
**Aufwand**: Hoch — 10+ Dateien, neues Konzept
**Empfehlung**: ❌ Nicht adaptieren — ueberdimensioniert fuer unser Tool. Unser Spec-System ist fokussierter.

#### 9. Non-Engineering Agents (Marketing, Sales, Design)
**Was**: 80+ Agents fuer Marketing, Sales, Product, Support
**Unser Gap**: Komplett fehlend
**Aufwand**: Hoch — und ausserhalb unseres Core-Scopes
**Empfehlung**: ❌ Nicht adaptieren — wir sind Developer-Tool, nicht Agentur-Suite

#### 10. Multi-Tool-Support (Cursor, Copilot, Windsurf)
**Was**: convert.sh generiert Agent-Dateien fuer 10 verschiedene Tools
**Unser Gap**: Wir sind Claude-Code-only
**Aufwand**: Hoch — fundamentaler Architektur-Shift
**Empfehlung**: ❌ Nicht adaptieren — Claude-Code-Fokus ist Staerke, nicht Schwaeche

---

## Einzelne Saetze/Patterns zum Adaptieren

Auch aus "Already Covered" Items gibt es einzelne Zeilen die wertvoll sind:

### Aus engineering-code-reviewer:
> "One review, complete feedback — Don't drip-feed comments across rounds"

Gut fuer unseren code-reviewer.md — explizites Single-Pass-Prinzip.

### Aus engineering-software-architect:
> "No architecture astronautics — Every abstraction must justify its complexity"
> "Reversibility matters — Prefer decisions that are easy to change over ones that are optimal"

Beide Prinzipien fehlen explizit in unserem code-architect.md.

### Aus testing-reality-checker:
> "First implementations typically need 2-3 revision cycles. C+/B- ratings are normal and acceptable."

Realistische Erwartungssteuerung — fehlt in unserem verify-app.md.

### Aus specialized-workflow-architect:
> "A workflow that exists in code but not in a spec is a liability"

Gut fuer unser Spec-System als Motivation.

### Aus agents-orchestrator:
> "Maximum 3 retry attempts per task. Each retry includes specific QA feedback."

Retry-Limit mit Feedback — fehlt in spec-work-all.

### Agent-Frontmatter "vibe" Feld:
> z.B. `vibe: Reviews code like a mentor, not a gatekeeper`

Einzeilige Persoenlichkeits-Zusammenfassung — effektiv fuer Agent-Verhalten.

---

## Architektur-Patterns

### 1. Strukturierte Agent-Dateien mit YAML Frontmatter
**Ihr Pattern**: Jeder Agent hat `---` YAML-Block mit maschinenlesbaren Feldern
**Unser Pattern**: Freitext-Markdown ohne Standard-Struktur
**Wert**: Ermoeglicht automatische Discovery, Katalogisierung, Validierung
**Aufwand**: Niedrig — Frontmatter zu bestehenden Dateien hinzufuegen

### 2. Persona + Deliverables Separation
**Ihr Pattern**: Identity/Mission/Rules definieren WER, Deliverables definieren WAS
**Unser Pattern**: Verhaltensregeln + Tool-Integration vermischt
**Wert**: Klarere Agent-Dateien, einfacher zu erweitern
**Bewertung**: Interessant, aber unser Format ist kompakter und token-effizienter

### 3. Dev-QA-Loop mit Retry-Limit
**Ihr Pattern**: Task → Dev → QA → PASS/FAIL → Retry (max 3) → Escalate
**Unser Pattern**: spec-work-all fuehrt Specs aus, aber ohne QA-Loop
**Wert**: Qualitaets-Gate nach jedem Task
**Aufwand**: Hoch — fundamentale Aenderung an spec-work-all

### 4. Agent Lint (CI-Gate)
**Ihr Pattern**: lint-agents.sh prueft Frontmatter, Pflichtsektionen, Mindestlaenge
**Unser Pattern**: Keine Validierung
**Wert**: Verhindert kaputte Agent-Dateien
**Aufwand**: Niedrig — ~50 Zeilen Bash

---

## Gesamtranking nach Aufwand/Nutzen

| # | Item | Wert | Aufwand | Empfehlung |
|---|------|------|---------|------------|
| 1 | Reality-Checker-Pattern in verify-app | ★★★★ | Niedrig | ✅ Sofort |
| 2 | ADR-Template in code-architect | ★★★★ | Niedrig | ✅ Sofort |
| 3 | Architektur-Selektions-Matrix | ★★★ | Niedrig | ✅ Sofort |
| 4 | Einzelne Saetze adoptieren (5 Zitate oben) | ★★★ | Niedrig | ✅ Sofort |
| 5 | Agent-Frontmatter YAML-Standard | ★★★★ | Mittel | ✅ Naechste Iteration |
| 6 | Agent-Lint-Script | ★★★ | Mittel | ✅ Naechste Iteration |
| 7 | MCP-Builder Agent | ★★ | Mittel | ⚠️ Optional |
| 8 | Workflow-Beispiel-Templates | ★★ | Mittel | ⚠️ Optional |
| 9 | NEXUS Pipeline | ★ | Hoch | ❌ Skip |
| 10 | Non-Engineering Agents | ★ | Hoch | ❌ Skip |
| 11 | Multi-Tool Support | ★ | Hoch | ❌ Skip |

---

## Token-Oekonomie

**Ihre Agent-Dateien**: 80-150 Zeilen pro Agent, reich an Code-Beispielen und Templates
**Unsere Agent-Dateien**: 45-120 Zeilen, fokussiert auf Verhalten und Tool-Integration

**Bewertung**: Unsere Agents sind token-effizienter weil:
1. Keine Code-Beispiele in Agent-Dateien (die generiert der Agent kontextuell)
2. When-to-Use / Avoid-If Sektionen sind praeziese (spart falsche Agent-Aktivierungen)
3. Model-Routing (haiku/sonnet/opus) spart massiv bei Agent-Spawning

**Risiko bei Adoption**: Wenn wir ihre detaillierteren Templates uebernehmen, steigt der Token-Verbrauch pro Agent-Datei um ~50%. Nur uebernehmen was tatsaechlich die Qualitaet verbessert.
