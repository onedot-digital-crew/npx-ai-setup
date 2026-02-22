# Spec: Add Skills Discovery Section to CLAUDE.md Template

> **Spec ID**: 014 | **Created**: 2026-02-22 | **Status**: completed

## Goal
Add a "Skills Discovery" section to the CLAUDE.md template so Claude can search and install skills from skills.sh on demand during sessions.

## Context
After initial setup, Haiku selects top 5 skills. If users need more mid-session, Claude doesn't know the commands. Adding the search/install instructions to the template ensures every project has this capability. The `--agent claude-code --agent github-copilot` flags limit installs to these two agents only.

## Steps
- [x] Step 1: Add a `## Skills Discovery` section to `templates/CLAUDE.md` after "Working Style" with `npx skills find` and `npx skills add` commands, including `--agent claude-code --agent github-copilot -y` flags
- [x] Step 2: Verify the section doesn't conflict with the regeneration logic (which only touches Commands and Critical Rules sections)

## Acceptance Criteria
- [x] `templates/CLAUDE.md` contains Skills Discovery section with search and install commands
- [x] Install command includes `--agent claude-code --agent github-copilot` flags
- [x] Section includes guidance to check existing skills first and only install when needed

## Files to Modify
- `templates/CLAUDE.md` — add Skills Discovery section

## Out of Scope
- New slash command for skill discovery (can be added later)
- Changes to the Haiku-based skill curation during setup
- Copilot-instructions.md changes (Copilot already reads CLAUDE.md)
