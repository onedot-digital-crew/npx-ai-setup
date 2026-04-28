# Skill Template Standard

Claude-first, portable where practical.

## Frontmatter

Required:

- `name`
- `description`

Recommended:

- `user-invocable`
- `effort`
- `allowed-tools`

Optional:

- `argument-hint`
- `model`
- `disable-model-invocation`

## Body Structure

Preferred order:

1. Short opening sentence
2. `## Process`
3. `## Rules`
4. `## Next Step`

Alternative top-level sections are acceptable when they are more precise, but avoid unnecessary prose.

## Writing Rules

- Keep the portable workflow logic in the body.
- Keep Claude-specific execution details concise.
- Prefer short imperative steps over long explanation blocks.
- Move long examples, prompts, or reference material into `references/` when possible.
- Avoid repeating global rules that already live in `CLAUDE.md` or `AGENTS.md`.
- Descriptions should stay trigger-oriented and compact.

## Portability

- Assume Claude Code is the primary runtime.
- Other models should still be able to follow the body text even if they ignore Claude-specific frontmatter.
- Do not make portability claims for tool features the other clients do not support.
