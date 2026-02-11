# @onedot/ai-setup

AI infrastructure for projects: Claude Code, GSD, Memory Bank, Hooks.
One command creates the complete setup, then Claude analyzes the code and populates everything automatically.

## Installation

```bash
npx @onedot/ai-setup
```

## Requirements

- **Node.js** >= 18
- **npm** (for `npx`)
- **jq** (for hooks, JSON parsing) - `brew install jq`
- **Claude Code CLI** (`claude`) - for Auto-Init (optional, Copilot as fallback)
- **GSD** - auto-installed globally by ai-setup if not present (`~/.claude/commands/gsd/`)

## Architecture

```
GSD (.planning/)          = Process (plan > execute > verify)
Memory Bank (memory-bank/) = Knowledge (Patterns, Tech Stack)
CLAUDE.md                  = Rules (Critical Rules, Workflow)
```

---

## What it does

### 1. Project scaffolding (instant)

- Creates `memory-bank/` with project brief and system patterns templates
- Copies `CLAUDE.md` with communication protocol and GSD workflow
- Sets up `.claude/settings.json` with granular bash permissions (no `Bash(*)`)
- Installs hooks: auto-lint on edit, file protection (.env, projectbrief.md), circuit breaker (detects edit loops)
- Adds `.github/copilot-instructions.md` for GitHub Copilot context
- Installs GSD (Get Shit Done) workflow engine globally
- Cleans up legacy AI structures (.ai/, .skillkit/, old skills)

### 2. Auto-Init (optional, requires Claude CLI)

Runs 3 steps after scaffolding:

| Step | What | Mode |
|------|------|------|
| **Memory Bank** | Claude reads your code, populates `projectbrief.md` + `systemPatterns.md` | Parallel |
| **CLAUDE.md** | Claude adds `## Commands` (from package.json) + `## Critical Rules` (from linting config) | Parallel |
| **Skills** | AI-curated skill installation with live progress (see below) | Sequential |

Steps 1+2 run in parallel (Sonnet, max 3 turns each). Step 3 runs sequentially after.

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

For maximum autonomy: `claude --dangerously-skip-permissions`

---

## GSD Workflow & Usage

The **Get-Shit-Done (GSD)** framework prevents "Context Rot" through strict phase management and file-based state (`STATE.md`, `PROJECT.md`).

### Core Workflow (Features & Architecture)

Use this loop for **new features, refactorings, or complex logic**. The system splits work into discrete phases to guarantee precision.

1. **Start:**
   `/gsd:new-project` — Initializes project, tech stack, and roadmap.

2. **Discussion (Important!):**
   `/gsd:discuss-phase [ID]` — Clarifies gray zones (e.g. API design, edge cases) *before* any code is written.

3. **Planning:**
   `/gsd:plan-phase [ID]` — Creates a detailed step-by-step plan and checks dependencies.

4. **Execution:**
   `/gsd:execute-phase [ID]` — Writes code, creates tests, and commits atomically per task.

5. **Verification:**
   `/gsd:verify-work [ID]` — Validates the result. On failures, an automatic fix plan is created.

### Quick Mode (Hotfixes & Tweaks)

Use this mode **only** for isolated, small tasks without architectural impact.

- **Command:** `/gsd:quick "Your instruction here"`
- **Use cases:** CSS fixes, typos, simple config changes, adding logging.
- **Note:** Skips deep planning and discussion. Do not use for complex logic!

### Decision Matrix: Phase vs. Quick

| Scenario | Method | Why? |
|----------|--------|------|
| New feature / new page | **Phase Loop** | Needs planning, state management, multiple files. |
| Refactoring / DB change | **Phase Loop** | High risk, needs tests and proper planning. |
| UI tweak (color/padding) | **Quick Mode** | Isolated, no logic risk. |
| Bugfix (logic error) | **Phase Loop** | Should be verified and tested. |
| Bugfix (syntax/typo) | **Quick Mode** | Risk-free and fast. |

### Golden Rules

1. **Trust the Files:** Do not manually edit `STATE.md` or `PROJECT.md`. They are the AI's memory.
2. **Commit Often:** GSD makes atomic commits. If a phase fails, roll back via `git`.
3. **No Context Rot:** After a completed phase (`verify` success), the chat context can be cleared since state lives in files.

### Daily Workflow

| Step | Command | Description |
|------|---------|-------------|
| Plan | `/gsd:plan-phase N` | Research + create plan |
| Build | `/gsd:execute-phase N` | Write code, hooks run automatically |
| Verify | `/gsd:verify-work N` | User acceptance testing |
| Pause | `/gsd:pause-work` | Create handoff document |
| Resume | `/gsd:resume-work` | Restore context |
| Status | `/gsd:progress` | Where am I? Next action? |

### GSD Command Reference

**Core Workflow**

