# CLAUDE.md

## Communication Protocol
No small talk. Just do it.
Confirmations one word (Done, Fixed). Show code changes as diff only.

## Project Documentation
Technical documentation in `.agents/context/`:
- `ARCHITECTURE.md` - System architecture and data flow
- `CONVENTIONS.md` - Coding standards and patterns
- `STACK.md` - Technology stack and versions

## Commands
<!-- Auto-Init will populate this section with package.json scripts -->
<!-- Example after Auto-Init:
- dev: Start development server
- build: Production build
- lint: Run ESLint with auto-fix
- test: Run test suite
-->

## Critical Rules
<!-- Auto-Init will populate this section based on linting config -->
<!-- Add project-specific rules manually:
Example rules to consider:
- Never commit .env files or secrets
- Always use TypeScript strict mode
- Prefer named exports over default exports
- Follow existing naming conventions (check CONVENTIONS.md)
- Run tests before committing (npm run test)
-->

## Spec-Driven Development
Specs live in `specs/` -- structured task plans created before coding.

**When to suggest a spec:** Changes across 3+ files, new features, architectural changes, ambiguous requirements.
**Skip specs for:** Single-file fixes, typos, config changes.

Workflow: `/spec "task"` -> Review -> Implement -> Move to `specs/completed/`
See `specs/README.md` for details.
