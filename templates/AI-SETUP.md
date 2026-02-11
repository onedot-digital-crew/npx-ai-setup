# AI Setup: GSD + Lean Memory Bank

Dieses Setup automatisiert die AI-Konfiguration fuer Projekte mit Claude Code und GitHub Copilot.
Ein Script erstellt die komplette Infrastruktur, Claude analysiert danach den Code und befuellt alles automatisch.

## Was macht was?

| Komponente | Funktion |
|-----------|----------|
| **setup-ai.sh** | Erstellt Ordnerstruktur, Permissions, Hooks, installiert GSD Skill, startet Claude Auto-Init |
| **Memory Bank** | 2 Dateien mit Projekt-Wissen: Tech Stack (`projectbrief.md`) + Coding Patterns (`systemPatterns.md`) |
| **GSD** | Workflow-Engine fuer Features: Plan → Execute → Verify. State in `.planning/` |
| **CLAUDE.md** | Projekt-Regeln die Claude bei jeder Session liest (Commands, Critical Rules) |
| **Hooks** | Auto-Lint, File Protection, Circuit Breaker (erkennt Endlosschleifen) |
| **Init-Prompt** | Claude liest den Code, befuellt Memory Bank + CLAUDE.md + sucht passende Skills |

## Architektur

```
GSD (.planning/)          = Prozess (plan → execute → verify)
Memory Bank (memory-bank/) = Wissen (Patterns, Tech Stack)
CLAUDE.md                  = Regeln (Critical Rules, Workflow)
```

---

## Requirements

- **Node.js** >= 18
- **npm** (fuer `npx`)
- **jq** (fuer Hooks, JSON-Parsing) - `brew install jq`
- **Claude Code CLI** (`claude`) - fuer Auto-Init (optional, Copilot als Fallback)
- **Shopify CLI** (optional, fuer `shopify theme check`)

---

## Setup (neues Projekt)

### 1. Script ausfuehren

```bash
npx @onedot/ai-setup
```

Erstellt automatisch:
- `memory-bank/` (Project Brief + System Patterns)
- `CLAUDE.md` (AI Regeln + Critical Rules)
- `.claude/settings.json` (Permissions + Hooks)
- GSD (project-lokal in `.claude/commands/gsd/`)
- Copilot Instructions, GSD Companion Skill
- Auto-Init (Claude analysiert Code, befuellt Memory Bank)

### 2. GSD Projekt initialisieren (interaktiv)

```
/gsd:new-project
```

Stellt Fragen zum Projekt und erstellt `.planning/PROJECT.md`.

---

## Taeglicher Workflow

| Schritt | Command | Beschreibung |
|---------|---------|-------------|
| Planen | `/gsd:plan-phase N` | Research + Plan erstellen |
| Bauen | `/gsd:execute-phase N` | Code schreiben, Hooks laufen automatisch |
| Pruefen | `/gsd:verify-work N` | User Acceptance Testing |
| Pause | `/gsd:pause-work` | Handoff-Dokument erstellen |
| Weiter | `/gsd:resume-work` | Kontext wiederherstellen |
| Status | `/gsd:progress` | Wo bin ich? Naechste Aktion? |

---

## GSD Command Referenz

### Kern-Workflow

| Command | Beschreibung |
|---------|-------------|
| `/gsd:plan-phase N` | Phase planen (Research + Plan erstellen) |
| `/gsd:execute-phase N` | Phase ausfuehren (Code schreiben) |
| `/gsd:verify-work N` | User Acceptance Testing |
| `/gsd:pause-work` | Session unterbrechen (Handoff erstellen) |
| `/gsd:resume-work` | Session fortsetzen (Kontext wiederherstellen) |
| `/gsd:progress` | Status anzeigen, naechste Aktion vorschlagen |
| `/gsd:quick` | Schnelle Aufgabe mit GSD-Garantien (atomic commits) |
| `/gsd:debug` | Systematisches Debugging mit persistentem State |

### Projekt & Roadmap

