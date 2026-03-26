# Spec 588: Spec-Skills auf <5KB trimmen

> **Spec ID**: 588 | **Created**: 2026-03-26 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal

`spec-validate` (6.1KB), `spec-review` (5.7KB) und `spec-work-all` (5.5KB) auf jeweils <4.5KB trimmen — analog zum spec-work-Trimming (11.5KB → 4.4KB, Spec 585).

## Context

Session-Optimize 2026-03-26: Die 3 größten Skills nach dem Trimming-Pass von gestern. Jeder Trigger lädt ~1.500 Token ins Kontextfenster. spec-work wurde bereits erfolgreich auf 4.4KB reduziert — gleiches Muster anwendbar.

## Steps

- [ ] Step 1: Alle 3 SKILL.md lesen, redundante/verbose Sections identifizieren
- [ ] Step 2: Trimmen nach bewährtem Muster: Debugging-Sections entfernen, Erklärungen auf 1-Zeiler kürzen, Blockquotes kondensieren
- [ ] Step 3: Größe vor/nach pro Datei dokumentieren
- [ ] Step 4: Template-Kopien in `templates/skills/` synchronisieren

## Acceptance Criteria

- [ ] Alle 3 Skills unter 4.5KB
- [ ] Kernfunktionalität erhalten (Steps, Workflow, Output-Format)
- [ ] Template-Versionen synchron
- [ ] Frontmatter unverändert
