# Brainstorm: lean-ctx Adaptionen fuer npx-ai-setup
> **Status**: completed
> Source: https://github.com/yvgude/lean-ctx | Date: 2026-04-13

## Was ist lean-ctx?

Rust-Binary ("Intelligence Layer for AI Coding") mit 34 MCP-Tools, 90+ Shell-Kompressions-Patterns und tree-sitter AST-Parsing fuer 18 Sprachen. Kernidee: jeden Tool-Call (Read, Grep, Bash, ls) durch eine komprimierte Variante ersetzen, die Session-Caching, Entropy-Filtering und Signature-Extraction nutzt. Claim: bis zu 99% Token-Reduktion.

v3.0.3 (Apr 2026), MIT-Lizenz, 572 Stars. Unterstuetzt Claude Code, Cursor, Copilot, Gemini, Windsurf, Kiro.

## Bestandsvergleich

### Kontext-Optimierung

| Feature | lean-ctx | npx-ai-setup | Status |
|---------|----------|--------------|--------|
| Shell-Output-Kompression (git, npm, cargo) | `lean-ctx -c <cmd>` / `ctx_shell` — 90+ Patterns | RTK (`rtk git status` etc.) via tool-redirect.sh Hook | ✅ Covered (RTK) |
| File-Read-Caching (Re-reads ~13 Tokens) | `ctx_read` mit Session-Cache + Hash-Dedupe | Nicht vorhanden — jeder Read kostet volle Tokens | ❌ Missing |
| AST-basierte Signatur-Extraktion | tree-sitter fuer 18 Sprachen, Mode `signatures` | `smart-explore` Skill nutzt tree-sitter via CLI | ⚠️ Partial |
| Adaptive Read-Modes (full/map/sig/diff/entropy) | 8 Modi mit auto-select via `ctx_smart_read` | Kein Konzept fuer Read-Modi | ❌ Missing |
| Compact Directory Tree | `ctx_tree` mit Token-Savings-Report | Standard `ls`/Glob | ❌ Missing |
| Cross-file Deduplication (TF-IDF Cosine) | `ctx_dedup` erkennt duplizierte Bloecke | Nicht vorhanden | ❌ Missing |
| Token-Cost-Tracking pro Session | `ctx_metrics` / `ctx_cost` mit Agent-Attribution | Kein Session-Tracking — nur RTK `gain` fuer CLI-Ops | ⚠️ Partial |
| Delta-Loading (nur geaenderte Zeilen) | `ctx_read mode=diff` vergleicht mit Cache | Nicht vorhanden | ❌ Missing |
| Entropy-Filtering (Shannon + Jaccard) | Zeilen mit niedrigem Informationsgehalt entfernen | Nicht vorhanden | ❌ Missing |

### Hook-Integration

| Feature | lean-ctx | npx-ai-setup | Status |
|---------|----------|--------------|--------|
| PreToolUse Hook fuer Tool-Rewriting | `hook_handlers.rs` — Bash-Calls zu `lean-ctx -c` umschreiben | `tool-redirect.sh` — Bash-Calls zu `rtk` umschreiben | ✅ Covered |
| Auto-Hook-Install bei Setup | `lean-ctx setup` / `lean-ctx init --agent claude` | Template-basierte Hook-Installation | ✅ Covered |
| Hook-Refresh bei Binary-Update | `refresh_installed_hooks()` in hooks.rs | `update-check.sh` Hook prueft Version | ✅ Covered |
| Rules-Injection in CLAUDE.md | `rules_inject.rs` — automatisches Einfuegen von Tool-Mapping-Regeln | Template-basiertes CLAUDE.md mit manuellen Regeln | ⚠️ Partial |

### MCP-Server

| Feature | lean-ctx | npx-ai-setup | Status |
|---------|----------|--------------|--------|
| MCP-Server mit 28+ Tools | Eigener MCP-Server (`mcp_stdio.rs`) | Kein eigener MCP-Server — nutzt externe (Context7) | ❌ Missing (by design) |
| Semantic Search (BM25 + Embeddings) | `ctx_search` / `ctx_semantic_search` | Standard Grep | ❌ Missing |
| Call-Graph / Impact-Analysis | `ctx_callers` / `ctx_callees` / `ctx_impact` | `build-graph.sh` generiert graph.json (statisch) | ⚠️ Partial |
| Knowledge Graph | `ctx_knowledge` mit Property-Graph-DB | Kein Knowledge Graph | ❌ Missing |
| Dashboard / TUI | Terminal-UI mit Heatmap, Session-Metrics | Kein Dashboard | ❌ Missing |

