# Spec 149: Onboarding Best Practices in Context-Dateien

> **Status**: Draft
> **Source**: specs/145-evaluate-understand-anything.md (Kandidat #5, adaptiert)
> **Goal**: Context-Refresher-Output um onboarding-relevante Sections erweitern (keine neuen Dateien/Skills)
> **Depends on**: Spec 148 (both modify context-refresher.md — implement 148 first)

## Context

Understand-Anything generiert Onboarding-Guides mit: Complexity Hotspots, Key Concepts, Entry Points, File Map mit Zweckbeschreibung. Diese Patterns verbessern die bestehende ARCHITECTURE.md und STACK.md ohne neues Tooling.

## Steps

- [ ] 1. Read `.claude/agents/context-refresher.md` and template version
- [ ] 2. Add to ARCHITECTURE.md generation prompt: "Entry Points" section — identify main entry files (index.*, main.*, app.*) and explain the bootstrap flow
- [ ] 3. Add to ARCHITECTURE.md generation prompt: "Complexity Hotspots" section — flag files/modules with high complexity or many dependencies
- [ ] 4. Add to STACK.md generation prompt: "Key Patterns" section — list design patterns actively used (e.g., middleware chain, pub/sub, repository pattern)
- [ ] 5. Mirror changes to template version
- [ ] 6. Test: run context-refresher on npx-ai-setup, verify new sections appear

## Acceptance Criteria

- ARCHITECTURE.md includes Entry Points and Complexity Hotspots sections
- STACK.md includes Key Patterns section
- Sections are concise: prompt instructs "max 8 lines per section". Test: verify section headings exist in output
- No new files created — enriches existing context output only

## Files to Modify

- `.claude/agents/context-refresher.md`
- `templates/agents/context-refresher.md`