| Command | Beschreibung |
|---------|-------------|
| `/gsd:new-project` | Neues Projekt initialisieren (interaktiv) |
| `/gsd:map-codebase` | Codebase analysieren (autonom) |
| `/gsd:add-phase` | Phase am Ende der Roadmap anfuegen |
| `/gsd:insert-phase` | Dringende Phase einfuegen (z.B. 3.1) |
| `/gsd:remove-phase` | Phase entfernen und neu nummerieren |
| `/gsd:discuss-phase` | Kontext sammeln vor dem Planen |
| `/gsd:add-todo` | Todo aus Gespraech erfassen |
| `/gsd:check-todos` | Offene Todos anzeigen |

### Milestones & System

| Command | Beschreibung |
|---------|-------------|
| `/gsd:new-milestone` | Neuen Milestone starten |
| `/gsd:complete-milestone` | Milestone abschliessen und archivieren |
| `/gsd:audit-milestone` | Milestone vor Abschluss pruefen |
| `/gsd:help` | Alle Commands anzeigen |
| `/gsd:settings` | GSD konfigurieren |
| `/gsd:update` | GSD auf neueste Version aktualisieren |

---

## Dateistruktur

```
projekt/
+-- memory-bank/
|   +-- projectbrief.md      # North Star (write-protected)
|   +-- systemPatterns.md     # Coding Patterns
+-- .planning/                # GSD State (automatisch)
|   +-- PROJECT.md
|   +-- ROADMAP.md
|   +-- STATE.md
+-- .claude/
|   +-- settings.json         # Permissions + Hooks
|   +-- init-prompt.md        # Init-Prompt Template
|   +-- hooks/
|       +-- protect-files.sh    # Schuetzt .env, projectbrief.md
|       +-- post-edit-lint.sh  # Auto-Lint nach Edit
|       +-- circuit-breaker.sh # Erkennt Endlosschleifen
+-- .github/
|   +-- copilot-instructions.md
+-- CLAUDE.md                 # AI Regeln + Critical Rules
+-- AI-SETUP.md               # Diese Dokumentation
```

---

## Sicherheit

| Geschuetzt | Warum |
|-----------|-------|
| `.env` | Secrets |
| `package-lock.json` | Dependency Integrity |
| `.git/` | Repository History |
| `memory-bank/projectbrief.md` | North Star, nur manuell aendern |

`systemPatterns.md` ist **nicht** geschuetzt - Claude soll Patterns aktualisieren koennen.

---

## Permissions

Settings.json nutzt **granulare Bash-Permissions** statt `Bash(*)`:

- Erlaubt: `git add/commit/status/log/diff/tag`, `npm run`, `eslint`, `cat/ls/grep/...`
- Blockiert: `git push`, `rm -rf`, `.env` lesen

Fuer maximale Autonomie: `claude --dangerously-skip-permissions`

---

## FAQ

**Memory Bank vs. GSD - was ist der Unterschied?**
GSD = Prozess (was tun wir als naechstes?). Memory Bank = Wissen (wie coden wir hier?).

**Muss ich memory-bank/ manuell pflegen?**
Nein. Der Init-Prompt befuellt sie. `systemPatterns.md` wird von Claude bei Bedarf aktualisiert.

**Was passiert bei `git pull` mit `.planning/`?**
`.planning/` ist committed. Bei Merge-Konflikten: GSD State ist pro-Entwickler, im Zweifel eigene Version behalten.

**Kann ich Skills nachinstallieren?**
Ja: `npx skills find <query>` zeigt verfuegbare Skills.
`npx skills add <owner/repo@skill> --agent claude-code --agent github-copilot -y` installiert sie.

**Claude CLI vs. Copilot CLI?**
Das Script erkennt automatisch welches AI CLI installiert ist. Claude bekommt Auto-Init, Copilot bekommt manuelle Anweisungen.

---

## Weiterfuehrende Dokumentation

- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Code Hooks](https://docs.anthropic.com/en/docs/claude-code/hooks)
- [CLAUDE.md Best Practices](https://docs.anthropic.com/en/docs/claude-code/memory)
- [GSD (Get Shit Done)](https://github.com/get-shit-done-cc/get-shit-done-cc)
- [Skills CLI](https://github.com/anthropics/skills)
