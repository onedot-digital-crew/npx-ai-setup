# AGENTS.md - @onedot/ai-setup

## Project Overview

This is **@onedot/ai-setup**, an npx-installable AI infrastructure setup tool for software projects. It scaffolds Claude Code configuration, hooks, project context documentation, and AI-curated skills.

**Purpose**: One command creates the complete AI development setup:
```bash
npx github:onedot-digital-crew/npx-ai-setup
```

**What it creates in target projects:**
- `CLAUDE.md` - AI communication protocol and project rules
- `.claude/settings.json` - Granular bash permissions (no `Bash(*)`)
- `.claude/hooks/` - Safety hooks (protect files, auto-lint, circuit breaker)
- `.claude/commands/` - Slash commands for spec-driven development
- `.agents/context/` - Auto-generated project documentation
- `specs/` - Spec-driven development workflow
- `.github/copilot-instructions.md` - GitHub Copilot context

## Technology Stack

- **Language**: Bash (shell scripting)
- **Runtime**: Node.js >= 18, npm
- **Dependencies**: jq (JSON parsing), curl (HTTP requests)
- **Target AI Tools**: Claude Code CLI, GitHub Copilot

## Project Structure

```
project-root/
├── bin/
│   └── ai-setup.sh              # Main installation script (~1660 lines)
├── templates/
│   ├── CLAUDE.md                # Template for project rules
│   ├── claude/
│   │   ├── settings.json        # Claude Code permissions config
│   │   └── hooks/               # Hook scripts
│   │       ├── protect-files.sh       # Prevents edits to .env, package-lock.json
│   │       ├── post-edit-lint.sh      # Auto-runs eslint --fix
│   │       ├── circuit-breaker.sh     # Detects edit loops (warns at 5x, blocks at 8x)
│   │       └── README.md              # Hook documentation
│   ├── commands/
│   │   ├── spec.md              # /spec slash command (Opus, plan mode)
│   │   ├── spec-work.md         # /spec-work slash command (Sonnet, execute mode)
│   │   ├── spec-work-all.md     # /spec-work-all parallel execution via Git worktrees
│   │   ├── spec-review.md       # /spec-review review + PR draft (Opus, plan mode)
│   │   └── spec-board.md        # /spec-board Kanban overview (Sonnet, plan mode)
│   ├── github/
│   │   └── copilot-instructions.md    # Copilot context template
│   ├── specs/
│   │   ├── TEMPLATE.md          # Spec template
│   │   └── README.md            # Spec workflow documentation
│   └── mcp.json                 # Context7 MCP server config
├── package.json                 # NPM package config
└── README.md                    # User documentation
```

## Key Components

### 1. Installation Script (bin/ai-setup.sh)

The main bash script handles:
- **Requirements check**: Node.js >= 18, npm, jq
- **Update detection**: Reads `.ai-setup.json` to detect updates/reinstalls
- **Template installation**: Copies files from `templates/` to target project
- **Auto-Init**: Optional Claude-powered project analysis and context generation
- **Skill curation**: Searches, ranks, and installs relevant skills from skills.sh
- **Plugin installation**: Claude-Mem, official plugins, Context7 MCP

**Command-line flags:**
- `--system <name>` - Target system (auto, shopify, nuxt, laravel, shopware, storyblok)
- `--with-gsd` / `--no-gsd` - GSD workflow engine
- `--with-claude-mem` / `--no-claude-mem` - Persistent memory
- `--with-plugins` / `--no-plugins` - Official Claude plugins
- `--with-context7` / `--no-context7` - Context7 MCP server
- `--regenerate` - Regenerate CLAUDE.md and context files

### 2. Hooks (templates/claude/hooks/)

**protect-files.sh**: Blocks edits to protected files (`.env`, `package-lock.json`, `.git/`)

**post-edit-lint.sh**: Auto-fixes linting on `.js`/`.ts` files after edit

**circuit-breaker.sh**: Prevents infinite edit loops
- Tracks edits per file in `/tmp/claude-cb-<hash>.log`
- Warns at 5 edits within 10 minutes
- Blocks at 8 edits within 10 minutes

