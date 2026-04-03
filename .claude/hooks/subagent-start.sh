#!/usr/bin/env bash
# subagent-start.sh — experimental advisory hook
# Event availability is not guaranteed in public Claude releases.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
[ -n "$INPUT" ] || exit 0

MODEL=$(printf '%s' "$INPUT" | jq -r '.model // ""' 2>/dev/null)
AGENT_NAME=$(printf '%s' "$INPUT" | jq -r '.agent_name // .name // ""' 2>/dev/null)
ROLE=$(printf '%s' "$INPUT" | jq -r '.agent_role // .role // ""' 2>/dev/null)
TOOLS=$(printf '%s' "$INPUT" | jq -r '[(.allowed_tools // []), (.tools // [])] | flatten | join(",")' 2>/dev/null)
READ_ONLY=$(printf '%s' "$INPUT" | jq -r '.read_only // .is_read_only // false' 2>/dev/null)

[ "$MODEL" = "null" ] && MODEL=""
[ "$AGENT_NAME" = "null" ] && AGENT_NAME=""
[ "$ROLE" = "null" ] && ROLE=""
[ "$TOOLS" = "null" ] && TOOLS=""
[ "$READ_ONLY" = "null" ] && READ_ONLY="false"

LABEL="${AGENT_NAME:-${ROLE:-subagent}}"

if [ -z "$MODEL" ]; then
  printf '[subagent-start] %s started without model field; parent-model inheritance may be active.\n' "$LABEL" >&2
  exit 0
fi

case "$MODEL" in
  *haiku*)
    case "$READ_ONLY|$TOOLS|$ROLE" in
      true*|*Read*|*Glob*|*Grep*|*explore*)
        exit 0
        ;;
      *)
        printf '[subagent-start] %s appears to use a Haiku-class model for non-read-only work (%s).\n' "$LABEL" "$MODEL" >&2
        ;;
    esac
    ;;
esac

exit 0
