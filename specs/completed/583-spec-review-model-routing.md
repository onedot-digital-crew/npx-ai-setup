# Spec 583: spec-review Agent-Spawning ohne explizites Model

> **Spec ID**: 583 | **Created**: 2026-03-25 | **Status**: in-review | **Complexity**: low | **Branch**: —

## Goal

`spec-review` soll code-reviewer und staff-reviewer Agents explizit mit `model: sonnet` spawnen, statt das Model offen zu lassen.

## Context

Session-Optimize-Analyse (2026-03-25): Session 936b13f2 (35min) lief 54% auf Opus (50/92 Turns) mit Skill spec-review. Das Skill hat `disable-model-invocation: true` und kein `model:` auf den Agent-Spawns in Step 5c — Agents erben das Session-Modell oder System-Default, was bei Opus-Sessions teuer wird. Review-Agents sind keine Architektur-Analyse sondern Code-Prüfung → Sonnet ausreichend.

## Steps

- [x] Step 1: `model: sonnet` zu code-reviewer Agent-Spawn in Step 5c hinzufügen
- [x] Step 2: `model: sonnet` zu staff-reviewer Agent-Spawn in Step 5c hinzufügen

## Acceptance Criteria

- [x] Beide Agent-Spawns in Step 5c enthalten explizites `model: sonnet`
- [x] Kein `model: opus` in der Datei

## Files to Modify

- `templates/skills/spec-review/SKILL.md` — model: sonnet zu beiden Agent-Spawns

## Out of Scope

- Änderungen an der Review-Logik oder Acceptance-Criteria-Prüfung
- Andere Skills als spec-review
