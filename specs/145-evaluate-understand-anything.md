# Brainstorm: Understand-Anything Adaptionen fuer npx-ai-setup

> **Source**: https://github.com/Lum1104/Understand-Anything
> **Erstellt**: 2026-03-22
> **Zweck**: Evaluierung welche Patterns aus dem Knowledge-Graph-Plugin adaptierbar sind
> **Status**: Complete

---

## Was ist Understand-Anything?

Ein Claude-Code-Plugin das Codebases in interaktive Knowledge Graphs umwandelt. Multi-Agent-Pipeline analysiert jede Datei, Funktion und Klasse und erzeugt einen durchsuchbaren Graph in `.understand-anything/knowledge-graph.json`.

**Stack**: TypeScript, pnpm Monorepo, React 19, Vite 6, TailwindCSS v4, tree-sitter (WASM), Fuse.js, Zod, React Flow, Zustand

**Kern-Features**:
- 7-Phasen-Analyse-Pipeline (Scan → Analyze → Assemble → Architecture → Tour → Review → Save)
- Inkrementelle Updates via Git-Commit-Hash-Vergleich
- Architektur-Layer-Erkennung (heuristisch + LLM)
- Guided Tours (topologisch sortiert via Kahns Algorithmus)
- Diff-Impact-Analyse mit Blast-Radius-Bewertung
- Fuzzy Search (Fuse.js) + Semantic Search
- React-Flow-Dashboard zur Visualisierung
- Multi-Platform: Claude Code, Codex, Cursor, OpenClaw, Antigravity

---

## Bestandsvergleich: Was haben wir schon?

### Inventar

```
UNDERSTAND-ANYTHING:  1 agent, 6 skills, 5 agent-prompts, 11 core modules
UNSER PROJEKT:       11 agents, 21 commands, 6 skills, 12 hooks, 9 rules
```

### Feature-Matching

| UA Feature | Unser Equivalent | Status |
|---|---|---|
| `/understand` (7-Phasen-Analyse) | `/analyze` (3 parallele Agents) | ⚠️ Partial — unser analyze ist breiter aber flacher |
| `/understand-chat` (Graph-basierte Q&A) | claude-mem MCP (search/get_observations) | ⚠️ Partial — anderer Ansatz (Memory vs. Graph) |
| `/understand-dashboard` (React Flow) | Kein UI-equivalent | ❌ Missing |
| `/understand-diff` (Impact-Analyse) | `/review` + code-reviewer Agent | ⚠️ Partial — kein Graph-basiertes Impact-Tracing |
| `/understand-explain` (Deep-Dive Module) | Explore-Agent (subagent_type=Explore) | ✅ Covered — unser Explore macht das gleiche |
| `/understand-onboard` (Onboarding-Guide) | `/discover` (reverse-engineers specs) | ⚠️ Partial — discover fokussiert auf Specs, nicht Onboarding |
| Knowledge Graph (JSON) | `.agents/context/` (STACK, ARCHITECTURE, CONVENTIONS) | ⚠️ Partial — unser System ist Text-basiert, nicht strukturiert |
| tree-sitter AST-Parsing | Kein equivalent | ❌ Missing |
| Inkrementelle Updates (Git-Hash) | context-freshness.sh Hook | ⚠️ Partial — unser Hook prueft Alter, nicht Inhalt |
| Layer-Erkennung | ARCHITECTURE.md (manuell/LLM) | ⚠️ Partial — keine automatische Erkennung |
| Guided Tours | Kein equivalent | ❌ Missing |
| Fuzzy Search | Grep/Glob Tools | ✅ Covered — native Tools reichen |
| Graph-Review/Validation | spec-validate, code-reviewer | ✅ Covered — anderer Scope aber Prinzip vorhanden |
| Multi-Platform Plugin Config | Kein equivalent (nur Claude Code) | ❌ Missing — aber irrelevant fuer uns |
| Diff Overlay (JSON) | Kein equivalent | ❌ Missing |
| Language Lessons (12 Patterns) | Kein equivalent | ❌ Missing — nischig |

---