| Command | Description |
|---------|-------------|
| `/gsd:plan-phase N` | Plan phase (research + create plan) |
| `/gsd:execute-phase N` | Execute phase (write code) |
| `/gsd:verify-work N` | User acceptance testing |
| `/gsd:pause-work` | Pause session (create handoff) |
| `/gsd:resume-work` | Resume session (restore context) |
| `/gsd:progress` | Show status, suggest next action |
| `/gsd:quick` | Quick task with GSD guarantees (atomic commits) |
| `/gsd:debug` | Systematic debugging with persistent state |

**Project & Roadmap**

| Command | Description |
|---------|-------------|
| `/gsd:new-project` | Initialize new project (interactive) |
| `/gsd:map-codebase` | Analyze codebase (autonomous) |
| `/gsd:add-phase` | Add phase at the end of roadmap |
| `/gsd:insert-phase` | Insert urgent phase (e.g. 3.1) |
| `/gsd:remove-phase` | Remove phase and renumber |
| `/gsd:discuss-phase` | Gather context before planning |
| `/gsd:add-todo` | Capture todo from conversation |
| `/gsd:check-todos` | Show open todos |

**Milestones & System**

| Command | Description |
|---------|-------------|
| `/gsd:new-milestone` | Start new milestone |
| `/gsd:complete-milestone` | Complete and archive milestone |
| `/gsd:audit-milestone` | Audit milestone before completion |
| `/gsd:help` | Show all commands |
| `/gsd:settings` | Configure GSD |
| `/gsd:update` | Update GSD to latest version |

---

## File Structure

```
project/
+-- memory-bank/
|   +-- projectbrief.md      # North Star (write-protected)
|   +-- systemPatterns.md     # Coding Patterns
+-- .planning/                # GSD State (created by /gsd:new-project)
|   +-- PROJECT.md
|   +-- ROADMAP.md
|   +-- STATE.md
+-- .claude/
|   +-- settings.json         # Permissions + Hooks
|   +-- init-prompt.md        # Init-Prompt Template
|   +-- hooks/
|       +-- protect-files.sh  # Protects .env, projectbrief.md
|       +-- post-edit-lint.sh # Auto-Lint after Edit
|       +-- circuit-breaker.sh # Detects edit loops
+-- .github/
|   +-- copilot-instructions.md
+-- CLAUDE.md                 # AI Rules + Critical Rules

~/.claude/                    # GSD Global (shared across all projects)
+-- commands/gsd/             # 29 slash commands
+-- agents/                   # GSD sub-agents
+-- skills/gsd/               # GSD Companion Skill
+-- get-shit-done/            # Workflows + references
```

---

## Security

| Protected | Why |
|-----------|-----|
| `.env` | Secrets |
| `package-lock.json` | Dependency Integrity |
| `.git/` | Repository History |
| `memory-bank/projectbrief.md` | North Star, change manually only |

`systemPatterns.md` is **not** protected — Claude should be able to update patterns.

---

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

---

## FAQ

**Memory Bank vs. GSD — what's the difference?**
GSD = Process (what do we do next?). Memory Bank = Knowledge (how do we code here?).

**Do I need to maintain memory-bank/ manually?**
No. The init prompt populates it. `systemPatterns.md` is updated by Claude as needed.

**What happens with `.planning/` on `git pull`?**
`.planning/` is committed. On merge conflicts: GSD state is per-developer, keep your own version when in doubt.

**Why is GSD installed globally?**
GSD is a workflow engine used across all projects. Global installation means commands like `/gsd:plan-phase` are available everywhere. Only `.planning/` (project state) lives in the repo.

**I already have GSD installed globally. What happens?**
The script detects existing installations and skips GSD. Your global config is untouched.

**Claude CLI vs. Copilot CLI?**
The script automatically detects which AI CLI is installed. Claude gets Auto-Init, Copilot gets manual instructions.

---

## GSD Cheat Sheet

```
Core Loop:
  /gsd:discuss-phase N      Clarify requirements before planning
  /gsd:plan-phase N         Create step-by-step plan
  /gsd:execute-phase N      Write code & commit atomically
  /gsd:verify-work N        User acceptance testing

Quick Tasks:
  /gsd:quick "task"          Fast fix (typos, CSS, config)
  /gsd:debug                Systematic debugging

Session Management:
  /gsd:pause-work           Save context for later
  /gsd:resume-work          Restore previous session
  /gsd:progress             Status & next action

Roadmap:
  /gsd:add-phase            Add phase to roadmap
  /gsd:insert-phase         Insert urgent work (e.g. 3.1)
  /gsd:add-todo             Capture idea as todo
  /gsd:check-todos          Show open todos
```

---

## Links

- [Skills — Browse & Install](https://skills.sh/)
- [GSD (Get Shit Done)](https://github.com/get-shit-done-cc/get-shit-done-cc)
- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Code Hooks](https://docs.anthropic.com/en/docs/claude-code/hooks)
- [CLAUDE.md Best Practices](https://docs.anthropic.com/en/docs/claude-code/memory)
