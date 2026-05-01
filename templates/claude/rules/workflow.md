---
paths:
  - "**/*.ts"
  - "**/*.js"
  - "**/*.vue"
  - "**/*.sh"
  - "specs/**"
  - ".claude/skills/**"
---

# Workflow Routing

## Skill Hints

After completing work, suggest the logical next skill. Keep hints to one line.

| After this...                                                    | Suggest                                                            |
| ---------------------------------------------------------------- | ------------------------------------------------------------------ |
| Code changes (edit/write)                                        | `/test` — Tests laufen lassen                                      |
| `/test` passes                                                   | `/review` — Changes reviewen                                       |
| `/review` passes                                                 | `/commit` — Stagen + committen                                     |
| `/commit` done                                                   | `/pr` auf Feature-Branches, sonst stop                             |
| Planning a multi-file change (3+ files, new dep, or arch change) | `/spec` — erst planen, dann bauen                                  |
| Plan-Phase: externe Lib-/API-Frage                               | `/research` — Context7-Lookup mit Doku in Spec                     |
| Spec-Draft fuehlt sich zu gross / zu vage                        | `/challenge` — Skeptik-Pass durch staff-reviewer                   |
| Vor Edit: Codebase verstehen, Patterns finden                    | `/explore` — Code-Explorer (haiku)                                 |
| Spec erstellt (Status: draft)                                    | `/spec-work NNN` — Spec implementieren                             |
| Mehrere Draft-Specs queued                                       | `/spec-work-all` — Worktree-Batch                                  |
| Implementation done, vor merge                                   | `/review --spec NNN` — Diff-Review gegen Spec                      |
| Uebersicht aller Specs                                           | `/spec-board` — Kanban-Board der Specs                             |
| Spec erstellt oder abgeschlossen                                 | `/clear` — Session leeren, Kontext-Bleed vermeiden                 |
| Session >30 tool calls                                           | `/reflect` — Learnings sichern, dann `/clear`                      |
| Vue/Liquid/JSX/CSS edited                                        | `/agent-browser` — visual screenshot                               |
| Build failure                                                    | `! bash .claude/scripts/ci-prep.sh` dann manuell fixen             |
| Codebase-Knowledge-Graph bauen / abfragen                        | `/graphify` — semantischen Graph bauen oder abfragen               |
| Frisch geklontes Projekt / Context fehlt / Manifest stale        | `/index` — stack-aware Context + Graph + Manifest bauen            |
| Viele neue Dateien committed (>5)                                | `/index --refresh` — Artefakte neu bauen, dann optional `/analyze` |
| Editing this repo's `templates/`                                 | `bash bin/sync-local.sh` — Mirror in `.claude/` aktualisieren      |

## When to Auto-Invoke Skills

Claude MAY invoke these skills programmatically (via Skill tool) when the context clearly calls for it:

- `/spec-work NNN` — after context compaction when the active spec is known
- `/spec-board` — when user asks for spec overview

**User-only skills** (`disable-model-invocation: true`) — NEVER invoke via Skill tool, only suggest:

- `/commit`, `/reflect`

Claude SHOULD NOT auto-invoke without user intent:

- `/pr` — always confirm first
- `/spec` — only when user explicitly wants a spec

## Hint Format

After completing a step, append one line:

```
> Naechster Schritt: `/command` — kurze Beschreibung
```

Do not stack multiple hints. Pick the single most relevant next action.
