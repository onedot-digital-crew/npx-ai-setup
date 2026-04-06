# CLAUDE.md

## Memory

**Built-in**: Auto-saves to `.agents/memory/MEMORY.md`. No setup required.
**claude-mem** (optional): Cross-session semantic search via `/plugin`.

## Tips

- `ultrathink:` prefix — triggers extended reasoning without switching models
- `! command` — run a bash command instantly without token overhead
- `@path/to/file` — import file contents compactly into context
- One task per conversation — prevents context bleed

## MCP Servers

Each MCP server adds tools to every request — only enable servers actively used. Use `claude mcp list/enable/disable`.

## Communication Protocol
No small talk. Just do it. Confirmations one word (Done, Fixed). Diff only.
If you edit the same file 3+ times without progress, stop and ask.

## Project Context (tiered loading)
SessionStart injects L0 abstracts from `.agents/context/` (~400 tokens).
Full details: `/context-load STACK.md` (or ARCHITECTURE.md, CONVENTIONS.md, decisions.md, all).
Optional: `PATTERNS.md`, `AUDIT.md` (from /analyze), `LEARNINGS.md` (from /reflect).

## Build Artifact Rules

Never read or search inside build output directories (dist/, .output/, .nuxt/, .next/, build/, coverage/). These directories contain generated artifacts that waste tokens and pollute context.

## Token Optimization
- **Prep-scripts** (`.claude/scripts/*-prep.sh`) gather data in shell before Claude analyzes — zero tokens on green paths.
- **Defuddle** (`defuddle parse <url> --md`) replaces WebFetch for web pages — strips noise, saves ~80% tokens.
- See `.claude/docs/token-optimization.md` for the full guide.

## Task Complexity Routing
Before starting, classify the task tier:
- **Simple** (typos, single-file fixes, config tweaks): proceed directly
- **Medium** (new feature, 2-3 files, component): use plan mode
- **Complex** (architecture, refactor, new system): stop and flag model requirement first

## Verification
**Iron Law**: Run verification in THIS message before claiming it passes.

Before marking done: run tests (`/test`), check the build, make a test request for API changes.
Never say "should work" or "probably passes" — those mean you skipped verification.
Required: automated checks pass + "Verification complete: [what was checked]".

## Context Management
Auto-compact at 68%. Use `/compact Focus on <topic>` for targeted compaction.
Before ending: `/pause`. After fresh start: `/resume`.
After sessions with >30 tool calls: `/reflect` and `/commit`.
If a session crosses `>30` tool calls with no subagents, stop and reconsider delegation before continuing.


