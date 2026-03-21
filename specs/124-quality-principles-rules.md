# Spec: Quality Principles as Reusable Rules Templates

> **Spec ID**: 124 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

## Goal
Add 4 quality principle rule files as templates that agents and commands can reference for consistent code quality checks.

## Context
Octopus has reusable `principles/` files (general, maintainability, performance, security) referenced by multiple agents. Our agents each define their own ad-hoc checklists, leading to inconsistency. Shared principles ensure every reviewer checks the same things. Inspired by claude-octopus agents/principles/ directory.

## Steps
- [ ] Step 1: Create `templates/rules/quality-general.md` — Correctness (edge cases, error handling), Reliability (no race conditions, resource cleanup, idempotency), Code Quality (readability, no dead code, no secrets)
- [ ] Step 2: Create `templates/rules/quality-performance.md` — DB (no N+1, proper indexing), Caching (strategic, no leaks), I/O (async, connection pooling), Frontend (no layout thrashing, lazy load)
- [ ] Step 3: Create `templates/rules/quality-security.md` — Input/Output (no injection, escape output), Auth (CSRF, bcrypt, rate limiting), Data Protection (encrypt sensitive, no plaintext secrets)
- [ ] Step 4: Create `templates/rules/quality-maintainability.md` — Structure (SRP, DRY), Naming (clear, no magic numbers), Error Handling (explicit, meaningful messages), Testability (pure functions)
- [ ] Step 5: Reference principles from relevant agent templates: `perf-reviewer` → performance, `code-reviewer` → general+security, `staff-reviewer` → maintainability
- [ ] Step 6: Add rules to `bin/ai-setup.sh` install flow

## Acceptance Criteria
- [ ] 4 rule files created, each ≤20 lines (concise checklists, not essays)
- [ ] At least 3 agent templates reference relevant principles
- [ ] Rules installed during ai-setup to `.claude/rules/`

## Files to Modify
- `templates/rules/quality-general.md` — new
- `templates/rules/quality-performance.md` — new
- `templates/rules/quality-security.md` — new
- `templates/rules/quality-maintainability.md` — new
- `templates/agents/perf-reviewer.md` — reference performance principles
- `templates/agents/code-reviewer.md` — reference general + security

## Out of Scope
- Agent-level hooks for enforcement
- Changing agent scoring/verdict logic
