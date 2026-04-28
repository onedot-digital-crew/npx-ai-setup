---
name: claude-changelog
description: "Fetches the latest Claude Code changelog, diffs it against the last checked version, and audits the current ai-setup for outdated patterns, missing features, and simplification opportunities."
effort: medium
model: sonnet
argument-hint: "[--since <version>]"
allowed-tools: Read, Glob, Grep, WebFetch, AskUserQuestion, Agent, Bash
---

Audit the Claude Code changelog against this ai-setup. Input: $ARGUMENTS

## Phase 1 — Fetch Changelog

Fetch the Claude Code changelog:

```
https://code.claude.com/docs/en/changelog
```

Use WebFetch. Extract all entries, grouped by release date/version. Focus on sections:

- New features / capabilities
- Settings / configuration changes
- Hook system changes
- MCP updates
- Slash commands / skills system
- Model routing / agent changes
- Permission / sandbox changes

Store the raw changelog entries for Phase 2.

## Phase 2 — Load Last-Checked State

Check if a state file exists:

```bash
cat "${CLAUDE_PROJECT_DIR:-.}/.claude/changelog-audit.json" 2>/dev/null || echo "{}"
```

The state file tracks:

```json
{
  "last_checked": "YYYY-MM-DD",
  "last_changelog_entry": "entry title or date of last processed entry",
  "processed_entries": ["entry-id-1", "entry-id-2"]
}
```

If state file exists: only process entries newer than `last_changelog_entry`.
If no state file: process ALL entries (full audit).

## Phase 3 — Load Current Setup

Read current setup in parallel:

- `.claude/settings.json` — permissions, hooks, env
- `CLAUDE.md` — project instructions
- `.claude/rules/*.md` — all rule files
- `templates/CLAUDE.md` — template for new projects
- `templates/claude/rules/*.md` if exists
- `.ai-setup.json` — installed version

Build inventory:

```
SETUP: [N] rules, [N] hooks, [N] skills, settings snapshot
```

## Phase 4 — Gap Analysis

For each NEW changelog entry, categorize:

| Category               | Question                                                           |
| ---------------------- | ------------------------------------------------------------------ |
| **Native feature**     | Does Claude Code now natively do something we scripted/hooked?     |
| **New setting/option** | Should we add it to settings.json or CLAUDE.md?                    |
| **Changed behavior**   | Does our config fight the new default?                             |
| **New skill/command**  | Should we add it to our skill library?                             |
| **Deprecated pattern** | Are we using something that's now obsolete?                        |
| **Model routing**      | New models or routing options that change our model-routing rules? |

For each finding, produce:

```
[ENTRY DATE] Feature: <name>
Status: NEW / CHANGED / DEPRECATED
Setup Impact: <file and line where this touches us>
Recommendation: SIMPLIFY / ADD / UPDATE / REMOVE / MONITOR
Effort: low / medium / high
```

## Phase 5 — Simplification Scan

Look specifically for:

1. **Workarounds we can delete**: Scripts/hooks that replicate native Claude Code behavior
2. **Config we can simplify**: Settings Claude Code now handles natively
3. **Rules that are now default**: Instructions in CLAUDE.md that match Claude Code's new defaults
4. **Over-specified model routing**: If Claude Code added smarter defaults, our explicit overrides may conflict

Quote the specific line in our setup + the changelog entry that makes it redundant.

## Phase 6 — Report

Write findings to `specs/changelog-audit-YYYY-MM-DD.md`:

```markdown
# Claude Code Changelog Audit — YYYY-MM-DD

## Neue Entries seit [last checked / "full audit"]

## Simplification Opportunities (can remove/reduce)
[list with file:line + changelog reference]

## Updates erforderlich (config/rules anpassen)
[list with specific changes needed]

## Neue Features zum Adoptieren
[list with recommendation + effort]

## Keine Action nötig
[entries reviewed, no impact]

## Setup-Gesundheit
Processed: [N] entries | Findings: [N] | Action items: [N]
```

## Phase 7 — Interactive Triage

`AskUserQuestion` multiSelect — show top action items, ask which to tackle now.

For each selected item: either apply the change directly (if low-effort/clear) or create a spec (`/spec`) for larger changes.

## Phase 8 — Update State File

After processing, write updated state:

```bash
cat > "${CLAUDE_PROJECT_DIR:-.}/.claude/changelog-audit.json" << EOF
{
  "last_checked": "YYYY-MM-DD",
  "last_changelog_entry": "<title or date of newest processed entry>",
  "processed_entries": ["...all processed entry IDs..."]
}
EOF
```

## Rules

- Quote exact changelog text — no paraphrasing
- Quote exact lines from our setup when flagging redundancy
- If a finding is speculative ("might be"), mark as MONITOR not SIMPLIFY
- Never remove something without confirming the native feature is a full replacement
- Prefer simplification over addition — less config = less maintenance
