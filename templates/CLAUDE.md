# CLAUDE.md

## Project Context
@.agents/context/SUMMARY.md
Details on demand: `@.agents/context/STACK.md` | `ARCHITECTURE.md` | `CONVENTIONS.md`.

## Rules (load on demand)
- Investigation/debug discipline → `.claude/rules/quality.md`
- Model routing (haiku/sonnet/opus), file navigation, context offload → `.claude/rules/agents.md`
- External docs (Context7 first) → `.claude/rules/general.md`
- MCP usage (project + global servers) → `.claude/rules/mcp.md`
- Git/commits/branches → `.claude/rules/git.md`
- Hooks token policy → `.claude/rules/hooks-token-policy.md`
- Code-review reception → `.claude/rules/code-review-reception.md`
- Testing → `.claude/rules/testing.md`
- Workflow routing → `.claude/rules/workflow.md`
- TypeScript (TS projects only) → `.claude/rules/typescript.md`

## Hard Constraints
- **RTK**: prefix ALL shell commands with `rtk`. Hook auto-rewrites where possible. Reference: `.claude/docs/rtk-reference.md`.
- **Build artifacts**: never read/search `dist/`, `.output/`, `.nuxt/`, `.next/`, `build/`, `coverage/`. Blocked via `permissions.deny`.
- **Frontend verify**: after editing `*.vue` `*.tsx` `*.jsx` `*.liquid` `*.css` `*.scss`, invoke `/agent-browser` for visual screenshot. Type-check ≠ rendered correctly.
- **Sandbox**: never set `dangerouslyDisableSandbox: true` without explicit user confirmation.

## CLI Shortcuts (zero tokens)
CI `! bash .claude/scripts/ci-prep.sh` | Lint `! bash .claude/scripts/lint-prep.sh` | Test `! bash .claude/scripts/test-prep.sh` | Health `! bash .claude/scripts/doctor.sh` | Quality-gate `! bash .claude/scripts/quality-gate.sh` | Debug `! bash .claude/scripts/debug-prep.sh`

## Automation (Agent SDK CLI)
Non-interactive: `claude -p "<prompt>" --output-format json`. CI: `--bare` disables hooks/skills/MCP. Cost: `--max-budget-usd 0.50` / `--max-turns 20`.
