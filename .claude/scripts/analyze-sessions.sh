#!/bin/bash
# analyze-sessions.sh — Mines local Claude Code session logs for setup-optimization signals.
#
# Reads ~/.claude/projects/*/*.jsonl (read-only), aggregates tool usage, model mix,
# subagent spawns, skill invocations, bash command histogram, hook denials, errors.
# Emits JSON + Markdown report with concrete suggestions for templates/agents/skills/permissions.
#
# Usage:
#   bash .claude/scripts/analyze-sessions.sh                  # default: last 50 ONEDOT sessions
#   bash .claude/scripts/analyze-sessions.sh --last 100
#   bash .claude/scripts/analyze-sessions.sh --all            # all sessions, ONEDOT-filtered
#   bash .claude/scripts/analyze-sessions.sh --include-all    # no project filter
#   bash .claude/scripts/analyze-sessions.sh --out tmp/foo    # custom output dir
#
# Outputs:
#   tmp/session-analysis/data.json     # raw aggregated metrics
#   tmp/session-analysis/report.md     # human-readable findings + suggestions

set -eu

# --- Defaults ---
LAST_N=50
INCLUDE_ALL_PROJECTS=0
OUT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}/tmp/session-analysis"
SESSIONS_DIR="$HOME/.claude/projects"

# --- Args ---
while [ $# -gt 0 ]; do
  case "$1" in
    --last)
      LAST_N="$2"
      shift 2
      ;;
    --all)
      LAST_N=0
      shift
      ;;
    --include-all)
      INCLUDE_ALL_PROJECTS=1
      shift
      ;;
    --out)
      OUT_DIR="$2"
      shift 2
      ;;
    -h | --help)
      sed -n '2,18p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

# --- Preflight ---
command -v jq > /dev/null || {
  echo "jq required" >&2
  exit 1
}
[ -d "$SESSIONS_DIR" ] || {
  echo "No sessions dir: $SESSIONS_DIR" >&2
  exit 1
}

mkdir -p "$OUT_DIR"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# --- Step 1: pick session files ---
# ONEDOT filter: Sites-* or Obsidian-*; exclude Paperclip/tmp/private.
list_sessions() {
  if [ "$INCLUDE_ALL_PROJECTS" -eq 1 ]; then
    find "$SESSIONS_DIR" -maxdepth 2 -name '*.jsonl' -type f
  else
    find "$SESSIONS_DIR" -maxdepth 2 -name '*.jsonl' -type f |
      grep -E '/(-Users-deniskern-(Sites|Obsidian)-)' |
      grep -v -E '/(Paperclip|private-tmp|debug)' || true
  fi
}

# Sort by mtime desc, take top N (or all if N=0)
if [ "$LAST_N" -gt 0 ]; then
  list_sessions | xargs -I{} stat -f '%m %N' {} 2> /dev/null |
    sort -rn | head -n "$LAST_N" | awk '{print $2}' > "$TMP/files.txt"
else
  list_sessions > "$TMP/files.txt"
fi

FILE_COUNT=$(wc -l < "$TMP/files.txt" | tr -d ' ')
[ "$FILE_COUNT" -gt 0 ] || {
  echo "No session files matched" >&2
  exit 1
}
echo "Analyzing $FILE_COUNT session files..." >&2

