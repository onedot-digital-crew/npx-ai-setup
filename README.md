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
Runs 4 steps after scaffolding:

| Step | What | Mode |
|------|------|------|
| **Memory Bank** | Claude reads your code, populates `projectbrief.md` + `systemPatterns.md` | Parallel |
| **CLAUDE.md** | Claude adds `## Commands` (from package.json) + `## Critical Rules` (from linting config) | Parallel |
| **Skills** | AI-curated skill installation with live progress (see below) | Sequential |
| **GSD Map** | `/gsd:map-codebase` — autonomous codebase analysis | Sequential |

Steps 1+2 run in parallel (Sonnet, max 3 turns each). Steps 3+4 run sequentially after.

### 3. AI-curated Skills installation

Skills are automatically detected, curated, and installed in 4 phases:

**Phase 1 — Detect & Search** (bash, 30s timeout per search)
Reads `package.json` dependencies, maps them to technology keywords, and searches for available skills.

Supported technologies: Vue, Nuxt, Nuxt UI, React, Next.js, Svelte, Astro, Tailwind, Shadcn, Radix, Headless UI, TypeScript, Express, NestJS, Hono, Shopify, Angular, Prisma, Drizzle, Supabase, Firebase, Vitest, Playwright, Pinia, TanStack, Zustand

**Phase 2 — Fetch Install Counts** (parallel curl, ~1s)
Fetches weekly install counts from [skills.sh](https://skills.sh) for all found skills in parallel. This data is used to rank skills by real-world popularity.

**Phase 3 — AI Curation** (Claude Sonnet, 1 turn, 60s timeout)
Claude receives the full list of found skills with their install counts and selects the top 5 most relevant ones. It prefers higher install counts, avoids duplicates, prefers well-known maintainers, and picks only what fits the actual tech stack.

**Phase 4 — Install** (bash, live output)
Selected skills are installed one by one with live status updates:

```
🔌 Searching and installing skills...
  Detected: vue nuxt tailwind typescript
  🔍 Searching: vue ... 6 skills found
  🔍 Searching: nuxt ... 5 skills found
  🔍 Searching: tailwind ... 4 skills found

  📊 Fetching install counts...
  🤖 Claude selecting best skills (17 found)...
  ✨ 5 skills selected:

     ✅ antfu/skills@vue
     ✅ antfu/skills@nuxt
     ✅ antfu/skills@tailwind-css
     ✅ antfu/skills@vue-router-best-practices
     ✅ antfu/skills@typescript-best-practices

  Total: 5 skills installed
```

**Fallback**: If Claude is unavailable or times out, top 3 per technology are installed without AI curation.

### 4. Hooks (active after setup)

| Hook | Trigger | What it does |
|------|---------|-------------|
| **protect-files.sh** | Before Edit/Write | Blocks changes to `.env`, `package-lock.json`, `.git/`, `projectbrief.md` |
| **post-edit-lint.sh** | After Edit/Write | Auto-runs `eslint --fix` on .js/.ts files |
| **circuit-breaker.sh** | Before Edit/Write | Warns at 5x edits, blocks at 8x edits to same file within 10 min |

### 5. Permissions

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
