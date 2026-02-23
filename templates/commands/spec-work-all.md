---
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
---

Execute all draft specs in `specs/` using parallel subagents in isolated Git worktrees.

## Process

### 1. Discover draft specs
Scan `specs/` for all `NNN-*.md` files (excluding `specs/completed/`). Only pick specs with `Status: draft`. Read each spec's Goal and Out of Scope to build a dependency map.

### 2. Dependency detection
A spec is **dependent** on another if its "Out of Scope" section explicitly names another spec number (e.g. "Spec 010", "spec 009"). Dependent specs must run after the spec they reference.

Group specs into:
- **Parallel group**: specs with no dependencies on each other
- **Sequential queue**: specs that depend on a parallel spec (run after their dependency completes)

### 3. Gitignore setup
Ensure `.worktrees/` is in `.gitignore`. If not, append it:
```bash
grep -qxF '.worktrees/' .gitignore 2>/dev/null || echo '.worktrees/' >> .gitignore
```

### 4. Execute in waves

#### Wave setup — create worktrees
For each spec in the current wave, before launching subagents:

1. Derive branch name: `spec/NNN-title` (lowercase, hyphens, from spec filename without `.md`)
2. Create worktree: `git worktree add .worktrees/spec-NNN -b spec/NNN-title`
   - If branch already exists: `git worktree add .worktrees/spec-NNN spec/NNN-title`
3. **Copy .env files**: Copy all `.env*` files from repo root into the worktree, skipping `.env.example` and `.env.template`. If no `.env*` files exist, skip silently. Warn but continue on failure:
   ```bash
   for f in .env*; do
     [[ -f "$f" ]] || continue   # skip if glob didn't match (no .env files)
     [[ "$f" == ".env.example" || "$f" == ".env.template" ]] && continue
     cp "$f" ".worktrees/spec-NNN/" 2>/dev/null || echo "  ⚠️  Could not copy $f to worktree — continuing"
   done
   ```
4. **Install dependencies**: Detect lockfile in repo root and run install inside worktree. Skip if no lockfile found. Warn but continue on failure:
   ```bash
   if [ -f "bun.lockb" ]; then
     (cd .worktrees/spec-NNN && bun install --frozen-lockfile 2>/dev/null) || echo "  ⚠️  bun install failed — continuing"
   elif [ -f "package-lock.json" ]; then
     (cd .worktrees/spec-NNN && npm ci 2>/dev/null) || echo "  ⚠️  npm ci failed — continuing"
   elif [ -f "pnpm-lock.yaml" ]; then
     (cd .worktrees/spec-NNN && pnpm install --frozen-lockfile 2>/dev/null) || echo "  ⚠️  pnpm install failed — continuing"
   elif [ -f "yarn.lock" ]; then
     (cd .worktrees/spec-NNN && yarn install --frozen-lockfile 2>/dev/null) || echo "  ⚠️  yarn install failed — continuing"
   fi
   ```
5. Update spec header in the **main working directory** spec file:
   - Set `**Status**: in-progress`
   - Set `**Branch**: spec/NNN-title`

#### Wave execution — parallel subagents
Launch one Task subagent per spec simultaneously. Each subagent receives:

**Prompt for each subagent:**
```
Execute this spec in the worktree at .worktrees/spec-NNN.

IMPORTANT: All file operations (Read, Write, Edit, Bash) must target files inside
.worktrees/spec-NNN/ — this is an isolated Git worktree with its own branch.
The spec file itself lives in the main working directory at specs/NNN-*.md.

Note: .env files have been copied and dependencies installed (if applicable) — the
worktree is ready to use. Do not re-run installs unless a step explicitly requires it.

Spec content:
[full spec content here]

Process:
1. Read .agents/context/CONVENTIONS.md and .agents/context/STACK.md from the worktree if they exist
2. Load relevant skills if referenced in the spec's Context section
3. Execute each step in order — work inside .worktrees/spec-NNN/
4. After completing each step, edit the spec file in the MAIN directory (specs/NNN-*.md)
   to check it off: - [ ] → - [x]
5. After all steps: verify acceptance criteria, mark them checked in the spec
6. Stage and commit all changes in the worktree:
   git add -A && git commit -m "spec(NNN): [spec title]"
   Run this inside .worktrees/spec-NNN/
7. Update spec status to in-review
8. Prepend CHANGELOG entry:
   - Find/create ## YYYY-MM-DD heading for today
   - Add: - **Spec NNN**: [Title] — [1-sentence summary]
   - Insert after <!-- Entries are prepended below this line, newest first -->
```

#### Wave cleanup — remove worktrees
After each wave completes, for each spec:
1. Remove the worktree: `git worktree remove .worktrees/spec-NNN --force`
2. Verify the branch exists: `git branch --list spec/NNN-*`

**Wave 2+**: After each wave completes, launch the next wave of specs that are now unblocked. Repeat setup → execution → cleanup for each wave.

### 5. Final summary
After all waves complete, report:
- Completed specs (with spec ID, title, and branch name)
- Failed specs (with spec ID and reason)
- Total: N completed, M failed
- Next step: `Run /spec-review NNN for each completed spec, or /spec-board for overview`

## Rules
- Follow each spec exactly — no scope creep
- If a step in a spec is blocked or unclear, mark it unchecked and continue remaining steps
- Each subagent works ONLY in its own worktree — never modify files in the main working directory except the spec file and CHANGELOG.md
- If `specs/` has no draft specs, report "No draft specs found" and stop
- If `git worktree` fails (e.g. dirty working tree), report the error and skip that spec
- Always clean up worktrees, even if the subagent fails
