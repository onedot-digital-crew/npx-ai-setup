# @onedot/ai-setup

AI infrastructure for projects: Claude Code, GSD, Memory Bank, Hooks.
One command creates the complete setup, then Claude analyzes the code and populates everything automatically.

## Installation

```bash
npx @onedot/ai-setup
```

## What it does

### 1. Project scaffolding (instant)
- Creates `memory-bank/` with project brief and system patterns templates
- Copies `CLAUDE.md` with communication protocol and GSD workflow
- Sets up `.claude/settings.json` with granular bash permissions (no `Bash(*)`)
- Installs hooks: auto-lint on edit, file protection (.env, projectbrief.md), circuit breaker (detects edit loops)
- Adds `.github/copilot-instructions.md` for GitHub Copilot context
- Installs GSD (Get Shit Done) workflow engine locally
- Cleans up legacy AI structures (.ai/, .skillkit/, old skills)

### 2. Auto-Init (optional, requires Claude CLI)
Runs 4 steps with progress bars after scaffolding:

| Step | What | Mode |
|------|------|------|
| **Memory Bank** | Claude reads your code, populates `projectbrief.md` + `systemPatterns.md` | Parallel |
| **CLAUDE.md** | Claude adds `## Commands` (from package.json) + `## Critical Rules` (from linting config) | Parallel |
| **GSD Map** | `/gsd:map-codebase` — autonomous codebase analysis | Sequential |
| **Skills** | Detects tech stack from package.json, searches and installs matching skills | Sequential |

Steps 1+2 run in parallel (Sonnet, max 3 turns each). Steps 3+4 run sequentially after.

### 3. Hooks (active after setup)

| Hook | Trigger | What it does |
|------|---------|-------------|
| **protect-files.sh** | Before Edit/Write | Blocks changes to `.env`, `package-lock.json`, `.git/`, `projectbrief.md` |
| **post-edit-lint.sh** | After Edit/Write | Auto-runs `eslint --fix` on .js/.ts files |
| **circuit-breaker.sh** | Before Edit/Write | Warns at 5x edits, blocks at 8x edits to same file within 10 min |

### 4. Permissions

Granular bash permissions instead of `Bash(*)`:
- **Allowed**: `git add/commit/status/log/diff/tag`, `npm run`, `eslint`, `cat/ls/grep/...`
- **Denied**: `git push`, `rm -rf`, reading `.env`

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
