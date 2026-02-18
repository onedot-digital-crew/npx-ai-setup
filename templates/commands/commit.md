---
model: claude-sonnet-4-6
allowed-tools: Read, Bash, Glob, Grep
---

Stage all changes and create a commit with a descriptive message.

## Process

1. Run `git status` and `git diff --staged` + `git diff` to see all changes.
2. Run `git log --oneline -5` to match the repo's commit style.
3. Analyze the changes — determine if this is a new feature, enhancement, bug fix, refactor, test, or docs update.
4. Stage relevant files by name (`git add <file>...`). Do NOT use `git add -A` or `git add .` — avoid accidentally staging secrets or binaries.
5. Write a concise conventional commit message (1-2 sentences) focusing on **why**, not what.
6. Commit. Do NOT push. Do NOT use `--no-verify`.

## Rules
- Never stage `.env`, credentials, or large binaries.
- Never push — only commit locally.
- Never skip hooks (`--no-verify`).
- If there are no changes, say so and stop.
