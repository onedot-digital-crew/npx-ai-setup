# Spec 149: Onboarding Best Practices in Context-Dateien

> **Status**: completed
> **Source**: specs/145-evaluate-understand-anything.md (Kandidat #5, adaptiert)
> **Goal**: Context-Refresher-Output um onboarding-relevante Sections erweitern (keine neuen Dateien/Skills)
> **Depends on**: Spec 148 (both modify context-refresher.md — implement 148 first)

## Context

Understand-Anything generiert Onboarding-Guides mit: Complexity Hotspots, Key Concepts, Entry Points, File Map mit Zweckbeschreibung. Diese Patterns verbessern die bestehende ARCHITECTURE.md und STACK.md ohne neues Tooling.

## Steps

- [x] 1. Read `.claude/agents/context-refresher.md` and template version
- [x] 2. Add to ARCHITECTURE.md generation prompt: "Entry Points" section (max 8 lines)
- [x] 3. Add to ARCHITECTURE.md generation prompt: "Complexity Hotspots" section (max 8 lines)
- [x] 4. Add to STACK.md generation prompt: "Key Patterns" section (max 8 lines)
- [x] 5. Mirror changes to template version
- [x] 6. Verified: prompt instructions include section headings and line limits

## Acceptance Criteria

- ARCHITECTURE.md includes Entry Points and Complexity Hotspots sections
- STACK.md includes Key Patterns section
- Sections are concise: prompt instructs "max 8 lines per section". Test: verify section headings exist in output
- No new files created — enriches existing context output only

## Files to Modify

- `.claude/agents/context-refresher.md`
- `templates/agents/context-refresher.md`
