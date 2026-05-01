# Developer Workflow Guide

Dieses Setup macht Claude Code zum strukturierten Entwicklungswerkzeug statt einer Chat-Box. Statt "mach mal Feature X" gibt es einen klaren Prozess: Idee bewerten, Plan erstellen, ausfuehren, reviewen, committen. Jeder Schritt ist ein Slash-Command, jede Aenderung nachvollziehbar.

**Was laeuft automatisch im Hintergrund:**

- **Hooks + Settings** verhindern typische Fehler: Hooks geben Warnungen oder blocken riskante Edits, waehrend `permissions.deny` in `settings.json` harte Read-Blocks fuer Build-Output, Secrets und andere teure Dateien setzt
- **Context-Dateien** geben Claude sofort Wissen ueber Stack, Architektur und Conventions — ohne jedes Mal erklaeren zu muessen
- **Prep-Scripts** sammeln Daten in Shell bevor Claude sie sieht — spart 60-90% Tokens

**Was das bringt:** Konsistente Code-Qualitaet ueber das Team, nachvollziehbare Specs statt ad-hoc Aenderungen, automatische Sicherheitsnetze die greifen bevor etwas kaputt geht.

---

## Quick Start

```bash
claude                # Claude Code im Projekt oeffnen
/index                # 1x nach Setup: Context + Graph + Manifest bauen
/spec-board           # aktive Specs anzeigen
```

---

## Workflow Diagramm (Default-Pfade)

```
[neues Projekt]
      │
      ▼
  npx ai-setup
      │
      ▼
   /index ────────► .agents/context/ + graph.json + manifest
      │
      │  (Session-Start: Stale-Hook checkt Manifest)
      │
      ▼
┌─────────────────────────────────────┐
│  Task einschätzen                   │
└─────────────────────────────────────┘
      │
      ├─ klein  ─► [edit] ─► /test ─► /review ─► /commit
      │
      ├─ mittel ─► /explore ─► [edit] ─► /test ─► /review ─► /commit
      │
      └─ groß   ─► /explore ─► /spec ─► /spec-work ─► /review --spec ─► /commit
                                            │
                                            └─► (intern: /test, delegation)
```

### Default-Skills (7)

| Skill        | Zweck                                                   | Wann                                                      |
| ------------ | ------------------------------------------------------- | --------------------------------------------------------- |
| `/index`     | Context + Graph + Manifest bauen/refreshen              | 1x initial, bei Stale-Warning, nach Major-Changes         |
| `/explore`   | Read-only Code-Verständnis, Patterns, Tradeoffs (haiku) | Vor Edit wenn Bereich unbekannt; vor Spec bei Scope-Frage |
| `/spec`      | Plan für 3+ Files / neue Dep / Arch-Change              | Vor Code bei mittleren/großen Tasks                       |
| `/spec-work` | Spec abarbeiten, delegiert an implementer/bash-runner   | Nach `/spec` bis ACs grün                                 |
| `/review`    | Diff-Review (`/review --spec NNN` für Spec-Mode)        | Vor Commit, vor Merge                                     |
| `/test`      | Test-Runner + Failure-Analyse                           | Nach Code-Edits, vor `/review`                            |
| `/commit`    | Stagen + Conventional Commit                            | Wenn Review grün                                          |

### Opt-in Skills (Power-User)

`/research` (Context7-Lookup), `/challenge` (Red-Team), `/graphify` (semantischer Graph), `/discover` (Spec aus Code), `/orchestrate` (Codex/Gemini), `/agent-browser` (Visual-Check).

Direkt aufrufbar, aber aus Default-Routing raus.

---

## Onboarding

Einmalig ausfuehren wenn du in eine neue Codebase einsteigst oder ein groesseres Vorhaben planst.

| Command            | Was es tut                                                                                                                             | Wann nutzen                                                                  |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `/analyze`         | Parallele Agents analysieren die Codebase, erzeugen PATTERNS.md (Architektur-Patterns) und AUDIT.md (Hotspots, Risks, Recommendations) | Direkt nach Erstinstallation und wenn sich die Codebase stark veraendert hat |
| `/explore "topic"` | Read-Only Thinking Partner — Codebase erkunden, Tradeoffs aufzeigen, ASCII-Diagramme. Aendert keine Dateien                            | Wenn du verstehen willst wie etwas funktioniert, ohne Code anzufassen        |
| `/research "tool"` | Deep-Research eines externen Repos/Tools/Patterns, produziert Brainstorm-Dokument                                                      | Bevor ein neues Tool oder Pattern eingefuehrt wird                           |
| `/discover`        | Reverse-Engineer Draft-Specs aus existierendem Code                                                                                    | Wenn es Features ohne Spec gibt und du den Stand dokumentieren willst        |

Context on-demand laden: `@.agents/context/STACK.md` (oder `ARCHITECTURE.md`, `CONVENTIONS.md`) direkt im Prompt.

---

## Development Cycle

