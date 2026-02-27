# @onedot/ai-setup

Production-ready AI infrastructure for Claude Code. One command installs hooks, slash commands, subagents, project context, and AI-curated skills — then Claude analyzes the codebase and populates everything automatically.

```bash
npx github:onedot-digital-crew/npx-ai-setup
```

Supports Shopify, Nuxt, Next.js, Laravel, Shopware, Storyblok, or auto-detection.

---

## What it installs

| Layer | What |
|-------|------|
| **CLAUDE.md** | Communication protocol, task routing (simple/medium/complex), verification gate |
| **Settings** | Granular bash permissions — no `Bash(*)`, no accidental `git push` or `rm -rf` |
| **Hooks** | protect-files, auto-lint, circuit-breaker, context-freshness, update-check, notifications |
| **Commands** | 16 slash commands for spec-driven development, reviews, releases, debugging |
| **Agents** | 8 subagent templates for parallel verification, review, and architectural assessment |
| **Context** | `.agents/context/` — STACK.md, ARCHITECTURE.md, CONVENTIONS.md (auto-generated) |
| **Skills** | AI-curated Claude Code skills matched to your stack via skills.sh |

---

## Slash Commands

| Command | Model | Description |
|---------|-------|-------------|
| `/spec "task"` | Opus | Challenge idea first, then create structured spec |
| `/spec-work 001` | Sonnet | Execute a spec step by step |
| `/spec-work-all` | Sonnet | Execute all draft specs in parallel via Git worktrees |
| `/spec-review 001` | Opus | Review spec changes against acceptance criteria |
| `/spec-board` | Sonnet | Kanban-style overview of all specs |
| `/bug "description"` | Sonnet | Reproduce → root cause → fix → verify → code review |
| `/commit` | Sonnet | Stage changes + create descriptive commit |
| `/pr` | Sonnet | Draft PR title/body, run build validation |
| `/review` | Opus | Review uncommitted changes — bugs, security, performance |
| `/test` | Sonnet | Run tests + fix failures (up to 3 attempts) |
| `/techdebt` | Sonnet | End-of-session sweep — dead code, unused imports |
| `/release` | Sonnet | Bump version, update CHANGELOG, commit + git tag |
| `/grill` | Opus | Adversarial code review — blocks until all issues resolved |
| `/analyze` | Sonnet | 3 parallel agents — architecture, hotspots, risks |
| `/reflect` | Sonnet | Detect session corrections → write as permanent CLAUDE.md rules |
| `/context-full` | Sonnet | Full codebase snapshot via repomix |

## Subagents

| Agent | Purpose |
|-------|---------|
| `verify-app` | Run tests + build, report PASS/FAIL |
| `build-validator` | Quick build check (Haiku) |
| `code-reviewer` | HIGH/MEDIUM confidence review — PASS/CONCERNS/FAIL |
| `code-architect` | Architectural assessment before implementation |
| `staff-reviewer` | Skeptical staff engineer review |
| `perf-reviewer` | Performance analysis — FAST/CONCERNS/SLOW |
| `test-generator` | Generate missing tests for changed files |
| `context-refresher` | Regenerate `.agents/context/` on `[CONTEXT STALE]` |

---

## Installation flags

```bash
npx github:onedot-digital-crew/npx-ai-setup [flags]

--system nuxt,storyblok   # Set framework (auto, shopify, nuxt, next, laravel, shopware, storyblok)
--with-gsd                # Install GSD workflow engine
--with-claude-mem         # Install Claude-Mem persistent memory plugin
--with-plugins            # Install official Claude Code plugins (code-review, feature-dev, ralph-wiggum)
--with-context7           # Add Context7 MCP server (.mcp.json)
--with-playwright         # Add Playwright MCP server (.mcp.json)
--regenerate              # Re-run Auto-Init without reinstalling files
```

---

## Update

Run the same command again — the script auto-detects and offers:

- **Update files** — compare each template, ask before overwriting user-modified files
- **Regenerate** — re-run Claude analysis (CLAUDE.md, context, commands, skills)
- **Clean reinstall** — remove all managed files, fresh install

---

## Requirements

- Node.js >= 18 + npm
- `jq` — `brew install jq`
- Claude Code CLI (`claude`) — for Auto-Init (optional, Copilot as fallback)

---

## Plugins & Extensions

| Plugin | Flag | What it does |
|--------|------|-------------|
| **claude-mem** | `--with-claude-mem` | Persistent memory across sessions, MCP search tools |
| **code-review** | `--with-plugins` | 4 parallel review agents — `/code-review` |
| **feature-dev** | `--with-plugins` | 7-phase feature workflow — `/feature-dev` |
| **ralph-wiggum** | `--with-plugins` | Iterative loop until task is done — `/ralph-loop` |
| **Context7** | `--with-context7` | Up-to-date library docs in context — "use context7" |
| **Playwright MCP** | `--with-playwright` | Browser automation for UI verification |
| **GSD** | `--with-gsd` | Phase planning, codebase mapping, session management |

Team sharing: marketplace plugins via `extraKnownMarketplaces` in `.claude/settings.json`, MCP servers via `.mcp.json` — both committed to git.

---

## Default skills by system

| System | Skills installed |
|--------|-----------------|
| **Shopify** | shopify-development, shopify-expert, shopify-theme-dev |
| **Nuxt / Vue** | nuxt, vue, vueuse |
| **Next.js / React** | vercel-react-best-practices, nextjs-developer, nextjs-app-router-patterns |
| **Laravel** | laravel-specialist, eloquent-best-practices |
| **Shopware** | shopware6-best-practices |
| **Storyblok** | storyblok-best-practices |

---

## Links

- [Skills marketplace](https://skills.sh/)
- [Claude-Mem](https://claude-mem.ai)
- [GSD workflow engine](https://github.com/get-shit-done-cc/get-shit-done-cc)
- [Context7](https://github.com/upstash/context7)
- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)
- [Concept & Design Decisions](.agents/context/CONCEPT.md)