### Multi-Agent

| Feature | lean-ctx | npx-ai-setup | Status |
|---------|----------|--------------|--------|
| Agent-to-Agent Context Sharing | `ctx_share` / A2A-Module | Kein A2A — Agents sind isoliert | ❌ Missing |
| Cost Attribution per Agent | `ctx_cost` mit Agent-ID-Tracking | Nicht vorhanden | ❌ Missing |
| Task Briefing / Context Preloading | `ctx_task` / `ctx_preload` | Context-Loader Hook (SessionStart) | ⚠️ Partial |

### Packaging / Distribution

| Feature | lean-ctx | npx-ai-setup | Status |
|---------|----------|--------------|--------|
| Distribution | Rust Binary (cargo, npm, AUR, Homebrew) | Bash-Skript via npm tarball (`npx`) | ✅ Covered (different approach) |
| IDE-Support | Claude Code, Cursor, Windsurf, Copilot, Kiro, Gemini | Claude Code only (Codex/Gemini via orchestrate) | ⚠️ Partial |
| Chrome Extension | `packages/chrome-lean-ctx` | Nicht vorhanden | ❌ Missing (irrelevant) |
| VS Code Extension | `packages/vscode-lean-ctx` | Nicht vorhanden | ❌ Missing (irrelevant) |

## Kandidaten fuer Adaption

### 1. Session-Read-Caching (HIGH VALUE)

**Gap**: Jeder `Read`-Aufruf in Claude Code kostet volle Tokens. lean-ctx cached Dateien in der Session und liefert Re-Reads fuer ~13 Tokens statt Hunderten.

**Ihre Implementierung**: `ctx_read` in Rust mit `SessionCache` (Hash-basiert). Re-Read erkennt unveraenderte Datei und liefert kurze Referenz (`F1: file.ts — unchanged, 342 tokens cached`).

**Unsere Luecke**: npx-ai-setup hat kein Konzept fuer Read-Caching. RTK optimiert nur CLI-Output, nicht File-Reads.

**Effort**: Hoch — erfordert entweder eigenen MCP-Server oder Integration von lean-ctx als Dependency.

**Empfehlung**: EVALUATE — das ist lean-ctx's Kern-Value-Prop. Frage: Installieren wir lean-ctx als optionale Dependency, oder bauen wir etwas Eigenes?

### 2. Adaptive Read-Modes (MEDIUM VALUE)

**Gap**: Claude liest immer die komplette Datei. lean-ctx waehlt automatisch den optimalen Modus:
- `full` fuer zu editierende Dateien
- `map` fuer Kontext-Dateien (nur Deps + API-Surface)
- `signatures` fuer API-Overview (tree-sitter AST)
- `diff` fuer bereits gecachte Dateien

**Ihre Implementierung** (`ctx_smart_read.rs`):
```rust
if token_count <= 200 { return "full" }
if cached && hash_unchanged { return "full" }
if cached && hash_changed { return "diff" }
// else: predictor based on file extension + size
```

**Unsere Luecke**: `smart-explore` Skill nutzt tree-sitter, aber nur als manueller Aufruf — nicht als automatischer Read-Replacement.

**Effort**: Hoch — gleiche Dependency-Frage wie #1.

### 3. Token-Metrics-Dashboard (LOW-MEDIUM VALUE)

**Gap**: Kein Ueberblick ueber Token-Verbrauch pro Session in npx-ai-setup. RTK trackt nur CLI-Savings.

**Ihre Implementierung**: `ctx_metrics` liefert Session-Totals (original vs. compressed), `ctx_cost` trackt per Agent/Tool.

**Unsere Luecke**: Kein Session-Level-Tracking. RTK `gain` zeigt nur CLI-Savings.

**Effort**: Niedrig-Mittel — RTK koennte erweitert werden, oder lean-ctx liefert die Daten via MCP.

**Empfehlung**: NICE-TO-HAVE — RTK deckt den wichtigsten Teil ab.

### 4. Rules-Auto-Injection (MEDIUM VALUE)

**Gap**: lean-ctx injiziert automatisch Tool-Mapping-Regeln in CLAUDE.md (`rules_inject.rs`), mit Version-Tracking und LITM-optimierter Positionierung.

**Ihre Implementierung**:
```rust
const RULES_SHARED: &str = r#"# lean-ctx - Context Engineering Layer
<!-- lean-ctx-rules-v8 -->
CRITICAL: ALWAYS use lean-ctx MCP tools instead of native equivalents.
| ALWAYS USE | NEVER USE | Why |
..."#;
```

