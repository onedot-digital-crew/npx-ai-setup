---
model: sonnet
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep, Task
---

Drafts a pull request with staff review and PR body. Use when a feature branch is ready to be submitted for review.

## Context

- Current status: `!git status`
- Unstaged changes: `!git diff`
- Commits ahead of main: `!git log --oneline main..HEAD`
- Current branch: `!git branch --show-current`

## Process

1. **Build validation**: Spawn `build-validator` via Task tool.
   - If build-validator returns **FAIL**: stop immediately and tell the user: "Fix the build before creating a PR." Show the build output. Do not proceed.
   - If build-validator returns **PASS**: continue.
2. Analyze the changes shown in Context above to understand all modifications on this branch.
3. Stage and commit any remaining uncommitted changes (descriptive message, no `git add .`).
4. **Staff review**: Spawn `staff-reviewer` via Task tool with the prompt:
   > "Review this branch for production readiness before PR creation. Branch: <branch-name>. Recent commits: <commits from git log --oneline main..HEAD>."
   - If staff-reviewer returns **APPROVE**: continue drafting PR normally; note "Staff review: APPROVED" in the output.
   - If staff-reviewer returns **APPROVE WITH CONCERNS**: continue drafting PR; include the concerns under `## Staff Review Concerns` in the PR body.
   - If staff-reviewer returns **REQUEST CHANGES**: stop, show the reviewer's concerns, and tell the user: "Fix the reported issues before creating the PR."
5. Draft the PR title (short, under 70 chars) and body (`## Summary` with 2-3 bullets + `## Test plan` checklist).
6. Show the user the PR details and the commands to run:
   ```
   git push -u origin <branch>
   gh pr create --title "..." --body "..."
   ```
7. Do NOT push or create the PR — the user does this manually.

## Rules
- Never push (`git push` is denied by settings).
- Never push to main/master directly.
- If the branch is `main` or `master`, stop and ask the user to create a feature branch first.
- If `gh` CLI is not installed, provide the GitHub URL for manual PR creation.
