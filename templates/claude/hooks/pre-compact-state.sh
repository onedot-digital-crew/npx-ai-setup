#!/usr/bin/env bash
# pre-compact-state.sh — PreCompact hook
# Saves unified session handoff state before context compaction.

cat >/dev/null

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
STATE_FILE="$PROJECT_ROOT/.claude/session-state.json"
mkdir -p "$(dirname "$STATE_FILE")" 2>/dev/null || exit 0

ACTIVE_SPECS=()
for spec_file in "$PROJECT_ROOT"/specs/*.md; do
  [ -f "$spec_file" ] || continue
  if grep -q '^> .*Status.*in-progress' "$spec_file" 2>/dev/null; then
    ACTIVE_SPECS+=("${spec_file#$PROJECT_ROOT/}")
  fi
done

ACTIVE_SPEC=""
if [ "${#ACTIVE_SPECS[@]}" -gt 0 ]; then
  ACTIVE_SPEC="${ACTIVE_SPECS[0]}"
fi

TMP_FILE="${STATE_FILE}.tmp"
if command -v jq >/dev/null 2>&1; then
  if [ "${#ACTIVE_SPECS[@]}" -gt 0 ]; then
    printf '%s\n' "${ACTIVE_SPECS[@]}" | jq -R . | jq -s \
      --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      --arg active "$ACTIVE_SPEC" \
      '{
        updated_at: $ts,
        source: "pre-compact",
        phase: "compaction",
        active_spec: $active,
        active_specs: .,
        next_action: "Resume the in-progress spec after compaction",
        has_active_spec: true
      }' > "$TMP_FILE" 2>/dev/null || exit 0
  else
    jq -n --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '{
      updated_at: $ts,
      source: "pre-compact",
      phase: "compaction",
      active_spec: "",
      active_specs: [],
      next_action: "Start with the current priority task or inspect open specs",
      has_active_spec: false
    }' > "$TMP_FILE" 2>/dev/null || exit 0
  fi
else
  {
    echo "{"
    echo "  \"updated_at\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
    echo "  \"source\": \"pre-compact\","
    echo "  \"phase\": \"compaction\","
    echo "  \"active_spec\": \"${ACTIVE_SPEC}\","
    if [ "${#ACTIVE_SPECS[@]}" -gt 0 ]; then
      echo "  \"active_specs\": ["
      i=0
      for spec in "${ACTIVE_SPECS[@]}"; do
        i=$((i + 1))
        suffix=","
        [ "$i" -eq "${#ACTIVE_SPECS[@]}" ] && suffix=""
        printf '    "%s"%s\n' "$spec" "$suffix"
      done
      echo "  ],"
      echo "  \"next_action\": \"Resume the in-progress spec after compaction\","
      echo "  \"has_active_spec\": true"
    else
      echo "  \"active_specs\": [],"
      echo "  \"next_action\": \"Start with the current priority task or inspect open specs\","
      echo "  \"has_active_spec\": false"
    fi
    echo "}"
  } > "$TMP_FILE" 2>/dev/null || exit 0
fi

mv "$TMP_FILE" "$STATE_FILE" 2>/dev/null || true
exit 0
