# Spec: Local skill templates for common frameworks

> **Spec ID**: 032 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/032-local-skill-templates-for-common-frameworks

## Goal
Bundle skill templates for tailwind, pinia, drizzle, tanstack, and vitest locally so the slow npx skills.sh search is skipped and "no skills found" warnings disappear.

## Context
The dynamic skill search runs `npx skills@latest find $kw` for each detected keyword (up to 30s per keyword). Technologies like tailwind, pinia, drizzle, tanstack, and vitest consistently return nothing from skills.sh. The project already bundles Shopify skills as local templates — this spec extends that pattern to common framework-agnostic technologies.

## Steps
- [x] Step 1: Create `templates/skills/tailwind/prompt.md` — Tailwind CSS patterns and best practices
- [x] Step 2: Create `templates/skills/pinia/prompt.md` — Pinia state management patterns
- [x] Step 3: Create `templates/skills/drizzle/prompt.md` — Drizzle ORM schema and query patterns
- [x] Step 4: Create `templates/skills/tanstack/prompt.md` — TanStack Query/Router patterns
- [x] Step 5: Create `templates/skills/vitest/prompt.md` — Vitest test conventions and mock patterns
- [x] Step 6: Add `get_local_skill_template()` helper in `bin/ai-setup.sh` — case statement mapping keyword → template path (bash 3.2 safe, no `declare -A`)
- [x] Step 7: In the keyword loop (line ~984-1001), call `get_local_skill_template` first — if template exists, copy to `.claude/skills/$kw/prompt.md` and skip the npx search; if not, run dynamic search as before
- [x] Step 8: Run smoke test to verify no regressions

## Acceptance Criteria
- [x] 5 skill templates exist in `templates/skills/{tailwind,pinia,drizzle,tanstack,vitest}/`
- [x] Setup with a nuxt project installs these skills without npx search calls
- [x] Keywords without local templates still fall through to dynamic search
- [x] No "no skills found" warnings for the 5 bundled keywords
- [x] Smoke test passes

## Files to Modify
- `templates/skills/tailwind/prompt.md` — new file
- `templates/skills/pinia/prompt.md` — new file
- `templates/skills/drizzle/prompt.md` — new file
- `templates/skills/tanstack/prompt.md` — new file
- `templates/skills/vitest/prompt.md` — new file
- `bin/ai-setup.sh` — add helper function + update keyword loop

## Out of Scope
- Updating existing `.claude/skills/` during the update flow (separate spec)
- Adding templates for vue, nuxt, react (covered by SYSTEM_SKILLS IDs)
- Removing the dynamic search entirely for known systems
