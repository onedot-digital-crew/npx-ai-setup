---
model: sonnet
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

Stages changes and creates a conventional commit message. Use when work is ready and a well-scoped message is needed.

## Context

- Current status: `!git status`
- Staged changes: `!git diff --staged`
- Unstaged changes: `!git diff`
- Recent commits: `!git log --oneline -5`

## Process

1. Analyze the changes shown in Context above — determine if this is a new feature, enhancement, bug fix, refactor, test, or docs update.
2. Stage relevant files by name (`git add <file>...`). Do NOT use `git add -A` or `git add .` — avoid accidentally staging secrets or binaries.
3. Write a concise conventional commit message (1-2 sentences) focusing on **why**, not what.
4. Commit. Do NOT push. Do NOT use `--no-verify`.

## Rules
- Never stage `.env`, credentials, or large binaries.
- Never push — only commit locally.
- Never skip hooks (`--no-verify`).
- If there are no changes, say so and stop.