Der Standard-Ablauf fuer jede Aenderung die mehr als ein einzelnes File betrifft. Specs sorgen dafuer, dass Claude einen Plan hat bevor es Code schreibt — das verhindert Scope Creep und macht Aenderungen reviewbar.

### Der Ablauf

```
1. /spec "task description"       ← Plan + Struktur-Check + User-Review (Plan-Mode-aligned)
2. /spec-work NNN                 ← Schritt fuer Schritt ausfuehren
3. /test                          ← Tests laufen lassen + Failures fixen
4. /review                        ← Uncommitted Changes reviewen
5. /commit                        ← Stagen + Conventional Commit Message
6. /pr                            ← PR-Titel/Body + Build-Validation
```

**Spec-Lifecycle:** `draft` → `in-progress` → `in-review` → `completed`

Fuer kleine Aenderungen (Typo, Config, einzelnes File) direkt mit Schritt 4-6 starten — kein Spec noetig.

### Wo anfangen?

```
Neue Idee oder Feature?
├── Einfach (1-2 Files, klarer Scope) → /spec direkt
├── Komplex oder unklar → /challenge zuerst → dann /spec
├── Externes Tool/Repo evaluieren → /research
└── Frei erkunden (kein Urteil) → /explore
```

### Spec Commands

| Command              | Was es tut                                                                |
| -------------------- | ------------------------------------------------------------------------- |
| `/spec "task"`       | Komplexitaet einschaetzen, Spec erstellen, Struktur-Check + User-Approval |
| `/spec-work NNN`     | Spec Schritt fuer Schritt ausfuehren, ohne Commits waehrend der Umsetzung |
| `/spec-work-all`     | Alle Draft-Specs parallel in isolierten Git Worktrees ausfuehren          |
| `/review --spec NNN` | Review gegen Acceptance Criteria + Finishing Gate                         |
| `/spec-board`        | Kanban-Board aller Specs                                                  |

### Code Quality

| Command   | Was es tut                                                         |
| --------- | ------------------------------------------------------------------ |
| `/test`   | Tests laufen lassen + Failures fixen (bis zu 3 Versuche)           |
| `/review` | Uncommitted Changes reviewen (Quick Scan / Standard / Adversarial) |

Schnelle Zero-Token-Checks: `! bash .claude/scripts/lint-prep.sh` bzw. `test-prep.sh`, `ci-prep.sh`, `quality-gate.sh`.

### Build & Deploy

| Command   | Was es tut                                            |
| --------- | ----------------------------------------------------- |
| `/commit` | Stagen + Conventional Commit Message generieren       |
| `/pr`     | PR-Titel/Body draften, Build-Validation laufen lassen |
| `/ci`     | CI-Status via `gh pr checks` / `gh run list` pruefen  |

### Debugging & Planung

| Command               | Was es tut                                                       |
| --------------------- | ---------------------------------------------------------------- |
| `/challenge "idea"`   | Schnelles Critical Gate — GO/SIMPLIFY/REJECT vor Spec-Investment |
| `/research "tool"`    | Deep-Research eines externen Tools/Repos/Patterns                |
| `/explore "topic"`    | Read-Only Thinking Partner — keine Dateiaenderungen              |
| `/orchestrate "task"` | Task an Gemini oder Codex CLI delegieren                         |
| `/analyze`            | Parallele Agents — PATTERNS.md + AUDIT.md erzeugen               |
| `/discover`           | Reverse-Engineer Draft-Specs aus existierendem Code              |

Fuer Bug-Investigation: `! bash .claude/scripts/debug-prep.sh` sammelt Git-Diff, jungste Logs und Test-Status in einem Shot.

---

## Hotfix Flow

Fuer Production-Bugs die den normalen Spec-Cycle umgehen.

```
! bash .claude/scripts/debug-prep.sh   # Context in Shell sammeln
/test                                  # Fix mit Tests verifizieren
/commit                                # Conventional Commit: fix(scope): description
/pr                                    # Fast-Track PR
```

Kein Spec noetig — Debug-Prep liefert das Untersuchungsprotokoll.

---

## Session Management

| Command             | Was es tut                                                                                |
| ------------------- | ----------------------------------------------------------------------------------------- |
| `/reflect`          | Session-Learnings als permanente Regeln speichern. Nach langen Sessions (>30 Tool Calls). |
| `/claude-changelog` | CHANGELOG automatisch pflegen auf Basis der Commits.                                      |
| `/yolo`             | Fast-Execution-Modus mit minimalem Review — nur fuer klare, lokale Aenderungen.           |

ai-setup Update: `npx github:onedot-digital-crew/npx-ai-setup` erneut ausfuehren — interaktives Menue (Update/Regenerate/Reset).

---

## Permission Governance

Dieses Setup unterscheidet bewusst zwischen Repo-Baseline und Operator-Entscheidungen.

- **Projekt-Baseline**: `.claude/settings.json` im Repo. Das ist die teamfaehige Standard-Policy.
- **Workstation-Settings**: `~/.claude/settings.json`. Das sind lokale Operator- oder Maschinenentscheidungen.
- **Hooks**: lokale Warn- und Safety-Netze
- **`permissions.deny`**: harte technische Read-/Command-Blocks

