# CLAUDE.md

## Communication Protocol
No small talk. Just do it.
Confirmations one word (Done, Fixed). Show code changes as diff only.
If you edit the same file 3+ times without progress, stop and ask for guidance.

## Project Context (read before complex tasks)
Before multi-file changes or new features, read `.agents/context/`:
- `STACK.md` - Technology stack, versions, key dependencies, and what to avoid
- `ARCHITECTURE.md` - System architecture, directory structure, and data flow
- `CONVENTIONS.md` - Coding standards, naming patterns, error handling, and testing

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

## Verification
After completing work, verify before marking done:
- Run tests if available (`/test`)
- For UI changes: use browser tools or describe expected result
- For API changes: make a test request
- Check the build still passes
Never mark work as completed without verification.

## Context Management
Your context will be compacted automatically — this is normal. Before compaction:
- Commit current work or save state to HANDOFF.md
- Track remaining work in the spec or a todo list
After fresh start: review git log, open specs, check test state.

## Working Style
Read relevant code before answering questions about it.
Implement changes rather than only suggesting them.
Use subagents for parallel or isolated work. For simple tasks, work directly.

## Spec-Driven Development
Specs live in `specs/` -- structured task plans created before coding.

**When to suggest a spec:** Changes across 3+ files, new features, architectural changes, ambiguous requirements.
**Skip specs for:** Single-file fixes, typos, config changes.

**Workflow:**
1. `/spec "task"` (Opus in plan mode - creates detailed plan, you approve, spec file is created)
2. Review and refine spec if needed
3. `/spec-work NNN` (Sonnet executes the approved plan step-by-step)
4. Completed specs move to `specs/completed/`

See `specs/README.md` for details.
