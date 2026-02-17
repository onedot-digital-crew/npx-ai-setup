---
model: sonnet
allowed-tools: Read, Bash, Glob, Grep
---

Prepare a pull request for the current branch.

## Process

1. Run `git status`, `git diff`, and `git log --oneline main..HEAD` to understand all changes.
2. Stage and commit any remaining uncommitted changes (descriptive message, no `git add .`).
3. Draft the PR title (short, under 70 chars) and body (`## Summary` with 2-3 bullets + `## Test plan` checklist).
4. Show the user the PR details and the commands to run:
   ```
   git push -u origin <branch>
   gh pr create --title "..." --body "..."
   ```
5. Do NOT push or create the PR — the user does this manually.

## Rules
- Never push (`git push` is denied by settings).
- Never push to main/master directly.
- If the branch is `main` or `master`, stop and ask the user to create a feature branch first.
- If `gh` CLI is not installed, provide the GitHub URL for manual PR creation.
