# Hook Configuration Guide

## Active Hooks

| Hook | Event | Purpose | Customization |
|------|-------|---------|---------------|
| `protect-files.sh` | PreToolUse | Blocks edits to `.env`, `package-lock.json`, `.git/` | Edit `PROTECTED` array |
| `circuit-breaker.sh` | PreToolUse | Warns at 5 edits, blocks at 8 edits to same file in 10 min | Edit `WARN`/`BLOCK`/`WINDOW` vars |
| `post-edit-lint.sh` | PostToolUse | ESLint on `.js`/`.ts`/`.jsx`/`.tsx`, Prettier on `.css`/`.html`/`.json`/`.md`/`.vue`/`.svelte` | Add extensions or change tools |
| `context-freshness.sh` | UserPromptSubmit | Warns when `.agents/context/` is stale | Runs silently unless project files changed |

**Exit codes:** `0` = pass, `1` = fail with feedback, `2` = blocked

## Debugging

```bash
# Test a hook manually
echo '{"tool_input":{"file_path":"test.js"}}' | ./.claude/hooks/protect-files.sh
echo $?  # 0 = allowed, 2 = blocked

# View/clear circuit breaker log
cat /tmp/claude-cb-*.log
rm /tmp/claude-cb-*.log
```

## Disabling Hooks

Remove the hook block from `.claude/settings.json`, or add `exit 0` at the top of the script.
