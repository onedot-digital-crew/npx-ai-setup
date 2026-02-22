# Architecture

## Project Type
CLI tool — bash script that bootstraps Claude Code AI infrastructure into target projects.

## Directory Structure
```
bin/            # Entry point: ai-setup.sh (main script)
templates/      # Files copied into target projects
  claude/       # Claude Code config: hooks/, settings.json
  commands/     # Slash command templates (spec.md, spec-work.md, bug.md, etc.)
  agents/       # Agent templates (context-refresher.md)
  specs/        # Spec templates
  github/       # GitHub Actions templates
specs/          # Spec-driven dev specs for this project itself
  completed/    # Archived completed specs
.agents/context/ # Auto-generated project context (STACK, ARCHITECTURE, CONVENTIONS)
.claude/        # Claude Code config for THIS repo
  agents/       # Agent definitions
  commands/     # Slash commands for THIS repo
  hooks/        # Hooks: circuit-breaker.sh, context-freshness.sh
docs/           # Architecture, concept, design decisions docs
```

## Entry Point
- `bin/ai-setup.sh` — interactive CLI; detects system, collects options, copies templates, runs Claude to generate CLAUDE.md and context files

## Data Flow
1. User runs `npx github:onedot-digital-crew/npx-ai-setup [--system X] [--with-*]`
2. Script detects or prompts for target system(s)
3. Copies relevant templates into target project
4. Optionally installs skills from registry
5. Invokes Claude Code to analyze codebase and populate CLAUDE.md + `.agents/context/`

## Key Patterns
- Template copy model: no code generation, files are copied verbatim or with substitution
- System-specific skill selection: skills mapped per system (nuxt, shopify, etc.)
- Spec-driven development for changes to this repo itself
- Hooks: circuit-breaker (edit-loop protection), context-freshness (stale context detection)
