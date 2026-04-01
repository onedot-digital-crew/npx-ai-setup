#!/usr/bin/env bash
# pre-compact-state.sh — PreCompact hook
# Saves minimal in-progress spec state before context compaction.

cat >/dev/null

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
STATE_FILE="$PROJECT_ROOT/.claude/compact-state.json"
mkdir -p "$(dirname "$STATE_FILE")" 2>/dev/null || exit 0

ACTIVE_SPECS=()
for spec_file in "$PROJECT_ROOT"/specs/*.md; do
  [ -f "$spec_file" ] || continue
  if grep -q '^\> .*Status.*in-progress' "$spec_file" 2>/dev/null; then
    ACTIVE_SPECS+=("${spec_file#$PROJECT_ROOT/}")
  fi
done

TMP_FILE="${STATE_FILE}.tmp"
if command -v jq >/dev/null 2>&1; then
  if [ "${#ACTIVE_SPECS[@]}" -gt 0 ]; then
    printf '%s\n' "${ACTIVE_SPECS[@]}" | jq -R . | jq -s --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '{
      saved_at: $ts,
      has_active_spec: true,
      active_specs: .
    }' > "$TMP_FILE" 2>/dev/null || exit 0
  else
    jq -n --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '{
      saved_at: $ts,
      has_active_spec: false,
      active_specs: []
    }' > "$TMP_FILE" 2>/dev/null || exit 0
  fi
else
  {
    echo "{"
    echo "  \"saved_at\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
    if [ "${#ACTIVE_SPECS[@]}" -gt 0 ]; then
      echo "  \"has_active_spec\": true,"
      echo "  \"active_specs\": ["
      i=0
      for spec in "${ACTIVE_SPECS[@]}"; do
        i=$((i + 1))
        suffix=","
        [ "$i" -eq "${#ACTIVE_SPECS[@]}" ] && suffix=""
        printf '    "%s"%s\n' "$spec" "$suffix"
      done
      echo "  ]"
    else
      echo "  \"has_active_spec\": false,"
      echo "  \"active_specs\": []"
    fi
    echo "}"
  } > "$TMP_FILE" 2>/dev/null || exit 0
fi

mv "$TMP_FILE" "$STATE_FILE" 2>/dev/null || true
exit 0
