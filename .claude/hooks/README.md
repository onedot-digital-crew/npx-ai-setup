# Hook Configuration Guide

See `AGENTS.md` for the full active-hook inventory and customization overview.
Hook scripts use these exit codes: `0` = pass, `1` = fail with feedback, `2` = blocked

## Dead-Loop Prevention Notes

- `circuit-breaker.sh` warning output is intentionally strict even on `exit 0`, so the model is told not to keep editing the same file before the hard block triggers.
- `context-monitor.sh` uses advisory wording only. It should suggest saving state and wrapping up, but it must not issue imperative workflow commands that can trigger unnecessary tool calls.
- `context-monitor.sh` should stay scoped to write-oriented tool flows. Running it after every `Bash` call adds avoidable hook churn and can create noisy interactions with RTK's Bash rewrite hook.
- `templates/claude/settings.json` is the compact-threshold source of truth. `context-monitor.sh` warning copy should mirror the configured `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` value instead of inventing its own trigger.
- `context-loader.sh` is a local harness optimization: it injects abstract frontmatter only from the highest-priority context files and caps section detail to keep SessionStart stable.
- `file-index.sh` is also local harness behavior: it emits a compact repo-shape index for the current project type (for example Bash CLI/setup repos), not a clone of Claude-internal indexing.
- `subagent-start.sh` and `subagent-stop.sh` are experimental hooks. They stay advisory/logging-only and must tolerate missing or partial event payloads.
- `permission-denied-log.sh` logs denial payloads and only prints source-specific remediation when the event payload identifies the denial source clearly.
- `post-edit-lint.sh` suppresses normal formatter/linter output to avoid fix-loop prompts from non-fatal lint noise.
- `tdd-checker.sh` is advisory only. It warns about missing nearby tests after source edits but must never block an edit.
- `spec-stop-guard.sh` blocks the first Stop while a spec is still in progress, then allows a second Stop within 60 seconds.

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
