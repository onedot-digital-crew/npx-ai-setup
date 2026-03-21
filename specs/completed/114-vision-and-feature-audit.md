# Spec: CONCEPT.md erweitern und Feature-Audit durchführen

> **Spec ID**: 114 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

## Goal
CONCEPT.md um strategische Grenzen erweitern und alle Features gegen diese Grenzen kategorisieren (Core / Extended / Remove).

## Context
npx-ai-setup ist von einem "one-command setup tool" zu einem Meta-Development-Framework gewachsen (6K LOC, 21 Commands, 112 Specs). CONCEPT.md beschreibt gut *was* das Tool ist, aber nicht *wo die Grenze liegt*. Fehlende Anti-Principles und Scope-Grenzen haben dazu geführt, dass jede gute Idee gebaut wurde. Internes Steuerungsdokument für Denis + Claude.

## Steps
- [ ] Step 1: CONCEPT.md erweitern — drei neue Sections: "What This Is NOT" (Anti-Principles), "Scope Boundaries", "Decision Heuristic" (wenn X, dann nicht bauen)
- [ ] Step 2: Alle 21 Commands in `templates/commands/` gegen Scope-Grenzen kategorisieren → Core / Extended / Remove
- [ ] Step 3: System-Plugins (`lib/systems/`), Template-Skills (`templates/skills/`), Lib-Module (13 Dateien) kategorisieren
- [ ] Step 4: Alle 14 Projekt-Dokumentationsdateien (.md) prüfen — stimmen sie noch mit der erweiterten CONCEPT.md überein? Redundanzen, Widersprüche, veraltete Inhalte markieren
- [ ] Step 5: Audit-Ergebnis als `AUDIT.md` dokumentieren mit Kategorisierung und konkreten Empfehlungen (Features + Docs)

## Acceptance Criteria
- [ ] CONCEPT.md hat klare Anti-Principles und Scope-Grenzen
- [ ] Jedes Feature (Commands, Skills, Plugins, Module) ist kategorisiert
- [ ] AUDIT.md enthält priorisierte Empfehlungen für Vereinfachung
- [ ] Keine Features werden gelöscht — nur kategorisiert

## Files to Modify
- `.agents/context/CONCEPT.md` - Anti-Principles, Scope-Grenzen, Decision Heuristic
- `AUDIT.md` (neu) - Feature-Kategorisierung und Empfehlungen
- Alle 14 Projekt-.md-Dateien — prüfen und ggf. anpassen (README, CLAUDE.md, AGENTS.md, BACKLOG.md, CHANGELOG.md, STACK.md, ARCHITECTURE.md, CONVENTIONS.md, DESIGN-DECISIONS.md, agent-dispatch.md, rules/*.md, hooks/README.md)

## Out of Scope
- Tatsächliches Entfernen oder Umbauen von Features (separate Specs)
- Endnutzer-Dokumentation oder README-Änderungen
- Änderungen am Installationsablauf
