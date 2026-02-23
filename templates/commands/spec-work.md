---
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
---

Execute the spec: $ARGUMENTS

## Process

1. **Find the spec**: If `$ARGUMENTS` is a number (e.g. `001`), open `specs/001-*.md`. If it's a filename, open that directly. If empty, list all draft specs in `specs/` and ask which one to work on.

2. **Read the spec** and understand Goal, Steps, and Files to Modify.

3. **Branch setup**: Ask the user whether to create a new branch before starting work.
   - Derive the branch name from the spec filename: `spec/NNN-title` (lowercase, hyphens, strip `.md`)
   - If user says yes: run `git checkout -b spec/NNN-title`. If the branch already exists, offer to switch to it with `git checkout spec/NNN-title`.
   - Update the spec header: set `**Branch**: spec/NNN-title` (or `—` if no branch created).

4. **Read project context**: Skim `.agents/context/CONVENTIONS.md` and `.agents/context/STACK.md` to follow project patterns and use correct libraries.

5. **Load relevant skills**: If the spec's Context section mentions skills (e.g. "Relevant skills: foo, bar"), read `.claude/skills/<name>/prompt.md` for each. Apply their guidance throughout execution. Skip if `.claude/skills/` doesn't exist or no skills are listed.

6. **Start work**: Update the spec header — set `**Status**: in-progress`.

7. **Execute each step** in order:
   - Implement the change
   - After completing a step, edit the spec file to check it off: `- [ ]` -> `- [x]`
   - If a step is blocked or unclear, stop and ask the user

8. **Verify acceptance criteria**: After all steps are done, check each acceptance criterion. Mark them as checked in the spec.

9. **Update CHANGELOG.md**: Add an entry to the `## [Unreleased]` section in `CHANGELOG.md`:
   - Find the `## [Unreleased]` heading (it's just below the `<!-- Entries are prepended below this line, newest first -->` comment)
   - Insert after `## [Unreleased]`: `- **Spec NNN**: [Spec title] — [1-sentence summary of what changed]`
   - Do NOT create date headings — entries accumulate under [Unreleased] until `/release` is run

10. **Auto-review**: Ask the user whether to run an automatic review with corrections now.
    - If **no**: Set status to `in-review` in the spec header. Report what was done and suggest: `Run /spec-review NNN to review`.
    - If **yes**: Perform a full review pass in a single round:
      1. **Spec compliance**: Are all steps checked? Does implementation match each step? Any scope creep?
      2. **Acceptance criteria**: Verify each criterion against actual code — don't just trust checkboxes.
      3. **Code quality**: Check for bugs (logic errors, null/undefined, off-by-one), security issues, readability problems. Only flag HIGH and MEDIUM confidence issues.
      4. **Fix issues found**: Make corrections in the same files. Do NOT start a second review pass.
      5. **After corrections**:
         - If everything passes: set status to `completed`, move spec file `specs/NNN-*.md` → `specs/completed/NNN-*.md`. Report: "Auto-review passed. Spec NNN completed."
         - If unfixable issues remain: keep status as `in-review`, report the issues. Suggest: `Run /spec-review NNN to review manually.`

## Rules
- Follow the spec exactly. Do not add scope beyond what's listed.
- If something is in "Out of Scope", do NOT implement it.
- Check off each step in the spec file as you complete it (progress tracking).
- If a step fails or is blocked, leave it unchecked, set status to `blocked`, and ask the user.
- Commit after logical groups of changes, not after every single step.
- If called with `--complete` flag, skip the review step: set status directly to `completed` and move to `specs/completed/` (legacy behavior).
