---
model: sonnet
mode: plan
allowed-tools: Read, Glob, Grep, Bash
---

Displays a Kanban board of all specs with status and step progress. Use for an overview of the current spec pipeline.

## Process

### 1. Discover all specs
Glob `specs/*.md` and `specs/completed/*.md` (exclude `README.md` and `TEMPLATE.md`). Read each file's header block and step checkboxes.

### 2. Parse each spec
Extract from every spec file:
- **Spec ID**: from `Spec ID` in header
- **Title**: from the `# Spec:` heading
- **Status**: from `Status` in header (`draft`, `in-progress`, `in-review`, `blocked`, `completed`)
- **Branch**: from `Branch` in header (if present, `—` means none)
- **Step progress**: count `- [x]` vs total `- [ ]` + `- [x]` in the `## Steps` section only (not Acceptance Criteria)

### 3. Group by status columns
Map specs into columns:

| Column | Statuses |
|---|---|
| BACKLOG | `draft` |
| IN PROGRESS | `in-progress` |
| REVIEW | `in-review` |
| BLOCKED | `blocked` |
| DONE | `completed` |

### 4. Display the board
Format as a clean overview. For each spec show one line:

```
#NNN Title [done/total] (branch: name)
```

Example output:

```
BACKLOG (2)              IN PROGRESS (1)          REVIEW (1)             DONE (3)
────────────────         ────────────────         ────────────────       ────────────────
#014 Export API          #012 Auth flow           #011 Search            #008 DB schema
#015 Dark mode             [5/8] spec/012           [8/8] spec/011        #009 API routes
                                                                          #010 Unit tests

BLOCKED (1)
────────────────
#013 Payments
  blocked — depends on #012
```

- Omit step progress for `draft` specs (no work started) and `completed` specs
- Show branch name only if not `—`
- For `blocked` specs, show the reason if found in the spec's `## Review Feedback` section
- Sort specs within each column by Spec ID ascending

### 5. Summary line
After the board, show:
```
Total: N specs | B backlog, P in-progress, R in-review, X blocked, D done
```

If any specs have all steps checked but status is still `in-progress`, flag them:
```
Ready for review: #NNN Title (all steps complete, run /spec-review NNN)
```

## Rules
- Do NOT make any changes. This is read-only.
- If `specs/` does not exist or has no spec files, report "No specs found" and stop.
- Only count checkboxes in the `## Steps` section, not `## Acceptance Criteria`.
