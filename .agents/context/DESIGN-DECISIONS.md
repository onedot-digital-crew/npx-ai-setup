# Design Decisions: @onedot/ai-setup

## Bash, Not Node.js

**Decision**: The setup script is written in Bash, not Node.js (despite being an npm package).

**Rationale**: The script runs in environments where Node.js version, package manager, and toolchain are unknown. A Bash script has no runtime dependencies beyond the shell. It runs identically on macOS (bash 3.2), Linux (bash 4+), and CI environments. There is also no compile step, no `node_modules`, and no version mismatch issues.

**Constraint**: The script must be POSIX-compatible where possible. macOS ships with bash 3.2, which lacks many bash 4+ features (no associative arrays, no `mapfile`). Where bash 4+ is required, the script checks the version and falls back gracefully.

## cksum, Not md5

**Decision**: File checksums use `cksum` instead of `md5sum` or `md5`.

**Rationale**: `md5sum` is not available on macOS by default (only `md5`). `md5` is not available on Linux. `cksum` is POSIX-standard and available everywhere. The checksum is used only for change detection (is this file modified?), not for security — cksum is sufficient.

## Templates, Not Generated Content

**Decision**: Hooks, commands, settings, and agents are static templates, not generated per-project.

**Rationale**: Generative content is harder to review, harder to version, and non-deterministic. A developer running the setup tool should know exactly what they are getting. Templates are committed to this repository, visible on GitHub, and updated via version bumps. The generated parts (CLAUDE.md Commands section, context files) are the minimum necessary — the parts that cannot be templated because they require knowledge of the specific project.

## Granular Permissions, Not Bash(*)

**Decision**: `.claude/settings.json` lists explicit bash permissions instead of `Bash(*)`.

**Rationale**: `Bash(*)` allows any shell command, which is a broad surface area for mistakes. Granular permissions mean that common dangerous operations (git push, rm -rf, npm publish) require explicit user approval. This is a safety default — users who want full autonomy can use `claude --dangerously-skip-permissions`.

The permission list is intentionally generous for development operations (git, npm, eslint, prettier, grep, curl) while blocking operations that are hard to reverse or affect shared state.

## Claude Haiku for Skill Curation

**Decision**: Skill selection uses Claude Haiku (not Sonnet or Opus).

**Rationale**: Skill curation is a ranking task with structured input (list of skills + install counts) and simple output (top 5 picks). It does not require reasoning depth. Haiku is fast (< 5s), cheap, and accurate enough for this task. Using a more capable model would add cost and latency for no quality gain.

**Fallback**: If Haiku times out or Claude is unavailable, the script falls back to installing the top 3 skills by install count, without AI curation. This ensures skills are always installed even in offline or rate-limited environments.

## Auto-Init is Optional

**Decision**: Auto-Init (the AI-powered generation phase) is opt-in, not required.

**Rationale**: Auto-Init requires the Claude CLI to be installed and authenticated. Many teams may run the setup in CI, on new machines, or before Claude is configured. The scaffolding (Phase 1) is always useful regardless of AI availability. Separating the two phases means the tool always succeeds, even when the AI layer is unavailable.

## Parallel Context Generation

**Decision**: CLAUDE.md generation and context file generation run in parallel during Auto-Init.

**Rationale**: The two tasks are independent. CLAUDE.md generation reads config files (package.json, eslintrc, prettierrc). Context generation reads the full codebase. Running them in parallel cuts Auto-Init time roughly in half. The skill curation step runs after both complete because it uses the context files to make better selections.

## No Build Step

**Decision**: The npm package has no build step. The Bash script is published directly.

**Rationale**: A build step would add complexity (transpiler config, CI build, watch mode) for no benefit. Bash scripts do not need compilation. The `bin/ai-setup.sh` file is the source and the artifact — there is nothing to build.

## Context Files Referenced by CLAUDE.md

**Decision**: `.agents/context/*.md` files are not auto-injected — they are referenced in CLAUDE.md.

**Rationale**: Claude always reads CLAUDE.md at session start. CLAUDE.md contains explicit `@path` references to the context files, which triggers Claude to read them. This makes context loading deterministic and visible. An alternative (auto-injecting context files into settings.json) would make context loading implicit and harder to debug.

## Spec-Driven Development Included

**Decision**: The spec workflow (`specs/`, `/spec`, `/spec-work`) is included in the scaffolding.

**Rationale**: The spec workflow is the recommended pattern for using this tool in real projects — it's how this tool itself is developed. Including it in the scaffolding means every project that uses `@onedot/ai-setup` gets the same structured workflow out of the box, without requiring the developer to discover it separately.
