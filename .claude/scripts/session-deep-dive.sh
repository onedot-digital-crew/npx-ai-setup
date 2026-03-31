#!/usr/bin/env bash
# session-deep-dive.sh — Analyze one exported Claude session transcript
# Usage: bash .claude/scripts/session-deep-dive.sh /path/to/session-<id>.txt
set -euo pipefail

SESSION_FILE="${1:-}"

if [ -z "$SESSION_FILE" ]; then
  echo "Usage: bash .claude/scripts/session-deep-dive.sh /path/to/session-<id>.txt" >&2
  exit 1
fi

if [ ! -f "$SESSION_FILE" ]; then
  echo "Session export not found: $SESSION_FILE" >&2
  exit 1
fi

python3 - "$SESSION_FILE" "$PWD" <<'PYEOF'
import json
import re
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path


def read_text(path):
    try:
        return Path(path).read_text(errors="ignore")
    except Exception:
        return ""


def read_json(path):
    try:
        with open(path) as handle:
            return json.load(handle)
    except Exception:
        return None


def file_contains(path, needles):
    text = read_text(path)
    if not text:
        return False
    return all(needle in text for needle in needles)


def extract(pattern, text):
    match = re.search(pattern, text, re.M)
    return match.group(1).strip() if match else ""


def parse_iso(raw):
    if not raw:
        return None
    try:
        return datetime.fromisoformat(raw.replace("Z", "+00:00"))
    except Exception:
        return None


def parse_export_date(raw):
    if not raw:
        return None
    try:
        return datetime.strptime(raw, "%Y-%m-%d %H:%M:%S UTC").replace(tzinfo=timezone.utc)
    except Exception:
        return None


def topic_label(message):
    low = message.lower()
    if any(x in low for x in ["picker", "badge", "pro version", "versionen vergleichen", "uvp", "label"]):
        return "picker"
    if any(x in low for x in ["gallery", "thumb", "thumbs", "abgeschnitten", "overflow", "scrollbar", "container"]):
        return "gallery"
    if any(x in low for x in ["vite", "build", "dev", "endloss schleife"]):
        return "tooling"
    if any(x in low for x in ["branch", "metafields", "snippet"]):
        return "implementation"
    if "<task-notification>" in low:
        return "notification"
    return "other"


session_file = Path(sys.argv[1]).expanduser()
repo_root = Path(sys.argv[2]).resolve()
text = read_text(session_file)

metrics = {
    "session": extract(r"^Session:\s+(.*)$", text),
    "project": extract(r"^Project:\s+(.*)$", text),
    "branch": extract(r"^Branch:\s+(.*)$", text),
    "date": extract(r"^Date:\s+(.*)$", text),
    "duration": extract(r"^Duration:\s+(.*)$", text),
    "total_tokens": extract(r"^Total Tokens:\s+([\d,]+)$", text),
    "input_tokens": extract(r"^Input Tokens:\s+([\d,]+)$", text),
    "output_tokens": extract(r"^Output Tokens:\s+([\d,]+)$", text),
    "cache_read": extract(r"^Cache Read:\s+([\d,]+)$", text),
    "cache_created": extract(r"^Cache Created:\s+([\d,]+)$", text),
    "messages": extract(r"^Messages:\s+([\d,]+)$", text),
}

sections = Counter(re.findall(r"^────────────────────────────────────────\n([A-Z]+):", text, re.M))
user_messages = re.findall(r"^USER: (.*)$", text, re.M)
skill_calls = text.count("Tool: Skill")
agent_calls = text.count("Tool: Agent")

correction_markers = [
    "geht nicht",
    "immer noch",
    "rückgängig",
    "nein",
    "falsch",
    "anders",
    "nochmal",
    "funktioniert",
    "abgeschnitten",
    "scrollbar",
    "endloss schleife",
]
correction_hits = []
for message in user_messages:
    low = message.lower()
    matched = [marker for marker in correction_markers if marker in low]
    if matched:
        correction_hits.append((message[:160], matched))

labels = []
for message in user_messages:
    label = topic_label(message)
    if not labels or labels[-1] != label:
        labels.append(label)

non_notification_labels = [label for label in labels if label != "notification"]
topic_shifts = max(len(non_notification_labels) - 1, 0)
automation_dropoff = skill_calls <= 1 and len(user_messages) >= 20
same_theme_corrections = Counter()
for message, _matched in correction_hits:
    same_theme_corrections[topic_label(message)] += 1
max_same_theme_corrections = max(same_theme_corrections.values(), default=0)

project_root = Path(metrics["project"]).expanduser() if metrics["project"] else None
project_setup = read_json(project_root / ".ai-setup.json") if project_root else None
repo_package = read_json(repo_root / "package.json")
project_claude = project_root / "CLAUDE.md" if project_root else None
project_legacy_spec_work = project_root / ".claude" / "commands" / "spec-work.md" if project_root else None
project_skill_spec_work = project_root / ".claude" / "skills" / "spec-work" / "SKILL.md" if project_root else None

project_version = project_setup.get("version", "unknown") if isinstance(project_setup, dict) else "unknown"
project_updated_at = project_setup.get("updated_at", "") if isinstance(project_setup, dict) else ""
repo_version = repo_package.get("version", "unknown") if isinstance(repo_package, dict) else "unknown"

session_dt = parse_export_date(metrics["date"])
updated_dt = parse_iso(project_updated_at)
if updated_dt and session_dt and session_dt < updated_dt:
    version_lens = "historical-pre-update-session"
