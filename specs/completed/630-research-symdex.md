# Brainstorm: SymDex Adaptionen für npx-ai-setup
> **Status**: completed
> Source: https://github.com/husnainpk/SymDex | Date: 2026-04-13

## Was ist SymDex?

Repo-lokales Codebase-Oracle für AI-Coding-Agenten. Indiziert Quellcode in SQLite, liefert Symbol-Suche, semantische Suche, Call Graphs und HTTP-Route-Extraktion via CLI + MCP Server. Kernversprechen: ~80% Token-Einsparung durch byte-genaue Symbol-Extraktion statt Full-File-Reads.

**Tech Stack:** Python 3.11+, tree-sitter (16 Sprachen), SQLite + sqlite-vec, FastMCP, Typer/Rich CLI, optional sentence-transformers oder Voyage AI Embeddings.

## Inventar

```
SYMDEX:        20 MCP Tools, 1 Skill, 1 CLI, 16 Language Parsers, SQLite Storage
NPX-AI-SETUP: 30 Skills, 13 Hooks, 8 Rules, 26 Commands, 25 Agent Definitions
```

## Bestandsvergleich

| SymDex Feature | npx-ai-setup Status | Detail |
|---|---|---|
| **Symbol Search (exact)** | &#x26A0;&#xFE0F; Partial | Wir nutzen Glob/Grep/Read direkt. graph.json (spec 629) liefert Import-Kanten, aber keine Symbol-Ebene |
| **Semantic Search** | &#x274C; Missing | Kein Embedding-basiertes Search. Wir verlassen uns auf Grep + Agent-Explore |
| **Text Search (indexed)** | &#x2705; Covered | Grep + RTK ist unser Äquivalent. Kein Indexing, aber ripgrep ist schnell genug |
| **File Outline** | &#x26A0;&#xFE0F; Partial | smart-explore (claude-mem Skill) nutzt tree-sitter AST, aber nicht als MCP Tool |
| **Call Graph** | &#x26A0;&#xFE0F; Partial | graph.json (build-graph.sh) liefert Import-Kanten, aber keine Caller/Callee auf Symbol-Ebene |
| **Circular Dep Detection** | &#x274C; Missing | graph.json enthält Kanten, aber keinen Cycle-Detection-Algorithmus |
| **HTTP Route Extraction** | &#x274C; Missing | Kein Äquivalent. Nuxt-Projekte haben File-Based-Routing (implizit), Express/FastAPI nicht abgedeckt |
| **Byte-Offset Symbol Retrieval** | &#x274C; Missing | Wir lesen immer ganze Dateien oder line-ranges via Read Tool |
| **Watch Mode (auto re-index)** | &#x26A0;&#xFE0F; Partial | context-freshness.sh Hook warnt bei veralteten Context-Files, aber kein aktives Re-Indexing |
| **Token Savings Reporting** | &#x2705; Covered | RTK (`rtk gain`) liefert Token-Savings-Analytics. SymDex hat ROI pro Suche |
| **MCP Server Integration** | &#x2705; Covered | Wir installieren Context7 als MCP. SymDex wäre ein zusätzlicher MCP Server |
| **CLAUDE.md Product Truth** | &#x2705; Covered | Unser CLAUDE.md + context files sind ausführlicher und tiered (L0/L1/L2) |
| **AGENTS.md Workflow Guide** | &#x2705; Covered | Unser AGENTS.md + agent-dispatch.md ist detaillierter mit Model Routing |
| **SKILL.md Agent Integration** | &#x2705; Covered | 30 Skills vs. 1 Skill. SymDex hat eine fokussierte Code-Search-Skill |
| **Spec-Driven Development** | &#x2705; Better | SymDex hat SPEC.md als Produktdoku. Wir haben spec/spec-work/spec-validate Workflow |
| **Quality Gates** | &#x2705; Better | 13 Hooks + circuit-breaker + protect-files vs. keine Hooks bei SymDex |
| **Model Routing** | &#x2705; Better | Haiku/Sonnet/Opus Routing in agents.md. SymDex hat kein Model Routing |
| **Context Tiering** | &#x2705; Better | L0 Abstracts (~400 Tokens) via SessionStart Hook. SymDex lädt alles |

## Kandidaten für Adaption

### 1. SymDex als optionaler MCP Server (NEW)

**Gap:** Kein Symbol-Level Code Intelligence in unserem Setup. Grep findet Text, aber keine Funktions-Signaturen, Klassen-Hierarchien oder Call Chains.

**Was SymDex liefert:** 20 MCP Tools für präzise Code-Navigation. Ein `search_symbols("validate_email")` kostet ~15 Tokens vs. ~250 Tokens für Full-File-Read.

**Aufwand:** Plugin-Integration in `lib/plugins.sh` (wie Context7). MCP-Config in `.mcp.json`. Skill-Template für Agent-Anweisungen.

**Empfehlung:** SymDex als optionalen MCP Server anbieten für Projekte mit >500 Dateien. Nicht mandatory - zu schwere Dependency (Python + tree-sitter).

### 2. Symbol-Aware File Outline als Hook (PARTIAL)

**Gap:** Unsere Agents lesen oft ganze Dateien, um eine Funktion zu finden. `get_file_outline` würde die Datei-Struktur als Vorschau liefern.

**SymDex-Ansatz:** tree-sitter Parse + SQLite Index. Byte-Offsets für jedes Symbol.

**Unser Äquivalent:** claude-mem `smart-explore` nutzt tree-sitter, aber nur on-demand und nicht als MCP Tool.

