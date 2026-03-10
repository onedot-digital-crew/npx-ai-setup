# AGENTS.md

## Purpose
Universal passive context for AGENTS.md-compatible tools (Cursor, Windsurf, Cline, and others).
Read this file before making multi-file edits, architectural changes, or release-impacting updates.

## Project Overview
<!-- Auto-Init populates this -->

## Project Context
For detailed project context, read:
- `.agents/context/STACK.md` - runtime, frameworks, key dependencies, and toolchain
- `.agents/context/ARCHITECTURE.md` - structure, entry points, boundaries, and data flow
- `.agents/context/CONVENTIONS.md` - coding conventions, testing patterns, and Definition of Done

If these files are missing or stale, regenerate with:
`npx @onedot/ai-setup --regenerate`

## Architecture Summary
<!-- Auto-Init populates this -->

## Commands
<!-- Auto-Init populates this -->

## Code Style Guidelines
- Follow existing lint and formatter config; do not introduce conflicting style rules.
- Prefer small, focused changes with clear intent and minimal side effects.
- Keep naming, folder structure, and abstraction patterns consistent with neighboring code.
- Add or update tests for behavior changes when a test framework is available.
- Avoid new dependencies unless there is a clear net benefit.

## Critical Rules
<!-- Auto-Init populates this -->

## Verification
- Run relevant lint, test, and build commands before marking work complete.
- Validate integrations affected by your changes (API calls, UI flows, background jobs).
- Summarize what was verified and the result.
