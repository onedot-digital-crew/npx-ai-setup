---
model: sonnet-4-6
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

End-of-session technical debt sweep.

## Process

1. **Scan recent changes**: Run `git diff --name-only HEAD~5` (or fewer if less history) to focus on recently touched files.
2. **Check each file for**:
   - Duplicated code blocks (3+ similar lines appearing in multiple places)
   - Dead exports (exported but never imported anywhere)
   - Unused imports
   - TODO/FIXME/HACK comments that could be resolved now
   - Inconsistent patterns compared to the rest of the codebase
3. **Report findings** grouped by category with file paths and line numbers.
4. **Fix clear wins only**: Remove unused imports, delete dead exports, consolidate obvious duplicates. Leave anything ambiguous for the user.

## Rules
- Only scan recently changed files — not the entire codebase.
- Fix only clear, safe wins. Do not refactor working code.
- Do not change public APIs or behavior.
- Report but do not fix anything you're unsure about.
