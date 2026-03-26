# Spec 590: apply-learnings Mapping-Tabelle erweitern

> **Spec ID**: 590 | **Created**: 2026-03-26 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal

CLAUDE.md als Target für Process- und CLI-Kategorien in der apply-learnings Mapping-Tabelle ergänzen. Aktuell fallen diese Kategorien durch zum User-Fallback.

## Context

Code-Review #25044: `/reflect` klassifiziert Learnings in Kategorien wie Process, CLI, Workflow. Die Mapping-Tabelle in apply-learnings routet diese nicht zu CLAUDE.md, obwohl das der richtige Target ist. Silent Failure — Learnings gehen nicht verloren, aber der User muss manuell entscheiden.

## Steps

- [ ] Step 1: apply-learnings/SKILL.md lesen, aktuelle Mapping-Tabelle analysieren
- [ ] Step 2: Process → CLAUDE.md und CLI → CLAUDE.md als Mappings ergänzen
- [ ] Step 3: Template-Version in `templates/skills/apply-learnings/` synchronisieren

## Acceptance Criteria

- [ ] Process- und CLI-Kategorien routen zu CLAUDE.md
- [ ] Bestehende Mappings unverändert
- [ ] Template-Version synchron
