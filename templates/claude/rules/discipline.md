# Discipline (Surgical + Goal-Driven)

Adapted from Karpathy's LLM-coding pitfalls. Triggers: ≥3 tool calls, architectural decision, ≥2 file edits. Skip for trivial one-liners and typo fixes — judgment over rigor.

## Surgical Changes

**Touch only what the user asked for.**

- Don't "improve" adjacent code, comments, formatting, or imports.
- Don't refactor things that aren't broken — even if you'd write them differently.
- Match existing style of the file/layer (naming, indentation, error handling).
- Notice unrelated dead code? **Mention it, don't delete it.**

**Orphan rule** — clean only your own mess:

- Remove imports/vars/functions YOUR edit made unused.
- Don't remove pre-existing dead code unless asked.

**The test**: every changed line must trace directly to the user's request. If you can't justify a line by the task, revert it.

## Goal-Driven Execution

**Transform imperative tasks into verifiable goals before coding.**

| Imperative       | Verifiable goal                                                      |
| ---------------- | -------------------------------------------------------------------- |
| "Add validation" | Write failing tests for invalid inputs → make them pass              |
| "Fix the bug"    | Write a test reproducing the bug → make it pass                      |
| "Refactor X"     | Capture tests/snapshot before → ensure same after                    |
| "Make it work"   | Define what "work" means (output, status, log line) → loop until met |

**Multi-step tasks**: state the plan with verify-checks before executing.

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") force constant clarification.

## Anti-Pattern

- Drive-by-Refactor während Bugfix
- Style-Angleichung anderer Files weil "war eh inkonsistent"
- Pre-existing dead code löschen ohne Auftrag
- "Done" ohne verifiable check (Test/Build/Output)
- 200 Zeilen für 50-Zeilen-Task — wenn doppelte Größe vom Minimum, stop und simplify