### 3. Spec-Driven Development

Five slash commands enable a Kanban-style spec workflow:

**`/spec "task description"`** (templates/commands/spec.md):
- Uses Claude Opus in plan mode
- Challenges the idea (GO/SIMPLIFY/REJECT), then creates `specs/NNN-description.md`
- 60-line max spec size enforced

**`/spec-work NNN`** (templates/commands/spec-work.md):
- Uses Claude Sonnet in execute mode
- Follows spec step-by-step, transitions status: `draft` → `in-progress` → `in-review`
- Supports `--complete` flag for legacy behavior (skip review, move directly to completed)

**`/spec-work-all`** (templates/commands/spec-work-all.md):
- Uses Claude Sonnet with Task subagents
- Creates isolated Git worktrees per spec (`spec/NNN-title` branch)
- Parallel execution in waves with dependency detection
- Each subagent works in its own worktree — no merge conflicts

**`/spec-review NNN`** (templates/commands/spec-review.md):
- Uses Claude Opus in plan mode
- Reviews code changes against spec acceptance criteria
- Verdict: APPROVED (→ completed + PR draft) / CHANGES REQUESTED (→ back to in-progress) / REJECTED (→ blocked)

**`/spec-board`** (templates/commands/spec-board.md):
- Uses Claude Sonnet in plan mode
- Kanban-style overview: Backlog | In Progress | Review | Blocked | Done
- Shows step-level progress (`[3/8]`) and branch info per spec

**Status lifecycle:** `draft` → `in-progress` → `in-review` → `completed` (or `blocked` at any stage)

### 4. Auto-Init Process

When `--regenerate` or during initial setup with Claude CLI:

1. **CLAUDE.md extension** (Sonnet 4.6, max 3 turns):
   - Populates `## Commands` from package.json scripts
   - Populates `## Critical Rules` from eslint/prettier config

2. **Project Context Generation** (Sonnet 4.6, max 4 turns):
   - Creates `.agents/context/STACK.md` - Technology stack
   - Creates `.agents/context/ARCHITECTURE.md` - System architecture
   - Creates `.agents/context/CONVENTIONS.md` - Coding standards

3. **AI-Curated Skills** (Haiku, 1 turn):
   - Reads package.json dependencies
   - Maps to technology keywords (vue, nuxt, react, next, etc.)
   - Searches skills.sh for available skills
   - Fetches weekly install counts
   - Claude Haiku selects top 5 most relevant
   - Installs via `npx skills add`

### 5. Skill Installation Flow

```
package.json deps → keywords → skills.sh search → install counts → 
Haiku curation → install top 5 → system-specific defaults
```

**Supported technologies mapping:**
- Vue, Nuxt, Nuxt UI
- React, Next.js
- Svelte, Astro
- Tailwind, Shadcn, Radix, Headless UI
- TypeScript
- Express, NestJS, Hono
- Shopify, Angular
- Prisma, Drizzle
- Supabase, Firebase
- Vitest, Playwright
- Pinia, TanStack, Zustand

**System-specific default skills:**
- **Shopify**: `sickn33/antigravity-awesome-skills@shopify-development`
- **Nuxt**: `antfu/skills@nuxt`, `onmax/nuxt-skills@nuxt`
- **Laravel**: `jeffallan/claude-skills@laravel-specialist`
- **Shopware**: `bartundmett/skills@shopware6-best-practices`
- **Storyblok**: `bartundmett/skills@storyblok-best-practices`

## Code Style Guidelines

### Bash Scripting

- Use `set -e` for error handling (disabled selectively in functions)
- Quote all variable expansions: `"$VAR"` not `$VAR`
- Use `[[` for bash conditionals, `[` for POSIX compatibility
- Functions use `snake_case`
- Local variables declared with `local`
- Error output to `stderr` with `>&2`

### JSON Handling

- Use `jq` for all JSON manipulation
- Always validate JSON before processing: `jq -e . file.json`
- Use `--arg` and `--argjson` for safe value injection

