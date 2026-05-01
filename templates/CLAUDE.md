# CLAUDE.md

## Project Context

@.agents/context/SUMMARY.md
Details on demand: `@.agents/context/STACK.md` | `ARCHITECTURE.md` | `CONVENTIONS.md` | `DESIGN-DECISIONS.md` (why-decisions, not how).

## Rules (load on demand)

- Investigation/debug discipline → `.claude/rules/quality.md`
- Surgical changes + goal-driven execution → `.claude/rules/discipline.md`
- Model routing: haiku (explore/read-only), sonnet (code generation/default), opus (arch) → `.claude/rules/agents.md`
- External docs (Context7 first) → `.claude/rules/general.md`
- External verification in Plan-Phase (Spec/Explore/Design) → `.claude/rules/external-verification.md`
- **Code-Reuse Pflicht-Scan vor neuen Helpers/Types/Composables** → `.claude/rules/code-reuse.md`
- MCP usage (project + global servers) → `.claude/rules/mcp.md`
- Git/commits/branches → `.claude/rules/git.md`
- Hooks token policy → `.claude/rules/hooks-token-policy.md`
- Code-review reception → `.claude/rules/code-review-reception.md`
- Testing → `.claude/rules/testing.md`
- Workflow routing → `.claude/rules/workflow.md`
- TypeScript (TS projects only) → `.claude/rules/typescript.md`

## Hard Constraints

- **RTK**: prefix ALL shell commands with `rtk` (e.g. `rtk git status`, `rtk grep ...`). Reference: `.claude/docs/rtk-reference.md`.
- **Build artifacts**: never read/search `dist/`, `.output/`, `.nuxt/`, `.next/`, `build/`, `coverage/`. Blocked via `permissions.deny`.
- **Frontend verify**: after editing `*.vue` `*.tsx` `*.jsx` `*.liquid` `*.css` `*.scss`, invoke `/agent-browser` for visual screenshot. Type-check ≠ rendered correctly.
- **Sandbox**: never set `dangerouslyDisableSandbox: true` without explicit user confirmation.
- **Skill `!` exec**: prep-skills (`/test`, `/ci`, quality-gate) use `!`-prefixed shell. If org policy sets `disableSkillShellExecution: true`, those skills fail silently — fallback: run the `.sh` directly via Bash.

## CLI Shortcuts (zero tokens)

CI `! bash .claude/scripts/ci-prep.sh` | Lint `! bash .claude/scripts/lint-prep.sh` | Test `! bash .claude/scripts/test-prep.sh` | Quality-gate `! bash .claude/scripts/quality-gate.sh` | Debug `! bash .claude/scripts/debug-prep.sh`

## Automation (Agent SDK CLI)

Non-interactive: `claude -p "<prompt>" --output-format json`. CI: `--bare` disables hooks/skills/MCP. Cost: `--max-budget-usd 0.50` / `--max-turns 20`.

## Documentation Lookup

Always use Context7 MCP when you need library/API documentation, code generation,
setup or configuration steps. Add "use context7" to prompts or it will be auto-invoked.
