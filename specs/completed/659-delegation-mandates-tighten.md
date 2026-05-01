# Spec: Delegation Mandates schärfen

> **Spec ID**: 659 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: small | **Branch**: —

<!-- depends_on: [654] -->

## Goal

Behalte `bash-runner` und `implementer` als Token-Hebel, aber schärfe ihre Trigger so, dass Claude keine Entscheidungsarbeit zu früh delegiert.

## Context

Opus-Delegation spart Tokens: Haiku ist für read-only Shell deutlich günstiger, Sonnet für bounded Implementierung effizienter. Das Problem ist nicht die Existenz der Agents, sondern zu vage Trigger. Konkrete Regeln:

- `bash-runner` nur bei read-only Bash (`jq`, `grep`, `rg`, `find`, `cat`, `sed`, `awk`, `git diff/log/show/status`) und klarer Extraktionsaufgabe
- Mutationen führt Opus/Main-Agent selbst oder ein klar gebriefter Implementer aus, nie `bash-runner`
- `implementer` nur wenn Spec/Task explizite Files und erwartete Diffs/Änderungen nennt
- Bei "refactor X", unklarem Scope oder Architekturentscheidung bleibt Opus/Main-Agent verantwortlich

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**: none

## Steps

- [ ] Step 1: `templates/claude/rules/agents.md` — Delegation Mandates mit den konkreten Triggern ersetzen
- [ ] Step 2: `templates/agents/bash-runner.md` — "Read-only Bash only" als harte Regel ergänzen; mutierende Commands explizit verweigern
- [ ] Step 3: `templates/agents/implementer.md` — "nur explizite Files + erwartete Änderung" als harte Use-Bedingung ergänzen
- [ ] Step 4: `templates/CLAUDE.md` — Delegation Mandates Kurzfassung aktualisieren
- [ ] Step 5: `.claude/` Mirrors via `bin/sync-local.sh`
- [ ] Step 6: README/WORKFLOW-GUIDE prüfen, keine vagen "≥3 Bash → bash-runner" Regeln ohne Read-only-Einschränkung
- [ ] Step 7: Komplexitäts-Signale für Model-Routing (aus obra/superpowers) in `agents.md` ergänzen: "1-2 Files spec'd → haiku/sonnet, multi-file (3-7) → sonnet, design/arch → opus"; ersetzt vage Trigger-Tabelle

## Acceptance Criteria

- [ ] `bash-runner` Prompt verweigert mutierende Commands (`rm`, `mv`, `git checkout`, `git reset`, redirects to files)
- [ ] `implementer` Prompt verlangt explizite Files und erwartete Änderung
- [ ] `agents.md` enthält die beiden Regeln wörtlich: "bash-runner only for read-only Bash" und "implementer only when files and expected edits are explicit"
- [ ] Keine Doku empfiehlt `bash-runner` für Mutationen
- [ ] `bash .claude/scripts/quality-gate.sh` grün

## Files to Modify

> Nur `templates/` editieren. `.claude/` Mirrors via `bash bin/sync-local.sh` aus Spec 654.

- `templates/claude/rules/agents.md` - Delegation Mandates
- `templates/agents/bash-runner.md` - Trigger/Safety
- `templates/agents/implementer.md` - Trigger/Safety
- `templates/CLAUDE.md` - Kurzfassung
- `CLAUDE.md` (dieses Repo) - Projektkopie
- `README.md`, `WORKFLOW-GUIDE.md` - Docs
- `bash bin/sync-local.sh` nach Template-Edits

## Out of Scope

- `bash-runner` oder `implementer` entfernen
- Neue Delegation-Agents einführen
- Claude Model-Routing grundsätzlich ändern