**Unsere Luecke**: npx-ai-setup setzt CLAUDE.md einmalig via Template. Updates erfordern manuelles `npx ai-setup --update`. Kein automatisches Re-Inject bei Version-Bumps.

**Effort**: Niedrig — `update.sh` koennte Marker-basierte Section-Updates implementieren.

**Empfehlung**: ADAPT PATTERN — Marker-basierte Sections in CLAUDE.md (`<!-- ai-setup-rules-vN -->`) wuerden Updates sicherer machen.

### 5. lean-ctx als optionale Plugin-Integration (HIGH VALUE)

**Gap**: lean-ctx ist ein komplementaeres Tool, kein Konkurrent. npx-ai-setup koennte lean-ctx als Plugin installieren — aehnlich wie Context7 oder claude-mem.

**Ihre Implementierung**: `lean-ctx init --agent claude` installiert MCP-Config + Hooks + CLAUDE.md-Rules automatisch.

**Unsere Luecke**: Kein Plugin fuer lean-ctx in `lib/plugins.sh`.

**Effort**: Niedrig — Plugin-Pattern existiert bereits (Context7, claude-mem). Nur Detection + MCP-Config + Rules-Injection.

**Empfehlung**: PRIME CANDIDATE — passt perfekt ins Plugin-System.

### 6. Cross-File Deduplication Hint (LOW VALUE)

**Gap**: lean-ctx erkennt duplizierte Code-Bloecke ueber Dateigrenzen hinweg.

**Unsere Luecke**: Kein Feature dafuer.

**Effort**: Hoch — erfordert AST-Parsing + Hashing-Infrastruktur.

**Empfehlung**: SKIP — zu spezialisiert, lean-ctx liefert das besser als Eigenbau.

### 7. Agent Cost Attribution (LOW VALUE)

**Gap**: lean-ctx trackt Token-Kosten per Subagent.

**Unsere Luecke**: Kein Agent-Cost-Tracking.

**Effort**: Hoch — erfordert MCP-Server oder Hook-basiertes Logging.

**Empfehlung**: SKIP — operationales Tooling, nicht Setup-Scope.

## Patterns zum Adaptieren

### LITM-Positioning (Lost in the Middle)
lean-ctx platziert kritische Instruktionen am Anfang UND Ende von injizierten Bloecken:
```
CRITICAL: ALWAYS use lean-ctx MCP tools...
[table with mappings]
...
CRITICAL: ctx_read replaces READ operations only.
<!-- /lean-ctx -->
```
**Anwendbar**: Unsere CLAUDE.md-Templates koennten kritische Regeln dupliziert am Ende wiederholen.

### Version-Tagged Rule Sections
```html
<!-- lean-ctx-rules-v8 -->
...
<!-- /lean-ctx -->
```
**Anwendbar**: `<!-- ai-setup-rules-v3 -->` Marker wuerden idempotente Updates ermoeglichen.

### Session-File-References (F1, F2...)
lean-ctx vergibt persistente Referenz-IDs pro Session (`F1: app.ts`). Spaetere Referenzen nutzen nur die ID.
**Anwendbar**: Interessantes Pattern, aber erfordert MCP-Server — nicht via Hooks loesbar.

## Ranking nach Aufwand/Nutzen

| # | Kandidat | Value | Aufwand | Empfehlung |
|---|----------|-------|---------|------------|
| 5 | lean-ctx Plugin-Integration | ★★★★★ | Niedrig | **GO** — Plugin in `lib/plugins.sh`, MCP-Config, CLAUDE.md-Rules |
| 4 | Marker-basierte Rules-Injection | ★★★★ | Niedrig | **GO** — Idempotente Section-Updates in CLAUDE.md |
| 1 | Session-Read-Caching | ★★★★★ | N/A (via Plugin) | **DEFER** — kommt automatisch mit Plugin #5 |
| 2 | Adaptive Read-Modes | ★★★★ | N/A (via Plugin) | **DEFER** — kommt automatisch mit Plugin #5 |
| 3 | Token-Metrics-Dashboard | ★★★ | Mittel | **SKIP** — RTK + lean-ctx Plugin decken das ab |
| — | LITM-Positioning Pattern | ★★★ | Niedrig | **GO** — in naechstem Template-Update anwenden |
| 6 | Cross-File Deduplication | ★★ | Hoch | **SKIP** — lean-ctx liefert das besser |
| 7 | Agent Cost Attribution | ★★ | Hoch | **SKIP** — operationales Tooling, out of scope |
