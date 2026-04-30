# Brainstorm: code2prompt + repomix Adaptionen für npx-ai-setup

> **Spec ID**: 650 | **Created**: 2026-04-30 | **Status**: completed (research) | **Complexity**: low
>
> Sources:
> - https://code2prompt.dev/ — Rust CLI, MIT
> - https://github.com/yamadashy/repomix — TS/Node CLI, MIT
>
> **Closed 2026-04-30**: Research-Doc, kein Implementations-Spec. Erkenntnisse in Spec 651 (repomix opt-in) absorbiert. Goal+Format+Context Sections für TEMPLATE.md → separater Mini-Spec wenn Bedarf.

## Was diese Tools tun

Codebase → ein AI-konsumierbarer Prompt-File. Glob-Filter, .gitignore-aware, Token-Counting, Git-Context, MD/XML/JSON-Output. Designed für **externe LLM-Konsumenten** (ChatGPT, Gemini-Web, Codex-CLI), nicht für Claude Code (das liest nativ).

## Tool-Vergleich

| Aspekt              | code2prompt (Rust)            | repomix (Node)                                  |
| ------------------- | ----------------------------- | ----------------------------------------------- |
| Install             | `cargo`/`brew`                | `npx`/`npm`/`brew`                              |
| Output              | MD/JSON/XML, Handlebars       | XML (Claude-optimiert)/MD/Plain                 |
| Compression         | nein                          | `--compress` (Tree-sitter signatures)           |
| Remote Repo         | nein                          | `--remote owner/repo[/tree/branch]`             |
| stdin-Pipe          | nein                          | `--stdin` (rg/fzf/git ls-files pipeline)        |
| Security-Scan       | nein                          | Secretlint integriert                           |
| Git Diff/Log        | diff only                     | `--include-logs --include-diffs`                |
| Templating          | Handlebars User-Vars          | nein                                            |
| MCP Server          | ja                            | ja                                              |
| Browser-Extension   | nein                          | Chrome/Firefox (GitHub 1-Klick)                 |
| Default Output      | Markdown                      | XML mit `<file_summary>`/`<directory_structure>` |

**Verdict**: repomix > code2prompt für unsere Stacks. npm-native, Compression spart Tokens, --remote deckt Research-Cases ab, XML ist Anthropic-empfohlen für Claude.

## Bestandsvergleich vs npx-ai-setup

| Feature                                | Status      | Notiz                                                                |
| -------------------------------------- | ----------- | -------------------------------------------------------------------- |
| Codebase→Prompt-File                   | ❌ fehlt    | Nur relevant für externe Tools (Codex/Gemini/Web).                   |
| Glob include/exclude                   | ⚠️ partial  | `permissions.deny` für Build-Output, kein Pack-Selector.             |
| Token-Counting                         | ⚠️ partial  | RTK trackt CLI, kein Per-Pack-Count.                                 |
| Git diff/log Integration               | ⚠️ partial  | `pr.md`, `ci-prep.sh`. Kein --include-logs Äquivalent.               |
| Secret-Scan vor Sharing                | ❌ fehlt    | Repomix Secretlint löst das. Riskant ohne.                           |
| Compression / Tree-sitter Extraction   | ❌ fehlt    | Wäre nützlich für graph.json Augmentation.                           |
| Remote-Repo Pack                       | ❌ fehlt    | `/research` Skill könnte profitieren.                                |
| Handlebars Templates                   | ❌ N/A      | Claude-Skills (.md) lösen das anders. Skip.                          |
| Codebase-MCP                           | ❌ N/A      | Out of scope. Context7 + graph.json reichen.                         |

## Lokal laufen lassen — Validierung

**Empfehlung: NICHT install-by-default. Optional via Skill `/pack`.**

**Begründung**:
- Innerhalb Claude Code: Read/Glob/graph.json effizienter, kein File-IO.
- Außerhalb (Codex/Gemini-Handoff, externe Reviewer, Research auf fremden Repos): repomix nützlich.
- Beide Tools sind brew-installable, kein Stack-Conflict.

**Entscheidung**: repomix als opt-in tool, code2prompt skip (redundant).

## Beschlossene Adaptionen (User-Interview)

| Item                                                      | Entscheidung |
| --------------------------------------------------------- | ------------ |
| Built-in Prompt-Templates als Skills cherry-picken        | **SKIP** — wir haben genug Skills |
| Git-Diff-as-Context Skill                                 | **SKIP** — pr/review reichen |
| Goal+Format+Context Sections im Spec-TEMPLATE.md          | **GO** + Hard-Migrate aller aktiven Specs |
| Read-Strategie via graph.json dokumentieren               | **GO** — in `quality.md` unter "Search before Read" als Schritt 0 |
| Focus-Mode Skill                                          | PIVOT → wird durch Read-Strategie-Doku abgedeckt |
| `/pack` Skill (repomix-wrapper, opt-in)                   | **NEU — Vorschlag**: prüfen ob Bedarf |

## Patterns zum Adaptieren

**XML-Output für Claude** (repomix default): `<file_summary>` + `<directory_structure>` + `<files><file path="…">…</file></files>`. Anthropic-Empfehlung. Wenn wir je einen `/pack`-Skill bauen, XML als Default.

**Goal + Format + Context Framework** (code2prompt Landing): Spec-TEMPLATE.md bekommt 3 fixe Sections. Klärt Skills-Outputs.

**`--compress` via Tree-sitter** (repomix): Extrahiert nur Function-Signatures, dropt Bodies. Reduziert Tokens 70-80% bei Graph-Builds. Inspiration für graph.json Erweiterung — Signature-Index statt Just-Edges.

## Ranking final

| Item                                                  | Value | Aufwand | Status |
| ----------------------------------------------------- | ----- | ------- | ------ |
| Goal+Format+Context Sections + Hard-Migrate           | ★★★   | mittel  | **GO** |
| graph.json Read-Strategie in quality.md               | ★★★   | niedrig | **GO** |
| `/pack` Skill (repomix opt-in wrapper)                | ★★    | niedrig | **EVAL** — frag User |
| Tree-sitter Signature-Index für graph.json            | ★★★   | hoch    | später, eigene Spec |
| Handlebars-Templates / Codebase-MCP / Diff-Skill      | -     | -       | SKIP |