### File Paths

- Templates referenced via `$SCRIPT_DIR/templates/`
- Target paths relative to current working directory
- Check file existence before operations: `[ -f "$file" ]`

## Testing & Debugging

### Manual Hook Testing

```bash
echo '{"tool_input":{"file_path":"test.js"}}' | ./.claude/hooks/protect-files.sh
echo $?  # 0 = allowed, 2 = blocked
```

### Circuit Breaker Debugging

```bash
# View log
cat /tmp/claude-cb-*.log

# Clear log
rm /tmp/claude-cb-*.log
```

### Testing Setup Script

```bash
# Fresh install test
rm -rf .claude/ .agents/ specs/ CLAUDE.md .ai-setup.json
./bin/ai-setup.sh

# Regenerate test
./bin/ai-setup.sh --regenerate --system nuxt
```

## Update System

The script tracks installed state in `.ai-setup.json`:

```json
{
  "version": "1.0.0",
  "installed_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z",
  "files": {
    "CLAUDE.md": "checksum size",
    ".claude/settings.json": "checksum size"
  }
}
```

**Update behavior:**
- Compares template checksum to installed file
- Unmodified files: Silent update
- User-modified files: Backup to `.ai-setup-backup/`, then update
- New files: Auto-install

## Security Considerations

### Protected Files

The following are protected by hooks:
- `.env` - Secrets and credentials
- `package-lock.json` - Dependency integrity
- `.git/` - Repository history

### Permission Model

`.claude/settings.json` uses granular permissions instead of `Bash(*)`:

**Allowed:**
- `Read(src/**)`, `Read(.planning/**)`
- `Bash(git add:*)`, `Bash(git commit:*)`, `Bash(git status:*)`
- `Bash(npm run *)`, `Bash(npx eslint *)`
- Basic file operations: `cat`, `ls`, `grep`, `mkdir`

**Denied:**
- `Read(.env*)`
- `Bash(git push *)`
- `Bash(rm -rf *)`

### Network Safety

- All curl commands use `--max-time` timeouts
- Skill searches use 30s timeout
- WebFetch permissions limited to specific domains

## Build & Release

This package is distributed via npm/github:

```bash
# Install from GitHub
npx github:onedot-digital-crew/npx-ai-setup

# Version is read from package.json
jq -r '.version' package.json
```

**Files included in package** (from package.json):
- `bin/`
- `templates/`
- `README.md`

## Development Conventions

### Adding New Templates

1. Add file to `templates/` directory
2. Add mapping to `TEMPLATE_MAP` array in `bin/ai-setup.sh`
3. Add template copy logic in setup section
4. Update `write_metadata()` to track the new file

### Adding New System Support

1. Add system name to `VALID_SYSTEMS` array
2. Add to `select_system()` options and descriptions
3. Add system-specific skills to `SYSTEM_SKILLS` case statement
4. Document in README.md

### Adding New Technology Detection

1. Add case pattern in skill detection loop (around line 583)
2. Add keyword to KEYWORDS array if not exists
3. Test with sample package.json

## Common Tasks

### Regenerate Context Files

```bash
npx @onedot/ai-setup --regenerate --system <name>
```

### Test Skill Search

```bash
npx skills find nuxt
```

### Install Skill Manually

```bash
npx skills add owner/repo@skill-name --agent claude-code -y
```

## Troubleshooting

### "No AI CLI detected"

Install Claude Code:
```bash
npm i -g @anthropics-ai/claude-code
```

### Skills not installing

- Check network connectivity to skills.sh
- Verify `npx skills` works independently
- Check timeout settings (some systems need `gtimeout` vs `timeout`)

### Circuit breaker triggering too soon

Edit `.claude/hooks/circuit-breaker.sh`:
```bash
WARN=10    # Increase warning threshold
BLOCK=15   # Increase block threshold
```

### Update check failing

Verify `.ai-setup.json` is valid JSON:
```bash
jq . .ai-setup.json
```
