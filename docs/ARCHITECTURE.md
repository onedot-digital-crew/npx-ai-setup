# Architecture: @onedot/ai-setup

## Overview

The system is a single Bash script (`bin/ai-setup.sh`) that runs in the target project's directory. It reads arguments, detects the environment, copies templates, and optionally triggers AI generation. There is no build step and no runtime process.

## Setup Flow

```
npx @onedot/ai-setup [--system nuxt] [--with-gsd] ...
          |
          v
    Version check
    (ai-setup.json present?)
          |
    +-----+-----+
    |           |
  Fresh      Update
  Install     Path
    |           |
    +-----+-----+
          |
          v
    Interactive Setup
    (or use --flags)
          |
          v
    Phase 1: Scaffolding  (instant, no AI)
    Phase 2: Auto-Init    (optional, AI-powered)
```

## Phase 1: Scaffolding

Runs entirely in Bash with no AI calls. Copies template files from the npm package into the target project:

| What | Where | Purpose |
|------|-------|---------|
| `CLAUDE.md` (base) | project root | AI rules and project references |
| `.claude/settings.json` | project `.claude/` | Permissions + hooks config |
| `.claude/hooks/*.sh` | project `.claude/hooks/` | Safety hooks |
| `.claude/commands/*.md` | project `.claude/commands/` | Slash commands |
| `.claude/agents/*.md` | project `.claude/agents/` | Subagent templates |
| `specs/TEMPLATE.md` + `README.md` | project `specs/` | Spec-driven workflow |
| `.github/copilot-instructions.md` | project `.github/` | Copilot context |
| `.mcp.json` | project root | MCP server config (if requested) |

Templates are copied verbatim. The script tracks installed files in `.ai-setup.json` for future update tracking.

## Phase 2: Auto-Init

Runs 3 Claude CLI invocations in parallel (Steps 1+2) then sequentially (Step 3):

```
Step 1 (parallel): CLAUDE.md generation
  claude --model sonnet --max-turns 3
  Input: package.json, README, prettierrc, .eslintrc
  Output: ## Commands + ## Critical Rules sections appended to CLAUDE.md

Step 2 (parallel): Context generation
  claude --model sonnet --max-turns 4
  Input: full codebase scan
  Output: .agents/context/STACK.md + ARCHITECTURE.md + CONVENTIONS.md

Step 3 (sequential, after 1+2): Skills curation
  Phase A: Bash — detect tech keywords from package.json
  Phase B: Bash — search skills.sh for each keyword (parallel curl)
  Phase C: Bash — fetch install counts (parallel curl)
  Phase D: claude --model haiku --max-turns 1 — select top 5
  Phase E: Bash — install selected skills
```

If Claude CLI is unavailable, Auto-Init is skipped and the user gets manual instructions.

## Template System

Templates live in `templates/` in this repository. They are included in the npm package via `files` in `package.json`. The script locates them via `SCRIPT_DIR`:

```bash
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/templates"
```

When run via `npx`, `SCRIPT_DIR` resolves to the npm cache location for this package. Templates are never modified by the script — they are always fresh copies from the package version.

## Hook System

Hooks are shell scripts registered in `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [{ "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": ".claude/hooks/protect-files.sh" }] }],
    "PostToolUse": [{ "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": ".claude/hooks/post-edit-lint.sh" }] }],
    "UserPromptSubmit": [{ "hooks": [{ "type": "command", "command": ".claude/hooks/context-freshness.sh" }] }]
  }
}
```

| Hook | Trigger | Function |
|------|---------|----------|
| `protect-files.sh` | PreToolUse (Edit/Write) | Block edits to `.env`, `package-lock.json`, `.git/` |
| `post-edit-lint.sh` | PostToolUse (Edit/Write) | Run `eslint --fix` or `prettier` on edited file |
| `circuit-breaker.sh` | PreToolUse (Edit/Write) | Warn at 5x edits, block at 8x edits to same file in 10 min |
| `context-freshness.sh` | UserPromptSubmit | Warn if `.agents/context/` files are stale relative to config files |

## Update System

On re-run, the script detects the current version from `.ai-setup.json`:
- **Same version**: skips install, offers optional regenerate
- **New version**: offers Update (diff-based), Clean reinstall, or Skip

The diff-based update compares each template file's `cksum` against the installed file. Unmodified files are silently overwritten. User-modified files are backed up to `.ai-setup-backup/` before updating.

## Skill Curation Pipeline

```
package.json deps
      |
      v
keyword mapping (hardcoded map: "vue" -> "vue", "nuxt" -> "nuxt,vue", ...)
      |
      v
skills.sh search (parallel, one curl per keyword, 30s timeout)
      |
      v
install count fetch (parallel curl to skills.sh API)
      |
      v
Claude Haiku: "select top 5 from this list given the stack"
      |
      v
claude skill install <owner/repo@skill>
```

System-specific defaults bypass the curation step and are always installed for known systems (Shopify, Nuxt, Laravel, Shopware, Storyblok).
