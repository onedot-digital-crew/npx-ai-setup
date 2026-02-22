---
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
---

Execute all draft specs in `specs/` using parallel subagents where possible.

## Process

### 1. Discover draft specs
Scan `specs/` for all `NNN-*.md` files (excluding `specs/completed/`). Read each spec's Goal and Out of Scope to build a dependency map.

### 2. Dependency detection
A spec is **dependent** on another if its "Out of Scope" section explicitly names another spec number (e.g. "Spec 010", "spec 009"). Dependent specs must run after the spec they reference.

Group specs into:
- **Parallel group**: specs with no dependencies on each other
- **Sequential queue**: specs that depend on a parallel spec (run after their dependency completes)

### 3. Execute in waves

**Wave 1 — parallel**: Launch one Task subagent per independent spec simultaneously. Each subagent receives:
- The full spec content
- The spec-work process below

**Wave 2+ — sequential**: After each wave completes, launch the next wave of specs that are now unblocked.

### 4. Spec-work process (each subagent follows this)
1. Read the spec file fully
2. Read `.agents/context/CONVENTIONS.md` and `.agents/context/STACK.md` if they exist
3. Execute each step in order — check off `- [ ]` → `- [x]` in the spec file after each step
4. Verify all acceptance criteria and mark them checked
5. Prepend entry to `CHANGELOG.md`:
   - Find/create `## YYYY-MM-DD` heading for today
   - Add: `- **Spec NNN**: [Title] — [1-sentence summary]`
   - Insert after `<!-- Entries are prepended below this line, newest first -->`
6. Change spec status from `draft` to `completed`
7. Move spec: `specs/NNN-*.md` → `specs/completed/NNN-*.md`

### 5. Final summary
After all waves complete, report:
- ✅ Completed specs (with spec ID and title)
- ❌ Failed specs (with spec ID and reason)
- Total: N completed, M failed

## Rules
- Follow each spec exactly — no scope creep
- If a step in a spec is blocked or unclear, mark it unchecked and continue remaining steps
- Do NOT commit — leave committing to the user
- If `specs/` has no draft specs, report "No draft specs found" and stop
