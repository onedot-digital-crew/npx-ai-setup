# Spec-Driven Development

Specs are structured task plans created before coding. They live in `specs/` and follow a simple template.

## When to Create a Spec

**Create a spec when:**
- Changes touch 3+ files
- Adding a new feature or module
- Requirements are ambiguous or complex
- Architectural decisions are involved

**Skip specs for:**
- Single-file fixes (typos, CSS tweaks, config changes)
- Bug fixes with obvious root cause
- Documentation-only changes

## Workflow

1. **Create** — Run `/spec "task description"` to generate a numbered spec
2. **Review** — Refine steps, acceptance criteria, and file list
3. **Execute** — Implement the spec step by step
4. **Complete** — Move finished spec to `specs/completed/`

## Naming Convention

```
NNN-short-description.md
```

Examples:
- `001-add-user-authentication.md`
- `002-refactor-api-layer.md`
- `003-dark-mode-support.md`

## Directory Structure

```
specs/
+-- README.md              # This file
+-- TEMPLATE.md            # Spec template
+-- completed/             # Archive for finished specs
+-- 001-some-feature.md    # Active spec
+-- 002-another-task.md    # Active spec
```

## Quick Start

```
/spec "add dark mode support"
```

This creates `specs/NNN-add-dark-mode-support.md` with the template pre-filled based on codebase analysis.
