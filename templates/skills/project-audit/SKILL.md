---
name: project-audit
description: Analyze the existing codebase and produce .agents/context/PATTERNS.md and .agents/context/AUDIT.md. Use when onboarding Claude to an existing project, after a major refactor, or when the project's established patterns need to be re-documented. Invokes the project-auditor agent.
---

# Project Audit

Runs the project-auditor agent to analyze this codebase and produce team-shared context files.

## When to use
- First time setting up Claude on an existing project
- After a major refactor that changes established patterns
- When `.agents/context/PATTERNS.md` or `AUDIT.md` is missing or outdated

## What it produces
- `.agents/context/PATTERNS.md` — reusable patterns found in this codebase
- `.agents/context/AUDIT.md` — improvement opportunities, prioritized by impact

Both files are committed (team-shared) — Claude reads them automatically in future sessions.

## Process

1. Run the project-auditor agent:
   ```
   Use the project-auditor subagent to analyze this project.
   ```

2. The agent reads in this order:
   - `.agents/context/` files (STACK, ARCHITECTURE, CONVENTIONS)
   - 3-5 spot-reads of representative files

3. After producing PATTERNS.md and AUDIT.md, the agent asks whether to create specs for the top findings.

## Rules
- Do not re-run if both files exist and are less than 7 days old — ask the user first
- Commit the output files after generation
