# Spec: performance-reviewer stack-gated aktivieren

> **Spec ID**: 660 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: small | **Branch**: —

<!-- depends_on: [654,659] -->

## Goal

Behalte `performance-reviewer`, aber aktiviere ihn gezielt: Hotpath-/Stack-gated statt pauschal als Review-Option überall.

## Context

Performance-Review ist für Shopify/Nuxt/Frontend-Hotpaths und DB-/Loop-/Bundle-Änderungen wertvoll. Als immer sichtbare Option erhöht er aber Routing-Komplexität und False-Positive-Risiko. Die Aktivierung soll stack- und diff-basiert sein.

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**:
  - `shopify-liquid`: Liquid sections/snippets, bundle entrypoints, render-heavy snippets
  - `nuxt-storyblok`, `nuxtjs`, `nextjs`: render loops, composables, data fetching, bundle imports
  - `laravel`, `shopware`: DB queries, loops, service hotpaths
  - default: only explicit performance request or obvious loops/data fetching

## Steps

- [ ] Step 1: `templates/agents/performance-reviewer.md` — Stack-gated "When to Use" ergänzen
- [ ] Step 2: `templates/skills/review/SKILL.template.md` — Performance-Agent nur spawnen wenn Hotpath-Heuristik oder Stack-Profil passt
- [ ] Step 3: `templates/skills/spec-work/SKILL.template.md` — Review-Matrix anpassen: performance-reviewer nur bei stack/hotpath Kriterien
- [ ] Step 4: `templates/skills/review/SKILL.template.md` — Hotpath-Heuristik dokumentieren: DB queries, loops over unbounded data, render loops, bundle imports, Liquid hub snippets
- [ ] Step 5: `templates/claude/rules/agents.md` — Agent Dispatch Matrix entsprechend aktualisieren
- [ ] Step 6: `.claude/` Mirrors via `bin/sync-local.sh`

## Acceptance Criteria

- [ ] `performance-reviewer` wird nicht mehr pauschal bei jedem Standard-Review vorgeschlagen
- [ ] `review` Skill nennt konkrete Hotpath/Stack-Trigger
- [ ] Shopify Liquid hub snippets (`imported_by ≥ 5` aus liquid-graph `top_hubs`) triggern Performance-Review-Hinweis
- [ ] Nuxt/Next data fetching oder render loops triggern Performance-Review-Hinweis
- [ ] Pure docs/config/CSS-only Änderungen triggern keinen Performance-Reviewer
- [ ] `bash .claude/scripts/quality-gate.sh` grün

## Files to Modify

> Nur `templates/` editieren. `.claude/` Mirrors via `bash bin/sync-local.sh` aus Spec 654.

- `templates/agents/performance-reviewer.md` - Stack-gated Trigger
- `templates/skills/review/SKILL.template.md` - Dispatch
- `templates/skills/spec-work/SKILL.template.md` - Matrix
- `templates/claude/rules/agents.md` - Dispatch docs
- `bash bin/sync-local.sh` nach Template-Edits

## Out of Scope

- `performance-reviewer` löschen
- Vollautomatische Performance-Benchmarks
- Stack-spezifische neue Reviewer schreiben
