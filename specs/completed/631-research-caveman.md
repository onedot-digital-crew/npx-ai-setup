# Brainstorm: Caveman Adaptionen für npx-ai-setup
> **Status**: completed
> Source: https://github.com/JuliusBrussee/caveman | Date: 2026-04-13

## Inventar

```
CAVEMAN:       5 skills, 3 hooks, 3 commands, 1 rule, 1 plugin manifest, 1 CI workflow
NPX-AI-SETUP: 30+ skills, 16 hooks, 18 commands, 8 rules, 1 plugin system, 1 CI workflow
```

## Bestandsvergleich

| Caveman Item | Uns | Status | Anmerkung |
|---|---|---|---|
| **Caveman Mode** (Output-Kompression ~75%) | token-optimizer Audit | ❌ Missing | Wir optimieren Input-Tokens (Context), nicht Output-Tokens. Caveman adressiert die andere Hälfte. |
| **Intensity Levels** (lite/full/ultra/wenyan) | - | ❌ Missing | Stufensystem für Verbosität. Unser Projekt hat kein Äquivalent. |
| **caveman-compress** (CLAUDE.md Kompression ~46%) | token-optimizer | ⚠️ Partial | Unser token-optimizer auditiert, komprimiert aber nicht automatisch. Caveman hat Python-Scripts mit Validation. |
| **caveman-commit** (terse Commits) | /commit Skill | ⚠️ Partial | Unser Commit-Skill erzeugt Conventional Commits, aber ohne explizite Kürze-Regeln. Caveman: 50 char hard cap. |
| **caveman-review** (one-liner Reviews) | /review Skill | ⚠️ Partial | Unser Review ist umfangreicher (3 Intensitäten). Caveman: `L42: bug: user null. Add guard.` — extremer Fokus. |
| **SessionStart Hook** (auto-activate + SKILL.md inject) | context-loader.sh | ✅ Covered | Wir injizieren Context-Abstracts via SessionStart. Caveman injiziert seinen Ruleset. Gleicher Mechanismus. |
| **UserPromptSubmit Hook** (mode tracking) | tool-redirect.sh, update-check.sh | ⚠️ Partial | Wir nutzen UserPromptSubmit für andere Zwecke. Mode-Tracking haben wir nicht. |
| **Statusline Badge** ([CAVEMAN:ULTRA]) | statusline.sh | ⚠️ Partial | Wir haben Statusline-Support, aber keinen dynamischen Mode-Badge. |
| **Flag File** (~/.claude/.caveman-active) | - | ❌ Missing | Inter-Hook Kommunikation via Flag File. Wir haben keinen Hook-zu-Hook State. |
| **Plugin Manifest** (plugin.json) | plugins.sh | ✅ Covered | Wir generieren Plugin-Konfiguration. Caveman hat ein Claude Plugin manifest. |
| **CI Sync Workflow** (single source → sync) | - | ⚠️ Partial | Caveman synced SKILL.md → 8 Agent-Formate via CI. Wir haben templates/ als Source of Truth, aber kein CI-Sync. |
| **Multi-Agent Distribution** (Cursor, Windsurf, Cline, Copilot, Codex, Gemini) | detect.sh + boilerplate.sh | ✅ Covered | Wir erkennen und generieren für diverse Agents. Caveman verteilt denselben Content an alle. |
| **Evals Harness** (3-arm: baseline/terse/skill) | - | ❌ Missing | Messbare Token-Evaluierung. Wir haben kein Eval-Framework. |
| **Config Resolution** (env → file → default) | .ai-setup.json | ⚠️ Partial | Wir haben project-level Config. Caveman hat user-level Config mit Kaskade. |
| **Auto-Clarity** (drop terse for security/irreversible) | quality.md Rules | ✅ Covered | Unsere Quality-Rules decken das ab. |
| **caveman-help** (Quick-Reference Card) | /doctor Skill | ⚠️ Partial | Doctor prüft Setup-Health, ist aber kein Quick-Reference für Features. |

## Kandidaten für Adaption

### 1. Output-Token Compression Skill (NEU)

**Was Caveman macht:** SKILL.md wird via SessionStart injiziert. Claude antwortet dann in komprimiertem Stil — Artikel weglassen, Fragmente OK, kurze Synonyme. ~65-75% weniger Output-Tokens.

**Unsere Lücke:** Wir optimieren nur Input-Tokens (Context-Loading, tiered abstracts). Output-Tokens bleiben unberührt — und machen typisch 60-70% der Session-Kosten aus.

**Gap:** Komplett fehlend. Kein Skill, keine Rule, kein Mechanismus.

**Aufwand:** Niedrig — ein SKILL.md + eine Rule-Datei + Hook-Integration.

**Empfehlung:** Adaptieren, aber als optionaler Skill (nicht always-on). Unser Projekt ist safety-first; always-on terse mode kann bei Security-Warnungen oder komplexen Erklärungen gefährlich sein.

### 2. CLAUDE.md Auto-Compression (ERWEITERUNG)

**Was Caveman macht:** Python-basierter Kompressor mit Validation (Headings, Code-Blocks, URLs preserved). `caveman-compress/scripts/` mit detect.py, compress.py, validate.py, benchmark.py.

