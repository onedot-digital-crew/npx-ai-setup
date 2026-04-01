# Hook Configuration Guide

See `AGENTS.md` for the full active-hook inventory and customization overview.
Hook scripts use these exit codes: `0` = pass, `1` = fail with feedback, `2` = blocked

## Dead-Loop Prevention Notes

- `circuit-breaker.sh` warning output is intentionally strict even on `exit 0`, so the model is told not to keep editing the same file before the hard block triggers.
- `context-monitor.sh` uses advisory wording only. It should suggest saving state and wrapping up, but it must not issue imperative workflow commands that can trigger unnecessary tool calls.
- `post-edit-lint.sh` suppresses normal formatter/linter output to avoid fix-loop prompts from non-fatal lint noise.
- `tdd-checker.sh` is advisory only. It warns about missing nearby tests after source edits but must never block an edit.
- `spec-stop-guard.sh` blocks the first Stop while a spec is still in progress, then allows a second Stop within 60 seconds.
- `pre-compact-state.sh` writes minimal in-progress spec state before compaction, and `post-compact-restore.sh` restores a short resume hint on compact restarts.

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