## Kandidaten fuer Adaption

### 1. Strukturierter Knowledge Graph fuer Context-System

**Was es tut**: Statt Freitext-Markdown (ARCHITECTURE.md) ein maschinenlesbares JSON mit typisiertem Node/Edge-Schema. 5 Node-Typen, 18 Edge-Typen, Layer-Zuordnung.

**Unsere Luecke**: Unser `.agents/context/` ist menschenlesbar aber nicht abfragbar. Kein programmatischer Zugriff auf "welche Dateien haengen von X ab?"

**Aufwand**: Hoch — erfordert neuen Analyse-Skill, Schema-Definition, Persistierung
**Empfehlung**: ⚠️ Abwaegen — hoher Aufwand, aber fundamentaler Qualitaetssprung fuer Context-Qualitaet

### 2. Multi-Agent Analyse-Pipeline (7 Phasen)

**Was es tut**: Spezialisierte Agents fuer jede Phase — Scanner, File-Analyzer, Architecture-Analyzer, Tour-Builder, Graph-Reviewer. Jeder Agent hat einen eigenen Prompt mit exakten Constraints.

**Unsere Luecke**: Unser `/analyze` nutzt 3 generische parallele Agents. UA's Ansatz ist granularer mit Batch-Processing (5-10 Files pro Agent, bis zu 3 concurrent).

**Konkrete Verbesserung**: Die Batch-Strategie (5-10 Files, max 3 concurrent) ist direkt auf unseren analyze-Command uebertragbar.

**Aufwand**: Mittel — Pipeline-Logik in bestehendem /analyze ergaenzen
**Empfehlung**: ✅ Batch-Processing-Pattern adaptieren

### 3. Inkrementelle Analyse via Git-Hash

**Was es tut**: `staleness.ts` vergleicht gespeicherten Git-Commit-Hash mit aktuellem HEAD. Bei Aenderungen: nur geaenderte Files + deren 1-Hop-Nachbarn neu analysieren. `mergeGraphUpdate()` merged alt + neu intelligent.

**Unsere Luecke**: `context-freshness.sh` prueft nur das Alter der Dateien (Tage seit letzter Aenderung), nicht den tatsaechlichen Inhalt. Keine inkrementelle Aktualisierung.

**Aufwand**: Mittel — Git-Hash-Vergleich in context-freshness.sh einbauen
**Empfehlung**: ✅ Adaptieren — direkte Verbesserung unseres bestehenden Hooks

### 4. Diff-Impact-Analyse mit Blast-Radius

**Was es tut**: Bei Code-Aenderungen: 1-Hop-Expansion ueber Edges, Layer-Mapping, Risk-Assessment (High Complexity, Cross-Layer, Blast Radius 5+). Schreibt diff-overlay.json.

**Unsere Luecke**: Unser `/review` prueft Code-Qualitaet, aber tracet nicht systematisch welche anderen Komponenten betroffen sein koennten.

**Aufwand**: Mittel-Hoch — benoetigt strukturierten Graph als Grundlage
**Empfehlung**: ⚠️ Nur mit Knowledge Graph sinnvoll — Abhaengigkeit von #1

### 5. Onboarding-Guide-Generator

**Was es tut**: Generiert strukturierten Onboarding-Guide aus Knowledge Graph: Project Overview, Architecture Layers, Key Concepts, Guided Tour, File Map, Complexity Hotspots. Bietet an, als `docs/ONBOARDING.md` zu speichern.

**Unsere Luecke**: `/discover` reverse-engineered Specs, generiert aber keinen Onboarding-Guide fuer neue Team-Mitglieder.

**Aufwand**: Niedrig — neuer Skill der Context-Dateien liest und Guide generiert
**Empfehlung**: ✅ Adaptieren — hoher Nutzen fuer Agentur-Teams

### 6. Agent-Prompt-Separation (Prompt-als-Datei)

**Was es tut**: Jeder Analyse-Agent hat seinen eigenen Prompt als separate .md-Datei: `project-scanner-prompt.md`, `file-analyzer-prompt.md`, etc. Der Haupt-Skill dispatched Subagents mit diesen Prompts.

