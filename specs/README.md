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

## Naming Convention

```
NNN-short-description.md
```

Examples: `001-add-user-authentication.md`, `002-refactor-api-layer.md`

## Quick Start

```
/spec "add dark mode support"
```

This creates `specs/NNN-add-dark-mode-support.md` with the template pre-filled based on codebase analysis.
