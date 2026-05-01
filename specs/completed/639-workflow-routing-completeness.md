# Spec: workflow.md — komplette Skill-Routing-Tabelle

> **Spec ID**: 639 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: small | **Branch**: —

## Goal

`templates/claude/rules/workflow.md` listet nur 8 Skills in der "Suggest"-Tabelle. Die installierten 16 Skills sind sonst unentdeckbar — neue User wissen nicht dass `/research`, `/challenge`, `/explore`, `/agent-browser`, `/spec-review`, `/spec-work-all`, `/graphify`, `/analyze` existieren.

## Context

`ls templates/skills/` zeigt 16 Skill-Verzeichnisse. workflow.md routet nach: test/review/commit/pr/release/spec/spec-work/clear/reflect/analyze (8). Fehlend in Routing: research, challenge, explore, agent-browser, spec-review, spec-work-all, spec-board, graphify.

WORKFLOW-GUIDE.md erwähnt einige — aber das ist Doc, keine Routing-Hint die Claude nach jedem Step ausspielt. Resultat: User benutzen Claude ohne zu wissen dass `/research` existiert; Claude weist nicht selbst auf diese Skills hin.

## Stack Coverage

- **Profiles affected**: alle
- **Per-stack difference**: keine — pure Routing-Doc

## Steps

- [x] Step 1: `templates/claude/rules/workflow.md` — Routing-Tabelle erweitern um folgende Zeilen:
  - "Plan-Phase: externe Lib-/API-Frage" → `/research` — Context7-Lookup mit Doku in Spec
  - "Spec-Draft fühlt sich zu groß / zu vage" → `/challenge` — Skeptik-Pass durch staff-reviewer
  - "Vor Edit: Codebase verstehen, Patterns finden" → `/explore` — Code-Explorer (haiku)
  - "Vue/Liquid/JSX/CSS edited" → `/agent-browser` — visual screenshot
  - "Mehrere Draft-Specs queued" → `/spec-work-all` — Worktree-Batch
  - "Implementation done, vor merge" → `/spec-review` — Diff-Review gegen Spec
  - "Übersicht aller Specs" → `/spec-board`
  - "Codebase-Knowledge-Graph bauen / abfragen" → `/graphify`
- [x] Step 2: `.claude/rules/workflow.md` mirror
- [x] Step 3: Verify mit `ls templates/skills/` — jeder Skill-Ordner muss in der Tabelle vorkommen, außer den Plumbing-Skills die `disable-model-invocation: true` haben (auch dann routen, aber als "User-only" markiert)

## Acceptance Criteria

- [x] Routing-Tabelle hat ≥16 Zeilen (eine pro installierter Skill, ggf. mehrere wenn Skill mehrere Trigger hat)
- [x] `diff <(ls templates/skills/) <(grep -oE '/[a-z-]+' workflow.md | sort -u)` zeigt 0 fehlende Skills
- [x] Bestehende Routing-Hints (test→review→commit→pr) bleiben unverändert

## Files to Modify

- `templates/claude/rules/workflow.md`
- `.claude/rules/workflow.md`

## Out of Scope

- Skills neu schreiben oder kombinieren
- WORKFLOW-GUIDE.md komplett überarbeiten (separates Doc)
- Auto-Invoke-Liste ändern (nur Hint-Tabelle)
