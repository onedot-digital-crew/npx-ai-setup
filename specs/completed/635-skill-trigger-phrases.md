# Spec: Skill Trigger Phrases im Frontmatter

> **Spec ID**: 635 | **Created**: 2026-04-13 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal

Die Top-10 Skill-Templates mit konkreten Trigger-Phrasen im `description`-Feld erweitern damit Claude Skills zuverlässiger erkennt und aktiviert.

## Context

SymDex Research (spec 630) zeigte ein Pattern aus SKILL.md: explizite Trigger-Phrasen ("where is this defined?", "who calls this?") verbessern Skill-Discovery erheblich. Unsere Skills haben knappe description-Felder — spec, debug, research, analyze haben kaum Trigger-Hinweise. CONCEPT.md fordert "Curated Skills, Not AI Discovery" — bessere Trigger-Phrasen machen kuratierte Skills effektiver ohne Discovery-Overhead.

### Verified Assumptions

- Skill-Frontmatter `description` wird von Claude für Skill-Matching genutzt — Evidence: `templates/skills/spec/SKILL.template.md:2` | Confidence: High | If Wrong: Änderung ist trotzdem harmlos
- Kein dediziertes `triggers`-Feld existiert — Evidence: Alle SKILL.template.md Frontmatter | Confidence: High | If Wrong: Trigger-Feld statt description nutzen
- Bestehende descriptions können erweitert werden ohne Breaking Change | Confidence: High | If Wrong: —

## Steps

- [ ] 1. `templates/skills/spec/SKILL.template.md` — description um Trigger-Phrasen erweitern: "Use when planning multi-file changes, new features, or architectural work. Trigger: 'let's spec this', 'before we start', 'plan this out'"
- [ ] 2. `templates/skills/debug/SKILL.template.md` — Trigger: "something is broken", "why is X not working", "investigate this bug", "root cause"
- [ ] 3. `templates/skills/test/SKILL.template.md` — Trigger: "run tests", "check if tests pass", "fix failing tests"
- [ ] 4. `templates/skills/review/SKILL.template.md` — Trigger: "review changes", "check my work", "before I commit"
- [ ] 5. `templates/skills/commit/SKILL.template.md` — Trigger: "commit this", "stage and commit", "create a commit"
- [ ] 6. `templates/skills/research/SKILL.template.md` — Trigger: "research X", "look into this repo", "evaluate this tool"
- [ ] 7. `templates/skills/analyze/SKILL.template.md` — Trigger: "analyze codebase", "rebuild graph", "overview of this project"
- [ ] 8. `templates/skills/lint/SKILL.template.md` — Trigger: "check linting", "fix lint errors", "run linter"
- [ ] 9. `templates/skills/build-fix/SKILL.template.md` — Trigger: "build is failing", "fix build errors", "compilation error"
- [ ] 10. `templates/skills/explore/SKILL.template.md` — Trigger: "explore this codebase", "understand how X works", "find where"

## Acceptance Criteria

- [ ] Alle 10 SKILL.template.md haben Trigger-Phrasen in der description
- [ ] `grep -l "Trigger:" templates/skills/*/SKILL.template.md | wc -l` gibt ≥10
- [ ] Kein Skill hat description >3 Sätze (Token-Budget bleibt kompakt)

## Files to Modify

- `templates/skills/spec/SKILL.template.md`
- `templates/skills/debug/SKILL.template.md`
- `templates/skills/test/SKILL.template.md`
- `templates/skills/review/SKILL.template.md`
- `templates/skills/commit/SKILL.template.md`
- `templates/skills/research/SKILL.template.md`
- `templates/skills/analyze/SKILL.template.md`
- `templates/skills/lint/SKILL.template.md`
- `templates/skills/build-fix/SKILL.template.md`
- `templates/skills/explore/SKILL.template.md`

## Out of Scope

- Rule-Datei-Änderungen (→ Spec 634)
- Skill-Inhalt (nur Frontmatter description)
- Skills außerhalb der Top-10
