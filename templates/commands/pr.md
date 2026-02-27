---
model: sonnet
allowed-tools: Read, Bash, Glob, Grep, Task
---

Drafts a pull request with staff review and PR body. Use when a feature branch is ready to be submitted for review.

## Process

1. Run `git status`, `git diff`, and `git log --oneline main..HEAD` to understand all changes.
2. Stage and commit any remaining uncommitted changes (descriptive message, no `git add .`).
3. **Staff review**: Spawn `staff-reviewer` via Task tool with the prompt:
   > "Review this branch for production readiness before PR creation. Branch: <branch-name>. Recent commits: <commits from git log --oneline main..HEAD>."
   - If staff-reviewer returns **APPROVE**: continue drafting PR normally; note "Staff review: APPROVED" in the output.
   - If staff-reviewer returns **APPROVE WITH CONCERNS**: continue drafting PR; include the concerns under `## Staff Review Concerns` in the PR body.
   - If staff-reviewer returns **REQUEST CHANGES**: stop, show the reviewer's concerns, and tell the user: "Fix the reported issues before creating the PR."
4. Draft the PR title (short, under 70 chars) and body (`## Summary` with 2-3 bullets + `## Test plan` checklist).
5. Show the user the PR details and the commands to run:
   ```
   git push -u origin <branch>
   gh pr create --title "..." --body "..."
   ```
6. Do NOT push or create the PR — the user does this manually.

## Rules
- Never push (`git push` is denied by settings).
- Never push to main/master directly.
- If the branch is `main` or `master`, stop and ask the user to create a feature branch first.
- If `gh` CLI is not installed, provide the GitHub URL for manual PR creation.