**Unsere Lücke:** token-optimizer analysiert und empfiehlt, komprimiert aber nicht automatisch. Kein Validation-Framework für komprimierte Files.

**Gap:** Automatische Kompression + Validation fehlt. Der Ansatz (Python + Claude API für Kompression, lokale Validation) ist elegant.

**Aufwand:** Mittel — Python-Dependency ist für unser Bash-basiertes Projekt problematisch. Müsste als Shell + Claude -p reimplementiert werden.

**Empfehlung:** Pattern adaptieren (backup → compress → validate → retry), aber in Shell/Claude-CLI statt Python implementieren.

### 3. Inter-Hook State via Flag File (PATTERN)

**Was Caveman macht:** `~/.claude/.caveman-active` als Bridge zwischen SessionStart (schreibt), UserPromptSubmit (schreibt Mode), Statusline (liest).

**Unsere Lücke:** Unsere Hooks kommunizieren nicht untereinander. Jeder Hook ist stateless.

**Gap:** Kein shared state zwischen Hooks.

**Aufwand:** Niedrig — simples Flag-File-Pattern.

**Empfehlung:** Adoptieren als generisches Pattern. Nützlich für Feature-Flags, Mode-Tracking, Session-State.

### 4. Eval Harness für Skills (NEU)

**Was Caveman macht:** 3-Arm-Test (baseline/terse/skill), echte LLM-Runs, Snapshots in Git, CI liest ohne API-Calls. Honest delta = skill vs terse, nicht skill vs nothing.

**Unsere Lücke:** Keine messbare Evaluierung unserer Skills. Wir testen ob Scripts laufen (integration tests), nicht ob Skills effektiv sind.

**Gap:** Komplett fehlend. Kein Eval, kein Benchmark, keine Messung.

**Aufwand:** Hoch — braucht API-Key-Management, Snapshot-Infrastruktur, reproduzierbare Runs.

**Empfehlung:** Langfristig wertvoll, aber aktuell zu aufwändig. Als Backlog-Item parken.

### 5. Dynamic Statusline Mode Badge (ERWEITERUNG)

**Was Caveman macht:** Statusline zeigt `[CAVEMAN:ULTRA]` basierend auf Flag File. Farbig, auto-update bei Mode-Wechsel.

**Unsere Lücke:** Statusline existiert, zeigt aber statische Info. Kein dynamischer State.

**Gap:** Dynamic Mode Display fehlt.

**Aufwand:** Niedrig — Flag-File lesen + printf.

**Empfehlung:** Wenn Inter-Hook State (Kandidat 3) kommt, ist das ein schneller Win.

## Patterns zum Adaptieren

### Single Source of Truth + CI Sync
```
skills/caveman/SKILL.md  →  CI syncs to:
  caveman/SKILL.md
  plugins/caveman/skills/caveman/SKILL.md
  .cursor/skills/caveman/SKILL.md
  .windsurf/skills/caveman/SKILL.md
```
Wir haben `templates/` als Source of Truth, aber die Distribution ist manuell via `npx ai-setup`. CI-Sync könnte die Template-Drift-Probleme lösen, die wir in Obs 3668 identifiziert haben.

### Silent-Fail Hook Pattern
```javascript
try { fs.writeFileSync(flagPath, mode); } catch (e) { /* Silent fail */ }
```
Caveman-Hooks crashing blockt nie den Session-Start. Unser `circuit-breaker.sh` macht ähnliches, aber Caveman ist konsequenter: jeder einzelne Filesystem-Zugriff ist try/catch.

### Backup-Before-Modify Pattern
```
CLAUDE.md          ← compressed (active)
CLAUDE.original.md ← human-readable backup
```
Sauberes Pattern für destructive Operations. Wir haben nichts Vergleichbares — unsere Updates überschreiben direkt.

### Intensity Levels als UX-Pattern
```
lite  → professional but tight
full  → classic caveman (default)
ultra → maximum compression
```
Stufensystem statt binary on/off. Übertragbar auf unsere Review-Intensitäten (die wir schon haben) und potentiell auf andere Skills.

## Ranking nach Aufwand/Nutzen

| # | Item | Value | Aufwand | Empfehlung |
|---|------|-------|---------|------------|
| 1 | Output-Token Compression Skill | ★★★★★ | Niedrig | **GO** — als optionaler Skill. Adressiert die größte unberührte Kostenstelle. |
| 2 | Inter-Hook State (Flag File) | ★★★ | Niedrig | **GO** — generisches Pattern, enables 3 und 5. |
| 3 | CLAUDE.md Auto-Compression | ★★★★ | Mittel | **PIVOT** — Pattern ja, aber Shell statt Python. |
| 4 | Dynamic Statusline Badge | ★★ | Niedrig | **GO** — quick win nach 2. |
| 5 | Eval Harness | ★★★★ | Hoch | **BACKLOG** — zu aufwändig für jetzt. |
| 6 | CI Sync Workflow | ★★★ | Mittel | **SKIP** — unser Distribution-Modell (npx) ist anders als Cavemans (repo-local). |
| 7 | Backup-Before-Modify | ★★ | Niedrig | **GO** — in bestehende Update-Logik integrieren. |
