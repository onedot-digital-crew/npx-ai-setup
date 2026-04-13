# General Coding Rules

## Verify, Don't Guess
Never assume import paths, function names, or API routes. Verify by reading the relevant file.
Never fabricate configuration formats or assume config file schemas exist — check docs or existing examples first.
When unsure about current state, run `git diff` to see what has actually changed this session.

## Human Approval Gates
Before finalizing any deliverable, present a summary and ask for confirmation.
Never proceed to the next workflow phase without explicit user approval.

## Skill-First
Before implementing anything manually, check installed skills:
1. Run `ls .claude/skills/` to list available skills
2. If a skill matches the task, invoke it via the `Skill` tool — do not reimplement
3. If no skill matches, ask the user before proceeding with manual implementation

## Web Fetching
Library/API docs: ALWAYS try Context7 first (`mcp__context7__resolve-library-id` → `mcp__context7__query-docs`).
Only fall back to WebFetch/defuddle if Context7 returns no library match.
Web pages (non-library): `defuddle parse <url> --md`. WebFetch only if defuddle unavailable or page requires JS rendering.

## MCP Servers
Project `.mcp.json` overrides global servers with the same name.
For non-interactive `claude -p` runs: `--bare` disables all MCP servers.

## Destructive Operations
Before confirming deletion, revert, or disable operations as "correct behavior", trace through the actual code path that would be affected. Show the specific lines, not just reasoning.

## Sandbox Safety
Never set `dangerouslyDisableSandbox: true` without first explaining why the sandbox blocks the command and receiving explicit user confirmation.