**Unsere Luecke**: Unsere Agents haben den kompletten Prompt inline. Keine Wiederverwendung von Prompt-Fragmenten.

**Aufwand**: Niedrig — Refactoring-Pattern, kein neues Feature
**Empfehlung**: ⚠️ Nice-to-have — aktuelle Struktur funktioniert, marginaler Gewinn

### 7. Schema-Validierung mit Zod

**Was es tut**: Striktes Zod-Schema fuer den gesamten Knowledge Graph. `validateGraph()` prueft Struktur, Typen, Referenzen. Graph-Reviewer-Agent fuehrt 7 Validierungs-Checks durch.

**Unsere Luecke**: Keine Schema-Validierung fuer Context-Dateien. Keine automatische Pruefung ob ARCHITECTURE.md konsistent ist.

**Aufwand**: Mittel — nur relevant wenn Knowledge Graph adoptiert wird
**Empfehlung**: ⚠️ Nur mit Knowledge Graph sinnvoll — Abhaengigkeit von #1

### 8. Architektur-Layer-Erkennung

**Was es tut**: Zweistufig — erst heuristische Erkennung via Directory-Patterns (12 Kategorien), dann LLM-basierte Verfeinerung. Berechnet Fan-In/Fan-Out, Inter-Group-Import-Frequenz.

**Unsere Luecke**: ARCHITECTURE.md wird manuell/LLM-generiert ohne systematische Analyse der tatsaechlichen Abhaengigkeiten.

**Konkreter Nutzen**: Die heuristischen Patterns (Routes→API, Services→Service, Models→Data etc.) koennten in unseren context-refresher-Agent eingebaut werden fuer bessere ARCHITECTURE.md-Generierung.

**Aufwand**: Mittel
**Empfehlung**: ✅ Heuristische Patterns adaptieren fuer bessere ARCHITECTURE.md

---

## Einzelne Saetze/Patterns zum Adaptieren

### Aus `project-scanner-prompt.md`:
> "NEVER invent or guess file paths. ALWAYS validate that `totalFiles` matches the actual length of the `files` array."

→ Unsere Agents haben keine solche Halluzinations-Schutzklausel fuer Dateipfade. Direkt in `agents.md` Rule aufnehmen.

### Aus `file-analyzer-prompt.md`:
> "Only functions/classes with exports or 10+ lines warrant dedicated nodes."

→ Gutes Heuristik-Pattern fuer Granularitaet. Vermeidet Ueber-Analyse kleiner Hilfsfunktionen.

### Aus `graph-reviewer-prompt.md`:
> "Report must be specific: 'Edge at index 14 references non-existent target file:src/missing.ts' not generic descriptions."

→ Direkt auf unseren code-reviewer Agent uebertragbar. Spezifische Fehlermeldungen statt generischer Beschreibungen.

### Aus `understand/SKILL.md` (Phase 2):
> "Batches files 5-10 per batch, up to 3 concurrent subagents."

→ Unser /analyze dispatched 3 Agents mit dem gesamten Scope. Batching wuerde Token-Effizienz und Qualitaet verbessern.

### Aus `architecture-analyzer-prompt.md`:
> Script computes: "Import adjacency matrices (fan-in, fan-out), Inter-group import frequency and intra-group density"

→ Quantitative Architektur-Analyse statt reiner LLM-Interpretation. Koennnte als Pre-Processing-Schritt in context-refresher.

### Aus `staleness.ts`:
> `mergeGraphUpdate()`: Intelligentes Merge — alte Knoten bleiben erhalten wenn Files nicht geaendert, neue ersetzen nur geaenderte.

→ Inkrementelles Context-Update-Pattern. Statt alles neu zu generieren, nur geaenderte Sections in ARCHITECTURE.md aktualisieren.

---

## Architektur-Patterns

### 1. Prompt-as-File Pattern
Jeder spezialisierte Agent bekommt seinen Prompt als separate Markdown-Datei. Vorteile: versionierbar, testbar, wiederverwendbar. UA hat 5 solche Prompt-Dateien unter `skills/understand/`.

