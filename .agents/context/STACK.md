# Stack

## Runtime
- Bash (primary language — `bin/ai-setup.sh`)
- No Node.js runtime; no TypeScript; no tsconfig

## Package
- `@onedot/ai-setup` v1.1.2
- Published via npm as `npx github:onedot-digital-crew/npx-ai-setup`
- Package manager: npm (npx distribution)

## Key Dependencies
- None (pure bash, no npm dependencies)

## Templates System
- Markdown templates in `templates/` copied during setup
- Supports systems: `auto`, `shopify`, `nuxt`, `next`, `laravel`, `shopware`, `storyblok`
- Optional integrations: GSD, Claude-Mem, Context7, Playwright MCP, plugins

## Optional Integrations (installed into target projects)
- GSD workflow engine (`--with-gsd`)
- Claude-Mem persistent memory (`--with-claude-mem`)
- Claude Code plugins (`--with-plugins`)
- Context7 MCP (`--with-context7`)
- Playwright MCP (`--with-playwright`)

## Build Tooling
- None — shell script is executed directly

## Avoid
- Adding Node.js/npm runtime dependencies
- TypeScript or compiled artifacts
- Framework-specific assumptions in core scripts
