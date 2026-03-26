# Spec 586: agent-browser/SKILL.md auf Kern-Workflow trimmen

> **Spec ID**: 586 | **Created**: 2026-03-25 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal

`agent-browser/SKILL.md` von 686 Zeilen (26KB, ~6.500 Token) auf ~60–80 Zeilen kürzen — ohne Funktionsverlust, da alles Weitere via `agent-browser --help` erreichbar ist.

## Context

Token-Analyse 2026-03-25: agent-browser ist das größte Skill-File im Projekt (26KB), 6× größer als das nächstgrößte. Jede Trigger-Auslösung lädt alle 6.500 Token ins Kontextfenster. Das File enthält ein vollständiges Reference-Manual (iOS Simulator, Lightpanda Engine, JSON Policy-Schemas, Ready-to-Use Templates, Deep-Dive Docs) — Inhalte, die explizit gegen das CLAUDE.md-Prinzip "Token-Budget > Vollständigkeit" und "Keine Code-Block-Tutorials — nur das Nötigste, was nicht via `--help` nachschlagbar ist" verstoßen.

## Steps

- [ ] Step 1: Aktuelle `agent-browser/SKILL.md` lesen, Kern-Sections identifizieren (Core Workflow, Essential Commands, 2–3 häufigste Patterns)
- [ ] Step 2: File auf ~70 Zeilen trimmen — Struktur:
  - Frontmatter (unverändert)
  - Install + Core Workflow (open → snapshot -i → interact via @ref)
  - Essential Commands (kompakte Tabelle, max 15 Einträge)
  - 3 Common Patterns: Form Submit, Auth, Data Extraction
  - Hinweis: `agent-browser --help` für vollständige Referenz
- [ ] Step 3: Sections entfernen: iOS Simulator, Lightpanda Engine, Deep-Dive Docs, Configuration File JSON, Ready-to-Use Templates, Diffing, Annotated Screenshots, Semantic Locators, JavaScript Evaluation, Parallel Sessions, Session Management (~20 Sections)
- [ ] Step 4: Größe vor/nach vergleichen und dokumentieren

## Acceptance Criteria

- [ ] `agent-browser/SKILL.md` unter 100 Zeilen
- [ ] Kern-Workflow (open → snapshot → @ref) vollständig erhalten
- [ ] Kein Inhalt entfernt der NICHT via `--help` oder Docs nachschlagbar ist
- [ ] Frontmatter (description, allowed-tools) unverändert

## Files to Modify

- `.claude/skills/agent-browser/SKILL.md` — kürzen

## Out of Scope

- Änderungen an der Skill-Beschreibung oder Trigger-Keywords
- Änderungen an anderen Skills
