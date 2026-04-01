# Hook Configuration Guide

Hook scripts use these exit codes: `0` = pass, `1` = fail with feedback, `2` = blocked

## Active Hooks (10 events, 16 hook entries)

| Event | Script | Purpose |
|-------|--------|---------|
| SessionStart | context-loader.sh | L0 abstracts from .agents/context/ |
| SessionStart | mcp-health.sh | Validates .mcp.json syntax and commands |
| SessionStart | cli-health.sh | Warns about missing tools (rtk, defuddle, jq) |
| PreToolUse Edit\|Write | protect-and-breaker.sh | Protected file guard + edit loop detection |
| PostToolUse Edit\|Write | post-edit-lint.sh | Auto-format/lint (silent output) |
| PostToolUse Bash\|Edit\|Write\|NE | context-monitor.sh | Context exhaustion warning |
| PostToolUseFailure | post-tool-failure-log.sh | Failure logging to .claude/tool-failures.log |
| ConfigChange | config-change-audit.sh | Audit log + blocks disableAllHooks/Bash(*) |
| UserPromptSubmit | context-freshness.sh | CB reset + stale context warning |
| Notification | notify.sh | macOS/Linux desktop notifications |
| TaskCompleted | task-completed-gate.sh | Blocks WIP/TBD/merge-conflict closures |
| Stop | transcript-ingest.sh | Auto-extract session learnings via haiku |
| Stop | spec-stop-guard.sh | Blocks the first stop when specs remain in progress |
| PreCompact | (inline) | Auto-commit tracked changes before compaction |
| PreCompact | pre-compact-state.sh | Saves minimal in-progress spec state before compaction |
| SessionStart (compact) | post-compact-restore.sh | Restores a short resume hint after compaction |
| PostToolUse Edit\|Write | tdd-checker.sh | Advisory warning when edited source lacks nearby tests |

## Dead-Loop Prevention

- `protect-and-breaker.sh` warns at 5 edits/10min, blocks at 8. Resets on user message.
- `context-monitor.sh` suggests saving state — advisory only, no imperative commands.
- `post-edit-lint.sh` suppresses normal lint output to avoid fix-loop prompts.
- `tdd-checker.sh` is advisory only and always exits `0`.
- `spec-stop-guard.sh` uses a 60-second cooldown so an intentional second stop still works.

## Debugging

```bash
# Test protect-and-breaker
echo '{"tool_input":{"file_path":"test.js"}}' | ./.claude/hooks/protect-and-breaker.sh
echo $?  # 0 = allowed, 2 = blocked

# View/clear circuit breaker log
cat /tmp/claude-cb-*.log
rm /tmp/claude-cb-*.log
```
