# Spec 591: Model-Routing-Regeln in Templates prüfen und ergänzen

> **Spec ID**: 591 | **Created**: 2026-03-26 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal

Sicherstellen dass die Model-Routing-Regeln aus `agents.md` auch in User-Projekten landen die via ai-setup installiert werden. Haiku-Nutzung liegt bei ~1% über alle Projekte.

## Context

Session-Optimize 2026-03-26: Model-Routing ist in npx-ai-setup selbst konfiguriert (`.claude/rules/agents.md`), aber Haiku wird in installierten Projekten kaum genutzt. Finding offen seit letzter Session. templates/CLAUDE.md hat bereits Model-Routing-Sektion (8 Zeilen, ergänzt 2026-03-26), aber `templates/rules/` muss geprüft werden.

## Steps

- [ ] Step 1: `templates/rules/` lesen — prüfen ob agents.md oder Model-Routing-Regeln enthalten
- [ ] Step 2: `templates/CLAUDE.md` Model-Routing-Sektion verifizieren
- [ ] Step 3: Falls fehlend: kompakte Model-Routing-Regel in `templates/rules/` ergänzen
- [ ] Step 4: lib/install.sh prüfen ob rules/ korrekt kopiert wird

## Acceptance Criteria

- [ ] Installierte Projekte erhalten Model-Routing-Regeln (Haiku default, Sonnet nur für Multi-File)
- [ ] Keine Duplikation zwischen CLAUDE.md und rules/
- [ ] install.sh kopiert rules/ korrekt
