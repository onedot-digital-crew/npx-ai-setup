# Architecture

## Project Type
CLI tool — bash script that bootstraps Claude Code AI infrastructure into target projects.

## Directory Structure
```
bin/            # Entry point: ai-setup.sh (main script)
lib/            # Modules: core, setup, update, generate, tui, skills, detect, process, plugins
templates/      # Files copied into target projects
  CLAUDE.md     # Base Claude project instructions template
  repomix.config.json  # Repomix snapshot config template
  claude/       # hooks/, settings.json, rules/
  commands/     # Slash command templates
  agents/       # Subagent templates (context-refresher, code-reviewer, etc.)
  specs/        # Spec workflow templates
  github/       # GitHub Copilot instructions
  skills/       # Shopify skill templates
.agents/context/ # Auto-generated session context (this file)
.claude/        # Claude Code config for THIS repo
docs/           # Concept and design-decision docs (CONCEPT.md, DESIGN-DECISIONS.md)
specs/          # Spec-driven dev specs for this project
```

## Setup Flow
```
npx @onedot/ai-setup [--system X] [--with-*]
  |
  ├─ Version check (.ai-setup.json present?)
  |    ├─ Same version → smart update menu
  |    └─ New version → update / clean reinstall / skip
  |
  └─ Fresh install:
       Phase 1: Scaffolding (bash only, no AI)
         - CLAUDE.md, settings.json, hooks, commands, agents, specs
         - repomix.config.json, mcp.json (optional), plugins
       Phase 2: Auto-Init (optional, requires claude CLI)
         - Parallel: CLAUDE.md generation + context file generation
         - Sequential after: skill curation (detect → search → rank → install)
```

## Phase 2: Auto-Init (parallel then sequential)
```
Step 1+2 (parallel):
  CLAUDE.md generation  — reads package.json, README, eslintrc, prettierrc
  Context generation    — reads codebase → STACK.md, ARCHITECTURE.md, CONVENTIONS.md

Step 3 (sequential):
  A: keyword mapping from package.json deps
  B: skills.sh search (parallel curl, 30s timeout)
  C: install count fetch (parallel curl)
  D: Claude Haiku → select top 5
  E: install selected skills
```

## Key Patterns
- **Template copy model**: files copied verbatim, no code generation for deterministic parts
- **Config-aware repomix**: uses `repomix.config.json` if present, inline flags as fallback
- **Update tracking**: `.ai-setup.json` stores checksums; user-modified files backed up before update
- **Hooks**: circuit-breaker (edit-loop protection), context-freshness (stale context detection)
- **Idempotent installs**: all steps check before overwriting; skip if already installed
