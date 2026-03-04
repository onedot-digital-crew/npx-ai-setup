---
model: opus
mode: plan
allowed-tools: Read, Write, Edit, Glob, AskUserQuestion
---

Analyze the current session for corrections, architectural discoveries, and stack decisions — convert them into permanent rules.

## Process

### 1. Recall signals from this session

Review the conversation history in your context. Look for four categories of signals:

**CORRECTION signals** (explicit corrections — must apply):
- "don't do X", "stop doing Z", "not like that"
- "use Y instead", "wrong approach", "revert that"
- "I said X, not Y", "that's incorrect"

**AFFIRMATION signals** (approved approaches — apply if consistent):
- "good", "exactly", "yes that's right", "keep doing that"
- "that's the right way", "perfect", "this is how I want it"

**ARCHITECTURAL signals** (discovered patterns, component relationships, gotchas):
- Discovered data flow paths or component dependencies
- Codebase gotchas ("this file actually controls X", "Y depends on Z")
- Structural patterns ("all routes go through middleware X", "state lives in Y")
- Integration boundaries ("service A talks to B via C")

**STACK signals** (new deps, version decisions, tool choices discovered at runtime):
- New dependency added or removed during session
- Version constraint discovered ("library X requires Node >= 18")
- Tool choice made ("use pnpm not npm", "vitest not jest")
- Runtime requirement discovered ("needs Redis running locally")

Only process CORRECTION, AFFIRMATION, ARCHITECTURAL, and STACK signals. Skip general questions, clarifications, and one-off decisions without a clear general rule.

### 2. Classify each signal by target

For each signal found, classify where it belongs:

| Signal type | Target file |
|---|---|
| Coding style, naming, patterns, tooling choices | `.agents/context/CONVENTIONS.md` |
| Project workflow, process rules, safety rules | `CLAUDE.md` Critical Rules section |
| Tool usage, commands, CLI patterns | `CLAUDE.md` Commands section |
| Component relationships, data flow, gotchas, structural patterns | `.agents/context/ARCHITECTURE.md` |
| Dependencies, versions, runtime requirements, tool choices | `.agents/context/STACK.md` |

### 3. Draft proposed additions

Read all target files first to check for existing content and prevent duplicates:
- Read `CLAUDE.md` to see current Critical Rules and Commands sections
- Read `.agents/context/CONVENTIONS.md` to see current conventions
- Read `.agents/context/ARCHITECTURE.md` to see current architecture notes
- Read `.agents/context/STACK.md` to see current stack decisions

For each signal, draft a rule or fact addition:
- Maximum 1-2 lines per entry
- Corrections/affirmations: phrase as a directive ("Always X", "Never Y", "Use X instead of Y")
- Architectural findings: phrase as a factual statement ("Component X depends on Y", "All API calls route through Z")
- Stack findings: phrase as a factual statement ("Requires Node >= 18", "Uses pnpm as package manager")
- Do NOT duplicate content already present in the target file

If no actionable signals were found in this session, report that clearly and stop.

### 4. Show proposed changes for approval

Use AskUserQuestion to present the proposed additions and ask for approval before writing anything.

Format the proposal as a diff preview showing exactly what will be appended to each file. Show all four possible targets (only those with proposed changes):

Example question:
```
Proposed additions from this session:

File: .agents/context/CONVENTIONS.md
+ Always use kebab-case for script filenames

File: CLAUDE.md (Critical Rules)
+ Never modify template files directly — use generation logic instead

File: .agents/context/ARCHITECTURE.md
+ API routes pass through auth middleware before reaching handlers
+ The event bus in src/events/ decouples service communication

File: .agents/context/STACK.md
+ Requires Redis 7+ running locally for session storage
+ Uses vitest (not jest) for unit tests

Apply these changes?
Options: [Apply all] [Skip all] [Edit manually]
```

### 5. Write approved changes

Only write items the user approved. For each approved item:
- Append to the end of the relevant section (never delete or rewrite existing content)
- If appending to CONVENTIONS.md, add under the most relevant existing section header
- If appending to CLAUDE.md, add under "Critical Rules" or "Commands" as classified
- If appending to ARCHITECTURE.md, add under the most relevant existing section header (or create a new one if none fits)
- If appending to STACK.md, add under the most relevant existing section header (or create a new one if none fits)
- Keep additions minimal and self-contained

## Rules
- Never delete or overwrite existing rules — append only.
- Never write low-signal observations as rules.
- If a signal is ambiguous, skip it rather than guess.
- If no signals were found, say so and stop — do not invent rules.
- Changes must be explicit and git-trackable — no silent mutations.
