# @onedot/ai-setup

AI infrastructure for projects: Claude Code, GSD, Memory Bank, Hooks.
One command creates the complete setup, then Claude analyzes the code and populates everything automatically.

## Installation

```bash
npx @onedot/ai-setup
```

## What gets created?

| File/Folder | Function |
|-------------|----------|
| `memory-bank/` | Lean Memory Bank (projectbrief + systemPatterns) |
| `CLAUDE.md` | AI rules + Critical Rules |
| `.claude/settings.json` | Granular permissions + Hooks |
| `.claude/hooks/` | Auto-Lint, File Protection, Circuit Breaker |
| `.claude/init-prompt.md` | Auto-Init prompt for Claude |
| `.github/copilot-instructions.md` | Copilot context |
| `AI-SETUP.md` | Detailed documentation |

## Requirements

- Node.js >= 18
- npm
- jq (`brew install jq`)
- Claude Code CLI (optional, for Auto-Init)

## Skills

Skills are automatically detected and installed during Auto-Init (based on `package.json`).

### Search and install manually

```bash
npx skills find <technology>
npx skills add <owner/repo@skill> --agent claude-code --agent github-copilot -y
```

### Create custom skills

Skills live in `.claude/skills/<name>/` with a `prompt.md`:

```bash
mkdir -p .claude/skills/my-skill
```

`.claude/skills/my-skill/prompt.md`:
```markdown
# My Skill

Description of what this skill does.

## Rules
- Rule 1
- Rule 2
```

Invoke in Claude Code: `/my-skill`

### Examples

```bash
# Find available skills for React
npx skills find react

# Install skill from GitHub
npx skills add ctsstc/get-shit-done-skills@gsd --agent claude-code -y

# List all installed skills
ls .claude/skills/
```

## Documentation

See [AI-SETUP.md](templates/AI-SETUP.md) for workflow, commands, and FAQ.
