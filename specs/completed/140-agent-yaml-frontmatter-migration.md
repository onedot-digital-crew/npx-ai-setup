# Spec 140: Agent YAML Frontmatter Migration

> **Status**: completed
> **Quelle**: specs/136-evaluate-everything-claude-code.md (Kandidat #4)
> **Ziel**: Alle 11 Agents auf YAML Frontmatter migrieren (offizielles Claude Code Format)

## Context

ECC nutzt YAML Frontmatter in Agent-Dateien mit name, description, tools, model Feldern. Claude Code unterstuetzt dieses Format offiziell. Unsere Agents haben kein Frontmatter — alles steht im Markdown-Body. Migration macht Agents maschinenlesbar und validierbar.

## Steps

- [x] 1. Definiere Frontmatter-Schema: name, description, tools[], model (haiku|sonnet|opus)
- [x] 2. Migriere `templates/agents/build-validator.md` — Frontmatter extrahieren, Body bereinigen
- [x] 3. Migriere `templates/agents/code-architect.md`
- [x] 4. Migriere `templates/agents/code-reviewer.md`
- [x] 5. Migriere `templates/agents/context-refresher.md`
- [x] 6. Migriere `templates/agents/frontend-developer.md`
- [x] 7. Migriere `templates/agents/liquid-linter.md`
- [x] 8. Migriere `templates/agents/perf-reviewer.md`
- [x] 9. Migriere `templates/agents/project-auditor.md`
- [x] 10. Migriere `templates/agents/staff-reviewer.md`
- [x] 11. Migriere `templates/agents/test-generator.md`
- [x] 12. Migriere `templates/agents/verify-app.md`
- [x] 13. Kopiere alle migrierten Agents nach `.claude/agents/`
- [x] 14. Verifiziere: Alle Agents via Claude Code aufrufbar, Frontmatter wird korrekt geparst

## Acceptance Criteria

- Alle 11 Agents haben YAML Frontmatter mit name, description, tools, model
- Kein Agent hat doppelte Information (Frontmatter vs Body)
- Alle Agents sind weiterhin via Claude Code aufrufbar
- Model-Zuweisung konsistent mit agents.md Dispatch-Table

## Files to Modify

- `templates/agents/*.md` (alle 11 Dateien)
- `.claude/agents/*.md` (alle 11 Dateien)
