# Spec 576 — Spec Command/Skill Consolidation

**Status**: completed
**Goal**: Eliminate dual-implementation of spec commands. Skills become the single source of truth; commands become thin wrappers (3 lines each).

## Problem

Spec functionality exists in two parallel systems:
- `.claude/commands/spec-*.md` — full implementations (48–188 lines)
- `.claude/skills/spec-*/SKILL.md` — partial reimplementations (36–113 lines)

When `/spec-work` is typed, the **command** executes (not the skill). Both can diverge silently. Maintenance overhead doubles.

## Solution

**Skills win.** Full implementation goes into SKILL.md. Commands become 3-line redirectors:

```markdown
---
model: sonnet
argument-hint: "[spec number]"
---
$ARGUMENTS — invoke via the `Skill` tool with skill `spec-work`.
```

Actually: commands can't programmatically invoke the Skill tool. The correct thin wrapper is an instruction to Claude:

```markdown
---
model: sonnet
argument-hint: "[spec number]"
---
Use the Skill tool: `Skill({skill: "spec-work", args: "$ARGUMENTS"})`.
```

## Steps

- [x] Step 1: Audit — diff each command vs its skill, identify which has more complete/correct content per pair
- [x] Step 2: Merge `spec-work` — expand SKILL.md with full command content, strip command to 5-line wrapper
- [x] Step 3: Merge `spec` (create) — expand `spec-create` SKILL.md, strip `spec.md` command
- [x] Step 4: Merge `spec-review`, `spec-validate`, `spec-board`, `spec-work-all`
- [x] Step 5: Sync templates — mirror all changes to `templates/commands/` and `templates/skills/`
- [x] Step 6: Update `lib/setup.sh` if installation logic references command content

## Acceptance Criteria

- [x] Each spec command file is ≤10 lines
- [x] Each spec SKILL.md contains the full, merged implementation
- [x] `/spec-work 074` still executes correctly (via Skill tool invocation)
- [x] No content exists only in the command that isn't in the SKILL.md
- [x] Template files match installed files

## Files to Modify

**Commands (→ thin wrappers):**
- `templates/commands/spec.md` + `.claude/commands/spec.md`
- `templates/commands/spec-work.md` + `.claude/commands/spec-work.md`
- `templates/commands/spec-review.md` + `.claude/commands/spec-review.md`
- `templates/commands/spec-validate.md` + `.claude/commands/spec-validate.md`
- `templates/commands/spec-board.md` + `.claude/commands/spec-board.md`
- `templates/commands/spec-work-all.md` + `.claude/commands/spec-work-all.md`

**Skills (→ full implementation):**
- `templates/skills/spec-create/SKILL.md` + `.claude/skills/spec-create/SKILL.md`
- `templates/skills/spec-work/SKILL.md` + `.claude/skills/spec-work/SKILL.md`
- `templates/skills/spec-review/SKILL.md` + `.claude/skills/spec-review/SKILL.md`
- `templates/skills/spec-validate/SKILL.md` + `.claude/skills/spec-validate/SKILL.md`
- `templates/skills/spec-board/SKILL.md` + `.claude/skills/spec-board/SKILL.md`
- `templates/skills/spec-work-all/SKILL.md` + `.claude/skills/spec-work-all/SKILL.md`
