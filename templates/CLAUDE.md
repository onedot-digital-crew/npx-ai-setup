# CLAUDE.md

## Communication Protocol
No small talk. Just do it.
Confirmations one word (Done, Fixed). Show code changes as diff only.

## Project Documentation
Technical documentation in `.planning/codebase/` (created by `/gsd:map-codebase`).
- `ARCHITECTURE.md` - System architecture and data flow
- `CONVENTIONS.md` - Coding standards and patterns
- `STACK.md` - Technology stack and versions

Project context in `.planning/PROJECT.md` (created by `/gsd:new-project`)

## Workflow (GSD)
1. `/gsd:map-codebase` - Analyze existing code (brownfield)
2. `/gsd:new-project` - Initialize project planning
3. `/gsd:plan-phase N` - Plan next phase
4. `/gsd:execute-phase N` - Execute phase
5. `/gsd:verify-work N` - User acceptance testing

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
