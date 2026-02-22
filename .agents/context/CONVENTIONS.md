# Conventions

## Language
- Primary: Bash (POSIX-compatible where possible)
- All file content: English only, no umlauts

## Naming Patterns
- Scripts: `kebab-case.sh`
- Template files: `kebab-case.md`
- Spec files: `NNN-description.md` (zero-padded number prefix)
- Commands: `verb-noun.md` pattern (e.g., `spec-work.md`, `context-freshness.sh`)

## Shell Script Style
- Functions grouped by responsibility
- Interactive menus use arrow-key/space-toggle patterns
- State persisted between generation phases via temp files or flags
- Verbose user feedback during multi-step setup

## Template Authoring
- Templates are markdown files copied verbatim into target projects
- Placeholders substituted via `sed` or heredoc patterns in `ai-setup.sh`
- Templates must not contain project-specific assumptions

## Spec Workflow (for changes to this repo)
- Specs in `specs/NNN-description.md` before coding
- Use `/spec "task"` to create, `/spec-work NNN` to execute
- Completed specs move to `specs/completed/`

## Error Handling
- Not determined from available context (bash scripts use exit codes and echo)

## Testing
- Not determined from available context (no test framework found)

## What to Avoid
- Adding runtime dependencies to this package
- Editing CLAUDE.md mid-session (breaks prompt cache)
- Starting complex tasks without flagging model requirement