Permission-Modes sind keine versteckten Defaults:

- `default` und `plan` sind die sichere Standard-Empfehlung
- `acceptEdits` ist eine bewusste Komfortentscheidung fuer trusted lokale Arbeit
- `dontAsk` ist eine lokale Power-User-Entscheidung, nicht der Team-Baseline-Mode
- `auto` und `bypassPermissions` sind fortgeschrittene Betriebsmodi fuer klar verstandene Umgebungen

---

## Session Continuity

Cross-session context wird ueber claude-mem (Observations/Decisions) persistent gespeichert. Spec-Markdown in `specs/*.md` bleibt die fachliche Source of Truth fuer Fortschritt und Acceptance Criteria.

---

## Context-Dateien

In `.agents/context/` — automatisch beim Setup generiert, committed, teamweit geteilt. Claude kennt dadurch euren Stack und eure Conventions von der ersten Session an.

| Datei             | Inhalt                                                                            | Erzeugt durch                    |
| ----------------- | --------------------------------------------------------------------------------- | -------------------------------- |
| `SUMMARY.md`      | Tiered-Summary aus STACK/ARCHITECTURE/AUDIT — via `@-import` in CLAUDE.md geladen | `build-summary.sh` (automatisch) |
| `STACK.md`        | Tech Stack, Versionen, Key Dependencies                                           | Setup (automatisch)              |
| `ARCHITECTURE.md` | Systemarchitektur und Datenfluesse                                                | Setup (automatisch)              |
| `CONVENTIONS.md`  | Naming Patterns, Coding Standards, Testing                                        | Setup (automatisch)              |
| `PATTERNS.md`     | Wiederverwendbare Code-Patterns, Module Boundaries                                | `/analyze` (manuell)             |
| `AUDIT.md`        | Hotspots, Risks, Recommendations                                                  | `/analyze` (manuell)             |

Regenerieren: `npx @onedot/ai-setup` → **Regenerate** → **Context**.
PATTERNS/AUDIT regenerieren: `/analyze` ausfuehren.

---

## Tips

| Shortcut                    | Was es tut                                                                                                                                         |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Esc Esc`                   | Letzte Antwort zurueckspulen (Tokens zurueckgewinnen)                                                                                              |
| `! git status`              | Bash-Command direkt ausfuehren (kein Token-Overhead)                                                                                               |
| `@src/index.ts`             | Datei kompakt in den Kontext importieren                                                                                                           |
| `ultrathink:`               | Prefix fuer Extended Reasoning                                                                                                                     |
| `/compact`                  | Kontext komprimieren (eingebauter Claude Code Command, kein Skill)                                                                                 |
| `/`                         | Autocomplete fuer alle verfuegbaren Commands                                                                                                       |
| `defuddle parse <url> --md` | Web-Seiten in Markdown holen (~80% weniger Tokens als WebFetch). Hook `tool-redirect.sh` blockt WebFetch automatisch wenn defuddle verfuegbar ist. |

---

## Troubleshooting

**Claude editiert dieselbe Datei in einer Endlosschleife?**
Circuit-Breaker greift nach 3 Edits. Stop, Problem anders beschreiben.

**Kontext ist nach langer Session veraltet?**
`Esc Esc` zum Komprimieren, oder `/clear` + neue Session.

**Spec-Schritte nach Crash teilweise abgehakt?**
`/spec-work NNN` erneut ausfuehren — erkennt `[x]` Schritte und setzt beim ersten offenen fort.

**Wer blockt eigentlich was?**
`permissions.deny` in `.claude/settings.json` blockt harte Reads wie `.env*`, `dist/` oder Lockfiles. Hooks wie `protect-files.sh` und `circuit-breaker.sh` sind dagegen lokale Sicherheitsnetze fuer Edit-Flows, Warnings und Runtime-Hinweise.

**Command nicht gefunden?**
`/` in Claude Code tippen fuer Autocomplete, oder in `.claude/skills/` schauen.

**Sandbox blockt Pre-Commit Hook?**
Manuell committen: `! git commit -m "msg"`

---

## Dev Workflow (npx-ai-setup Repo)

Beim Arbeiten am ai-setup Repo selbst gilt: `templates/` ist Single Source of Truth. `.claude/` ist generierter Mirror.

```bash
bash bin/sync-local.sh           # Templates → repo-local Mirror
bash bin/sync-local.sh --check   # Drift-Check (CI/quality-gate)
bash bin/sync-local.sh --prune   # Orphans entfernen
```

Niemals `.claude/{agents,hooks,rules,scripts,docs,skills}` direkt editieren — naechster Sync ueberschreibt. Marketplace-Skills (agent-browser, gh-cli, orchestrate, bash-defensive-patterns) bleiben unberuehrt.

---

_Installiert von `@onedot/ai-setup`. Wird nicht automatisch in den Claude-Kontext geladen._