elif project_version != "unknown":
    version_lens = "post-update-session"
else:
    version_lens = "unknown"

config_drift_reasons = []
if project_version != "unknown" and project_version == repo_version and project_claude and project_claude.exists():
    if not file_contains(project_claude, ["Haiku", "explore"]):
        config_drift_reasons.append("CLAUDE.md missing current Haiku/explore routing language")
    if not file_contains(project_claude, [">30 tool calls"]):
        config_drift_reasons.append("CLAUDE.md missing long-session delegation check")
if project_legacy_spec_work and project_legacy_spec_work.exists() and not (project_skill_spec_work and project_skill_spec_work.exists()):
    config_drift_reasons.append("project still uses legacy command-style spec-work without skill counterpart")

if config_drift_reasons:
    config_drift = "confirmed"
elif project_version != "unknown" and project_version == repo_version:
    config_drift = "none"
else:
    config_drift = "possible"

def to_int(raw):
    try:
        return int(raw.replace(",", ""))
    except Exception:
        return 0


findings = []
if automation_dropoff:
    findings.append({
        "priority": "HIGH",
        "category": "E/Q",
        "title": "Automation drops off after kickoff",
        "evidence": f"{skill_calls} skill call for {len(user_messages)} user turns",
        "impact": "manual back-and-forth after the first plan",
        "fix": "trigger a mid-session re-plan after 8 turns without a new skill, or spawn a focused subagent after 3 correction turns",
    })

if len(correction_hits) >= 5 or max_same_theme_corrections >= 3:
    findings.append({
        "priority": "HIGH",
        "category": "Q",
        "title": "Strong rework signal inside one session",
        "evidence": f"{len(correction_hits)} correction-heavy user turns, max {max_same_theme_corrections} on one theme",
        "impact": "continued iteration without changing debugging strategy",
        "fix": "treat 3 same-theme corrections or 5 total correction turns as a hard stop for reproduction or instrumentation",
    })

if topic_shifts >= 4:
    findings.append({
        "priority": "MEDIUM",
        "category": "E",
        "title": "Too many topic shifts in one session",
        "evidence": f"{topic_shifts} topic shifts across {' > '.join(non_notification_labels[:8])}",
        "impact": "context drift lowers implementation precision",
        "fix": "split feature, bugfix, and tooling work into separate phases or sessions",
    })

if to_int(metrics["cache_read"]) >= 10000000 and to_int(metrics["messages"]) >= 300:
    findings.append({
        "priority": "LOW",
        "category": "T",
        "title": "Session size suggests a reset point is missing",
        "evidence": f"{metrics['cache_read']} cache-read tokens and {metrics['messages']} messages",
        "impact": "large cached sessions still accumulate drift and review overhead",
        "fix": "recommend a close-and-restart handoff once size and correction thresholds are crossed",
    })

if config_drift == "confirmed":
    findings.append({
        "priority": "MEDIUM",
        "category": "E/Q",
        "title": "Project setup shows config drift despite current ai-setup version",
        "evidence": "; ".join(config_drift_reasons[:3]),
        "impact": "local workflow guidance can lag behind released ai-setup behavior and skew findings",
        "fix": "refresh or reconcile local project guidance before treating this as a core routing failure",
    })

print(f"# Session Deep-Dive Report — {session_dt.date() if session_dt else 'unknown'}")
print("")
print("## Metrics")
print(f"Session: {metrics['session'] or 'unknown'}")
print(f"Project: {metrics['project'] or 'unknown'}")
print(f"Branch: {metrics['branch'] or 'unknown'}")
print(f"Duration: {metrics['duration'] or 'unknown'}")
print(f"Messages: {metrics['messages'] or '0'}")
print(f"Tokens: total {metrics['total_tokens'] or '0'} | output {metrics['output_tokens'] or '0'} | cache read {metrics['cache_read'] or '0'}")
print("")
print("## Deep-Dive Snapshot")
print(f"User turns: {sections.get('USER', 0)} | Thinking blocks: {sections.get('THINKING', 0)} | Assistant blocks: {sections.get('ASSISTANT', 0)}")
print(f"Skills: {skill_calls} | Agents: {agent_calls} | Correction turns: {len(correction_hits)}")
print(f"Topic shifts: {topic_shifts} | Automation drop-off: {'Yes' if automation_dropoff else 'No'}")
print(f"Topic path: {' > '.join(labels[:12]) if labels else 'unknown'}")
print("")
print("## Version Lens")
print(f"Project ai-setup: {project_version}")
print(f"Project updated_at: {project_updated_at or 'unknown'}")
print(f"Current repo version: {repo_version}")
print(f"Lens: {version_lens}")
print(f"Config drift: {config_drift}")
print("")
print("## Findings")
if findings:
    for finding in findings:
        print(f"### [{finding['priority']}] [{finding['category']}] {finding['title']}")
        print(f"Evidence: {finding['evidence']}")
        print(f"Impact: {finding['impact']}")
        print(f"Fix: {finding['fix']}")
        print("")
else:
    print("No strong local signals found.")
    print("")

if correction_hits:
    print("## Correction Samples")
    for sample, matched in correction_hits[:8]:
        print(f"- {', '.join(matched)}: {sample}")

if config_drift_reasons:
    print("")
    print("## Config Drift Signals")
    for reason in config_drift_reasons[:5]:
        print(f"- {reason}")
PYEOF
