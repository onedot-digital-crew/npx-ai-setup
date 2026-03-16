# Spec: Project Onboarding Audit

> **Spec ID**: 098 | **Created**: 2026-03-16 | **Status**: completed | **Branch**: — | **Depends on**: 095, 096

## Goal
After setup on an existing project, an agent efficiently understands the codebase and produces `PATTERNS.md` + `AUDIT.md` in `.agents/context/`, then asks whether to create specs for the top findings.

## Context
`ai-setup` installs tooling but leaves Claude blind to existing project patterns and technical debt. Developers have to manually orient Claude every session. A one-time audit agent reads the codebase efficiently (context files → compressed snapshot → spot-reads) and persists its findings as machine-readable context that Claude loads automatically in future sessions.

## Efficient Reading Strategy (for the agent)
The agent must NOT read every source file. Fixed order:
1. `.agents/context/STACK.md` + `ARCHITECTURE.md` + `CONVENTIONS.md` — framework and structure
2. `.agents/repomix-snapshot.xml` with `--compress` — signatures only, no bodies
3. Spot-reads: `package.json`, main entry point, 1-2 representative service/component files
4. Produce findings from this — no further reading unless a specific pattern requires it

## Steps
- [x] Step 1: Add `--audit` flag parsing to `bin/ai-setup.sh` — after setup completes, invoke the `project-auditor` agent
- [x] Step 2: Create `templates/agents/project-auditor.md` — the agent with the efficient reading strategy, produces `PATTERNS.md` and `AUDIT.md`, asks before creating specs
- [x] Step 3: Create `templates/skills/project-audit/SKILL.md` — standalone skill for manual re-runs
- [x] Step 4: Added `project-audit` to `SPEC_SKILLS_MAP` in `lib/core.sh` — installed via `install_spec_skills`
- [x] Step 5: Smoke tests pass (86/86)

## Acceptance Criteria
- [x] `--audit` flag triggers the project-auditor agent after normal setup completes
- [x] `/project-audit` skill runs the same agent standalone without re-running setup
- [x] Agent produces `.agents/context/PATTERNS.md` (reusable patterns) and `.agents/context/AUDIT.md` (improvement opportunities)
- [x] Agent reads in the defined order and does NOT read full source files unless necessary
- [x] Agent asks user before creating any specs — does not auto-generate
- [x] Both output files are committed (team-shared per spec 100 decision)

## Output Format

**PATTERNS.md** — what to reuse:
```
## Established Patterns
- [Pattern name]: [where it's used, how to apply it]
```

**AUDIT.md** — what to improve:
```
## Findings
| Priority | Area | Issue | Suggested Action |
|----------|------|-------|-----------------|
| High     | ...  | ...   | ...             |
```

## Files to Modify / Create
- `bin/ai-setup.sh` — add `--audit` flag parsing
- `templates/agents/project-auditor.md` — new agent (create)
- `templates/skills/project-audit.md` — new skill (create)
- `lib/setup.sh` — add PATTERNS.md/AUDIT.md to .gitignore + skill install step

## Out of Scope
- Auto-creating specs without user confirmation
- Continuous/scheduled re-audits
- Diff-based incremental audits (full re-run each time)