# --- Step 2: extract per-record signals to NDJSON ---
# Schema: {kind, project, session, model?, tool?, cmd?, sub?, skill?, err?}
extract_session() {
  local f="$1"
  local proj
  proj=$(basename "$(dirname "$f")")
  local sess
  sess=$(basename "$f" .jsonl)

  # Tool uses with model context
  jq -c --arg p "$proj" --arg s "$sess" '
    select(.type=="assistant") |
    .message as $m |
    ($m.model // "unknown") as $model |
    ($m.content // []) |
    map(select(.type=="tool_use")) |
    .[] |
    {
      kind: "tool",
      project: $p,
      session: $s,
      model: $model,
      tool: .name,
      cmd: (if .name=="Bash" then (.input.command // "") else null end),
      sub: (if .name=="Agent" then (.input.subagent_type // "general-purpose") else null end),
      skill: (if .name=="Skill" then (.input.skill // "") else null end),
      file: (if .name=="Read" or .name=="Edit" or .name=="Write"
             then (.input.file_path // "") else null end)
    }
  ' "$f" 2> /dev/null

  # Tool errors (from user tool_result with is_error)
  jq -c --arg p "$proj" --arg s "$sess" '
    select(.type=="user") |
    (.message.content // []) |
    if type=="array" then .[] else empty end |
    select(type=="object" and .type=="tool_result" and (.is_error==true)) |
    {
      kind: "error",
      project: $p,
      session: $s,
      err: ((.content | tostring) | .[0:300])
    }
  ' "$f" 2> /dev/null

  # Token usage (per assistant turn)
  jq -c --arg p "$proj" --arg s "$sess" '
    select(.type=="assistant") |
    .message.usage as $u |
    select($u != null) |
    {
      kind: "usage",
      project: $p,
      session: $s,
      model: (.message.model // "unknown"),
      it: ($u.input_tokens // 0),
      ot: ($u.output_tokens // 0),
      cc: ($u.cache_creation_input_tokens // 0),
      cr: ($u.cache_read_input_tokens // 0)
    }
  ' "$f" 2> /dev/null
}

: > "$TMP/events.ndjson"
i=0
while IFS= read -r f; do
  i=$((i + 1))
  [ $((i % 10)) -eq 0 ] && echo "  ...processed $i / $FILE_COUNT" >&2
  extract_session "$f" >> "$TMP/events.ndjson" 2> /dev/null || true
done < "$TMP/files.txt"

EVENT_COUNT=$(wc -l < "$TMP/events.ndjson" | tr -d ' ')
echo "Extracted $EVENT_COUNT events" >&2

# --- Step 3: aggregate ---

# Tool frequency
jq -s '
  map(select(.kind=="tool")) |
  group_by(.tool) |
  map({tool: .[0].tool, count: length}) |
  sort_by(-.count)
' "$TMP/events.ndjson" > "$TMP/tools.json"

# Model mix
jq -s '
  map(select(.kind=="tool")) |
  group_by(.model) |
  map({model: .[0].model, count: length}) |
  sort_by(-.count)
' "$TMP/events.ndjson" > "$TMP/models.json"

# Subagent spawns
jq -s '
  map(select(.kind=="tool" and .tool=="Agent")) |
  group_by(.sub) |
  map({subagent: .[0].sub, count: length}) |
  sort_by(-.count)
' "$TMP/events.ndjson" > "$TMP/subagents.json"

# Skill invocations
jq -s '
  map(select(.kind=="tool" and .tool=="Skill")) |
  group_by(.skill) |
  map({skill: .[0].skill, count: length}) |
  sort_by(-.count)
' "$TMP/events.ndjson" > "$TMP/skills.json"

# Bash command histogram (first token after pipes/redirects stripped)
jq -r 'select(.kind=="tool" and .tool=="Bash" and .cmd != null) | .cmd' \
  "$TMP/events.ndjson" |
  sed -E 's/^[[:space:]]*//; s/[[:space:]]+/ /g' |
  awk '{
      n=split($0, a, /[|;&><]| /);
      cmd=a[1];
      # only keep bare command names (no slashes), reject shell keywords
      if (cmd ~ /^[A-Za-z_][A-Za-z0-9_.-]*$/ &&
          cmd !~ /^(for|while|if|do|done|then|else|fi|case|esac|in|true|false)$/) print cmd;
    }' |
  sort | uniq -c | sort -rn | head -50 |
  awk '{printf "{\"cmd\":\"%s\",\"count\":%s}\n", $2, $1}' |
  jq -s '.' > "$TMP/bash.json"

# Hook denials / blocks (extract from error content)
jq -s '
  map(select(.kind=="error")) |
  map(.err) |
  map(
    if (test("hook error|blocked|denied|hook failed"; "i")) then
      {pattern: (capture("(?<p>(hook error[^\n]{0,80}|blocked[^\n]{0,80}|denied[^\n]{0,80}))"; "i") // {p:"unknown"} | .p)}
    else empty end
  ) |
  group_by(.pattern) |
  map({pattern: .[0].pattern, count: length}) |
  sort_by(-.count) |
  .[0:20]
' "$TMP/events.ndjson" > "$TMP/denials.json" 2> /dev/null || echo '[]' > "$TMP/denials.json"

# Token totals by model
jq -s '
  map(select(.kind=="usage")) |
  group_by(.model) |
  map({
    model: .[0].model,
    turns: length,
    in_total: (map(.it) | add),
    out_total: (map(.ot) | add),
    cache_create: (map(.cc) | add),
    cache_read: (map(.cr) | add)
  }) |
  sort_by(-.cache_read)
' "$TMP/events.ndjson" > "$TMP/tokens.json"

# Per-project tool count (which projects active)
jq -s '
  map(select(.kind=="tool")) |
  group_by(.project) |
  map({project: .[0].project, calls: length}) |
  sort_by(-.calls) |
  .[0:15]
' "$TMP/events.ndjson" > "$TMP/projects.json"

# --- Step 4: derive suggestions ---
# Logic:
#  - bash commands seen >=10x and not in current allowlist → permission candidates
#  - subagents not in repo → consider importing
#  - skills used heavily but not in /skills → install candidate
#  - hook denials with high count → review hook (false positive risk)

ALLOWLIST_FILE="${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/settings.json"
CURRENT_ALLOW=""
if [ -f "$ALLOWLIST_FILE" ]; then
  CURRENT_ALLOW=$(jq -r '.permissions.allow // [] | .[]' "$ALLOWLIST_FILE" 2> /dev/null || true)
fi

# Bash candidates: cmd >=10 calls, not already covered by Bash(<cmd>:*) or Bash(<cmd> *) in allow
jq -r '.[] | select(.count >= 10) | .cmd' "$TMP/bash.json" > "$TMP/bash_freq.txt"

: > "$TMP/bash_candidates.txt"
while IFS= read -r cmd; do
  [ -z "$cmd" ] && continue
  if echo "$CURRENT_ALLOW" | grep -qE "Bash\(${cmd}([: ]|\\*|\\))"; then
    continue
  fi
  count=$(jq -r --arg c "$cmd" '.[] | select(.cmd==$c) | .count' "$TMP/bash.json")
  echo "$count $cmd" >> "$TMP/bash_candidates.txt"
done < "$TMP/bash_freq.txt"

# --- Step 5: Write JSON ---
jq -n \
  --slurpfile tools "$TMP/tools.json" \
  --slurpfile models "$TMP/models.json" \
  --slurpfile subagents "$TMP/subagents.json" \
  --slurpfile skills "$TMP/skills.json" \
  --slurpfile bash "$TMP/bash.json" \
  --slurpfile denials "$TMP/denials.json" \
  --slurpfile tokens "$TMP/tokens.json" \
  --slurpfile projects "$TMP/projects.json" \
  --arg sessions "$FILE_COUNT" \
  --arg events "$EVENT_COUNT" \
  '{
    meta: {
      sessions_analyzed: ($sessions | tonumber),
      events_extracted: ($events | tonumber),
      generated_at: now | strftime("%Y-%m-%dT%H:%M:%SZ")
    },
    tools: $tools[0],
    models: $models[0],
    subagents: $subagents[0],
    skills: $skills[0],
    bash_top: $bash[0],
    denials: $denials[0],
    tokens: $tokens[0],
    projects: $projects[0]
  }' > "$OUT_DIR/data.json"

# --- Step 6: Write Markdown report ---
{
  echo "# Session Analysis Report"
  echo
  echo "_Generated $(date '+%Y-%m-%d %H:%M')_"
  echo "_Sessions: ${FILE_COUNT} - Events: ${EVENT_COUNT}_"
  echo

  echo "## Tool Frequency (top 15)"
  echo
  echo "| Tool | Calls |"
  echo "|------|------:|"
  jq -r '.[0:15] | .[] | "| \(.tool) | \(.count) |"' "$TMP/tools.json"
  echo

  echo "## Model Mix"
  echo
  echo "| Model | Calls |"
  echo "|-------|------:|"
  jq -r '.[] | "| \(.model) | \(.count) |"' "$TMP/models.json"
  echo

  echo "## Subagent Spawns"
  echo
  if [ "$(jq 'length' "$TMP/subagents.json")" -eq 0 ]; then
    echo "_No subagents spawned in sample._"
  else
    echo "| Subagent | Spawns |"
    echo "|----------|------:|"
    jq -r '.[] | "| \(.subagent) | \(.count) |"' "$TMP/subagents.json"
  fi
  echo

  echo "## Skill Invocations (top 20)"
  echo
  if [ "$(jq 'length' "$TMP/skills.json")" -eq 0 ]; then
    echo "_No skills invoked in sample._"
  else
    echo "| Skill | Calls |"
    echo "|-------|------:|"
    jq -r '.[0:20] | .[] | "| \(.skill) | \(.count) |"' "$TMP/skills.json"
  fi
  echo

  echo "## Top Bash Commands (top 30)"
  echo
  echo "| Command | Calls |"
  echo "|---------|------:|"
  jq -r '.[0:30] | .[] | "| `\(.cmd)` | \(.count) |"' "$TMP/bash.json"
  echo

  echo "## Token Usage by Model"
  echo
  echo "| Model | Turns | Input | Output | Cache Read | Cache Create |"
  echo "|-------|------:|------:|-------:|-----------:|-------------:|"
  jq -r '.[] | "| \(.model) | \(.turns) | \(.in_total) | \(.out_total) | \(.cache_read) | \(.cache_create) |"' "$TMP/tokens.json"
  echo

  echo "## Hook Denials / Blocks"
  echo
  if [ "$(jq 'length' "$TMP/denials.json")" -eq 0 ]; then
    echo "_No hook denials detected._"
  else
    echo "| Pattern | Count |"
    echo "|---------|------:|"
    jq -r '.[] | "| `\(.pattern // "unknown")` | \(.count) |"' "$TMP/denials.json"
  fi
  echo

  echo "## Most Active Projects"
  echo
  echo "| Project | Tool calls |"
  echo "|---------|----------:|"
  jq -r '.[] | "| `\(.project)` | \(.calls) |"' "$TMP/projects.json"
  echo

  # --- Suggestions ---
  echo "## Suggestions"
  echo
  echo "### Permission Allowlist Candidates"
  echo
  echo "_Bash commands called \\>=10x in sample, not currently allowed in \`.claude/settings.json\`._"
  echo "_Adding these to \`permissions.allow\` would reduce permission prompts._"
  echo
  if [ -s "$TMP/bash_candidates.txt" ]; then
    echo "| Count | Command | Suggested rule |"
    echo "|------:|---------|----------------|"
    sort -rn "$TMP/bash_candidates.txt" | head -20 | while read -r count cmd; do
      echo "| $count | \`$cmd\` | \`Bash($cmd:*)\` |"
    done
  else
    echo "_None — current allowlist already covers high-frequency commands._"
  fi
  echo

  echo "### Skill / Subagent Coverage"
  echo
  REPO_SKILLS=$(ls "${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/skills/" 2> /dev/null | tr '\n' ' ')
  REPO_AGENTS=$(ls "${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/agents/" 2> /dev/null | sed 's/\.md$//g' | tr '\n' ' ')
  echo "_Repo skills:_ \`$REPO_SKILLS\`"
  echo
  echo "_Repo agents:_ \`$REPO_AGENTS\`"
  echo
  echo "Heavy-use external skills/subagents from sessions that aren't installed here are candidates"
  echo "for templating. Cross-check the tables above against repo agents/skills."
  echo

  echo "### Hook Health"
  echo
  TOTAL_TOOLS=$(jq '[.[].count] | add // 0' "$TMP/tools.json")
  TOTAL_DEN=$(jq '[.[].count] | add // 0' "$TMP/denials.json")
  if [ "$TOTAL_TOOLS" -gt 0 ] && [ "$TOTAL_DEN" -gt 0 ]; then
    PCT=$(awk -v d="$TOTAL_DEN" -v t="$TOTAL_TOOLS" 'BEGIN{printf "%.1f", d*100/t}')
    echo "Denial rate: $TOTAL_DEN / $TOTAL_TOOLS calls ($PCT%)."
    if awk -v p="$PCT" 'BEGIN{exit !(p>5)}'; then
      echo
      echo "**>5% — review hook false-positive rate.** Top patterns above."
    fi
  else
    echo "No denial signals."
  fi
  echo

  echo "### Model Routing Sanity"
  echo
  echo "Compare model mix against \`.claude/rules/agents.md\`:"
  echo "- haiku — explore/search only"
  echo "- sonnet — implementation default"
  echo "- opus — arch / spec"
  echo
  echo "If opus dominates implementation tool calls, delegation mandates aren't firing."
  echo

  echo "## Raw Data"
  echo
  echo "Machine-readable: \`$OUT_DIR/data.json\`"
} > "$OUT_DIR/report.md"

echo
echo "Done."
echo "  Report: $OUT_DIR/report.md"
echo "  Data:   $OUT_DIR/data.json"