### 2. Script-First, LLM-Second
Jeder Agent-Prompt beginnt mit "Phase 1: Run this script". Strukturierte Daten werden erst via Code extrahiert (tree-sitter, git, fs), dann LLM fuer semantische Analyse. Spart Tokens weil LLM nicht rohen Code lesen muss.

→ **Adaptierbar**: Unsere Agents koennten einen Script-First-Schritt haben der Basis-Daten sammelt bevor der LLM interpretiert.

### 3. Incremental-by-Default
Jede Analyse prueft zuerst ob ein Update noetig ist (Git-Hash-Vergleich). Vollanalyse nur bei `--full` Flag oder fehlendem Graph.

→ **Adaptierbar**: context-refresher koennte `--full` vs. inkrementell unterstuetzen.

### 4. Validation-as-Last-Step
Phase 6 (Graph-Reviewer) validiert das Endergebnis bevor es gespeichert wird. 7 automatisierte Checks + LLM-Review.

→ **Adaptierbar**: Ein Validierungs-Schritt am Ende von context-refresher der ARCHITECTURE.md gegen die tatsaechliche Codebase prueft.

---

## Gesamtranking nach Aufwand/Nutzen

| # | Item | Value | Aufwand | Abhaengigkeit | Empfehlung |
|---|---|---|---|---|---|
| 5 | Onboarding-Guide-Generator | ★★★★ | Niedrig | Keine | ✅ Sofort umsetzen |
| 3 | Inkrementelle Analyse (Git-Hash) | ★★★★ | Niedrig-Mittel | Keine | ✅ Sofort umsetzen |
| 8 | Heuristische Layer-Erkennung | ★★★ | Mittel | Keine | ✅ In context-refresher |
| 2 | Batch-Processing fuer Analyse | ★★★ | Mittel | Keine | ✅ In /analyze |
| — | Halluzinations-Schutzklausel | ★★★ | Trivial | Keine | ✅ In agents.md Rule |
| — | Spezifische Fehlermeldungen (Reviewer) | ★★★ | Trivial | Keine | ✅ In code-reviewer |
| 1 | Strukturierter Knowledge Graph | ★★★★★ | Hoch | Keine | ⚠️ Strategische Entscheidung |
| 4 | Diff-Impact mit Blast-Radius | ★★★★ | Mittel-Hoch | #1 | ⚠️ Nur mit Graph |
| 7 | Schema-Validierung (Zod) | ★★★ | Mittel | #1 | ⚠️ Nur mit Graph |
| 6 | Prompt-als-Datei Refactoring | ★★ | Niedrig | Keine | ⏭️ Spaeter |
| — | Language Lessons | ★ | Mittel | #1 | ❌ Skip — zu nischig |
| — | Dashboard (React Flow) | ★★ | Hoch | #1 | ❌ Skip — Overkill |
| — | Multi-Platform Plugin Configs | ★ | Niedrig | Keine | ❌ Skip — irrelevant |

---

## Strategische Einschaetzung

**Understand-Anything** ist konzeptionell stark — die Idee eines strukturierten, abfragbaren Knowledge Graphs ist dem Freitext-Ansatz ueberlegen. Allerdings:

1. **Komplexitaet**: Das volle Knowledge-Graph-System mit tree-sitter, Zod-Schemas und React-Dashboard ist Overkill fuer ein Setup-Tool
2. **Token-Oekonomie**: Der Graph muss bei jeder Aenderung aktualisiert werden — das kostet Tokens. Unser Text-basierter Ansatz ist guenstiger
3. **Pragmatische Mitte**: Die einzelnen Patterns (Batching, Git-Hash-Inkrement, heuristische Layer-Erkennung) sind sofort nutzbar ohne das gesamte System zu adoptieren

**Bottom Line**: Cherry-Pick die besten Patterns, skip das Framework. Die Quick Wins (Onboarding-Guide, Git-Hash-Checks, Halluzinations-Schutz) bringen sofortigen Wert bei minimalem Aufwand.
