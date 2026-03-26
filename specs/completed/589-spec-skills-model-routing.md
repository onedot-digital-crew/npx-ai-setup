# Spec 589: Model-Routing in Spec-Skills ergänzen

> **Spec ID**: 589 | **Created**: 2026-03-26 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal

Explizite `model:` Direktiven für Agent-Spawns in spec-validate, spec-review, spec-work-all und spec ergänzen. Verhindert Opus-Vererbung in Opus-Sessions.

## Context

Session-Optimize 2026-03-26: Alle 4 Skills haben `disable-model-invocation: true` aber keine `model:` Direktiven im Body. In Opus-Sessions erben Subagents das Opus-Model — 5× zu teuer. spec-work hat bereits `model: sonnet` als Referenz.

## Steps

- [ ] Step 1: spec-work/SKILL.md lesen — Model-Routing-Pattern als Vorlage extrahieren
- [ ] Step 2: In allen 4 Skills Agent-Spawn-Stellen identifizieren
- [ ] Step 3: `model: sonnet` (oder `model: haiku` wo passend) an jede Agent-Spawn-Stelle ergänzen
- [ ] Step 4: Template-Kopien in `templates/skills/` synchronisieren

## Acceptance Criteria

- [ ] Alle 4 Spec-Skills haben explizite `model:` Direktiven bei Agent-Spawns
- [ ] Haiku für reine Search/Explore-Agents, Sonnet für Code-Review/Generation
- [ ] Template-Versionen synchron
