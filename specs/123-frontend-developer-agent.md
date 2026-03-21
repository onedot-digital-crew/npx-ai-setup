# Spec: Add frontend-developer Agent Template

> **Spec ID**: 123 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

## Goal
Add a `frontend-developer` agent template specialized for React/Vue/Nuxt with accessibility and performance focus.

## Context
one-dot.de builds Shopify (Liquid + JS), Vue/Nuxt, and React/Next.js projects. No existing agent covers frontend-specific concerns (WCAG accessibility, Core Web Vitals, responsive design, component architecture). Inspired by claude-octopus frontend-developer agent. Stack-agnostic template that works across React and Vue ecosystems.

## Steps
- [ ] Step 1: Create `templates/agents/frontend-developer.md` with Core Expertise (React/Vue/Nuxt, Tailwind, WCAG 2.1 AA, Core Web Vitals), Behavioral Traits, Response Approach, Output Contract
- [ ] Step 2: Add `when_to_use` (component building, accessibility, responsive layouts, frontend performance) and `avoid_if` (backend API, database, infrastructure)
- [ ] Step 3: Set model to `sonnet`, tools to Read/Write/Edit/Glob/Grep/Bash, max_turns to 20
- [ ] Step 4: Add conditional stack detection in `lib/plugins.sh` — install agent only if frontend stack detected (React, Vue, Nuxt, Next.js, Svelte)
- [ ] Step 5: Mirror to `.claude/agents/frontend-developer.md`

## Acceptance Criteria
- [ ] Agent template covers: accessibility (WCAG), responsive design, Core Web Vitals, component architecture
- [ ] Stack-agnostic (React + Vue, not locked to one framework)
- [ ] Installed conditionally based on detected frontend stack
- [ ] Includes when_to_use/avoid_if routing metadata

## Files to Modify
- `templates/agents/frontend-developer.md` — new
- `lib/plugins.sh` — add frontend-developer to conditional install
- `.claude/agents/frontend-developer.md` — mirror

## Out of Scope
- Framework-specific agents (React-only, Vue-only)
- Design system generation
