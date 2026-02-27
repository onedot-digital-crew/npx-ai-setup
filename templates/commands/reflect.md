---
model: opus
mode: plan
allowed-tools: Read, Write, Edit, Glob, AskUserQuestion
---

Analyze the current session for corrections and convert them into permanent rules.

## Process

### 1. Recall corrections from this session

Review the conversation history in your context. Look for signals where the user corrected, redirected, or affirmed your behavior:

**HIGH signals** (explicit corrections — must apply):
- "don't do X", "stop doing Z", "not like that"
- "use Y instead", "wrong approach", "revert that"
- "I said X, not Y", "that's incorrect"

**MEDIUM signals** (approved approaches — apply if consistent):
- "good", "exactly", "yes that's right", "keep doing that"
- "that's the right way", "perfect", "this is how I want it"

**LOW signals** (observations — skip):
- General questions, clarifications, exploratory discussion
- One-off decisions without a clear general rule

Only process HIGH and MEDIUM signals.

### 2. Classify each correction by target

For each HIGH/MEDIUM signal found, classify where the rule belongs:

| Correction type | Target file |
|---|---|
| Coding style, naming, patterns, tooling choices | `.agents/context/CONVENTIONS.md` |
| Project workflow, process rules, safety rules | `CLAUDE.md` Critical Rules section |
| Tool usage, commands, CLI patterns | `CLAUDE.md` Commands section |

### 3. Draft proposed additions

For each correction, draft a rule addition:
- Maximum 1-2 lines per rule
- Phrase as a directive: "Always X", "Never Y", "Use X instead of Y"
- Do NOT duplicate rules already present in the target file

Read the target files first to check for existing rules before drafting:
- Read `CLAUDE.md` to see current Critical Rules and Commands sections
- Read `.agents/context/CONVENTIONS.md` to see current conventions

If no actionable corrections were found in this session, report that clearly and stop.

### 4. Show proposed changes for approval

Use AskUserQuestion to present the proposed additions and ask for approval before writing anything.

Format the proposal as a diff preview showing exactly what will be appended to each file.

Example question:
```
Proposed rule additions from this session:

File: .agents/context/CONVENTIONS.md
+ Always use kebab-case for script filenames

File: CLAUDE.md (Critical Rules)
+ Never modify template files directly — use generation logic instead

Apply these changes?
Options: [Apply all] [Skip all] [Edit manually]
```

### 5. Write approved changes

Only write items the user approved. For each approved item:
- Append to the end of the relevant section (never delete or rewrite existing content)
- If appending to CONVENTIONS.md, add under the most relevant existing section header
- If appending to CLAUDE.md, add under "Critical Rules" or "Commands" as classified
- Keep additions minimal and self-contained

## Rules
- Never delete or overwrite existing rules — append only.
- Never write LOW-signal observations as rules.
- If a correction is ambiguous, skip it rather than guess.
- If no corrections were found, say so and stop — do not invent rules.
- Changes must be explicit and git-trackable — no silent mutations.
