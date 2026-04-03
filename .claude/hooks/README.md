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
| PostToolUse Edit\|Write\|NE | context-monitor.sh | Context exhaustion warning on write flows |
| PostToolUseFailure | post-tool-failure-log.sh | Failure logging to .claude/tool-failures.log |
| ConfigChange | config-change-audit.sh | Audit log + blocks disableAllHooks/Bash(*) |
| UserPromptSubmit | context-freshness.sh | CB reset + stale context warning |
| Notification | notify.sh | macOS/Linux desktop notifications |
| TaskCompleted | task-completed-gate.sh | Blocks WIP/TBD/merge-conflict closures |
| Stop | transcript-ingest.sh | Auto-extract session learnings via haiku |
| Stop | spec-stop-guard.sh | Blocks the first stop when specs remain in progress |
| PreCompact | (inline) | Auto-commit tracked changes before compaction |
| PreCompact | pre-compact-state.sh | Saves minimal in-progress spec state before compaction |
| SessionStart (compact) | post-compact-restore.sh | Fallback restore path after compaction |
| PostCompact | post-compact-restore.sh | Experimental early restore path after compaction |
| SubagentStart | subagent-start.sh | Experimental advisory hook for missing model fields / suspicious Haiku routing |
| SubagentStop | subagent-stop.sh | Experimental usage logger for subagent payloads |
| PermissionDenied | permission-denied-log.sh | Experimental denial logger with conditional remediation hints |
| PostToolUse Edit\|Write | tdd-checker.sh | Advisory warning when edited source lacks nearby tests |

## Dead-Loop Prevention

- `protect-and-breaker.sh` warns at 5 edits/10min, blocks at 8. Resets on user message.
- `context-monitor.sh` runs on write-oriented tool flows only. Keeping it off generic `Bash` avoids noisy PostToolUse churn when RTK rewrites shell commands.
- `post-edit-lint.sh` suppresses normal lint output to avoid fix-loop prompts.
- `tdd-checker.sh` is advisory only and always exits `0`.
- `spec-stop-guard.sh` uses a 60-second cooldown so an intentional second stop still works.
- `PostCompact`, `SubagentStart`, `SubagentStop`, and `PermissionDenied` are experimental event hooks. Availability depends on the Claude build; stable fallback paths must keep working if the events never fire.

## Debugging

```bash
# Test protect-and-breaker
echo '{"tool_input":{"file_path":"test.js"}}' | ./.claude/hooks/protect-and-breaker.sh
echo $?  # 0 = allowed, 2 = blocked

# View/clear circuit breaker log
cat /tmp/claude-cb-*.log
rm /tmp/claude-cb-*.log
```
