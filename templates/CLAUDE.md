# CLAUDE.md

## Required Plugins

**claude-mem** — persistent memory across sessions (required for all team members).

If not installed: run these two commands in Claude Code:
```
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

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

## Build Artifact Rules

Never read or search inside build output directories (dist/, .output/, .nuxt/, .next/, build/, coverage/). These directories contain generated artifacts that waste tokens and pollute context.

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

## Skills Discovery
When current capabilities are insufficient, search the skills.sh marketplace for additional agent skills:
- Search: `npx -y skills@latest find "<keyword>"`
- Install: `npx -y skills@latest add <owner/repo@skill-name> --agent claude-code --agent github-copilot -y`

Check `.claude/skills/` first to avoid installing duplicates. Only install when genuinely needed for the task.

## Spec-Driven Development
Specs live in `specs/` -- structured task plans created before coding.

**When to suggest a spec:** Changes across 3+ files, new features, architectural changes, ambiguous requirements.
**Skip specs for:** Single-file fixes, typos, config changes.

**Spec status lifecycle:** `draft` → `in-progress` → `in-review` → `completed` (or `blocked` at any stage)

**Workflow:**
1. `/spec "task"` — Plan: Opus challenges the idea, creates spec if approved (status: `draft`)
2. Review and refine spec if needed
3. `/spec-work NNN` — Execute: Sonnet implements the spec step-by-step; prompts for branch creation and optional auto-review (status: `in-progress` → `in-review` or `completed`)
4. `/spec-work-all` — Execute all: parallel agents using native `isolation: "worktree"`, one branch per spec
5. `/spec-review NNN` — Review: Opus reviews changes against acceptance criteria (status: `completed`)
6. `/spec-board` — Overview: Kanban-style board showing all specs with status and step progress

**Parallel execution (`/spec-work-all`):**
- Uses native `isolation: "worktree"` — Claude Code manages worktrees automatically
- Each agent gets its own branch (`spec/NNN-title`) with no merge conflicts
- Specs with dependencies run in sequential waves
- After completion, each spec is ready for `/spec-review`

See `specs/README.md` for details.

<claude-mem-context></claude-mem-context>
