---
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Execute the spec: $ARGUMENTS

## Process

1. **Find the spec**: If `$ARGUMENTS` is a number (e.g. `001`), open `specs/001-*.md`. If it's a filename, open that directly. If empty, list all draft specs in `specs/` and ask which one to work on.

2. **Read the spec** and understand Goal, Steps, and Files to Modify.

3. **Read project context**: Skim `.agents/context/CONVENTIONS.md` and `.agents/context/STACK.md` to follow project patterns and use correct libraries.

4. **Execute each step** in order:
   - Implement the change
   - After completing a step, edit the spec file to check it off: `- [ ]` -> `- [x]`
   - If a step is blocked or unclear, stop and ask the user

5. **Verify acceptance criteria**: After all steps are done, check each acceptance criterion. Mark them as checked in the spec.

6. **Complete the spec**:
   - Change status from `draft` to `completed` in the spec header
   - Move the file: `specs/NNN-*.md` -> `specs/completed/NNN-*.md`
   - Report what was done

## Rules
- Follow the spec exactly. Do not add scope beyond what's listed.
- If something is in "Out of Scope", do NOT implement it.
- Check off each step in the spec file as you complete it (progress tracking).
- If a step fails or is blocked, leave it unchecked and ask the user.
- Commit after logical groups of changes, not after every single step.
