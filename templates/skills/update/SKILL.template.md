---
name: update
description: Check for ai-setup updates and install from within Claude Code
user-invocable: true
effort: medium
allowed-tools:
  - Bash
  - AskUserQuestion
  - Read
disable-model-invocation: true
---

Check for ai-setup updates, show what changed, and install if the user confirms.

## Process

### 1. Detect installed version

```bash
jq -r '.version // empty' "${CLAUDE_PROJECT_DIR:-.}/.ai-setup.json" 2>/dev/null || echo ""
```

If `.ai-setup.json` is missing, tell the user ai-setup is not installed and suggest `npx github:onedot-digital-crew/npx-ai-setup`.

### 2. Check latest version

```bash
npm view @onedot/ai-setup version 2>/dev/null || curl -fsSL --max-time 5 "https://api.github.com/repos/onedot-digital-crew/npx-ai-setup/releases/latest" 2>/dev/null | jq -r '.tag_name // empty' | sed 's/^v//'
```

If both fail, report that the version check is unavailable.

### 3. Compare versions

Only continue if `latest > installed`.
- Same version: stop with "Already up to date"
- Installed > latest: stop with "You're ahead of the latest release"

### 4. Fetch changelog

```bash
curl -fsSL --max-time 5 "https://raw.githubusercontent.com/onedot-digital-crew/npx-ai-setup/main/CHANGELOG.md" 2>/dev/null | head -80
```

Extract entries between installed and latest. If unavailable, continue without changelog text.

### 5. Confirm update

Show:

```text
## ai-setup Update Available
Installed: vX.Y.Z
Latest:    vA.B.C

### What's New
[changelog summary if available]
```

Ask: `Yes, update now` or `No, cancel`.

### 6. Capture pre-update SHA

```bash
git -C "${CLAUDE_PROJECT_DIR:-.}" rev-parse HEAD 2>/dev/null > /tmp/ai-setup-pre-sha.txt || true
```

### 7. Run update

```bash
npx github:onedot-digital-crew/npx-ai-setup
```

### 8. Clear update cache

```bash
rm -f /tmp/ai-setup-update-*.txt /tmp/ai-setup-cli-latest-version.txt
```

### 9. Show changed files

```bash
PRE_SHA=$(cat /tmp/ai-setup-pre-sha.txt 2>/dev/null | tr -cd 'a-f0-9'); rm -f /tmp/ai-setup-pre-sha.txt
[ -n "$PRE_SHA" ] && git -C "${CLAUDE_PROJECT_DIR:-.}" diff --name-status "$PRE_SHA" HEAD -- .claude/ templates/ CLAUDE.md 2>/dev/null | head -30 || echo "(no git history available)"
```

Summarize changed files concisely. If nothing changed, say so explicitly.

## Rules
- Do not continue if the user declines the update.
- Prefer concise changelog summaries.
- Report no-op updates clearly.

## Next Step

Restart Claude Code and run `/health`.
