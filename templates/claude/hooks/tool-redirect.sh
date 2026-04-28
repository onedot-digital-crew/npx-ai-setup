#!/bin/bash
# PreToolUse — redirects:
#   1. WebFetch  → defuddle (token savings)
#   2. Bash: bare `git` → rtk git (token savings)
#   3. Bash: GitHub ops → gh (gh pr, gh issue, etc.)
#   4. Bash: head/cat/tail → Read tool (token savings)
#   5. Bash: grep/find    → Grep/Glob tools (token savings)

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Emergency bypass — set RTK_SKIP=1 to disable all redirects (e.g. when rtk itself is broken).
if [ "${RTK_SKIP:-0}" = "1" ]; then
  exit 0
fi

# ── 1. WebFetch → defuddle ───────────────────────────────────────────────────
if [ "$TOOL_NAME" = "WebFetch" ]; then
  command -v defuddle > /dev/null 2>&1 || exit 0
  URL=$(echo "$INPUT" | jq -r '.tool_input.url // empty')
  cat >&2 << EOF
WebFetch blocked — defuddle first (project rule: .claude/rules/general.md).
Saves ~80% tokens vs. WebFetch.

Use:      defuddle parse "$URL" --md
Fallback: WebFetch https://markdown.new/$URL

Only use WebFetch directly if the page requires JavaScript rendering or defuddle returns empty output.
EOF
  exit 2
fi

# ── 2. Bash: redirect file/search tools to native Claude tools ──────────────
if [ "$TOOL_NAME" = "Bash" ]; then
  CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

  # Skip redirects when command is piped/chained — those are legit shell usage
  # Only block standalone file-reading/searching invocations.
  IS_PIPELINE=0
  if echo "$CMD" | grep -qE '[|]|<<|>>|\$\(|`'; then
    IS_PIPELINE=1
  fi

  if [ "$IS_PIPELINE" -eq 0 ]; then
    # head/cat/tail → Read tool
    if echo "$CMD" | grep -qE '^[[:space:]]*(head|cat|tail)[[:space:]]+[^|;&]*$'; then
      BIN=$(echo "$CMD" | grep -oE '^[[:space:]]*(head|cat|tail)' | tr -d ' ')
      cat >&2 << EOF
Bash blocked — use Read tool instead of \`$BIN\` (project rule: CLAUDE.md agents.md).

Read tool supports offset/limit for partial reads and avoids line-number re-encoding.
Only use \`$BIN\` in pipes or scripts (cat file | grep ...).
EOF
      exit 2
    fi

    # grep → Grep tool
    if echo "$CMD" | grep -qE '^[[:space:]]*grep[[:space:]]'; then
      cat >&2 << EOF
Bash blocked — use Grep tool instead of \`grep\` (project rule: CLAUDE.md agents.md).

Grep tool uses bfs/ugrep under the hood (macOS/Linux native) with better defaults and glob filtering.
Only use bash \`grep\` inside pipes (cat x | grep y).
EOF
      exit 2
    fi

    # find → Glob tool (only when used for listing — skip -exec/-delete/-print0)
    if echo "$CMD" | grep -qE '^[[:space:]]*find[[:space:]]' &&
      ! echo "$CMD" | grep -qE '\-(exec|delete|print0|prune|ok|execdir)\b'; then
      cat >&2 << EOF
Bash blocked — use Glob tool instead of \`find\` (project rule: CLAUDE.md agents.md).

Glob supports patterns like \`**/*.ts\` and returns sorted by mtime.
Only use \`find\` for -exec, -delete, or other non-listing ops.
EOF
      exit 2
    fi
  fi

  # Check for bare `git` (not prefixed with rtk)
  # Match: git at start, after &&, after ;, or after whitespace — NOT inside .git/ paths
  # Skip entirely if rtk is not installed on this workstation (avoid deadlock).
  if command -v rtk > /dev/null 2>&1 &&
    echo "$CMD" | grep -qE '(^|[[:space:];&])git[[:space:]]' &&
    ! echo "$CMD" | grep -qE '(^|[[:space:];&])rtk[[:space:]]+git[[:space:]]' &&
    ! echo "$CMD" | grep -qE '\.git/'; then
    # Extract git subcommand (first word after git, ignoring rev-range args like HASH..HEAD)
    SUBCMD=$(echo "$CMD" | grep -oE '(^|[[:space:];&])git[[:space:]]+[a-z-]+' | head -1 | awk '{print $NF}')

    # GitHub-specific operations → suggest gh
    case "$SUBCMD" in
      push | pull | fetch | clone | remote)
        cat >&2 << EOF
Bash blocked — use \`gh\` for GitHub operations (project rule: .claude/rules/git.md).

Instead of: git $SUBCMD ...
Use:        gh repo clone / gh pr create / gh repo sync / etc.

For local git ops, always prefix with rtk:
  rtk git status / rtk git diff / rtk git log
EOF
        exit 2
        ;;
      *)
        cat >&2 << EOF
Bash blocked — prefix git with rtk for token savings (project rule: CLAUDE.md).

Instead of: git $SUBCMD ...
Use:        rtk git $SUBCMD ...

For GitHub operations (push, pull, fetch, clone), use gh instead.
EOF
        exit 2
        ;;
    esac
  fi
fi

exit 0
