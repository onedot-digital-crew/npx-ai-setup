# Developer Workflow Guide

Dieses Setup macht Claude Code zum strukturierten Entwicklungswerkzeug statt einer Chat-Box. Jede Codeaenderung laeuft durch einen definierten Prozess: Plan erstellen, ausfuehren, reviewen, committen. Hooks verhindern automatisch typische Fehler (Endlosschleifen, Lock-File-Edits, Build-Output-Aenderungen), und Context-Dateien geben Claude das Wissen ueber euren Stack, eure Architektur und eure Conventions.

**Was das bringt:** Konsistente Code-Qualitaet ueber das gesamte Team, nachvollziehbare Specs statt ad-hoc Aenderungen, und automatische Sicherheitsnetze die greifen bevor etwas kaputt geht.

---

## Quick Start

```bash
claude                # Claude Code im Projekt oeffnen
/spec-board           # aktive Specs anzeigen
/doctor               # Setup-Health pruefen
```

---

## Onboarding

Einmalig ausfuehren wenn du in eine neue Codebase einsteigst.

| Command | Was es tut |
|---------|------------|
| `/explore "topic"` | Codebase erkunden, Tradeoffs aufzeigen (aendert keine Dateien) |
| `/analyze` | Codebase-Uebersicht via paralleler Agents - erzeugt PATTERNS.md und AUDIT.md |
| `/discover` | Draft-Specs aus bestehendem Code reverse-engineeren |
| `/research "tool"` | Externes Repo/Tool/Pattern recherchieren |

---

## Development Cycle

Der Standard-Ablauf fuer jede Aenderung die mehr als ein einzelnes File betrifft. Specs sorgen dafuer, dass Claude einen Plan hat bevor es Code schreibt - das verhindert Scope Creep und macht Aenderungen reviewbar.

```
/spec "task description"       # Komplexitaet einschaetzen, Spec erstellen
/spec-validate NNN             # Spec-Qualitaet pruefen vor Ausfuehrung
/spec-work NNN                 # Schritt fuer Schritt ausfuehren, nach jedem Schritt committen
/test                          # Tests laufen lassen + Failures fixen (bis zu 3 Versuche)
/review                        # Uncommitted Changes reviewen
/commit                        # Stagen + Conventional Commit Message
/pr                            # Build-Validierung + PR-Draft
/release                       # Version bump, CHANGELOG, Tag
```

**Spec-Lifecycle:** `draft` → `in-progress` → `in-review` → `completed`

Parallele Ausfuehrung: `/spec-work-all` fuehrt alle Draft-Specs in isolierten Git Worktrees aus.

### Wo anfangen?

```
Neue Idee oder Feature?
├── Einfach (1-2 Files, klarer Scope) → /spec direkt
├── Komplex oder unklar → /challenge zuerst → dann /spec
├── Externes Tool/Repo evaluieren → /research
└── Frei erkunden (kein Urteil) → /explore
```

### Weitere Commands

| Command | Was es tut |
|---------|------------|
| `/spec-review NNN` | Review gegen Acceptance Criteria + Finishing Gate |
| `/spec-board` | Kanban-Board aller Specs |
| `/debug "description"` | Hypothesen-getriebene Bug-Untersuchung |
| `/build-fix` | Inkrementeller Build-Error-Fixer (max 10 Iterationen) |
| `/lint` | Linter ausfuehren, sichere Violations auto-fixen |
| `/scan` | Security-Vulnerability-Scan (snyk/npm audit/pip-audit) |
| `/techdebt` | End-of-Session Sweep - Dead Code, Unused Imports |
| `/ci` | CI-Status pruefen, naechsten Schritt vorschlagen |
| `/challenge "idea"` | Schnelles Critical Gate - GO/SIMPLIFY/REJECT vor Spec-Investment |

---

## Hotfix Flow

Fuer Production-Bugs die den normalen Spec-Cycle umgehen.

```
/debug "symptom"               # Root Cause isolieren
/test                          # Fix mit Tests verifizieren
/commit                        # Conventional Commit: fix(scope): description
/pr                            # Fast-Track PR
```

Kein Spec noetig - `/debug` Output dient als Untersuchungsprotokoll.

---

## Session Management

| Command | Was es tut |
|---------|------------|
| `/pause` | Session-State speichern, WIP committen |
| `/resume` | State wiederherstellen, naechste Aktion routen |
| `/reflect` | Session-Learnings als permanente Regeln speichern |
| `/doctor` | AI-Setup Health Check |
| `/update` | ai-setup Updates pruefen und installieren |

---

## Context-Dateien

In `.agents/context/` - automatisch generiert, committed, teamweit geteilt. Claude kennt dadurch euren Stack und eure Conventions ohne dass ihr es jedes Mal erklaeren muesst.

| Datei | Inhalt |
|-------|--------|
| `STACK.md` | Tech Stack, Versionen, Key Dependencies |
| `ARCHITECTURE.md` | Systemarchitektur und Datenfluesse |
| `CONVENTIONS.md` | Naming Patterns, Coding Standards, Testing |

Zusaetzlich (via `/analyze`): `PATTERNS.md` (wiederverwendbare Patterns), `AUDIT.md` (Verbesserungspotential).

Regenerieren: `npx @onedot/ai-setup` ausfuehren → **Regenerate** → **Context** waehlen.

---

## Tips

| Shortcut | Was es tut |
|----------|------------|
| `Esc Esc` | Letzte Antwort zurueckspulen (Tokens zurueckgewinnen) |
| `! git status` | Bash-Command direkt ausfuehren (kein Token-Overhead) |
| `@src/index.ts` | Datei kompakt in den Kontext importieren |
| `ultrathink:` | Prefix fuer Extended Reasoning |
| `/compact` | Kontext komprimieren bei 80% Auslastung |

---

## Troubleshooting

**Claude editiert dieselbe Datei in einer Endlosschleife?**
Circuit-Breaker greift nach 3 Edits. Stop, Problem anders beschreiben.

**Kontext ist nach langer Session veraltet?**
`Esc Esc` zum Komprimieren, oder `/pause` + neue Session + `/resume`.

**Spec-Schritte nach Crash teilweise abgehakt?**
`/spec-work NNN` erneut ausfuehren - erkennt `[x]` Schritte und setzt beim ersten offenen fort.

**Build schlaegt nach spec-work fehl?**
`/build-fix` - parsed den ersten Error, fixt minimal, rebuildet, wiederholt.

**Command nicht gefunden?**
`/` in Claude Code tippen fuer Autocomplete, oder in `.claude/skills/` schauen.

**Sandbox blockt Pre-Commit Hook?**
Manuell committen: `! git commit -m "msg"`

---

*Installiert von `@onedot/ai-setup`. Wird nicht automatisch in den Claude-Kontext geladen.*
