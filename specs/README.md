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

## Workflow

### 1. Create a spec

```
/spec "add dark mode support"
```

This runs an integrated workflow:
1. **Challenge phase** — validates the idea, questions assumptions, surfaces edge cases
2. **Spec generation** — creates `specs/NNN-add-dark-mode-support.md` with steps, criteria, and files to modify

### 2. Review and refine

Read the generated spec. Edit steps, acceptance criteria, or files to modify as needed.

### 3. Execute one spec

```
/spec-work NNN
```

Executes the spec step by step, checking off each step as it completes. Moves completed spec to `specs/completed/`.

### 4. Execute all specs in parallel

```
/spec-work-all
```

Discovers all draft specs in `specs/`, detects dependencies between them, then executes in parallel waves. Independent specs run simultaneously; dependent specs wait for their dependencies.

## Spec Status

- **draft** — ready to execute
- **completed** — done, moved to `specs/completed/`

## Directory Structure

```
specs/
  README.md           # This file
  TEMPLATE.md         # Blank spec template
  001-feature-name.md # Draft spec
  completed/
    000-old-spec.md   # Completed spec
```
