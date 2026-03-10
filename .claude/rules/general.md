# General Coding Rules

## Read Before Modify
Always read a file before modifying it. Never assume contents from memory or prior context.
After context compaction, re-read files before continuing work — do not assume what was already done.

## Check Before Creating
Before creating a new file, check if one already exists:
- Run `ls` or Glob to find existing files matching the concept
- Run `git ls-files` to see tracked files that may not be visible

## Verify, Don't Guess
Never assume import paths, function names, or API routes. Verify by reading the relevant file.
When unsure about current state, run `git diff` to see what has actually changed this session.

## Subagent Model Routing
When spawning subagents via the Agent tool, always set the model parameter:
- `model: haiku` — Explore agents, file search, codebase questions, simple research
- `model: sonnet` — Implementation, code generation, test writing
- `model: opus` — Architecture review, complex analysis, spec creation
Never spawn Explore or search agents without `model: haiku`.

## Human Approval Gates
Before finalizing any deliverable, present a summary and ask for confirmation.
Never proceed to the next workflow phase without explicit user approval.