**Empfehlung:** Kein eigenes Re-Implementation. Entweder SymDex als MCP einbinden oder `smart-explore` promoten.

### 3. Circular Dependency Detection (NEW)

**Gap:** graph.json hat Import-Kanten, aber keinen Cycle-Detection. SymDex hat `get_circular_deps`.

**Aufwand:** jq-basierter Algorithmus auf graph.json oder SymDex MCP nutzen.

**Empfehlung:** Einfacher jq/bash Cycle-Detector auf graph.json als Script. Spec 629 (lightweight-dependency-graph) deckt das teilweise ab.

### 4. Token ROI per Search (PATTERN)

**Gap:** RTK zeigt aggregierte Savings. SymDex zeigt ROI pro Suchergebnis ("Saved ~200 tokens vs. full file read").

**Zitat SymDex:** `roi_summary` mit `estimated_tokens_without_symdex` vs. `estimated_tokens_with_symdex`.

**Empfehlung:** Nice-to-have Pattern für RTK. Niedrige Priorität - RTK `gain` reicht.

### 5. Watch Mode / Auto-Reindex (PATTERN)

**Gap:** context-freshness.sh warnt, aber re-indiziert nicht automatisch.

**SymDex-Ansatz:** `watchdog` Library + targeted invalidation bei File Changes.

**Empfehlung:** Unser Hook-Ansatz (warnen statt auto-fix) ist bewusst gewählt (decisions.md: "LLM nur bei Fehler"). Kein Adaption nötig.

### 6. CLAUDE.md Sync Discipline (PATTERN)

**Zitat SymDex CLAUDE.md:** "Whenever the MCP tool count or language support changes, update: CLAUDE.md, context.md, SKILL.md, README.md"

**Unser Äquivalent:** context-refresh Skill + doctor.sh Health Check. Aber keine explizite "update these 4 files" Regel.

**Empfehlung:** Pattern bereits besser gelöst durch unsere automatische Context-Generierung.

## Patterns zum Adaptieren

### SymDex Token Cost Model (aus SPEC.md)

> "Single symbol: 250 -> 50 tokens (80% savings). 5-symbol call chain: 1250 -> 300 tokens (76% savings). Repo structure: 5000 -> 200 tokens (96% savings)."

Relevanz: Untermauert den Business Case für Symbol-Level-Retrieval. Nützlich als Argumentation in unserer Token-Optimization-Doku.

### Agent Best Practices (aus AGENTS.md)

> "A 500-line file read costs ~250 tokens. A SymDex symbol retrieval costs ~20 tokens. Use SymDex first to narrow the scope."
> "Before reading a function, trace its get_callees and get_callers. This often provides enough context to avoid reading the full file."

Relevanz: Dieses "Search-before-Read" Pattern könnten wir als Regel in `agents.md` verstärken.

### Skill Trigger Design (aus SKILL.md)

> ```yaml
> name: symdex-code-search
> description: |
>   This skill should be used when finding, tracing, or understanding code...
>   Trigger it for requests like "where is this defined?", "who calls this?"...
> ```

Relevanz: Gutes Muster für Skill-Trigger-Dokumentation mit konkreten Trigger-Phrasen. Unsere Skills könnten davon profitieren.

## Ranking nach Aufwand/Nutzen

| # | Item | Value | Aufwand | Empfehlung |
|---|------|-------|---------|------------|
| 1 | SymDex als opt. MCP Server | &#x2B50;&#x2B50;&#x2B50; | Mittel (Plugin + Skill + Docs) | GO - als optionaler Power-User-MCP |
| 2 | "Search-before-Read" Regel | &#x2B50;&#x2B50; | Gering (1 Absatz in agents.md) | GO - Quick Win |
| 3 | Circular Dep auf graph.json | &#x2B50;&#x2B50; | Gering (jq Script) | DEFER - Spec 629 deckt das ab |
| 4 | Skill Trigger Phrases | &#x2B50; | Gering (Template Update) | GO - verbessert Skill Discovery |
| 5 | Token ROI per Search | &#x2B50; | Mittel (RTK Erweiterung) | SKIP - RTK gain reicht |
| 6 | Watch Mode Auto-Reindex | &#x2B50; | Hoch | SKIP - widerspricht unserer Philosophie |

## Entscheidungen (Interview + Philosophy Check)

**Grundsatzentscheidung:** SymDex selbst wird NICHT eingebunden. Nur Patterns adaptieren.

| # | Kandidat | Verdict | Umsetzung |
|---|----------|---------|-----------|
| 1 | Search-before-Read Regel | **GO** | Kurzfassung in `templates/claude/rules/quality.md`, Detail in `templates/claude/rules/agents.md` |
| 2 | Skill Trigger Phrases | **GO** | Frontmatter-Erweiterung der Top-10 Skill-Templates mit konkreten Trigger-Phrasen |
| 3 | Circular Dep Detection | **DEFER** | Wird als Feature in Spec 629 aufgenommen wenn graph.json-Basis steht |
| 4 | SymDex als MCP Server | **SKIP** | Nur Patterns, nicht das Tool selbst. Python-Dependency zu schwer |
| 5 | Token ROI per Search | **SKIP** | RTK `gain` deckt den Use Case ab |
| 6 | Watch Mode | **SKIP** | Widerspricht Decision #3 (Hook-first, LLM nur bei Fehler) |

### Philosophy Check Results

Alle GO-Kandidaten aligned mit:
- **CONCEPT.md**: "burns tokens on actual work" + "Curated Skills, Not AI Discovery"
- **Decision #4**: Token Optimization mandatory
- **Decision #3**: Hook-first, keine Auto-Magic
