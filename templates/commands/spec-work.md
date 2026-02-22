---
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Execute the spec: $ARGUMENTS

## Process

1. **Find the spec**: If `$ARGUMENTS` is a number (e.g. `001`), open `specs/001-*.md`. If it's a filename, open that directly. If empty, list all draft specs in `specs/` and ask which one to work on.

2. **Read the spec** and understand Goal, Steps, and Files to Modify.

3. **Read project context**: Skim `.agents/context/CONVENTIONS.md` and `.agents/context/STACK.md` to follow project patterns and use correct libraries.

4. **Load relevant skills**: If the spec's Context section mentions skills (e.g. "Relevant skills: foo, bar"), read `.claude/skills/<name>/prompt.md` for each. Apply their guidance throughout execution. Skip if `.claude/skills/` doesn't exist or no skills are listed.

5. **Start work**: Update the spec header — set `**Status**: in-progress`. If the spec has no `**Branch**` field, add `| **Branch**: —` to the header line.

6. **Execute each step** in order:
   - Implement the change
   - After completing a step, edit the spec file to check it off: `- [ ]` -> `- [x]`
   - If a step is blocked or unclear, stop and ask the user

7. **Verify acceptance criteria**: After all steps are done, check each acceptance criterion. Mark them as checked in the spec.

8. **Update CHANGELOG.md**: Prepend an entry to `CHANGELOG.md` in the project root:
   - Find or create a `## YYYY-MM-DD` heading for today's date at the top of the entries section
   - Under it, add: `- **Spec NNN**: [Spec title] — [1-sentence summary of what changed]`
   - Use the Edit tool to insert the entry after the `<!-- Entries are prepended below this line, newest first -->` comment

9. **Mark ready for review**:
   - Change status from `in-progress` to `in-review` in the spec header
   - Report what was done and suggest: `Run /spec-review NNN to review and create a PR`
   - Do NOT move the file to `specs/completed/` — that happens during review

## Rules
- Follow the spec exactly. Do not add scope beyond what's listed.
- If something is in "Out of Scope", do NOT implement it.
- Check off each step in the spec file as you complete it (progress tracking).
- If a step fails or is blocked, leave it unchecked, set status to `blocked`, and ask the user.
- Commit after logical groups of changes, not after every single step.
- If called with `--complete` flag, skip the review step: set status directly to `completed` and move to `specs/completed/` (legacy behavior).
