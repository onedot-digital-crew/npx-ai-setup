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
<!-- Auto-Init populates this -->

## Critical Rules
<!-- Auto-Init populates this -->

## Task Complexity Routing
Before starting, classify and state the task tier:

- **Simple** (typos, single-file fixes, config tweaks): proceed directly
- **Medium** (new feature, 2-3 files, component): use plan mode
- **Complex** (architecture, refactor, new system): stop and tell the user to run
  `/gsd:set-profile quality` or restart with `claude --model claude-opus-4-6`

Never start a complex task without flagging the model requirement first.

## Verification
After completing work, verify before marking done:
- Run tests if available (`/test`)
- For UI changes: use browser tools or describe expected result
- For API changes: make a test request
- Check the build still passes

Never mark work as completed without BOTH:
1. Automated checks pass (tests green, linter clean, build succeeds)
2. Explicit statement: "Verification complete: [what was checked and result]"

## Context Management
Your context will be compacted automatically — this is normal. Before compaction:
- Commit current work or save state to HANDOFF.md
- Track remaining work in the spec or a todo list
After fresh start: review git log, open specs, check test state.

If you see `[CONTEXT STALE]` in your context: invoke the `context-refresher` subagent before proceeding with the task. This regenerates `.agents/context/` to reflect the current project state.

## Prompt Cache Strategy
Claude caches prompts as a prefix — static content first, dynamic content last maximizes cache hits:
1. **System prompt + tools** — globally cached across all sessions
2. **CLAUDE.md** — cached per project (do not edit mid-session)
3. **Session context** (`.agents/context/`) — cached per session
4. **Conversation messages** — dynamic, appended each turn

Do not edit CLAUDE.md or tool definitions mid-session — it breaks the cache for all subsequent turns.
Pass dynamic updates (timestamps, file changes) via messages, not by editing static layers.

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
4. `/spec-work-all` (Sonnet executes all draft specs in parallel via subagents)
5. Completed specs move to `specs/completed/`

See `specs/README.md` for details.
