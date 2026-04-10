# Plan: Setup Improvement Opportunities

## Context

Basierend auf dem aktuellen GitHub-`main`-Stand (`282dc033`): vier abgeschlossene Research-Brainstorms
(manage-skills, repowise, graphify, claude-code-internals, auto-mode) haben konkrete Empfehlungen geliefert.
Diese sind **noch nicht als Specs erfasst** und nicht implementiert. Das ist die Lücke, die wir schließen.

**Was bereits erledigt ist (nicht nochmal anfassen):**
- 607: Pre/Post-Compact Hooks ✅ completed
- 622: Skill-Audit (5 Skills entfernt) ✅ completed
- 627: ADR/architectural-decisions Skill ✅ in-review
- 628: Pre-Modification Skill ✅ in-review
- 629: Lightweight Dependency Graph ✅ in-review
- PR #9: MCP context7, ci-prep.sh, graph.json stub, dead code removal ✅ open

**Wo sind die echten Lücken?**

Nach Analyse aller vier Research-Docs: keine der unten stehenden Verbesserungen ist
in einem offenen oder geplanten Spec enthalten.

---

## Implementierungsplan: 5 fokussierte Verbesserungen

### 1. Suggested Questions in /analyze (★★★, ~30min)

**Gap**: `/analyze` produziert ARCHITECTURE.md + AUDIT.md als reine Beschreibungen.
Graphify's Kernmuster: der Analyse-Agent formuliert 3–5 Folgefragen zu schwachen Stellen
(unklare Kopplungen, Gott-Module, fragile Pfade). Heute: nichts actionable.

**Change**: `templates/skills/analyze/SKILL.template.md` — neuen Output-Block
`## Suggested Questions` am Ende des Synthesizer-Schritts:
- "Warum ist `<hub-file>` so stark importiert — gibt es eine Abstraktionsgrenze?"
- "Wer ist der einzige Konsument von `<isolated-module>`?"
- "Was bricht, wenn `<fragile-file>` geändert wird?"

**Files**: `templates/skills/analyze/SKILL.template.md`, `.claude/skills/analyze/SKILL.md`

---

### 2. Confidence Levels in /techdebt (★★★, ~20min)

**Gap**: `/techdebt` listet Findings ohne Differenzierung. Repowise-Pattern: jede Finding
bekommt `[HIGH/MED/LOW]` + kurze Begründung → User kann priorisieren, Fehlalarme fallen auf.

**Change**: `templates/skills/techdebt/SKILL.template.md` — Output-Format für jeden Finding-Typ:
```
[HIGH] Unused export `fooBar` — 0 callers in codebase
[MED]  Duplicated block in api.ts:45 and utils.ts:12 (8 lines)
[LOW]  TODO in auth.ts:89 (12 months old)
```

**Files**: `templates/skills/techdebt/SKILL.template.md`, `.claude/skills/techdebt/SKILL.md`

---

### 3. Corpus Health Check in /doctor (★★★, ~20min)

**Gap**: `/doctor` prüft nicht ob das Projekt zu groß für sinnvolle Context-Generierung ist.
Graphify-Muster: Warnung bei >500 Files ("wird teuer"), Info bei <10 Files ("zu klein").

**Change**: `templates/scripts/doctor.sh` — neue Check-Routine nach dem Specs-Check:
```bash
# Corpus size check
file_count=$(git ls-files 2>/dev/null | wc -l | tr -d ' ')
if [ "$file_count" -gt 500 ]; then
  add_row "$WARN" "Corpus size" "${file_count} tracked files — /analyze and /context-refresh will be expensive"
elif [ "$file_count" -lt 5 ]; then
  add_row "$WARN" "Corpus size" "${file_count} tracked files — context generation adds little value"
else
  add_row "$PASS" "Corpus size" "${file_count} tracked files"
fi
```

**Files**: `templates/scripts/doctor.sh`, `.claude/scripts/doctor.sh` (local sync)

---

### 4. MCP-Fallback blocks in explore + debug Skills (★★, ~20min)

**Gap**: `explore` und `debug` Skills haben keinen expliziten Fallback wenn MCP-Tools
(context7, etc.) nicht verfügbar sind. Repowise-Pattern: immer ein `## If MCP Unavailable`-Block.

**Change**: In beiden Skills jeweils einen Fallback-Block ergänzen:
```markdown
## If MCP Unavailable
If a MCP server is unavailable or returns an error:
- Continue using Read, Grep, Glob directly
- Note to user: run `claude mcp list` to verify server status
```

**Files**:
- `templates/skills/explore/SKILL.template.md`
- `templates/skills/debug/SKILL.template.md`
- `.claude/skills/explore/SKILL.md`
- `.claude/skills/debug/SKILL.md`

---

### 5. Autonomous Flow Safety in CLAUDE.md template (★★★★, ~15min)

**Gap**: Das `templates/CLAUDE.md`-Template dokumentiert `-p`, `--bare`, `--output-format json`,
aber NICHT `--max-budget-usd` und `--max-turns`. Aus der auto-mode Research: Budget-Caps sind
der primäre Safety-Mechanismus für autonome Runs — fehlt komplett.

**Change**: In `templates/CLAUDE.md` die Automation-Section erweitern:

```markdown
## Automation (Agent SDK CLI)
Non-interactive: `claude -p "<prompt>" --output-format json`. CI: add `--bare` (disables Hooks/Skills/MCP).
Cost controls: `--max-budget-usd 0.50` / `--max-turns 20`. Stateless: `--no-session-persistence`.
```

Außerdem: Permission Mode Awareness ergänzen (Shift+Tab cycling, `auto`, `dontAsk` kurz erwähnen).

**Files**: `templates/CLAUDE.md`

---

## Größere Items (separate Specs empfohlen, nicht diese Session)

| Item | Wert | Warum separater Spec |
|------|------|---------------------|
| Interactive Skill Selection | ★★★★★ | `bin/ai-setup.sh` + `lib/setup-skills.sh` — komplexer Prompt-Flow |
| SubagentStart/Stop Hooks | ★★★ | Hook-Scripts + Settings-Änderungen, braucht eigene Validierung |
| graph_diff() für /review | ★★ | Abhängig von graph.json (spec 629 noch in-review) |

---

## Implementierungsreihenfolge

```
1 (Suggested Questions)  ──┐
2 (Confidence Levels)    ──├── Alle parallel, da unabhängige Template-Edits
3 (Corpus Health)        ──┤
4 (MCP Fallback)         ──┤
5 (Automation Safety)    ──┘
```

Dann: smoke tests, commit, push.

## Kritische Dateien

| Datei | Aktion |
|-------|--------|
| `templates/skills/analyze/SKILL.template.md` | Edit — Suggested Questions block |
| `templates/skills/techdebt/SKILL.template.md` | Edit — Confidence Level output format |
| `templates/scripts/doctor.sh` | Edit — Corpus size check |
| `.claude/scripts/doctor.sh` | Sync-Edit (mirrors template) |
| `templates/skills/explore/SKILL.template.md` | Edit — MCP fallback block |
| `templates/skills/debug/SKILL.template.md` | Edit — MCP fallback block |
| `.claude/skills/explore/SKILL.md` | Sync |
| `.claude/skills/debug/SKILL.md` | Sync |
| `templates/CLAUDE.md` | Edit — budget/turn limits + permission mode |

## Verifikation

```bash
bash tests/smoke/run-tests.sh
bash templates/scripts/doctor.sh   # (oder .claude/scripts/doctor.sh im Projekt)
bash -n templates/scripts/doctor.sh  # Syntax-Check
```
