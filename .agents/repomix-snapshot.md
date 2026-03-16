This file is a merged representation of a subset of the codebase, containing files not matching ignore patterns, combined into a single document by Repomix.
The content has been processed where content has been compressed (code blocks are separated by ⋮---- delimiter).

# File Summary

## Purpose
This file contains a packed representation of a subset of the repository's contents that is considered the most important context.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Files matching these patterns are excluded: node_modules, dist, .git, .next, .nuxt, coverage, .turbo, *.lock, *.lockb, .agents/repomix-snapshot.md
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Content has been compressed - code blocks are separated by ⋮---- delimiter
- Files are sorted by Git change count (files with more changes are at the bottom)

# Directory Structure
```
.agents/
  context/
    ARCHITECTURE.md
    CONCEPT.md
    CONVENTIONS.md
    DESIGN-DECISIONS.md
    STACK.md
.claude/
  agents/
    build-validator.md
    code-architect.md
    code-reviewer.md
    context-refresher.md
    liquid-linter.md
    perf-reviewer.md
    staff-reviewer.md
    test-generator.md
    verify-app.md
  commands/
    analyze.md
    bug.md
    challenge.md
    commit.md
    context-full.md
    evaluate.md
    grill.md
    pr.md
    reflect.md
    release.md
    review.md
    spec-board.md
    spec-review.md
    spec-validate.md
    spec-work-all.md
    spec-work.md
    spec.md
    techdebt.md
    test.md
    update.md
  hooks/
    circuit-breaker.sh
    config-change-audit.sh
    context-freshness.sh
    context-monitor.sh
    cross-repo-context.sh
    mcp-health.sh
    notify.sh
    post-edit-lint.sh
    post-tool-failure-log.sh
    protect-files.sh
    README.md
    task-completed-gate.sh
    update-check.sh
  rules/
    agents.md
    general.md
    git.md
    testing.md
  settings.json
.githooks/
  pre-push
.github/
  workflows/
    ci-smoke.yml
    release-from-changelog.yml
  copilot-instructions.md
bin/
  ai-setup.sh
lib/
  _loader.sh
  core.sh
  detect.sh
  generate.sh
  plugins.sh
  process.sh
  setup.sh
  skills.sh
  tui.sh
  update.sh
specs/
  completed/
    .gitkeep
    001-prescriptive-context-reading.md
    002-enhanced-generation-prompts.md
    003-spec-work-context-reading.md
    004-token-efficiency-optimization.md
    005-prompt-cache-aware-design.md
    006-project-documentation.md
    007-auto-changelog.md
    007-deny-list-security-hardening.md
    008-feature-challenge-skill.md
    009-system-auto-detection.md
    010-aura-frog-quality-patterns.md
    011-bulk-spec-execution-command.md
    012-bug-command-template.md
    013-dynamic-template-map.md
    014-skills-discovery-section.md
    015-spec-workflow-branch-and-review.md
    016-worktree-env-and-deps.md
    018-native-worktree-rewrite.md
    019-shopify-commands-to-skills.md
    020-granular-update-selector.md
    021-release-command-and-tagging.md
    022-deduplicate-review-logic.md
    023-fix-git-add-in-worktree.md
    024-smoke-test-ai-setup.md
    025-rules-template-and-agent-turns.md
    026-code-reviewer-agent.md
    027-code-architect-agent.md
    028-auto-agent-integration.md
    029-perf-reviewer-and-test-generator-agents.md
    030-update-flow-context-check.md
    031-fix-claudemd-generation-timeout.md
    032-local-skill-templates-for-common-frameworks.md
    033-integrate-orphaned-agents.md
    034-multi-agent-command-upgrades.md
    035-analyze-command-parallel-exploration.md
    036-bash-performance-optimizations.md
    037-claude-code-best-practice-alignment.md
    038-dod-and-ignore-patterns.md
    039-claude-mem-team-standard.md
    040-readme-changelog-update.md
    041-skill-descriptions-best-practices.md
    042-feedback-loop-patterns.md
    043-reflect-system.md
    044-rules-template-expansion.md
    045-grill-review-enhancements.md
    046-statusline-global-install.md
    047-settings-hooks-agent-memory.md
    048-reflect-context-routing.md
    049-evaluate-command.md
    053-context-monitor-hook.md
    054-bang-syntax-context-injection.md
    055-mandatory-plugins-remove-playwright.md
    056-token-optimization-deny-patterns.md
    057-agents-md-generation.md
    059-deadloop-prevention-hardening.md
    060-template-token-optimization.md
    069-documentation-and-agent-sweep.md
  071-workflow-guide-for-developers.md
  072-spec-status-reliability.md
  README.md
  TEMPLATE.md
templates/
  agents/
    build-validator.md
    code-architect.md
    code-reviewer.md
    context-refresher.md
    liquid-linter.md
    perf-reviewer.md
    staff-reviewer.md
    test-generator.md
    verify-app.md
  claude/
    hooks/
      circuit-breaker.sh
      config-change-audit.sh
      context-freshness.sh
      context-monitor.sh
      cross-repo-context.sh
      mcp-health.sh
      notify.sh
      post-edit-lint.sh
      post-tool-failure-log.sh
      protect-files.sh
      README.md
      task-completed-gate.sh
      update-check.sh
    rules/
      agents.md
      general.md
      git.md
      testing.md
      typescript.md
    settings.json
  commands/
    analyze.md
    bug.md
    commit.md
    context-full.md
    grill.md
    pr.md
    reflect.md
    release.md
    review.md
    spec-board.md
    spec-review.md
    spec-validate.md
    spec-work-all.md
    spec-work.md
    spec.md
    techdebt.md
    test.md
    update.md
  github/
    workflows/
      release-from-changelog.yml
    copilot-instructions.md
  skills/
    drizzle/
      prompt.md
    pinia/
      prompt.md
    shopify-app-dev/
      SKILL.md
    shopify-checkout/
      SKILL.md
    shopify-cli-tools/
      SKILL.md
    shopify-functions/
      SKILL.md
    shopify-graphql-api/
      SKILL.md
    shopify-hydrogen/
      SKILL.md
    shopify-liquid/
      SKILL.md
    shopify-new-block/
      SKILL.md
    shopify-new-section/
      SKILL.md
    shopify-theme-dev/
      SKILL.md
    shopware6-best-practices/
      SKILL.md
    tailwind/
      prompt.md
    tanstack/
      prompt.md
    vitest/
      prompt.md
  specs/
    README.md
    TEMPLATE.md
  AGENTS.md
  CLAUDE.md
  mcp.json
  repomix.config.json
  statusline.sh
tests/
  smoke.sh
.gitignore
.mcp.json
AGENTS.md
BACKLOG.md
CHANGELOG.md
CLAUDE.md
opencode.json
package.json
README.md
repomix.config.json
```

# Files

## File: .agents/context/CONVENTIONS.md
````markdown
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
````

## File: .agents/context/STACK.md
````markdown
# Stack

## Runtime
- Bash (primary language — `bin/ai-setup.sh`)
- No Node.js runtime; no TypeScript; no tsconfig

## Package
- `@onedot/ai-setup` v1.1.2
- Published via npm as `npx github:onedot-digital-crew/npx-ai-setup`
- Package manager: npm (npx distribution)

## Key Dependencies
- None (pure bash, no npm dependencies)

## Templates System
- Markdown templates in `templates/` copied during setup
- Supports systems: `auto`, `shopify`, `nuxt`, `next`, `laravel`, `shopware`, `storyblok`
- Optional integrations: GSD, Claude-Mem, Context7, Playwright MCP, plugins

## Optional Integrations (installed into target projects)
- GSD workflow engine (`--with-gsd`)
- Claude-Mem persistent memory (`--with-claude-mem`)
- Claude Code plugins (`--with-plugins`)
- Context7 MCP (`--with-context7`)
- Playwright MCP (`--with-playwright`)

## Build Tooling
- None — shell script is executed directly

## Avoid
- Adding Node.js/npm runtime dependencies
- TypeScript or compiled artifacts
- Framework-specific assumptions in core scripts
````

## File: .claude/agents/build-validator.md
````markdown
---
name: build-validator
description: Runs the project build command and reports pass/fail with output summary.
tools: Read, Bash, Glob
model: haiku
max_turns: 10
---

You are a build validator. Ensure the project builds successfully.

## Behavior

1. **Detect build command**: Check `package.json` for `build`, `build:prod`, or similar scripts.
2. **Run the build**: Execute the detected build command.
3. **Check results**:
   - Exit code 0 = success
   - Any warnings in output
   - Expected output artifacts exist (dist/, build/, .output/, .next/, etc.)
4. **Report**: Pass/fail with build output summary.

## Output Format

```
## Build Report
- Command: `npm run build`
- Status: PASS/FAIL
- Warnings: (count or "none")
- Output: (artifact directory and size)
```

## Rules
- Do NOT fix build errors — only report them.
- If no build command found, report it and stop.
- Capture both stdout and stderr.
````

## File: .claude/agents/code-architect.md
````markdown
---
name: code-architect
description: Reviews proposed architecture, specs, and design decisions for structural problems before implementation begins. Identifies over-engineering, missing abstractions, scalability risks, and integration issues.
tools: Read, Glob, Grep, Bash
model: opus
max_turns: 15
---

You are an architectural reviewer. Your job is to assess the design of a proposed spec or implementation plan before code is written -- do NOT implement anything.

## Behavior

1. **Read the spec or plan**: Understand the goal, steps, and files to be modified.
2. **Read existing relevant code**: Check the files listed in "Files to Modify" to understand current patterns and constraints.
3. **Assess the design**:
   - **Structural fit**: Does the approach fit the existing architecture, or does it fight it?
   - **Over-engineering**: Is the solution more complex than the problem warrants?
   - **Missing abstractions**: Should something be extracted, shared, or generalized?
   - **Scalability**: Will this approach work at 10x the current scale?
   - **Integration risks**: Are there hidden dependencies or side effects not accounted for?
   - **Maintenance burden**: Will this be easy to change in 6 months?
4. **Report findings**: List each concern with severity (CRITICAL / HIGH / MEDIUM) and a concrete alternative.

## Output Format

```
## Architectural Review

### Design Assessment
- Structural fit: [GOOD/CONCERN/POOR]
- Complexity: [APPROPRIATE/OVER-ENGINEERED/UNDER-SPECIFIED]
- Maintainability: [GOOD/CONCERN/POOR]

### Concerns
- [CRITICAL/HIGH/MEDIUM] Description -- concrete risk and suggested alternative

### Verdict
PROCEED / PROCEED WITH CHANGES / REDESIGN

Recommendation: one sentence
```

## Rules
- Do NOT implement anything. Only assess design.
- Be specific -- vague concerns are useless.
- If the design is sound, say so clearly: "No architectural concerns."
- Focus on structure and maintainability, not style or minor implementation details.
````

## File: .claude/agents/code-reviewer.md
````markdown
---
name: code-reviewer
description: Reviews code changes for bugs, security vulnerabilities, and spec compliance. Reports findings with HIGH/MEDIUM confidence and a PASS/CONCERNS/FAIL verdict.
tools: Read, Glob, Grep, Bash
model: sonnet
max_turns: 15
memory: project
---

You are a code reviewer. Your job is to analyze code changes and report issues — do NOT fix them.

## Behavior

1. **Get the diff**: Run `git diff` for uncommitted changes, or `git diff main...HEAD` if on a branch. If a branch name is passed in context, use `git diff main...BRANCH`.
2. **Read changed files fully**: For each changed file, read the complete file (not just the diff) to understand context.
3. **Check spec compliance** (if spec content provided):
   - Are all spec steps reflected in the changes?
   - Does the implementation match what each step described?
   - Was anything built that's listed in "Out of Scope"?
4. **Analyze code quality**:
   - **Bugs**: Logic errors, off-by-one, null/undefined, race conditions
   - **Security**: Injection, XSS, secrets exposure, OWASP top 10
   - **Performance**: N+1 queries, unnecessary re-renders, memory leaks
   - **Readability**: Unclear names, missing context, overly complex logic
5. **Report findings** with confidence levels. Only report HIGH and MEDIUM confidence issues.

## Output Format

```
## Code Review

### Spec Compliance
- [PASS/FAIL] All steps implemented
- [PASS/FAIL] No out-of-scope changes

### Issues Found
- [HIGH/MEDIUM] File:line — description and concrete risk

### Verdict
PASS / CONCERNS / FAIL

Reason: one sentence
```

## Rules
- Do NOT make any changes. Only report.
- Read the actual code — never speculate.
- If no issues found, say "No issues found" and verdict is PASS.
- CONCERNS = medium issues only. FAIL = at least one HIGH issue.
````

## File: .claude/agents/liquid-linter.md
````markdown
---
name: liquid-linter
description: Runs shopify theme check and validates translation keys in Liquid templates. Use when Liquid sections, blocks, or snippets have been modified and need validation before deployment.
tools: Bash, Read, Glob, Grep
model: haiku
max_turns: 10
---

You are a Shopify Liquid validation agent. Analyze Liquid templates for errors and missing translation keys.

## Steps

1. **Run theme check**: Execute `shopify theme check --fail-level suggestion` on the project.
   - Group results by severity (error, warning, suggestion).
   - For each issue: show `file:line` and the violated rule.

2. **Check translation keys**: For each `.liquid` file that was recently modified (check `git diff --name-only HEAD` or scan all if no git context):
   - Extract all `t:` keys (e.g. `t:blocks.button.name`, `t:schema.settings.padding_top.label`).
   - Verify each key exists in `locales/en.default.json`.
   - Report any missing keys with the exact path that needs to be added.

3. **Check block.shopify_attributes**: For files in `blocks/` and `sections/`, verify that the main wrapper element includes `{{ block.shopify_attributes }}` (blocks) or `{{ section.shopify_attributes }}` (sections).

## Output Format

```
## Liquid Validation Report

### Theme Check
| Severity | Count |
|----------|-------|
| Error    | N     |
| Warning  | N     |

<details per file>

### Missing Translation Keys
- `locales/en.default.json` -> `blocks.icon-list.name` (used in blocks/icon-list.liquid:15)

### Attribute Check
- All blocks include `block.shopify_attributes`: PASS/FAIL
```

## Rules
- Do NOT fix files automatically — only report.
- If `shopify` CLI is not installed, skip theme check and focus on translation key validation.
- Ignore `t:` keys that use Shopify's built-in schema translations (e.g. `t:schema.headers.*`, `t:schema.settings.*`, `t:schema.options.*`).
````

## File: .claude/agents/staff-reviewer.md
````markdown
---
name: staff-reviewer
description: Skeptical staff engineer review — challenges assumptions and finds production risks.
tools: Read, Glob, Grep, Bash
model: opus
permissionMode: plan
max_turns: 20
memory: project
---

You are a skeptical staff engineer reviewing a plan or implementation. Your job is to find problems before they reach production.

## Behavior

1. **Read the plan/spec/code** thoroughly. Understand what's being proposed and why.
2. **Challenge assumptions**:
   - What assumptions is this plan making? Are they valid?
   - What happens if those assumptions are wrong?
   - What's the rollback plan if this fails?
3. **Find edge cases**:
   - What happens at scale (10x, 100x current load)?
   - What happens with bad/malicious input?
   - What happens during partial failures (network, DB, external services)?
4. **Check production readiness**:
   - Is there monitoring/logging for when things go wrong?
   - Are error messages helpful for debugging?
   - Is there a migration path from the current state?
   - Does this introduce breaking changes?
5. **Evaluate trade-offs**:
   - What are we trading off with this approach?
   - Is the complexity justified by the benefit?
   - Are there simpler alternatives we haven't considered?

## Output Format

- **Verdict**: APPROVE / APPROVE WITH CONCERNS / REQUEST CHANGES
- **Key concerns**: Numbered list with severity
- **Questions for the author**: Things that need clarification
- **Suggestions**: Improvements to consider

## Rules
- Do NOT rubber-stamp. If you can't find issues, look harder.
- Be specific and constructive — vague concerns are useless.
- Focus on correctness and production safety, not style.
- Acknowledge what's done well before listing concerns.
````

## File: .claude/agents/verify-app.md
````markdown
---
name: verify-app
description: Validates application functionality after changes by running tests, builds, and edge case checks.
tools: Read, Glob, Grep, Bash
model: sonnet
max_turns: 20
---

You are a verification agent. Thoroughly validate application functionality after changes.

## Behavior

1. **Identify what changed**: Read git diff or the task description to understand what was modified.
2. **Run tests**: Execute the project's test suite. Report pass/fail with details.
3. **Check the build**: Run the build command. Verify it completes without errors or warnings.
4. **Verify functionality**: For the specific changes made:
   - Check that the intended behavior works
   - Test edge cases (empty input, missing data, error paths)
   - Verify no regressions in related functionality
5. **Report results**: Pass/fail for each check with evidence (command output, file contents).

## Output Format

```
## Verification Report
- Tests: PASS/FAIL (details)
- Build: PASS/FAIL (details)
- Functionality: PASS/FAIL (what was checked)
- Edge cases: PASS/FAIL (what was tested)
```

## Rules
- Do NOT fix issues — only report them. The author fixes.
- Always run actual commands for evidence — never assume tests pass.
- If no test suite exists, note it and focus on build + manual verification.
````

## File: .claude/commands/bug.md
````markdown
---
model: sonnet
argument-hint: "[bug description]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

Investigates and fixes bug: $ARGUMENTS. Use when a defect needs root-cause analysis and a minimal targeted fix.

## Process

### 1. Reproduce
- Identify the exact condition that triggers the bug
- If steps to reproduce are unclear, ask before proceeding
- Locate the relevant code path (use Grep/Glob, read 2-3 files max)

### 2. Root cause
- Trace the execution path to find where behavior diverges from expected
- State the root cause in one sentence before fixing

### 3. Fix
- Make the minimal change that fixes the root cause
- Do NOT refactor surrounding code or add unrelated improvements
- If the fix touches more than 3 files, stop and suggest creating a spec instead

### 4. Verify
Spawn `verify-app` via Agent tool:
> "Verify the bug fix. Run the test suite if available. Run the build if available. Report PASS or FAIL."
- If **FAIL**: report the output and stop. Do NOT proceed to review. Suggest: re-investigate the root cause.
- If **PASS**: continue to Step 5.

### 5. Review
Spawn `code-reviewer` via Agent tool. Pass the changed files and a one-line description of the fix.
- Verdict **PASS** or **CONCERNS**: done, report fix as complete.
- Verdict **FAIL**: flag for manual review, report the issues.

## Rules
- Fix only what is broken. No scope creep.
- If the bug is unclear or cannot be reproduced, ask the user before writing any code.
- If the root cause requires architectural changes, stop and recommend `/spec` instead.
````

## File: .claude/commands/grill.md
````markdown
---
model: opus
mode: plan
allowed-tools: Read, Glob, Grep, Bash
---

Runs an adversarial code review blocking approval until all issues are resolved. Use before merging high-risk changes.

## Step 0: Scope Challenge

Before reading any code, challenge the scope of this review.

1. **Does this already exist?** Run Grep to search for similar functions, patterns, or logic already present in the codebase. If the change duplicates existing code, flag it immediately.
2. **Is this the minimum viable change?** Consider whether a smaller diff would solve the problem equally well.

Present the following three paths using AskUserQuestion:

```
A) Scope reduction — you identify a smaller version of this change and suggest it before proceeding
B) Full adversarial review — continue with the complete grill (all steps below)
C) Compressed review — quick pass, report top 3 issues only, no deep dive
```

Wait for the user's choice before proceeding. If A is chosen, suggest the smaller scope and stop. If C is chosen, skip to the issue list and report only the three most critical findings.

## Process

1. Run `git diff main...HEAD` (or `git diff` if on main) to identify all changes under review.
2. Read every changed file **completely** — not just the diff, the full file for context.
3. **What already exists** — Before flagging any issue, run Grep to find similar functions, patterns, or logic already present in the codebase. Document what was found. Do not flag existing patterns as new problems.
4. Act as a senior engineer who does NOT want to ship this. Challenge everything:
   - **Edge cases**: What happens with empty input, null, zero, max values, concurrent access?
   - **Error handling**: Are all error paths covered? Can errors propagate silently?
   - **Security**: Any injection, auth bypass, data exposure, SSRF, or path traversal?
   - **Race conditions**: Any shared state, async operations without proper synchronization?
   - **Missing validation**: Are inputs validated at system boundaries?
   - **Breaking changes**: Does this break any existing API, behavior, or contract?
   - **Data integrity**: Any risk of data loss, corruption, or inconsistency?
5. List every issue found. For each issue:
   - Severity: CRITICAL / HIGH / MEDIUM
   - File and line number
   - What could go wrong (concrete scenario, not theoretical)
   - Present resolution options in A/B/C format:

     ```
     **Option A** — [approach]: [tradeoff]
     **Option B** — [approach]: [tradeoff]
     **Option C** — [approach]: [tradeoff]
     -> Recommended: Option [X] because [reason]
     ```

   For each CRITICAL or HIGH issue, use AskUserQuestion to let the user choose which option to apply before continuing to the next issue.

6. **NOT reviewed** — At the end of the output, explicitly list what was out of scope for this review. Common exclusions: generated files in `dist/` or `.output/`, `node_modules/`, test fixtures, lock files (`package-lock.json`, `yarn.lock`), binary assets.
7. Verdict: BLOCK (has critical/high issues) or PASS (only medium or no issues).
8. **Self-verification table** — As the final step, double-check every single claim made in this review. Create a markdown table with the following columns:

   | Claim | File:Line | Verified |
   |-------|-----------|----------|
   | [each finding summarized in one line] | [exact file and line] | yes / no / partial |

   Every finding from step 5 must appear in this table. If a claim cannot be verified against an exact file and line, mark it as `no` and remove it from the blocking issues list.

## Rules
- Do NOT approve by default. The bar is: "Would I bet production uptime on this?"
- Do NOT make changes. Only report. The author fixes.
- Read the full file, not just the diff — bugs hide in context.
- Ignore style, formatting, and naming preferences — focus on correctness.
````

## File: .claude/commands/review.md
````markdown
---
model: opus
mode: plan
allowed-tools: Read, Glob, Grep, Bash
---

Reviews uncommitted changes and reports bugs, security issues, and improvements. Use before committing to catch issues.

## Context

- Current branch: `!git rev-parse --abbrev-ref HEAD`
- Unstaged changes: `!git diff`
- Staged changes: `!git diff --staged`
- Branch diff vs main: `!git diff main...HEAD 2>/dev/null`

## Process

1. Analyze all changes shown in Context above. If all diffs are empty, report "No changes found." and stop.
2. For each changed file, read the full file to understand context around the changes.
3. **What already exists** — Before reporting any finding, run one Grep pass across the codebase to check for similar functions, patterns, or logic. If duplicated logic is detected, note it explicitly: "Similar pattern already exists at [file:line] — verify this is intentional and not a copy-paste." Do not flag existing patterns as new problems.
4. Analyze each change for:
   - **Bugs**: Logic errors, off-by-one, null/undefined, race conditions
   - **Security**: Injection, XSS, secrets exposure, OWASP top 10
   - **Performance**: N+1 queries, unnecessary re-renders, memory leaks
   - **Readability**: Unclear names, missing context, overly complex logic
   - **Missing tests**: Changed logic without test coverage
5. Report findings with confidence levels (HIGH / MEDIUM / LOW).
6. Only report HIGH and MEDIUM confidence issues — skip stylistic preferences.

## Rules
- Do NOT make any changes. Only report findings.
- Read the actual code before commenting — never speculate.
- Focus on what matters: bugs and security over style.
- If no issues found, say so clearly.
````

## File: .claude/commands/spec-review.md
````markdown
---
model: opus
mode: plan
argument-hint: "[spec number]"
allowed-tools: Read, Glob, Grep, Bash, AskUserQuestion, Agent
---

Reviews spec $ARGUMENTS and its code changes against acceptance criteria. Use after spec-work to validate and close.

## Process

### 1. Find the spec
If `$ARGUMENTS` is a number (e.g. `011`), open `specs/011-*.md`. If it's a filename, open that directly. If empty, list all specs with status `in-review` in `specs/` and ask which one to review.

### 2. Validate status
The spec's status must be `in-review`. If it's `draft` or `in-progress`, report: "Spec is not ready for review (status: X). Run `/spec-work NNN` first." and stop. If it's `completed`, report: "Spec is already completed." and stop.

### 3. Read the spec
Understand Goal, Steps, Acceptance Criteria, Files to Modify, and Out of Scope. Note which steps and criteria are checked off.

### 4. Inspect code changes
Read the `**Branch**` field from the spec header. Then:

- If a branch exists (not `—`): run `git diff main...BRANCH` to see all changes on that branch
- If no branch: run `git diff` and `git diff --staged` to see uncommitted changes

For each changed file, read the full file to understand context around the changes. **Cap**: Read at most the 5 most significantly changed files in full; for remaining files, review only the diff hunks.

### 5. Review against spec

#### 5a — Spec compliance & acceptance criteria
- Are ALL steps checked off and matching what was described?
- Are acceptance criteria genuinely met (verify against diff, not checkboxes)?
- Was anything built that's listed in "Out of Scope"? Flag scope creep.

#### 5b — Definition of Done
If `.agents/context/CONVENTIONS.md` contains a `## Definition of Done` section, verify the code changes satisfy those global quality gates. Report unmet gates as blocking issues.

#### 5c — Code quality
Spawn `code-reviewer` agent via Agent tool. Pass the full spec content and branch name. Use the agent's verdict (PASS / CONCERNS / FAIL) and issue list as code quality input. Do NOT duplicate its analysis inline.

#### 5d — Quality scoring

Based on evidence from 5a–5c, score 10 metrics (0–100 each):

| # | Metric | What to check |
|---|--------|---------------|
| 1 | **Spec Compliance** | All steps implemented exactly as described? |
| 2 | **Acceptance Criteria** | Every criterion genuinely met (verified, not assumed)? |
| 3 | **Test Coverage** | New functionality has tests; existing tests still pass? |
| 4 | **Requirements Fidelity** | Implementation matches the spec goal — no drift, no gold-plating? |
| 5 | **Code Clarity** | Code is readable, named well, no magic numbers or unexplained logic? |
| 6 | **Error Handling** | Failure paths handled; no silent failures, no unguarded throws? |
| 7 | **Security** | No credentials in code, no unsafe patterns, no exposed internals? |
| 8 | **Scope Adherence** | Nothing built outside the spec; no accidental scope creep? |
| 9 | **No Regressions** | Existing functionality unaffected; no broken imports or side effects? |
| 10 | **Completeness** | No TODOs, no stubs, no placeholder comments left in the diff? |

Display the score table:

```
Quality Score — Spec NNN
─────────────────────────────────────────
 1. Spec Compliance ........... XX
 2. Acceptance Criteria ........ XX
 3. Test Coverage .............. XX
 4. Requirements Fidelity ....... XX
 5. Code Clarity ............... XX
 6. Error Handling .............. XX
 7. Security .................... XX
 8. Scope Adherence ............. XX
 9. No Regressions .............. XX
10. Completeness ................. XX
─────────────────────────────────────────
   Average: XX.X    Minimum: XX
   Threshold: 85 avg / 70 min
```

### 6. Verdict

Present the review findings + quality score, then choose exactly one:

**APPROVED** — All criteria met AND avg ≥ 85 AND no metric < 70 AND code-reviewer PASS or CONCERNS.
1. Status → `completed`, move to `specs/completed/NNN-*.md`
2. Report: "Spec NNN approved. Score: XX.X avg / XX min."

**CHANGES REQUESTED** — code-reviewer FAIL, spec failures, avg < 85, or any metric < 70.
1. Add `## Review Feedback` with failing metrics and concrete fix instructions
2. Status → `in-progress`
3. Report: "Run `/spec-work NNN` to address feedback, then `/spec-review NNN` again."

**REJECTED** — Score < 60 avg or critical security/regression issue.
1. Status → `blocked`, add `## Review Feedback` with rejection reason
2. Report why and suggest next steps.

## Rules
- Do NOT make code changes. Only review and update spec status/feedback.
- Read the actual code before commenting — never speculate.
- Focus on what matters: spec compliance and bugs over style.
- If the diff is empty (no changes found), report this and ask the user to verify.
- Never push to remote or create PRs automatically.
````

## File: .claude/commands/spec-validate.md
````markdown
---
model: sonnet
mode: plan
argument-hint: "[spec number]"
allowed-tools: Read, Glob, Grep, AskUserQuestion
---

Validates spec $ARGUMENTS against 10 quality metrics before execution. Run before `/spec-work` to catch weak specs early.

## Process

### 1. Find the spec
If `$ARGUMENTS` is a number (e.g. `011`), open `specs/011-*.md`. If it's a filename, open that directly. If empty, list all draft specs in `specs/` and ask which to validate.

### 2. Validate status
Only validate specs with `Status: draft`. If `in-progress`, `in-review`, or `completed` → report status and stop.

### 3. Load context
Read `.agents/context/CONVENTIONS.md` if it exists — use it to calibrate expectations for test coverage, code patterns, and integration standards.

### 4. Score the spec

Evaluate each metric from 0–100. Be strict — a spec that doesn't answer the question scores ≤50.

| # | Metric | Question to answer |
|---|--------|--------------------|
| 1 | **Goal Clarity** | Is the one-sentence goal specific, bounded, and measurable? Can you tell when it's done? |
| 2 | **Step Decomposition** | Are steps atomic and each achievable in one focused session? No "implement X" megasteps. |
| 3 | **Dependency Identification** | Are external dependencies (other specs, APIs, libs, env vars) named explicitly? |
| 4 | **Coverage Completeness** | Do the steps collectively cover the entire goal — nothing obviously missing? |
| 5 | **Acceptance Criteria Quality** | Are criteria specific and testable (not vague)? Can each be checked YES/NO? |
| 6 | **Scope Coherence** | Is the scope realistic for a single spec? Not too large, not trivially small? |
| 7 | **Risk & Blockers** | Are known risks, ambiguities, or potential blockers mentioned (in Context or Out of Scope)? |
| 8 | **File Coverage** | Are all files that will realistically change listed in "Files to Modify"? |
| 9 | **Out of Scope Clarity** | Is scope exclusion precise enough to prevent creep during execution? |
| 10 | **Integration Awareness** | Does the spec account for how changes integrate with existing code, tests, or systems? |

### 5. Present results

Display a score table:

```
Spec Validation — NNN: [title]
─────────────────────────────────────────
 1. Goal Clarity ................ XX
 2. Step Decomposition .......... XX
 3. Dependency Identification ... XX
 4. Coverage Completeness ........ XX
 5. Acceptance Criteria Quality .. XX
 6. Scope Coherence .............. XX
 7. Risk & Blockers .............. XX
 8. File Coverage ................ XX
 9. Out of Scope Clarity ......... XX
10. Integration Awareness ........ XX
─────────────────────────────────────────
   Average: XX.X    Minimum: XX
   Threshold: 80 avg / 65 min
   Result: PASS ✓  |  FAIL ✗
```

### 6. Verdict

**PASS** (avg ≥ 80 AND no metric < 65):
- Report: "Spec NNN is ready for execution. Run `/spec-work NNN`."
- No changes to the spec file.

**FAIL** (avg < 80 OR any metric < 65):
- List every metric below threshold with a specific, actionable improvement (1-2 sentences per issue).
- Do NOT make changes to the spec. Let the user revise it.
- Report: "Spec NNN needs improvement before execution. Fix the issues above and re-run `/spec-validate NNN`."

## Rules
- **Read-only** — never modify the spec or any file.
- Score honestly. A spec that passes with weak scores wastes execution compute.
- Only report metrics that actually fail. Don't pad passing specs with warnings.
- This command does NOT block `/spec-work` — it's advisory. But weak specs ship weak code.
````

## File: .claude/commands/techdebt.md
````markdown
---
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

Scans recently changed files for tech debt and fixes safe wins. Use at end of session to clean up before committing.

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

5. **Verify fixes**: Spawn `verify-app` via Agent tool with the prompt:
   > "Run the project's test suite and build command. Report PASS or FAIL with details."
   - If **PASS**: report what was cleaned up and stop.
   - If **FAIL**: read the error output, fix only the regressions caused by the debt cleanup (do not introduce new changes), then re-run verify-app.
   - Retry up to **2 times**. If still failing after 2 retries: revert the last change (`git checkout -- <file>`), report the failure, and stop.

## Rules
- Only scan recently changed files — not the entire codebase.
- Fix only clear, safe wins. Do not refactor working code.
- Do not change public APIs or behavior.
- Report but do not fix anything you're unsure about.
````

## File: .claude/commands/test.md
````markdown
---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Runs the project test suite and fixes failures in source code. Use when tests are failing or before submitting changes.

## Process

1. **Detect test command**: Check `package.json` scripts for `test`, `test:unit`, `vitest`, or `jest`. If none found, check for `vitest.config.*` or `jest.config.*` files.
2. **Run tests**: Execute the detected test command.
3. **If all pass**: Report success and stop.
4. **If failures**: For each failing test:
   - Read the failing test file to understand what it expects
   - Read the source file being tested
   - Fix the **source code** (not the tests) to make tests pass
   - Re-run tests
5. **Repeat** with explicit attempt tracking:
   - **Attempt 1**: Apply fixes, re-run tests. If all pass: report success and stop.
   - **Attempt 2**: If still failing, read new error output, apply further fixes, re-run tests. If all pass: report success and stop.
   - **Attempt 3**: If still failing, apply one final round of fixes, re-run tests. If all pass: report success and stop.
6. If still failing after Attempt 3, report what was tried in each attempt and what remains broken.

## Rules
- Fix source code, not tests (unless the test itself has a clear bug).
- Do not delete or skip failing tests.
- Do not install new dependencies without asking.
- If no test framework is detected, tell the user and stop.
````

## File: .claude/commands/update.md
````markdown
---
name: update
description: Check for ai-setup updates and install from within Claude Code
allowed-tools:
  - Bash
  - AskUserQuestion
  - Read
---

Check for ai-setup updates, show what changed, and install if the user confirms.

## Process

### Step 1: Detect installed version

```bash
jq -r '.version // empty' "${CLAUDE_PROJECT_DIR:-.}/.ai-setup.json" 2>/dev/null || echo ""
```

If no `.ai-setup.json` exists, tell the user ai-setup is not installed in this project and suggest running `npx github:onedot-digital-crew/npx-ai-setup`.

### Step 2: Check latest version

Try npm first, fall back to GitHub API:

```bash
npm view @onedot/ai-setup version 2>/dev/null || curl -fsSL --max-time 5 "https://api.github.com/repos/onedot-digital-crew/npx-ai-setup/releases/latest" 2>/dev/null | jq -r '.tag_name // empty' | sed 's/^v//'
```

If both fail, tell the user to check their network connection.

### Step 3: Compare versions

Parse both versions as semver (major.minor.patch). Only proceed if latest > installed.

- If **same version**: "Already up to date (vX.Y.Z)." — stop.
- If **installed > latest**: "You're ahead of the latest release (dev version?)." — stop.
- If **latest > installed**: continue to step 4.

### Step 4: Fetch changelog

```bash
curl -fsSL --max-time 5 "https://raw.githubusercontent.com/onedot-digital-crew/npx-ai-setup/main/CHANGELOG.md" 2>/dev/null | head -80
```

Extract entries between installed and latest version. If no CHANGELOG.md exists, skip this step.

### Step 5: Show update summary and confirm
Show:
```
## ai-setup Update Available

**Installed:** vX.Y.Z
**Latest:**    vA.B.C

### What's New
(changelog entries if available)

Will review customized templates, optionally regenerate AI context, and back up modified files.
```
Use AskUserQuestion: "Proceed with update?" Options: "Yes, update now" / "No, cancel"
If user cancels, stop.

### Step 6: Run update

```bash
npx github:onedot-digital-crew/npx-ai-setup
```

This launches the interactive update flow.

### Step 7: Clear update cache

```bash
rm -f /tmp/ai-setup-update-*.txt /tmp/ai-setup-cli-latest-version.txt
```

### Step 8: Display result
```
ai-setup updated: vX.Y.Z -> vA.B.C
Restart Claude Code to pick up new hooks and settings.
```
````

## File: .claude/hooks/circuit-breaker.sh
````bash
#!/bin/bash
# Circuit Breaker: Detects when Claude is going in circles
# Tracks edit frequency per file. Warns at 5x, blocks at 8x within 10 min.
# Dead-loop protection: BLOCK message explicitly forbids retry attempts.
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

PROJ_HASH=$(echo "$PWD" | shasum | cut -c1-8)
LOG="/tmp/claude-cb-${PROJ_HASH}.log"
NOW=$(date +%s)
WINDOW=600
WARN=5
BLOCK=8

echo "$NOW $FILE_PATH" >> "$LOG"

CUTOFF=$((NOW - WINDOW))
awk -v c="$CUTOFF" '$1 >= c' "$LOG" > "${LOG}.tmp" 2>/dev/null && mv "${LOG}.tmp" "$LOG"

COUNT=$(grep -cF "$FILE_PATH" "$LOG" 2>/dev/null || echo 0)

if [ "$COUNT" -ge "$BLOCK" ]; then
  echo "⛔ CIRCUIT BREAKER TRIGGERED — Edit blocked." >&2
  echo "" >&2
  echo "File    : ${FILE_PATH}" >&2
  echo "Edits   : ${COUNT}x in the last 10 minutes" >&2
  echo "" >&2

  # Show recent edit timestamps so Claude understands the pattern
  echo "Recent edit history (last 10):" >&2
  grep -F "$FILE_PATH" "$LOG" | tail -10 | while read -r ts _; do
    DELTA=$(( NOW - ts ))
    echo "  — ${DELTA}s ago" >&2
  done
  echo "" >&2

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
  echo "STOP. DO NOT attempt another edit to this file." >&2
  echo "DO NOT retry the same approach." >&2
  echo "DO NOT spawn a sub-agent that edits files." >&2
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
  echo "" >&2
  echo "Required action:" >&2
  echo "  1. STOP all edit attempts immediately." >&2
  echo "  2. Summarize to the user: what were you trying to fix?" >&2
  echo "  3. Describe what approach you tried and why it failed." >&2
  echo "  4. Ask the user for a different strategy or guidance." >&2
  echo "" >&2
  echo "If you need to diagnose a build failure, you may spawn a" >&2
  echo "READ-ONLY Haiku sub-agent (no Write/Edit tools) to analyze" >&2
  echo "the error — but do NOT have it edit any files." >&2
  echo "" >&2
  echo "(Circuit breaker resets when the user sends the next message)" >&2
  exit 2
fi

if [ "$COUNT" -ge "$WARN" ]; then
  echo "⚠️  CIRCUIT BREAKER WARNING — Stop and reassess now." >&2
  echo "" >&2
  echo "File    : ${FILE_PATH}" >&2
  echo "Edits   : ${COUNT}x in the last 10 minutes (blocks at ${BLOCK})" >&2
  echo "" >&2
  echo "DO NOT edit this file again until a different approach is chosen." >&2
  echo "DO NOT retry the same fix on the same file." >&2
  echo "If diagnosis is needed, use a read-only Haiku agent first." >&2
fi

exit 0
````

## File: .claude/hooks/config-change-audit.sh
````bash
#!/bin/bash
# config-change-audit.sh — ConfigChange hook
# Logs config mutations and blocks unsafe settings in user/project/local scopes.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // empty' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"
printf '%s CONFIG_CHANGE source=%s file=%s\n' \
  "$(date -u +%FT%TZ)" "$SOURCE" "${FILE_PATH:-n/a}" >> "$LOG_DIR/config-changes.log"

# policy_settings cannot be blocked by Claude Code; keep this as audit-only.
[ "$SOURCE" = "policy_settings" ] && exit 0

# Security/compliance guardrails for mutable settings files.
if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
  if jq -e '.disableAllHooks == true' "$FILE_PATH" >/dev/null 2>&1; then
    echo "Blocked config change: disableAllHooks=true is not allowed in this setup." >&2
    exit 2
  fi

  if jq -e '.permissions.allow[]? | select(. == "Bash(*)")' "$FILE_PATH" >/dev/null 2>&1; then
    echo "Blocked config change: wildcard Bash(*) permission is not allowed." >&2
    exit 2
  fi
fi

exit 0
````

## File: .claude/hooks/context-monitor.sh
````bash
#!/bin/bash
# context-monitor.sh — PostToolUse hook
# Warns when context window is approaching exhaustion by reading bridge file
# written by statusline.sh on every render.
#
# Outputs additionalContext JSON at <=35% remaining (WARNING) and <=25% (CRITICAL).
# Debounces via a counter file — 5 tool calls between warnings at same severity.
# Severity escalation (WARNING -> CRITICAL) bypasses debounce.
# Silent exit 0 when bridge file missing, stale (>60s), or jq unavailable.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""' 2>/dev/null)
SESSION_ID=$(echo "$SESSION_ID" | tr -cd 'a-zA-Z0-9_-')
[ -z "$SESSION_ID" ] && exit 0

BRIDGE_FILE="/tmp/claude-ctx-${SESSION_ID}.json"
[ -f "$BRIDGE_FILE" ] || exit 0

# Read bridge file
BRIDGE=$(cat "$BRIDGE_FILE" 2>/dev/null) || exit 0
[ -z "$BRIDGE" ] && exit 0

# Check staleness (>60s old = ignore)
TS=$(echo "$BRIDGE" | jq -r '.timestamp // 0' 2>/dev/null)
case "$TS" in ''|null|*[!0-9]*) TS=0 ;; esac
NOW=$(date +%s)
AGE=$(( NOW - TS ))
[ "$AGE" -gt 60 ] && exit 0

REMAINING=$(echo "$BRIDGE" | jq -r '.remaining_percentage // 100' 2>/dev/null)
case "$REMAINING" in ''|null|*[!0-9]*) exit 0 ;; esac

# Determine severity
SEVERITY=""
if [ "$REMAINING" -le 25 ]; then
  SEVERITY="CRITICAL"
elif [ "$REMAINING" -le 35 ]; then
  SEVERITY="WARNING"
fi

[ -z "$SEVERITY" ] && exit 0

# Debounce: track call counter and last severity
COUNTER_FILE="/tmp/claude-ctx-warn-${SESSION_ID}"
COUNTER=0
LAST_SEVERITY=""
if [ -f "$COUNTER_FILE" ]; then
  COUNTER=$(head -1 "$COUNTER_FILE" 2>/dev/null || echo 0)
  LAST_SEVERITY=$(tail -1 "$COUNTER_FILE" 2>/dev/null || echo "")
  case "$COUNTER" in ''|null|*[!0-9]*) COUNTER=0 ;; esac
fi

COUNTER=$(( COUNTER + 1 ))

# Bypass debounce on severity escalation (WARNING -> CRITICAL)
ESCALATED=false
if [ "$SEVERITY" = "CRITICAL" ] && [ "$LAST_SEVERITY" = "WARNING" ]; then
  ESCALATED=true
fi

# Suppress if under debounce threshold (5 calls between warnings) and no escalation
if [ "$COUNTER" -lt 6 ] && [ "$ESCALATED" = "false" ] && [ "$LAST_SEVERITY" = "$SEVERITY" ]; then
  printf '%s\n%s\n' "$COUNTER" "$SEVERITY" > "$COUNTER_FILE" 2>/dev/null || true
  exit 0
fi

# Reset counter and write state
printf '%s\n%s\n' "0" "$SEVERITY" > "$COUNTER_FILE" 2>/dev/null || true

# Build message
if [ "$SEVERITY" = "CRITICAL" ]; then
  MESSAGE="CRITICAL: Context window at ${REMAINING}% remaining. Compaction is imminent. Consider saving state to HANDOFF.md. Wrapping up should begin before context is truncated."
else
  MESSAGE="WARNING: Context window at ${REMAINING}% remaining. Context compaction will fire at 30%. Consider saving state to HANDOFF.md soon."
fi

# Output additionalContext JSON to stdout (via jq for safe escaping)
jq -n --arg msg "$MESSAGE" '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":$msg}}'

exit 0
````

## File: .claude/hooks/mcp-health.sh
````bash
#!/bin/bash
# mcp-health.sh — SessionStart hook
# Validates .mcp.json on session start: JSON syntax, required fields per server type,
# and existence of base commands for stdio servers.
# Silent on success. Outputs warnings to stderr (shown as system messages in Claude's turn).
# Max runtime: 5s. Exits 0 always — warnings are informational only.

MCP_FILE="${CLAUDE_PROJECT_DIR:-.}/.mcp.json"
[ ! -f "$MCP_FILE" ] && exit 0

# Require jq
if ! command -v jq > /dev/null 2>&1; then
  echo "[MCP HEALTH] jq not found — skipping .mcp.json validation" >&2
  exit 0
fi

# Validate JSON syntax
if ! jq empty "$MCP_FILE" 2>/dev/null; then
  echo "[MCP HEALTH] .mcp.json has invalid JSON syntax — fix before MCP servers will load" >&2
  exit 0
fi

# Iterate over servers
WARNINGS=""

while IFS= read -r server_name; do
  [ -z "$server_name" ] && continue

  TYPE=$(jq -r --arg s "$server_name" '.mcpServers[$s].type // "stdio"' "$MCP_FILE" 2>/dev/null)

  case "$TYPE" in
    http|sse)
      URL=$(jq -r --arg s "$server_name" '.mcpServers[$s].url // empty' "$MCP_FILE" 2>/dev/null)
      if [ -z "$URL" ]; then
        WARNINGS="${WARNINGS}  - $server_name (${TYPE}): missing required field 'url'\n"
      fi
      ;;
    stdio|*)
      CMD=$(jq -r --arg s "$server_name" '.mcpServers[$s].command // empty' "$MCP_FILE" 2>/dev/null)
      if [ -z "$CMD" ]; then
        WARNINGS="${WARNINGS}  - $server_name (stdio): missing required field 'command'\n"
      else
        # Check that the base executable exists
        BASE_CMD=$(echo "$CMD" | awk '{print $1}')
        if ! command -v "$BASE_CMD" > /dev/null 2>&1; then
          WARNINGS="${WARNINGS}  - $server_name (stdio): command not found: $BASE_CMD\n"
        fi
      fi
      ;;
  esac
done < <(jq -r '.mcpServers | keys[]' "$MCP_FILE" 2>/dev/null)

if [ -n "$WARNINGS" ]; then
  printf "[MCP HEALTH] .mcp.json issues detected:\n%b" "$WARNINGS" >&2
fi

exit 0
````

## File: .claude/hooks/post-tool-failure-log.sh
````bash
#!/bin/bash
# post-tool-failure-log.sh — PostToolUseFailure hook
# Appends a compact one-line failure record to .claude/tool-failures.log.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null)
ERR=$(echo "$INPUT" | jq -r '.error // "unknown error"' 2>/dev/null)
INTERRUPT=$(echo "$INPUT" | jq -r '.is_interrupt // false' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"

ERR_ONELINE=$(printf '%s' "$ERR" \
  | tr '\r\n' '  ' \
  | sed 's/[[:space:]]\+/ /g' \
  | cut -c1-400)

printf '%s TOOL_FAIL tool=%s interrupt=%s error=%s\n' \
  "$(date -u +%FT%TZ)" "$TOOL" "$INTERRUPT" "$ERR_ONELINE" >> "$LOG_DIR/tool-failures.log"

exit 0
````

## File: .claude/hooks/protect-files.sh
````bash
#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED=(".env" "package-lock.json" "pnpm-lock.yaml" "yarn.lock" "bun.lockb" "composer.lock" ".git/")

for pattern in "${PROTECTED[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH is protected ('$pattern')" >&2
    exit 2
  fi
done

# Block direct edits to assets/ in Vite-based projects (build output)
if [[ "$FILE_PATH" == */assets/* ]]; then
  for cfg in vite.config.js vite.config.ts vite.config.mjs vite.config.mts; do
    if [ -f "$cfg" ]; then
      echo "Blocked: $FILE_PATH is in assets/ (build output — edit src/ instead)" >&2
      exit 2
    fi
  done
fi

exit 0
````

## File: .claude/hooks/README.md
````markdown
# Hook Configuration Guide

See `AGENTS.md` for the full active-hook inventory and customization overview.
Hook scripts use these exit codes: `0` = pass, `1` = fail with feedback, `2` = blocked

## Dead-Loop Prevention Notes

- `circuit-breaker.sh` warning output is intentionally strict even on `exit 0`, so the model is told not to keep editing the same file before the hard block triggers.
- `context-monitor.sh` uses advisory wording only. It should suggest saving state and wrapping up, but it must not issue imperative workflow commands that can trigger unnecessary tool calls.
- `post-edit-lint.sh` suppresses normal formatter/linter output to avoid fix-loop prompts from non-fatal lint noise.

## Debugging

```bash
# Test a hook manually
echo '{"tool_input":{"file_path":"test.js"}}' | ./.claude/hooks/protect-files.sh
echo $?  # 0 = allowed, 2 = blocked

# View/clear circuit breaker log
cat /tmp/claude-cb-*.log
rm /tmp/claude-cb-*.log
```

## Disabling Hooks

Remove the hook block from `.claude/settings.json`, or add `exit 0` at the top of the script.
````

## File: .claude/hooks/task-completed-gate.sh
````bash
#!/bin/bash
# task-completed-gate.sh — TaskCompleted hook
# Prevents clearly incomplete task closures and logs task completion attempts.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
TASK_ID=$(echo "$INPUT" | jq -r '.task_id // "unknown"' 2>/dev/null)
TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task_subject // ""' 2>/dev/null)
TASK_DESCRIPTION=$(echo "$INPUT" | jq -r '.task_description // ""' 2>/dev/null)
TEAMMATE_NAME=$(echo "$INPUT" | jq -r '.teammate_name // "n/a"' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"
printf '%s TASK_COMPLETED id=%s teammate=%s subject=%s\n' \
  "$(date -u +%FT%TZ)" "$TASK_ID" "$TEAMMATE_NAME" "$(printf '%s' "$TASK_SUBJECT" | tr '\r\n' '  ' | sed 's/[[:space:]]\+/ /g' | cut -c1-200)" \
  >> "$LOG_DIR/task-completed.log"

# Block obviously unfinished placeholders in task metadata.
if printf '%s\n%s' "$TASK_SUBJECT" "$TASK_DESCRIPTION" | grep -qiE '\b(TODO|TBD|WIP)\b'; then
  echo "Task completion blocked: task still contains TODO/TBD/WIP markers." >&2
  exit 2
fi

# Block unresolved merge conflict markers in tracked files.
if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
  if git grep -n -E '^(<<<<<<<|=======|>>>>>>>)' -- . >/dev/null 2>&1; then
    echo "Task completion blocked: unresolved merge conflict markers found." >&2
    exit 2
  fi
fi

exit 0
````

## File: .claude/rules/agents.md
````markdown
# Agent Delegation Rules

Use agents for focused, isolated work. Call them directly — do not ask the user first.

## When to Delegate

| Agent | Trigger | Model |
|-------|---------|-------|
| build-validator | After code changes, before marking work done | haiku |
| code-reviewer | After completing a spec or feature branch | sonnet |
| code-architect | Before implementing high-complexity specs or multi-system changes | opus |
| context-refresher | When stack, architecture, or conventions have changed | haiku |
| perf-reviewer | After changes to hot paths, loops, data fetching, or bundle-affecting code | sonnet |
| staff-reviewer | Final review before merging significant changes | opus |
| test-generator | After adding new functions or modules that lack test coverage | sonnet |
| verify-app | After spec completion to validate tests, build, and functionality | sonnet |
| liquid-linter | After editing Liquid templates in Shopify projects | haiku |

## When NOT to Delegate

- Single-file reads or searches — use Read/Glob/Grep directly
- Trivial fixes (typos, config tweaks) — faster to do inline
- Tasks requiring fewer than 3 tool calls — agent startup overhead exceeds the work
- Follow-up edits after a review — apply fixes yourself, do not re-delegate

## Scope Limits

- Agents report findings — they do not fix issues unless their description says otherwise
- `test-generator` writes tests only; it does not modify source code
- `code-architect` and `staff-reviewer` run in plan mode — they cannot edit files
- `build-validator` runs commands but does not write code
````

## File: .claude/rules/general.md
````markdown
# General Coding Rules

## Read Before Modify
Always read a file before modifying it. Never assume contents from memory or prior context.
After context compaction, re-read files before continuing work — do not assume what was already done.

## Check Before Creating
Before creating a new file, check if one already exists:
- Run `ls` or Glob to find existing files matching the concept
- Run `git ls-files` to see tracked files that may not be visible

## Verify, Don't Guess
Never assume import paths, function names, or API routes. Verify by reading the relevant file.
When unsure about current state, run `git diff` to see what has actually changed this session.

## Subagent Model Routing
When spawning subagents via the Agent tool, always set the model parameter:
- `model: haiku` — Explore agents, file search, codebase questions, simple research
- `model: sonnet` — Implementation, code generation, test writing
- `model: opus` — Architecture review, complex analysis, spec creation
Never spawn Explore or search agents without `model: haiku`.

## Human Approval Gates
Before finalizing any deliverable, present a summary and ask for confirmation.
Never proceed to the next workflow phase without explicit user approval.
````

## File: .claude/rules/git.md
````markdown
# Git Rules

## Commit Message Format
Use Conventional Commits: `type(scope): description`
Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `perf`, `ci`
Examples:
- `feat(auth): add OAuth2 login flow`
- `fix(cart): prevent negative quantity on decrement`
- `chore: update dependencies`

Keep the subject line under 72 characters.
Use the body to explain *why*, not *what* — the diff shows what changed.

## Branch Naming
Feature branches: `feat/short-description`
Bug fixes: `fix/short-description`
Spec branches: `spec/NNN-description`
Chore/tooling: `chore/short-description`

## Safety Rules
Never force-push to `main` or `master`.
Never use `--no-verify` to skip hooks — fix the underlying issue instead.
Never use `--no-gpg-sign` unless explicitly requested by the user.
Never `git reset --hard` without confirming with the user first.

## Commit Hygiene
One logical change per commit — do not bundle unrelated changes.
Stage specific files rather than `git add -A` to avoid committing secrets or generated artifacts.
Always review `git diff --staged` before committing.
````

## File: .claude/rules/testing.md
````markdown
# Testing Rules

## Test First
Write tests before or alongside implementation — never after the fact as an afterthought.
When fixing a bug, write a failing test that reproduces it first, then fix the code.

## Assertion Expectations
Assert the specific value, not just that something is truthy.
Prefer `expect(result).toBe(42)` over `expect(result).toBeTruthy()`.
Include the expected value in assertion messages to aid debugging.

## Edge Case Coverage
Every function must cover: empty input, null/undefined, boundary values, and error paths.
Do not only test the happy path — edge cases are where bugs live.

## No Mocks by Default
Prefer real implementations over mocks.
Only mock: network calls, external services, file system side effects, and time-dependent behavior.
When mocking, document why a real implementation could not be used.

## Isolation
Each test must be fully independent — no shared mutable state between tests.
Reset all side effects in `afterEach` / `teardown` blocks.
Tests must pass in any order and when run in isolation.

## Test Naming
Use descriptive names that explain the scenario and expected outcome:
`it("returns null when the user ID does not exist")` not `it("works correctly")`.
````

## File: .github/copilot-instructions.md
````markdown
# Copilot Instructions

This project uses **Claude Code** as the primary AI assistant.
All coding rules are in `CLAUDE.md`.

## Context
- **MUST READ**: `.agents/context/` for technical documentation (ARCHITECTURE.md, CONVENTIONS.md, STACK.md)
- **MUST READ**: `CLAUDE.md` for project rules and critical coding standards
````

## File: lib/_loader.sh
````bash
#!/bin/bash
# Module loader for ai-setup
# Requires: SCRIPT_DIR must be set by the caller before sourcing this file.

LIB_DIR="$SCRIPT_DIR/lib"

source_lib() {
  local module="$1"
  if [ ! -f "$LIB_DIR/$module" ]; then
    echo "FATAL: Missing lib/$module" >&2
    exit 1
  fi
  source "$LIB_DIR/$module"
}
````

## File: lib/process.sh
````bash
#!/bin/bash
# Process management: kill_tree, progress_bar, wait_parallel

# Kill process + all child processes (Claude spawns sub-agents)
kill_tree() {
  local pid=$1
  pkill -P "$pid" 2>/dev/null || true
  kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
}

# Progress bar for a single process
# Usage: progress_bar <pid> <label> [est_seconds] [max_seconds]
progress_bar() {
  local pid=$1 label=$2 est=${3:-120} max=${4:-600}
  local width=30 elapsed=0
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$elapsed" -ge "$max" ]; then
      kill_tree "$pid"
      printf "\r  ⚠️  %s cancelled after %ds (timeout)%*s\n" "$label" "$elapsed" 20 ""
      return 0
    fi
    local pct=$((elapsed * 100 / est))
    [ "$pct" -gt 95 ] && pct=95
    local filled=$((pct * width / 100))
    local empty=$((width - filled))
    local bar=$(printf '█%.0s' $(seq 1 $filled 2>/dev/null) ; printf '░%.0s' $(seq 1 $empty 2>/dev/null))
    printf "\r  %s %s [%s] %d%% (%ds)" "⏳" "$label" "$bar" "$pct" "$elapsed"
    sleep 1
    elapsed=$((elapsed + 1))
  done
  local bar=$(printf '█%.0s' $(seq 1 $width))
  printf "\r  ✅ %s [%s] 100%% (%ds)\n" "$label" "$bar" "$elapsed"
}

# Parallel progress bars for multiple processes
# Usage: wait_parallel "PID:Label:Est:Max" "PID:Label:Est:Max" ...
wait_parallel() {
  local specs=("$@")
  local count=${#specs[@]}
  local width=30

  # Parse specs
  local pids=() labels=() ests=() maxes=() done_at=()
  for spec in "${specs[@]}"; do
    IFS=: read -r pid label est max <<< "$spec"
    pids+=("$pid")
    labels+=("$label")
    ests+=("$est")
    maxes+=("$max")
    done_at+=(0)
  done

  # Reserve lines
  for ((i=0; i<count; i++)); do echo ""; done

  local elapsed=0

  while true; do
    local running=0
    # Move cursor up to overwrite
    printf "\033[${count}A"

    for ((i=0; i<count; i++)); do
      local pid=${pids[$i]}
      local label=${labels[$i]}
      local est=${ests[$i]}
      local max=${maxes[$i]}

      if [ "${done_at[$i]}" -gt 0 ]; then
        # Already finished
        local bar=$(printf '█%.0s' $(seq 1 $width))
        printf "\r  ✅ %-25s [%s] 100%% (%ds)%*s\n" "$label" "$bar" "${done_at[$i]}" 5 ""
      elif ! kill -0 "$pid" 2>/dev/null; then
        # Just finished
        done_at[$i]=$((elapsed > 0 ? elapsed : 1))
        local bar=$(printf '█%.0s' $(seq 1 $width))
        printf "\r  ✅ %-25s [%s] 100%% (%ds)%*s\n" "$label" "$bar" "$elapsed" 5 ""
      elif [ "$elapsed" -ge "$max" ]; then
        # Timeout
        kill_tree "$pid"
        done_at[$i]=$elapsed
        printf "\r  ⚠️  %-25s cancelled after %ds (timeout)%*s\n" "$label" "$elapsed" 10 ""
      else
        # Still running
        running=$((running + 1))
        local pct=$((elapsed * 100 / est))
        [ "$pct" -gt 95 ] && pct=95
        local filled=$((pct * width / 100))
        local empty=$((width - filled))
        local bar=$(printf '█%.0s' $(seq 1 $filled 2>/dev/null) ; printf '░%.0s' $(seq 1 $empty 2>/dev/null))
        printf "\r  ⏳ %-25s [%s] %d%% (%ds)%*s\n" "$label" "$bar" "$pct" "$elapsed" 5 ""
      fi
    done

    [ "$running" -eq 0 ] && break
    sleep 1
    elapsed=$((elapsed + 1))
  done
}
````

## File: specs/completed/.gitkeep
````

````

## File: specs/completed/001-prescriptive-context-reading.md
````markdown
# Spec: Prescriptive context reading and stuck instruction

> **Spec ID**: 001 | **Created**: 2026-02-17 | **Status**: completed

## Goal
Make CLAUDE.md template actively instruct Claude to read context files before complex tasks, and add a soft "stuck" detection instruction.

## Context
Current "Project Documentation" section passively lists files. Lean+ research shows prescriptive instructions ("MUST read before...") significantly improve context utilization. Also: circuit breaker fires at 5 edits, but a soft instruction at 3 catches issues earlier.

## Steps
- [x] Rename "## Project Documentation" to "## Project Context (read before complex tasks)" in `templates/CLAUDE.md`
- [x] Change passive list to prescriptive: "Before multi-file changes or new features, read `.agents/context/`:"
- [x] Reorder to STACK → ARCHITECTURE → CONVENTIONS with enhanced descriptions
- [x] Add "If you edit the same file 3+ times without progress, stop and ask for guidance." to Communication Protocol

## Acceptance Criteria
- [x] CLAUDE.md template has prescriptive "read before" instruction
- [x] "Stuck" instruction present in Communication Protocol
- [x] Section references match what STACK.md and CONVENTIONS.md will generate

## Files to Modify
- `templates/CLAUDE.md` — rewrite sections

## Out of Scope
- Changes to generation prompts (separate spec)
````

## File: specs/completed/002-enhanced-generation-prompts.md
````markdown
# Spec: Enhanced generation prompts for STACK.md, CONVENTIONS.md, and Critical Rules

> **Spec ID**: 002 | **Created**: 2026-02-17 | **Status**: completed

## Goal
Improve the auto-generation prompts so STACK.md includes an "Avoid" section, CONVENTIONS.md covers testing and deeper error handling, and Critical Rules generation follows specific categories.

## Context
Lean+ research shows that "DO NOT USE" lists prevent wrong library suggestions (e.g., axios when project uses custom apiClient). Testing conventions and error handling depth are currently missing from CONVENTIONS.md generation. Critical Rules prompt is too vague, producing generic output.

## Steps
- [x] Add "Avoid" bullet to STACK.md generation prompt in `bin/ai-setup.sh` (~line 489)
- [x] Expand "Error handling patterns" bullet in CONVENTIONS.md prompt with specifics (try-catch, error boundaries, API errors, logging)
- [x] Add "Testing patterns" bullet to CONVENTIONS.md prompt (test location, naming, framework, what is tested)
- [x] Expand Critical Rules prompt with specific categories (code style, TypeScript, imports, framework, testing)
- [x] Add "Omit categories where no evidence exists" guard to prevent fabrication

## Acceptance Criteria
- [x] STACK.md prompt includes "Avoid" instruction with examples
- [x] CONVENTIONS.md prompt has 6 bullets (was 5) including testing
- [x] Critical Rules prompt lists 5 category hints
- [x] `bash -n bin/ai-setup.sh` passes

## Files to Modify
- `bin/ai-setup.sh` — 3 prompt sections

## Out of Scope
- ARCHITECTURE.md prompt changes
- Changing the generation model or max-turns
````

## File: specs/completed/003-spec-work-context-reading.md
````markdown
# Spec: Add context reading step to spec-work command

> **Spec ID**: 003 | **Created**: 2026-02-17 | **Status**: completed

## Goal
Ensure Sonnet reads project conventions and stack before executing spec steps, so generated code matches project patterns.

## Context
Currently spec-work.md goes straight from reading the spec to executing steps. Sonnet has no awareness of project conventions unless it happens to read them. Adding a context reading step ensures consistent code quality.

## Steps
- [x] Add step 3 "Read project context" after "Read the spec" in `templates/commands/spec-work.md`
- [x] Instruction: "Skim `.agents/context/CONVENTIONS.md` and `.agents/context/STACK.md` to follow project patterns and use correct libraries."
- [x] Renumber subsequent steps (3→4, 4→5, 5→6)

## Acceptance Criteria
- [x] spec-work.md has 6 process steps (was 5)
- [x] Context reading step references CONVENTIONS.md and STACK.md
- [x] Step numbering is sequential and correct

## Files to Modify
- `templates/commands/spec-work.md` — add step + renumber

## Out of Scope
- Changes to spec.md (creation command)
- Changes to the spec template
````

## File: specs/completed/004-token-efficiency-optimization.md
````markdown
# Spec: Token Efficiency Optimization

> **Spec ID**: 004 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Reduce per-setup token footprint by ~400 tokens through removing duplication in generation prompts and CLAUDE.md template comments.

## Context
Direct file inspection confirmed 4 real optimization areas. Generation prompts in ai-setup.sh repeat "Do NOT read any files" twice per prompt (L471+L483, L493+L526). The CLAUDE.md template has 18 lines of HTML placeholder comments (L14-32) that Claude reads every session but never uses. The skill curator prompt has an example response (L768-770) that duplicates the already-stated format. Settings.json granular rules are intentional (security), not waste.

## Steps
- [x] Step 1: `bin/ai-setup.sh` L483 — remove duplicate "Do NOT read any files" line from prompt 1 (already stated on L471)
- [x] Step 2: `bin/ai-setup.sh` L526 — remove duplicate "Do NOT read any files" line from prompt 2 (already stated on L493)
- [x] Step 3: `bin/ai-setup.sh` L497-521 — compress 3×8 bullet-point file descriptions to 3 single-line descriptions (~180 tokens saved)
- [x] Step 4: `bin/ai-setup.sh` L768-770 — remove example response from skill curator prompt (format already stated on L766-767)
- [x] Step 5: `templates/CLAUDE.md` L14-21 — replace 8-line `<!-- Auto-Init will populate... -->` comment block with single line `<!-- Auto-Init populates this -->`
- [x] Step 6: `templates/CLAUDE.md` L23-32 — replace 10-line Critical Rules comment block with single line `<!-- Auto-Init populates this -->`
- [x] Step 7: Run `bash -n bin/ai-setup.sh` to verify syntax

## Acceptance Criteria
- [x] Each generation prompt has "Do NOT read" only once
- [x] Context file descriptions compressed without losing semantic content
- [x] CLAUDE.md template HTML comments are single-line stubs
- [x] `bash -n bin/ai-setup.sh` passes clean

## Files to Modify
- `bin/ai-setup.sh` — remove prompt duplicates, compress descriptions
- `templates/CLAUDE.md` — compress HTML comment blocks

## Out of Scope
- settings.json rule consolidation (security-by-design, not waste)
- Agent template restructuring
- Command template changes (commit.md, pr.md already lean at 22/24 lines)
````

## File: specs/completed/005-prompt-cache-aware-design.md
````markdown
# Spec: Prompt Cache-Aware Template Design

> **Spec ID**: 005 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Document prompt caching best practices in generated templates so target projects benefit from Claude Code's caching architecture.

## Context
Lance Martin's writeup on Claude Code's caching strategy reveals that CLAUDE.md, context files, and `<system-reminder>` hooks map directly to Claude's caching tiers. Our templates already follow these patterns accidentally — we should make them intentional and documented so devs understand the "why" and don't accidentally break the cache.

## Steps
- [x] Step 1: Add `## Prompt Cache Strategy` section to `templates/CLAUDE.md` explaining the 4 tiers
- [x] Step 2: Add inline comment to context-freshness hook explaining `<system-reminder>` preserves cache vs. system prompt edits
- [x] Step 3: Add comment to `templates/claude/settings.json` noting tool order should stay stable across sessions
- [x] Step 4: Update `bin/ai-setup.sh` Auto-Init prompt to mention static-first ordering when writing CLAUDE.md sections

## Acceptance Criteria
- [x] `templates/CLAUDE.md` explains caching tiers: system prompt → CLAUDE.md → session context → messages
- [x] context-freshness hook has comment explaining why `<system-reminder>` is cache-safe
- [x] Devs reading the generated CLAUDE.md understand why they shouldn't edit static sections mid-session

## Files to Modify
- `templates/CLAUDE.md` — add caching section (~8 lines)
- `templates/claude/hooks/context-freshness.sh` — add 1-2 comment lines
- `bin/ai-setup.sh` — minor prompt tweak in Auto-Init section

## Out of Scope
- Adding `cache_control` to Claude API calls (we use CLI, not API)
- Compaction implementation (handled by Claude Code itself)
- Tool defer_loading pattern (Claude Code internal, not exposed via CLI)
````

## File: specs/completed/006-project-documentation.md
````markdown
# Spec: Add Project Concept Documentation

> **Spec ID**: 006 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Create a `docs/` directory with conceptual documentation explaining the project idea, philosophy, and architecture.

## Context
The README serves as an NPM package reference (installation, usage, features). What's missing is higher-level documentation: why this project exists, what problem it solves, the design philosophy behind decisions (template-based vs generative, AI curation, hook-based safety). This helps contributors and users understand the thinking behind the tool.

## Steps
- [x] Step 1: Create `docs/` directory
- [x] Step 2: Create `docs/CONCEPT.md` — project vision, problem statement, design philosophy (why one command, why templates over generation, why AI curation)
- [x] Step 3: Create `docs/ARCHITECTURE.md` — how the system works end-to-end (setup flow, Auto-Init pipeline, template system, hook system, skill curation)
- [x] Step 4: Create `docs/DESIGN-DECISIONS.md` — key decisions with rationale (POSIX shell, no build step, cksum over md5, granular permissions, Haiku for curation)
- [x] Step 5: Add a `## Documentation` section to README.md linking to docs/

## Acceptance Criteria
- [x] `docs/` contains 3 markdown files covering concept, architecture, and design decisions
- [x] Each doc is self-contained and readable without the README
- [x] README links to the docs directory
- [x] All content in English

## Files to Modify
- `docs/CONCEPT.md` — new file
- `docs/ARCHITECTURE.md` — new file
- `docs/DESIGN-DECISIONS.md` — new file
- `README.md` — add docs link section

## Out of Scope
- API reference or code-level documentation
- Tutorials or getting-started guides
- Translating docs to other languages
````

## File: specs/completed/007-auto-changelog.md
````markdown
# Spec: Auto-Updated CHANGELOG.md on Spec Completion

> **Spec ID**: 007 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Create a CHANGELOG.md that automatically updates with date and changes whenever a spec is completed via `/spec-work`.

## Context
There is no changelog tracking completed specs and their changes. Adding an automatic update step to the `/spec-work` command ensures every completed spec produces a changelog entry without manual effort. The changelog groups entries by date.

## Steps
- [x] Step 1: Create `CHANGELOG.md` in project root with initial structure (header, format description)
- [x] Step 2: Add changelog update step to `templates/commands/spec-work.md` between "verify acceptance criteria" and "complete the spec" — prepend entry under today's date heading with spec title and summary of changes
- [x] Step 3: Also add the same changelog step to the project's own `.claude/commands/spec-work.md` so it takes effect immediately
- [x] Step 4: Validate by dry-reading the updated spec-work template to confirm the instruction flow is correct

## Acceptance Criteria
- [x] `CHANGELOG.md` exists in project root with a clear format
- [x] `templates/commands/spec-work.md` includes an automatic changelog update step
- [x] `.claude/commands/spec-work.md` also includes the changelog update step
- [x] Changelog entries are grouped by date with spec title and change summary

## Files to Modify
- `CHANGELOG.md` — create with initial structure
- `templates/commands/spec-work.md` — add changelog step
- `.claude/commands/spec-work.md` — add changelog step

## Out of Scope
- Retroactively adding entries for specs 001-006
- Changelog formatting beyond date + spec title + summary
````

## File: specs/completed/007-deny-list-security-hardening.md
````markdown
# Spec: Harden deny list in settings.json template

> **Spec ID**: 007 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Add missing destructive git commands to the deny list in `templates/claude/settings.json`.

## Context
The current deny list blocks `rm -rf`, `git reset --hard`, and `npm publish`, but misses `git clean` which can irreversibly delete untracked files. Other destructive patterns like `git checkout .` and `git restore .` (discard all uncommitted changes) are also unguarded. The suggestions about Copilot symlinks, GSD sub-agents, and `npm run verify` are not relevant to this project's templates.

## Steps
- [x] Step 1: Add `Bash(git clean *)` to deny list in `templates/claude/settings.json`
- [x] Step 2: Add `Bash(git checkout -- *)` to deny list (discards uncommitted file changes)
- [x] Step 3: Add `Bash(git restore *)` to deny list (modern equivalent of checkout --)
- [x] Step 4: Verify `git push` is already sufficiently scoped (allow only `claude/*` branches, general push not allowed)
- [x] Step 5: Run `bash -n bin/ai-setup.sh` to validate no syntax issues
- [x] Step 6: Test that settings.json remains valid JSON

## Acceptance Criteria
- [x] `git clean`, `git checkout --`, and `git restore` are denied
- [x] Existing allow/deny entries unchanged
- [x] Valid JSON after edits

## Files to Modify
- `templates/claude/settings.json` - add deny entries

## Out of Scope
- Copilot symlink strategy (not used in this project)
- GSD sub-agent path resolution (not part of templates)
- `npm run verify` command (not defined in templates)
````

## File: specs/completed/008-feature-challenge-skill.md
````markdown
# Spec: Feature Challenge & Brainstorm Skill

> **Spec ID**: 008 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Create a local `/challenge` skill that critically questions proposed features before implementation begins.

## Context
New feature ideas often get implemented without questioning whether they're truly needed, add unnecessary overhead, or solve the wrong problem. A dedicated skill acts as a "devil's advocate" — forcing structured critical thinking, including an explicit "don't build it" option, before any code is written. This skill is project-local (`.claude/commands/`), not a template for target projects.

## Steps
- [x] Step 1: Create `.claude/commands/challenge.md` with structured challenge prompt
- [x] Step 2: Include phases: (1) restate the idea, (2) **concept fit** — does it align with "one command, zero config, template-based"? (3) **is it necessary at all?** (4) overhead/maintenance cost, (5) complexity/risks, (6) simpler alternatives or "don't build it", (7) verdict
- [x] Step 3: Accept `$ARGUMENTS` as the feature description to challenge
- [x] Step 4: Use `model: sonnet` and read-only tools (`Read, Glob, Grep`) — no edits
- [x] Step 5: Skill reads `docs/CONCEPT.md` to validate concept alignment; reads codebase for overlap
- [x] Step 6: End with GO / SIMPLIFY / REJECT — REJECT explicitly covers "unnecessary overhead"

## Acceptance Criteria
- [x] `/challenge "add feature X"` produces a structured critical analysis
- [x] Concept fit is explicitly evaluated against `docs/CONCEPT.md`
- [x] Skill checks for overlap with existing functionality
- [x] Output includes simpler alternatives when applicable
- [x] No file modifications — purely analytical

## Files to Modify
- `.claude/commands/challenge.md` — new skill file

## Out of Scope
- Not a template for target projects (project-local only)
- No integration into spec-work workflow
- No automated blocking of feature implementation
````

## File: specs/completed/009-system-auto-detection.md
````markdown
# Spec: Auto-Detect System from Codebase Signals

> **Spec ID**: 009 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Resolve `--system auto` to a concrete system (shopify/nuxt/laravel/shopware/storyblok) via shell-based codebase signals so system-specific skills are actually installed.

## Context
When a user runs `npx @onedot/ai-setup` without `--system`, they select "auto" and Claude detects the stack in generation prompts — but system-specific skill installation uses a `case` statement that only matches concrete system names. Result: `auto` users never get system-specific skills. The fix is a shell-based detect function that resolves `auto` to a concrete system before skill installation.

## Steps
- [x] Step 1: Add `detect_system()` function in `bin/ai-setup.sh` after `select_system()` (~line 310)
- [x] Step 2: Detection signals (in priority order):
  - `theme.liquid` present → `shopify`
  - `composer.json` + `artisan` file → `laravel`
  - `composer.json` + `vendor/shopware` dir → `shopware`
  - `package.json` containing `"nuxt"` → `nuxt`
  - `package.json` containing `"@storyblok"` → `storyblok`
  - No match → keep `auto` (let generation prompts handle it)
- [x] Step 3: Call `detect_system` immediately after `select_system` resolves `SYSTEM="auto"`
- [x] Step 4: If resolved, print `"  🔍 Detected system: $SYSTEM"` and continue
- [x] Step 5: System-specific skills install with resolved system (existing case statement unchanged)
- [x] Step 6: Store resolved system in `.ai-setup.json` so `--regenerate` reuses it

## Acceptance Criteria
- [x] A Shopify repo with `theme.liquid` auto-resolves to `shopify` and installs Shopify skills
- [x] A Laravel repo with `artisan` auto-resolves to `laravel` and installs Laravel skills
- [x] Unknown stacks keep `SYSTEM=auto`, no skills installed, no crash
- [x] Detection is pure shell — no LLM call, no network request, <50ms

## Files to Modify
- `bin/ai-setup.sh` — add `detect_system()`, call it after system selection

## Out of Scope
- No changes to generation prompts (they already handle `$SYSTEM`)
- No new systems beyond the 5 already supported
- No UI changes to `select_system()` menu
````

## File: specs/completed/010-aura-frog-quality-patterns.md
````markdown
# Spec: Adapt Aura Frog Quality Patterns into Templates

> **Spec ID**: 010 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Add TDD enforcement and dual-condition verification gate to CLAUDE.md template, inspired by Aura Frog's quality discipline.

## Context
Aura Frog enforces TDD (no code before failing test) and dual-condition exit gates (tests pass + explicit verification). Our CLAUDE.md template has a basic Verification section but lacks TDD enforcement and strict exit criteria. Model routing and Playwright MCP are already covered by GSD profiles and existing settings — no changes needed there.

## Steps
- [x] Step 1: Add Task Complexity Routing section to `templates/CLAUDE.md` — simple/medium/complex classification with explicit model guidance
- [x] Step 2: Strengthen `templates/CLAUDE.md` Verification section with dual-condition gate — require both automated checks (tests/lint pass) AND explicit confirmation statement
- [x] Step 3: Add conditional TDD rule to `templates/CLAUDE.md` — enforce "write failing test first" only when test infrastructure exists (detected by Auto-Init)
- [x] Step 4: Update `bin/ai-setup.sh` Auto-Init CLAUDE.md generation prompt to detect test framework and conditionally include TDD rule
- [x] Step 5: Add Context7 MCP to `bin/ai-setup.sh` — already implemented at lines 1494-1537
- [x] Step 6: Validate with `bash -n bin/ai-setup.sh` and review generated output

## Acceptance Criteria
- [x] CLAUDE.md template includes Task Complexity Routing section (simple/medium/complex)
- [x] Verification section requires dual-condition exit (automated + explicit statement)
- [x] TDD rule included conditionally based on test framework detection
- [x] Auto-Init detects jest/vitest/mocha/pytest presence for TDD rule
- [x] Context7 MCP is written to `.mcp.json` in target project during setup

## Files to Modify
- `templates/CLAUDE.md` — add routing section, TDD rule, strengthen verification
- `bin/ai-setup.sh` — test framework detection, Context7 MCP setup

## Out of Scope
- Playwright MCP setup (project-specific, not generic)
- New agent personas (existing agents sufficient)
- Automatic model switching (not possible, guidance only)
````

## File: specs/completed/012-bug-command-template.md
````markdown
# Spec: /bug Command for Bug Investigation

> **Spec ID**: 012 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Add a `/bug` slash command template that gives Claude a structured bug investigation workflow instead of defaulting to spec creation.

## Context
When users report bugs, Claude currently has no dedicated workflow — it either investigates ad-hoc or suggests creating a spec (wrong tool for bugs). A `/bug` command template gives Claude a clear protocol: reproduce → isolate → fix → verify, without the overhead of spec format.

## Steps
- [x] Step 1: Create `templates/commands/bug.md` with bug investigation workflow
- [x] Step 2: Add `"templates/commands/bug.md:.claude/commands/bug.md"` to `TEMPLATE_MAP` in `bin/ai-setup.sh`
- [x] Step 3: Add `bug.md` to the command install loop in `bin/ai-setup.sh` (fresh install path)
- [x] Step 4: Update `README.md` commands table to include `/bug`
- [x] Step 5: `bash -n bin/ai-setup.sh` syntax check

## Acceptance Criteria
- [x] `/bug "description"` starts a structured investigation (not a spec)
- [x] Template covers: reproduce → root cause → fix → verify
- [x] Installs automatically with `npx @onedot/ai-setup`
- [x] Appears in README command table

## Files to Modify
- `templates/commands/bug.md` - new command template (create)
- `bin/ai-setup.sh` - TEMPLATE_MAP + install loop
- `README.md` - commands table

## Out of Scope
- GitHub Issues integration
- Bug tracking database or persistence
````

## File: specs/completed/013-dynamic-template-map.md
````markdown
# Spec: Dynamic Template Map for Reliable Update Propagation

> **Spec ID**: 013 | **Created**: 2026-02-22 | **Status**: completed

## Goal
Replace hardcoded TEMPLATE_MAP with dynamic generation from `templates/` directory so all template changes automatically propagate to consumer projects.

## Context
TEMPLATE_MAP is manually maintained and already has gaps: `spec-work-all.md` missing from install loop, `hooks/README.md` missing from map entirely. Adding a new template requires updating 3 places. Dynamic generation eliminates this class of bugs.

## Steps
- [x] Step 1: Add `build_template_map()` function in `bin/ai-setup.sh` that scans `$SCRIPT_DIR/templates/` recursively and maps paths using prefix rules (claude/→.claude/, commands/→.claude/commands/, agents/→.claude/agents/, github/→.github/, specs/→specs/). Exclude `mcp.json` (special merge handling).
- [x] Step 2: Replace the hardcoded `TEMPLATE_MAP=()` array (lines 56-81) with a call to `build_template_map`
- [x] Step 3: Fix Section 4 hooks loop (line 1368) to derive file list from `templates/claude/hooks/` instead of hardcoded list
- [x] Step 4: Fix Section 6c commands loop (line 1407) to derive file list from `templates/commands/` instead of hardcoded list (fixes missing `spec-work-all.md`)
- [x] Step 5: Fix Section 6d agents loop (line 1420) to derive file list from `templates/agents/` instead of hardcoded list
- [x] Step 6: Test by running `./bin/ai-setup.sh` in a test directory — verify all templates are installed on fresh install and smart update detects all files

## Acceptance Criteria
- [x] Every file in `templates/` (except mcp.json) appears in TEMPLATE_MAP automatically
- [x] Adding a new template file to `templates/` requires zero changes to `bin/ai-setup.sh`
- [x] Fresh install and smart update both cover the same set of files
- [x] Existing checksum-based update logic (backup user-modified files) still works

## Files to Modify
- `bin/ai-setup.sh` — add `build_template_map()`, replace hardcoded array, update install loops

## Out of Scope
- MCP server config (`.mcp.json`) — stays with special merge logic
- Regeneration flow (CLAUDE.md, context files) — already dynamic
- CI/CD automation for publishing
````

## File: specs/completed/014-skills-discovery-section.md
````markdown
# Spec: Add Skills Discovery Section to CLAUDE.md Template

> **Spec ID**: 014 | **Created**: 2026-02-22 | **Status**: completed

## Goal
Add a "Skills Discovery" section to the CLAUDE.md template so Claude can search and install skills from skills.sh on demand during sessions.

## Context
After initial setup, Haiku selects top 5 skills. If users need more mid-session, Claude doesn't know the commands. Adding the search/install instructions to the template ensures every project has this capability. The `--agent claude-code --agent github-copilot` flags limit installs to these two agents only.

## Steps
- [x] Step 1: Add a `## Skills Discovery` section to `templates/CLAUDE.md` after "Working Style" with `npx skills find` and `npx skills add` commands, including `--agent claude-code --agent github-copilot -y` flags
- [x] Step 2: Verify the section doesn't conflict with the regeneration logic (which only touches Commands and Critical Rules sections)

## Acceptance Criteria
- [x] `templates/CLAUDE.md` contains Skills Discovery section with search and install commands
- [x] Install command includes `--agent claude-code --agent github-copilot` flags
- [x] Section includes guidance to check existing skills first and only install when needed

## Files to Modify
- `templates/CLAUDE.md` — add Skills Discovery section

## Out of Scope
- New slash command for skill discovery (can be added later)
- Changes to the Haiku-based skill curation during setup
- Copilot-instructions.md changes (Copilot already reads CLAUDE.md)
````

## File: specs/completed/015-spec-workflow-branch-and-review.md
````markdown
# Spec: Improve spec-work branch handling and review flow

> **Spec ID**: 015 | **Created**: 2026-02-22 | **Status**: completed | **Branch**: —

## Goal
Add branch creation prompt to /spec-work, remove PR from /spec-review, and add optional auto-review with corrections to /spec-work.

## Context
The spec workflow currently lacks a branch prompt in /spec-work (users may work on main), suggests PR commands in /spec-review (unwanted), and requires a separate /spec-review step. This spec streamlines the flow: ask about branches upfront, remove PR noise, and offer inline auto-review with auto-fix after execution.

## Steps
- [x] Step 1: In `templates/commands/spec-work.md`, add `AskUserQuestion` to `allowed-tools` in frontmatter
- [x] Step 2: In `spec-work.md`, insert step 3 (after reading spec): ask user if a new branch should be created. If yes, derive `spec/NNN-title` from filename, run `git checkout -b`, update spec `**Branch**` field. If branch exists, offer to switch.
- [x] Step 3: In `spec-work.md`, replace step 9 (mark ready for review): ask user if auto-review should run. If no, keep current behavior (set `in-review`, suggest `/spec-review`).
- [x] Step 4: In `spec-work.md`, add step 10 (auto-review): full review pass — check spec compliance, acceptance criteria, code quality. Fix issues found. One pass only. If all good, set status `completed`, move to `specs/completed/`. If unfixable issues, keep `in-review` and report.
- [x] Step 5: In `templates/commands/spec-review.md`, remove PR preparation from APPROVED verdict (steps 3-4: PR title/body/commands). Keep status change and file move only.
- [x] Step 6: Update `templates/CLAUDE.md` spec workflow section to reflect that /spec-review no longer suggests PRs
- [x] Step 7: Renumber all steps in spec-work.md to account for inserted branch step and auto-review

## Acceptance Criteria
- [x] `/spec-work` asks about branch creation before starting work
- [x] `/spec-work` asks about auto-review after completing all steps
- [x] `/spec-review` APPROVED verdict has no PR commands or suggestions
- [x] Auto-review performs full check and auto-fixes issues in one pass

## Files to Modify
- `templates/commands/spec-work.md` — add branch prompt, auto-review option
- `templates/commands/spec-review.md` — remove PR from APPROVED
- `templates/CLAUDE.md` — update workflow description

## Out of Scope
- Changes to `/spec-work-all` (already has its own branch/worktree logic)
- Creating a separate `/pr` command
- Multi-pass review loops
````

## File: specs/completed/016-worktree-env-and-deps.md
````markdown
# Spec: Auto-copy .env and install deps in spec-work-all worktrees

> **Spec ID**: 016 | **Created**: 2026-02-22 | **Status**: completed | **Branch**: spec/016-worktree-env-and-deps

## Goal
Make spec-work-all worktrees production-ready by copying .env files and installing dependencies automatically.

## Context
Inspired by Timberline's worktree manager, our `spec-work-all.md` creates bare worktrees without .env files or installed dependencies. Agents running in these worktrees fail silently when the project needs environment variables or node_modules. This adds two steps to the "Wave setup" section.

## Steps
- [x] Step 1: In `templates/commands/spec-work-all.md`, after `git worktree add` in "Wave setup", add .env copy step: copy all `.env*` files from repo root to worktree, excluding `.env.example` and `.env.template`. Use glob: `for f in .env*; do ...`
- [x] Step 2: In same section, add dependency auto-init: detect lockfile (bun.lockb→bun, package-lock.json→npm, pnpm-lock.yaml→pnpm, yarn.lock→yarn) and run `<pm> install` inside worktree. Skip if no lockfile found.
- [x] Step 3: Add error handling: if .env copy or dep install fails, log a warning but continue (don't block spec execution)
- [x] Step 4: Update the subagent prompt template to mention that .env and deps are pre-configured in the worktree

## Acceptance Criteria
- [x] Worktrees receive .env files (excluding example/template) before agents launch
- [x] Dependencies are installed via detected package manager before agents launch
- [x] Failures in env copy or dep install are warnings, not blockers

## Files to Modify
- `templates/commands/spec-work-all.md` — add env copy and dep init to Wave setup

## Out of Scope
- Supporting non-JS package managers (cargo, pip, go mod) — add later if needed
- Syncing .env changes back from worktree to main repo
- Session linking (symlink Claude project data across worktrees)
````

## File: specs/completed/019-shopify-commands-to-skills.md
````markdown
# Spec: Move Shopify templates from commands to skills

> **Spec ID**: 019 | **Created**: 2026-02-23 | **Status**: completed

## Goal
Relocate Shopify knowledge templates from `.claude/commands/shopify/` to `.claude/skills/shopify-*/prompt.md` where they belong semantically.

## Context
The 8 Shopify templates (theme-dev, liquid, app-dev, graphql-api, hydrogen, checkout, functions, cli-tools) are reference/knowledge documents, not user-invokable commands. They were incorrectly placed under `templates/commands/shopify/`. Moving them to skills with the subdirectory convention (`.claude/skills/shopify-*/prompt.md`) matches their actual purpose. The overlapping `dragnoir/Shopify-agent-skills` entries in the skills.sh curated list will be removed since bundled templates are more detailed and version-controlled.

## Steps
- [x] Step 1: Create `templates/skills/` directory structure with 8 subdirs (`shopify-theme-dev/`, `shopify-liquid/`, etc.), move each `.md` → `prompt.md` inside its subdir
- [x] Step 2: Delete `templates/commands/shopify/` directory entirely
- [x] Step 3: In `bin/ai-setup.sh`, rename `SHOPIFY_TEMPLATE_MAP` to `SHOPIFY_SKILLS_MAP` and update all source→target paths to `templates/skills/shopify-*/prompt.md:.claude/skills/shopify-*/prompt.md`
- [x] Step 4: Update all install/update/uninstall references in `bin/ai-setup.sh` — change `commands/shopify` → `skills/shopify-*`, update `mkdir -p` targets and `cp` paths
- [x] Step 5: Remove `dragnoir/Shopify-agent-skills@*` entries (8 lines) from the shopify curated skills list in `bin/ai-setup.sh`
- [x] Step 6: Update dynamic template discovery in `bin/ai-setup.sh` if it scans `templates/commands/` — ensure it also discovers `templates/skills/`
- [x] Step 7: Bump version in `package.json` to 1.1.4, add CHANGELOG entry

## Acceptance Criteria
- [x] `templates/commands/shopify/` no longer exists
- [x] 8 skills exist at `templates/skills/shopify-*/prompt.md`
- [x] Running `./bin/ai-setup.sh --system shopify` installs to `.claude/skills/` not `.claude/commands/`
- [x] No `dragnoir/Shopify-agent-skills` references remain in setup script

## Files to Modify
- `templates/commands/shopify/*.md` → `templates/skills/shopify-*/prompt.md` (move)
- `bin/ai-setup.sh` — path mappings, install logic, curated skills list
- `package.json` — version bump
- `CHANGELOG.md` — release notes

## Out of Scope
- Content changes to the Shopify templates themselves
- Adding skills support for other systems (nuxt, next, etc.)
- Changing the skills.sh marketplace integration logic
````

## File: specs/completed/020-granular-update-selector.md
````markdown
# Spec: Granular Template Update Selector

> **Spec ID**: 020 | **Created**: 2026-02-23 | **Status**: completed

## Goal
Allow users to select which template categories to update during a version-bump smart update instead of updating all files at once.

## Context
The smart update (option 1 on version bump) currently iterates the full `TEMPLATE_MAP` and copies every template. Users who only want e.g. updated commands must accept hook/settings changes too. A new `ask_update_parts` checkbox UI (same pattern as existing `ask_regen_parts`) lets users toggle 5 categories: Hooks, Settings, Commands, Agents, Other. The filter applies to the `TEMPLATE_MAP` loop in the smart update block.

## Steps
- [x] Step 1: Add `ask_update_parts` function (lines ~480) using same checkbox UI pattern as `ask_regen_parts`. 5 options: Hooks (`.claude/hooks/`), Settings (`.claude/settings.json`), Commands (`.claude/commands/`), Agents (`.claude/agents/`), Other (`specs/`, `github/`, `CLAUDE.md` template). Sets flags `UPD_HOOKS`, `UPD_SETTINGS`, `UPD_COMMANDS`, `UPD_AGENTS`, `UPD_OTHER`.
- [x] Step 2: Add `should_update_template` helper function that takes a template mapping string and returns 0/1 based on the `UPD_*` flags. Match by target path prefix: `.claude/hooks/` → UPD_HOOKS, `.claude/settings` → UPD_SETTINGS, `.claude/commands/` → UPD_COMMANDS, `.claude/agents/` → UPD_AGENTS, everything else → UPD_OTHER.
- [x] Step 3: Insert `ask_update_parts` call at line ~1214 (after "Analyzing templates..." echo, before the template loop). If returns 1 (nothing selected), skip to metadata update.
- [x] Step 4: Add `should_update_template "$mapping"` guard at top of the `TEMPLATE_MAP` loop (line ~1222) and the `SHOPIFY_TEMPLATE_MAP` loop (line ~1270). Skip entries that don't match selected categories.
- [x] Step 5: Update the summary output (line ~1304) to mention which categories were selected.

## Acceptance Criteria
- [x] Running smart update shows 5-category checkbox selector before template processing
- [x] Deselecting a category skips all template files in that category
- [x] Selecting nothing skips the template update entirely (goes straight to regen prompt)
- [x] Shopify templates respect the Commands filter
- [x] Fresh install and reinstall paths are NOT affected

## Files to Modify
- `bin/ai-setup.sh` — add `ask_update_parts`, `should_update_template`, integrate into smart update block

## Out of Scope
- Changing the `ask_regen_parts` regeneration selector (already works correctly)
- Adding CLI flags for non-interactive category selection
- Per-file selection (too granular, checkbox UI doesn't scale)
````

## File: specs/completed/021-release-command-and-tagging.md
````markdown
# Spec: /release command with git tagging and CHANGELOG versioning

> **Spec ID**: 021 | **Created**: 2026-02-23 | **Status**: completed

## Goal
Add a `/release` command that bumps the version, formats CHANGELOG under version headings, updates README, commits, and creates a git tag — plus backfill tags for all historical versions.

## Context
The project is at v1.1.4 with zero git tags and an inconsistent CHANGELOG (duplicate dates, missing version numbers). Version bumps happen ad-hoc inside specs. A dedicated `/release` command standardizes this: entries accumulate under `[Unreleased]`, then `/release` moves them into a versioned block, bumps package.json, commits, and tags. The template is auto-discovered via the dynamic template map (spec 013).

## Steps
- [x] Step 1: Create `templates/commands/release.md` — Sonnet command that reads git log + CHANGELOG, asks version type (patch/minor/major), bumps `package.json`, moves `[Unreleased]` entries under `## [vX.Y.Z] — YYYY-MM-DD`, checks README command table count against actual templates, commits as `release: vX.Y.Z`, creates git tag `vX.Y.Z`
- [x] Step 2: Reformat `CHANGELOG.md` — add `## [Unreleased]` section at top, retroactively group existing entries under version headings (`[v1.1.4]`, `[v1.1.3]`, etc.) based on commit messages and dates
- [x] Step 3: Update `templates/commands/spec-work.md` — change CHANGELOG instructions to prepend entries under the `## [Unreleased]` heading instead of date headings
- [x] Step 4: Update `README.md` — add `/release` to the Slash Commands table (13 commands), add version badge or indicator at top
- [x] Step 5: Backfill git tags — create tags `v1.1.0`, `v1.1.1`, `v1.1.2`, `v1.1.3`, `v1.1.4` on the correct historical commits
- [x] Step 6: Bump version to `1.1.5` in `package.json`, add CHANGELOG entry for this spec

## Acceptance Criteria
- [x] `/release` command template exists and follows project command patterns (Sonnet, allowed-tools)
- [x] CHANGELOG uses `## [vX.Y.Z] — date` headings with `## [Unreleased]` at top
- [x] All historical versions (v1.1.0–v1.1.4) have git tags on correct commits
- [x] README command table reflects 13 commands including `/release`
- [x] `/spec-work` template targets `[Unreleased]` section for new entries

## Files to Modify
- `templates/commands/release.md` — new file (release command template)
- `CHANGELOG.md` — reformat with version headings + [Unreleased]
- `templates/commands/spec-work.md` — update CHANGELOG instructions
- `README.md` — add /release to command table, update count
- `package.json` — version bump to 1.1.5

## Out of Scope
- npm publish automation
- GitHub Releases (API integration)
- Automatic version detection from conventional commits (user picks)
````

## File: specs/completed/022-deduplicate-review-logic.md
````markdown
# Spec: Deduplicate Auto-Review Logic in spec-work

> **Spec ID**: 022 | **Created**: 2026-02-24 | **Status**: in-review | **Branch**: spec/022-deduplicate-review-logic

## Goal
Remove the duplicated review criteria from `spec-work.md`'s auto-review step and reference the shared review logic instead.

## Context
`spec-work.md` Step 10 and `spec-review.md` contain near-identical review criteria (spec compliance, acceptance criteria, code quality checks). If one changes, the other silently goes stale — a maintenance trap. The auto-review step should describe *what* to do, not re-define the criteria.

## Steps
- [x] Step 1: Read `spec-work.md` Step 10 and `spec-review.md` §5 side by side to confirm duplication
- [x] Step 2: Rewrite `spec-work.md` Step 10 "yes" path to a compact summary — check spec compliance, criteria, and HIGH/MEDIUM code issues — without copy-pasting the full review schema
- [x] Step 3: Add a note: "For full review criteria see `/spec-review`"
- [x] Step 4: Sync the same change to `.claude/commands/spec-work.md`

## Acceptance Criteria
- [x] `spec-work.md` Step 10 no longer duplicates review criteria from `spec-review.md`
- [x] Auto-review behavior is unchanged (still checks compliance, criteria, quality)
- [x] Both templates and deployed commands are updated

## Files to Modify
- `templates/commands/spec-work.md` — replace verbose auto-review criteria
- `.claude/commands/spec-work.md` — sync deployed copy

## Out of Scope
- Changing spec-review.md logic
- Merging the two commands
````

## File: specs/completed/023-fix-git-add-in-worktree.md
````markdown
# Spec: Fix git add -A in spec-work-all Worktree Prompt

> **Spec ID**: 023 | **Created**: 2026-02-24 | **Status**: in-review | **Branch**: spec/023-fix-git-add-in-worktree

## Goal
Replace `git add -A` with `git add -u` in the `spec-work-all.md` subagent commit step to match project conventions.

## Context
`spec-work-all.md` embeds a shell snippet ending with `git add -A && git commit`. This contradicts the rule in `commit.md` ("never use `git add -A` — avoid accidentally staging secrets or binaries"). In a worktree context the risk is lower but the inconsistency undermines the project's own safety conventions.

## Steps
- [x] Step 1: Locate the commit line in `spec-work-all.md` subagent prompt (`git add -A && git commit`)
- [x] Step 2: Replace with `git add -u && git commit -m "spec(NNN): [spec title]"` (stages tracked changes only)
- [x] Step 3: Sync to `.claude/commands/spec-work-all.md`

## Acceptance Criteria
- [x] No `git add -A` in any spec-work-all template or deployed command
- [x] `git add -u` is used instead (tracks modified/deleted, ignores untracked secrets)

## Files to Modify
- `templates/commands/spec-work-all.md` — fix commit line in subagent prompt
- `.claude/commands/spec-work-all.md` — sync deployed copy

## Out of Scope
- Changing the broader worktree setup logic
- Adding secret scanning
````

## File: specs/completed/024-smoke-test-ai-setup.md
````markdown
# Spec: Smoke Test for bin/ai-setup.sh

> **Spec ID**: 024 | **Created**: 2026-02-24 | **Status**: in-review | **Branch**: spec/024-smoke-test-ai-setup

## Goal
Add a minimal smoke test script that catches syntax errors and flag regressions in `bin/ai-setup.sh` without requiring a live install.

## Context
`bin/ai-setup.sh` is the core of the package but has zero automated tests. Bugs go undetected until a user runs `npx @onedot/ai-setup`. A lightweight bash test covering syntax, `--help`, and key function presence provides a safety net for changes.

## Steps
- [x] Step 1: Create `tests/smoke.sh` — run `bash -n bin/ai-setup.sh` (syntax check), then `bash bin/ai-setup.sh --help` and assert exit 0
- [x] Step 2: Assert key functions exist in the script: `setup_system`, `update_system`, `build_template_map`
- [x] Step 3: Add `"test": "bash tests/smoke.sh"` to `package.json` scripts
- [x] Step 4: Verify `npm test` passes

## Acceptance Criteria
- [x] `npm test` runs `tests/smoke.sh` and exits 0
- [x] Syntax errors in `bin/ai-setup.sh` cause test failure
- [x] Missing key functions cause test failure
- [x] Test runs in under 5 seconds

## Files to Modify
- `tests/smoke.sh` — new file
- `package.json` — add test script

## Out of Scope
- Integration tests that actually install files to a temp directory
- Testing every flag or system type
````

## File: specs/completed/025-rules-template-and-agent-turns.md
````markdown
# Spec: Add .claude/rules/general.md Template + Agent max_turns

> **Spec ID**: 025 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: —

## Goal

Install a universal `.claude/rules/general.md` coding safety rules file to target projects, and add `max_turns` limits to all agent templates.

## Context

Alex's AI Coding Starter Kit uses `.claude/rules/` as a third enforcement layer between CLAUDE.md (always loaded) and hooks (tool-level blocks). Rules auto-apply contextually, keeping CLAUDE.md lean. A framework-agnostic `general.md` enforces "read before modify" and "check before creating" at the prompt level. Additionally, his agents cap turns (30–50) as a cost guard; our agent templates have no `max_turns` frontmatter.

## Steps

- [x] Step 1: Create `templates/claude/rules/general.md` with universal rules: always read before modifying, verify import paths by reading, check existing files before creating, run `git diff` after changes
- [x] Step 2: Add `max_turns` frontmatter to `templates/agents/build-validator.md` (10), `verify-app.md` (20), `staff-reviewer.md` (20), `context-refresher.md` (15)
- [x] Step 3: Update `bin/ai-setup.sh` install logic to copy `templates/claude/rules/` to `.claude/rules/` in target projects (alongside existing hooks copy)
- [x] Step 4: Update `bin/ai-setup.sh` update logic to include `rules/` in the regeneration/sync paths

## Acceptance Criteria

- [x] Running `npx @onedot/ai-setup` creates `.claude/rules/general.md` in the target project
- [x] All 4 agent templates have `max_turns` in frontmatter
- [x] Update mode syncs the rules file without overwriting user customizations (same pattern as hooks)
- [x] `general.md` contains only framework-agnostic rules (no Next.js, no Supabase)

## Files to Modify

- `templates/claude/rules/general.md` - create new
- `templates/agents/build-validator.md` - add max_turns: 10
- `templates/agents/verify-app.md` - add max_turns: 20
- `templates/agents/staff-reviewer.md` - add max_turns: 20
- `templates/agents/context-refresher.md` - add max_turns: 15
- `bin/ai-setup.sh` - install + update rules/ directory

## Out of Scope

- Stack-specific rules (frontend.md, backend.md, security.md) — too project-specific
- Role-based agents (frontend-dev, backend-dev, qa-engineer) — audience mismatch
- Feature tracking system (features/INDEX.md) — we have specs/
````

## File: specs/completed/029-perf-reviewer-and-test-generator-agents.md
````markdown
# Spec: Performance-Reviewer und Test-Generator Agent-Templates

> **Spec ID**: 029 | **Created**: 2026-02-24 | **Status**: completed

## Goal
Zwei neue universelle Agent-Templates hinzufuegen: `perf-reviewer` (Performance-Analyse) und `test-generator` (Test-Generierung).

## Context
Die aktuellen 5 Agents decken Build, Verification, Code-Review, Staff-Review und Context ab. Es fehlen spezialisierte Agents fuer Performance-Analyse und Test-Generierung. Beide sind universell — jedes Projekt profitiert davon. `perf-reviewer` ist read-only (wie code-reviewer), `test-generator` ist der erste generative Agent mit Write-Zugriff (nur fuer Testdateien).

## Steps
- [x] Step 1: `templates/agents/perf-reviewer.md` erstellen — Sonnet, Tools: Read/Glob/Grep/Bash, read-only. Prueft: N+1 Queries, Memory Leaks, unnoetige Re-Renders, Bundle-Groesse, langsame DB-Queries, ineffiziente Loops. Output: FAST/CONCERNS/SLOW Verdict mit Findings.
- [x] Step 2: `templates/agents/test-generator.md` erstellen — Sonnet, Tools: Read/Write/Glob/Grep/Bash, max_turns: 20. Analysiert geaenderte Dateien via `git diff`, identifiziert ungetestete Pfade, generiert Tests im bestehenden Test-Framework des Projekts. Guardrail: darf NUR Dateien in test/tests/__tests__/spec-Verzeichnissen schreiben.
- [x] Step 3: Beide Agents im Format der bestehenden Templates (Frontmatter + Behavior + Output Format + Rules). Konsistenz mit code-reviewer.md und build-validator.md sicherstellen.
- [x] Step 4: Smoke-Test: `./bin/ai-setup.sh` im Trockenlauf pruefen — TEMPLATE_MAP erkennt `templates/agents/*.md` automatisch, kein Eingriff in ai-setup.sh noetig.

## Acceptance Criteria
- [x] `perf-reviewer.md` folgt dem bestehenden Agent-Format (Frontmatter, Behavior, Output, Rules)
- [x] `test-generator.md` hat Write-Guardrail: nur Test-Verzeichnisse beschreibbar
- [x] TEMPLATE_MAP erkennt beide neuen Agents ohne Code-Aenderung in ai-setup.sh
- [x] Bestehende Agents bleiben unveraendert

## Files to Modify
- `templates/agents/perf-reviewer.md` — neues Agent-Template
- `templates/agents/test-generator.md` — neues Agent-Template

## Out of Scope
- Domain-spezifische Agents (React, Django, etc.)
- Aenderungen an ai-setup.sh oder TEMPLATE_MAP
- Aenderungen an bestehenden Agent-Templates
````

## File: specs/completed/030-update-flow-context-check.md
````markdown
# Spec: Add context file check and granular regeneration to update flow

> **Spec ID**: 030 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: —

## Goal
Ensure the smart update flow checks for missing `.agents/context/` files and offers granular regeneration via `ask_regen_parts` instead of a binary y/N prompt.

## Context
The "Different version" update path (option 1) uses a simple y/N prompt defaulting to No for context regeneration, while the "Same version" path already uses the granular `ask_regen_parts` selector. Context files may be entirely missing after updating from older versions — this is never detected or communicated.

## Steps
- [x] Step 1: After template update summary (line ~1414), add existence check for `.agents/context/{STACK,ARCHITECTURE,CONVENTIONS}.md` — count existing vs expected (3)
- [x] Step 2: If any context files are missing, print warning with count (e.g. "⚠️  2 of 3 context files missing — regeneration recommended")
- [x] Step 3: Replace the y/N prompt block (lines 1416-1429) with `ask_regen_parts` call, matching the same-version flow pattern (lines 1273-1283)
- [x] Step 4: If context files are missing, pre-set `REGEN_CONTEXT="yes"` before calling `ask_regen_parts` so Context is recommended (but user can still deselect)
- [x] Step 5: Verify idempotency — running update twice with all context files present must not force regeneration

## Acceptance Criteria
- [x] Missing context files are detected and reported during smart update
- [x] Update flow uses `ask_regen_parts` for granular control (CLAUDE.md, Context, Commands, Skills)
- [x] Default behavior regenerates context when files are missing, skips when all present
- [x] No regression in same-version and reinstall flows

## Files to Modify
- `bin/ai-setup.sh` — smart update section (lines ~1414-1429)

## Out of Scope
- Staleness detection for existing context files (age-based checks)
- Changes to the `--regen` CLI flag flow
- Modifications to `run_generation` itself
````

## File: specs/completed/031-fix-claudemd-generation-timeout.md
````markdown
# Spec: Fix CLAUDE.md generation timeout and error message

> **Spec ID**: 031 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/031-fix-claudemd-generation-timeout

## Goal
Increase the CLAUDE.md generation timeout from 120s to 180s and show a clear "timed out" message instead of "check authentication" when exit code is 143.

## Context
The `wait_parallel` function gives CLAUDE.md generation 120s before killing the process with SIGTERM (exit code 143). The verify step then shows "check authentication" which is misleading — the real cause is a timeout, not an auth issue. Context generation already gets 180s; CLAUDE.md should match.

## Steps
- [x] Step 1: In `bin/ai-setup.sh` line 837, change `"$PID_CM:CLAUDE.md:30:120"` → `"$PID_CM:CLAUDE.md:30:180"` (match context timeout)
- [x] Step 2: In lines 843-854, detect exit code 143 separately — show "Generation timed out (>180s). Re-run: npx @onedot/ai-setup --regenerate" instead of "check authentication"

## Acceptance Criteria
- [x] CLAUDE.md generation gets 180s (same as context)
- [x] Exit code 143 shows timeout message, not auth message
- [x] Other non-zero exit codes still show "check authentication"

## Files to Modify
- `bin/ai-setup.sh` — lines 837 and 849-853

## Out of Scope
- Retry logic for failed generation
- Changes to context generation timeout (already 180s)
````

## File: specs/completed/032-local-skill-templates-for-common-frameworks.md
````markdown
# Spec: Local skill templates for common frameworks

> **Spec ID**: 032 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/032-local-skill-templates-for-common-frameworks

## Goal
Bundle skill templates for tailwind, pinia, drizzle, tanstack, and vitest locally so the slow npx skills.sh search is skipped and "no skills found" warnings disappear.

## Context
The dynamic skill search runs `npx skills@latest find $kw` for each detected keyword (up to 30s per keyword). Technologies like tailwind, pinia, drizzle, tanstack, and vitest consistently return nothing from skills.sh. The project already bundles Shopify skills as local templates — this spec extends that pattern to common framework-agnostic technologies.

## Steps
- [x] Step 1: Create `templates/skills/tailwind/prompt.md` — Tailwind CSS patterns and best practices
- [x] Step 2: Create `templates/skills/pinia/prompt.md` — Pinia state management patterns
- [x] Step 3: Create `templates/skills/drizzle/prompt.md` — Drizzle ORM schema and query patterns
- [x] Step 4: Create `templates/skills/tanstack/prompt.md` — TanStack Query/Router patterns
- [x] Step 5: Create `templates/skills/vitest/prompt.md` — Vitest test conventions and mock patterns
- [x] Step 6: Add `get_local_skill_template()` helper in `bin/ai-setup.sh` — case statement mapping keyword → template path (bash 3.2 safe, no `declare -A`)
- [x] Step 7: In the keyword loop (line ~984-1001), call `get_local_skill_template` first — if template exists, copy to `.claude/skills/$kw/prompt.md` and skip the npx search; if not, run dynamic search as before
- [x] Step 8: Run smoke test to verify no regressions

## Acceptance Criteria
- [x] 5 skill templates exist in `templates/skills/{tailwind,pinia,drizzle,tanstack,vitest}/`
- [x] Setup with a nuxt project installs these skills without npx search calls
- [x] Keywords without local templates still fall through to dynamic search
- [x] No "no skills found" warnings for the 5 bundled keywords
- [x] Smoke test passes

## Files to Modify
- `templates/skills/tailwind/prompt.md` — new file
- `templates/skills/pinia/prompt.md` — new file
- `templates/skills/drizzle/prompt.md` — new file
- `templates/skills/tanstack/prompt.md` — new file
- `templates/skills/vitest/prompt.md` — new file
- `bin/ai-setup.sh` — add helper function + update keyword loop

## Out of Scope
- Updating existing `.claude/skills/` during the update flow (separate spec)
- Adding templates for vue, nuxt, react (covered by SYSTEM_SKILLS IDs)
- Removing the dynamic search entirely for known systems
````

## File: specs/071-workflow-guide-for-developers.md
````markdown
# Spec: Developer Workflow Guide

> **Spec ID**: 071 | **Created**: 2026-03-10 | **Status**: draft

## Goal
Install a static `.claude/WORKFLOW-GUIDE.md` that teaches developers the daily AI workflow, commands, and Claude Code basics.

## Context
ONEDOT developers struggle with the ai-setup output — they don't know which commands to use, how the spec workflow works, or what hooks/context files do. A human-readable guide installed alongside the config gives immediate onboarding without adding token cost (not referenced in CLAUDE.md system context). Uses the existing `_install_or_update_file` mechanism.

## Steps
- [ ] Step 1: Create `templates/claude/WORKFLOW-GUIDE.md` with sections: Quick Start, Daily Workflow (spec-driven), Commands Reference (all installed commands with one-liner + example), Claude Code Essentials (context, subagents, hooks), Troubleshooting
- [ ] Step 2: Add `install_workflow_guide()` function in `lib/setup.sh` — copies template to `.claude/WORKFLOW-GUIDE.md` via `_install_or_update_file`
- [ ] Step 3: Call `install_workflow_guide` from the main install flow in `bin/ai-setup.sh`
- [ ] Step 4: Add a one-line reference in `templates/CLAUDE.md` Tips section pointing developers to the guide
- [ ] Step 5: Add `WORKFLOW-GUIDE.md` to the update selector in `lib/update.sh` so it stays current on re-runs

## Acceptance Criteria
- [ ] Running `npx @onedot/ai-setup` installs `.claude/WORKFLOW-GUIDE.md`
- [ ] Guide covers all installed slash commands with usage examples
- [ ] Guide is NOT referenced in CLAUDE.md context loading (no token cost)
- [ ] Re-running setup updates the guide without losing user modifications (checksum logic)

## Files to Modify
- `templates/claude/WORKFLOW-GUIDE.md` - new file, the guide content
- `lib/setup.sh` - new `install_workflow_guide()` function
- `bin/ai-setup.sh` - call the new install function
- `templates/CLAUDE.md` - one-line tip referencing the guide
- `lib/update.sh` - add to update selector

## Out of Scope
- Interactive `/guide` slash command (future enhancement)
- Video tutorials or external documentation
- Translating the guide to German (all templates stay English)
````

## File: specs/072-spec-status-reliability.md
````markdown
# Spec: Reliable Spec Workflow Hardening

> **Spec ID**: 072 | **Created**: 2026-03-10 | **Status**: draft

## Goal
Ensure spec status transitions always happen and large tasks automatically split into multiple specs.

## Context
Developers report specs stuck with stale status (all steps done but still `in-progress`, not moved to `specs/completed/`). Root cause: status updates are prompt instructions at end of a 13-step flow — skipped under context pressure. Additionally, the "max 60 lines, split if larger" rule in `/spec` is passive and often ignored. Fix via prompt hardening, spec-board repair mode, and active auto-split logic.

## Steps
- [ ] Step 1: In `templates/commands/spec-work.md`, add a "Status Checkpoint" rule at top of Rules section: "Before finishing, ALWAYS update status and move the file — this is the single most important step"
- [ ] Step 2: In `templates/commands/spec-work.md`, restructure step 13 — update status to `in-review` BEFORE spawning code-reviewer, so status is saved even if agent fails
- [ ] Step 3: In `templates/commands/spec-work-all.md`, add explicit fallback in wave post-processing: "If subagent failed or returned no result, set spec status to `blocked` with reason"
- [ ] Step 4: In `templates/commands/spec-board.md`, add Step 6 "Consistency Check + Repair" — detect stale specs (all steps done but wrong status, completed but not moved), ask user to confirm fix, then update status and move files
- [ ] Step 5: Update `templates/commands/spec-board.md` YAML header: remove `mode: plan`, add `Write, Edit, AskUserQuestion` to allowed-tools
- [ ] Step 6: In `templates/commands/spec-work.md`, add resume logic at the start of step 9: scan for already-checked steps (`- [x]`), skip them, and continue from the first unchecked step — print which steps were skipped
- [ ] Step 7: In `templates/commands/spec-work.md`, add auto-commit rule to step 9: after completing each step and checking it off, run `git add -A && git commit -m "spec(NNN): step N — <title>"` to preserve progress
- [ ] Step 8: In `templates/commands/spec.md`, add active auto-split in Phase 2 Step 3: after drafting, check two triggers — (a) >60 lines or >8 steps, (b) mixed layers (frontend + backend, API + UI, etc.) — and automatically create separate spec files (NNN, NNN+1) with cross-references and dependency notes

## Acceptance Criteria
- [ ] spec-work updates status before spawning code-reviewer agent
- [ ] spec-board detects and offers to fix at least 2 inconsistency types (with user confirmation)
- [ ] spec-work resumes from last unchecked step when re-run on a partially completed spec
- [ ] spec-work commits after each completed step for crash resilience
- [ ] /spec auto-splits when >60 lines, >8 steps, or mixed frontend/backend layers

## Files to Modify
- `templates/commands/spec-work.md` - reorder status update, add checkpoint rule
- `templates/commands/spec-work-all.md` - add failed subagent fallback
- `templates/commands/spec-board.md` - add consistency check + repair mode
- `templates/commands/spec.md` - add active auto-split logic in Phase 2

## Out of Scope
- New `/spec-fix` command (spec-board covers this)
- Hook-based automation of status transitions
- Changes to spec-review.md (already robust)
````

## File: specs/README.md
````markdown
# Spec-Driven Development

Specs are structured task plans created before coding. They live in `specs/` and follow a simple template.

## When to Create a Spec

**Create a spec when:**
- Changes touch 3+ files
- Adding a new feature or module
- Requirements are ambiguous or complex
- Architectural decisions are involved

**Skip specs for:**
- Single-file fixes (typos, CSS tweaks, config changes)
- Bug fixes with obvious root cause
- Documentation-only changes

## Naming Convention

```
NNN-short-description.md
```

Examples: `001-add-user-authentication.md`, `002-refactor-api-layer.md`

## Workflow

### 1. Create a spec

```
/spec "add dark mode support"
```

This runs an integrated workflow:
1. **Challenge phase** — validates the idea, questions assumptions, surfaces edge cases
2. **Spec generation** — creates `specs/NNN-add-dark-mode-support.md` with steps, criteria, and files to modify

### 2. Review and refine

Read the generated spec. Edit steps, acceptance criteria, or files to modify as needed.

### 3. Execute one spec

```
/spec-work NNN
```

Executes the spec step by step, checking off each step as it completes. Sets status to `in-review` when done.

### 4. Execute all specs in parallel

```
/spec-work-all
```

Discovers all draft specs in `specs/`, detects dependencies between them, then executes in parallel waves using **isolated Git worktrees** — one branch per spec, no merge conflicts. Independent specs run simultaneously; dependent specs wait for their dependencies.

### 5. Review and create PR

```
/spec-review NNN
```

Opus reviews all code changes against the spec's acceptance criteria. Three possible verdicts:
- **APPROVED** — spec completed, moved to `specs/completed/`, PR draft prepared
- **CHANGES REQUESTED** — feedback written to spec, status back to `in-progress` for another `/spec-work` pass
- **REJECTED** — spec blocked with explanation

### 6. View the board

```
/spec-board
```

Kanban-style overview of all specs grouped by status with step-level progress (`[3/8]`) and branch info.

## Spec Status Lifecycle

```
draft → in-progress → in-review → completed
                ↑          |
                └──────────┘  (changes requested)
                
Any status → blocked
```

| Status | Meaning |
|---|---|
| `draft` | Planned, not started |
| `in-progress` | Agent is working on it |
| `in-review` | Work done, awaiting review |
| `blocked` | Blocked by dependency or review rejection |
| `completed` | Reviewed and done, moved to `specs/completed/` |

## Directory Structure

```
specs/
  README.md           # This file
  TEMPLATE.md         # Blank spec template
  001-feature-name.md # Draft spec (status: draft)
  002-other-task.md   # In-progress spec (status: in-progress, branch: spec/002-other-task)
  completed/
    000-old-spec.md   # Completed spec
```
````

## File: specs/TEMPLATE.md
````markdown
# Spec: [TITLE]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft | **Branch**: —

## Goal
[One sentence: what is the desired outcome?]

## Context
[Why is this needed? What triggered this task?]

## Steps
- [ ] Step 1: description
- [ ] Step 2: description
- [ ] Step 3: description

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Files to Modify
- `path/to/file` - reason

## Out of Scope
- What is NOT part of this task
````

## File: templates/agents/build-validator.md
````markdown
---
name: build-validator
description: Runs the project build command and reports pass/fail with output summary.
tools: Read, Bash, Glob
model: haiku
max_turns: 10
---

You are a build validator. Ensure the project builds successfully.

## Behavior

1. **Detect build command**: Check `package.json` for `build`, `build:prod`, or similar scripts.
2. **Run the build**: Execute the detected build command.
3. **Check results**:
   - Exit code 0 = success
   - Any warnings in output
   - Expected output artifacts exist (dist/, build/, .output/, .next/, etc.)
4. **Report**: Pass/fail with build output summary.

## Output Format

```
## Build Report
- Command: `npm run build`
- Status: PASS/FAIL
- Warnings: (count or "none")
- Output: (artifact directory and size)
```

## Rules
- Do NOT fix build errors — only report them.
- If no build command found, report it and stop.
- Capture both stdout and stderr.
````

## File: templates/agents/code-architect.md
````markdown
---
name: code-architect
description: Reviews proposed architecture, specs, and design decisions for structural problems before implementation begins. Identifies over-engineering, missing abstractions, scalability risks, and integration issues.
tools: Read, Glob, Grep, Bash
model: opus
max_turns: 15
---

You are an architectural reviewer. Your job is to assess the design of a proposed spec or implementation plan before code is written -- do NOT implement anything.

## Behavior

1. **Read the spec or plan**: Understand the goal, steps, and files to be modified.
2. **Read existing relevant code**: Check the files listed in "Files to Modify" to understand current patterns and constraints.
3. **Assess the design**:
   - **Structural fit**: Does the approach fit the existing architecture, or does it fight it?
   - **Over-engineering**: Is the solution more complex than the problem warrants?
   - **Missing abstractions**: Should something be extracted, shared, or generalized?
   - **Scalability**: Will this approach work at 10x the current scale?
   - **Integration risks**: Are there hidden dependencies or side effects not accounted for?
   - **Maintenance burden**: Will this be easy to change in 6 months?
4. **Report findings**: List each concern with severity (CRITICAL / HIGH / MEDIUM) and a concrete alternative.

## Output Format

```
## Architectural Review

### Design Assessment
- Structural fit: [GOOD/CONCERN/POOR]
- Complexity: [APPROPRIATE/OVER-ENGINEERED/UNDER-SPECIFIED]
- Maintainability: [GOOD/CONCERN/POOR]

### Concerns
- [CRITICAL/HIGH/MEDIUM] Description -- concrete risk and suggested alternative

### Verdict
PROCEED / PROCEED WITH CHANGES / REDESIGN

Recommendation: one sentence
```

## Rules
- Do NOT implement anything. Only assess design.
- Be specific -- vague concerns are useless.
- If the design is sound, say so clearly: "No architectural concerns."
- Focus on structure and maintainability, not style or minor implementation details.
````

## File: templates/agents/verify-app.md
````markdown
---
name: verify-app
description: Validates application functionality after changes by running tests, builds, and edge case checks.
tools: Read, Glob, Grep, Bash
model: sonnet
max_turns: 20
---

You are a verification agent. Thoroughly validate application functionality after changes.

## Behavior

1. **Identify what changed**: Read git diff or the task description to understand what was modified.
2. **Run tests**: Execute the project's test suite. Report pass/fail with details.
3. **Check the build**: Run the build command. Verify it completes without errors or warnings.
4. **Verify functionality**: For the specific changes made:
   - Check that the intended behavior works
   - Test edge cases (empty input, missing data, error paths)
   - Verify no regressions in related functionality
5. **Report results**: Pass/fail for each check with evidence (command output, file contents).

## Output Format

```
## Verification Report
- Tests: PASS/FAIL (details)
- Build: PASS/FAIL (details)
- Functionality: PASS/FAIL (what was checked)
- Edge cases: PASS/FAIL (what was tested)
```

## Rules
- Do NOT fix issues — only report them. The author fixes.
- Always run actual commands for evidence — never assume tests pass.
- If no test suite exists, note it and focus on build + manual verification.
````

## File: templates/github/copilot-instructions.md
````markdown
# Copilot Instructions

This project uses **Claude Code** as the primary AI assistant.
All coding rules are in `CLAUDE.md`.

## Context
- **MUST READ**: `.agents/context/` for technical documentation (ARCHITECTURE.md, CONVENTIONS.md, STACK.md)
- **MUST READ**: `CLAUDE.md` for project rules and critical coding standards
````

## File: templates/skills/drizzle/prompt.md
````markdown
---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Drizzle ORM

## When to use this skill

Use this skill when:

- Defining database schemas with Drizzle's table/column builders
- Writing type-safe queries with the Drizzle query builder
- Managing database migrations with `drizzle-kit`
- Configuring Drizzle for PostgreSQL, MySQL, or SQLite
- Handling relations between tables
- Optimizing query performance with indexes and joins

## Overview

Drizzle ORM is a TypeScript-first ORM that generates fully type-safe SQL. Unlike ORMs that abstract SQL away, Drizzle keeps queries close to SQL while providing compile-time type checking.

### Core concepts

- **Schema** — TypeScript definitions that describe tables, columns, and relations
- **drizzle()** — creates the database client bound to a connection
- **Query builder** — chainable API: `db.select().from(table).where(...).orderBy(...)`
- **Relational queries** — `db.query.users.findMany({ with: { posts: true } })` — Drizzle-specific high-level API
- **`drizzle-kit`** — CLI for generating and running migrations from schema changes

### Adapter matrix

| Database   | Package              | Import from              |
| ---------- | -------------------- | ------------------------ |
| PostgreSQL | `drizzle-orm/pg-core` | `drizzle-orm/node-postgres` or `drizzle-orm/postgres-js` |
| MySQL      | `drizzle-orm/mysql-core` | `drizzle-orm/mysql2`  |
| SQLite     | `drizzle-orm/sqlite-core` | `drizzle-orm/better-sqlite3` or `drizzle-orm/libsql` |

## Best Practices

### Schema definition

Define all schemas in a `db/schema/` directory, one file per domain:

```ts
// db/schema/users.ts
import { pgTable, uuid, varchar, timestamp, boolean } from 'drizzle-orm/pg-core'

export const users = pgTable('users', {
  id:        uuid('id').defaultRandom().primaryKey(),
  email:     varchar('email', { length: 255 }).notNull().unique(),
  name:      varchar('name', { length: 100 }),
  isActive:  boolean('is_active').notNull().default(true),
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at').notNull().defaultNow(),
})

// Infer TypeScript types from schema
export type User    = typeof users.$inferSelect
export type NewUser = typeof users.$inferInsert
```

### Indexes

Define indexes in the schema to avoid N+1 on frequently filtered columns:

```ts
import { pgTable, uuid, varchar, index, uniqueIndex } from 'drizzle-orm/pg-core'

export const posts = pgTable('posts', {
  id:       uuid('id').defaultRandom().primaryKey(),
  userId:   uuid('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  slug:     varchar('slug', { length: 255 }).notNull(),
  status:   varchar('status', { length: 20 }).notNull().default('draft'),
  // ...
}, (table) => ({
  userIdIdx:    index('posts_user_id_idx').on(table.userId),
  slugUniqueIdx: uniqueIndex('posts_slug_unique_idx').on(table.slug),
  statusIdx:    index('posts_status_idx').on(table.status),
}))
```

### Relations

Declare relations separately from table definitions:

```ts
// db/schema/relations.ts
import { relations } from 'drizzle-orm'
import { users } from './users'
import { posts } from './posts'

export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
}))

export const postsRelations = relations(posts, ({ one }) => ({
  author: one(users, {
    fields: [posts.userId],
    references: [users.id],
  }),
}))
```

### Database client setup

```ts
// db/index.ts
import { drizzle } from 'drizzle-orm/postgres-js'
import postgres from 'postgres'
import * as schema from './schema'

const client = postgres(process.env.DATABASE_URL!)

export const db = drizzle(client, { schema })
```

### Drizzle Kit configuration

```ts
// drizzle.config.ts
import type { Config } from 'drizzle-kit'

export default {
  schema:    './db/schema',
  out:       './db/migrations',
  dialect:   'postgresql',
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
} satisfies Config
```

Migration commands:

```bash
npx drizzle-kit generate   # generate migration files from schema diff
npx drizzle-kit migrate    # apply pending migrations
npx drizzle-kit push       # push schema directly (dev only, no migration files)
npx drizzle-kit studio     # open Drizzle Studio GUI
```

## Common Patterns

### Basic CRUD

```ts
import { db } from '@/db'
import { users } from '@/db/schema/users'
import { eq, and, ilike, desc } from 'drizzle-orm'
import type { NewUser } from '@/db/schema/users'

// SELECT
const allUsers = await db.select().from(users)

// SELECT with filter
const activeUsers = await db
  .select()
  .from(users)
  .where(and(eq(users.isActive, true), ilike(users.email, '%@example.com')))
  .orderBy(desc(users.createdAt))
  .limit(20)

// SELECT specific columns
const emails = await db
  .select({ id: users.id, email: users.email })
  .from(users)

// INSERT
const [newUser] = await db
  .insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' } satisfies NewUser)
  .returning()

// UPDATE
const [updated] = await db
  .update(users)
  .set({ name: 'Bob', updatedAt: new Date() })
  .where(eq(users.id, '123'))
  .returning()

// DELETE
await db.delete(users).where(eq(users.id, '123'))
```

### Relational queries

```ts
// Fetch user with all their posts
const userWithPosts = await db.query.users.findFirst({
  where: eq(users.id, userId),
  with: {
    posts: {
      where: eq(posts.status, 'published'),
      orderBy: [desc(posts.createdAt)],
      limit: 10,
    },
  },
})

// Nested relations
const fullData = await db.query.users.findMany({
  with: {
    posts: {
      with: {
        comments: true,
      },
    },
  },
})
```

### Join queries

```ts
// Explicit join (use when relational queries are insufficient)
const result = await db
  .select({
    userId:    users.id,
    userEmail: users.email,
    postTitle: posts.title,
  })
  .from(users)
  .innerJoin(posts, eq(posts.userId, users.id))
  .where(eq(posts.status, 'published'))
```

### Transactions

```ts
const result = await db.transaction(async (tx) => {
  const [order] = await tx.insert(orders).values({ userId, total }).returning()
  await tx.insert(orderItems).values(
    items.map((item) => ({ orderId: order.id, ...item }))
  )
  await tx
    .update(inventory)
    .set({ stock: sql`${inventory.stock} - ${item.quantity}` })
    .where(eq(inventory.productId, item.productId))
  return order
})
```

### Dynamic queries

```ts
import { SQL, sql } from 'drizzle-orm'

function buildUserQuery(filters: { search?: string; isActive?: boolean }) {
  const conditions: SQL[] = []

  if (filters.search) {
    conditions.push(ilike(users.name, `%${filters.search}%`))
  }
  if (filters.isActive !== undefined) {
    conditions.push(eq(users.isActive, filters.isActive))
  }

  return db
    .select()
    .from(users)
    .where(conditions.length > 0 ? and(...conditions) : undefined)
}
```

### Pagination

```ts
async function paginate(page: number, pageSize = 20) {
  const offset = (page - 1) * pageSize

  const [items, [{ count }]] = await Promise.all([
    db.select().from(posts).limit(pageSize).offset(offset),
    db.select({ count: sql<number>`count(*)::int` }).from(posts),
  ])

  return { items, total: count, page, pageSize }
}
```

### Upsert

```ts
await db
  .insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' })
  .onConflictDoUpdate({
    target: users.email,
    set: { name: 'Alice Updated', updatedAt: new Date() },
  })
```

## Resources

- [Drizzle ORM Docs](https://orm.drizzle.team)
- [Drizzle Kit Migrations](https://orm.drizzle.team/kit-docs/overview)
- [Drizzle Studio](https://orm.drizzle.team/drizzle-studio/overview)
````

## File: templates/skills/pinia/prompt.md
````markdown
---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Pinia State Management

## When to use this skill

Use this skill when:

- Creating or modifying Pinia stores in a Vue 3 or Nuxt 3 project
- Deciding between Options API and Composition API store styles
- Handling async actions, loading states, and error handling in stores
- Persisting store state across page reloads
- Testing Pinia stores in isolation
- Composing multiple stores together

## Overview

Pinia is the official state management library for Vue 3. It replaces Vuex with a simpler API, full TypeScript support, and first-class support for the Composition API.

### Core concepts

- **Store** — a reactive, singleton unit of state + logic, created with `defineStore`
- **State** — reactive data (like `data()` in a component)
- **Getters** — computed values derived from state (like `computed`)
- **Actions** — methods that mutate state or call async APIs (like `methods`)
- **`$patch`** — batch-update multiple state properties atomically
- **`storeToRefs`** — destructure reactive state from a store without losing reactivity

### Two store styles

**Options Store** (familiar to Vuex users):

```ts
export const useCounterStore = defineStore('counter', {
  state: () => ({ count: 0 }),
  getters: {
    doubled: (state) => state.count * 2,
  },
  actions: {
    increment() { this.count++ },
  },
})
```

**Setup Store** (recommended — more flexible, better TypeScript):

```ts
export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubled = computed(() => count.value * 2)
  function increment() { count.value++ }
  return { count, doubled, increment }
})
```

## Best Practices

### File and naming conventions

- One store per file in `stores/` directory
- Name files after the domain: `stores/user.ts`, `stores/cart.ts`
- Export as `use{Domain}Store` — `useUserStore`, `useCartStore`
- Store ID must match the composable name minus `use` and `Store`: `defineStore('user', ...)`

### Structuring a store

```ts
// stores/user.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { User } from '@/types'

export const useUserStore = defineStore('user', () => {
  // State
  const user = ref<User | null>(null)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Getters
  const isLoggedIn = computed(() => user.value !== null)
  const fullName = computed(() =>
    user.value ? `${user.value.firstName} ${user.value.lastName}` : ''
  )

  // Actions
  async function fetchUser(id: string) {
    isLoading.value = true
    error.value = null
    try {
      user.value = await api.getUser(id)
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to fetch user'
    } finally {
      isLoading.value = false
    }
  }

  function reset() {
    user.value = null
    error.value = null
  }

  return { user, isLoading, error, isLoggedIn, fullName, fetchUser, reset }
})
```

### Using a store in components

```vue
<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useUserStore } from '@/stores/user'

const store = useUserStore()

// Destructure reactive state with storeToRefs — keeps reactivity
const { user, isLoading, error } = storeToRefs(store)

// Actions can be destructured directly (they are not reactive values)
const { fetchUser, reset } = store

onMounted(() => fetchUser('123'))
</script>

<template>
  <div v-if="isLoading">Loading...</div>
  <div v-else-if="error" class="text-red-600">{{ error }}</div>
  <div v-else-if="user">Welcome, {{ user.firstName }}</div>
</template>
```

### Always use `storeToRefs` for state destructuring

```ts
// Wrong — loses reactivity
const { user, isLoading } = useUserStore()

// Correct
const { user, isLoading } = storeToRefs(useUserStore())
```

### Batch updates with `$patch`

```ts
// Update multiple properties atomically
store.$patch({
  count: store.count + 1,
  lastUpdated: new Date(),
})

// Function form for complex mutations
store.$patch((state) => {
  state.items.push({ id: Date.now(), name: 'New item' })
  state.count++
})
```

### Cross-store composition

```ts
// stores/cart.ts — uses the user store
import { useUserStore } from './user'

export const useCartStore = defineStore('cart', () => {
  const userStore = useUserStore()
  const items = ref<CartItem[]>([])

  async function checkout() {
    if (!userStore.isLoggedIn) throw new Error('Must be logged in')
    // ...
  }

  return { items, checkout }
})
```

Call stores inside actions — not at the top level — to avoid circular dependency issues during SSR.

### Reset pattern

```ts
export const useFormStore = defineStore('form', () => {
  const initialState = () => ({ name: '', email: '', submitted: false })
  const state = reactive(initialState())

  function reset() {
    Object.assign(state, initialState())
  }

  return { ...toRefs(state), reset }
})
```

## Common Patterns

### Async action with loading/error state

```ts
async function loadProducts() {
  isLoading.value = true
  error.value = null
  try {
    products.value = await fetchProducts()
  } catch (e) {
    error.value = 'Could not load products'
    console.error(e)
  } finally {
    isLoading.value = false
  }
}
```

### Pinia in Nuxt 3

Install `@pinia/nuxt`:

```ts
// nuxt.config.ts
export default defineNuxtConfig({
  modules: ['@pinia/nuxt'],
})
```

Stores work identically. Nuxt auto-imports stores from `stores/` when `@pinia/nuxt` is configured.

For SSR-safe data fetching, combine with `useAsyncData`:

```ts
// pages/products.vue
const store = useProductStore()
await useAsyncData('products', () => store.fetchProducts())
```

### Persisting state (pinia-plugin-persistedstate)

```ts
// stores/auth.ts
export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(null)
  // ...
  return { token, ... }
}, {
  persist: true, // persists entire store to localStorage
})
```

Or selectively:

```ts
}, {
  persist: {
    key: 'auth',
    storage: persistedState.localStorage,
    paths: ['token'], // only persist the token
  },
})
```

### Subscribe to store changes

```ts
const store = useCartStore()

store.$subscribe((mutation, state) => {
  localStorage.setItem('cart', JSON.stringify(state.items))
})
```

### Testing a store

```ts
import { setActivePinia, createPinia } from 'pinia'
import { useUserStore } from '@/stores/user'

describe('useUserStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('sets user on fetchUser', async () => {
    const store = useUserStore()
    vi.spyOn(api, 'getUser').mockResolvedValue({ id: '1', firstName: 'Alice' })

    await store.fetchUser('1')

    expect(store.user?.firstName).toBe('Alice')
    expect(store.isLoading).toBe(false)
  })
})
```

## Resources

- [Pinia Docs](https://pinia.vuejs.org)
- [Nuxt + Pinia](https://pinia.vuejs.org/ssr/nuxt.html)
- [pinia-plugin-persistedstate](https://prazdevs.github.io/pinia-plugin-persistedstate/)
````

## File: templates/skills/tailwind/prompt.md
````markdown
---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Tailwind CSS

## When to use this skill

Use this skill when:

- Adding or modifying styles in a project that uses Tailwind CSS
- Designing responsive layouts with breakpoint utilities
- Building component UIs with utility-first classes
- Creating custom design tokens via `tailwind.config`
- Migrating from CSS/SCSS to Tailwind utility classes
- Debugging unexpected styles or specificity conflicts

## Overview

Tailwind CSS is a utility-first CSS framework. Instead of writing custom CSS, you compose pre-defined utility classes directly in HTML/JSX/templates. The compiler scans source files and generates only the CSS that is actually used.

### Core concepts

- **Utility classes** — single-purpose classes like `flex`, `mt-4`, `text-blue-600`
- **Responsive prefixes** — `sm:`, `md:`, `lg:`, `xl:`, `2xl:` apply utilities at breakpoints (mobile-first)
- **State variants** — `hover:`, `focus:`, `active:`, `disabled:`, `group-hover:`, `peer-focus:`
- **Dark mode** — `dark:` prefix when `darkMode: 'class'` or `darkMode: 'media'` is configured
- **Arbitrary values** — `w-[342px]`, `bg-[#1a2b3c]`, `top-[calc(100%-1rem)]` for one-off values
- **`@apply`** — extracts repeated utility groups into reusable CSS classes (use sparingly)

### Tailwind v3 vs v4

Tailwind v4 (2025) replaces `tailwind.config.js` with CSS-first configuration using `@theme` in a CSS file. Check `package.json` to determine which version is in use before writing configuration.

## Best Practices

### Layout

1. **Use flexbox and grid utilities** — avoid custom `display` CSS; reach for `flex`, `grid`, `grid-cols-{n}`
2. **Gap over margin for spacing in flex/grid** — `gap-4` instead of `margin` on children
3. **Container with `mx-auto`** — `<div class="container mx-auto px-4">` for centred page content
4. **Avoid nesting flex containers unnecessarily** — keep layouts flat for readability

### Responsive design

Apply the smallest breakpoint first (mobile), then layer larger breakpoints:

```html
<!-- Mobile: stacked, md+: side-by-side -->
<div class="flex flex-col md:flex-row gap-4">
  <aside class="w-full md:w-64">...</aside>
  <main class="flex-1">...</main>
</div>
```

Breakpoints:

| Prefix | Min-width |
| ------ | --------- |
| `sm:`  | 640px     |
| `md:`  | 768px     |
| `lg:`  | 1024px    |
| `xl:`  | 1280px    |
| `2xl:` | 1536px    |

### Typography

```html
<h1 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white">Heading</h1>
<p class="text-base text-gray-600 dark:text-gray-300 leading-relaxed">Body text</p>
<span class="text-sm font-medium text-blue-600 hover:text-blue-800">Link</span>
```

### Colors and theming

Use the semantic color scale (50–950). Keep a consistent palette per project:

```js
// tailwind.config.js — extend, never replace
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          50:  '#eff6ff',
          500: '#3b82f6',
          900: '#1e3a8a',
        },
      },
    },
  },
}
```

Access custom colors the same way as defaults: `bg-brand-500`, `text-brand-900`.

### State and interaction

```html
<!-- Button with multiple state variants -->
<button class="
  bg-blue-600 text-white font-semibold px-4 py-2 rounded-lg
  hover:bg-blue-700
  focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
  active:scale-95
  disabled:opacity-50 disabled:cursor-not-allowed
  transition-colors duration-150
">
  Submit
</button>
```

### Group and peer

```html
<!-- group: parent controls child styles -->
<div class="group flex items-center gap-2">
  <span class="text-gray-600 group-hover:text-blue-600 transition-colors">Icon</span>
  <span class="text-gray-800 group-hover:font-semibold">Label</span>
</div>

<!-- peer: sibling controls sibling styles -->
<input id="cb" type="checkbox" class="peer sr-only" />
<label for="cb" class="peer-checked:text-blue-600 peer-checked:font-bold cursor-pointer">
  Toggle me
</label>
```

### Dark mode

```html
<div class="bg-white text-gray-900 dark:bg-gray-900 dark:text-gray-100">
  <p class="text-gray-600 dark:text-gray-400">Secondary text</p>
</div>
```

Enable in config:

```js
module.exports = {
  darkMode: 'class', // toggle via <html class="dark">
}
```

### @apply — use sparingly

Reserve `@apply` for genuine reuse (e.g., button base styles shared across components):

```css
/* Avoid for one-off styles — just use utilities inline */
.btn-primary {
  @apply inline-flex items-center gap-2 px-4 py-2 bg-blue-600 text-white
         font-semibold rounded-lg hover:bg-blue-700 focus:ring-2 focus:ring-blue-500
         transition-colors duration-150;
}
```

## Common Patterns

### Card component

```html
<div class="rounded-xl border border-gray-200 bg-white shadow-sm p-6 dark:border-gray-700 dark:bg-gray-800">
  <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Card title</h2>
  <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">Card description goes here.</p>
  <div class="mt-4 flex items-center justify-between">
    <span class="text-sm font-medium text-blue-600">View more</span>
    <button class="text-xs text-gray-400 hover:text-gray-600">Dismiss</button>
  </div>
</div>
```

### Responsive grid

```html
<ul class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
  <li class="...">Item 1</li>
  <li class="...">Item 2</li>
</ul>
```

### Form input

```html
<div class="flex flex-col gap-1">
  <label for="email" class="text-sm font-medium text-gray-700 dark:text-gray-300">
    Email address
  </label>
  <input
    id="email"
    type="email"
    class="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm
           placeholder-gray-400 shadow-sm
           focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500
           dark:border-gray-600 dark:bg-gray-800 dark:text-white"
    placeholder="you@example.com"
  />
</div>
```

### Sidebar layout

```html
<div class="flex min-h-screen">
  <nav class="w-64 shrink-0 border-r border-gray-200 bg-gray-50 dark:border-gray-700 dark:bg-gray-900 p-4">
    <!-- Sidebar content -->
  </nav>
  <main class="flex-1 overflow-y-auto p-8">
    <!-- Main content -->
  </main>
</div>
```

### Badge / pill

```html
<span class="inline-flex items-center rounded-full bg-green-100 px-2.5 py-0.5 text-xs font-semibold text-green-800 dark:bg-green-900 dark:text-green-200">
  Active
</span>
```

## Tailwind v4 (CSS-first config)

```css
/* app.css — replaces tailwind.config.js */
@import "tailwindcss";

@theme {
  --color-brand-500: #3b82f6;
  --font-sans: "Inter", sans-serif;
  --radius-lg: 0.75rem;
}
```

## Resources

- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [Tailwind UI Components](https://tailwindui.com)
- [Tailwind Play (sandbox)](https://play.tailwindcss.com)
````

## File: templates/skills/tanstack/prompt.md
````markdown
---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# TanStack Query and TanStack Router

## When to use this skill

Use this skill when:

- Fetching, caching, and synchronizing server data with TanStack Query
- Handling loading, error, and stale states for async data
- Implementing optimistic updates and mutations
- Setting up file-based or code-based routing with TanStack Router
- Prefetching data for route transitions
- Using TanStack Query with Vue, React, or Nuxt

## Overview

**TanStack Query** (formerly React Query) manages server state — async data that lives outside the app. It handles caching, background refetching, deduplication, and stale-while-revalidate semantics automatically.

**TanStack Router** is a fully type-safe router for React and Vue with first-class search param support, nested layouts, and built-in data loading.

### Key TanStack Query concepts

- **`useQuery`** — fetch and cache data; returns `{ data, isLoading, isError, error, refetch }`
- **`useMutation`** — trigger writes (POST/PUT/DELETE); returns `{ mutate, isPending, isError }`
- **Query keys** — arrays that uniquely identify a query and drive cache invalidation
- **`invalidateQueries`** — mark cached data stale, triggering background refetch
- **`queryClient`** — the cache manager; typically a singleton provided at the app root
- **staleTime** — how long data is considered fresh (no refetch); `0` = always refetch

## Best Practices

### Query key conventions

Use structured array keys — they enable precise invalidation:

```ts
// Factory pattern — keeps keys consistent across files
const userKeys = {
  all:    () => ['users'] as const,
  lists:  () => ['users', 'list'] as const,
  list:   (filters: UserFilters) => ['users', 'list', filters] as const,
  detail: (id: string) => ['users', 'detail', id] as const,
}

// Usage
useQuery({ queryKey: userKeys.detail(userId), queryFn: () => fetchUser(userId) })

// Invalidate all user queries
queryClient.invalidateQueries({ queryKey: userKeys.all() })

// Invalidate only list queries
queryClient.invalidateQueries({ queryKey: userKeys.lists() })
```

### Separating query functions

Extract query functions into dedicated files for reuse:

```ts
// api/users.ts
export async function fetchUser(id: string): Promise<User> {
  const res = await fetch(`/api/users/${id}`)
  if (!res.ok) throw new Error('Failed to fetch user')
  return res.json()
}

export async function updateUser(id: string, data: Partial<User>): Promise<User> {
  const res = await fetch(`/api/users/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  if (!res.ok) throw new Error('Failed to update user')
  return res.json()
}
```

### Error handling

Always throw on non-OK responses — TanStack Query only treats thrown errors as failures:

```ts
// Correct — throw on failure
async function fetchProducts() {
  const res = await fetch('/api/products')
  if (!res.ok) {
    const body = await res.json().catch(() => ({}))
    throw new Error(body.message ?? `HTTP ${res.status}`)
  }
  return res.json() as Promise<Product[]>
}

// Wrong — returning null/undefined won't trigger error state
async function fetchProducts() {
  const res = await fetch('/api/products')
  if (!res.ok) return null  // DON'T do this
}
```

### staleTime configuration

Set appropriate staleTime per query to avoid unnecessary refetches:

```ts
// Static reference data — refetch every hour
useQuery({
  queryKey: ['countries'],
  queryFn: fetchCountries,
  staleTime: 60 * 60 * 1000,
})

// User-specific data — refetch when tab regains focus (default: 0)
useQuery({
  queryKey: userKeys.detail(userId),
  queryFn: () => fetchUser(userId),
})

// Real-time data — refetch every 30 seconds
useQuery({
  queryKey: ['notifications'],
  queryFn: fetchNotifications,
  staleTime: 0,
  refetchInterval: 30_000,
})
```

## Common Patterns

### React: basic query

```tsx
import { useQuery } from '@tanstack/react-query'
import { fetchUser } from '@/api/users'

function UserProfile({ userId }: { userId: string }) {
  const { data: user, isLoading, isError, error } = useQuery({
    queryKey: ['users', 'detail', userId],
    queryFn: () => fetchUser(userId),
    staleTime: 5 * 60 * 1000, // 5 minutes
  })

  if (isLoading) return <Spinner />
  if (isError) return <ErrorMessage message={error.message} />

  return <div>{user.name}</div>
}
```

### Vue: basic query

```vue
<script setup lang="ts">
import { useQuery } from '@tanstack/vue-query'
import { fetchUser } from '@/api/users'

const props = defineProps<{ userId: string }>()

const { data: user, isLoading, isError, error } = useQuery({
  queryKey: computed(() => ['users', 'detail', props.userId]),
  queryFn: () => fetchUser(props.userId),
})
</script>

<template>
  <div v-if="isLoading">Loading...</div>
  <div v-else-if="isError">{{ error?.message }}</div>
  <div v-else-if="user">{{ user.name }}</div>
</template>
```

### Mutation with cache invalidation

```tsx
import { useMutation, useQueryClient } from '@tanstack/react-query'

function EditUserForm({ user }: { user: User }) {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: (data: Partial<User>) => updateUser(user.id, data),
    onSuccess: (updatedUser) => {
      // Update the cache directly (avoids a refetch)
      queryClient.setQueryData(['users', 'detail', user.id], updatedUser)
      // Also invalidate the list so it stays in sync
      queryClient.invalidateQueries({ queryKey: ['users', 'list'] })
    },
    onError: (error) => {
      console.error('Update failed:', error)
    },
  })

  return (
    <form onSubmit={(e) => {
      e.preventDefault()
      mutation.mutate({ name: e.currentTarget.name.value })
    }}>
      <input name="name" defaultValue={user.name} />
      <button type="submit" disabled={mutation.isPending}>
        {mutation.isPending ? 'Saving...' : 'Save'}
      </button>
      {mutation.isError && <p>{mutation.error.message}</p>}
    </form>
  )
}
```

### Optimistic updates

```ts
const mutation = useMutation({
  mutationFn: (newTodo: Todo) => createTodo(newTodo),
  onMutate: async (newTodo) => {
    await queryClient.cancelQueries({ queryKey: ['todos'] })
    const previous = queryClient.getQueryData<Todo[]>(['todos'])
    queryClient.setQueryData<Todo[]>(['todos'], (old = []) => [...old, { ...newTodo, id: 'temp' }])
    return { previous }
  },
  onError: (_err, _vars, context) => {
    queryClient.setQueryData(['todos'], context?.previous)
  },
  onSettled: () => {
    queryClient.invalidateQueries({ queryKey: ['todos'] })
  },
})
```

### Dependent queries

```ts
const { data: user } = useQuery({
  queryKey: ['users', userId],
  queryFn: () => fetchUser(userId),
})

// Only runs when user is loaded
const { data: orders } = useQuery({
  queryKey: ['orders', user?.id],
  queryFn: () => fetchOrders(user!.id),
  enabled: !!user?.id,
})
```

### Infinite / paginated queries

```ts
const { data, fetchNextPage, hasNextPage, isFetchingNextPage } = useInfiniteQuery({
  queryKey: ['products', filters],
  queryFn: ({ pageParam = 1 }) => fetchProducts({ page: pageParam, ...filters }),
  getNextPageParam: (lastPage) => lastPage.nextPage ?? undefined,
  initialPageParam: 1,
})

// Flatten pages
const products = data?.pages.flatMap((page) => page.items) ?? []
```

### TanStack Router setup (React)

```tsx
// router.tsx
import { createRouter, createRoute, createRootRoute } from '@tanstack/react-router'

const rootRoute = createRootRoute({ component: RootLayout })

const indexRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/',
  component: HomePage,
})

const userRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/users/$userId',
  loader: ({ params }) => fetchUser(params.userId), // prefetch on navigation
  component: UserPage,
})

export const router = createRouter({
  routeTree: rootRoute.addChildren([indexRoute, userRoute]),
})
```

### QueryClient setup

```tsx
// main.tsx (React)
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30 * 1000, // 30 seconds default
      retry: 1,
    },
  },
})

ReactDOM.createRoot(document.getElementById('root')!).render(
  <QueryClientProvider client={queryClient}>
    <App />
  </QueryClientProvider>
)
```

```ts
// plugins/tanstack-query.ts (Nuxt 3)
import { VueQueryPlugin, QueryClient } from '@tanstack/vue-query'

export default defineNuxtPlugin((nuxtApp) => {
  const queryClient = new QueryClient({ defaultOptions: { queries: { staleTime: 30_000 } } })
  nuxtApp.vueApp.use(VueQueryPlugin, { queryClient })
})
```

## Resources

- [TanStack Query Docs](https://tanstack.com/query/latest)
- [TanStack Router Docs](https://tanstack.com/router/latest)
- [TanStack Query DevTools](https://tanstack.com/query/latest/docs/react/devtools)
````

## File: templates/skills/vitest/prompt.md
````markdown
---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Vitest

## When to use this skill

Use this skill when:

- Writing unit tests or integration tests in a Vite-based project
- Mocking modules, functions, timers, or network requests
- Testing Vue components with `@vue/test-utils` and Vitest
- Testing React components with React Testing Library and Vitest
- Measuring test coverage
- Debugging flaky tests or slow test suites

## Overview

Vitest is a Vite-native test runner. It shares the same Vite config (plugins, aliases, transforms) as the app, so setup is minimal. It is API-compatible with Jest, making migration straightforward.

### Core concepts

- **Test files** — `*.test.ts`, `*.spec.ts`, or files inside `__tests__/`
- **`describe` / `it` / `test`** — standard test structure (all interchangeable as top-level)
- **`expect`** — assertion library (same API as Jest)
- **`vi`** — Vitest's utility object: `vi.fn()`, `vi.mock()`, `vi.spyOn()`, `vi.useFakeTimers()`
- **`beforeEach` / `afterEach` / `beforeAll` / `afterAll`** — lifecycle hooks
- **`coverage`** — built-in via `@vitest/coverage-v8` or `@vitest/coverage-istanbul`

## Best Practices

### File co-location

Place test files next to the files they test:

```
src/
  utils/
    format.ts
    format.test.ts
  components/
    UserCard.vue
    UserCard.test.ts
```

### Test structure — Arrange, Act, Assert

```ts
describe('formatCurrency', () => {
  it('formats whole dollars without decimals', () => {
    // Arrange
    const amount = 1000

    // Act
    const result = formatCurrency(amount, 'USD')

    // Assert
    expect(result).toBe('$1,000.00')
  })
})
```

### Naming conventions

- `describe` block: the thing being tested — `formatCurrency`, `UserCard`, `useUserStore`
- `it` / `test` block: reads as a sentence — `it('returns null when list is empty')`
- File: `*.test.ts` for unit tests, `*.spec.ts` for integration/behavior tests (convention only)

### Avoid implementation details

Test behavior, not internals. Prefer `expect(result)` over asserting on private variables.

### One assertion concept per test

```ts
// Bad — multiple unrelated assertions
it('processes form', () => {
  expect(result.name).toBe('Alice')
  expect(result.email).toBe('alice@example.com')
  expect(mockSave).toHaveBeenCalledOnce()
  expect(router.currentRoute.value.path).toBe('/dashboard')
})

// Better — split into focused tests
it('saves form data with correct values', () => {
  expect(mockSave).toHaveBeenCalledWith({ name: 'Alice', email: 'alice@example.com' })
})

it('redirects to dashboard after save', () => {
  expect(router.currentRoute.value.path).toBe('/dashboard')
})
```

## Common Patterns

### Basic unit test

```ts
// src/utils/math.test.ts
import { describe, it, expect } from 'vitest'
import { add, clamp } from './math'

describe('add', () => {
  it('adds two positive numbers', () => {
    expect(add(2, 3)).toBe(5)
  })

  it('handles negative numbers', () => {
    expect(add(-1, 1)).toBe(0)
  })
})

describe('clamp', () => {
  it.each([
    [5,  0, 10, 5],
    [-5, 0, 10, 0],
    [15, 0, 10, 10],
  ])('clamp(%i, %i, %i) = %i', (value, min, max, expected) => {
    expect(clamp(value, min, max)).toBe(expected)
  })
})
```

### Mocking a module

```ts
import { vi, describe, it, expect, beforeEach } from 'vitest'
import { sendEmail } from './notifications'

// Hoist vi.mock — executed before imports
vi.mock('@/lib/mailer', () => ({
  sendMail: vi.fn().mockResolvedValue({ messageId: 'test-123' }),
}))

import { sendMail } from '@/lib/mailer'

describe('sendEmail', () => {
  beforeEach(() => vi.clearAllMocks())

  it('calls sendMail with correct arguments', async () => {
    await sendEmail('alice@example.com', 'Hello')

    expect(sendMail).toHaveBeenCalledOnce()
    expect(sendMail).toHaveBeenCalledWith(
      expect.objectContaining({ to: 'alice@example.com', subject: 'Hello' })
    )
  })
})
```

### Spying on methods

```ts
import { vi, it, expect } from 'vitest'

it('calls console.error on failure', async () => {
  const spy = vi.spyOn(console, 'error').mockImplementation(() => {})

  await riskyFunction()

  expect(spy).toHaveBeenCalledWith(expect.stringContaining('failed'))
  spy.mockRestore()
})
```

### Fake timers

```ts
import { vi, it, expect, beforeEach, afterEach } from 'vitest'

beforeEach(() => vi.useFakeTimers())
afterEach(() => vi.useRealTimers())

it('debounces the callback', async () => {
  const fn = vi.fn()
  const debounced = debounce(fn, 300)

  debounced()
  debounced()
  debounced()

  expect(fn).not.toHaveBeenCalled()

  vi.advanceTimersByTime(300)

  expect(fn).toHaveBeenCalledOnce()
})
```

### Testing Vue components

```ts
// UserCard.test.ts
import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import UserCard from './UserCard.vue'

describe('UserCard', () => {
  it('renders user name and email', () => {
    const wrapper = mount(UserCard, {
      props: { user: { id: '1', name: 'Alice', email: 'alice@example.com' } },
    })

    expect(wrapper.text()).toContain('Alice')
    expect(wrapper.text()).toContain('alice@example.com')
  })

  it('emits delete event when delete button is clicked', async () => {
    const wrapper = mount(UserCard, {
      props: { user: { id: '1', name: 'Alice', email: 'alice@example.com' } },
    })

    await wrapper.find('[data-testid="delete-btn"]').trigger('click')

    expect(wrapper.emitted('delete')).toBeTruthy()
    expect(wrapper.emitted('delete')?.[0]).toEqual(['1'])
  })
})
```

### Testing with Pinia

```ts
import { setActivePinia, createPinia } from 'pinia'
import { useCartStore } from '@/stores/cart'

describe('useCartStore', () => {
  beforeEach(() => setActivePinia(createPinia()))

  it('adds item to cart', () => {
    const store = useCartStore()
    store.addItem({ id: 'p1', name: 'Widget', price: 9.99 })

    expect(store.items).toHaveLength(1)
    expect(store.total).toBeCloseTo(9.99)
  })
})
```

### Mocking fetch / network

```ts
import { vi, it, expect, afterEach } from 'vitest'

const mockFetch = vi.fn()
vi.stubGlobal('fetch', mockFetch)

afterEach(() => mockFetch.mockReset())

it('fetches user data', async () => {
  mockFetch.mockResolvedValueOnce({
    ok: true,
    json: () => Promise.resolve({ id: '1', name: 'Alice' }),
  })

  const user = await fetchUser('1')

  expect(user.name).toBe('Alice')
  expect(mockFetch).toHaveBeenCalledWith('/api/users/1')
})
```

### Coverage configuration

```ts
// vitest.config.ts
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      include: ['src/**/*.{ts,vue}'],
      exclude: ['src/**/*.d.ts', 'src/main.ts'],
      thresholds: {
        lines: 80,
        branches: 75,
        functions: 80,
      },
    },
  },
})
```

Run: `npx vitest run --coverage`

### Snapshot testing

```ts
it('renders the expected HTML structure', () => {
  const wrapper = mount(AlertBanner, { props: { type: 'error', message: 'Oops' } })
  expect(wrapper.html()).toMatchSnapshot()
})
```

Update snapshots: `npx vitest run --update-snapshots`

### Setup file

```ts
// vitest.config.ts
export default defineConfig({
  test: {
    setupFiles: ['./tests/setup.ts'],
  },
})

// tests/setup.ts
import { vi } from 'vitest'
import { config } from '@vue/test-utils'

// Global mocks
vi.mock('@/lib/analytics', () => ({ track: vi.fn() }))

// Global Vue Test Utils config
config.global.stubs = { RouterLink: true, RouterView: true }
```

## Vitest CLI reference

| Command                                | Description                    |
| -------------------------------------- | ------------------------------ |
| `npx vitest`                           | Watch mode (dev)               |
| `npx vitest run`                       | Single run (CI)                |
| `npx vitest run --reporter=verbose`    | Verbose output                 |
| `npx vitest run --coverage`            | Run with coverage report       |
| `npx vitest run path/to/file.test.ts`  | Run a specific test file       |
| `npx vitest run -t "test name"`        | Run tests matching pattern     |
| `npx vitest ui`                        | Open browser UI                |

## Resources

- [Vitest Docs](https://vitest.dev)
- [Vitest API Reference](https://vitest.dev/api/)
- [Vue Test Utils](https://test-utils.vuejs.org)
- [Testing Library](https://testing-library.com)
````

## File: templates/specs/README.md
````markdown
# Spec-Driven Development

Specs are structured task plans created before coding. They live in `specs/` and follow a simple template.

## When to Create a Spec

**Create a spec when:**
- Changes touch 3+ files
- Adding a new feature or module
- Requirements are ambiguous or complex
- Architectural decisions are involved

**Skip specs for:**
- Single-file fixes (typos, CSS tweaks, config changes)
- Bug fixes with obvious root cause
- Documentation-only changes

## Naming Convention

```
NNN-short-description.md
```

Examples: `001-add-user-authentication.md`, `002-refactor-api-layer.md`

## Workflow

### 1. Create a spec

```
/spec "add dark mode support"
```

This runs an integrated workflow:
1. **Challenge phase** — validates the idea, questions assumptions, surfaces edge cases
2. **Spec generation** — creates `specs/NNN-add-dark-mode-support.md` with steps, criteria, and files to modify

### 2. Review and refine

Read the generated spec. Edit steps, acceptance criteria, or files to modify as needed.

### 3. Execute one spec

```
/spec-work NNN
```

Executes the spec step by step, checking off each step as it completes. Sets status to `in-review` when done.

### 4. Execute all specs in parallel

```
/spec-work-all
```

Discovers all draft specs in `specs/`, detects dependencies between them, then executes in parallel waves using **isolated Git worktrees** — one branch per spec, no merge conflicts. Independent specs run simultaneously; dependent specs wait for their dependencies.

### 5. Review and create PR

```
/spec-review NNN
```

Opus reviews all code changes against the spec's acceptance criteria. Three possible verdicts:
- **APPROVED** — spec completed, moved to `specs/completed/`, PR draft prepared
- **CHANGES REQUESTED** — feedback written to spec, status back to `in-progress` for another `/spec-work` pass
- **REJECTED** — spec blocked with explanation

### 6. View the board

```
/spec-board
```

Kanban-style overview of all specs grouped by status with step-level progress (`[3/8]`) and branch info.

## Spec Status Lifecycle

```
draft → in-progress → in-review → completed
                ↑          |
                └──────────┘  (changes requested)
                
Any status → blocked
```

| Status | Meaning |
|---|---|
| `draft` | Planned, not started |
| `in-progress` | Agent is working on it |
| `in-review` | Work done, awaiting review |
| `blocked` | Blocked by dependency or review rejection |
| `completed` | Reviewed and done, moved to `specs/completed/` |

## Directory Structure

```
specs/
  README.md           # This file
  TEMPLATE.md         # Blank spec template
  001-feature-name.md # Draft spec (status: draft)
  002-other-task.md   # In-progress spec (status: in-progress, branch: spec/002-other-task)
  completed/
    000-old-spec.md   # Completed spec
```
````

## File: templates/specs/TEMPLATE.md
````markdown
# Spec: [TITLE]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft | **Branch**: —

## Goal
[One sentence: what is the desired outcome?]

## Context
[Why is this needed? What triggered this task?]

## Steps
- [ ] Step 1: description
- [ ] Step 2: description
- [ ] Step 3: description

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Files to Modify
- `path/to/file` - reason

## Out of Scope
- What is NOT part of this task
````

## File: templates/mcp.json
````json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    }
  }
}
````

## File: .mcp.json
````json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp"
      ]
    }
  }
}
````

## File: repomix.config.json
````json
{
  "output": {
    "filePath": ".agents/repomix-snapshot.md",
    "style": "markdown",
    "compress": true
  },
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "node_modules",
      "dist",
      ".git",
      ".next",
      ".nuxt",
      "coverage",
      ".turbo",
      "*.lock",
      "*.lockb",
      ".agents/repomix-snapshot.md"
    ]
  },
  "security": {
    "enableSecurityCheck": true
  }
}
````

## File: .agents/context/ARCHITECTURE.md
````markdown
# Architecture

## Project Type
CLI tool — bash script that bootstraps Claude Code AI infrastructure into target projects.

## Directory Structure
```
bin/            # Entry point: ai-setup.sh (main script)
lib/            # Modules: core, setup, update, generate, tui, skills, detect, process, plugins
templates/      # Files copied into target projects
  CLAUDE.md     # Base Claude project instructions template
  repomix.config.json  # Repomix snapshot config template
  claude/       # hooks/, settings.json, rules/
  commands/     # Slash command templates
  agents/       # Subagent templates (context-refresher, code-reviewer, etc.)
  specs/        # Spec workflow templates
  github/       # GitHub Copilot instructions
  skills/       # Shopify skill templates
.agents/context/ # Auto-generated session context (this file)
.claude/        # Claude Code config for THIS repo
docs/           # Concept and design-decision docs (CONCEPT.md, DESIGN-DECISIONS.md)
specs/          # Spec-driven dev specs for this project
```

## Setup Flow
```
npx @onedot/ai-setup [--system X] [--with-*]
  |
  ├─ Version check (.ai-setup.json present?)
  |    ├─ Same version → smart update menu
  |    └─ New version → update / clean reinstall / skip
  |
  └─ Fresh install:
       Phase 1: Scaffolding (bash only, no AI)
         - CLAUDE.md, settings.json, hooks, commands, agents, specs
         - repomix.config.json, mcp.json (optional), plugins
       Phase 2: Auto-Init (optional, requires claude CLI)
         - Parallel: CLAUDE.md generation + context file generation
         - Sequential after: skill curation (detect → search → rank → install)
```

## Phase 2: Auto-Init (parallel then sequential)
```
Step 1+2 (parallel):
  CLAUDE.md generation  — reads package.json, README, eslintrc, prettierrc
  Context generation    — reads codebase → STACK.md, ARCHITECTURE.md, CONVENTIONS.md

Step 3 (sequential):
  A: keyword mapping from package.json deps
  B: skills.sh search (parallel curl, 30s timeout)
  C: install count fetch (parallel curl)
  D: Claude Haiku → select top 5
  E: install selected skills
```

## Key Patterns
- **Template copy model**: files copied verbatim, no code generation for deterministic parts
- **Config-aware repomix**: uses `repomix.config.json` if present, inline flags as fallback
- **Update tracking**: `.ai-setup.json` stores checksums; user-modified files backed up before update
- **Hooks**: circuit-breaker (edit-loop protection), context-freshness (stale context detection)
- **Idempotent installs**: all steps check before overwriting; skip if already installed
````

## File: .agents/context/DESIGN-DECISIONS.md
````markdown
# Design Decisions: @onedot/ai-setup

## Bash, Not Node.js

**Decision**: The setup script is written in Bash, not Node.js (despite being an npm package).

**Rationale**: The script runs in environments where Node.js version, package manager, and toolchain are unknown. A Bash script has no runtime dependencies beyond the shell. It runs identically on macOS (bash 3.2), Linux (bash 4+), and CI environments. There is also no compile step, no `node_modules`, and no version mismatch issues.

**Constraint**: The script must be POSIX-compatible where possible. macOS ships with bash 3.2, which lacks many bash 4+ features (no associative arrays, no `mapfile`). Where bash 4+ is required, the script checks the version and falls back gracefully.

## cksum, Not md5

**Decision**: File checksums use `cksum` instead of `md5sum` or `md5`.

**Rationale**: `md5sum` is not available on macOS by default (only `md5`). `md5` is not available on Linux. `cksum` is POSIX-standard and available everywhere. The checksum is used only for change detection (is this file modified?), not for security — cksum is sufficient.

## Templates, Not Generated Content

**Decision**: Hooks, commands, settings, and agents are static templates, not generated per-project.

**Rationale**: Generative content is harder to review, harder to version, and non-deterministic. A developer running the setup tool should know exactly what they are getting. Templates are committed to this repository, visible on GitHub, and updated via version bumps. The generated parts (CLAUDE.md Commands section, context files) are the minimum necessary — the parts that cannot be templated because they require knowledge of the specific project.

## Granular Permissions, Not Bash(*)

**Decision**: `.claude/settings.json` lists explicit bash permissions instead of `Bash(*)`.

**Rationale**: `Bash(*)` allows any shell command, which is a broad surface area for mistakes. Granular permissions mean that common dangerous operations (git push, rm -rf, npm publish) require explicit user approval. This is a safety default — users who want full autonomy can use `claude --dangerously-skip-permissions`.

The permission list is intentionally generous for development operations (git, npm, eslint, prettier, grep, curl) while blocking operations that are hard to reverse or affect shared state.

## Claude Haiku for Skill Curation

**Decision**: Skill selection uses Claude Haiku (not Sonnet or Opus).

**Rationale**: Skill curation is a ranking task with structured input (list of skills + install counts) and simple output (top 5 picks). It does not require reasoning depth. Haiku is fast (< 5s), cheap, and accurate enough for this task. Using a more capable model would add cost and latency for no quality gain.

**Fallback**: If Haiku times out or Claude is unavailable, the script falls back to installing the top 3 skills by install count, without AI curation. This ensures skills are always installed even in offline or rate-limited environments.

## Auto-Init is Optional

**Decision**: Auto-Init (the AI-powered generation phase) is opt-in, not required.

**Rationale**: Auto-Init requires the Claude CLI to be installed and authenticated. Many teams may run the setup in CI, on new machines, or before Claude is configured. The scaffolding (Phase 1) is always useful regardless of AI availability. Separating the two phases means the tool always succeeds, even when the AI layer is unavailable.

## Parallel Context Generation

**Decision**: CLAUDE.md generation and context file generation run in parallel during Auto-Init.

**Rationale**: The two tasks are independent. CLAUDE.md generation reads config files (package.json, eslintrc, prettierrc). Context generation reads the full codebase. Running them in parallel cuts Auto-Init time roughly in half. The skill curation step runs after both complete because it uses the context files to make better selections.

## No Build Step

**Decision**: The npm package has no build step. The Bash script is published directly.

**Rationale**: A build step would add complexity (transpiler config, CI build, watch mode) for no benefit. Bash scripts do not need compilation. The `bin/ai-setup.sh` file is the source and the artifact — there is nothing to build.

## Context Files Referenced by CLAUDE.md

**Decision**: `.agents/context/*.md` files are not auto-injected — they are referenced in CLAUDE.md.

**Rationale**: Claude always reads CLAUDE.md at session start. CLAUDE.md contains explicit `@path` references to the context files, which triggers Claude to read them. This makes context loading deterministic and visible. An alternative (auto-injecting context files into settings.json) would make context loading implicit and harder to debug.

## Spec-Driven Development Included

**Decision**: The spec workflow (`specs/`, `/spec`, `/spec-work`) is included in the scaffolding.

**Rationale**: The spec workflow is the recommended pattern for using this tool in real projects — it's how this tool itself is developed. Including it in the scaffolding means every project that uses `@onedot/ai-setup` gets the same structured workflow out of the box, without requiring the developer to discover it separately.
````

## File: .claude/agents/context-refresher.md
````markdown
---
name: context-refresher
description: Regenerates .agents/context/ files (STACK.md, ARCHITECTURE.md, CONVENTIONS.md) when project config has changed.
tools: Read, Write, Glob, Bash
model: haiku
max_turns: 15
---

You are a context generation agent. Your job is to analyze the project and write accurate context files to `.agents/context/`.

## Behavior

1. **Gather project info**: Read `package.json`, `README.md` (if exists), `tsconfig.json`, `.eslintrc*`, `prettierrc*` (if they exist). Run `ls -la` and scan the top-level directory structure.
2. **Sample source files**: Read 3-5 representative source files to understand conventions and architecture.
3. **Write exactly 3 files**:

**`.agents/context/STACK.md`** — runtime, framework (with versions), key dependencies (categorized: UI, state, data, testing, build), package manager, build tooling, libraries/patterns to avoid.

**`.agents/context/ARCHITECTURE.md`** — project type, directory structure, entry points, data flow, key patterns, how the pieces connect.

**`.agents/context/CONVENTIONS.md`** — naming patterns, import style, component structure, error handling, TypeScript usage, testing patterns. Be specific — actual patterns found in code, not generic advice.

4. **Update state file**: After writing the 3 files, run:
```bash
echo "PKG_HASH=$(cksum package.json 2>/dev/null | cut -d' ' -f1,2)" > .agents/context/.state
echo "TSCONFIG_HASH=$(cksum tsconfig.json 2>/dev/null | cut -d' ' -f1,2)" >> .agents/context/.state
```

5. **Generate repomix snapshot** (optional, best-effort): Run:
```bash
_t=""; command -v timeout &>/dev/null && _t="timeout 120"; command -v gtimeout &>/dev/null && _t="gtimeout 120"
if [ -f "repomix.config.json" ]; then
  $_t npx -y repomix 2>/dev/null
else
  $_t npx -y repomix --compress --style markdown \
    --ignore "node_modules,dist,.git,.next,.nuxt,coverage,.turbo,*.lock,*.lockb" \
    --output .agents/repomix-snapshot.md 2>/dev/null
fi
```
If this fails or times out, skip silently — the 3 context files are the primary output.

## Rules
- Keep each file under 80 lines — terse and factual, no padding.
- Write only what you observed, not what you assumed.
- Overwrite existing files completely — do not append.
- Do NOT read `.env` files.
- The repomix snapshot is optional — never block or fail because of it.
````

## File: .claude/agents/perf-reviewer.md
````markdown
---
name: perf-reviewer
description: Reviews code changes for performance issues. Reports findings with HIGH/MEDIUM confidence and a FAST/CONCERNS/SLOW verdict.
tools: Read, Glob, Grep, Bash
model: sonnet
max_turns: 15
memory: project
---

You are a performance reviewer. Your job is to analyze code changes and report performance issues — do NOT fix them.

## Behavior

1. **Get the diff**: Run `git diff` for uncommitted changes, or `git diff main...HEAD` if on a branch.
2. **Read changed files fully**: For each changed file, read the complete file to understand context.
3. **Analyze for performance issues** across these categories:

   **Database & I/O**
   - N+1 queries: loops that trigger individual DB queries per iteration
   - Missing indexes: queries on un-indexed columns
   - Unbounded queries: no LIMIT clause on potentially large result sets
   - Synchronous I/O in hot paths

   **Memory**
   - Memory leaks: event listeners not removed, intervals not cleared, closures retaining references
   - Large allocations in loops: objects/arrays created inside tight loops
   - Unbounded caches: maps/sets that grow without eviction

   **Frontend / React**
   - Unnecessary re-renders: missing `useMemo`, `useCallback`, `React.memo`
   - Large bundle imports: `import _ from 'lodash'` instead of `import debounce from 'lodash/debounce'`
   - Expensive operations in render: sorting/filtering without memoization

   **Algorithms**
   - O(n²) or worse: nested loops over large datasets
   - Repeated work: same computation performed multiple times without caching

4. **Report findings** with confidence levels. Only report HIGH and MEDIUM confidence issues.

## Output Format

```
## Performance Review

### Issues Found
- [HIGH/MEDIUM] File:line — description, expected impact (e.g. "N+1 query in user loop — O(n) DB calls per request")

### Verdict
FAST / CONCERNS / SLOW

Reason: one sentence
```

## Rules
- Do NOT make any changes. Only report.
- Read the actual code — never speculate about what might be slow.
- If no issues found, say "No performance issues found" and verdict is FAST.
- CONCERNS = medium issues only. SLOW = at least one HIGH issue.
- Focus on measurable impact — skip micro-optimizations that don't matter in practice.
````

## File: .claude/agents/test-generator.md
````markdown
---
name: test-generator
description: Generates missing tests for changed files. Detects the project test framework and writes tests only into test directories.
tools: Read, Write, Glob, Grep, Bash
model: sonnet
max_turns: 20
isolation: worktree
---

You are a test generator. Your job is to write missing tests for recently changed code.

## HARD CONSTRAINT

You may ONLY write files inside these directories:
- `test/`
- `tests/`
- `__tests__/`
- `spec/`
- `src/**/__tests__/` (co-located tests)
- `src/**/*.test.*` (co-located test files)
- `src/**/*.spec.*` (co-located spec files)

Do NOT write or modify any file outside these paths. If you are unsure whether a path is a test path, skip it.

## Behavior

1. **Get the diff**: Run `git diff` for uncommitted changes, or `git diff main...HEAD` if on a branch. Identify all changed source files (exclude test files themselves).

2. **Detect test framework**:
   - Check `package.json` for: `jest`, `vitest`, `mocha`, `ava`, `jasmine`, `playwright`, `cypress`
   - Find existing test files with Glob patterns `**/*.test.*` and `**/*.spec.*` (exclude node_modules) to confirm patterns
   - Read one existing test file to understand import style, assertion style, and mocking patterns

3. **Identify untested paths**: For each changed source file:
   - Read the full file
   - List exported functions, classes, and components
   - Check if a corresponding test file already exists
   - Identify which exports lack test coverage in the existing tests

4. **Generate tests**:
   - Write tests following the exact style and patterns of existing tests in the project
   - Use the same import syntax (ESM/CJS), the same assertion library, the same mocking approach
   - Cover: happy path, error/edge cases, boundary conditions
   - Keep tests focused and independent — no shared mutable state between tests
   - Add a comment at the top: `// Generated by test-generator agent — review before committing`

5. **Report**: List all files written and what they cover.

## Output Format

```
## Test Generation Report

### Framework Detected
- Framework: [jest/vitest/mocha/etc]
- Pattern: [test/*.test.ts / src/**/__tests__/*.ts / etc]

### Tests Written
- `test/foo.test.ts` — covers: functionA (happy path, null input), functionB (error case)

### Skipped
- `src/bar.ts` — reason (e.g. "test file already exists and covers all exports")

### Verdict
DONE / PARTIAL / SKIPPED

Reason: one sentence
```

## Rules
- NEVER write outside test directories (see HARD CONSTRAINT above).
- For co-located tests: before writing, verify the target filename ends with `.test.*` or `.spec.*` — never write a file without these suffixes.
- NEVER modify existing test files — only create new ones.
- If no test framework is detected, report it and stop.
- If an existing test file already covers the changed code, skip it and note why.
- Generated tests must run without modification — use real imports, not pseudocode.
- Always add the `// Generated by test-generator agent` comment at the top of each file.
````

## File: .claude/commands/analyze.md
````markdown
---
model: sonnet
allowed-tools: Read, Glob, Grep, Bash, Agent
---

Produces a structured codebase overview via 3 parallel agents. Use when exploring or preparing for major changes.

## Process

### 1. Launch 3 agents simultaneously

Spawn all three agents at the same time using the Agent tool in parallel:

**Agent 1 — Architecture**

```
You are an Architecture exploration agent. Analyze this codebase and report:

1. Read `.agents/context/ARCHITECTURE.md` if it exists — use it as the starting point.
2. Identify entry points (main files, index files, CLI entrypoints, server bootstraps).
3. Trace the primary data flow from input to output.
4. Map module/package boundaries and their responsibilities.
5. Identify key abstractions (base classes, interfaces, core utilities, shared types).
6. Note the directory structure and what lives where.

Return a concise report under the heading: ## Architecture
Include sub-sections: Entry Points, Data Flow, Module Boundaries, Key Abstractions.
Keep it factual and dense — no padding.
```

**Agent 2 — Hotspots**

```
You are a Hotspots exploration agent. Find the most active and complex areas of this codebase:

1. Run: git log --format="%f" | sort | uniq -c | sort -rn | head -20
   List the top 20 most-changed files with their change counts.
2. Find the 10 largest files by line count (use: find . -name "*.{js,ts,py,rb,go,sh}" -not -path "*/node_modules/*" -not -path "*/.git/*" | xargs wc -l 2>/dev/null | sort -rn | head -15).
3. Identify complex areas: deeply nested functions, files with many responsibilities, long functions.
4. Note any files that appear in both "most changed" and "largest" — these are highest-risk hotspots.

Return a concise report under the heading: ## Hotspots
Include sub-sections: Most Changed Files, Largest Files, Complexity Areas.
```

**Agent 3 — Risks**

```
You are a Risk exploration agent. Find quality issues and risk areas in this codebase:

1. Search for TODO/FIXME/HACK/XXX comments: grep -rn "TODO\|FIXME\|HACK\|XXX" --include="*.{js,ts,py,rb,go,sh,md}" --exclude-dir={node_modules,.git,dist,build} . 2>/dev/null | head -40
2. Look for dead code patterns: exported symbols never imported, commented-out code blocks.
3. Check for missing error handling: unhandled promise rejections, bare catch blocks, unchecked return values.
4. Identify inconsistent naming: mixed camelCase/snake_case, inconsistent file naming conventions.
5. Note any security-adjacent patterns: hardcoded strings that look like credentials, unvalidated inputs.

Return a concise report under the heading: ## Risks
Include sub-sections: TODOs/FIXMEs, Dead Code, Error Handling Gaps, Naming Inconsistencies.
```

### 2. Synthesize results

After all 3 agents return, combine their output into a single structured report:

```
## Architecture
[Agent 1 output]

## Hotspots
[Agent 2 output]

## Risks
[Agent 3 output]

## Recommendations
[Derive 3-5 actionable recommendations based on the findings above:
 - Address the highest-risk hotspots first
 - Resolve critical TODOs/FIXMEs
 - Fix missing error handling in high-traffic code paths
 - Standardize naming where inconsistencies were found
 - Any architectural improvements suggested by the data flow analysis]
```

## Rules

- Launch all 3 agents simultaneously — do not wait for one before starting the next.
- Each agent works independently — no shared state between them.
- The report is output only — do not write it to a file unless the user asks.
- Keep each section dense and factual; omit padding and filler phrases.
- If a command fails (e.g. git not available), note it and continue with available data.
````

## File: .claude/commands/challenge.md
````markdown
---
model: sonnet
allowed-tools: Read, Glob, Grep
---

Challenge and critically evaluate this feature idea before any implementation: **$ARGUMENTS**

## Process

### Phase 1 — Restate the Idea
Summarize the proposed feature in 1-2 sentences in your own words to confirm understanding.

### Phase 2 — Concept Fit
Read `.agents/context/CONCEPT.md` now. Then answer:
- Does this align with the project's core principles: **one command, zero config, template-based**?
- Does it fit the "templates not generation" distinction?
- Would this belong in the scaffolding layer, or is it scope creep?

Rate concept fit: **ALIGNED / BORDERLINE / MISALIGNED**

### Phase 3 — Necessity
Is this actually needed? Challenge it hard:
- What problem does it solve? Is that problem real or hypothetical?
- What happens if we don't build it? Can users work without it?
- Is this solving a problem that users have reported, or a problem we imagined?

### Phase 4 — Overhead & Maintenance Cost
- How much ongoing maintenance does this add?
- Does it increase the surface area of the tool (more flags, more config, more docs)?
- What breaks if this feature has a bug?
- Does it add complexity that slows down the "one command" promise?

### Phase 5 — Complexity & Risks
- How many files need to change?
- Does this require new dependencies?
- What edge cases or failure modes exist?
- Does this interact with hooks, agents, or the CLI in unexpected ways?

### Phase 6 — Simpler Alternatives
List 1-3 alternatives, including:
- A simpler version of the same idea (scope reduction)
- A workaround that avoids building anything new
- **"Don't build it"** — explicitly state this as an option if it applies

Also scan the codebase with Glob and Grep to check if similar functionality already exists.

### Phase 7 — Verdict

Choose exactly one:

**GO** — Concept fits, clearly needed, manageable complexity. Recommend proceeding.

**SIMPLIFY** — The idea has merit but the proposed scope is too large. State the smaller version worth building.

**REJECT** — Misaligned with concept, unnecessary, or adds unjustified overhead. State the reason explicitly.

---

## Rules
- Be direct and skeptical. The default stance is skepticism, not encouragement.
- Do NOT modify any files.
- Cite specific lines from `.agents/context/CONCEPT.md` when evaluating concept fit.
- The verdict must be unambiguous — no "it depends" conclusions.
````

## File: .claude/commands/commit.md
````markdown
---
model: haiku
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

Stages changes and creates a conventional commit message. Use when work is ready and a well-scoped message is needed.

## Context

- Current status: `!git status`
- Staged changes: `!git diff --staged`
- Unstaged changes: `!git diff`
- Recent commits: `!git log --oneline -5`

## Process

1. Analyze the changes shown in Context above — determine if this is a new feature, enhancement, bug fix, refactor, test, or docs update.
2. Stage relevant files by name (`git add <file>...`). Do NOT use `git add -A` or `git add .` — avoid accidentally staging secrets or binaries.
3. Write a concise conventional commit message (1-2 sentences) focusing on **why**, not what.
4. Commit. Do NOT push. Do NOT use `--no-verify`.

## Post-Commit

After a successful commit, suggest:
> "Run `/reflect` to capture any learnings from this session before they leave context."

## Rules
- Never stage `.env`, credentials, or large binaries.
- Never push — only commit locally.
- Never skip hooks (`--no-verify`).
- If there are no changes, say so and stop.
````

## File: .claude/commands/context-full.md
````markdown
---
model: sonnet
allowed-tools: Bash, Read
---

Generates a compressed full-codebase snapshot via repomix. Use before large refactors or architecture reviews.

## Steps

1. **Run repomix** with tree-sitter compression:

```bash
_t=""; command -v timeout &>/dev/null && _t="timeout 120"; command -v gtimeout &>/dev/null && _t="gtimeout 120"
$_t npx -y repomix --compress --style markdown \
  --ignore "node_modules,dist,.git,.next,.nuxt,coverage,.turbo,*.lock,*.lockb" \
  --output .agents/repomix-snapshot.md
```

If repomix fails (not available, permission error), report the error and stop.

2. **Report token count**: After completion, run:

```bash
wc -l .agents/repomix-snapshot.md
```

Report: "Snapshot written to `.agents/repomix-snapshot.md` — [N] lines."

3. **Read the snapshot** and give a 3-5 sentence summary of what the codebase contains: key modules, entry points, notable patterns.

## Rules

- Do NOT read every file manually — repomix handles the aggregation.
- Do NOT commit `.agents/repomix-snapshot.md` — it is gitignored.
- The snapshot is a read-only artifact. Do not modify it.
- If `.agents/repomix-snapshot.md` already exists and is less than 30 minutes old (check mtime), skip re-generation and report "Using cached snapshot."
````

## File: .claude/commands/pr.md
````markdown
---
model: haiku
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep, Agent
---

Drafts a pull request with staff review and PR body. Use when a feature branch is ready to be submitted for review.

## Context

- Current status: `!git status`
- Unstaged changes: `!git diff`
- Commits ahead of main: `!git log --oneline main..HEAD`
- Current branch: `!git branch --show-current`

## Process

1. **Build validation**: Spawn `build-validator` via Agent tool.
   - If build-validator returns **FAIL**: stop immediately and tell the user: "Fix the build before creating a PR." Show the build output. Do not proceed.
   - If build-validator returns **PASS**: continue.
2. Analyze the changes shown in Context above to understand all modifications on this branch.
3. Stage and commit any remaining uncommitted changes (descriptive message, no `git add .`).
4. **Staff review**: Spawn `staff-reviewer` via Agent tool with the prompt:
   > "Review this branch for production readiness before PR creation. Branch: <branch-name>. Recent commits: <commits from git log --oneline main..HEAD>."
   - If staff-reviewer returns **APPROVE**: continue drafting PR normally; note "Staff review: APPROVED" in the output.
   - If staff-reviewer returns **APPROVE WITH CONCERNS**: continue drafting PR; include the concerns under `## Staff Review Concerns` in the PR body.
   - If staff-reviewer returns **REQUEST CHANGES**: stop, show the reviewer's concerns, and tell the user: "Fix the reported issues before creating the PR."
5. Draft the PR title (short, under 70 chars) and body (`## Summary` with 2-3 bullets + `## Test plan` checklist).
6. Show the user the PR details and the commands to run:
   ```
   git push -u origin <branch>
   gh pr create --title "..." --body "..."
   ```
7. Do NOT push or create the PR — the user does this manually.

## Post-PR

After presenting the PR commands to the user, suggest:
> "Run `/reflect` to capture any learnings from this session before they leave context."

## Rules
- Never push (`git push` is denied by settings).
- Never push to main/master directly.
- If the branch is `main` or `master`, stop and ask the user to create a feature branch first.
- If `gh` CLI is not installed, provide the GitHub URL for manual PR creation.
````

## File: .claude/commands/reflect.md
````markdown
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

Read `CLAUDE.md`, `.agents/context/CONVENTIONS.md`, `.agents/context/ARCHITECTURE.md`, and `.agents/context/STACK.md` first to avoid duplicates.

For each signal, draft a rule or fact addition:
- Maximum 1-2 lines per entry
- Corrections/affirmations: phrase as a directive ("Always X", "Never Y", "Use X instead of Y")
- Architectural findings: phrase as a factual statement ("Component X depends on Y", "All API calls route through Z")
- Stack findings: phrase as a factual statement ("Requires Node >= 18", "Uses pnpm as package manager")
- Do NOT duplicate content already present in the target file

If no actionable signals were found in this session, report that clearly and stop.

### 4. Show proposed changes for approval
Use AskUserQuestion to present the proposed additions and ask for approval before writing anything.
Format the proposal as a diff preview showing exactly what will be appended to each file.
Example:
```
Proposed additions from this session:

File: .agents/context/CONVENTIONS.md
+ Always use kebab-case for script filenames

File: CLAUDE.md (Critical Rules)
+ Never modify template files directly — use generation logic instead

Apply the same format for `.agents/context/ARCHITECTURE.md` and `.agents/context/STACK.md` when needed.

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
````

## File: .claude/commands/spec-board.md
````markdown
---
model: haiku
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
````

## File: .claude/commands/spec-work-all.md
````markdown
---
model: sonnet
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

Executes all draft specs in parallel using isolated worktrees. Use to batch-implement multiple independent specs.

## Process

### 1. Discover draft specs
Scan `specs/` for all `NNN-*.md` files (excluding `specs/completed/`). Only pick specs with `Status: draft`. Read each spec's Goal and Out of Scope to build a dependency map.

### 2. Dependency detection
A spec is **dependent** on another if its "Out of Scope" section explicitly names another spec number (e.g. "Spec 010", "spec 009"). Dependent specs must run after the spec they reference.

Group specs into:
- **Parallel group**: specs with no dependencies on each other
- **Sequential queue**: specs that depend on a parallel spec (run after their dependency completes)

### 3. Execute in waves

#### Wave setup — before launching subagents
For each spec in the current wave:

1. Derive branch name: `spec/NNN-title` (lowercase, hyphens, from spec filename without `.md`)
2. Update spec header in the **main working directory** spec file:
   - Set `**Status**: in-progress`
   - Set `**Branch**: spec/NNN-title`

#### Wave execution — parallel subagents
Launch one Agent subagent per spec simultaneously using `isolation: "worktree"`. Each subagent receives:
**Prompt for each subagent:**
```
Execute this spec. You are running in an isolated Git worktree.
Do first:
1. Rename the current branch to `spec/NNN-title`:
   git branch -m spec/NNN-title
2. Get the main repo path (the parent of this worktree):
   MAIN_REPO=$(git worktree list | head -1 | awk '{print $1}')
3. Copy .env files from the main repo (skip .env.example and .env.template):
   for f in "$MAIN_REPO"/.env*; do
     [[ -f "$f" ]] || continue
     base=$(basename "$f")
     [[ "$base" == ".env.example" || "$base" == ".env.template" ]] && continue
     cp "$f" . 2>/dev/null || echo "⚠️  Could not copy $base — continuing"
   done
4. Install dependencies if a lockfile exists (run from worktree root):
   if [ -f "bun.lockb" ]; then bun install --frozen-lockfile 2>/dev/null || echo "⚠️  bun install failed"
   elif [ -f "package-lock.json" ]; then npm ci 2>/dev/null || echo "⚠️  npm ci failed"
   elif [ -f "pnpm-lock.yaml" ]; then pnpm install --frozen-lockfile 2>/dev/null || echo "⚠️  pnpm install failed"
   elif [ -f "yarn.lock" ]; then yarn install --frozen-lockfile 2>/dev/null || echo "⚠️  yarn install failed"
   fi
Then follow the `/spec-work` process for this spec inside the worktree: read context, load referenced skills, execute each step in order, verify acceptance criteria, then commit with `git add -A && git commit -m "spec(NNN): [spec title]"`.
Spec content:
[full spec content here]
```

#### Wave post-processing — after each subagent returns
For each completed subagent, using the branch and worktree path from the Agent result:

1. Check all spec steps off in `specs/NNN-*.md`
2. Mark all acceptance criteria as checked
3. Set spec status to `in-review`
4. Prepend CHANGELOG entry under `## [Unreleased]`:
   - Add: `- **Spec NNN**: [Title] — [1-sentence summary]`
   - Insert after the `## [Unreleased]` heading
5. Remove the worktree (branch is preserved for `/spec-review`):
   `git worktree remove --force <worktree-path-from-agent-result>`

**Wave 2+**: After each wave completes, launch the next wave of specs that are now unblocked.

### 4. Final summary
After all waves complete, report:
- Completed specs (with spec ID, title, and branch name)
- Failed specs (with spec ID and reason)
- Total: N completed, M failed
- Next step: `Run /spec-review NNN for each completed spec, or /spec-board for overview`

## Rules
- Follow each spec exactly — no scope creep
- If a step in a spec is blocked or unclear, mark it unchecked and continue remaining steps
- If `specs/` has no draft specs, report "No draft specs found" and stop
- If an Agent subagent fails, mark the spec as `blocked` and report the error
````

## File: .claude/commands/spec-work.md
````markdown
---
model: sonnet
disable-model-invocation: true
argument-hint: "[spec number]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion, Agent
---

Executes spec $ARGUMENTS step by step and verifies acceptance criteria. Use to implement a single approved spec.

## Process

1. **Find the spec**: If `$ARGUMENTS` is a number (e.g. `001`), open `specs/001-*.md`. If it's a filename, open that directly. If empty, list all draft specs in `specs/` and ask which one to work on.

2. **Read the spec** and understand Goal, Steps, and Files to Modify.

3. **Branch setup**: Ask the user whether to create a new branch before starting work.
   - Derive the branch name from the spec filename: `spec/NNN-title` (lowercase, hyphens, strip `.md`)
   - If user says yes: run `git checkout -b spec/NNN-title`. If the branch already exists, offer to switch to it with `git checkout spec/NNN-title`.
   - Update the spec header: set `**Branch**: spec/NNN-title` (or `—` if no branch created).

4. **Read project context**: Skim `.agents/context/CONVENTIONS.md` and `.agents/context/STACK.md` to follow project patterns and use correct libraries.

5. **Load relevant skills**: If the spec's Context section mentions skills, read `.claude/skills/<name>/SKILL.md` for each and apply throughout execution. Skip if none listed.

6. **Architectural review** (high-complexity specs only): Check if the spec header contains `**Complexity**: high`. If yes, spawn the `code-architect` agent via Agent tool, passing the full spec content as the prompt. Then:
   - If the verdict is **REDESIGN**: stop immediately, report all concerns to the user, and do not proceed.
   - If the verdict is **PROCEED WITH CHANGES**: report the concerns to the user, then continue.
   - If the verdict is **PROCEED**: continue normally.

7. **Start work**: Update the spec header — set `**Status**: in-progress`.

8. **Output progress checklist**: Before executing, print a checklist of all steps found in the spec:
   ```
   Progress — Spec NNN
   [ ] Step 1: <title>
   [ ] Step 2: <title>
   ...
   ```
   Check off each item (`[x]`) as you complete it so the user can follow along.

9. **Execute each step** in order:
   - Implement the change
   - After completing a step, edit the spec file to check it off: `- [ ]` -> `- [x]`
   - Update the printed progress checklist to reflect the completed step
   - If a step is blocked or unclear, stop and ask the user

10. **Verify acceptance criteria**: After all steps are done, check each acceptance criterion. Mark them as checked in the spec.

11. **Update CHANGELOG.md**: Add an entry to the `## [Unreleased]` section in `CHANGELOG.md`:
    - Find the `## [Unreleased]` heading (it's just below the `<!-- Entries are prepended below this line, newest first -->` comment)
    - Insert after `## [Unreleased]`: `- **Spec NNN**: [Spec title] — [1-sentence summary of what changed]`
    - Do NOT create date headings — entries accumulate under [Unreleased] until `/release` is run

12. **Verify implementation**: Spawn `verify-app` via Agent tool with the prompt:
    > "Verify that the implementation for spec NNN is correct. Check if the project has a test suite and run it. Check if there is a build command and run it. Report PASS or FAIL."
    - If verify-app returns **PASS**: continue to the next step.
    - If verify-app returns **FAIL**: trigger the **Haiku Investigator** (exactly once — never in a loop):

    > **Haiku Investigator** — spawn a sub-agent with these constraints:
    > - Model: haiku | Allowed tools: Read, Glob, Grep, Bash (read-only: `cat`, `ls`, `grep`, `find`) | **Forbidden: Write, Edit**
    > - Prompt: "Diagnose this build/test failure. Read the error output and relevant source files. Identify the root cause. Output: (1) root cause in one sentence, (2) the specific line(s) to fix, (3) exact fix to apply. Do NOT edit any files."
    > - Pass the full verify-app error output to the investigator.
    
    Apply the investigator's suggested fix as a **single targeted edit**, then run verify-app once more.
    - If the second verify-app returns **PASS**: continue normally.
    - If the second verify-app returns **FAIL**: set status to `in-review`, report the investigator's diagnosis and remaining error, **stop**. Do NOT proceed to step 13 (code-reviewer). Do NOT run the investigator again. Suggest: `Fix the reported issues and re-run /spec-work NNN`.

13. **Auto-review**: Spawn the `code-reviewer` agent via Agent tool to review the changes. Pass the spec content and the current branch name so the agent can run the correct diff.
    - If verdict is **FAIL**: set status to `in-review`. Report the issues. Suggest: `Run /spec-review NNN to review manually.`
    - If verdict is **PASS** or **CONCERNS**: set status to `completed`, move spec file `specs/NNN-*.md` → `specs/completed/NNN-*.md`. Report: "Auto-review passed. Spec NNN completed."

## Rules
- Follow the spec exactly — nothing outside the Steps and within scope.
- Check off each step in the spec file as you complete it (progress tracking).
- If a step fails or is blocked, leave it unchecked, set status to `blocked`, and ask the user.
- Commit after logical groups of changes, not after every single step.
- If called with `--complete` flag, skip steps 12-13: set status directly to `completed` and move to `specs/completed/` (legacy behavior).
````

## File: .claude/hooks/context-freshness.sh
````bash
#!/bin/bash
# context-freshness.sh — UserPromptSubmit hook
# Warns when .agents/context/ files may be outdated (package.json or tsconfig changed)
# Silent pass when up-to-date or state file missing (~10ms runtime, no API calls)
#
# Cache note: Warning is injected as stderr output (shown as a system message in Claude's turn),
# NOT by editing CLAUDE.md. This preserves the prompt cache prefix — editing static layers
# mid-session would invalidate the cache for all subsequent turns.

STATE_FILE=".agents/context/.state"
[ ! -f "$STATE_FILE" ] && exit 0

# Read stored hashes
STORED_PKG=""
STORED_TSC=""
while IFS='=' read -r key val; do
  case "$key" in
    PKG_HASH) STORED_PKG="$val" ;;
    TSCONFIG_HASH) STORED_TSC="$val" ;;
  esac
done < "$STATE_FILE"

CHANGED=""

# Compare package.json
if [ -n "$STORED_PKG" ] && [ -f "package.json" ]; then
  CURRENT_PKG=$(cksum package.json 2>/dev/null | cut -d' ' -f1,2)
  [ "$CURRENT_PKG" != "$STORED_PKG" ] && CHANGED="package.json"
fi

# Compare tsconfig.json
if [ -n "$STORED_TSC" ] && [ -f "tsconfig.json" ]; then
  CURRENT_TSC=$(cksum tsconfig.json 2>/dev/null | cut -d' ' -f1,2)
  [ "$CURRENT_TSC" != "$STORED_TSC" ] && CHANGED="${CHANGED:+$CHANGED, }tsconfig.json"
fi

if [ -n "$CHANGED" ]; then
  echo "[CONTEXT STALE] Project context may be outdated ($CHANGED changed since last setup)." >&2
fi

exit 0
````

## File: .claude/hooks/cross-repo-context.sh
````bash
#!/bin/bash
# cross-repo-context.sh — SessionStart hook
# Emits compact sibling-repo context across related repositories.
# Priority:
#   1) Explicit map: .agents/context/repo-group.json (framework-agnostic)
#   2) Fallback discovery: naming pattern sw-<module>-<suite>

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
REPO_NAME="$(basename "$PROJECT_DIR")"

repo_summary() {
  local repo="$1"
  local module="$2"
  local summary=""
  local file
  for file in "$repo/.agents/context/ROLE.md" "$repo/.agents/context/ARCHITECTURE.md" "$repo/.agents/context/STACK.md"; do
    if [ -f "$file" ]; then
      summary="$(sed -n '1,20p' "$file" | sed -E '/^[[:space:]]*$/d; /^#/d' | head -n1)"
      [ -n "$summary" ] && break
    fi
  done
  if [ -z "$summary" ]; then
    case "$module" in
      theme) summary="base storefront theme repository" ;;
      sub-theme) summary="project-specific storefront theme customizations" ;;
      plugin) summary="custom plugin and business logic repository" ;;
      shop) summary="integration/runtime repository" ;;
      frontend) summary="frontend application repository" ;;
      backend) summary="backend application repository" ;;
      api) summary="API/backend service repository" ;;
      *) summary="related project repository" ;;
    esac
  fi
  printf '%s' "$summary" | tr '\r\n' ' ' | sed 's/[[:space:]]\+/ /g' | cut -c1-180
}

emit_repo_line() {
  local repo="$1"
  local name="$2"
  local module="$3"

  local branch_info="no-git"
  if git -C "$repo" rev-parse --git-dir >/dev/null 2>&1; then
    local branch dirty state
    branch="$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)"
    dirty="$(git -C "$repo" status --porcelain -uno 2>/dev/null | head -n1)"
    state="clean"
    [ -n "$dirty" ] && state="dirty"
    branch_info="branch=${branch:-unknown},${state}"
  fi
  local marker=""
  [ "$name" = "$REPO_NAME" ] && marker=" (current)"
  printf -- "- %s%s [%s, %s]\n" "$name" "$marker" "${module:-unknown}" "$branch_info"
  printf "  context: %s\n" "$(repo_summary "$repo" "$module")"
}

emit_repo() {
  local repo="$1"
  local name="${2:-$(basename "$repo")}"
  local module="${3:-unknown}"
  emit_repo_line "$repo" "$name" "$module"
}

# 1) Explicit repo-group map (recommended, works for any naming convention).
GROUP_FILE="$PROJECT_DIR/.agents/context/repo-group.json"
if [ -f "$GROUP_FILE" ] && command -v jq >/dev/null 2>&1; then
  GROUP_NAME="$(jq -r '.group // "workspace"' "$GROUP_FILE" 2>/dev/null)"
  ENTRY_COUNT="$(jq -r '.repos | length' "$GROUP_FILE" 2>/dev/null)"
  case "$ENTRY_COUNT" in
    ''|null|*[!0-9]*) ENTRY_COUNT=0 ;;
  esac
  if [ "$ENTRY_COUNT" -gt 0 ]; then
    printed=0
    echo "=== Cross-Repo Context (group: ${GROUP_NAME}) ==="
    while IFS= read -r entry; do
      rel_path="$(printf '%s' "$entry" | jq -r '.path // empty')"
      [ -n "$rel_path" ] || continue
      if [[ "$rel_path" = /* ]]; then
        abs_path="$rel_path"
      else
        abs_path="$(cd "$PROJECT_DIR" 2>/dev/null && cd "$rel_path" 2>/dev/null && pwd)" || continue
      fi
      [ -n "$abs_path" ] || continue
      [ -d "$abs_path" ] || continue
      name="$(printf '%s' "$entry" | jq -r '.name // empty')"
      module="$(printf '%s' "$entry" | jq -r '.module // empty')"
      emit_repo "$abs_path" "$name" "$module"
      printed=$((printed + 1))
    done < <(jq -c '.repos[]?' "$GROUP_FILE" 2>/dev/null)
    [ "$printed" -gt 1 ] && exit 0
    # If map exists but resolves to <=1 repo, silently continue to fallback.
  fi
fi

# 2) Fallback: Shopware suite naming like sw-theme-acme, sw-plugin-acme, ...
if [[ ! "$REPO_NAME" =~ ^sw-([a-z0-9-]+)-([a-z0-9]+)$ ]]; then
  exit 0
fi
SUITE_ID="${BASH_REMATCH[2]}"
PARENT_DIR="$(cd "$PROJECT_DIR/.." 2>/dev/null && pwd)"
[ -n "$PARENT_DIR" ] || exit 0

repos=()
while IFS= read -r repo_path; do
  repos+=("$repo_path")
done < <(find "$PARENT_DIR" -maxdepth 1 -mindepth 1 -type d -name "sw-*-${SUITE_ID}" | sort)

# If no sibling repos found, skip noise.
[ "${#repos[@]}" -gt 1 ] || exit 0

echo "=== Cross-Repo Context (suite: ${SUITE_ID}) ==="

for repo in "${repos[@]}"; do
  name="$(basename "$repo")"
  module="unknown"
  if [[ "$name" =~ ^sw-([a-z0-9-]+)-([a-z0-9]+)$ ]]; then
    module="${BASH_REMATCH[1]}"
  fi
  emit_repo "$repo" "$name" "$module"
done

exit 0
````

## File: .claude/hooks/notify.sh
````bash
#!/bin/bash
# Cross-platform notification hook for Claude Code
# Supports: macOS (osascript), Linux (notify-send), silent fallback
# Claude Code passes notification data via stdin as JSON:
# {"message": "Task complete", "title": "Claude Code", "level": "info"}

# Read stdin payload
PAYLOAD=$(cat /dev/stdin 2>/dev/null || echo "{}")

MSG=""
TTL=""
if command -v jq >/dev/null 2>&1; then
  MSG=$(echo "$PAYLOAD" | jq -r '.message // empty' 2>/dev/null)
  TTL=$(echo "$PAYLOAD" | jq -r '.title // empty' 2>/dev/null)
fi

TITLE="${TTL:-Claude Code}"
MESSAGE="${MSG:-Claude Code is ready}"

case "$(uname -s)" in
  Darwin)
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null || true
    ;;
  Linux)
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "$TITLE" "$MESSAGE" 2>/dev/null || true
    fi
    ;;
  *)
    # Silent fallback for unsupported platforms
    ;;
esac
````

## File: .claude/hooks/post-edit-lint.sh
````bash
#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

# Ignore events without a concrete file (or deleted/moved files).
[ -n "$FILE_PATH" ] || exit 0
[ -f "$FILE_PATH" ] || exit 0

# Optional project formatter script.
# Try file-scoped format first; on failure, continue with per-file fallback below.
if [ -f "package.json" ] && jq -e '.scripts.format' package.json >/dev/null 2>&1; then
  if command -v bun >/dev/null 2>&1 && bun run format -- "$FILE_PATH" >/dev/null 2>&1; then
    exit 0
  fi
  if command -v npm >/dev/null 2>&1 && npm run -s format -- "$FILE_PATH" >/dev/null 2>&1; then
    exit 0
  fi
fi

# ESLint for JS/TS files
if [[ "$FILE_PATH" == *.js || "$FILE_PATH" == *.ts || "$FILE_PATH" == *.jsx || "$FILE_PATH" == *.tsx ]]; then
  if [ -x "node_modules/.bin/eslint" ]; then
    OUTPUT=$(./node_modules/.bin/eslint "$FILE_PATH" --fix 2>&1)
  else
    OUTPUT=$(npx eslint "$FILE_PATH" --fix 2>&1)
  fi
  if [ $? -ne 0 ]; then
    echo "Lint failed:" && echo "$OUTPUT" | head -20
    exit 1
  fi
fi

# Prettier for other supported files (css, html, json, md, yaml, vue, svelte)
if [[ "$FILE_PATH" == *.css || "$FILE_PATH" == *.html || "$FILE_PATH" == *.json || "$FILE_PATH" == *.md || "$FILE_PATH" == *.yaml || "$FILE_PATH" == *.yml || "$FILE_PATH" == *.vue || "$FILE_PATH" == *.svelte ]]; then
  if [ -x "node_modules/.bin/prettier" ]; then
    ./node_modules/.bin/prettier --write "$FILE_PATH" 2>/dev/null
  fi
fi

exit 0
````

## File: .githooks/pre-push
````
#!/usr/bin/env bash
set -euo pipefail

if [ "${SKIP_PREPUSH_TESTS:-0}" = "1" ]; then
  echo "Skipping pre-push tests (SKIP_PREPUSH_TESTS=1)."
  exit 0
fi

echo "Running pre-push checks: npm test"
npm test
echo "Pre-push checks passed."
````

## File: .github/workflows/ci-smoke.yml
````yaml
name: CI Smoke Test

on:
  pull_request:
  push:
    branches:
      - main

permissions:
  contents: read

jobs:
  smoke:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Run smoke tests
        run: bash tests/smoke.sh
````

## File: lib/skills.sh
````bash
#!/bin/bash
# Skill search, curation, and installation
# Requires: $TIMEOUT_CMD (optional, set at call time)

SKILL_PATTERN='^[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+@[a-zA-Z0-9_.-]+'

# Detect timeout command availability
TIMEOUT_CMD=""
command -v timeout &>/dev/null && TIMEOUT_CMD="timeout 30"
command -v gtimeout &>/dev/null && TIMEOUT_CMD="gtimeout 30"

# Search skills.sh registry with timeout
search_skills() {
  local kw=$1
  local result=""
  if [ -n "$TIMEOUT_CMD" ]; then
    result=$($TIMEOUT_CMD npx -y skills@latest find "$kw" 2>/dev/null \
      | sed 's/\x1b\[[0-9;]*m//g' \
      | grep -E "$SKILL_PATTERN" || true)
  else
    local tmp=$(mktemp)
    npx -y skills@latest find "$kw" > "$tmp" 2>/dev/null &
    local pid=$!
    local wait_s=0
    while kill -0 "$pid" 2>/dev/null && [ "$wait_s" -lt 30 ]; do
      sleep 1
      wait_s=$((wait_s + 1))
    done
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
    else
      wait "$pid" 2>/dev/null || true
      result=$(sed 's/\x1b\[[0-9;]*m//g' "$tmp" \
        | grep -E "$SKILL_PATTERN" || true)
    fi
    rm -f "$tmp"
  fi
  echo "$result"
}

# Returns space-separated skill IDs curated from the skills.sh directory.
# Bash 3.2 safe (no declare -A). Update this list when new skills are published.
get_keyword_skills() {
  local kw="$1"
  case "$kw" in
    vue)        echo "vuejs-ai/skills@vue-best-practices antfu/skills@vue" ;;
    react)      echo "0xbigboss/claude-code@react-best-practices wshobson/agents@react-state-management" ;;
    typescript) echo "wshobson/agents@typescript-advanced-types sickn33/antigravity-awesome-skills@typescript-expert" ;;
    shadcn)     echo "google-labs-code/stitch-skills@shadcn-ui" ;;
    playwright) echo "microsoft/playwright-cli@playwright-cli" ;;
    prisma)     echo "sickn33/antigravity-awesome-skills@prisma-expert" ;;
    supabase)   echo "supabase/agent-skills@supabase-postgres-best-practices" ;;
    nestjs)     echo "kadajett/agent-nestjs-skills@nestjs-best-practices" ;;
    svelte)     echo "ejirocodes/agent-skills@svelte5-best-practices" ;;
    angular)    echo "analogjs/angular-skills@angular-component analogjs/angular-skills@angular-signals" ;;
    nuxt-ui)    echo "" ;;  # handled conditionally in system skills (nuxt case)
    vitest)     echo "antfu/skills@vitest" ;;
    pinia)      echo "vuejs-ai/skills@vue-pinia-best-practices" ;;
    tanstack)   echo "jezweb/claude-skills@tanstack-query" ;;
    tailwind)   echo "wshobson/agents@tailwind-design-system" ;;
    express)    echo "wshobson/agents@nodejs-backend-patterns" ;;
    hono)       echo "elysiajs/skills@elysiajs" ;;
    firebase)      echo "" ;;
    reka-ui)       echo "" ;;
    primevue)      echo "" ;;
    vuetify)       echo "" ;;
    element-plus)  echo "" ;;
    quasar)        echo "" ;;
    *)             echo "" ;;
  esac
}

# Install bundled local skill template as fallback when registry/network install is unavailable.
# Returns 0 when fallback was installed, 1 when no local template exists.
install_local_skill_template() {
  local sid="$1"
  local skill_name="${sid##*@}"
  local local_template="$SCRIPT_DIR/templates/skills/$skill_name/SKILL.md"
  local local_target_dir=".claude/skills/$skill_name"

  [ -f "$local_template" ] || return 1
  mkdir -p "$local_target_dir"
  cp "$local_template" "$local_target_dir/SKILL.md"
  printf "\r     ✅ %s (local template fallback)\n" "$sid"
  return 0
}

# Install a single skill with duplicate detection and registry verification
# Uses $TIMEOUT_CMD if available
install_skill() {
  local sid=$1
  local skill_name="${sid##*@}"  # Extract skill name after @
  local owner_repo="${sid%@*}"
  local owner="${owner_repo%/*}"
  local repo="${owner_repo#*/}"

  # Check if already installed (local or global)
  if [ -d ".claude/skills/$skill_name" ] || [ -d "${HOME}/.claude/skills/$skill_name" ]; then
    printf "     ⏭️  %s (already installed)\n" "$sid"
    SKIPPED=$((SKIPPED + 1))
    return 0
  fi

  # Verify skill exists on skills.sh registry before attempting install
  if command -v curl >/dev/null 2>&1; then
    local status
    status=$(curl -s -o /dev/null -w "%{http_code}" \
      "https://skills.sh/$owner/$repo/$skill_name" 2>/dev/null)
    if [ "$status" != "200" ]; then
      if install_local_skill_template "$sid"; then
        return 0
      fi
      printf "     ⚠️  %s (not in registry, skipping)\n" "$sid"
      return 0
    fi
  fi

  printf "     ⏳ %s ..." "$sid"
  if ${TIMEOUT_CMD:-} npx -y skills@latest add "$sid" --agent claude-code --agent github-copilot -y </dev/null >/dev/null 2>&1; then
    printf "\r     ✅ %s\n" "$sid"
    return 0
  else
    if install_local_skill_template "$sid"; then
      return 0
    fi
    printf "\r     ❌ %s (install failed)\n" "$sid"
    return 1
  fi
}
````

## File: specs/completed/011-bulk-spec-execution-command.md
````markdown
# Spec: Bulk Spec Execution via Agents

> **Spec ID**: 011 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Add a `/spec-work-all` slash command that executes multiple specs in parallel or sequence using subagents.

## Context
Currently `/spec-work NNN` processes one spec at a time with a single agent. When multiple independent specs exist, users must run them one-by-one. A bulk command using subagents would dramatically speed up spec completion for batches of unrelated specs.

## Steps
- [x] Step 1: Create `templates/commands/spec-work-all.md` — slash command that lists all draft specs and dispatches each to an Agent subagent
- [x] Step 2: Define parallelism strategy in the command: independent specs run in parallel, dependent specs run in sequence
- [x] Step 3: Add dependency detection: if spec A's "Out of Scope" mentions spec B, treat them as sequential
- [x] Step 4: Register `spec-work-all.md` in `bin/ai-setup.sh` template deployment (alongside spec-work.md)
- [x] Step 5: Update `templates/CLAUDE.md` Spec-Driven Development section to document `/spec-work-all`
- [x] Step 6: Update `README.md` slash commands table with new command

## Acceptance Criteria
- [x] `/spec-work-all` discovers all draft specs in `specs/` automatically
- [x] Independent specs execute in parallel via subagents
- [x] Each subagent follows the same spec-work process (check off steps, update CHANGELOG, move to completed/)
- [x] Final summary shows which specs completed, which failed

## Files to Modify
- `templates/commands/spec-work-all.md` — new command (create)
- `bin/ai-setup.sh` — register new template
- `templates/CLAUDE.md` — document command
- `README.md` — add to slash commands table

## Out of Scope
- Spec ordering / priority ranking
- Automatic rollback if a spec fails
- Interactive spec selection UI
````

## File: specs/completed/018-native-worktree-rewrite.md
````markdown
# Spec: Rewrite spec-work-all to use native worktree isolation

> **Spec ID**: 018 | **Created**: 2026-02-23 | **Status**: completed | **Branch**: spec/018-native-worktree-rewrite

## Goal
Replace manual git worktree management in spec-work-all.md with Claude Code's native `isolation: "worktree"` on the Agent tool, and bump version to 1.1.3.

## Context
Claude Code now has built-in worktree support via `Agent(isolation: "worktree")`. Our spec-work-all.md manually manages worktrees with ~40 lines of bash (create, .env copy, dep install, cleanup). The native approach handles creation, isolation, and cleanup automatically. This rewrite simplifies the template and moves spec file/CHANGELOG updates to the orchestrator (cleaner separation of concerns).

## Steps
- [x] Step 1: Rewrite `templates/commands/spec-work-all.md` — remove Section 3 (gitignore setup), replace Wave setup (manual worktree/env/deps) with `Agent(isolation: "worktree")`, remove Wave cleanup. Orchestrator sets spec status before launch and updates branch/CHANGELOG after return.
- [x] Step 2: Update subagent prompt: remove worktree path instructions, add "copy .env* from main repo and run dep install if lockfile exists" as first steps, add "rename branch to `spec/NNN-title`" before commit.
- [x] Step 3: Move spec file updates (check off steps, status, CHANGELOG) from subagent to orchestrator — subagent only does implementation + commit inside worktree.
- [x] Step 4: Update `templates/CLAUDE.md` spec workflow section — mention native worktree isolation.
- [x] Step 5: Bump version in `package.json` from 1.1.2 to 1.1.3.

## Acceptance Criteria
- [x] spec-work-all uses `Agent(isolation: "worktree")` instead of manual `git worktree add/remove`
- [x] No `.worktrees/` directory or `.gitignore` management in the template
- [x] Subagent prompt includes .env copy, dep install, and branch rename instructions
- [x] package.json version is 1.1.3

## Files to Modify
- `templates/commands/spec-work-all.md` — full rewrite of worktree management
- `templates/CLAUDE.md` — update workflow description
- `package.json` — version bump

## Out of Scope
- Changes to `/spec-work` (single spec execution — uses branch prompt, not worktrees)
- Adding `isolation: worktree` to custom agent frontmatter files
- Changing the spec template format
````

## File: specs/completed/026-code-reviewer-agent.md
````markdown
# Spec: Add code-reviewer Agent and Wire Into Spec Workflow

> **Spec ID**: 026 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/026-code-reviewer-agent

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->

## Goal
Create a reusable `code-reviewer` agent and integrate it into `spec-work` and `spec-review` so review logic is delegated to the agent rather than duplicated inline.

## Context
The installed agents (`build-validator`, `verify-app`, `staff-reviewer`) are never automatically called — only `context-refresher` is triggered via hook. `spec-work` and `spec-review` both run inline review logic; a dedicated agent makes this reusable, consistently applied, and independently improvable. `bin/ai-setup.sh` already copies all `templates/agents/*` to `.claude/agents/` automatically.

## Steps
- [x] Step 1: Create `templates/agents/code-reviewer.md` — model: sonnet, max_turns: 15, read-only; accepts diff + optional spec context; reports bugs/security/quality at HIGH/MEDIUM confidence; returns PASS / CONCERNS / FAIL verdict
- [x] Step 2: Update `templates/commands/spec-work.md` — add `Agent` to `allowed-tools`; auto-review step always spawns `code-reviewer` (no "ask user" — mandatory)
- [x] Step 3: Update `templates/commands/spec-review.md` — add `Agent` to `allowed-tools`; step 5c (code quality) spawns `code-reviewer` agent with spec + branch diff
- [x] Step 4: Sync both to `.claude/commands/spec-work.md` and `.claude/commands/spec-review.md`

## Acceptance Criteria
- [x] `templates/agents/code-reviewer.md` exists with valid frontmatter and clear behavior rules
- [x] `spec-work` always spawns `code-reviewer` after steps complete (no user prompt)
- [x] `spec-review` step 5c delegates to `code-reviewer` instead of inline analysis
- [x] Deployed commands in `.claude/commands/` match templates

## Files to Modify
- `templates/agents/code-reviewer.md` — new file
- `templates/commands/spec-work.md` — add Agent, delegate auto-review
- `templates/commands/spec-review.md` — add Agent, delegate code quality check
- `.claude/commands/spec-work.md` — sync
- `.claude/commands/spec-review.md` — sync

## Out of Scope
- Changing `/review` or `/grill` commands
- Integrating `build-validator` or `verify-app` into commands
- Modifying `bin/ai-setup.sh`
````

## File: specs/completed/027-code-architect-agent.md
````markdown
# Spec: Add code-architect Agent Template

> **Spec ID**: 027 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/027-code-architect-agent

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->

## Goal
Add a `code-architect` agent template that performs design reviews and architectural assessments before or during complex spec implementation.

## Context
Claude Code exposes `code-architect` as a native subagent type for design reviews and architectural assessments — but the project has no template for it. `bin/ai-setup.sh` auto-installs all `templates/agents/*` to `.claude/agents/`, so only the template file is needed. The agent sits between `code-reviewer` (routine check) and `staff-reviewer` (adversarial production gate) in terms of depth and cost.

## Steps
- [x] Step 1: Create `templates/agents/code-architect.md` — model: opus, max_turns: 15; reviews proposed architecture or spec for design problems before implementation begins
- [x] Step 2: Update `templates/commands/spec-work.md` — add `Agent` to `allowed-tools` (if not already added by 026); before executing steps, auto-spawn `code-architect` when spec file contains `**Complexity**: high` in its header
- [x] Step 3: Sync change to `.claude/commands/spec-work.md`

## Acceptance Criteria
- [x] `templates/agents/code-architect.md` exists with valid frontmatter, opus model, and architectural review criteria
- [x] Agent installed via normal `npx @onedot/ai-setup` flow (no bin/ai-setup.sh change needed)
- [x] `spec-work` spawns `code-architect` automatically for high-complexity specs

## Files to Modify
- `templates/agents/code-architect.md` — new file
- `templates/commands/spec-work.md` — auto-spawn code-architect for complex specs
- `.claude/commands/spec-work.md` — sync

## Out of Scope
- Changing `/spec` creation command
- Changing complexity detection beyond a simple header field
- Depends on: Spec 026 (Agent tool already added to spec-work)
````

## File: specs/completed/028-auto-agent-integration.md
````markdown
# Spec: Fully Automatic Agent Integration Into Workflow

> **Spec ID**: 028 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/028-auto-agent-integration

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->

## Goal
Wire `verify-app` into `spec-work` and `staff-reviewer` into `/pr` so all installed agents run automatically at the right workflow moments without user prompting.

## Context
After 026 and 027, agents are available and `code-reviewer` runs automatically. Two remaining gaps: (1) `verify-app` never runs — `spec-work` completes steps but never checks if build/tests pass; (2) `staff-reviewer` (opus) is designed as a production gate but `/pr` never calls it. Both should be mandatory, not optional.

## Steps
- [x] Step 1: Update `templates/commands/spec-work.md` — after all steps complete, auto-spawn `verify-app` before `code-reviewer`; if verify-app returns FAIL, stop and report without running code-reviewer
- [x] Step 2: Update `templates/commands/pr.md` — add `Agent` to `allowed-tools`; spawn `staff-reviewer` automatically before drafting PR title/body; include reviewer verdict in PR output
- [x] Step 3: Sync both to `.claude/commands/spec-work.md` and `.claude/commands/pr.md`

## Acceptance Criteria
- [x] `spec-work` post-implementation order: `verify-app` → `code-reviewer` → report
- [x] `verify-app` FAIL blocks the code-reviewer step and reports build/test errors
- [x] `/pr` always runs `staff-reviewer` before generating the PR description
- [x] Deployed commands in `.claude/commands/` match templates

## Files to Modify
- `templates/commands/spec-work.md` — add verify-app spawn before code-reviewer
- `templates/commands/pr.md` — add Agent, spawn staff-reviewer
- `.claude/commands/spec-work.md` — sync
- `.claude/commands/pr.md` — sync

## Out of Scope
- Modifying `build-validator` (covered by verify-app)
- Changing `spec-work-all` (uses worktrees — verify handled per-worktree)
- Depends on: Spec 026 (Agent already in spec-work allowed-tools)
````

## File: specs/completed/033-integrate-orphaned-agents.md
````markdown
# Spec: Integrate Orphaned Agent Templates into Pipelines

> **Spec ID**: 033 | **Created**: 2026-02-26 | **Status**: completed | **Branch**: spec/033-integrate-orphaned-agents

## Goal
Wire build-validator into the PR pipeline and expand /review to cover branch commits.

## Context
build-validator exists as an agent template but is referenced by no command. Additionally, /review only sees uncommitted changes — branch commits on feature branches are invisible. perf-reviewer belongs in /analyze (Spec 035) and /review, not in /spec-work which processes shell/template files.

## Steps
- [x] Step 1: In `templates/commands/pr.md`, add build-validator as the first step — spawn it before staff review; if FAIL, stop with "Fix the build before creating a PR"
- [x] Step 2: In `templates/commands/review.md`, replace the git diff step with: run `git diff` + `git diff --staged` first; if on a branch also run `git diff main...HEAD`; combine all changes for review; note "no changes found" if all are empty
- [x] Step 3: Update agent listing in `bin/ai-setup.sh` (~line 2146) to include build-validator
- [x] Step 4: Run smoke tests (`./tests/smoke.sh`) to verify templates parse correctly

## Acceptance Criteria
- [x] `/pr` fails fast with a build error message before staff review if build is broken
- [x] `/review` on a feature branch shows both uncommitted changes and branch commits
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/pr.md` — add build-validator as Step 1
- `templates/commands/review.md` — extend git diff to include branch commits
- `bin/ai-setup.sh` — update agent listing in summary output

## Out of Scope
- perf-reviewer in /spec-work (wrong context — shell/template files have no perf issues)
- Changing /grill (stays monolithic Opus by design)
- test-generator integration (requires separate design)
````

## File: specs/completed/036-bash-performance-optimizations.md
````markdown
# Spec: Bash Performance Optimizations for ai-setup.sh

> **Spec ID**: 036 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/036-bash-performance-optimizations

## Goal
Reduce ai-setup.sh runtime by parallelizing skills search and installation, capping unbounded parallel curl calls, and eliminating subshell overhead in string transformations.

## Context
Profiling found 4 concrete bottlenecks: (1) skills installation is fully sequential (~30s/skill), (2) skills search per keyword is sequential (~30s/keyword × N keywords), (3) curl install-count fetches spawn unlimited parallel subshells with no job pool, (4) string transformations use echo|sed subshells where bash parameter expansion suffices. Total savings potential: 100+ seconds on a typical run with 5+ skills.

## Steps
- [x] Step 1: Parallelize the keyword search loop (~line 1012): run each `search_skills "$kw"` in background with `&`, collect results with `wait`, merge into a single deduped list
- [x] Step 2: Parallelize the system skills installation loop (~line 1300): install each skill with `&`; collect PIDs; `wait` for all; report results in order
- [x] Step 3: Parallelize the dynamic skills installation loop (~line 1159): same `&` + `wait` pattern; ensure duplicate-check logic is safe for concurrent execution
- [x] Step 4: Add job pool cap to the curl install-count fetch loop (~line 1052): limit to max 8 concurrent curl subshells using a semaphore pattern (`while (( $(jobs -r | wc -l) >= 8 )); do sleep 0.1; done`)
- [x] Step 5: Replace `echo "$var" | sed` and `echo "$var" | tr` subshells with bash parameter expansion (`${var//from/to}`, `${var^^}`, etc.) in the inner loops
- [x] Step 6: Run `./tests/smoke.sh` to verify correctness after changes; manually time a test run before/after with `time ./bin/ai-setup.sh --help`

## Acceptance Criteria
- [x] Skills search keywords run in parallel (not sequential npx calls)
- [x] Skills installation runs in parallel (not one-by-one)
- [x] curl fetch loop has max 8 concurrent jobs at any time
- [x] No `echo | sed` or `echo | tr` inside loops — replaced with parameter expansion
- [x] Smoke tests pass with no behavior change

## Files to Modify
- `bin/ai-setup.sh` — lines ~1012-1035 (search), ~1052-1062 (curl), ~1159-1164 (install), ~1300-1302 (system install), string transforms in loops

## Out of Scope
- Rewriting in Node.js
- Changing the user-facing output or UX
- Optimizing the Claude API call for CLAUDE.md generation (network-bound, not fixable in bash)
````

## File: specs/completed/037-claude-code-best-practice-alignment.md
````markdown
# Spec: Align with Official Claude Code Best Practices

> **Spec ID**: 037 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/037-claude-code-best-practice-alignment

## Goal
Close 8 gaps between our templates and official Claude Code standards: SKILL.md rename, enriched frontmatter, settings schema, sandbox, attribution, disable-model-invocation, and cross-platform notification hook.

## Context
Audit against code.claude.com/docs found our skills use the legacy `prompt.md` filename (official is now `SKILL.md`), skills lack `description` needed for auto-discovery, settings.json misses `$schema`/sandbox/attribution, destructive commands allow model self-invocation, and the notification hook is macOS-only. All gaps are fixable without architectural changes.

## Steps
- [x] Step 1: Rename all `templates/skills/*/prompt.md` to `SKILL.md` and add `name` + `description` frontmatter to each; update `bin/ai-setup.sh` template map (~lines 104-111) to reference `SKILL.md` instead of `prompt.md`
- [x] Step 2: Add `disable-model-invocation: true` frontmatter to destructive commands: `commit.md`, `release.md`, `pr.md`, `spec-work.md`, `spec-work-all.md`
- [x] Step 3: Add `argument-hint` to commands that take arguments: `spec.md` (`[task description]`), `bug.md` (`[bug description]`), `spec-work.md` (`[spec number]`), `spec-review.md` (`[spec number]`)
- [x] Step 4: In `templates/claude/settings.json`: add `"$schema": "https://json.schemastore.org/claude-code-settings.json"`, add `"respectGitignore": true`, add `"attribution"` block with Co-Authored-By
- [x] Step 5: In `templates/claude/settings.json`: add `"sandbox": {"enabled": true}` with network allowlist for common domains (github.com, npmjs.org, skills.sh)
- [x] Step 6: Replace macOS-only `osascript` notification hook with a cross-platform script that detects OS and uses `osascript` on macOS, `notify-send` on Linux, or silent fallback
- [x] Step 7: In `bin/ai-setup.sh`, update the skill install path to copy `SKILL.md` to `.claude/skills/<name>/SKILL.md`; add backwards-compat: if target has old `prompt.md`, rename it
- [x] Step 8: Run `./tests/smoke.sh` to verify all renamed/modified templates deploy correctly

## Acceptance Criteria
- [x] All skill templates use `SKILL.md` with `name` and `description` in frontmatter
- [x] Destructive commands have `disable-model-invocation: true`
- [x] `settings.json` has `$schema`, `sandbox`, `attribution`, `respectGitignore`
- [x] Notification hook works on macOS and Linux
- [x] Smoke tests pass

## Files to Modify
- `templates/skills/*/prompt.md` → rename to `SKILL.md` + update frontmatter (8 files)
- `templates/commands/{commit,release,pr,spec-work,spec-work-all,spec,bug,spec-review}.md` — add frontmatter fields
- `templates/claude/settings.json` — add schema, sandbox, attribution, respectGitignore
- `bin/ai-setup.sh` — update skill template paths and add backwards-compat migration

## Out of Scope
- Migrating commands from `.claude/commands/` to `.claude/skills/` (both work, no urgency)
- Adding `context: fork` to existing commands (requires per-command design)
- Plugin system configuration (not enough adoption yet)

## Review Feedback

### Issues (from code-reviewer, verdict: FAIL)

**[HIGH] Step 5 nicht implementiert — `sandbox` fehlt in settings.json**
`"sandbox": {"enabled": true}` mit Network-Allowlist wurde nicht zu `templates/claude/settings.json` hinzugefuegt. Acceptance Criteria war faelschlicherweise als erledigt markiert.

**[HIGH] Verbleibende `osascript`-Aufrufe in `bin/ai-setup.sh`**
Zeilen 180 und 182 in `bin/ai-setup.sh` enthalten noch direkte `osascript`-Aufrufe (Auto-Init Notifications). Diese sollten die cross-platform `notify.sh` Logik nutzen oder zumindest einen `uname`-Check verwenden.

**[MEDIUM] `notify.sh` ignoriert stdin-Payload**
Claude Code uebergibt den Notification-Inhalt via stdin als JSON. `notify.sh` liest stdin nicht und zeigt immer den statischen String "Claude Code is ready". Sollte stdin parsen oder zumindest Message/Title als Argumente akzeptieren.

**[MEDIUM] Scope Creep — `bin/ai-setup.sh` in 10 `lib/` Module aufgeteilt**
2100+ Zeilen Refaktorierung war nicht Teil der Spec. Smoke-Tests bestehen, aber diese Aenderung erhoet Regressionsrisiko und sollte als eigene Spec behandelt werden.

### Required Fixes (muss behoben werden)
1. `sandbox` Block zu `templates/claude/settings.json` hinzufuegen
2. `osascript` Aufrufe in `bin/ai-setup.sh` cross-platform machen
3. `notify.sh` stdin-Payload lesen lassen
````

## File: specs/completed/038-dod-and-ignore-patterns.md
````markdown
# Spec: Global Definition of Done and Ignore Patterns

> **Spec ID**: 038 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/038-dod-and-ignore-patterns

## Goal
Add auto-generated Definition of Done to CONVENTIONS.md and build-artifact ignore patterns to settings.json for higher baseline code quality and reduced token waste.

## Context
The /spec-review agent checks code only against spec-specific acceptance criteria. Generic quality gates (no console.log, no explicit any, linter clean) must be written into every spec manually. Additionally, Claude can read build artifacts (dist/, .output/, coverage/) wasting tokens and polluting context. Both fixes are template-level changes applied at setup time.

## Steps
- [x] Step 1: Extend CONVENTIONS.md generation prompt in `bin/ai-setup.sh` (~line 806) — add instruction: "Include a ## Definition of Done section with project-appropriate quality gates derived from detected tools (linter, TypeScript, test runner)."
- [x] Step 2: Add build-artifact deny rules to `templates/claude/settings.json` — add `Read(dist/**)`, `Read(.output/**)`, `Read(.nuxt/**)`, `Read(coverage/**)`, `Read(.next/**)`, `Read(build/**)` to the deny array.
- [x] Step 3: Add Critical Rule to `templates/CLAUDE.md` — "Never read or search inside build output directories (dist/, .output/, .nuxt/, .next/, build/, coverage/)."
- [x] Step 4: Update `templates/commands/spec-review.md` Step 5b — after verifying spec ACs, also verify code against the Definition of Done from `.agents/context/CONVENTIONS.md` if it exists.
- [x] Step 5: Verify all template files parse correctly and no existing functionality is broken.

## Acceptance Criteria
- [x] Fresh CONVENTIONS.md generation includes a DoD section with project-specific gates
- [x] settings.json deny list blocks Read access to common build artifact directories
- [x] /spec-review checks code against both spec ACs and the global DoD
- [x] Existing hooks, commands, and agents are unaffected

## Files to Modify
- `lib/generate.sh` — extend CONVENTIONS.md generation prompt
- `templates/claude/settings.json` — add deny rules for build artifacts
- `templates/CLAUDE.md` — add Critical Rule for build directories
- `templates/commands/spec-review.md` — add DoD verification step

## Out of Scope
- Native .claudeignore support (not available in Claude Code)
- Per-spec DoD overrides
- Token budget tracking or cost monitoring

## Review Feedback

### Issues (from code-reviewer, verdict: FAIL)

**[HIGH] Critical Rule in `templates/CLAUDE.md` nicht persistent**
Die neue Regel steht im `## Critical Rules`-Abschnitt, der bei jedem `run_generation`-Durchlauf vom LLM neu geschrieben wird. Die Regel wird bei der naechsten Regeneration ueberschrieben/entfernt. Fix: Die Regel muss ausserhalb des auto-populierten Bereichs platziert werden (z.B. in einem separaten `## Build Artifacts` Abschnitt nach Critical Rules, oder als Instruktion im Generation-Prompt, damit der LLM sie jedes Mal einbettet).

**[MEDIUM] Sektionsnummerierung `5b2` in spec-review.md**
Ungewoehnliche Nummerierung. Besser: `5b` umbenennen zu "Acceptance Criteria", neuen Step als `5c` einfuegen (DoD), bisheriges `5c` zu `5d`.

**[MEDIUM] Hardcodierte Beispiel-Gates im Generation-Prompt**
Beispiele wie "no explicit any" erscheinen immer im Prompt, auch wenn das Projekt kein TypeScript nutzt. Der Satz "If a tool is not detected, omit its gate" mildert das ab, koennte aber vom LLM ignoriert werden.

### Required Fixes (muss behoben werden)
1. Critical Rule aus dem auto-populierten Bereich verschieben (in Generation-Prompt oder separaten Abschnitt)
2. Sektionsnummerierung in spec-review.md bereinigen (5b2 → 5c, 5c → 5d)
````

## File: specs/completed/039-claude-mem-team-standard.md
````markdown
# Spec: Claude-Mem as Team Standard

> **Spec ID**: 039 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/039-claude-mem-team-standard

## Goal
Make claude-mem the default for every team member by changing opt-in to opt-out, adding folder context support to CLAUDE.md, and documenting the team expectation.

## Context
`install_claude_mem()` already exists in `lib/plugins.sh` and is called during init. It writes `enabledPlugins: {"claude-mem@thedotmack": true}` to `.claude/settings.json` which propagates to all team members via git — teammates are auto-prompted to install when they open the project. The only gaps: default prompt is `N` (skippable), no `<claude-mem-context>` placeholder in the CLAUDE.md template for folder context, and no team expectation documented.

## Steps
- [x] Step 1: In `lib/plugins.sh` `install_claude_mem()` — change the prompt default from `N` to `Y`: replace `read -p "   Install Claude-Mem? (y/N) "` with `read -p "   Install Claude-Mem? (Y/n) "` and update the condition to treat empty input as yes: `[[ "$INSTALL_CMEM" =~ ^[Nn]$ ]] && WITH_CLAUDE_MEM="no" || WITH_CLAUDE_MEM="yes"`
- [x] Step 2: Add `<claude-mem-context></claude-mem-context>` placeholder block to `templates/CLAUDE.md` — place it at the very end of the file so claude-mem can inject folder context without touching other sections
- [x] Step 3: Add a `## Required Plugins` section to `templates/CLAUDE.md` (before `## Communication Protocol`) — document that claude-mem is expected: install via `/plugin marketplace add thedotmack/claude-mem` then `/plugin install claude-mem`
- [x] Step 4: In `lib/plugins.sh` `install_claude_mem()` — update the skip message from `"⏭️  Claude-Mem skipped."` to a warning: `"⚠️  Claude-Mem skipped — team members will lack persistent memory. Re-run with --with-claude-mem to install."`
- [x] Step 5: Run `./tests/smoke.sh` to verify nothing broken

## Acceptance Criteria
- [x] Running `npx @onedot/ai-setup` prompts claude-mem with Y as default (pressing Enter installs it)
- [x] `templates/CLAUDE.md` contains `<claude-mem-context>` placeholder at end of file
- [x] `templates/CLAUDE.md` documents claude-mem as required plugin with install command
- [x] Skipping claude-mem shows a warning instead of silent skip
- [x] Smoke tests pass

## Files to Modify
- `lib/plugins.sh` — change default prompt + skip warning
- `templates/CLAUDE.md` — add `<claude-mem-context>` placeholder + Required Plugins section

## Out of Scope
- Forcing installation without prompt (user must still confirm)
- Changing the `--no-claude-mem` flag behavior
- Adding claude-mem to gitignore handling (folder context CLAUDE.md files in subdirs are committed by default — no gitignore needed)
- Shopware or other system-specific changes
````

## File: specs/completed/040-readme-changelog-update.md
````markdown
# Spec: README & CHANGELOG Update + Release Validation

> **Spec ID**: 040 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: —

## Goal
Bring README.md in sync with actual features, compact CHANGELOG entries, and extend /release to validate README counts automatically.

## Context
README lists 13 commands (actual: 15), 4 agents (actual: 8), 3 hooks (actual: 6). CHANGELOG [Unreleased] has 9 verbose spec entries that need compacting. The /release command already checks command count — extend it to also validate agents and hooks counts so README never drifts again.

## Steps
- [x] Step 1: Update README.md commands section — change count to 15, add `/analyze` and `/context-full` to table
- [x] Step 2: Update README.md agents section — change count to 8, add code-reviewer, code-architect, perf-reviewer, test-generator to table
- [x] Step 3: Update README.md hooks section — change count to 6, add context-freshness, update-check, notify to table
- [x] Step 4: Update README.md file structure tree — add missing files (new agents, hooks, commands)
- [x] Step 5: Compact README overall — tighten verbose sections, remove redundancy, ensure nothing exceeds what's needed
- [x] Step 6: Compact CHANGELOG.md [Unreleased] entries — shorten each spec entry to one concise line
- [x] Step 7: Extend `templates/commands/release.md` Step 3 — validate agent count and hook count alongside command count

## Acceptance Criteria
- [x] README command/agent/hook counts match actual template files
- [x] CHANGELOG [Unreleased] entries are each one concise line
- [x] `/release` validates commands, agents, and hooks counts before proceeding
- [x] `npm test` passes (smoke tests)

## Files to Modify
- `README.md` — update counts, tables, file structure, compact
- `CHANGELOG.md` — compact [Unreleased] entries
- `templates/commands/release.md` — extend validation step

## Out of Scope
- Version bump or actual release
- Rewriting README structure or sections
- Adding new features
````

## File: specs/completed/042-feedback-loop-patterns.md
````markdown
# Spec: Add Feedback Loop Patterns to Workflow Commands

> **Spec ID**: 042 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/042-feedback-loop-patterns

## Goal
Add explicit "validate → fix → repeat" feedback loops and progress checklist patterns to workflow commands that modify code but lack verification.

## Context
Anthropic's skill best practices show that feedback loops ("run validator → fix → repeat") significantly improve output quality. Our `spec-work.md` and `bug.md` already have verify-app/code-reviewer loops, but `techdebt.md` modifies code without any verification. Commands with complex multi-step workflows (`spec-work.md`, `bug.md`) benefit from explicit progress checklist patterns.

## Steps
- [x] Step 1: Add verify step to `templates/commands/techdebt.md` — after Step 4 (fixing clear wins), spawn `verify-app` to run tests/build, retry fixes up to 2 times if failures
- [x] Step 2: Add progress checklist copy pattern to `templates/commands/spec-work.md` — before Step 8 (Execute), output a trackable checklist that Claude checks off during execution
- [x] Step 3: Add retry loop to `templates/commands/test.md` Step 5 — make the "repeat until pass or 3 attempts" pattern more explicit with numbered attempt tracking
- [x] Step 4: Run smoke tests (`bash tests/smoke-test.sh`) to verify templates install correctly

## Acceptance Criteria
- [x] `techdebt.md` runs verify-app after making changes and retries on failure
- [x] `spec-work.md` includes a progress checklist pattern before execution
- [x] `test.md` has explicit attempt counter in retry loop
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/techdebt.md` — add verification feedback loop
- `templates/commands/spec-work.md` — add progress checklist pattern
- `templates/commands/test.md` — make retry loop explicit

## Out of Scope
- Read-only commands (review, grill, analyze, spec-board) — no code changes to validate
- Single-action commands (commit, pr, release) — no loop needed
- Agent templates (`templates/agents/*.md`)
````

## File: specs/completed/043-reflect-system.md
````markdown
# Spec: Self-Improvement Reflect System

> **Spec ID**: 043 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/043-reflect-system | **Complexity**: high

## Goal
Create a `/reflect` command that detects corrections from the current session and converts them into permanent CLAUDE.md rules or convention updates.

## Context
Inspired by claude-reflect-system ("correct once, never again"). Currently corrections are lost between sessions — developers repeat the same feedback. This command analyzes session conversation for correction patterns (HIGH: "use X not Y", MEDIUM: approved approaches) and writes them as persistent rules. Integrates with existing CLAUDE.md and `.agents/context/CONVENTIONS.md`.

## Steps
- [x] Step 1: Create `templates/commands/reflect.md` — command that analyzes the conversation for correction signals (direct corrections, rejected approaches, approved patterns)
- [x] Step 2: Implement 3-tier signal detection in the command: HIGH (explicit corrections), MEDIUM (approved approaches), LOW (observations) — only apply HIGH+MEDIUM
- [x] Step 3: Define output targets: corrections about coding style → append to `.agents/context/CONVENTIONS.md`, corrections about project rules → append to CLAUDE.md Critical Rules section, corrections about tooling → append to CLAUDE.md Commands section
- [x] Step 4: Add safety: show proposed changes to user via AskUserQuestion before writing, create git-trackable changes (no silent mutations)
- [x] Step 5: Register the command in `lib/setup.sh` template map so it installs with ai-setup
- [x] Step 6: Run smoke tests to verify template installs correctly

## Acceptance Criteria
- [x] `/reflect` command exists and is installable via ai-setup
- [x] Command detects correction patterns from conversation context
- [x] Changes require explicit user approval before writing
- [x] Written changes are minimal, specific, and append-only (no destructive edits)

## Files to Modify
- `templates/commands/reflect.md` — new command template (create)
- `lib/setup.sh` — register reflect command in template map

## Out of Scope
- Auto-mode (hook-based automatic reflection) — future enhancement
- Skill file generation (YAML skill format) — use CLAUDE.md/context files instead
- Cross-session learning (that is claude-mem's responsibility)
````

## File: specs/completed/044-rules-template-expansion.md
````markdown
# Spec: Expand .claude/rules/ template system with modular rules and memory docs

> **Spec ID**: 044 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/044-rules-template-expansion

## Goal
Add modular rule templates, conditional TypeScript rules, opusplan model, and enrich template CLAUDE.md with memory docs, power-user tips, and @imports pattern.

## Context
The `.claude/rules/` directory is Claude Code's official modular instruction system. We already ship `general.md` and have `install_rules()` infrastructure. This spec adds two universal rule files (testing, git), one conditional rule file (TypeScript), sets `opusplan` as default model, and enriches template CLAUDE.md with the memory clarification, `ultrathink:` prefix, `!command` shortcut, and `@imports` pattern. `CLAUDE.local.md` is also added to gitignore for personal project preferences.

## Steps
- [x] Step 1: Create `templates/claude/rules/testing.md` — test-first rules, assertion expectations, edge case coverage, no mocks-by-default
- [x] Step 2: Create `templates/claude/rules/git.md` — commit message format, branch naming, no force-push, no --no-verify
- [x] Step 3: Create `templates/claude/rules/typescript.md` — strict types, no `any`, prefer inference, use existing project patterns
- [x] Step 4: Add `TS_RULES_MAP` to `lib/core.sh` — conditional map for TypeScript rules, skip `claude/rules/typescript.md` in `build_template_map()`
- [x] Step 5: Extend `install_rules()` in `lib/setup.sh` to install conditional TS rules when `*.ts`/`*.tsx` files detected; also add `CLAUDE.local.md` to `update_gitignore()`
- [x] Step 6: Add `"model": "opusplan"` to `templates/claude/settings.json` — Opus in plan mode, Sonnet in execution
- [x] Step 7: Update `templates/CLAUDE.md` — (a) replace "Required Plugins" with "Memory" section (Built-in Auto Memory + claude-mem), (b) add Tips section: `ultrathink:` prefix for deep reasoning, `!command` for instant bash, `@path` imports, one-conversation-per-task rule
- [x] Step 8: Verify idempotency — run setup twice on a test project, confirm no duplicates or overwrites

## Acceptance Criteria
- [x] `general.md`, `testing.md`, `git.md` installed for all projects; `typescript.md` only when TS detected
- [x] `CLAUDE.local.md` present in `.gitignore` after install
- [x] `opusplan` set in installed `.claude/settings.json`
- [x] Template CLAUDE.md has Memory section and Tips section with ultrathink/!/@ hints
- [x] Running setup twice produces identical results (idempotent)

## Files to Modify
- `templates/claude/rules/testing.md` — new file
- `templates/claude/rules/git.md` — new file
- `templates/claude/rules/typescript.md` — new file (conditional)
- `lib/core.sh` — add TS_RULES_MAP + exclude pattern
- `lib/setup.sh` — conditional TS rules + CLAUDE.local.md in gitignore
- `templates/claude/settings.json` — add opusplan model
- `templates/CLAUDE.md` — memory section + tips section

## Out of Scope
- Path-specific rules with YAML frontmatter (teams add these themselves)
- Additional language-specific rules (Python, Go) — future spec
- Changes to claude-mem plugin itself
````

## File: specs/completed/045-grill-review-enhancements.md
````markdown
# Spec: Enhance /grill with scope challenge, options format, and what-exists section

> **Spec ID**: 045 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/045-grill-review-enhancements

## Goal
Adapt Garry Tan's plan-exit-review patterns into `/grill` (full) and `/review` (light) to improve review depth and actionability.

## Context
The gist introduces three valuable patterns missing from our review commands: a pre-review Scope Challenge that catches unnecessary changes early, an A/B/C options format that makes issue resolution concrete, and explicit "What already exists" / "NOT reviewed" sections. `/grill` is the adversarial deep-review that benefits from all three. `/review` is a lighter pre-commit check that gets only the "What already exists" addition. `/spec-review` already delegates to `code-reviewer` and needs no changes.

## Steps
- [x] Step 1: Add Step 0 to `templates/commands/grill.md` — before analysis, challenge scope: does this already exist? Is this the minimum viable change? Offer three paths: scope reduction / full adversarial review / compressed review
- [x] Step 2: Change issue format in `grill.md` — replace "Suggested fix" with Options A/B/C (tradeoffs + directive recommendation), using AskUserQuestion for each blocking issue
- [x] Step 3: Add "What already exists" section to `grill.md` output — grep for similar functions/patterns before flagging issues
- [x] Step 4: Add "NOT reviewed" disclaimer to `grill.md` output — explicitly list what was out of scope
- [x] Step 5: Add light "What already exists" check to `templates/commands/review.md` — one grep pass for duplicated logic before reporting findings
- [x] Step 6: Add self-verification table as final step in `grill.md` — "Double check every single claim. At the end, make a table of what you were able to verify."

## Acceptance Criteria
- [x] `/grill` starts with a scope challenge before any code analysis
- [x] Each grill finding includes labeled options (A/B/C) with a directive recommendation
- [x] Grill output includes "What already exists" and "NOT reviewed" sections
- [x] `/review` output includes a brief "What already exists" note when duplication is detected
- [x] `/grill` ends with a self-verification table listing every claim and its verification status
- [x] Both commands remain read-only (no code changes)

## Files to Modify
- `templates/commands/grill.md` — Steps 1–4, 6: scope challenge, options format, new output sections, self-verification table
- `templates/commands/review.md` — Step 5: light duplication check

## Out of Scope
- Changes to `/spec-review` (already structured with code-reviewer agent)
- ASCII flow diagrams (complexity vs. value ratio too low for shell projects)
- TODOS.md integration (we use specs instead)
````

## File: specs/completed/046-statusline-global-install.md
````markdown
# Spec: Add optional global statusline install step to ai-setup.sh

> **Spec ID**: 046 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/046-statusline-global-install

## Goal
Add an optional end-of-setup step that installs a statusline script to `~/.claude/statusline.sh` and configures it in `~/.claude/settings.json`.

## Context
Claude Code supports a configurable statusline (JSON via stdin → shell script → stdout). Since statusline config lives in `~/.claude/settings.json` (user-level, not project-level), it cannot be installed via the regular template map. This spec adds `install_statusline_global()` to `lib/setup.sh` — a one-time optional step prompted at the end of `bin/ai-setup.sh`. The script shows model, context-%, git branch, and session cost in two lines with color-coded context bar.

## Steps
- [x] Step 1: Create `templates/statusline.sh` — two-line script: line 1 = model + dir + git branch; line 2 = color-coded context bar (green/yellow/red) + cost + duration; handles null fields with fallbacks
- [x] Step 2: Add `install_statusline_global()` to `lib/setup.sh` — copies script to `~/.claude/statusline.sh`, makes it executable, merges `statusLine` field into `~/.claude/settings.json` using `jq` (idempotent: skip if already set)
- [x] Step 3: Prompt user at end of `bin/ai-setup.sh` setup phase: "Install statusline? (y/N)" — skip silently on N or if already installed
- [x] Step 4: Verify script works standalone: `echo '{"model":{"display_name":"Sonnet"},"context_window":{"used_percentage":42},"cost":{"total_cost_usd":0.05,"total_duration_ms":120000}}' | ~/.claude/statusline.sh`

## Acceptance Criteria
- [x] After install: `~/.claude/settings.json` contains `statusLine.command` pointing to `~/.claude/statusline.sh`
- [x] Script handles null `context_window.used_percentage` without crashing
- [x] Re-running setup skips the prompt if statusline is already configured (idempotent)
- [x] User can decline without any side effects

## Files to Modify
- `templates/statusline.sh` — new file (the script itself)
- `lib/setup.sh` — add install_statusline_global()
- `bin/ai-setup.sh` — call install_statusline_global() with user prompt

## Out of Scope
- Multi-theme options (one good default is enough)
- Windows/PowerShell support
- Updating an already-installed statusline (user edits ~/.claude/statusline.sh directly)
````

## File: specs/completed/047-settings-hooks-agent-memory.md
````markdown
# Spec: Enhance template settings.json with hooks, env vars, and agent memory fields

> **Spec ID**: 047 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/047-settings-hooks-agent-memory

## Goal
Add SessionStart compact hook, CLAUDE_AUTOCOMPACT_PCT_OVERRIDE, agent memory/isolation fields, PostToolUse failure-logging hook, Stop prompt hook, and ENABLE_TOOL_SEARCH to the template settings and agent files.

## Context
Gap analysis of Claude Code docs (hooks-guide, sub-agents, headless, settings, Lovable hacks) revealed seven missing best-practice configurations in the template. Context degrades at 20-40% usage (not 95%), so AUTOCOMPACT at 30 prevents silent context loss. SessionStart compact hook re-injects project context after compaction. Agent `memory: project` enables per-agent learning for reviewer agents; `isolation: worktree` protects file-writing agents. **Implement after Spec 044** — both touch `templates/claude/settings.json`.

## Steps
- [x] Step 1: Add `SessionStart` hook to `templates/claude/settings.json` — compact matcher command that re-reads STACK.md + CONVENTIONS.md after compaction
- [x] Step 2: Add `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: "30"` to `env` block in `templates/claude/settings.json`
- [x] Step 3: Add `ENABLE_TOOL_SEARCH: "true"` to `env` block in `templates/claude/settings.json` — enables MCP lazy-loading
- [x] Step 4: Add `PostToolUse` failure-logging hook to `templates/claude/settings.json` — hook script checks `$CLAUDE_TOOL_EXIT_CODE` and logs failures with timestamp to `.claude/tool-failures.log`
- [x] Step 5: Add `Stop` prompt hook to `templates/claude/settings.json` — quality gate: verify all acceptance criteria met before stopping
- [x] Step 6: Add `memory: project` field to `templates/agents/code-reviewer.md`, `templates/agents/staff-reviewer.md`, and `templates/agents/perf-reviewer.md` frontmatter
- [x] Step 7: Add `isolation: worktree` field to `templates/agents/test-generator.md` frontmatter only — context-refresher must write directly to the working tree
- [x] Step 8: Verify idempotency — existing settings.json merge must not duplicate hooks or env keys

## Acceptance Criteria
- [x] `templates/claude/settings.json` contains SessionStart compact hook, AUTOCOMPACT=30, ENABLE_TOOL_SEARCH, PostToolUse failure hook, Stop hooks
- [x] `code-reviewer.md`, `staff-reviewer.md`, and `perf-reviewer.md` have `memory: project` in frontmatter
- [x] `test-generator.md` has `isolation: worktree` in frontmatter
- [x] Running install twice produces identical results (idempotent)

## Files to Modify
- `templates/claude/settings.json` — add hooks (SessionStart, PostToolUse failure, Stop) + env vars
- `templates/agents/code-reviewer.md` — add memory field
- `templates/agents/staff-reviewer.md` — add memory field
- `templates/agents/perf-reviewer.md` — add memory field
- `templates/agents/test-generator.md` — add isolation field

## Out of Scope
- PreCompact hook (not yet stable in production use)
- Team coordination hooks (TeammateIdle, TaskCompleted) — too specialized
- LSP server integration — separate spec if needed
````

## File: specs/completed/048-reflect-context-routing.md
````markdown
# Spec: Extend /reflect with Context File Routing

> **Spec ID**: 048 | **Created**: 2026-02-28 | **Status**: completed | **Branch**: spec/048-reflect-context-routing

## Goal
Extend `/reflect` to route architectural discoveries and stack decisions into `.agents/context/` files, not just CLAUDE.md rules.

## Context
Spec 043 implemented `/reflect` for correction-to-rule conversion (CLAUDE.md, CONVENTIONS.md). Brainmaxxing analysis revealed a gap: architectural patterns, codebase gotchas, and stack decisions discovered during work have no persistent home. These belong in `.agents/context/ARCHITECTURE.md` and `.agents/context/STACK.md` — our existing project memory layer.

## Steps
- [ ] Step 1: Update `templates/commands/reflect.md` — add two new signal categories: ARCHITECTURAL (discovered patterns, component relationships, gotchas) and STACK (new deps, version decisions, tool choices discovered at runtime)
- [ ] Step 2: Extend the classification table — ARCHITECTURAL signals → `.agents/context/ARCHITECTURE.md`, STACK signals → `.agents/context/STACK.md`
- [ ] Step 3: Add context file reading step before drafting — read ARCHITECTURE.md and STACK.md to prevent duplicate additions (mirrors existing rule for CLAUDE.md/CONVENTIONS.md)
- [ ] Step 4: Update the AskUserQuestion proposal format to show all four possible target files, not just two
- [ ] Step 5: Add reflect prompt to `/commit` and `/pr` command templates — final step suggests running `/reflect` after a successful commit or PR creation

## Acceptance Criteria
- [ ] `/reflect` detects architectural and stack signals alongside correction signals
- [ ] Architectural findings route to `.agents/context/ARCHITECTURE.md`
- [ ] Stack findings route to `.agents/context/STACK.md`
- [ ] No duplicates written — reads target files before proposing additions
- [ ] All changes still require explicit user approval before writing
- [ ] `/commit` and `/pr` suggest running `/reflect` as a closing step

## Files to Modify
- `templates/commands/reflect.md` - extend signal detection and routing table
- `templates/commands/commit.md` - add reflect suggestion at end
- `templates/commands/pr.md` - add reflect suggestion at end

## Out of Scope
- `brain/` directory concept (our `.agents/context/` serves this purpose)
- `/ruminate` command for mining JSONL archives (Claude Code auto-memory covers forward-looking case)
- `/meditate` vault auditing command
````

## File: specs/completed/049-evaluate-command.md
````markdown
# Spec: Project-Local /evaluate Command for Idea Assessment

> **Spec ID**: 049 | **Created**: 2026-02-28 | **Status**: in-progress

## Goal
Create a project-local `/evaluate` command that systematically assesses external ideas (links, articles, tweets) against our existing setup and recommends adopt, adapt, replace, or reject.

## Context
Maintaining npx-ai-setup requires regular evaluation of new Claude Code patterns, community tools, and workflow ideas. Today this is done ad-hoc with inconsistent depth. A structured command ensures every evaluation covers the same criteria: gap analysis against existing templates, overhead assessment, and a concrete verdict with next steps. This is project-local (`.claude/commands/`), not distributed as a template.

## Steps
- [x] Step 1: Create `.claude/commands/evaluate.md` with frontmatter — model: opus, mode: plan, allowed-tools: Read, Glob, Grep, WebFetch, WebSearch, AskUserQuestion
- [x] Step 2: Implement input parsing — accept `$ARGUMENTS` as URL (WebFetch) or pasted text, extract all patterns/features/tools being proposed
- [x] Step 3: Implement inventory scan — Glob `templates/commands/*.md`, `templates/agents/*.md`, `templates/claude/rules/*.md`, read `templates/claude/settings.json` to build a map of what we already have
- [x] Step 4: Implement gap analysis — for each extracted pattern, classify as NEW (we lack it), BETTER (improves on ours), REDUNDANT (equivalent exists), or WORSE (ours is stronger)
- [x] Step 5: Implement verdict output — structured table per finding with classification, affected files, and recommended action (create spec / modify existing / replace / skip)
- [x] Step 6: Add final AskUserQuestion — for each ADOPT/REPLACE finding, ask user whether to create a spec immediately

## Acceptance Criteria
- [x] `/evaluate <url-or-text>` produces a structured comparison against existing templates
- [x] Each finding has a clear classification (NEW/BETTER/REDUNDANT/WORSE) and action
- [x] Command is read-only — never modifies files, only recommends
- [x] Works with both URLs (fetched via WebFetch) and inline text

## Files to Modify
- `.claude/commands/evaluate.md` - new project-local command (create)

## Out of Scope
- Distribution as a template (this is only for npx-ai-setup project maintenance)
- Auto-creating specs (only recommends, user decides)
- Evaluating non-Claude-Code tools (scoped to AI dev environment patterns)
````

## File: specs/completed/053-context-monitor-hook.md
````markdown
# Spec: Context Monitor Hook

> **Spec ID**: 053 | **Created**: 2026-03-01 | **Status**: completed | **Branch**: spec/053-context-monitor-hook

## Goal
Add a PostToolUse hook that warns the agent before context window exhaustion via statusline bridge file metrics.

## Context
Context compaction fires at AUTOCOMPACT=30% but the agent has no advance warning — it starts complex tasks moments before compaction truncates its context. A PostToolUse hook reads remaining_percentage from a bridge file written by the statusline and injects WARNING (<=35%) or CRITICAL (<=25%) into the agent's conversation via `additionalContext`. Depends on statusline being installed; degrades silently without it. Inspired by gsd-build/get-shit-done `hooks/gsd-context-monitor.js`.

## Steps
- [x] Step 1: In `templates/statusline.sh`, after line 13, read `session_id` and `remaining_percentage` from the input JSON, then write `{"session_id":"...","remaining_percentage":N,"used_pct":N,"timestamp":EPOCH}` to `/tmp/claude-ctx-{session_id}.json`
- [x] Step 2: Create `templates/claude/hooks/context-monitor.sh` — reads `session_id` from stdin JSON, reads bridge file, checks `remaining_percentage` against thresholds (WARNING <=35%, CRITICAL <=25%), outputs `{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"..."}}` to stdout; debounce via `/tmp/claude-ctx-warn-{session_id}` counter file (5 calls between warnings); severity escalation (WARNING→CRITICAL) bypasses debounce; stale bridge (>60s) ignored; all errors exit 0
- [x] Step 3: In `templates/claude/settings.json`, add a PostToolUse entry with empty matcher for `context-monitor.sh` (after the existing tool-failure logger at line 112)
- [x] Step 4: Register `context-monitor.sh` in `lib/core.sh` hook template map (same pattern as other hooks) — auto-included via dynamic find scan, no manual registration needed

## Acceptance Criteria
- [x] Statusline writes bridge file with remaining_percentage on every render
- [x] Context monitor outputs additionalContext JSON at <=35% and <=25% thresholds
- [x] Debounce prevents warning spam (5 tool calls between warnings)
- [x] Silent exit 0 when bridge file missing, stale, or jq unavailable

## Files to Modify
- `templates/statusline.sh` - add bridge file writing (~5 lines)
- `templates/claude/hooks/context-monitor.sh` - new file (create)
- `templates/claude/settings.json` - add PostToolUse entry
- `lib/core.sh` - register hook in template map

## Out of Scope
- Making context monitor work without statusline installed
- Configurable thresholds (hardcoded 35%/25% is sufficient)
- JavaScript implementation (bash only, consistent with other hooks)

## Review Feedback

**[HIGH] `templates/claude/settings.json` — `PreCompact` hook section deleted (regression)**
The PreCompact hook block that exists on `main` is entirely absent from the branch. This is an unscoped regression — the spec only adds a PostToolUse entry, it must not remove the existing `PreCompact` block. Fix: restore the PreCompact section in settings.json.

**[HIGH] `session_id` used unsanitized in file paths (path traversal)**
Both `context-monitor.sh` and `statusline.sh` interpolate `SESSION_ID` directly into `/tmp/claude-ctx-${SESSION_ID}.json` without character validation. A malicious `session_id` like `../../../tmp/evil` could write outside `/tmp`. Fix: sanitize with `SESSION_ID=$(echo "$SESSION_ID" | tr -cd 'a-zA-Z0-9_-')` before use.

**[MEDIUM] Off-by-one in debounce counter**
Counter resets to `0` after firing, suppresses when `COUNTER < 5` — result is 4 calls between warnings, not 5. Fix: change condition to `[ "$COUNTER" -lt 6 ]` (i.e. `-le 5`).

**[MEDIUM] `REMAINING_PCT` truncation causes premature threshold trigger**
`cut -d. -f1` floors instead of rounds. At `used_percentage=64.1`, remaining is `35.9` but truncates to `35`, triggering WARNING falsely. Fix: use `printf '%.0f'` or `awk 'BEGIN{printf "%d", v+0.5}' v="$val"` for rounding.

**[MEDIUM] `printf` JSON output is not safe for special characters in MESSAGE**
If MESSAGE ever contains `"` or `%`, the JSON output breaks. Fix: use `jq -n --arg msg "$MESSAGE" '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$msg}}'`.
````

## File: specs/completed/054-bang-syntax-context-injection.md
````markdown
# Spec: Bang-Syntax Context Injection

> **Spec ID**: 054 | **Created**: 2026-03-01 | **Status**: completed | **Branch**: spec/054-bang-syntax-context-injection

## Goal
Replace manual git tool-call steps in /commit, /review, /pr with bang-syntax `## Context` sections that inject state before Claude runs.

## Context
Our commands spend 2-3 tool-call round-trips gathering git state (status, diff, log) before doing actual work. Claude Code's bang syntax (`!`command``) in a `## Context` section executes shell commands and injects output directly into the command template — zero tool calls needed. Anthropic uses this pattern in their own `commit-push-pr.md`.

## Steps
- [x] Step 1: In `templates/commands/commit.md`, add `## Context` section after the description (line 7) with `!`git status``, `!`git diff --staged``, `!`git diff``, `!`git log --oneline -5``. Remove steps 1-2 from Process, replace with "Analyze the changes shown in Context above."
- [x] Step 2: In `templates/commands/review.md`, add `## Context` section after the description (line 7) with `!`git rev-parse --abbrev-ref HEAD``, `!`git diff``, `!`git diff --staged``, `!`git diff main...HEAD 2>/dev/null``. Simplify step 1 to reference Context instead of running commands.
- [x] Step 3: In `templates/commands/pr.md`, add `## Context` section after the description (line 7) with `!`git status``, `!`git diff``, `!`git log --oneline main..HEAD``, `!`git branch --show-current``. Simplify step 2 to reference Context instead of running commands.
- [x] Step 4: Verify all three commands still have correct allowed-tools, model, and mode frontmatter

## Acceptance Criteria
- [x] All three commands have a `## Context` section with bang-syntax git commands
- [x] Process steps no longer instruct Claude to run git status/diff/log manually
- [x] Existing rules, allowed-tools, and workflow logic are unchanged

## Files to Modify
- `templates/commands/commit.md` - add Context section, simplify steps
- `templates/commands/review.md` - add Context section, simplify steps
- `templates/commands/pr.md` - add Context section, simplify steps

## Out of Scope
- Adding Context sections to other commands (spec, bug, grill, etc.)
- Changing command logic or rules beyond context gathering
- Adding new git commands not already present in the current steps
````

## File: specs/completed/055-mandatory-plugins-remove-playwright.md
````markdown
# Spec: Mandatory Plugins, Remove Playwright & GSD

> **Spec ID**: 055 | **Created**: 2026-03-04 | **Status**: completed | **Branch**: spec/055-mandatory-plugins-remove-playwright

## Goal
Remove Playwright MCP and GSD from setup, make context7 and claude-mem always install, and install all official plugins without prompts. GSD moves to README as optional extension.

## Context
The current plugin system asks 5 interactive prompts during setup, contradicting the "zero configuration" philosophy. Playwright is niche and rarely needed. GSD is a separate ecosystem that should be documented as an extension, not bundled. Context7 (docs lookup) and claude-mem (persistent memory) are core features that should always be present. Official plugins provide proven value and should install by default.

## Steps
- [ ] Step 1: Remove `install_playwright()` and `install_gsd()` functions from `lib/plugins.sh` and their calls in `bin/ai-setup.sh`
- [ ] Step 2: Remove all `--with-*` / `--no-*` CLI flags from `bin/ai-setup.sh` (playwright, context7, claude-mem, plugins, gsd)
- [ ] Step 3: Modify `install_claude_mem()` in `lib/plugins.sh` — remove interactive prompt, always install
- [ ] Step 4: Modify `install_official_plugins()` in `lib/plugins.sh` — remove selection UI, install all plugins
- [ ] Step 5: Modify `install_context7()` in `lib/plugins.sh` — remove interactive prompt, always install
- [ ] Step 6: Update `.agents/context/CONCEPT.md` — remove "Optional integrations" references to GSD/Playwright
- [ ] Step 7: Add GSD to `README.md` as optional extension with install instructions
- [ ] Step 8: Verify: `./bin/ai-setup.sh --help` shows no removed flags, dry-run has zero plugin prompts

## Acceptance Criteria
- [ ] Playwright MCP and GSD are completely removed from setup code
- [ ] Running setup installs context7, claude-mem, and all official plugins without any prompts
- [ ] GSD is documented in README as optional extension
- [ ] All existing idempotency checks (skip if already installed) still work

## Files to Modify
- `lib/plugins.sh` — remove playwright + gsd, remove prompts from context7/claude-mem/official-plugins
- `bin/ai-setup.sh` — remove CLI flags, remove playwright + gsd calls
- `.agents/context/CONCEPT.md` — update integrations text
- `README.md` — add GSD as optional extension section

## Out of Scope
- Adding new plugins or MCP servers
- Changing the MCP merge logic in plugins.sh
````

## File: specs/completed/056-token-optimization-deny-patterns.md
````markdown
# Spec: Token Optimization — Deny Patterns, Tips & Settings

> **Spec ID**: 056 | **Created**: 2026-03-04 | **Status**: completed | **Branch**: spec/056-token-optimization-deny-patterns

## Goal
Expand deny patterns, add missing session tips, and configure plansDirectory to reduce token waste and improve workflow.

## Context
Current deny list covers 7 paths but misses lock files (10k+ lines), source maps, minified assets, and cache dirs. CLAUDE.md Tips section lacks checkpointing (`Esc Esc`), `/rename`+`/resume`, and commit-checkpoint advice. The `plansDirectory` setting is missing. Playwright references need removal (per spec 055). Informed by rtk, token-optimizer, ACE-FCA patterns, and Claude Code best practices.

## Steps
- [ ] Step 1: Add lock file deny patterns to `templates/claude/settings.json` — `Read(package-lock.json)`, `Read(yarn.lock)`, `Read(pnpm-lock.yaml)`, `Read(bun.lockb)`, `Read(composer.lock)`
- [ ] Step 2: Add framework/cache deny patterns — `Read(.turbo/**)`, `Read(.vercel/**)`, `Read(.svelte-kit/**)`, `Read(.cache/**)`, `Read(.parcel-cache/**)`, `Read(storybook-static/**)`
- [ ] Step 3: Add minified/generated asset deny patterns — `Read(*.min.js)`, `Read(*.min.css)`, `Read(*.map)`, `Read(*.chunk.js)`
- [ ] Step 4: Add `"plansDirectory": ".claude/plans"` and `"enableAllProjectMcpServers": true` to `templates/claude/settings.json`
- [ ] Step 5: Expand Tips section in `templates/CLAUDE.md` — add `Esc Esc` (rewind/summarize), `/rename` + `/resume`, commit-after-task checkpoint rule
- [ ] Step 6: Remove Playwright references — MCP section in CLAUDE.md, `Bash(npx playwright *)` from settings.json allow list
- [ ] Step 7: Add rtk + GSD as optional extensions in README.md
- [ ] Step 8: Verify settings.json is valid JSON and deny patterns don't block legitimate dev files

## Acceptance Criteria
- [ ] Deny list covers lock files, cache dirs, minified assets, source maps
- [ ] Tips section includes checkpointing, session management, and commit advice
- [ ] `plansDirectory` and `enableAllProjectMcpServers` are configured in settings.json
- [ ] No Playwright references remain in templates

## Files to Modify
- `templates/claude/settings.json` — deny patterns, plansDirectory, remove playwright
- `templates/CLAUDE.md` — tips expansion, remove Playwright MCP section
- `README.md` — optional extensions (rtk, GSD)

## Out of Scope
- Installing rtk automatically (external binary, user choice)
- Output Styles templates (CLAUDE.md Communication Protocol covers this)
- Beads/graph task trackers (too early, GSD covers similar needs)
````

## File: specs/completed/057-agents-md-generation.md
````markdown
# Spec: AGENTS.md Template and Auto-Init Generation

> **Spec ID**: 057 | **Created**: 2026-03-05 | **Status**: completed | **Branch**: —

## Goal
Generate an AGENTS.md file for target projects — universal passive AI context for Cursor, Windsurf, Cline, and other AGENTS.md-compatible tools.

## Context
Vercel's agent evals show passive context (AGENTS.md) achieves 100% pass rate vs 53% for skills, with 56% of skills never invoked. npx-ai-setup already generates CLAUDE.md (Claude-specific) and copilot-instructions.md (GitHub Copilot), but lacks the universal AGENTS.md standard. This spec adds AGENTS.md generation following the exact same pattern as CLAUDE.md — template copy + AI-powered project-specific content generation.

## Steps
- [x] Step 1: Create `templates/AGENTS.md` — static template with project overview placeholder, stack reference to `.agents/context/`, code style guidelines section, and `<!-- Auto-Init populates this -->` markers for Commands and Critical Rules
- [x] Step 2: Verify `build_template_map()` auto-discovers `templates/AGENTS.md` and maps it to `AGENTS.md` in target projects (no core.sh changes needed)
- [x] Step 3: Add AGENTS.md generation prompt in `lib/generate.sh` — parallel background process alongside CLAUDE.md, using Sonnet to populate project-specific sections (commands, rules, architecture summary)
- [x] Step 4: Add AGENTS.md verification block in `lib/generate.sh` after wait — check file was modified (same pattern as CLAUDE.md checksum comparison)
- [x] Step 5: Add `AGENTS.md` to `.gitignore` template exclusion check — ensure it is NOT gitignored (it should be committed like CLAUDE.md)
- [x] Step 6: Test end-to-end: fresh install creates AGENTS.md, `--regenerate` updates it, update system detects user modifications and backs up before overwrite

## Acceptance Criteria
- [x] `npx @onedot/ai-setup` creates an AGENTS.md in the target project root
- [x] AGENTS.md contains project-specific content (stack, commands, rules) after Auto-Init
- [x] AGENTS.md is tracked by `.ai-setup.json` checksums (automatic via Template-Map)
- [x] Existing AGENTS.md files are backed up before overwrite (existing update system)

## Validation Notes
- Fresh install in isolated temp project created `AGENTS.md` from template.
- `build_template_map()` resolves `templates/AGENTS.md:AGENTS.md` without core changes.
- Smart update backed up user-modified `AGENTS.md` before overwrite and removed `AGENTS.md` from `.gitignore`.
- `--regenerate` path executed the new AGENTS generation flow and verification checks; in this test environment Claude edits failed due local `token-optimizer` SQLite permissions (`sqlite3.OperationalError: unable to open database file`), so content regeneration could not be fully validated here.

## Files to Modify
- `templates/AGENTS.md` - new static template (based on CLAUDE.md structure)
- `lib/generate.sh` - add parallel AGENTS.md generation prompt + verification

## Out of Scope
- Compressed docs-index generation (framework-specific, handled by framework codemods like `npx @next/codemod agents-md`)
- Changes to skill installation strategy
- AGENTS.md support for non-Claude AI tools' specific features
````

## File: specs/completed/059-deadloop-prevention-hardening.md
````markdown
# Spec: Deadloop Prevention Hardening

> **Spec ID**: 059 | **Created**: 2026-03-08 | **Status**: completed | **Branch**: —

## Goal
Eliminate remaining deadloop risks in hooks by hardening circuit-breaker WARNING messaging and softening context-monitor action directives.

## Context
Audit identified 2 medium-severity deadloop risks: circuit-breaker WARNING (exit 0) uses soft language that may prompt Claude to retry the same file, and context-monitor outputs directive language ("Commit current work") that could trigger unnecessary git calls. post-edit-lint was verified safe (output fully suppressed).

## Steps
- [x] Step 1: In `templates/claude/hooks/circuit-breaker.sh` lines 58-62 — rewrite WARNING message to explicitly say "do NOT edit this file again" (match the BLOCK message tone), add the same structured format (file name, edit count, instructions)
- [x] Step 2: In `templates/claude/hooks/context-monitor.sh` lines 74-78 — change directive language from "Commit current work" to passive "Consider saving state" and from "wrap up immediately" to "begin wrapping up". Remove imperative verbs.
- [x] Step 3: Add a comment block at top of `templates/claude/hooks/post-edit-lint.sh` documenting WHY all output is suppressed (deadloop prevention) so future maintainers don't accidentally expose lint output
- [x] Step 4: Update `templates/claude/hooks/README.md` to note the deadloop prevention design in the circuit-breaker and context-monitor entries
- [x] Step 5: Run `bash -n` syntax check on all 3 modified hooks

## Acceptance Criteria
- [x] circuit-breaker WARNING message explicitly forbids further edits to the same file
- [x] context-monitor messages use passive/advisory language, not imperative directives
- [x] post-edit-lint has maintainer documentation explaining output suppression rationale
- [x] All hooks pass `bash -n` syntax check

## Files to Modify
- `templates/claude/hooks/circuit-breaker.sh` — WARNING message rewrite
- `templates/claude/hooks/context-monitor.sh` — soften directive language
- `templates/claude/hooks/post-edit-lint.sh` — add documentation comment
- `templates/claude/hooks/README.md` — deadloop design notes

## Out of Scope
- Token optimization of templates (spec 060)
- Changing WARN/BLOCK thresholds
- Modifying hook event types or exit codes
````

## File: specs/completed/060-template-token-optimization.md
````markdown
# Spec: Template Token Optimization

> **Spec ID**: 060 | **Created**: 2026-03-08 | **Status**: completed | **Branch**: —

## Goal
Reduce token consumption of command templates by ~13% (~2,600 tokens) by compressing the 5 largest templates and eliminating cross-file duplication.

## Context
Audit found ~2,625 recoverable tokens across templates. Biggest waste: verbose question patterns in spec.md (400t), repeated examples in reflect.md (350t), duplicated emit logic in cross-repo-context.sh (350t), inline commentary in update.md (300t), and spec-work.md content duplicated in spec-work-all.md (280t). All command templates are loaded as prompts — every saved token compounds across all users and sessions.

## Steps
- [x] Step 1: Compress `templates/commands/spec.md` Phase 1e from 30 lines of nested questions to a 5-line checklist format. Preserve all check categories, remove verbose phrasing.
- [x] Step 2: Compress `templates/commands/reflect.md` from 4 identical example blocks (CONVENTIONS, CLAUDE, ARCHITECTURE, STACK) to 1 example + "apply same pattern to other context files" note.
- [x] Step 3: Refactor `templates/claude/hooks/cross-repo-context.sh` — consolidate duplicated emit_repo_line branches, inline small helper functions.
- [x] Step 4: Compress `templates/commands/update.md` — remove inline bash commentary, reduce 15-line display template to essential structure.
- [x] Step 5: Compress `templates/commands/spec-work-all.md` — replace inline spec-work duplication with "Follow /spec-work process" reference + only worktree-specific additions.
- [x] Step 6: Remove duplication in `templates/claude/hooks/README.md` where it repeats AGENTS.md hook table content.
- [x] Step 7: Measure before/after line counts for all modified files, verify total reduction ≥ 10%.

## Acceptance Criteria
- [x] Total line count across modified files reduced by ≥ 10%
- [x] No behavioral changes — all commands produce same outcomes
- [x] All hooks pass `bash -n` syntax check
- [x] spec.md still contains all Phase 1 challenge categories

## Files to Modify
- `templates/commands/spec.md` — compress Phase 1e questions
- `templates/commands/reflect.md` — deduplicate example blocks
- `templates/claude/hooks/cross-repo-context.sh` — consolidate emit logic
- `templates/commands/update.md` — remove verbose commentary
- `templates/commands/spec-work-all.md` — reference spec-work instead of duplicate
- `templates/claude/hooks/README.md` — remove AGENTS.md duplication

## Out of Scope
- Deadloop fixes (spec 059)
- Compressing already-lean templates (test.md, commit.md, bug.md, etc.)
- Changing command behavior or thresholds
````

## File: specs/completed/069-documentation-and-agent-sweep.md
````markdown
# Spec: Agent Rules and Template Standardization

> **Spec ID**: 069 | **Created**: 2026-03-09 | **Status**: completed | **Branch**: —

## Goal
Create agent delegation rules file and standardize agent template metadata so Claude delegates correctly without being asked.

## Context
Our template ships 9 agents but no rule defining when each should be used. Agent templates have inconsistent metadata fields (some missing `memory`, others missing fields). A rules file is always active — zero user action required.

## Steps
- [x] Step 1: Create `templates/claude/rules/agents.md` with agent-to-task mapping table, trigger conditions, scope limits, and anti-patterns for over-delegation
- [x] Step 2: Standardize `templates/agents/*.md` metadata fields (ensure all agents have consistent `name`, `description`, `tools`, `model`, `max_turns` fields) — verified: already consistent, no changes needed
- [x] Step 3: Register `agents.md` in rules template map in `lib/core.sh` — verified: `build_template_map()` auto-discovers all files under `templates/claude/rules/`, no manual registration needed

## Acceptance Criteria
- [ ] `templates/claude/rules/agents.md` exists with all generated agents documented
- [ ] All agent templates use consistent metadata fields
- [ ] No runtime behavior changes — documentation only (except new rules file)

## Files to Modify
- `templates/claude/rules/agents.md` — new file
- `templates/agents/*.md` — metadata standardization
- `lib/core.sh` — register agents.md rule

## Out of Scope
- New agents or hooks
- Installer behavior changes
- Hook design principles documentation (already covered in hooks/README)
- Monorepo context guidance
````

## File: templates/agents/code-reviewer.md
````markdown
---
name: code-reviewer
description: Reviews code changes for bugs, security vulnerabilities, and spec compliance. Reports findings with HIGH/MEDIUM confidence and a PASS/CONCERNS/FAIL verdict.
tools: Read, Glob, Grep, Bash
model: sonnet
max_turns: 15
memory: project
---

You are a code reviewer. Your job is to analyze code changes and report issues — do NOT fix them.

## Behavior

1. **Get the diff**: Run `git diff` for uncommitted changes, or `git diff main...HEAD` if on a branch. If a branch name is passed in context, use `git diff main...BRANCH`.
2. **Read changed files fully**: For each changed file, read the complete file (not just the diff) to understand context.
3. **Check spec compliance** (if spec content provided):
   - Are all spec steps reflected in the changes?
   - Does the implementation match what each step described?
   - Was anything built that's listed in "Out of Scope"?
4. **Analyze code quality**:
   - **Bugs**: Logic errors, off-by-one, null/undefined, race conditions
   - **Security**: Injection, XSS, secrets exposure, OWASP top 10
   - **Performance**: N+1 queries, unnecessary re-renders, memory leaks
   - **Readability**: Unclear names, missing context, overly complex logic
5. **Report findings** with confidence levels. Only report HIGH and MEDIUM confidence issues.

## Output Format

```
## Code Review

### Spec Compliance
- [PASS/FAIL] All steps implemented
- [PASS/FAIL] No out-of-scope changes

### Issues Found
- [HIGH/MEDIUM] File:line — description and concrete risk

### Verdict
PASS / CONCERNS / FAIL

Reason: one sentence
```

## Rules
- Do NOT make any changes. Only report.
- Read the actual code — never speculate.
- If no issues found, say "No issues found" and verdict is PASS.
- CONCERNS = medium issues only. FAIL = at least one HIGH issue.
````

## File: templates/agents/liquid-linter.md
````markdown
---
name: liquid-linter
description: Runs shopify theme check and validates translation keys in Liquid templates. Use when Liquid sections, blocks, or snippets have been modified and need validation before deployment.
tools: Bash, Read, Glob, Grep
model: haiku
max_turns: 10
---

You are a Shopify Liquid validation agent. Analyze Liquid templates for errors and missing translation keys.

## Steps

1. **Run theme check**: Execute `shopify theme check --fail-level suggestion` on the project.
   - Group results by severity (error, warning, suggestion).
   - For each issue: show `file:line` and the violated rule.

2. **Check translation keys**: For each `.liquid` file that was recently modified (check `git diff --name-only HEAD` or scan all if no git context):
   - Extract all `t:` keys (e.g. `t:blocks.button.name`, `t:schema.settings.padding_top.label`).
   - Verify each key exists in `locales/en.default.json`.
   - Report any missing keys with the exact path that needs to be added.

3. **Check block.shopify_attributes**: For files in `blocks/` and `sections/`, verify that the main wrapper element includes `{{ block.shopify_attributes }}` (blocks) or `{{ section.shopify_attributes }}` (sections).

## Output Format

```
## Liquid Validation Report

### Theme Check
| Severity | Count |
|----------|-------|
| Error    | N     |
| Warning  | N     |

<details per file>

### Missing Translation Keys
- `locales/en.default.json` -> `blocks.icon-list.name` (used in blocks/icon-list.liquid:15)

### Attribute Check
- All blocks include `block.shopify_attributes`: PASS/FAIL
```

## Rules
- Do NOT fix files automatically — only report.
- If `shopify` CLI is not installed, skip theme check and focus on translation key validation.
- Ignore `t:` keys that use Shopify's built-in schema translations (e.g. `t:schema.headers.*`, `t:schema.settings.*`, `t:schema.options.*`).
````

## File: templates/agents/perf-reviewer.md
````markdown
---
name: perf-reviewer
description: Reviews code changes for performance issues. Reports findings with HIGH/MEDIUM confidence and a FAST/CONCERNS/SLOW verdict.
tools: Read, Glob, Grep, Bash
model: sonnet
max_turns: 15
memory: project
---

You are a performance reviewer. Your job is to analyze code changes and report performance issues — do NOT fix them.

## Behavior

1. **Get the diff**: Run `git diff` for uncommitted changes, or `git diff main...HEAD` if on a branch.
2. **Read changed files fully**: For each changed file, read the complete file to understand context.
3. **Analyze for performance issues** across these categories:

   **Database & I/O**
   - N+1 queries: loops that trigger individual DB queries per iteration
   - Missing indexes: queries on un-indexed columns
   - Unbounded queries: no LIMIT clause on potentially large result sets
   - Synchronous I/O in hot paths

   **Memory**
   - Memory leaks: event listeners not removed, intervals not cleared, closures retaining references
   - Large allocations in loops: objects/arrays created inside tight loops
   - Unbounded caches: maps/sets that grow without eviction

   **Frontend / React**
   - Unnecessary re-renders: missing `useMemo`, `useCallback`, `React.memo`
   - Large bundle imports: `import _ from 'lodash'` instead of `import debounce from 'lodash/debounce'`
   - Expensive operations in render: sorting/filtering without memoization

   **Algorithms**
   - O(n²) or worse: nested loops over large datasets
   - Repeated work: same computation performed multiple times without caching

4. **Report findings** with confidence levels. Only report HIGH and MEDIUM confidence issues.

## Output Format

```
## Performance Review

### Issues Found
- [HIGH/MEDIUM] File:line — description, expected impact (e.g. "N+1 query in user loop — O(n) DB calls per request")

### Verdict
FAST / CONCERNS / SLOW

Reason: one sentence
```

## Rules
- Do NOT make any changes. Only report.
- Read the actual code — never speculate about what might be slow.
- If no issues found, say "No performance issues found" and verdict is FAST.
- CONCERNS = medium issues only. SLOW = at least one HIGH issue.
- Focus on measurable impact — skip micro-optimizations that don't matter in practice.
````

## File: templates/agents/staff-reviewer.md
````markdown
---
name: staff-reviewer
description: Skeptical staff engineer review — challenges assumptions and finds production risks.
tools: Read, Glob, Grep, Bash
model: opus
permissionMode: plan
max_turns: 20
memory: project
---

You are a skeptical staff engineer reviewing a plan or implementation. Your job is to find problems before they reach production.

## Behavior

1. **Read the plan/spec/code** thoroughly. Understand what's being proposed and why.
2. **Challenge assumptions**:
   - What assumptions is this plan making? Are they valid?
   - What happens if those assumptions are wrong?
   - What's the rollback plan if this fails?
3. **Find edge cases**:
   - What happens at scale (10x, 100x current load)?
   - What happens with bad/malicious input?
   - What happens during partial failures (network, DB, external services)?
4. **Check production readiness**:
   - Is there monitoring/logging for when things go wrong?
   - Are error messages helpful for debugging?
   - Is there a migration path from the current state?
   - Does this introduce breaking changes?
5. **Evaluate trade-offs**:
   - What are we trading off with this approach?
   - Is the complexity justified by the benefit?
   - Are there simpler alternatives we haven't considered?

## Output Format

- **Verdict**: APPROVE / APPROVE WITH CONCERNS / REQUEST CHANGES
- **Key concerns**: Numbered list with severity
- **Questions for the author**: Things that need clarification
- **Suggestions**: Improvements to consider

## Rules
- Do NOT rubber-stamp. If you can't find issues, look harder.
- Be specific and constructive — vague concerns are useless.
- Focus on correctness and production safety, not style.
- Acknowledge what's done well before listing concerns.
````

## File: templates/agents/test-generator.md
````markdown
---
name: test-generator
description: Generates missing tests for changed files. Detects the project test framework and writes tests only into test directories.
tools: Read, Write, Glob, Grep, Bash
model: sonnet
max_turns: 20
isolation: worktree
---

You are a test generator. Your job is to write missing tests for recently changed code.

## HARD CONSTRAINT

You may ONLY write files inside these directories:
- `test/`
- `tests/`
- `__tests__/`
- `spec/`
- `src/**/__tests__/` (co-located tests)
- `src/**/*.test.*` (co-located test files)
- `src/**/*.spec.*` (co-located spec files)

Do NOT write or modify any file outside these paths. If you are unsure whether a path is a test path, skip it.

## Behavior

1. **Get the diff**: Run `git diff` for uncommitted changes, or `git diff main...HEAD` if on a branch. Identify all changed source files (exclude test files themselves).

2. **Detect test framework**:
   - Check `package.json` for: `jest`, `vitest`, `mocha`, `ava`, `jasmine`, `playwright`, `cypress`
   - Find existing test files with Glob patterns `**/*.test.*` and `**/*.spec.*` (exclude node_modules) to confirm patterns
   - Read one existing test file to understand import style, assertion style, and mocking patterns

3. **Identify untested paths**: For each changed source file:
   - Read the full file
   - List exported functions, classes, and components
   - Check if a corresponding test file already exists
   - Identify which exports lack test coverage in the existing tests

4. **Generate tests**:
   - Write tests following the exact style and patterns of existing tests in the project
   - Use the same import syntax (ESM/CJS), the same assertion library, the same mocking approach
   - Cover: happy path, error/edge cases, boundary conditions
   - Keep tests focused and independent — no shared mutable state between tests
   - Add a comment at the top: `// Generated by test-generator agent — review before committing`

5. **Report**: List all files written and what they cover.

## Output Format

```
## Test Generation Report

### Framework Detected
- Framework: [jest/vitest/mocha/etc]
- Pattern: [test/*.test.ts / src/**/__tests__/*.ts / etc]

### Tests Written
- `test/foo.test.ts` — covers: functionA (happy path, null input), functionB (error case)

### Skipped
- `src/bar.ts` — reason (e.g. "test file already exists and covers all exports")

### Verdict
DONE / PARTIAL / SKIPPED

Reason: one sentence
```

## Rules
- NEVER write outside test directories (see HARD CONSTRAINT above).
- For co-located tests: before writing, verify the target filename ends with `.test.*` or `.spec.*` — never write a file without these suffixes.
- NEVER modify existing test files — only create new ones.
- If no test framework is detected, report it and stop.
- If an existing test file already covers the changed code, skip it and note why.
- Generated tests must run without modification — use real imports, not pseudocode.
- Always add the `// Generated by test-generator agent` comment at the top of each file.
````

## File: templates/claude/hooks/circuit-breaker.sh
````bash
#!/bin/bash
# Circuit Breaker: Detects when Claude is going in circles
# Tracks edit frequency per file. Warns at 5x, blocks at 8x within 10 min.
# Dead-loop protection: BLOCK message explicitly forbids retry attempts.
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

PROJ_HASH=$(echo "$PWD" | shasum | cut -c1-8)
LOG="/tmp/claude-cb-${PROJ_HASH}.log"
NOW=$(date +%s)
WINDOW=600
WARN=5
BLOCK=8

echo "$NOW $FILE_PATH" >> "$LOG"

CUTOFF=$((NOW - WINDOW))
awk -v c="$CUTOFF" '$1 >= c' "$LOG" > "${LOG}.tmp" 2>/dev/null && mv "${LOG}.tmp" "$LOG"

COUNT=$(grep -cF "$FILE_PATH" "$LOG" 2>/dev/null || echo 0)

if [ "$COUNT" -ge "$BLOCK" ]; then
  echo "⛔ CIRCUIT BREAKER TRIGGERED — Edit blocked." >&2
  echo "" >&2
  echo "File    : ${FILE_PATH}" >&2
  echo "Edits   : ${COUNT}x in the last 10 minutes" >&2
  echo "" >&2

  # Show recent edit timestamps so Claude understands the pattern
  echo "Recent edit history (last 10):" >&2
  grep -F "$FILE_PATH" "$LOG" | tail -10 | while read -r ts _; do
    DELTA=$(( NOW - ts ))
    echo "  — ${DELTA}s ago" >&2
  done
  echo "" >&2

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
  echo "STOP. DO NOT attempt another edit to this file." >&2
  echo "DO NOT retry the same approach." >&2
  echo "DO NOT spawn a sub-agent that edits files." >&2
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
  echo "" >&2
  echo "Required action:" >&2
  echo "  1. STOP all edit attempts immediately." >&2
  echo "  2. Summarize to the user: what were you trying to fix?" >&2
  echo "  3. Describe what approach you tried and why it failed." >&2
  echo "  4. Ask the user for a different strategy or guidance." >&2
  echo "" >&2
  echo "If you need to diagnose a build failure, you may spawn a" >&2
  echo "READ-ONLY Haiku sub-agent (no Write/Edit tools) to analyze" >&2
  echo "the error — but do NOT have it edit any files." >&2
  echo "" >&2
  echo "(Circuit breaker resets when the user sends the next message)" >&2
  exit 2
fi

if [ "$COUNT" -ge "$WARN" ]; then
  echo "⚠️  CIRCUIT BREAKER WARNING — Stop and reassess now." >&2
  echo "" >&2
  echo "File    : ${FILE_PATH}" >&2
  echo "Edits   : ${COUNT}x in the last 10 minutes (blocks at ${BLOCK})" >&2
  echo "" >&2
  echo "DO NOT edit this file again until a different approach is chosen." >&2
  echo "DO NOT retry the same fix on the same file." >&2
  echo "If diagnosis is needed, use a read-only Haiku agent first." >&2
fi

exit 0
````

## File: templates/claude/hooks/config-change-audit.sh
````bash
#!/bin/bash
# config-change-audit.sh — ConfigChange hook
# Logs config mutations and blocks unsafe settings in user/project/local scopes.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // empty' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"
printf '%s CONFIG_CHANGE source=%s file=%s\n' \
  "$(date -u +%FT%TZ)" "$SOURCE" "${FILE_PATH:-n/a}" >> "$LOG_DIR/config-changes.log"

# policy_settings cannot be blocked by Claude Code; keep this as audit-only.
[ "$SOURCE" = "policy_settings" ] && exit 0

# Security/compliance guardrails for mutable settings files.
if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
  if jq -e '.disableAllHooks == true' "$FILE_PATH" >/dev/null 2>&1; then
    echo "Blocked config change: disableAllHooks=true is not allowed in this setup." >&2
    exit 2
  fi

  if jq -e '.permissions.allow[]? | select(. == "Bash(*)")' "$FILE_PATH" >/dev/null 2>&1; then
    echo "Blocked config change: wildcard Bash(*) permission is not allowed." >&2
    exit 2
  fi
fi

exit 0
````

## File: templates/claude/hooks/context-freshness.sh
````bash
#!/bin/bash
# context-freshness.sh — UserPromptSubmit hook
# Warns when .agents/context/ files may be outdated (package.json or tsconfig changed)
# Silent pass when up-to-date or state file missing (~10ms runtime, no API calls)
#
# Cache note: Warning is injected as stderr output (shown as a system message in Claude's turn),
# NOT by editing CLAUDE.md. This preserves the prompt cache prefix — editing static layers
# mid-session would invalidate the cache for all subsequent turns.

STATE_FILE=".agents/context/.state"
[ ! -f "$STATE_FILE" ] && exit 0

# Read stored hashes
STORED_PKG=""
STORED_TSC=""
while IFS='=' read -r key val; do
  case "$key" in
    PKG_HASH) STORED_PKG="$val" ;;
    TSCONFIG_HASH) STORED_TSC="$val" ;;
  esac
done < "$STATE_FILE"

CHANGED=""

# Compare package.json
if [ -n "$STORED_PKG" ] && [ -f "package.json" ]; then
  CURRENT_PKG=$(cksum package.json 2>/dev/null | cut -d' ' -f1,2)
  [ "$CURRENT_PKG" != "$STORED_PKG" ] && CHANGED="package.json"
fi

# Compare tsconfig.json
if [ -n "$STORED_TSC" ] && [ -f "tsconfig.json" ]; then
  CURRENT_TSC=$(cksum tsconfig.json 2>/dev/null | cut -d' ' -f1,2)
  [ "$CURRENT_TSC" != "$STORED_TSC" ] && CHANGED="${CHANGED:+$CHANGED, }tsconfig.json"
fi

if [ -n "$CHANGED" ]; then
  echo "[CONTEXT STALE] Project context may be outdated ($CHANGED changed since last setup)." >&2
fi

exit 0
````

## File: templates/claude/hooks/mcp-health.sh
````bash
#!/bin/bash
# mcp-health.sh — SessionStart hook
# Validates .mcp.json on session start: JSON syntax, required fields per server type,
# and existence of base commands for stdio servers.
# Silent on success. Outputs warnings to stderr (shown as system messages in Claude's turn).
# Max runtime: 5s. Exits 0 always — warnings are informational only.

MCP_FILE="${CLAUDE_PROJECT_DIR:-.}/.mcp.json"
[ ! -f "$MCP_FILE" ] && exit 0

# Require jq
if ! command -v jq > /dev/null 2>&1; then
  echo "[MCP HEALTH] jq not found — skipping .mcp.json validation" >&2
  exit 0
fi

# Validate JSON syntax
if ! jq empty "$MCP_FILE" 2>/dev/null; then
  echo "[MCP HEALTH] .mcp.json has invalid JSON syntax — fix before MCP servers will load" >&2
  exit 0
fi

# Iterate over servers
WARNINGS=""

while IFS= read -r server_name; do
  [ -z "$server_name" ] && continue

  TYPE=$(jq -r --arg s "$server_name" '.mcpServers[$s].type // "stdio"' "$MCP_FILE" 2>/dev/null)

  case "$TYPE" in
    http|sse)
      URL=$(jq -r --arg s "$server_name" '.mcpServers[$s].url // empty' "$MCP_FILE" 2>/dev/null)
      if [ -z "$URL" ]; then
        WARNINGS="${WARNINGS}  - $server_name (${TYPE}): missing required field 'url'\n"
      fi
      ;;
    stdio|*)
      CMD=$(jq -r --arg s "$server_name" '.mcpServers[$s].command // empty' "$MCP_FILE" 2>/dev/null)
      if [ -z "$CMD" ]; then
        WARNINGS="${WARNINGS}  - $server_name (stdio): missing required field 'command'\n"
      else
        # Check that the base executable exists
        BASE_CMD=$(echo "$CMD" | awk '{print $1}')
        if ! command -v "$BASE_CMD" > /dev/null 2>&1; then
          WARNINGS="${WARNINGS}  - $server_name (stdio): command not found: $BASE_CMD\n"
        fi
      fi
      ;;
  esac
done < <(jq -r '.mcpServers | keys[]' "$MCP_FILE" 2>/dev/null)

if [ -n "$WARNINGS" ]; then
  printf "[MCP HEALTH] .mcp.json issues detected:\n%b" "$WARNINGS" >&2
fi

exit 0
````

## File: templates/claude/hooks/post-tool-failure-log.sh
````bash
#!/bin/bash
# post-tool-failure-log.sh — PostToolUseFailure hook
# Appends a compact one-line failure record to .claude/tool-failures.log.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null)
ERR=$(echo "$INPUT" | jq -r '.error // "unknown error"' 2>/dev/null)
INTERRUPT=$(echo "$INPUT" | jq -r '.is_interrupt // false' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"

ERR_ONELINE=$(printf '%s' "$ERR" \
  | tr '\r\n' '  ' \
  | sed 's/[[:space:]]\+/ /g' \
  | cut -c1-400)

printf '%s TOOL_FAIL tool=%s interrupt=%s error=%s\n' \
  "$(date -u +%FT%TZ)" "$TOOL" "$INTERRUPT" "$ERR_ONELINE" >> "$LOG_DIR/tool-failures.log"

exit 0
````

## File: templates/claude/hooks/task-completed-gate.sh
````bash
#!/bin/bash
# task-completed-gate.sh — TaskCompleted hook
# Prevents clearly incomplete task closures and logs task completion attempts.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
TASK_ID=$(echo "$INPUT" | jq -r '.task_id // "unknown"' 2>/dev/null)
TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task_subject // ""' 2>/dev/null)
TASK_DESCRIPTION=$(echo "$INPUT" | jq -r '.task_description // ""' 2>/dev/null)
TEAMMATE_NAME=$(echo "$INPUT" | jq -r '.teammate_name // "n/a"' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"
printf '%s TASK_COMPLETED id=%s teammate=%s subject=%s\n' \
  "$(date -u +%FT%TZ)" "$TASK_ID" "$TEAMMATE_NAME" "$(printf '%s' "$TASK_SUBJECT" | tr '\r\n' '  ' | sed 's/[[:space:]]\+/ /g' | cut -c1-200)" \
  >> "$LOG_DIR/task-completed.log"

# Block obviously unfinished placeholders in task metadata.
if printf '%s\n%s' "$TASK_SUBJECT" "$TASK_DESCRIPTION" | grep -qiE '\b(TODO|TBD|WIP)\b'; then
  echo "Task completion blocked: task still contains TODO/TBD/WIP markers." >&2
  exit 2
fi

# Block unresolved merge conflict markers in tracked files.
if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
  if git grep -n -E '^(<<<<<<<|=======|>>>>>>>)' -- . >/dev/null 2>&1; then
    echo "Task completion blocked: unresolved merge conflict markers found." >&2
    exit 2
  fi
fi

exit 0
````

## File: templates/claude/rules/agents.md
````markdown
# Agent Delegation Rules

Use agents for focused, isolated work. Call them directly — do not ask the user first.

## When to Delegate

| Agent | Trigger | Model |
|-------|---------|-------|
| build-validator | After code changes, before marking work done | haiku |
| code-reviewer | After completing a spec or feature branch | sonnet |
| code-architect | Before implementing high-complexity specs or multi-system changes | opus |
| context-refresher | When stack, architecture, or conventions have changed | haiku |
| perf-reviewer | After changes to hot paths, loops, data fetching, or bundle-affecting code | sonnet |
| staff-reviewer | Final review before merging significant changes | opus |
| test-generator | After adding new functions or modules that lack test coverage | sonnet |
| verify-app | After spec completion to validate tests, build, and functionality | sonnet |
| liquid-linter | After editing Liquid templates in Shopify projects | haiku |

## When NOT to Delegate

- Single-file reads or searches — use Read/Glob/Grep directly
- Trivial fixes (typos, config tweaks) — faster to do inline
- Tasks requiring fewer than 3 tool calls — agent startup overhead exceeds the work
- Follow-up edits after a review — apply fixes yourself, do not re-delegate

## Scope Limits

- Agents report findings — they do not fix issues unless their description says otherwise
- `test-generator` writes tests only; it does not modify source code
- `code-architect` and `staff-reviewer` run in plan mode — they cannot edit files
- `build-validator` runs commands but does not write code
````

## File: templates/claude/rules/general.md
````markdown
# General Coding Rules

## Read Before Modify
Always read a file before modifying it. Never assume contents from memory or prior context.
After context compaction, re-read files before continuing work — do not assume what was already done.

## Check Before Creating
Before creating a new file, check if one already exists:
- Run `ls` or Glob to find existing files matching the concept
- Run `git ls-files` to see tracked files that may not be visible

## Verify, Don't Guess
Never assume import paths, function names, or API routes. Verify by reading the relevant file.
When unsure about current state, run `git diff` to see what has actually changed this session.

## Subagent Model Routing
When spawning subagents via the Agent tool, always set the model parameter:
- `model: haiku` — Explore agents, file search, codebase questions, simple research
- `model: sonnet` — Implementation, code generation, test writing
- `model: opus` — Architecture review, complex analysis, spec creation
Never spawn Explore or search agents without `model: haiku`.

## Human Approval Gates
Before finalizing any deliverable, present a summary and ask for confirmation.
Never proceed to the next workflow phase without explicit user approval.
````

## File: templates/claude/rules/git.md
````markdown
# Git Rules

## Commit Message Format
Use Conventional Commits: `type(scope): description`
Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `perf`, `ci`
Examples:
- `feat(auth): add OAuth2 login flow`
- `fix(cart): prevent negative quantity on decrement`
- `chore: update dependencies`

Keep the subject line under 72 characters.
Use the body to explain *why*, not *what* — the diff shows what changed.

## Branch Naming
Feature branches: `feat/short-description`
Bug fixes: `fix/short-description`
Spec branches: `spec/NNN-description`
Chore/tooling: `chore/short-description`

## Safety Rules
Never force-push to `main` or `master`.
Never use `--no-verify` to skip hooks — fix the underlying issue instead.
Never use `--no-gpg-sign` unless explicitly requested by the user.
Never `git reset --hard` without confirming with the user first.

## Commit Hygiene
One logical change per commit — do not bundle unrelated changes.
Stage specific files rather than `git add -A` to avoid committing secrets or generated artifacts.
Always review `git diff --staged` before committing.
````

## File: templates/claude/rules/testing.md
````markdown
# Testing Rules

## Test First
Write tests before or alongside implementation — never after the fact as an afterthought.
When fixing a bug, write a failing test that reproduces it first, then fix the code.

## Assertion Expectations
Assert the specific value, not just that something is truthy.
Prefer `expect(result).toBe(42)` over `expect(result).toBeTruthy()`.
Include the expected value in assertion messages to aid debugging.

## Edge Case Coverage
Every function must cover: empty input, null/undefined, boundary values, and error paths.
Do not only test the happy path — edge cases are where bugs live.

## No Mocks by Default
Prefer real implementations over mocks.
Only mock: network calls, external services, file system side effects, and time-dependent behavior.
When mocking, document why a real implementation could not be used.

## Isolation
Each test must be fully independent — no shared mutable state between tests.
Reset all side effects in `afterEach` / `teardown` blocks.
Tests must pass in any order and when run in isolation.

## Test Naming
Use descriptive names that explain the scenario and expected outcome:
`it("returns null when the user ID does not exist")` not `it("works correctly")`.
````

## File: templates/claude/rules/typescript.md
````markdown
# TypeScript Rules

## Strict Types
Enable and maintain `strict: true` in `tsconfig.json`.
Never disable strictness to silence errors — fix the types instead.

## No `any`
Do not use `any` unless wrapping third-party code with no types available.
If you must use `any`, add an inline comment explaining why: `// any: no types available for legacy-sdk`.
Prefer `unknown` over `any` when the type is genuinely unknown — it forces you to narrow before use.

## Prefer Type Inference
Let TypeScript infer types where the value is obvious:
```ts
// Good — type inferred as string[]
const names = items.map(i => i.name);

// Unnecessary annotation
const names: string[] = items.map(i => i.name);
```
Add explicit annotations at public API boundaries (function parameters, return types, exported constants).

## Use Existing Project Patterns
Before adding a new type, check `types/`, `@/types/`, or adjacent files for existing definitions.
Do not duplicate types that already exist elsewhere in the project.
Follow the naming conventions already in use (e.g., `PascalCase` for interfaces and types, `UPPER_SNAKE_CASE` for enums).

## Type Narrowing
Use type guards and narrowing instead of casting:
```ts
// Prefer narrowing
if (typeof value === "string") { ... }

// Avoid casting unless truly necessary
const name = value as string;
```

## Avoid Non-Null Assertions
Do not use `!` (non-null assertion) unless you have verified the value is never null at that point.
Prefer optional chaining (`?.`) and nullish coalescing (`??`) instead.
````

## File: templates/commands/spec-validate.md
````markdown
---
model: sonnet
mode: plan
argument-hint: "[spec number]"
allowed-tools: Read, Glob, Grep, AskUserQuestion
---

Validates spec $ARGUMENTS against 10 quality metrics before execution. Run before `/spec-work` to catch weak specs early.

## Process

### 1. Find the spec
If `$ARGUMENTS` is a number (e.g. `011`), open `specs/011-*.md`. If it's a filename, open that directly. If empty, list all draft specs in `specs/` and ask which to validate.

### 2. Validate status
Only validate specs with `Status: draft`. If `in-progress`, `in-review`, or `completed` → report status and stop.

### 3. Load context
Read `.agents/context/CONVENTIONS.md` if it exists — use it to calibrate expectations for test coverage, code patterns, and integration standards.

### 4. Score the spec

Evaluate each metric from 0–100. Be strict — a spec that doesn't answer the question scores ≤50.

| # | Metric | Question to answer |
|---|--------|--------------------|
| 1 | **Goal Clarity** | Is the one-sentence goal specific, bounded, and measurable? Can you tell when it's done? |
| 2 | **Step Decomposition** | Are steps atomic and each achievable in one focused session? No "implement X" megasteps. |
| 3 | **Dependency Identification** | Are external dependencies (other specs, APIs, libs, env vars) named explicitly? |
| 4 | **Coverage Completeness** | Do the steps collectively cover the entire goal — nothing obviously missing? |
| 5 | **Acceptance Criteria Quality** | Are criteria specific and testable (not vague)? Can each be checked YES/NO? |
| 6 | **Scope Coherence** | Is the scope realistic for a single spec? Not too large, not trivially small? |
| 7 | **Risk & Blockers** | Are known risks, ambiguities, or potential blockers mentioned (in Context or Out of Scope)? |
| 8 | **File Coverage** | Are all files that will realistically change listed in "Files to Modify"? |
| 9 | **Out of Scope Clarity** | Is scope exclusion precise enough to prevent creep during execution? |
| 10 | **Integration Awareness** | Does the spec account for how changes integrate with existing code, tests, or systems? |

### 5. Present results

Display a score table:

```
Spec Validation — NNN: [title]
─────────────────────────────────────────
 1. Goal Clarity ................ XX
 2. Step Decomposition .......... XX
 3. Dependency Identification ... XX
 4. Coverage Completeness ........ XX
 5. Acceptance Criteria Quality .. XX
 6. Scope Coherence .............. XX
 7. Risk & Blockers .............. XX
 8. File Coverage ................ XX
 9. Out of Scope Clarity ......... XX
10. Integration Awareness ........ XX
─────────────────────────────────────────
   Average: XX.X    Minimum: XX
   Threshold: 80 avg / 65 min
   Result: PASS ✓  |  FAIL ✗
```

### 6. Verdict

**PASS** (avg ≥ 80 AND no metric < 65):
- Report: "Spec NNN is ready for execution. Run `/spec-work NNN`."
- No changes to the spec file.

**FAIL** (avg < 80 OR any metric < 65):
- List every metric below threshold with a specific, actionable improvement (1-2 sentences per issue).
- Do NOT make changes to the spec. Let the user revise it.
- Report: "Spec NNN needs improvement before execution. Fix the issues above and re-run `/spec-validate NNN`."

## Rules
- **Read-only** — never modify the spec or any file.
- Score honestly. A spec that passes with weak scores wastes execution compute.
- Only report metrics that actually fail. Don't pad passing specs with warnings.
- This command does NOT block `/spec-work` — it's advisory. But weak specs ship weak code.
````

## File: templates/skills/shopify-app-dev/SKILL.md
````markdown
---
name: shopify-app-dev
description: Expert guidance for Shopify app development including OAuth, embedded apps, Polaris UI, App Bridge, webhooks, billing API, and Remix-based app structure
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Shopify App Development

## When to use this skill

Use this skill when:

- Creating a new Shopify app
- Building app extensions (admin, checkout, etc.)
- Embedding UI in the Shopify admin
- Working with OAuth and app authentication
- Managing webhooks and app events
- Using Shopify Polaris UI components
- Deploying apps to the Shopify App Store

## App Types

### Public Apps

- Distributed via the Shopify App Store
- Available to all merchants
- Require app review process

### Custom Apps

- Built for a single merchant/organization
- Direct installation (no app store)
- Simpler distribution

### Sales Channel Apps

- Integrate a sales channel with Shopify
- Appear in the Shopify admin's sales channels

## Getting Started

### 1. Create a New App

```bash
# Initialize a new app
shopify app init

# Choose a template:
# - Remix (recommended)
# - Node
# - Ruby
# - PHP
```

### 2. Project Structure (Remix Template)

```
my-app/
├── app/
│   ├── routes/
│   │   ├── app._index.jsx      # Main app page
│   │   ├── app.products.jsx    # Products page
│   │   └── webhooks.jsx        # Webhook handlers
│   ├── shopify.server.js       # Shopify API config
│   └── root.jsx                # Root layout
├── extensions/                  # App extensions
├── prisma/                      # Database schema
├── shopify.app.toml            # App configuration
└── package.json
```

### 3. Start Development

```bash
# Start dev server with tunnel
shopify app dev

# View app info
shopify app info
```

## App Configuration

### shopify.app.toml

```toml
name = "My App"
client_id = "your-api-key"

[access_scopes]
scopes = "read_products, write_products, read_orders"

[webhooks]
api_version = "2025-01"

[[webhooks.subscriptions]]
topics = ["products/create", "orders/create"]
uri = "/webhooks"

[app_proxy]
url = "https://myapp.example.com/proxy"
subpath = "app-proxy"
prefix = "apps"
```

### Environment Variables

```env
SHOPIFY_API_KEY=your-api-key
SHOPIFY_API_SECRET=your-api-secret
SCOPES=read_products,write_products
HOST=https://your-tunnel-url.ngrok.io
```

## Authentication

### Session Tokens (Recommended)

Apps embedded in the Shopify admin use session tokens:

```javascript
// app/shopify.server.js
import "@shopify/shopify-app-remix/adapters/node";
import { AppDistribution, shopifyApp } from "@shopify/shopify-app-remix/server";

const shopify = shopifyApp({
  apiKey: process.env.SHOPIFY_API_KEY,
  apiSecretKey: process.env.SHOPIFY_API_SECRET,
  scopes: process.env.SCOPES?.split(","),
  appUrl: process.env.SHOPIFY_APP_URL,
  distribution: AppDistribution.AppStore,
});

export default shopify;
```

### Admin API Access

```javascript
import { authenticate } from "../shopify.server";

export async function loader({ request }) {
  const { admin } = await authenticate.admin(request);

  const response = await admin.graphql(`
    query {
      products(first: 10) {
        nodes {
          id
          title
          handle
        }
      }
    }
  `);

  const data = await response.json();
  return json({ products: data.data.products.nodes });
}
```

## App Extensions

### Extension Types

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| **Admin UI**     | Embedded UI in Shopify admin        |
| **Admin Action** | Action buttons in admin             |
| **Admin Block**  | Content blocks in admin             |
| **Checkout UI**  | Custom checkout experience          |
| **Theme App**    | Integrate with merchant themes      |
| **POS UI**       | Point of Sale extensions            |
| **Flow**         | Workflow automation                 |
| **Functions**    | Backend logic (discounts, shipping) |

### Create an Extension

```bash
# Generate an extension
shopify app generate extension

# Choose extension type from the list
```

### Admin UI Extension Example

```jsx
// extensions/admin-block/src/BlockExtension.jsx
import {
  reactExtension,
  useApi,
  AdminBlock,
  Text,
  BlockStack,
  InlineStack,
  Button,
} from "@shopify/ui-extensions-react/admin";

export default reactExtension("admin.product-details.block.render", () => (
  <ProductBlock />
));

function ProductBlock() {
  const { data } = useApi();

  return (
    <AdminBlock title="Custom Block">
      <BlockStack>
        <Text>Product ID: {data.selected[0]?.id}</Text>
        <InlineStack>
          <Button onPress={() => console.log("clicked")}>Action</Button>
        </InlineStack>
      </BlockStack>
    </AdminBlock>
  );
}
```

### Theme App Extension

```jsx
// extensions/theme-block/blocks/product-rating.liquid
{% schema %}
{
  "name": "Product Rating",
  "target": "section",
  "settings": [
    {
      "type": "product",
      "id": "product",
      "label": "Product"
    }
  ]
}
{% endschema %}

<div class="product-rating">
  <app-block-rating product-id="{{ block.settings.product.id }}">
  </app-block-rating>
</div>

{% javascript %}
  // Your JavaScript here
{% endjavascript %}

{% stylesheet %}
  .product-rating {
    padding: 16px;
  }
{% endstylesheet %}
```

## Polaris UI Components

### Basic Layout

```jsx
import {
  Page,
  Layout,
  Card,
  Text,
  BlockStack,
  InlineStack,
  Button,
  TextField,
  Select,
  Banner,
  List,
} from "@shopify/polaris";

export default function ProductPage() {
  return (
    <Page title="Products" primaryAction={{ content: "Create product" }}>
      <Layout>
        <Layout.Section>
          <Card>
            <BlockStack gap="300">
              <Text as="h2" variant="headingMd">
                Product Details
              </Text>
              <TextField label="Title" value={title} onChange={setTitle} />
              <Select
                label="Status"
                options={[
                  { label: "Active", value: "active" },
                  { label: "Draft", value: "draft" },
                ]}
                value={status}
                onChange={setStatus}
              />
            </BlockStack>
          </Card>
        </Layout.Section>

        <Layout.Section variant="oneThird">
          <Card>
            <Text as="h2" variant="headingMd">
              Summary
            </Text>
          </Card>
        </Layout.Section>
      </Layout>
    </Page>
  );
}
```

### Data Table

```jsx
import { IndexTable, Card, Text } from "@shopify/polaris";

function ProductTable({ products }) {
  const rowMarkup = products.map((product, index) => (
    <IndexTable.Row id={product.id} key={product.id} position={index}>
      <IndexTable.Cell>
        <Text variant="bodyMd" fontWeight="bold">
          {product.title}
        </Text>
      </IndexTable.Cell>
      <IndexTable.Cell>{product.status}</IndexTable.Cell>
      <IndexTable.Cell>{product.inventory}</IndexTable.Cell>
    </IndexTable.Row>
  ));

  return (
    <Card>
      <IndexTable
        itemCount={products.length}
        headings={[
          { title: "Product" },
          { title: "Status" },
          { title: "Inventory" },
        ]}
        selectable={false}
      >
        {rowMarkup}
      </IndexTable>
    </Card>
  );
}
```

## Webhooks

### Register Webhooks

```toml
# shopify.app.toml
[[webhooks.subscriptions]]
topics = ["products/create", "products/update", "products/delete"]
uri = "/webhooks"
```

### Handle Webhooks

```javascript
// app/routes/webhooks.jsx
import { authenticate } from "../shopify.server";

export async function action({ request }) {
  const { topic, shop, payload } = await authenticate.webhook(request);

  switch (topic) {
    case "PRODUCTS_CREATE":
      console.log("Product created:", payload.id);
      // Handle product creation
      break;
    case "PRODUCTS_UPDATE":
      console.log("Product updated:", payload.id);
      // Handle product update
      break;
    case "ORDERS_CREATE":
      console.log("Order created:", payload.id);
      // Handle new order
      break;
  }

  return new Response("OK", { status: 200 });
}
```

## Metafields

### Reading Metafields

```javascript
const response = await admin.graphql(`
  query {
    product(id: "gid://shopify/Product/123456") {
      metafield(namespace: "custom", key: "care_instructions") {
        value
        type
      }
      metafields(first: 10) {
        nodes {
          namespace
          key
          value
          type
        }
      }
    }
  }
`);
```

### Writing Metafields

```javascript
const response = await admin.graphql(
  `
  mutation metafieldsSet($metafields: [MetafieldsSetInput!]!) {
    metafieldsSet(metafields: $metafields) {
      metafields {
        key
        value
      }
      userErrors {
        field
        message
      }
    }
  }
`,
  {
    variables: {
      metafields: [
        {
          ownerId: "gid://shopify/Product/123456",
          namespace: "custom",
          key: "care_instructions",
          value: "Machine wash cold",
          type: "single_line_text_field",
        },
      ],
    },
  },
);
```

## Deployment

### Deploy to Shopify

```bash
# Deploy app and extensions
shopify app deploy

# Deploy specific version
shopify app versions list
shopify app release --version VERSION_ID
```

### App Store Submission

1. Complete Partner Dashboard app listing
2. Add required app store assets
3. Submit for review
4. Address review feedback
5. Publish approved app

## CLI Commands Reference

| Command                          | Description      |
| -------------------------------- | ---------------- |
| `shopify app init`               | Create new app   |
| `shopify app dev`                | Start dev server |
| `shopify app deploy`             | Deploy app       |
| `shopify app generate extension` | Create extension |
| `shopify app info`               | View app info    |
| `shopify app env show`           | Show environment |
| `shopify app versions list`      | List versions    |

## Best Practices

1. **Use session tokens** - More secure than API keys
2. **Handle rate limits** - Implement retry logic
3. **Validate webhooks** - Verify HMAC signatures
4. **Test on dev stores** - Use development stores
5. **Follow Polaris guidelines** - Consistent UX
6. **Monitor app health** - Track errors and performance

## Resources

- [App Development Docs](https://shopify.dev/docs/apps/build)
- [Polaris Components](https://polaris.shopify.com)
- [App Bridge](https://shopify.dev/docs/api/app-bridge)
- [Admin API Reference](https://shopify.dev/docs/api/admin-graphql)
- [App Store Requirements](https://shopify.dev/docs/apps/store/requirements)

For backend functions, see the [shopify-functions](../shopify-functions/SKILL.md) skill.
For checkout customization, see the [checkout-customization](../checkout-customization/SKILL.md) skill.
````

## File: templates/skills/shopify-checkout/SKILL.md
````markdown
---
name: shopify-checkout
description: Expert guidance for Shopify checkout customization including Checkout UI extensions, thank-you page extensions, post-purchase extensions, and branding
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Checkout Customization

## When to use this skill

Use this skill when:

- Building checkout UI extensions
- Adding custom fields to checkout
- Implementing payment customizations
- Creating post-purchase upsells
- Extending customer account pages
- Customizing the checkout experience
- Adding custom validation logic

## Overview

Checkout customization uses extensions that are:

- **Upgrade-safe** - Work with Shop Pay and new features
- **Performant** - Run in a sandboxed environment
- **Secure** - Limited access for security

### Extension Types

| Type                  | Description                  |
| --------------------- | ---------------------------- |
| **Checkout UI**       | Add custom UI to checkout    |
| **Post-purchase**     | Upsells after order          |
| **Customer Accounts** | Extend account pages         |
| **Thank You**         | Customize order confirmation |
| **Order Status**      | Extend order tracking        |

## Getting Started

### 1. Create Checkout Extension

```bash
# In an existing app
shopify app generate extension

# Select: Checkout UI
```

### 2. Extension Structure

```
extensions/
└── checkout-ui/
    ├── src/
    │   └── Checkout.jsx
    ├── locales/
    │   └── en.default.json
    └── shopify.extension.toml
```

### 3. Configuration

```toml
# shopify.extension.toml
api_version = "2025-01"

[[extensions]]
type = "ui_extension"
name = "Custom Checkout"
handle = "custom-checkout"

[[extensions.targeting]]
module = "./src/Checkout.jsx"
target = "purchase.checkout.block.render"
```

## Checkout UI Extensions

### Basic Extension

```jsx
// src/Checkout.jsx
import {
  reactExtension,
  Banner,
  useApi,
  useTranslate,
} from "@shopify/ui-extensions-react/checkout";

export default reactExtension("purchase.checkout.block.render", () => (
  <Extension />
));

function Extension() {
  const translate = useTranslate();

  return (
    <Banner title={translate("welcomeMessage")}>
      Thank you for shopping with us!
    </Banner>
  );
}
```

### Extension Targets

Common checkout targets:

```jsx
// Before shipping options
"purchase.checkout.shipping-option-list.render-before";

// After shipping options
"purchase.checkout.shipping-option-list.render-after";

// Payment method
"purchase.checkout.payment-method-list.render-before";

// Order summary
"purchase.checkout.cart-line-list.render-after";

// Static render (header/footer)
"purchase.checkout.header.render-after";
"purchase.checkout.footer.render-after";

// Block render (anywhere in checkout)
"purchase.checkout.block.render";

// Delivery address
"purchase.checkout.delivery-address.render-before";
```

### Using Checkout Data

```jsx
import {
  useCartLines,
  useTotalAmount,
  useShippingAddress,
  useBuyerJourney,
  useCustomer,
  useDiscountCodes,
} from "@shopify/ui-extensions-react/checkout";

function Extension() {
  const cartLines = useCartLines();
  const totalAmount = useTotalAmount();
  const shippingAddress = useShippingAddress();
  const customer = useCustomer();
  const discountCodes = useDiscountCodes();

  const total = totalAmount?.amount;
  const itemCount = cartLines.reduce((sum, line) => sum + line.quantity, 0);

  return (
    <BlockStack>
      <Text>Items in cart: {itemCount}</Text>
      <Text>Total: ${total}</Text>
      {customer && <Text>Welcome back, {customer.firstName}!</Text>}
    </BlockStack>
  );
}
```

### UI Components

```jsx
import {
  Banner,
  BlockStack,
  InlineStack,
  Text,
  Button,
  Checkbox,
  TextField,
  Select,
  Image,
  Divider,
  Heading,
  Link,
  View,
  Grid,
  Icon,
} from "@shopify/ui-extensions-react/checkout";

function Extension() {
  const [checked, setChecked] = useState(false);
  const [note, setNote] = useState("");

  return (
    <BlockStack spacing="base">
      <Heading level={2}>Gift Options</Heading>

      <Checkbox checked={checked} onChange={setChecked}>
        This is a gift
      </Checkbox>

      {checked && (
        <TextField
          label="Gift message"
          value={note}
          onChange={setNote}
          multiline
        />
      )}

      <InlineStack spacing="tight">
        <Button kind="secondary" onPress={() => {}}>
          Cancel
        </Button>
        <Button onPress={() => {}}>Save</Button>
      </InlineStack>
    </BlockStack>
  );
}
```

### Custom Fields with Metafields

```jsx
import {
  useApplyMetafieldsChange,
  useMetafield,
} from "@shopify/ui-extensions-react/checkout";

function GiftMessage() {
  const [message, setMessage] = useState("");
  const applyMetafieldsChange = useApplyMetafieldsChange();

  const handleChange = async (value) => {
    setMessage(value);
    await applyMetafieldsChange({
      type: "updateMetafield",
      namespace: "custom",
      key: "gift_message",
      valueType: "string",
      value,
    });
  };

  return (
    <TextField label="Gift message" value={message} onChange={handleChange} />
  );
}
```

### Buyer Journey Intercept

Block checkout progression with validation:

```jsx
import { useBuyerJourneyIntercept } from "@shopify/ui-extensions-react/checkout";

function AgeVerification() {
  const [verified, setVerified] = useState(false);

  useBuyerJourneyIntercept(({ canBlockProgress }) => {
    if (!verified && canBlockProgress) {
      return {
        behavior: "block",
        reason: "Age verification required",
        errors: [
          {
            message: "Please verify your age to continue",
          },
        ],
      };
    }
    return { behavior: "allow" };
  });

  return (
    <Checkbox checked={verified} onChange={setVerified}>
      I confirm I am 21 or older
    </Checkbox>
  );
}
```

## Post-Purchase Extensions

### Create Post-Purchase Extension

```bash
shopify app generate extension
# Select: Post-purchase UI
```

### Post-Purchase Upsell

```jsx
// src/PostPurchase.jsx
import {
  extend,
  render,
  useExtensionInput,
  BlockStack,
  Button,
  Text,
  Image,
  Heading,
  CalloutBanner,
  Layout,
  TextContainer,
} from "@shopify/post-purchase-ui-extensions-react";

extend("Checkout::PostPurchase::ShouldRender", async ({ storage }) => {
  // Decide whether to show post-purchase
  const upsellProduct = await fetchUpsellProduct();
  await storage.update({ upsellProduct });
  return { render: true };
});

render("Checkout::PostPurchase::Render", () => <App />);

function App() {
  const { storage, done, calculateChangeset, applyChangeset } =
    useExtensionInput();
  const { upsellProduct } = storage.initialData;

  const handleAccept = async () => {
    const changeset = await calculateChangeset({
      changes: [
        {
          type: "add_variant",
          variantId: upsellProduct.variantId,
          quantity: 1,
        },
      ],
    });

    await applyChangeset(changeset.token);
    done();
  };

  const handleDecline = () => {
    done();
  };

  return (
    <BlockStack spacing="loose">
      <CalloutBanner title="Special Offer!">
        Add this item to your order at 20% off
      </CalloutBanner>

      <Layout
        media={[
          { viewportSize: "small", sizes: [1, 0, 1], maxInlineSize: 0.9 },
          { viewportSize: "medium", sizes: [532, 0, 1], maxInlineSize: 420 },
          { viewportSize: "large", sizes: [560, 38, 340] },
        ]}
      >
        <Image source={upsellProduct.imageUrl} />
        <View />
        <BlockStack spacing="tight">
          <Heading>{upsellProduct.title}</Heading>
          <TextContainer>
            <Text size="medium">${upsellProduct.price} (20% off)</Text>
          </TextContainer>
          <Button onPress={handleAccept}>Add to Order</Button>
          <Button onPress={handleDecline} plain>
            No thanks
          </Button>
        </BlockStack>
      </Layout>
    </BlockStack>
  );
}
```

## Customer Account Extensions

```jsx
// Extend customer account pages
import {
  reactExtension,
  Page,
  Card,
  BlockStack,
  Text,
} from "@shopify/ui-extensions-react/customer-account";

export default reactExtension("customer-account.page.render", () => (
  <CustomAccountPage />
));

function CustomAccountPage() {
  return (
    <Page title="Rewards">
      <Card padding>
        <BlockStack spacing="loose">
          <Text size="large">Your Points: 500</Text>
          <Text>Earn points with every purchase!</Text>
        </BlockStack>
      </Card>
    </Page>
  );
}
```

## Localization

```json
// locales/en.default.json
{
  "welcomeMessage": "Welcome to checkout",
  "giftLabel": "Gift options",
  "verifyAge": "I confirm I am 21 or older"
}

// locales/fr.json
{
  "welcomeMessage": "Bienvenue au paiement",
  "giftLabel": "Options cadeau",
  "verifyAge": "Je confirme avoir 21 ans ou plus"
}
```

```jsx
import { useTranslate } from "@shopify/ui-extensions-react/checkout";

function Extension() {
  const translate = useTranslate();
  return <Text>{translate("welcomeMessage")}</Text>;
}
```

## Network Requests

```jsx
import { useApi } from "@shopify/ui-extensions-react/checkout";

function Extension() {
  const { sessionToken } = useApi();

  const fetchData = async () => {
    const token = await sessionToken.get();

    const response = await fetch("https://your-app.com/api/data", {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    return response.json();
  };

  // Use in useEffect or event handler
}
```

## Testing

### Local Development

```bash
# Start app with preview
shopify app dev

# Extensions will load in checkout preview
```

### Testing in Checkout Editor

1. Go to Shopify admin > Settings > Checkout
2. Click "Customize"
3. Add your extension block
4. Preview changes

## Best Practices

1. **Keep extensions fast** - Minimize API calls
2. **Handle errors gracefully** - Show user-friendly messages
3. **Support localization** - Use translation files
4. **Test on mobile** - Checkout is often mobile
5. **Follow design guidelines** - Match Shopify's checkout style
6. **Use progressive enhancement** - Graceful degradation

## Resources

- [Checkout UI Extensions](https://shopify.dev/docs/api/checkout-ui-extensions)
- [Checkout UI Components](https://shopify.dev/docs/api/checkout-ui-extensions/components)
- [Post-Purchase Extensions](https://shopify.dev/docs/apps/build/checkout/post-purchase)
- [Customer Account Extensions](https://shopify.dev/docs/api/checkout-ui-extensions/extension-targets-overview#customer-account-targets)
- [Extension Targets Reference](https://shopify.dev/docs/api/checkout-ui-extensions/extension-targets-overview)

For backend logic, see the [shopify-functions](../shopify-functions/SKILL.md) skill.
````

## File: templates/skills/shopify-cli-tools/SKILL.md
````markdown
---
name: shopify-cli-tools
description: Expert guidance for Shopify CLI including app and theme development commands, environment management, extension scaffolding, and deployment workflows
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Shopify CLI & Developer Tools

## When to use this skill

Use this skill when:

- Installing and configuring Shopify CLI
- Running theme development commands
- Running app development commands
- Using Theme Check for linting
- Configuring VS Code for Shopify development
- Debugging Liquid code
- Setting up development workflows

## Installing Shopify CLI

### Prerequisites

- **Node.js 18+** - Required for all Shopify development
- **Git** - For version control
- **Package manager** - npm or pnpm

### Installation

```bash
# Install globally via npm
npm install -g @shopify/cli @shopify/theme

# Or via Homebrew (macOS)
brew tap shopify/shopify
brew install shopify-cli

# Verify installation
shopify version
```

### Authentication

```bash
# Log in to your Partner account
shopify auth login

# Log out
shopify auth logout

# Check current auth status
shopify auth info
```

## Theme CLI Commands

### Initialize Theme

```bash
# Clone Skeleton theme as starting point
shopify theme init my-theme

# Clone from custom repository
shopify theme init my-theme --clone-url git@github.com:org/repo.git
```

### Development Server

```bash
# Start dev server (auto-connects to store)
shopify theme dev

# Connect to specific store
shopify theme dev --store my-store.myshopify.com

# Specify theme to work on
shopify theme dev --theme THEME_ID

# Use specific port
shopify theme dev --port 9292

# Open in default browser
shopify theme dev --open

# Live reload options
shopify theme dev --live-reload hot-reload
shopify theme dev --live-reload full-page
shopify theme dev --live-reload off
```

### Push & Pull

```bash
# Push local changes to Shopify
shopify theme push

# Push as new unpublished theme
shopify theme push --unpublished

# Push to specific theme
shopify theme push --theme THEME_ID

# Push only specific files
shopify theme push --only templates/*.json

# Push ignoring specific files
shopify theme push --ignore config/settings_data.json

# Pull theme from Shopify
shopify theme pull

# Pull specific theme
shopify theme pull --theme THEME_ID

# Pull only specific files
shopify theme pull --only sections/*.liquid
```

### Theme Management

```bash
# List all themes
shopify theme list

# Publish a theme
shopify theme publish --theme THEME_ID

# Rename a theme
shopify theme rename --theme THEME_ID --name "New Name"

# Delete a theme
shopify theme delete --theme THEME_ID

# Package theme for upload
shopify theme package

# Open theme in browser
shopify theme open --theme THEME_ID
```

### Theme Check (Linting)

```bash
# Run Theme Check on current directory
shopify theme check

# Check specific path
shopify theme check --path ./sections

# Auto-fix issues
shopify theme check --auto-correct

# Output as JSON
shopify theme check --output json

# Fail on warnings (useful for CI)
shopify theme check --fail-level warning

# Show offenses inline
shopify theme check --print-offenses
```

### Theme Info & Console

```bash
# Show theme environment info
shopify theme info

# Start Liquid REPL console
shopify theme console

# Pull metafields for local development
shopify theme metafields pull
```

## App CLI Commands

### Create App

```bash
# Initialize new app
shopify app init

# Choose template interactively:
# - Remix (recommended)
# - Node
# - Ruby
# - PHP
```

### Development

```bash
# Start dev server with tunnel
shopify app dev

# Reset app configuration
shopify app dev --reset

# Skip tunnel (use your own)
shopify app dev --no-tunnel

# Specify port
shopify app dev --port 3000
```

### Generate Extensions

```bash
# Generate new extension
shopify app generate extension

# Extension types available:
# - Checkout UI
# - Admin UI
# - Theme App Extension
# - Post-purchase UI
# - Shopify Function
# - Web Pixel
# - Flow Action/Trigger
# - POS UI
```

### Deployment

```bash
# Deploy app and extensions
shopify app deploy

# List app versions
shopify app versions list

# Release specific version
shopify app release --version VERSION_ID
```

### App Info

```bash
# Show app info
shopify app info

# Show environment variables
shopify app env show

# Pull environment variables
shopify app env pull
```

### Functions

```bash
# Run function locally
shopify app function run --path extensions/my-function

# Generate types for function
shopify app function typegen --path extensions/my-function
```

## VS Code Extension

### Installation

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search "Shopify Liquid"
4. Install the official extension

Or install from CLI:

```bash
code --install-extension Shopify.theme-check-vscode
```

### Features

| Feature                     | Description                        |
| --------------------------- | ---------------------------------- |
| **Syntax Highlighting**     | Liquid, HTML, CSS, JS highlighting |
| **Code Completion**         | Objects, filters, tags, schema     |
| **Documentation on Hover**  | Inline docs for Liquid code        |
| **Theme Check Integration** | Real-time linting                  |
| **Schema Completion**       | JSON schema in sections            |
| **Go to Definition**        | Navigate to snippets/sections      |
| **Auto-closing Pairs**      | Liquid tags and braces             |
| **Code Formatting**         | Format Liquid code                 |

### Configuration

```json
// .vscode/settings.json
{
  "shopifyLiquid.formatterDevPreview": true,
  "shopifyLiquid.themeCheckNextDevPreview": true,
  "editor.formatOnSave": true,
  "[liquid]": {
    "editor.defaultFormatter": "Shopify.theme-check-vscode"
  },
  "files.associations": {
    "*.liquid": "liquid"
  }
}
```

## Theme Check Configuration

### .theme-check.yml

```yaml
# Extends default configuration
extends: :default

# Enable/disable specific checks
SyntaxError:
  enabled: true
  severity: error

DeprecatedFilter:
  enabled: true
  severity: warning

MissingTemplate:
  enabled: true

UnusedAssign:
  enabled: true

UnusedSnippet:
  enabled: false

ImgWidthAndHeight:
  enabled: true

AssetSizeCSS:
  enabled: true
  threshold_in_bytes: 100000

AssetSizeJavaScript:
  enabled: true
  threshold_in_bytes: 50000

# Ignore specific files
ignore:
  - vendor/**/*
  - assets/vendor.js
```

### Common Theme Check Errors

| Error               | Solution                     |
| ------------------- | ---------------------------- |
| `MissingTemplate`   | Create missing template file |
| `DeprecatedFilter`  | Update to new filter syntax  |
| `UnusedAssign`      | Remove or use the variable   |
| `SyntaxError`       | Fix Liquid syntax            |
| `AssetSizeCSS`      | Reduce CSS file size         |
| `ImgWidthAndHeight` | Add width/height to images   |

## Development Workflow

### Theme Development

```bash
# 1. Clone starter theme
shopify theme init my-theme
cd my-theme

# 2. Start development
shopify theme dev --store my-store.myshopify.com

# 3. Make changes (auto-synced)
# Edit files in your editor

# 4. Run linter
shopify theme check

# 5. Push when ready
shopify theme push --theme THEME_ID

# 6. Publish live
shopify theme publish --theme THEME_ID
```

### App Development

```bash
# 1. Create app
shopify app init

# 2. Add extensions
shopify app generate extension

# 3. Start development
shopify app dev

# 4. Test locally
# App runs at http://localhost:3000

# 5. Deploy
shopify app deploy
```

## Environment Configuration

### .shopify-cli.yml (Theme)

```yaml
shop: my-store.myshopify.com
theme: THEME_ID
path: .
ignore:
  - config/settings_data.json
  - .git/*
```

### .env (App)

```env
SHOPIFY_API_KEY=your-api-key
SHOPIFY_API_SECRET=your-api-secret
SHOPIFY_APP_URL=https://your-app.com
SCOPES=read_products,write_products
HOST=https://tunnel.ngrok.io
```

## CI/CD Integration

### GitHub Actions (Theme Check)

```yaml
# .github/workflows/theme-check.yml
name: Theme Check

on: [push, pull_request]

jobs:
  theme-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: "18"

      - name: Install Shopify CLI
        run: npm install -g @shopify/cli @shopify/theme

      - name: Run Theme Check
        run: shopify theme check --fail-level error
```

### GitHub Actions (App Deploy)

```yaml
# .github/workflows/deploy.yml
name: Deploy App

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: "18"

      - name: Install dependencies
        run: npm ci

      - name: Deploy
        env:
          SHOPIFY_CLI_PARTNERS_TOKEN: ${{ secrets.SHOPIFY_CLI_PARTNERS_TOKEN }}
        run: npm run deploy
```

## Troubleshooting

### Common Issues

**CLI not found after install:**

```bash
# Check Node.js path
which node

# Reinstall globally
npm install -g @shopify/cli
```

**Authentication issues:**

```bash
# Clear auth and re-login
shopify auth logout
shopify auth login --reset
```

**Theme dev not syncing:**

```bash
# Check .shopify-cli.yml configuration
# Ensure correct store URL
# Check file permissions
```

**Port already in use:**

```bash
# Use different port
shopify theme dev --port 9293
shopify app dev --port 3001
```

## Quick Reference

### Theme Commands

| Command         | Description         |
| --------------- | ------------------- |
| `theme init`    | Initialize theme    |
| `theme dev`     | Start dev server    |
| `theme push`    | Upload to store     |
| `theme pull`    | Download from store |
| `theme check`   | Run linter          |
| `theme list`    | List themes         |
| `theme publish` | Publish theme       |

### App Commands

| Command                  | Description      |
| ------------------------ | ---------------- |
| `app init`               | Create app       |
| `app dev`                | Start dev server |
| `app deploy`             | Deploy app       |
| `app generate extension` | Add extension    |
| `app info`               | Show app info    |
| `app function run`       | Test function    |

## Resources

- [Shopify CLI Reference](https://shopify.dev/docs/api/shopify-cli)
- [Theme Check Docs](https://shopify.dev/docs/storefronts/themes/tools/theme-check)
- [VS Code Extension](https://shopify.dev/docs/storefronts/themes/tools/shopify-liquid-vscode)
- [Language Server](https://shopify.dev/docs/storefronts/themes/tools/cli/language-server)
- [Dawn Theme Reference](https://github.com/Shopify/dawn)
- [GitHub Actions Integration](https://shopify.dev/docs/storefronts/themes/tools/github)

For theme development, see the [theme-development](../theme-development/SKILL.md) skill.
For app development, see the [app-development](../app-development/SKILL.md) skill.
````

## File: templates/skills/shopify-functions/SKILL.md
````markdown
---
name: shopify-functions
description: Expert guidance for Shopify Functions including discounts, delivery customization, payment customization, cart validation, and WebAssembly deployment
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Shopify Functions

## When to use this skill

Use this skill when:

- Creating custom discount logic
- Customizing delivery options
- Implementing payment method rules
- Validating cart or checkout
- Building order routing logic
- Extending Shopify's backend behavior

## What are Shopify Functions?

Functions are serverless WebAssembly modules that extend Shopify's backend logic. They:

- Run on Shopify's infrastructure
- Execute in milliseconds
- Scale automatically
- Are upgrade-safe

### Function Types

| API                            | Purpose                                |
| ------------------------------ | -------------------------------------- |
| **Discounts**                  | Product, order, and shipping discounts |
| **Delivery Customization**     | Rename, reorder, hide shipping options |
| **Payment Customization**      | Filter, reorder payment methods        |
| **Cart & Checkout Validation** | Block checkout with errors             |
| **Order Routing**              | Control fulfillment locations          |
| **Cart Transform**             | Modify cart contents                   |

## Getting Started

### 1. Create a Function

```bash
# In an existing app
shopify app generate extension

# Select from function types:
# - Delivery customization
# - Product discount
# - Order discount
# - Cart & Checkout Validation
# - etc.
```

### 2. Choose a Language

**Rust (Recommended)** - Best performance, handles large carts

**JavaScript** - Easier to learn, good for simpler logic

### 3. Function Structure

```
extensions/
└── my-discount/
    ├── src/
    │   └── run.rs (or run.js)
    ├── input.graphql
    ├── shopify.extension.toml
    └── Cargo.toml (for Rust)
```

## Function Anatomy

### Configuration (shopify.extension.toml)

```toml
api_version = "2025-01"

[[extensions]]
name = "Volume Discount"
handle = "volume-discount"
type = "function"

[[extensions.targeting]]
target = "purchase.product-discount.run"
input_query = "src/run.graphql"
export = "run"

[extensions.build]
command = "cargo wasi build --release"
path = "target/wasm32-wasi/release/volume-discount.wasm"
```

### Input Query (input.graphql)

```graphql
query RunInput {
  cart {
    lines {
      id
      quantity
      merchandise {
        ... on ProductVariant {
          id
          product {
            id
            title
            hasAnyTag(tags: ["discount-eligible"])
          }
        }
      }
      cost {
        amountPerQuantity {
          amount
          currencyCode
        }
      }
    }
  }
  discountNode {
    metafield(namespace: "volume-discount", key: "config") {
      value
    }
  }
}
```

## Product Discount Function (Rust)

```rust
// src/run.rs
use shopify_function::prelude::*;
use shopify_function::Result;

#[shopify_function_target(query_path = "src/run.graphql", schema_path = "schema.graphql")]
fn run(input: input::ResponseData) -> Result<output::FunctionRunResult> {
    let mut discounts = vec![];

    // Parse configuration from metafield
    let config: Config = input.discount_node.metafield
        .as_ref()
        .map(|m| serde_json::from_str(&m.value).unwrap())
        .unwrap_or_default();

    for line in input.cart.lines {
        let quantity = line.quantity;

        // Check if eligible for volume discount
        if quantity >= config.minimum_quantity {
            let merchandise = match &line.merchandise {
                input::InputCartLinesMerchandise::ProductVariant(variant) => variant,
                _ => continue,
            };

            // Check for eligible tag
            if merchandise.product.has_any_tag {
                discounts.push(output::Discount {
                    targets: vec![output::Target::ProductVariant(
                        output::ProductVariantTarget {
                            id: merchandise.id.clone(),
                            quantity: None,
                        },
                    )],
                    value: output::Value::Percentage(output::Percentage {
                        value: Decimal::from_str(&config.discount_percentage).unwrap(),
                    }),
                    message: Some(format!("{}% volume discount", config.discount_percentage)),
                });
            }
        }
    }

    Ok(output::FunctionRunResult {
        discounts,
        discount_application_strategy: output::DiscountApplicationStrategy::FIRST,
    })
}

#[derive(Default, serde::Deserialize)]
struct Config {
    minimum_quantity: i64,
    discount_percentage: String,
}
```

## Product Discount Function (JavaScript)

```javascript
// src/run.js
// @ts-check
import { DiscountApplicationStrategy } from "../generated/api";

/**
 * @param {RunInput} input
 * @returns {FunctionRunResult}
 */
export function run(input) {
  const config = JSON.parse(
    input.discountNode.metafield?.value ??
      '{"minimumQuantity": 5, "percentage": "10"}',
  );

  const discounts = [];

  for (const line of input.cart.lines) {
    const variant = line.merchandise;

    // Check quantity threshold
    if (line.quantity >= config.minimumQuantity) {
      // Check for eligible products
      if (
        variant.__typename === "ProductVariant" &&
        variant.product.hasAnyTag
      ) {
        discounts.push({
          targets: [
            {
              productVariant: {
                id: variant.id,
              },
            },
          ],
          value: {
            percentage: {
              value: config.percentage,
            },
          },
          message: `${config.percentage}% volume discount`,
        });
      }
    }
  }

  return {
    discounts,
    discountApplicationStrategy: DiscountApplicationStrategy.First,
  };
}
```

## Delivery Customization

```rust
// Rename, hide, or reorder delivery options
use shopify_function::prelude::*;
use shopify_function::Result;

#[shopify_function_target(query_path = "src/run.graphql", schema_path = "schema.graphql")]
fn run(input: input::ResponseData) -> Result<output::FunctionRunResult> {
    let mut operations = vec![];

    for method in input.cart.delivery_groups[0].delivery_options.iter() {
        // Hide express shipping for heavy orders
        if method.title.contains("Express") && cart_weight_exceeds_limit(&input) {
            operations.push(output::Operation::Hide(output::HideOperation {
                delivery_option_handle: method.handle.clone(),
            }));
        }

        // Rename delivery option
        if method.title.contains("Standard") {
            operations.push(output::Operation::Rename(output::RenameOperation {
                delivery_option_handle: method.handle.clone(),
                title: Some("Economy Shipping (5-7 days)".to_string()),
            }));
        }
    }

    Ok(output::FunctionRunResult { operations })
}
```

## Payment Customization

```javascript
// src/run.js
export function run(input) {
  const cart = input.cart;
  const operations = [];

  // Calculate cart total
  const total = cart.cost.totalAmount.amount;

  // Hide COD for orders over $500
  if (parseFloat(total) > 500) {
    const codMethod = input.paymentMethods.find((method) =>
      method.name.includes("Cash on Delivery"),
    );

    if (codMethod) {
      operations.push({
        hide: {
          paymentMethodId: codMethod.id,
        },
      });
    }
  }

  // Reorder payment methods
  operations.push({
    move: {
      paymentMethodId: input.paymentMethods[0].id,
      index: 2,
    },
  });

  return { operations };
}
```

## Cart & Checkout Validation

```rust
use shopify_function::prelude::*;
use shopify_function::Result;

#[shopify_function_target(query_path = "src/run.graphql", schema_path = "schema.graphql")]
fn run(input: input::ResponseData) -> Result<output::FunctionRunResult> {
    let mut errors = vec![];

    // Check minimum order value
    let total: f64 = input.cart.cost.total_amount.amount.parse().unwrap();
    if total < 25.0 {
        errors.push(output::FunctionError {
            localized_message: "Minimum order value is $25.00".to_string(),
            target: output::Target::Cart,
        });
    }

    // Check product availability by region
    for line in &input.cart.lines {
        if let input::InputCartLinesMerchandise::ProductVariant(variant) = &line.merchandise {
            if is_restricted_product(&variant, &input.cart.buyer_identity) {
                errors.push(output::FunctionError {
                    localized_message: format!(
                        "{} is not available in your region",
                        variant.product.title
                    ),
                    target: output::Target::CartLine(output::CartLineTarget {
                        id: line.id.clone(),
                    }),
                });
            }
        }
    }

    Ok(output::FunctionRunResult { errors })
}
```

## Cart Transform

Modify cart contents dynamically:

```javascript
// src/run.js
export function run(input) {
  const operations = [];

  for (const line of input.cart.lines) {
    const variant = line.merchandise;

    // Add free gift for orders with specific products
    if (variant.product.hasAnyTag && line.quantity >= 3) {
      operations.push({
        expand: {
          cartLineId: line.id,
          expandedCartItems: [
            {
              merchandiseId: variant.id,
              quantity: line.quantity,
            },
            {
              merchandiseId: "gid://shopify/ProductVariant/FREE_GIFT_ID",
              quantity: 1,
            },
          ],
        },
      });
    }
  }

  return { operations };
}
```

## Testing Functions

### Local Testing

```bash
# Test with sample input
shopify app function run --path extensions/my-function

# Provide input via stdin
cat input.json | shopify app function run --path extensions/my-function
```

### Sample Input JSON

```json
{
  "cart": {
    "lines": [
      {
        "id": "gid://shopify/CartLine/1",
        "quantity": 5,
        "merchandise": {
          "__typename": "ProductVariant",
          "id": "gid://shopify/ProductVariant/123",
          "product": {
            "id": "gid://shopify/Product/456",
            "title": "Test Product",
            "hasAnyTag": true
          }
        },
        "cost": {
          "amountPerQuantity": {
            "amount": "10.00",
            "currencyCode": "USD"
          }
        }
      }
    ]
  },
  "discountNode": {
    "metafield": {
      "value": "{\"minimumQuantity\": 3, \"discountPercentage\": \"15\"}"
    }
  }
}
```

## Deployment

```bash
# Deploy function with app
shopify app deploy

# Function will be available to configure in admin
```

## Configuration UI

Create an admin UI to configure function settings:

```jsx
// app/routes/app.discount.jsx
import { authenticate } from "../shopify.server";
import { Form, TextField, Button, Card } from "@shopify/polaris";

export async function action({ request }) {
  const { admin } = await authenticate.admin(request);
  const formData = await request.formData();

  // Create discount with function
  await admin.graphql(
    `
    mutation CreateDiscount($discount: DiscountAutomaticAppInput!) {
      discountAutomaticAppCreate(automaticAppDiscount: $discount) {
        automaticAppDiscount {
          discountId
        }
        userErrors {
          field
          message
        }
      }
    }
  `,
    {
      variables: {
        discount: {
          title: formData.get("title"),
          functionId: "YOUR_FUNCTION_ID",
          startsAt: new Date().toISOString(),
          metafields: [
            {
              namespace: "volume-discount",
              key: "config",
              value: JSON.stringify({
                minimumQuantity: parseInt(formData.get("minQty")),
                discountPercentage: formData.get("percentage"),
              }),
              type: "json",
            },
          ],
        },
      },
    },
  );

  return redirect("/app/discounts");
}
```

## Performance Best Practices

1. **Use Rust for large carts** - JavaScript can timeout
2. **Minimize input query** - Only request needed data
3. **Avoid complex loops** - Keep logic simple
4. **Cache configuration** - Parse metafields once
5. **Test with real data** - Test large cart scenarios

## CLI Commands Reference

| Command                          | Description     |
| -------------------------------- | --------------- |
| `shopify app generate extension` | Create function |
| `shopify app function run`       | Test locally    |
| `shopify app function typegen`   | Generate types  |
| `shopify app deploy`             | Deploy function |

## Resources

- [Functions Overview](https://shopify.dev/docs/apps/build/functions)
- [Functions API Reference](https://shopify.dev/docs/api/functions)
- [Discount Functions](https://shopify.dev/docs/apps/build/discounts)
- [Delivery Customization](https://shopify.dev/docs/apps/build/checkout/delivery-shipping)
- [Payment Customization](https://shopify.dev/docs/apps/build/payments)
- [JavaScript for Functions](https://shopify.dev/docs/apps/build/functions/programming-languages/javascript-for-functions)
- [Rust for Functions](https://shopify.dev/docs/apps/build/functions/programming-languages/rust-for-functions)

For checkout UI, see the [checkout-customization](../checkout-customization/SKILL.md) skill.
````

## File: templates/skills/shopify-graphql-api/SKILL.md
````markdown
---
name: shopify-graphql-api
description: Expert guidance for Shopify Admin API and Storefront API GraphQL queries, mutations, pagination, metafields, webhooks, and rate limit handling
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Shopify GraphQL APIs

## When to use this skill

Use this skill when:

- Querying Shopify data (products, orders, customers)
- Creating or updating resources via mutations
- Building integrations with Shopify stores
- Working with metafields and metaobjects
- Handling pagination in API responses
- Managing API authentication and rate limits

## API Types

### Admin API

- Full store access (backend only)
- Requires authentication (OAuth or API key)
- Used by apps and integrations

### Storefront API

- Public storefront access
- Uses public access token
- Safe for frontend/client-side

## Getting Started

### Admin API Authentication

```javascript
// Using @shopify/shopify-api
import { shopifyApi, LATEST_API_VERSION } from "@shopify/shopify-api";

const shopify = shopifyApi({
  apiKey: process.env.SHOPIFY_API_KEY,
  apiSecretKey: process.env.SHOPIFY_API_SECRET,
  scopes: ["read_products", "write_products"],
  hostName: "your-app.com",
  apiVersion: LATEST_API_VERSION,
});
```

### Making Requests

```javascript
// In a Remix app route
import { authenticate } from "../shopify.server";

export async function loader({ request }) {
  const { admin } = await authenticate.admin(request);

  const response = await admin.graphql(`
    query {
      products(first: 10) {
        nodes {
          id
          title
        }
      }
    }
  `);

  return response.json();
}
```

## Common Queries

### Products

```graphql
# Get products with variants
query GetProducts($first: Int!, $after: String) {
  products(first: $first, after: $after) {
    pageInfo {
      hasNextPage
      endCursor
    }
    nodes {
      id
      title
      handle
      description
      status
      vendor
      productType
      tags
      featuredImage {
        url
        altText
      }
      variants(first: 10) {
        nodes {
          id
          title
          sku
          price
          compareAtPrice
          inventoryQuantity
          selectedOptions {
            name
            value
          }
        }
      }
      priceRange {
        minVariantPrice {
          amount
          currencyCode
        }
        maxVariantPrice {
          amount
          currencyCode
        }
      }
    }
  }
}
```

```graphql
# Get single product by ID
query GetProduct($id: ID!) {
  product(id: $id) {
    id
    title
    description
    variants(first: 100) {
      nodes {
        id
        title
        price
      }
    }
  }
}

# Get product by handle
query GetProductByHandle($handle: String!) {
  productByHandle(handle: $handle) {
    id
    title
  }
}
```

### Orders

```graphql
query GetOrders($first: Int!, $query: String) {
  orders(first: $first, query: $query) {
    nodes {
      id
      name
      email
      createdAt
      displayFinancialStatus
      displayFulfillmentStatus
      totalPriceSet {
        shopMoney {
          amount
          currencyCode
        }
      }
      customer {
        id
        firstName
        lastName
        email
      }
      lineItems(first: 50) {
        nodes {
          id
          title
          quantity
          variant {
            id
            sku
          }
          originalTotalSet {
            shopMoney {
              amount
            }
          }
        }
      }
      shippingAddress {
        address1
        city
        province
        country
        zip
      }
    }
  }
}
```

### Customers

```graphql
query GetCustomers($first: Int!, $query: String) {
  customers(first: $first, query: $query) {
    nodes {
      id
      firstName
      lastName
      email
      phone
      ordersCount
      totalSpent {
        amount
        currencyCode
      }
      addresses(first: 5) {
        address1
        city
        province
        country
        zip
      }
      tags
      createdAt
    }
  }
}
```

### Collections

```graphql
query GetCollection($handle: String!) {
  collectionByHandle(handle: $handle) {
    id
    title
    description
    products(first: 20) {
      nodes {
        id
        title
        featuredImage {
          url
        }
      }
    }
  }
}
```

### Inventory

```graphql
query GetInventory($locationId: ID!) {
  location(id: $locationId) {
    inventoryLevels(first: 100) {
      nodes {
        id
        available
        item {
          id
          variant {
            id
            displayName
            sku
          }
        }
      }
    }
  }
}
```

## Common Mutations

### Create Product

```graphql
mutation CreateProduct($input: ProductInput!) {
  productCreate(input: $input) {
    product {
      id
      title
      handle
    }
    userErrors {
      field
      message
    }
  }
}
```

Variables:

```json
{
  "input": {
    "title": "New Product",
    "descriptionHtml": "<p>Product description</p>",
    "vendor": "My Store",
    "productType": "Apparel",
    "tags": ["new", "featured"],
    "variants": [
      {
        "price": "29.99",
        "sku": "NEW-001",
        "inventoryManagement": "SHOPIFY",
        "inventoryPolicy": "DENY"
      }
    ]
  }
}
```

### Update Product

```graphql
mutation UpdateProduct($input: ProductInput!) {
  productUpdate(input: $input) {
    product {
      id
      title
    }
    userErrors {
      field
      message
    }
  }
}
```

Variables:

```json
{
  "input": {
    "id": "gid://shopify/Product/123456",
    "title": "Updated Title",
    "tags": ["sale", "featured"]
  }
}
```

### Create Order

```graphql
mutation CreateDraftOrder($input: DraftOrderInput!) {
  draftOrderCreate(input: $input) {
    draftOrder {
      id
      invoiceUrl
    }
    userErrors {
      field
      message
    }
  }
}
```

### Update Inventory

```graphql
mutation AdjustInventory($input: InventoryAdjustQuantityInput!) {
  inventoryAdjustQuantity(input: $input) {
    inventoryLevel {
      available
    }
    userErrors {
      field
      message
    }
  }
}
```

Variables:

```json
{
  "input": {
    "inventoryLevelId": "gid://shopify/InventoryLevel/123456",
    "availableDelta": 10
  }
}
```

## Metafields

### Read Metafields

```graphql
# Product metafields
query GetProductMetafields($id: ID!) {
  product(id: $id) {
    metafields(first: 20) {
      nodes {
        id
        namespace
        key
        value
        type
      }
    }
    # Specific metafield
    careInstructions: metafield(namespace: "custom", key: "care_instructions") {
      value
    }
  }
}
```

### Write Metafields

```graphql
mutation SetMetafields($metafields: [MetafieldsSetInput!]!) {
  metafieldsSet(metafields: $metafields) {
    metafields {
      id
      key
      value
    }
    userErrors {
      field
      message
    }
  }
}
```

Variables:

```json
{
  "metafields": [
    {
      "ownerId": "gid://shopify/Product/123456",
      "namespace": "custom",
      "key": "care_instructions",
      "value": "Machine wash cold",
      "type": "single_line_text_field"
    },
    {
      "ownerId": "gid://shopify/Product/123456",
      "namespace": "custom",
      "key": "dimensions",
      "value": "{\"width\": 10, \"height\": 20, \"depth\": 5}",
      "type": "json"
    }
  ]
}
```

### Metafield Types

| Type                     | Description | Example Value            |
| ------------------------ | ----------- | ------------------------ |
| `single_line_text_field` | Short text  | `"Hello"`                |
| `multi_line_text_field`  | Long text   | `"Line 1\nLine 2"`       |
| `number_integer`         | Integer     | `"42"`                   |
| `number_decimal`         | Decimal     | `"19.99"`                |
| `boolean`                | True/False  | `"true"`                 |
| `date`                   | Date        | `"2025-01-15"`           |
| `json`                   | JSON object | `"{\"key\": \"value\"}"` |
| `url`                    | URL         | `"https://example.com"`  |
| `color`                  | Color hex   | `"#FF0000"`              |

## Pagination

### Cursor-Based Pagination

```javascript
async function getAllProducts(admin) {
  let products = [];
  let hasNextPage = true;
  let cursor = null;

  while (hasNextPage) {
    const response = await admin.graphql(
      `
      query GetProducts($first: Int!, $after: String) {
        products(first: $first, after: $after) {
          pageInfo {
            hasNextPage
            endCursor
          }
          nodes {
            id
            title
          }
        }
      }
    `,
      {
        variables: { first: 50, after: cursor },
      },
    );

    const data = await response.json();
    products = [...products, ...data.data.products.nodes];
    hasNextPage = data.data.products.pageInfo.hasNextPage;
    cursor = data.data.products.pageInfo.endCursor;
  }

  return products;
}
```

## Rate Limits

### Understanding Cost

```graphql
query {
  products(first: 100) {
    nodes {
      id
      title
    }
  }
}
```

Response includes:

```json
{
  "extensions": {
    "cost": {
      "requestedQueryCost": 102,
      "actualQueryCost": 52,
      "throttleStatus": {
        "maximumAvailable": 2000,
        "currentlyAvailable": 1948,
        "restoreRate": 100
      }
    }
  }
}
```

### Handling Rate Limits

```javascript
async function queryWithRetry(admin, query, variables, maxRetries = 3) {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      const response = await admin.graphql(query, { variables });
      const data = await response.json();

      if (data.errors?.some((e) => e.extensions?.code === "THROTTLED")) {
        const waitTime = Math.pow(2, attempt) * 1000;
        await new Promise((resolve) => setTimeout(resolve, waitTime));
        continue;
      }

      return data;
    } catch (error) {
      if (attempt === maxRetries - 1) throw error;
    }
  }
}
```

## Storefront API

### Authentication

```javascript
const storefrontClient = new StorefrontApiClient({
  privateAccessToken: process.env.STOREFRONT_ACCESS_TOKEN,
  storeDomain: "your-store.myshopify.com",
  apiVersion: "2025-01",
});
```

### Product Query (Storefront)

```graphql
query GetProduct($handle: String!) {
  product(handle: $handle) {
    id
    title
    description
    images(first: 5) {
      nodes {
        url
        altText
      }
    }
    variants(first: 100) {
      nodes {
        id
        title
        price {
          amount
          currencyCode
        }
        availableForSale
      }
    }
  }
}
```

### Cart Operations (Storefront)

```graphql
# Create cart
mutation CreateCart($lines: [CartLineInput!]!) {
  cartCreate(input: { lines: $lines }) {
    cart {
      id
      checkoutUrl
      lines(first: 10) {
        nodes {
          id
          quantity
          merchandise {
            ... on ProductVariant {
              title
            }
          }
        }
      }
    }
  }
}

# Add to cart
mutation AddToCart($cartId: ID!, $lines: [CartLineInput!]!) {
  cartLinesAdd(cartId: $cartId, lines: $lines) {
    cart {
      id
      lines(first: 10) {
        nodes {
          id
          quantity
        }
      }
    }
  }
}
```

## Webhooks

### Subscribe to Webhooks

```graphql
mutation WebhookSubscriptionCreate(
  $topic: WebhookSubscriptionTopic!
  $webhookSubscription: WebhookSubscriptionInput!
) {
  webhookSubscriptionCreate(
    topic: $topic
    webhookSubscription: $webhookSubscription
  ) {
    webhookSubscription {
      id
      topic
      endpoint {
        ... on WebhookHttpEndpoint {
          callbackUrl
        }
      }
    }
    userErrors {
      field
      message
    }
  }
}
```

Variables:

```json
{
  "topic": "PRODUCTS_CREATE",
  "webhookSubscription": {
    "callbackUrl": "https://your-app.com/webhooks",
    "format": "JSON"
  }
}
```

### Webhook Topics

| Topic                     | Description       |
| ------------------------- | ----------------- |
| `PRODUCTS_CREATE`         | Product created   |
| `PRODUCTS_UPDATE`         | Product updated   |
| `PRODUCTS_DELETE`         | Product deleted   |
| `ORDERS_CREATE`           | Order placed      |
| `ORDERS_UPDATED`          | Order modified    |
| `ORDERS_PAID`             | Order paid        |
| `CUSTOMERS_CREATE`        | Customer created  |
| `INVENTORY_LEVELS_UPDATE` | Inventory changed |

## Bulk Operations

### Bulk Query

```graphql
mutation BulkProducts {
  bulkOperationRunQuery(
    query: """
    {
      products {
        edges {
          node {
            id
            title
            variants {
              edges {
                node {
                  id
                  sku
                  price
                }
              }
            }
          }
        }
      }
    }
    """
  ) {
    bulkOperation {
      id
      status
    }
    userErrors {
      field
      message
    }
  }
}
```

### Poll Bulk Operation

```graphql
query BulkOperationStatus {
  currentBulkOperation {
    id
    status
    objectCount
    url
  }
}
```

## Best Practices

1. **Request only needed fields** - Reduces cost and response size
2. **Use fragments** - Reuse common field selections
3. **Handle errors** - Check for userErrors in mutations
4. **Implement pagination** - Don't request all records at once
5. **Monitor rate limits** - Use throttle status in responses
6. **Use bulk operations** - For large data exports

## Resources

- [Admin API Reference](https://shopify.dev/docs/api/admin-graphql)
- [Storefront API Reference](https://shopify.dev/docs/api/storefront)
- [GraphQL Basics](https://shopify.dev/docs/apps/build/graphql)
- [Rate Limits](https://shopify.dev/docs/api/usage/rate-limits)
- [Webhooks Reference](https://shopify.dev/docs/api/admin-graphql/latest/enums/WebhookSubscriptionTopic)
- [GraphiQL Explorer](https://shopify.dev/docs/apps/build/graphql/basics/graphiql)

For app integration, see the [app-development](../app-development/SKILL.md) skill.
````

## File: templates/skills/shopify-hydrogen/SKILL.md
````markdown
---
name: shopify-hydrogen
description: Expert guidance for headless commerce with Shopify Hydrogen including Remix routing, Storefront API, cart management, caching strategies, and deployment
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Headless Commerce with Hydrogen

## When to use this skill

Use this skill when:

- Building a custom headless storefront
- Using Hydrogen framework for e-commerce
- Deploying to Oxygen (Shopify's edge hosting)
- Working with the Storefront API
- Creating high-performance, custom storefronts
- Integrating Shopify with custom tech stacks

## What is Hydrogen?

Hydrogen is Shopify's official headless commerce framework built on:

- **React Router** - For routing and data loading
- **React** - Component-based UI
- **GraphQL** - Data fetching from Storefront API
- **Oxygen** - Global edge deployment (free hosting)

### Key Benefits

- **Build-ready components** - Pre-built commerce components
- **Free hosting** - Deploy to Oxygen at no extra cost
- **Fast by default** - SSR, progressive enhancement, nested routes
- **Shopify-native** - Deep integration with Shopify APIs

## Getting Started

### 1. Create a Hydrogen App

```bash
# Create new Hydrogen project
npm create @shopify/hydrogen@latest

# Follow the prompts:
# - Choose a template (Demo store, Hello World, Skeleton)
# - Enter your store URL
# - Select JavaScript or TypeScript
```

### 2. Project Structure

```
hydrogen-app/
├── app/
│   ├── components/        # React components
│   ├── routes/            # Page routes
│   │   ├── _index.tsx     # Home page
│   │   ├── products.$handle.tsx  # Product page
│   │   └── collections.$handle.tsx
│   ├── styles/            # CSS files
│   ├── entry.client.tsx   # Client entry
│   └── entry.server.tsx   # Server entry
├── public/                # Static assets
├── .env                   # Environment variables
├── hydrogen.config.ts     # Hydrogen config
└── package.json
```

### 3. Environment Setup

```env
# .env
SESSION_SECRET=your-session-secret
PUBLIC_STOREFRONT_API_TOKEN=your-storefront-api-token
PUBLIC_STORE_DOMAIN=your-store.myshopify.com
```

### 4. Start Development

```bash
npm run dev
```

## Core Concepts

### Routes and Data Loading

```tsx
// app/routes/products.$handle.tsx
import { useLoaderData, type LoaderFunctionArgs } from "@remix-run/react";

export async function loader({ params, context }: LoaderFunctionArgs) {
  const { storefront } = context;
  const { handle } = params;

  const { product } = await storefront.query(PRODUCT_QUERY, {
    variables: { handle },
  });

  if (!product) {
    throw new Response("Not Found", { status: 404 });
  }

  return { product };
}

export default function ProductPage() {
  const { product } = useLoaderData<typeof loader>();

  return (
    <div className="product-page">
      <h1>{product.title}</h1>
      <p>{product.description}</p>
      <ProductPrice data={product} />
      <AddToCartButton variantId={product.variants.nodes[0].id} />
    </div>
  );
}

const PRODUCT_QUERY = `#graphql
  query Product($handle: String!) {
    product(handle: $handle) {
      id
      title
      description
      handle
      variants(first: 1) {
        nodes {
          id
          price {
            amount
            currencyCode
          }
        }
      }
      featuredImage {
        url
        altText
      }
    }
  }
`;
```

### Hydrogen Components

```tsx
import {
  Image,
  Money,
  CartForm,
  CartLineQuantity,
  useCart,
} from '@shopify/hydrogen';

// Image Component
<Image
  data={product.featuredImage}
  aspectRatio="1/1"
  sizes="(min-width: 45em) 50vw, 100vw"
/>

// Money Component
<Money data={product.price} />

// Add to Cart
<CartForm
  route="/cart"
  action={CartForm.ACTIONS.LinesAdd}
  inputs={{
    lines: [{ merchandiseId: variantId, quantity: 1 }],
  }}
>
  <button type="submit">Add to Cart</button>
</CartForm>
```

### Cart Management

```tsx
// app/routes/cart.tsx
import { CartForm } from "@shopify/hydrogen";
import { type ActionFunctionArgs } from "@remix-run/cloudflare";

export async function action({ request, context }: ActionFunctionArgs) {
  const { cart } = context;
  const formData = await request.formData();
  const { action, inputs } = CartForm.getFormInput(formData);

  switch (action) {
    case CartForm.ACTIONS.LinesAdd:
      return await cart.addLines(inputs.lines);
    case CartForm.ACTIONS.LinesUpdate:
      return await cart.updateLines(inputs.lines);
    case CartForm.ACTIONS.LinesRemove:
      return await cart.removeLines(inputs.lineIds);
    default:
      throw new Error("Unknown cart action");
  }
}

export default function CartPage() {
  const cart = useLoaderData<typeof loader>();

  return (
    <div className="cart">
      {cart.lines.nodes.map((line) => (
        <CartLineItem key={line.id} line={line} />
      ))}
      <Money data={cart.cost.totalAmount} />
    </div>
  );
}
```

### Collections

```tsx
// app/routes/collections.$handle.tsx
export async function loader({ params, context }: LoaderFunctionArgs) {
  const { handle } = params;
  const { storefront } = context;

  const { collection } = await storefront.query(COLLECTION_QUERY, {
    variables: { handle, first: 24 },
  });

  return { collection };
}

const COLLECTION_QUERY = `#graphql
  query Collection($handle: String!, $first: Int!) {
    collection(handle: $handle) {
      id
      title
      description
      products(first: $first) {
        nodes {
          id
          title
          handle
          featuredImage {
            url
            altText
          }
          priceRange {
            minVariantPrice {
              amount
              currencyCode
            }
          }
        }
      }
    }
  }
`;
```

## Advanced Patterns

### Search Implementation

```tsx
// app/routes/search.tsx
export async function loader({ request, context }: LoaderFunctionArgs) {
  const url = new URL(request.url);
  const searchTerm = url.searchParams.get("q");

  if (!searchTerm) {
    return { results: null };
  }

  const { storefront } = context;
  const { products } = await storefront.query(SEARCH_QUERY, {
    variables: { query: searchTerm, first: 20 },
  });

  return { results: products };
}

const SEARCH_QUERY = `#graphql
  query Search($query: String!, $first: Int!) {
    products(query: $query, first: $first) {
      nodes {
        id
        title
        handle
        featuredImage {
          url
          altText
        }
      }
    }
  }
`;
```

### Customer Authentication

```tsx
// app/routes/account.login.tsx
export async function action({ request, context }: ActionFunctionArgs) {
  const { customerAccount } = context;
  const formData = await request.formData();
  const email = formData.get("email");
  const password = formData.get("password");

  const { customerAccessTokenCreate } = await customerAccount.mutate(
    LOGIN_MUTATION,
    { variables: { input: { email, password } } },
  );

  if (customerAccessTokenCreate.customerAccessToken) {
    // Store token in session
    return redirect("/account");
  }

  return { errors: customerAccessTokenCreate.customerUserErrors };
}
```

### Localization

```tsx
// Multi-currency and language support
export async function loader({ request, context }: LoaderFunctionArgs) {
  const { storefront } = context;

  // Get localized data
  const { localization } = await storefront.query(LOCALIZATION_QUERY);

  // Query with localization context
  const { product } = await storefront.query(PRODUCT_QUERY, {
    variables: { handle, country: "CA", language: "FR" },
  });

  return { product, localization };
}
```

## Oxygen Deployment

### Deploy from CLI

```bash
# Link to Shopify store
npx shopify hydrogen link

# Deploy to Oxygen
npx shopify hydrogen deploy
```

### Environment Variables

Set environment variables in Shopify admin:

1. Go to Sales channels > Hydrogen
2. Select your storefront
3. Add environment variables

### Preview Deployments

Every git push creates a preview URL for testing.

```bash
# Push to create preview
git push origin feature-branch
```

## Bring Your Own Stack

If not using Hydrogen, you can use the Storefront API with any framework:

### Install Headless Channel

```bash
# In your Shopify admin, install the Headless channel
# Create a storefront and get API credentials
```

### Use with Next.js

```typescript
// lib/shopify.ts
const domain = process.env.SHOPIFY_STORE_DOMAIN;
const storefrontAccessToken = process.env.SHOPIFY_STOREFRONT_ACCESS_TOKEN;

export async function shopifyFetch({ query, variables }) {
  const endpoint = `https://${domain}/api/2025-01/graphql.json`;

  const response = await fetch(endpoint, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-Shopify-Storefront-Access-Token": storefrontAccessToken,
    },
    body: JSON.stringify({ query, variables }),
  });

  return response.json();
}
```

### Storefront Web Components

```html
<!-- Embed products anywhere with Web Components -->
<script
  type="module"
  src="https://cdn.shopify.com/storefront-web-components/v1/storefront.js"
></script>

<shopify-product-provider store-domain="your-store.myshopify.com">
  <shopify-product handle="product-handle">
    <shopify-product-title></shopify-product-title>
    <shopify-product-price></shopify-product-price>
    <shopify-add-to-cart></shopify-add-to-cart>
  </shopify-product>
</shopify-product-provider>
```

## Performance Best Practices

1. **Server-side rendering** - SSR for initial page load
2. **Streaming** - Use React Suspense for progressive loading
3. **Image optimization** - Use Hydrogen's Image component
4. **Code splitting** - Lazy load non-critical components
5. **Cache headers** - Configure appropriate cache policies
6. **Prefetching** - Prefetch links on hover

```tsx
// Streaming example
import { Suspense } from "react";

function ProductPage() {
  return (
    <div>
      <ProductInfo />
      <Suspense fallback={<LoadingSkeleton />}>
        <ProductRecommendations />
      </Suspense>
    </div>
  );
}
```

## CLI Commands Reference

| Command                        | Description              |
| ------------------------------ | ------------------------ |
| `npm create @shopify/hydrogen` | Create new project       |
| `npm run dev`                  | Start dev server         |
| `npm run build`                | Build for production     |
| `npx shopify hydrogen link`    | Link to store            |
| `npx shopify hydrogen deploy`  | Deploy to Oxygen         |
| `npx shopify hydrogen preview` | Preview production build |

## Resources

- [Hydrogen Documentation](https://shopify.dev/docs/storefronts/headless/hydrogen)
- [Storefront API Reference](https://shopify.dev/docs/api/storefront)
- [Hydrogen Components](https://shopify.dev/docs/api/hydrogen)
- [Oxygen Hosting](https://shopify.dev/docs/storefronts/headless/hydrogen/deployments)
- [Demo Store Template](https://github.com/Shopify/hydrogen/tree/main/templates/demo-store)

For API details, see the [api-graphql](../api-graphql/SKILL.md) skill.
````

## File: templates/skills/shopify-liquid/SKILL.md
````markdown
---
name: shopify-liquid
description: Expert guidance for Shopify Liquid templating including objects, filters, tags, control flow, loops, snippets, sections, and forms
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Shopify Liquid Templating

## When to use this skill

Use this skill when:

- Writing Liquid template code
- Accessing Shopify data (products, collections, cart, etc.)
- Using Liquid filters to transform output
- Creating conditional logic and loops
- Building dynamic theme content
- Debugging Liquid code issues
- Optimizing Liquid performance

## Liquid Basics

### Output Tags

Output data using double curly braces:

```liquid
{{ product.title }}
{{ shop.name }}
{{ 'hello' | upcase }}
```

### Logic Tags

Use logic with `{% %}` tags:

```liquid
{% if product.available %}
  <p>In Stock</p>
{% else %}
  <p>Sold Out</p>
{% endif %}
```

### Whitespace Control

Use `-` to strip whitespace:

```liquid
{%- if condition -%}
  content
{%- endif -%}
```

## Core Objects

### Product Object

```liquid
{{ product.title }}
{{ product.description }}
{{ product.price | money }}
{{ product.compare_at_price | money }}
{{ product.vendor }}
{{ product.type }}
{{ product.tags | join: ', ' }}
{{ product.available }}
{{ product.url }}

<!-- Featured Image -->
{{ product.featured_image | image_url: width: 500 | image_tag }}

<!-- All Images -->
{% for image in product.images %}
  {{ image | image_url: width: 300 | image_tag }}
{% endfor %}

<!-- Variants -->
{% for variant in product.variants %}
  {{ variant.title }} - {{ variant.price | money }}
{% endfor %}

<!-- Metafields -->
{{ product.metafields.custom.care_instructions }}
```

### Collection Object

```liquid
{{ collection.title }}
{{ collection.description }}
{{ collection.products_count }}
{{ collection.url }}

{% for product in collection.products %}
  {{ product.title }}
{% endfor %}

<!-- Pagination -->
{% paginate collection.products by 12 %}
  {% for product in collection.products %}
    {% render 'product-card', product: product %}
  {% endfor %}
  {{ paginate | default_pagination }}
{% endpaginate %}
```

### Cart Object

```liquid
{{ cart.item_count }}
{{ cart.total_price | money }}
{{ cart.total_weight | weight_with_unit }}

{% for item in cart.items %}
  {{ item.product.title }}
  {{ item.variant.title }}
  {{ item.quantity }}
  {{ item.line_price | money }}
{% endfor %}

<!-- Cart Attributes -->
{{ cart.attributes.gift_message }}

<!-- Cart Note -->
{{ cart.note }}
```

### Customer Object

```liquid
{% if customer %}
  Hello, {{ customer.first_name }}!
  {{ customer.email }}
  {{ customer.orders_count }} orders
  {{ customer.total_spent | money }}

  {% for address in customer.addresses %}
    {{ address.street }}
    {{ address.city }}, {{ address.province }}
  {% endfor %}
{% else %}
  <a href="/account/login">Log in</a>
{% endif %}
```

### Shop Object

```liquid
{{ shop.name }}
{{ shop.email }}
{{ shop.domain }}
{{ shop.money_format }}
{{ shop.currency }}
{{ shop.enabled_currencies }}
```

### Request Object

```liquid
{{ request.locale.iso_code }}
{{ request.page_type }}
{{ request.path }}
{{ request.host }}
```

## Essential Filters

### String Filters

```liquid
{{ 'hello world' | capitalize }}     <!-- Hello world -->
{{ 'hello world' | upcase }}         <!-- HELLO WORLD -->
{{ 'HELLO' | downcase }}             <!-- hello -->
{{ '  hello  ' | strip }}            <!-- hello -->
{{ 'hello' | append: ' world' }}     <!-- hello world -->
{{ 'hello world' | prepend: 'say ' }} <!-- say hello world -->
{{ 'hello' | replace: 'e', 'a' }}    <!-- hallo -->
{{ 'hello world' | split: ' ' }}     <!-- ['hello', 'world'] -->
{{ 'hello world' | truncate: 8 }}    <!-- hello... -->
{{ 'hello world' | truncatewords: 1 }} <!-- hello... -->
{{ 'hello' | size }}                 <!-- 5 -->
```

### Number Filters

```liquid
{{ 4.5 | ceil }}                     <!-- 5 -->
{{ 4.5 | floor }}                    <!-- 4 -->
{{ 4.567 | round: 2 }}               <!-- 4.57 -->
{{ 5 | plus: 3 }}                    <!-- 8 -->
{{ 5 | minus: 3 }}                   <!-- 2 -->
{{ 5 | times: 3 }}                   <!-- 15 -->
{{ 10 | divided_by: 3 }}             <!-- 3 -->
{{ 10 | modulo: 3 }}                 <!-- 1 -->
{{ 1234.56 | money }}                <!-- $1,234.56 -->
{{ 1234.56 | money_without_currency }} <!-- 1,234.56 -->
```

### Array Filters

```liquid
{{ array | first }}
{{ array | last }}
{{ array | size }}
{{ array | join: ', ' }}
{{ array | sort }}
{{ array | sort: 'price' }}
{{ array | reverse }}
{{ array | uniq }}
{{ array | compact }}
{{ array | concat: other_array }}
{{ array | map: 'title' }}
{{ array | where: 'available', true }}
```

### URL Filters

```liquid
{{ 'products' | url }}
{{ product.url | within: collection }}
{{ 'style.css' | asset_url }}
{{ 'image.png' | asset_url }}
{{ 'logo.png' | file_url }}
{{ product.featured_image | image_url: width: 500 }}
{{ product | product_image_url: 'master' }}
```

### Image Filters

```liquid
<!-- Modern image_url approach (recommended) -->
{{ image | image_url: width: 800 }}
{{ image | image_url: width: 800, height: 600, crop: 'center' }}
{{ image | image_url: width: 800 | image_tag }}

<!-- Responsive images -->
{{ image | image_url: width: 1200 | image_tag:
  loading: 'lazy',
  widths: '300, 600, 900, 1200',
  sizes: '(max-width: 600px) 100vw, 50vw'
}}

<!-- With alt text -->
{{ image | image_url: width: 500 | image_tag: alt: product.title }}
```

### Money Filters

```liquid
{{ product.price | money }}                    <!-- $10.00 -->
{{ product.price | money_with_currency }}      <!-- $10.00 USD -->
{{ product.price | money_without_trailing_zeros }} <!-- $10 -->
{{ product.price | money_without_currency }}   <!-- 10.00 -->
```

### Date Filters

```liquid
{{ article.created_at | date: '%B %d, %Y' }}   <!-- January 15, 2025 -->
{{ article.created_at | date: '%Y-%m-%d' }}    <!-- 2025-01-15 -->
{{ 'now' | date: '%H:%M' }}                    <!-- 14:30 -->
```

## Control Flow

### Conditionals

```liquid
{% if product.available %}
  In Stock
{% elsif product.compare_at_price %}
  Sale
{% else %}
  Sold Out
{% endif %}

<!-- Unless (opposite of if) -->
{% unless product.available %}
  Sold Out
{% endunless %}

<!-- Case/When -->
{% case product.type %}
  {% when 'Shirt' %}
    <p>It's a shirt!</p>
  {% when 'Pants' %}
    <p>It's pants!</p>
  {% else %}
    <p>Unknown type</p>
{% endcase %}
```

### Comparison Operators

```liquid
{% if product.price > 1000 %}{% endif %}
{% if product.price >= 1000 %}{% endif %}
{% if product.price < 1000 %}{% endif %}
{% if product.price <= 1000 %}{% endif %}
{% if product.title == 'Hat' %}{% endif %}
{% if product.title != 'Hat' %}{% endif %}
{% if product.tags contains 'sale' %}{% endif %}
{% if product.title %}{% endif %}              <!-- truthy check -->
{% if product.title == blank %}{% endif %}     <!-- blank check -->
```

### Logical Operators

```liquid
{% if product.available and product.price < 5000 %}
  Affordable and in stock!
{% endif %}

{% if product.type == 'Shirt' or product.type == 'Pants' %}
  It's clothing!
{% endif %}
```

## Loops

### For Loop

```liquid
{% for product in collection.products %}
  {{ forloop.index }}: {{ product.title }}
{% endfor %}

<!-- With limit and offset -->
{% for product in collection.products limit: 4 offset: 2 %}
  {{ product.title }}
{% endfor %}

<!-- Reversed -->
{% for product in collection.products reversed %}
  {{ product.title }}
{% endfor %}

<!-- Forloop variables -->
{% for item in array %}
  {{ forloop.index }}      <!-- 1, 2, 3... -->
  {{ forloop.index0 }}     <!-- 0, 1, 2... -->
  {{ forloop.first }}      <!-- true on first -->
  {{ forloop.last }}       <!-- true on last -->
  {{ forloop.length }}     <!-- total items -->
{% endfor %}

<!-- Else for empty -->
{% for product in collection.products %}
  {{ product.title }}
{% else %}
  No products found.
{% endfor %}
```

### Cycle

```liquid
{% for product in collection.products %}
  <div class="{% cycle 'odd', 'even' %}">
    {{ product.title }}
  </div>
{% endfor %}
```

### Tablerow

```liquid
<table>
  {% tablerow product in collection.products cols: 3 %}
    {{ product.title }}
  {% endtablerow %}
</table>
```

## Variables

### Assign

```liquid
{% assign my_variable = 'Hello' %}
{% assign price_in_dollars = product.price | divided_by: 100.0 %}
```

### Capture

```liquid
{% capture full_name %}
  {{ customer.first_name }} {{ customer.last_name }}
{% endcapture %}

<p>Hello, {{ full_name }}!</p>
```

### Increment/Decrement

```liquid
{% increment counter %}  <!-- 0 -->
{% increment counter %}  <!-- 1 -->
{% decrement counter %}  <!-- -1 -->
```

## Snippets and Sections

### Render Snippets

```liquid
<!-- Basic render -->
{% render 'product-card' %}

<!-- With variables -->
{% render 'product-card', product: product %}

<!-- With multiple variables -->
{% render 'product-card', product: product, show_price: true %}

<!-- For loop with render -->
{% render 'product-card' for collection.products as product %}
```

### Section Tags

```liquid
<!-- In layout file -->
{% section 'header' %}
{% sections 'footer-group' %}

<!-- Content placeholder -->
{{ content_for_layout }}
{{ content_for_header }}
```

## Forms

### Product Form

```liquid
{% form 'product', product %}
  <select name="id">
    {% for variant in product.variants %}
      <option value="{{ variant.id }}">{{ variant.title }}</option>
    {% endfor %}
  </select>
  <input type="number" name="quantity" value="1" min="1">
  <button type="submit">Add to Cart</button>
{% endform %}
```

### Contact Form

```liquid
{% form 'contact' %}
  <input type="email" name="contact[email]" required>
  <textarea name="contact[body]"></textarea>
  <button type="submit">Send</button>
{% endform %}
```

### Customer Forms

```liquid
<!-- Login -->
{% form 'customer_login' %}
  <input type="email" name="customer[email]">
  <input type="password" name="customer[password]">
  <button type="submit">Log In</button>
{% endform %}

<!-- Register -->
{% form 'create_customer' %}
  <input type="text" name="customer[first_name]">
  <input type="text" name="customer[last_name]">
  <input type="email" name="customer[email]">
  <input type="password" name="customer[password]">
  <button type="submit">Create Account</button>
{% endform %}
```

## Best Practices

1. **Use `render` not `include`** - `render` is faster and scopes variables
2. **Avoid complex logic in Liquid** - Move to JavaScript when possible
3. **Use descriptive variable names** - `{% assign product_price = ... %}`
4. **Leverage caching** - Use Liquid responsibly within sections
5. **Handle blank states** - Always check for `blank` or empty arrays
6. **Use schema defaults** - Provide sensible defaults in section schemas

## Common Patterns

### Sale Badge

```liquid
{% if product.compare_at_price > product.price %}
  {% assign savings = product.compare_at_price | minus: product.price %}
  {% assign percent_off = savings | times: 100.0 | divided_by: product.compare_at_price | round %}
  <span class="sale-badge">{{ percent_off }}% OFF</span>
{% endif %}
```

### Variant Selector

```liquid
{% unless product.has_only_default_variant %}
  {% for option in product.options_with_values %}
    <label>{{ option.name }}</label>
    <select name="options[{{ option.name }}]">
      {% for value in option.values %}
        <option value="{{ value }}">{{ value }}</option>
      {% endfor %}
    </select>
  {% endfor %}
{% endunless %}
```

## Resources

- [Liquid Reference](https://shopify.dev/docs/api/liquid)
- [Liquid Cheat Sheet](https://www.shopify.com/partners/shopify-cheat-sheet)
- [Objects Reference](https://shopify.dev/docs/api/liquid/objects)
- [Filters Reference](https://shopify.dev/docs/api/liquid/filters)
- [Tags Reference](https://shopify.dev/docs/api/liquid/tags)
````

## File: templates/skills/shopify-new-block/SKILL.md
````markdown
---
name: shopify-new-block
description: Scaffold a new Shopify section block with Liquid template, schema, doc comment, standard spacing, and translation key stubs following project conventions. Use when adding a new block type to a Shopify theme.
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Scaffold a New Shopify Block

Arguments: $ARGUMENTS = block name in kebab-case (e.g. `icon-list`, `testimonial`)

## Steps

1. **Read reference block**: Read `blocks/button.liquid` (or another existing block) to understand:
   - `{% doc %}` comment structure
   - `{{ block.shopify_attributes }}` usage
   - Standard spacing settings pattern
   - `visible_if` usage for advanced settings
   - Translation key conventions in `locales/en.default.json`

2. **Read locale file**: Read `locales/en.default.json` to understand the existing `blocks` key structure.

3. **Create block file** `blocks/<name>.liquid` with:

```liquid
{%- doc -%}
  Renders <description>.

  @param {type} setting_name - Description
{%- enddoc -%}

{%- liquid
  assign example_setting = block.settings.example_setting
-%}

<div
  class="block-<name>"
  style="{% render 'spacings', padding_top: block.settings.padding_top, padding_bottom: block.settings.padding_bottom %}"
  {{ block.shopify_attributes }}
>
  {%- comment -%} Block content here {%- endcomment -%}
</div>

{% schema %}
{
  "name": "t:blocks.<name>.name",
  "settings": [
    {
      "type": "header",
      "content": "t:schema.headers.content"
    },
    {
      "type": "header",
      "content": "t:schema.headers.spacing"
    },
    {
      "type": "select",
      "id": "padding_top",
      "label": "t:schema.settings.padding_top.label",
      "options": [
        { "value": "none", "label": "t:schema.options.none" },
        { "value": "s", "label": "t:schema.options.s" },
        { "value": "m", "label": "t:schema.options.m" },
        { "value": "l", "label": "t:schema.options.l" }
      ],
      "default": "none"
    },
    {
      "type": "select",
      "id": "padding_bottom",
      "label": "t:schema.settings.padding_bottom.label",
      "options": [
        { "value": "none", "label": "t:schema.options.none" },
        { "value": "s", "label": "t:schema.options.s" },
        { "value": "m", "label": "t:schema.options.m" },
        { "value": "l", "label": "t:schema.options.l" }
      ],
      "default": "none"
    },
    {
      "type": "checkbox",
      "id": "advanced_settings",
      "label": "t:schema.settings.advanced_settings.label"
    },
    {
      "type": "text",
      "id": "custom_class",
      "label": "t:schema.settings.custom_class.label",
      "visible_if": "{{ block.settings.advanced_settings }}"
    }
  ],
  "presets": [
    {
      "name": "t:blocks.<name>.name",
      "category": "Content"
    }
  ]
}
{% endschema %}
```

4. **Output translation key stubs** (do NOT write to locale file automatically):

```json
// Add to locales/en.default.json -> blocks -> <name>:
"<name>": {
  "name": "<Human Readable Name>",
  "settings": {
    "example_setting": {
      "label": "Example Setting"
    }
  }
}
```

5. **Summary**: Report:
   - Created file: `blocks/<name>.liquid`
   - Translation keys to add to `locales/en.default.json`
   - Reminder: Register block in the parent section's `{% schema %}` under `"blocks": [{"type": "<name>"}]`

## Rules
- Always include `{{ block.shopify_attributes }}` on the wrapper element
- Always include standard spacing settings (padding_top, padding_bottom) at the end
- Always include `advanced_settings` checkbox + `custom_class` as the last settings
- Use `visible_if` for optional/conditional settings
- Use `{%- doc -%}` comment at the top documenting parameters
- Underscore-prefix (`_name.liquid`) only for product sub-blocks in `sections/product.liquid`
- Use Tailwind CSS classes, no inline styles (except dynamic spacing)
- Read the actual project first — adapt the template to match existing conventions
- If a `spacings` snippet does not exist, use plain padding classes instead
````

## File: templates/skills/shopify-new-section/SKILL.md
````markdown
---
name: shopify-new-section
description: Scaffold a new Shopify section with Liquid template, schema, and optional JS/CSS entrypoints following project conventions. Use when creating a new section for a Shopify theme.
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Scaffold a New Shopify Section

Arguments: $ARGUMENTS = section name in kebab-case (e.g. `featured-collection`, `hero-banner`)

## Steps

1. **Read project patterns**: Read an existing section from `sections/` to understand the project's conventions for:
   - HTML structure and Tailwind class usage
   - Schema structure (settings, blocks, presets)
   - Translation key patterns in `locales/en.default.json`
   - Whether Vite entrypoints are used (`src/entrypoints/`)

2. **Create section file** `sections/<name>.liquid` with:

```liquid
{%- liquid
  assign title = section.settings.title
-%}

<section
  class="section-<name>"
  style="{% render 'spacings', padding_top: section.settings.padding_top, padding_bottom: section.settings.padding_bottom %}"
  {{ section.shopify_attributes }}
>
  <div class="page-width">
    {% if title != blank %}
      <h2 class="text-2xl font-bold">{{ title }}</h2>
    {% endif %}

    {%- comment -%} Section content here {%- endcomment -%}
  </div>
</section>

{% schema %}
{
  "name": "t:sections.<name>.name",
  "tag": "section",
  "class": "section-<name>",
  "settings": [
    {
      "type": "header",
      "content": "t:schema.headers.content"
    },
    {
      "type": "text",
      "id": "title",
      "label": "t:sections.<name>.settings.title.label"
    },
    {
      "type": "header",
      "content": "t:schema.headers.spacing"
    },
    {
      "type": "select",
      "id": "padding_top",
      "label": "t:schema.settings.padding_top.label",
      "options": [
        { "value": "none", "label": "t:schema.options.none" },
        { "value": "s", "label": "t:schema.options.s" },
        { "value": "m", "label": "t:schema.options.m" },
        { "value": "l", "label": "t:schema.options.l" }
      ],
      "default": "none"
    },
    {
      "type": "select",
      "id": "padding_bottom",
      "label": "t:schema.settings.padding_bottom.label",
      "options": [
        { "value": "none", "label": "t:schema.options.none" },
        { "value": "s", "label": "t:schema.options.s" },
        { "value": "m", "label": "t:schema.options.m" },
        { "value": "l", "label": "t:schema.options.l" }
      ],
      "default": "none"
    }
  ],
  "presets": [
    {
      "name": "t:sections.<name>.name"
    }
  ]
}
{% endschema %}
```

3. **If JS is needed**: Create `src/entrypoints/<name>.js` as a Vite entrypoint (only if `src/entrypoints/` exists).

4. **If CSS is needed**: Create `src/css/components/<name>.css` (only if `src/css/components/` exists).

5. **Output translation key stubs** (do NOT write to locale file automatically):

```json
// Add to locales/en.default.json -> sections -> <name>:
"<name>": {
  "name": "<Human Readable Name>",
  "settings": {
    "title": {
      "label": "Title"
    }
  }
}
```

6. **Summary**: Report created files and manual steps needed:
   - Which template JSON file to add the section to (e.g. `templates/index.json`)
   - Translation keys to add to `locales/en.default.json`

## Rules
- Always include `{{ section.shopify_attributes }}` on the outermost element
- Always include standard spacing settings (padding_top, padding_bottom) at the end
- Use `t:` translation keys for all user-facing strings in schema
- Use Tailwind CSS classes, never inline styles (except for dynamic spacing)
- Read the actual project first — adapt the template to match existing conventions
- If a `spacings` snippet does not exist, use plain padding classes instead
````

## File: templates/skills/shopify-theme-dev/SKILL.md
````markdown
---
name: shopify-theme-dev
description: Expert guidance for Shopify theme development including Dawn theme architecture, sections, blocks, section groups, metafields, and performance optimization
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Shopify Theme Development

## When to use this skill

Use this skill when:

- Creating a new Shopify theme from scratch
- Modifying or customizing an existing theme
- Understanding Shopify theme architecture
- Working with sections, blocks, and templates
- Setting up the development environment
- Deploying themes to a Shopify store
- Optimizing theme performance

## Theme Architecture Overview

### Directory Structure

A Shopify theme must follow this structure:

```
your-theme/
├── assets/          # CSS, JS, images, fonts
├── config/          # Theme settings (settings_schema.json, settings_data.json)
├── layout/          # Layout files (theme.liquid required)
├── locales/         # Translation files (en.default.json, etc.)
├── sections/        # Reusable section components
├── snippets/        # Reusable code snippets
└── templates/       # Page templates (JSON or Liquid)
    └── customers/   # Customer account templates
```

**Minimum Requirements:** Only `layout/theme.liquid` is required for upload.

### Component Hierarchy

```
Layout (theme.liquid)
  └── Template (product.json)
        └── Sections (product-details.liquid)
              └── Blocks (price, quantity, add-to-cart)
                    └── Snippets (icon-cart.liquid)
```

## Getting Started

### 1. Initialize a New Theme

Use the Skeleton theme as a starting point:

```bash
# Clone the Skeleton theme
shopify theme init my-theme

# Navigate to your theme
cd my-theme
```

The [Skeleton theme](https://github.com/shopify/skeleton-theme) is minimal and follows Shopify best practices.

### 2. Start Development Server

```bash
# Start local development with hot reload
shopify theme dev

# Connect to a specific store
shopify theme dev --store your-store.myshopify.com
```

This opens a local preview URL with live reloading.

### 3. Push to Shopify

```bash
# Upload as a new theme
shopify theme push --unpublished

# Push to an existing theme
shopify theme push --theme THEME_ID
```

## Key Concepts

### Layouts

Layouts wrap all pages. The main layout file is `layout/theme.liquid`:

```liquid
<!DOCTYPE html>
<html lang="{{ request.locale.iso_code }}">
<head>
  <title>{{ page_title }}</title>
  {{ content_for_header }}
</head>
<body>
  {% sections 'header-group' %}

  <main>
    {{ content_for_layout }}
  </main>

  {% sections 'footer-group' %}
</body>
</html>
```

### JSON Templates

Modern themes use JSON templates that reference sections:

```json
// templates/product.json
{
  "sections": {
    "main": {
      "type": "product-details",
      "settings": {}
    },
    "recommendations": {
      "type": "product-recommendations",
      "settings": {}
    }
  },
  "order": ["main", "recommendations"]
}
```

### Sections

Sections are reusable, customizable modules:

```liquid
<!-- sections/featured-collection.liquid -->
{% schema %}
{
  "name": "Featured Collection",
  "settings": [
    {
      "type": "collection",
      "id": "collection",
      "label": "Collection"
    },
    {
      "type": "range",
      "id": "products_to_show",
      "min": 2,
      "max": 12,
      "step": 1,
      "default": 4,
      "label": "Products to show"
    }
  ],
  "presets": [
    {
      "name": "Featured Collection"
    }
  ]
}
{% endschema %}

<section class="featured-collection">
  {% if section.settings.collection != blank %}
    {% for product in section.settings.collection.products limit: section.settings.products_to_show %}
      {% render 'product-card', product: product %}
    {% endfor %}
  {% endif %}
</section>
```

### Blocks

Blocks allow merchants to add, remove, and reorder content:

```liquid
{% schema %}
{
  "name": "Slideshow",
  "blocks": [
    {
      "type": "slide",
      "name": "Slide",
      "settings": [
        {
          "type": "image_picker",
          "id": "image",
          "label": "Image"
        },
        {
          "type": "text",
          "id": "heading",
          "label": "Heading"
        }
      ]
    }
  ]
}
{% endschema %}

{% for block in section.blocks %}
  <div class="slide" {{ block.shopify_attributes }}>
    <img src="{{ block.settings.image | image_url: width: 1920 }}">
    <h2>{{ block.settings.heading }}</h2>
  </div>
{% endfor %}
```

## Best Practices

### Performance

1. **Lazy load images** - Use `loading="lazy"` for images below the fold
2. **Optimize images** - Use `image_url` filter with appropriate widths
3. **Minimize render-blocking resources** - Defer non-critical CSS/JS
4. **Use native browser features** - Prefer CSS over JavaScript when possible

```liquid
<!-- Responsive images with lazy loading -->
{{ product.featured_image | image_url: width: 800 | image_tag:
  loading: 'lazy',
  widths: '300, 500, 800, 1200',
  sizes: '(max-width: 600px) 100vw, 50vw'
}}
```

### Accessibility

1. Use semantic HTML (`<main>`, `<nav>`, `<article>`)
2. Provide alt text for images
3. Ensure proper heading hierarchy
4. Support keyboard navigation
5. Maintain sufficient color contrast

### Theme Settings

Use `settings_schema.json` for global theme settings:

```json
[
  {
    "name": "theme_info",
    "theme_name": "My Theme",
    "theme_version": "1.0.0"
  },
  {
    "name": "Colors",
    "settings": [
      {
        "type": "color",
        "id": "primary_color",
        "label": "Primary color",
        "default": "#000000"
      }
    ]
  }
]
```

Access in Liquid: `{{ settings.primary_color }}`

## CLI Commands Reference

| Command                 | Description               |
| ----------------------- | ------------------------- |
| `shopify theme init`    | Clone Skeleton theme      |
| `shopify theme dev`     | Start development server  |
| `shopify theme push`    | Upload theme to store     |
| `shopify theme pull`    | Download theme from store |
| `shopify theme check`   | Run theme linter          |
| `shopify theme list`    | List all themes           |
| `shopify theme publish` | Publish unpublished theme |
| `shopify theme delete`  | Delete a theme            |

## Common Issues & Solutions

### Issue: Theme not syncing changes

**Solution:** Ensure `shopify theme dev` is running and check for file save errors.

### Issue: Section not appearing in editor

**Solution:** Add a `presets` array to the section schema.

### Issue: Slow page load

**Solution:** Run `shopify theme check` and address performance warnings.

## Resources

- [Dawn Theme (Reference)](https://github.com/Shopify/dawn)
- [Skeleton Theme (Starter)](https://github.com/shopify/skeleton-theme)
- [Theme Architecture Docs](https://shopify.dev/docs/storefronts/themes/architecture)
- [Theme Best Practices](https://shopify.dev/docs/storefronts/themes/best-practices)

For Liquid templating specifics, see the [liquid-templating](../liquid-templating/SKILL.md) skill.
````

## File: templates/skills/shopware6-best-practices/SKILL.md
````markdown
---
name: shopware6-best-practices
description: Shopware 6 development guidance for plugins and shop repos (DAL, services, migrations, subscribers, admin extensions, and safe working boundaries)
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Shopware 6 Best Practices

## When to use this skill

Use this skill when:

- Working in a Shopware 6 plugin or full shop repository
- Implementing DAL entities, repositories, or criteria queries
- Creating services, subscribers, controllers, or migrations
- Extending Admin UI with Vue.js components
- Debugging Shopware-specific lifecycle or cache issues

## Core principles

- Prefer DAL repositories over raw SQL/DBAL for business data access.
- Keep business logic in services and wire dependencies via DI.
- Write idempotent migrations and keep schema changes forward-safe.
- Minimize criteria associations to avoid over-fetching and slow queries.
- Use strict typing and PSR-12 conventions for maintainable PHP code.

## Safe working boundaries

- Allowed: `custom/static-plugins/`, plugin `src/`, `Resources/`, `config/`.
- Read-only: `vendor/`, `public/`, `var/`, generated cache/artifacts.
- Never edit core Shopware packages under `vendor/shopware/`.
- Never edit admin-managed plugins in `custom/plugins/` unless explicitly requested.

## Plugin structure checklist

- Bootstrap class (`*Plugin.php` or `*Bundle.php`) in `src/`.
- Services and subscribers registered in `Resources/config/services.xml`.
- Routes configured via attributes or `Resources/config/routes.xml`.
- Migrations in `src/Migration/`.
- Storefront/Admin assets in `Resources/public/`.
- Twig templates in `Resources/views/`.

## Runtime checks after changes

```bash
bin/console cache:clear
bin/console plugin:refresh
```

Use project-specific install/activate/update commands as needed for the target plugin.
````

## File: templates/AGENTS.md
````markdown
# AGENTS.md

## Purpose
Universal passive context for AGENTS.md-compatible tools (Cursor, Windsurf, Cline, and others).
Read this file before making multi-file edits, architectural changes, or release-impacting updates.

## Project Overview
<!-- Auto-Init populates this -->

## Project Context
For detailed project context, read:
- `.agents/context/STACK.md` - runtime, frameworks, key dependencies, and toolchain
- `.agents/context/ARCHITECTURE.md` - structure, entry points, boundaries, and data flow
- `.agents/context/CONVENTIONS.md` - coding conventions, testing patterns, and Definition of Done

If these files are missing or stale, regenerate with:
`npx @onedot/ai-setup --regenerate`

## Architecture Summary
<!-- Auto-Init populates this -->

## Commands
<!-- Auto-Init populates this -->

## Code Style Guidelines
- Follow existing lint and formatter config; do not introduce conflicting style rules.
- Prefer small, focused changes with clear intent and minimal side effects.
- Keep naming, folder structure, and abstraction patterns consistent with neighboring code.
- Add or update tests for behavior changes when a test framework is available.
- Avoid new dependencies unless there is a clear net benefit.

## Critical Rules
<!-- Auto-Init populates this -->

## Verification
- Run relevant lint, test, and build commands before marking work complete.
- Validate integrations affected by your changes (API calls, UI flows, background jobs).
- Summarize what was verified and the result.
````

## File: templates/repomix.config.json
````json
{
  "output": {
    "filePath": ".agents/repomix-snapshot.md",
    "style": "markdown",
    "compress": true
  },
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "node_modules",
      "dist",
      ".git",
      ".next",
      ".nuxt",
      "coverage",
      ".turbo",
      "*.lock",
      "*.lockb",
      ".agents/repomix-snapshot.md"
    ]
  },
  "security": {
    "enableSecurityCheck": true
  }
}
````

## File: BACKLOG.md
````markdown
# Backlog

Ideas and future work for ai-setup. Specs live in `specs/` — this file tracks ideas that don't yet warrant a spec.

## Active Spec

- **#069** Agent Rules & Template Standardization — create `agents.md` rules file, standardize agent metadata

## Ideas (no spec yet)

### Advanced Installation Profile
Opt-in power-user profile with opinionated defaults (more agents, stricter hooks, monorepo support). Rejected as premature — revisit if users request it.

### Analytics Dashboard (Standalone)
Self-hosted Claude Code usage dashboard (OpenTelemetry ingest, PR attribution, ROI metrics). Separate project, not part of ai-setup. Inspired by rudel.ai.

### Monorepo Context Guidance
Document what belongs in root vs local context for monorepos/repo-groups. Low priority — no user requests yet.

## Evaluate

### CocoIndex Code — Semantic Code Search MCP
- **URL:** https://github.com/cocoindex-io/cocoindex-code
- **What:** MCP server for semantic code search via natural language queries
- **Why interesting:** ~70% token savings, AST-based chunking (Tree-sitter), incremental indexing, embedded SQLite vector store, 25+ languages
- **Concerns:** Python dependency (our stack is Shell/Node), Rust build requirements, early-stage project
- **Status:** Watch — evaluate once project matures or when users request semantic search

## Rejected

- **#050** TSC in post-edit hook — too slow (whole-project check per edit), conflicts with deadloop-safe design
- **#051** PreCompact hook — already implemented
- **#063** Spec workflow rewind hardening — already covered by existing retry limits and context-monitor
- **#061** Command/Agent/Skill clarity docs — too generic, no concrete user pain
- **#067** Skill boundary guidance — overlaps with #061, skills are external
- **#064** spec-work-all scope alignment — addressed by #060 token optimization
- **#068** Advanced install profile — premature, moved to Ideas
````

## File: CLAUDE.md
````markdown
# CLAUDE.md

## Communication Protocol
No small talk. Just do it.
Confirmations one word (Done, Fixed). Show code changes as diff only.
If you edit the same file 3+ times without progress, stop and ask for guidance.

## Project Context (read before complex tasks)
Before multi-file changes or new features, read `.agents/context/`:
- `STACK.md` - Technology stack, versions, key dependencies, and what to avoid
- `ARCHITECTURE.md` - System architecture, directory structure, and data flow
- `CONVENTIONS.md` - Coding standards, naming patterns, error handling, and testing

## Commands
- `npx @onedot/ai-setup` — run the setup tool (installs Claude Code config, hooks, skills)
- `./bin/ai-setup.sh` — run directly from repo root
- No npm scripts defined; all logic lives in the shell script

## Critical Rules

### Shell Script Style
- Use `bash` strictly; avoid bashisms that break on `sh`
- Quote all variable expansions: `"$var"`, `"${var}"`, `"$@"`
- Use `local` for all function-scoped variables
- Check exit codes explicitly; prefer `|| return 1` over silent failures

### File and Path Conventions
- Templates live in `templates/` and are copied verbatim to the target project
- Do not modify template files for project-specific content — use generation logic in `bin/ai-setup.sh`
- All generated content must be in English; no umlauts or non-ASCII characters

### Safety and Idempotency
- All install steps must be idempotent — running twice must not corrupt state
- Check for existing files before overwriting; prompt or skip, never silently clobber
- Never `rm -rf` without an explicit user confirmation gate in the script

## Task Complexity Routing
Before starting, classify and state the task tier:

- **Simple** (typos, single-file fixes, config tweaks): proceed directly
- **Medium** (new feature, 2-3 files, component): use plan mode
- **Complex** (architecture, refactor, new system): stop and tell the user to run
  `/gsd:set-profile quality` or restart with `claude --model claude-opus-4-6`

Never start a complex task without flagging the model requirement first.

## Verification
After completing work, verify before marking done:
- Run tests if available (`/test`)
- For UI changes: use browser tools or describe expected result
- For API changes: make a test request
- Check the build still passes

Never mark work as completed without BOTH:
1. Automated checks pass (tests green, linter clean, build succeeds)
2. Explicit statement: "Verification complete: [what was checked and result]"

## Context Management
Your context will be compacted automatically — this is normal. Before compaction:
- Commit current work or save state to HANDOFF.md
- Track remaining work in the spec or a todo list
After fresh start: review git log, open specs, check test state.

If you see `[CONTEXT STALE]` in your context: note that project context files may be outdated, but continue with the current task. Do not interrupt work to refresh context.

## Prompt Cache Strategy
Claude caches prompts as a prefix — static content first, dynamic content last maximizes cache hits:
1. **System prompt + tools** — globally cached across all sessions
2. **CLAUDE.md** — cached per project (do not edit mid-session)
3. **Session context** (`.agents/context/`) — cached per session
4. **Conversation messages** — dynamic, appended each turn

Do not edit CLAUDE.md or tool definitions mid-session — it breaks the cache for all subsequent turns.
Pass dynamic updates (timestamps, file changes) via messages, not by editing static layers.

## Working Style
Read relevant code before answering questions about it.
Implement changes rather than only suggesting them.
Use subagents for parallel or isolated work. For simple tasks, work directly.

## Spec-Driven Development
Specs live in `specs/` -- structured task plans created before coding.

**When to suggest a spec:** Changes across 3+ files, new features, architectural changes, ambiguous requirements.
**Skip specs for:** Single-file fixes, typos, config changes.

**Workflow:**
1. `/spec "task"` (Opus in plan mode - creates detailed plan, you approve, spec file is created)
2. Review and refine spec if needed
3. `/spec-work NNN` (Sonnet executes the approved plan step-by-step)
4. `/spec-work-all` (Sonnet executes all draft specs in parallel via subagents)
5. Completed specs move to `specs/completed/`

See `specs/README.md` for details.

## Documentation Lookup
Always use Context7 MCP when you need library/API documentation, code generation,
setup or configuration steps. Add "use context7" to prompts or it will be auto-invoked.
````

## File: opencode.json
````json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-6",
  "small_model": "anthropic/claude-haiku-4-5",
  "instructions": [
    "CLAUDE.md"
  ],
  "mcp": {
    "context7": {
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp"
      ]
    }
  },
  "agent": {
    "build-validator": {
      "description": "Runs the project build command and reports pass/fail with output summary.",
      "mode": "subagent",
      "model": "anthropic/claude-haiku-4-5",
      "prompt": "{file:.claude/agents/build-validator.md}",
      "tools": {
        "read": true,
        "write": false,
        "edit": false,
        "bash": true
      }
    },
    "code-architect": {
      "description": "Reviews proposed architecture, specs, and design decisions for structural problems before implementation begins. Identifies over-engineering, missing abstractions, scalability risks, and integration issues.",
      "mode": "subagent",
      "model": "anthropic/claude-opus-4-6",
      "prompt": "{file:.claude/agents/code-architect.md}",
      "tools": {
        "read": true,
        "write": false,
        "edit": false,
        "bash": true
      }
    },
    "code-reviewer": {
      "description": "Reviews code changes for bugs, security vulnerabilities, and spec compliance. Reports findings with HIGH/MEDIUM confidence and a PASS/CONCERNS/FAIL verdict.",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-6",
      "prompt": "{file:.claude/agents/code-reviewer.md}",
      "tools": {
        "read": true,
        "write": false,
        "edit": false,
        "bash": true
      }
    },
    "context-refresher": {
      "description": "Regenerates .agents/context/ files (STACK.md, ARCHITECTURE.md, CONVENTIONS.md) when project config has changed.",
      "mode": "subagent",
      "model": "anthropic/claude-haiku-4-5",
      "prompt": "{file:.claude/agents/context-refresher.md}",
      "tools": {
        "read": true,
        "write": true,
        "edit": true,
        "bash": true
      }
    },
    "perf-reviewer": {
      "description": "Reviews code changes for performance issues. Reports findings with HIGH/MEDIUM confidence and a FAST/CONCERNS/SLOW verdict.",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-6",
      "prompt": "{file:.claude/agents/perf-reviewer.md}",
      "tools": {
        "read": true,
        "write": false,
        "edit": false,
        "bash": true
      }
    },
    "staff-reviewer": {
      "description": "Skeptical staff engineer review — challenges assumptions and finds production risks.",
      "mode": "subagent",
      "model": "anthropic/claude-opus-4-6",
      "prompt": "{file:.claude/agents/staff-reviewer.md}",
      "tools": {
        "read": true,
        "write": false,
        "edit": false,
        "bash": true
      }
    },
    "test-generator": {
      "description": "Generates missing tests for changed files. Detects the project test framework and writes tests only into test directories.",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-6",
      "prompt": "{file:.claude/agents/test-generator.md}",
      "tools": {
        "read": true,
        "write": true,
        "edit": true,
        "bash": true
      }
    },
    "verify-app": {
      "description": "Validates application functionality after changes by running tests, builds, and edge case checks.",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-6",
      "prompt": "{file:.claude/agents/verify-app.md}",
      "tools": {
        "read": true,
        "write": false,
        "edit": false,
        "bash": true
      }
    }
  },
  "command": {
    "analyze": {
      "description": "analyze",
      "template": "{file:.claude/commands/analyze.md}\\n\\n$ARGUMENTS"
    },
    "bug": {
      "description": "bug",
      "template": "{file:.claude/commands/bug.md}\\n\\n$ARGUMENTS"
    },
    "challenge": {
      "description": "challenge",
      "template": "{file:.claude/commands/challenge.md}\\n\\n$ARGUMENTS"
    },
    "commit": {
      "description": "commit",
      "template": "{file:.claude/commands/commit.md}\\n\\n$ARGUMENTS"
    },
    "context-full": {
      "description": "context full",
      "template": "{file:.claude/commands/context-full.md}\\n\\n$ARGUMENTS"
    },
    "evaluate": {
      "description": "evaluate",
      "template": "{file:.claude/commands/evaluate.md}\\n\\n$ARGUMENTS"
    },
    "grill": {
      "description": "grill",
      "template": "{file:.claude/commands/grill.md}\\n\\n$ARGUMENTS"
    },
    "pr": {
      "description": "pr",
      "template": "{file:.claude/commands/pr.md}\\n\\n$ARGUMENTS"
    },
    "reflect": {
      "description": "reflect",
      "template": "{file:.claude/commands/reflect.md}\\n\\n$ARGUMENTS"
    },
    "release": {
      "description": "release",
      "template": "{file:.claude/commands/release.md}\\n\\n$ARGUMENTS"
    },
    "review": {
      "description": "review",
      "template": "{file:.claude/commands/review.md}\\n\\n$ARGUMENTS"
    },
    "spec-board": {
      "description": "spec board",
      "template": "{file:.claude/commands/spec-board.md}\\n\\n$ARGUMENTS"
    },
    "spec-review": {
      "description": "spec review",
      "template": "{file:.claude/commands/spec-review.md}\\n\\n$ARGUMENTS"
    },
    "spec-work-all": {
      "description": "spec work all",
      "template": "{file:.claude/commands/spec-work-all.md}\\n\\n$ARGUMENTS"
    },
    "spec-work": {
      "description": "spec work",
      "template": "{file:.claude/commands/spec-work.md}\\n\\n$ARGUMENTS"
    },
    "spec": {
      "description": "spec",
      "template": "{file:.claude/commands/spec.md}\\n\\n$ARGUMENTS"
    },
    "techdebt": {
      "description": "techdebt",
      "template": "{file:.claude/commands/techdebt.md}\\n\\n$ARGUMENTS"
    },
    "test": {
      "description": "test",
      "template": "{file:.claude/commands/test.md}\\n\\n$ARGUMENTS"
    }
  }
}
````

## File: .agents/context/CONCEPT.md
````markdown
# Concept: @onedot/ai-setup

## What Is This?

`@onedot/ai-setup` is a one-command scaffolding tool that gives any project a complete, production-ready AI development environment. Run it once and you have:

- A project memory system (CLAUDE.md + context files)
- Safety hooks that prevent common AI mistakes
- Curated slash commands for the development workflow
- AI-selected skills matched to your tech stack
- Built-in integrations (Context7, persistent memory, official plugins)

## The Problem

Setting up Claude Code for a new project involves many moving parts: writing CLAUDE.md, configuring permissions, installing hooks, picking skills, setting up MCP servers. Each step is documented separately, and doing it right requires understanding the full system.

Most projects skip steps or copy config from old projects without updating it. The result is AI assistants that don't know the tech stack, have overly broad permissions (`Bash(*)`), no linting hooks, and no context files.

## Who Is This For

For any developer or agency team using Claude Code — from solo freelancers
to multi-developer teams. No prior Claude Code expertise required.

The goal is an agency-grade baseline: every project starts with the same
proven setup, every developer on the team works with the same guardrails,
and no session begins with "explain this codebase to me again."

## Why One Command?

The goal is zero configuration for the consumer of the tool. A developer should be able to type one command and immediately have a working AI development environment. The setup adapts to the project automatically — it reads `package.json`, detects the tech stack, and generates context files specific to that codebase.

## What Success Looks Like

After setup, the daily workflow is spec-driven: write a structured spec,
execute it step by step, review the result. New features, optimizations,
and bug fixes all follow the same pattern.

Success means Claude understands the project from session one, doesn't
make avoidable mistakes, and the team burns tokens on actual work —
not on setup, re-explanation, or recovering from AI errors.

## Templates, Not Generation

The core scaffolding (hooks, settings, commands) is template-based, not generated. Templates are committed to this repository and copied 1:1. This is intentional:

- **Predictable**: every project gets the same battle-tested hooks
- **Reviewable**: you can read exactly what will be installed before running
- **Maintainable**: updating templates in this repo propagates via version bumps
- **Lightweight**: no LLM call needed for the deterministic parts

Generation is reserved for the parts that *must* be project-specific: CLAUDE.md Commands section, ARCHITECTURE.md, STACK.md, CONVENTIONS.md. These require understanding the actual codebase.

## AI Curation, Not AI Generation (for Skills)

Skills are not generated — they are installed from the skills.sh marketplace. The AI (Claude Haiku) is used only to *select* the best ones: it reads the install counts, tech keywords, and dependency list, and picks the top 5. This keeps the curation fast (one Haiku turn), cheap, and grounded in real community signal (install counts).

## Hook-Based Safety

AI assistants make mistakes: editing `.env` files, getting into edit loops, breaking linting rules. Hooks solve this at the infrastructure level, not the prompt level. Prompting an AI "don't edit .env" is unreliable. A PreToolUse hook that blocks the edit entirely is reliable.

The hook system is lightweight by design — every hook must complete in under 50ms with no API calls. They run on every tool use and must not slow down the development loop.

## Project Memory, Not Session Memory

CLAUDE.md and `.agents/context/` are persistent project memory. They survive across Claude Code sessions, team members, and context resets. This is the key insight: instead of re-explaining the project to Claude every session, the context files do it automatically by being referenced in CLAUDE.md (which Claude always reads at startup).

The three context files (STACK.md, ARCHITECTURE.md, CONVENTIONS.md) give Claude instant, accurate project understanding that normally takes 10–20 minutes of manual exploration per session.
````

## File: .claude/commands/evaluate.md
````markdown
---
model: opus
mode: plan
argument-hint: "<url-or-pasted-text>"
allowed-tools: Read, Glob, Grep, WebFetch, WebSearch, AskUserQuestion
---

Systematically evaluates an external idea, article, tool, or pattern against the existing npx-ai-setup template inventory. Input: $ARGUMENTS

## Phase 1 — Acquire Input

### 1a — Parse Input

Inspect `$ARGUMENTS`:

- If it starts with `http://` or `https://`: fetch via WebFetch. Use the prompt: "Extract all Claude Code patterns, workflow commands, agent definitions, hook configurations, settings fields, and tool recommendations mentioned in this content. List each as a named item with a one-sentence description."
- If it looks like a search query (no URL, short phrase): use WebSearch to find the most relevant article or discussion, then WebFetch the result.
- Otherwise: treat the full argument text as pasted content and extract patterns directly by reading it carefully.

Produce a numbered **Proposal Inventory** — every distinct pattern, feature, command, agent, rule, hook, or tool identified in the input. For each item, also note any specific implementation details, code snippets, or concrete approaches mentioned. Format:

```
1. [Name]: [one-line description]
   Implementation detail: [specific code, config, or approach if given]
2. [Name]: [one-line description]
   Implementation detail: [...]
```

If nothing can be extracted, report "No actionable Claude Code patterns found" and stop.

---

## Phase 2 — Build Existing Inventory (Shallow Pass)

Scan the project to understand what we already have. Run all reads in parallel:

1. Glob `templates/commands/*.md` — list all filenames
2. Glob `templates/agents/*.md` — list all filenames
3. Glob `templates/claude/rules/*.md` — list all filenames
4. Glob `templates/claude/hooks/*.sh` — list all hook filenames
5. Read `templates/claude/settings.json` — note hook types and field names (no need to read full content)
6. Glob `.claude/commands/*.md` — list project-local commands

Produce a compact **Existing Inventory** by category (names only at this stage).

---

## Phase 3 — Gap Analysis with Deep Comparison

For each item in the Proposal Inventory:

**Step 3a — Initial match**: Use Grep to search the `templates/` directory for the concept name, key terms, or related keywords. Identify the most likely existing equivalent.

**Step 3b — Deep read for non-obvious cases**: If a potential match is found and it's not immediately clear whether it's REDUNDANT or could be improved:
- Read the **full content** of the matching existing file(s)
- Read any related files referenced in it (e.g., if a command delegates to an agent, read that agent too)
- Compare the proposed implementation detail against our actual code line by line

**Step 3c — Classify** using these categories:

| Classification | Meaning |
|---|---|
| **NEW** | We have nothing equivalent — this fills a genuine gap |
| **PARTIAL** | We have this but the proposal has specific improvements we could adopt (list exactly what) |
| **BETTER** | The proposal is stronger overall — our version should be replaced |
| **REDUNDANT** | We have this fully — our version is equivalent or superior, nothing to borrow |
| **WORSE** | We have this and our version is clearly stronger — the proposal would be a downgrade |

**Critical rule**: Do NOT classify as REDUNDANT without reading the full file and comparing implementation details. Even similar-sounding features may differ in edge case handling, error recovery, scope, or specific code patterns.

---

## Phase 4 — Output: Findings Table

```
## Evaluation Results

**Source**: [URL or "inline text"]
**Evaluated**: [date]

### Findings

| # | Pattern | Class | Existing File | Detail |
|---|---------|-------|---------------|--------|
| 1 | name    | NEW   | —             | —      |
| 2 | name    | PARTIAL | templates/commands/foo.md | Proposal adds: [specific line/approach missing from ours] |
| 3 | name    | BETTER  | templates/agents/bar.md   | Proposal is stronger because: [specific reason] |
| 4 | name    | REDUNDANT | templates/commands/baz.md | Our version covers this fully |
| 5 | name    | WORSE   | templates/claude/rules/general.md | Our version handles: [what theirs misses] |
```

For **PARTIAL** and **BETTER** findings, the Detail column must be specific:
- Quote or describe the exact code/approach from the proposal that we lack
- Reference the exact line or section in our existing file where this could be added
- Example: "Proposal adds `tsc --noEmit` after TS edits; our `post-edit-lint.sh:7` only runs ESLint"

```
### Summary
- NEW: N | PARTIAL: N | BETTER: N | REDUNDANT: N | WORSE: N

### Overhead Assessment (NEW, PARTIAL, BETTER only)

| # | Pattern | Maintenance | Integration | User Value | Adopt? |
|---|---------|-------------|-------------|------------|--------|
| 1 | name    | low         | low         | high       | YES    |

### Verdict

[One paragraph: overall assessment. Highlight the highest-value PARTIAL/BETTER/NEW findings.]
```

---

## Phase 5 — Adoption Candidates

List all NEW, PARTIAL, and BETTER findings with medium/high user value:

```
## Adoption Candidates

1. [Pattern] — [one-line rationale]
   Class: NEW | Action: Create spec for `templates/commands/[name].md`

2. [Pattern] — [one-line rationale]
   Class: PARTIAL | Specific improvement: [exact change to make]
   Action: Modify `templates/claude/hooks/[file].sh` via spec — add [what]

3. [Pattern] — [one-line rationale]
   Class: BETTER | Action: Replace `templates/agents/[name].md` via spec
```

---

## Phase 6 — Spec Creation Gate

Use `AskUserQuestion` with multiSelect: true. Options: one per adoption candidate, plus "Keine — spaeter entscheiden".

If the user selects items: output pre-filled `/spec` commands with enough detail that the spec writer understands the exact change needed. For PARTIAL items, include the specific code or line to add.

Example:
```
Run these commands to create specs:

  /spec "Add tsc --noEmit to post-edit-lint.sh after .ts/.tsx edits — only when tsconfig.json exists in project root; insert after ESLint block at line 7"
```

---

## Rules

- Read-only: never write, create, or modify any file
- Never auto-create specs — only recommend `/spec` commands
- Always read the full existing file before classifying as REDUNDANT
- Scoped to Claude Code AI dev environment patterns only
- If WebFetch fails, ask user to paste content directly
````

## File: .claude/commands/release.md
````markdown
---
model: sonnet
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
---

Bumps version, updates CHANGELOG, commits, and tags the release. Use when shipping a new version.

## Process

1. **Read current state**
   - Run `git log --oneline $(git describe --tags --abbrev=0 2>/dev/null)..HEAD 2>/dev/null || git log --oneline` to see commits since last tag
   - Read `CHANGELOG.md` — find the `## [Unreleased]` section and collect its entries
   - Read `package.json` to get current version

2. **Determine version bump**
   - Show the unreleased commits and CHANGELOG entries to the user
   - Ask which version bump to apply:
     - **patch** (1.1.4 → 1.1.5): bug fixes, small improvements
     - **minor** (1.1.4 → 1.2.0): new features, backward-compatible
     - **major** (1.1.4 → 2.0.0): breaking changes
   - Calculate the new version from the current one

3. **Check README counts**
   - Commands: `ls .claude/commands/*.md 2>/dev/null | wc -l` — compare to stated count in README ("15 commands", etc.)
   - Agents: `ls .claude/agents/*.md 2>/dev/null | wc -l` — compare to stated count in README ("8 agents", etc.)
   - Hooks: `ls .claude/hooks/*.sh 2>/dev/null | wc -l` — compare to stated count in README ("6 hooks", etc.)
   - If any count differs, report all discrepancies and ask user to fix README before proceeding

4. **Update package.json**
   - Replace `"version": "X.Y.Z"` with the new version
   - Show the change as a diff

5. **Update CHANGELOG.md**
   - Replace the `## [Unreleased]` heading with `## [vX.Y.Z] — YYYY-MM-DD` (today's date)
   - Add a new empty `## [Unreleased]` section above it:
     ```
     ## [Unreleased]


     ## [vX.Y.Z] — YYYY-MM-DD
     <previous entries>
     ```
   - If `[Unreleased]` is empty, still add it but note there were no unreleased entries

6. **Commit and tag**
   - Stage: `git add package.json CHANGELOG.md`
   - Commit: `git commit -m "release: vX.Y.Z"`
   - Tag: `git tag vX.Y.Z`
   - Report: "Tagged vX.Y.Z. Run `git push && git push --tags` when ready."
   - AI Setup installs `.github/workflows/release-from-changelog.yml` by default: pushing `vX.Y.Z` auto-creates/updates the GitHub Release body from the matching `CHANGELOG.md` section (`## [vX.Y.Z]`), so Slack release notifications include the changelog text.
   - Fallback safety: if no push-triggered release run appears within ~60 seconds after pushing the tag, run `gh workflow run release-from-changelog.yml -f tag=vX.Y.Z`.

## Rules
- Never push automatically — always leave push to the user
- Never skip the CHANGELOG update
- If [Unreleased] section is missing from CHANGELOG.md, stop and ask the user to run the CHANGELOG migration first
- Do NOT bump version if there are uncommitted changes (run `git status` check first)
````

## File: .claude/commands/spec.md
````markdown
---
model: opus
mode: plan
argument-hint: "[task description]"
allowed-tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

Creates a structured spec for the task: $ARGUMENTS. Use before implementing any multi-file or architectural change.

## Phase 1 — Challenge & Think Through

Before writing anything: challenge the idea hard, then think it completely through. Present findings in the chat.

### 1a — Load Skills
If `.claude/skills/` exists, glob all skill directories and read each `SKILL.md` (first 5 lines only). Apply their guidance throughout the entire process.

### 1b — Clarify
If the request is ambiguous or underspecified, ask 1-3 focused questions before proceeding. Wait for answers. Skip if the task is clear.

### 1c — Concept Fit
Read `.agents/context/CONCEPT.md` if it exists. Answer:
- Does this align with the project's core principles?
- Is it in scope for this codebase/tool?
- Would this belong in the core, or is it a plugin/workaround?

Rate: **ALIGNED / BORDERLINE / MISALIGNED**. If MISALIGNED → **REJECT** immediately.

### 1d — Necessity
- What specific problem does this solve? Is it real or hypothetical?
- What breaks or stays painful if we don't build it?
- Who reported this problem — users, or us?

### 1e — Think It Through
Sketch the full implementation mentally before writing the spec.
**Use `AskUserQuestion` at any decision point** — don't assume, ask. Multiple rounds are fine.
Checklist:
- Files/systems touched; exact change in each
- Integration path; what calls what; data/state flow
- Edge cases; failure behavior; recoverability
- Hidden complexity; hard-to-test/debug parts; 6-month maintenance pain
- Implicit dependencies and side effects

### 1f — Overhead & Risk
- Maintenance burden added?
- Does it increase surface area (more config, more flags, more docs)?
- What's the risk if the implementation is wrong?

### 1g — Simpler Alternatives
List 1-3 alternatives:
- A smaller scope version
- A workaround that avoids building anything
- **"Don't build it"** — explicitly if it applies
Scan with Glob and Grep for similar existing functionality. Check installed skills for overlap.

### 1h — Verdict
Present a clear summary of the thinking above, then choose exactly one:
**GO** — Needed, fits, complexity is understood. The implementation sketch from 1e becomes the basis for the spec steps.
**SIMPLIFY** — Merits exist but scope is too large. State the reduced scope. Ask user to confirm before proceeding.
**REJECT** — Misaligned, unnecessary, or risk outweighs benefit. State reason. Stop here.

---

## Phase 2 — Write the Spec

Only proceed if verdict is GO or user confirmed a SIMPLIFY scope.

### Step 1 — Determine spec number
Scan `specs/` (including `specs/completed/`) for existing `NNN-*.md` files, find the highest number, increment by 1. Use 3-digit zero-padded numbers.

### Step 2 — Analyze the task
Read the 2-3 most relevant source files. Use the implementation sketch from Phase 1e — do not re-analyze from scratch.

List any relevant installed skills in the spec Context section.

### Step 3 — Create the spec file
Translate the Phase 1e implementation sketch into spec steps. Steps should reflect actual implementation path, not generic placeholders.

### Step 4 — Present the spec
Show the spec to the user for review and refinement.

### Step 5 — Branch
Use `AskUserQuestion` to ask: "Branch fuer diese Spec erstellen?"
- **Ja** — run `git checkout -b spec/NNN-<slug>` (slug = spec filename without number prefix)
- **Nein** — skip, user bleibt auf aktuellem Branch
- **Spaeter** — skip, user entscheidet selbst

## Spec Template

```markdown
# Spec: [Clear Title]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft | **Branch**: —

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->
<!-- Branch is set automatically by /spec-work-all (worktree mode) or manually -->

## Goal
[One sentence]

## Context
[2-3 sentences. Why needed, what approach was chosen, relevant skills if any.]

## Steps
- [ ] Step 1: description
- [ ] Step 2: description
- [ ] Step 3: description

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Files to Modify
- `path/to/file` - reason

## Out of Scope
- What is NOT part of this task
```

## Constraints & Rules
- **Total spec: max 60 lines.** If more, split into multiple specs.
- **Goal**: 1 sentence. **Context**: 2-3 sentences.
- **Steps**: Flat checkbox list, max 8 items. No nested sub-steps.
- **Acceptance Criteria**: max 5 items. **Out of Scope**: max 3 items.
- Steps must come from the Phase 1e implementation sketch — be specific, include file paths.
- Use today's date. Filename: lowercase with hyphens.
- Always create `specs/` and `specs/completed/` if they don't exist.
````

## File: .claude/hooks/update-check.sh
````bash
#!/bin/bash
# SessionStart/UserPromptSubmit hook: update check + circuit breaker reset
# Fast path runs from cache; network lookup is backgrounded.

# Auto-reset circuit breaker — user sending a message = they've acknowledged the loop
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
PROJ_HASH=$(echo "$PROJECT_ROOT" | shasum | cut -c1-8)
CB_LOG="/tmp/claude-cb-${PROJ_HASH}.log"
[ -f "$CB_LOG" ] && rm -f "$CB_LOG"

SETUP_JSON="$PROJECT_ROOT/.ai-setup.json"
[ ! -f "$SETUP_JSON" ] && exit 0

INSTALLED=$(jq -r '.version // empty' "$SETUP_JSON" 2>/dev/null | sed 's/^v//' | tr -d '[:space:]')
[ -z "$INSTALLED" ] && exit 0

# Cache per project (24h TTL)
CACHE="/tmp/ai-setup-update-$(echo "$PROJECT_ROOT" | cksum | cut -d' ' -f1).txt"

if [ -f "$CACHE" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    AGE=$(( $(date +%s) - $(stat -f %m "$CACHE") ))
  else
    AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
  fi

  if [ "$AGE" -lt 86400 ]; then
    LATEST=$(tr -d '[:space:]' < "$CACHE" | sed 's/^v//')
    if [ -n "$LATEST" ] && [ "$LATEST" != "$INSTALLED" ]; then
      # Semver compare: only notify if registry version is strictly newer
      _gt=0
      IFS=. read -ra _a <<< "$LATEST"
      IFS=. read -ra _b <<< "$INSTALLED"
      for _i in 0 1 2; do
        [ "${_a[$_i]:-0}" -gt "${_b[$_i]:-0}" ] 2>/dev/null && _gt=1 && break
        [ "${_a[$_i]:-0}" -lt "${_b[$_i]:-0}" ] 2>/dev/null && break
      done
      [ "$_gt" -eq 1 ] && echo "ai-setup v${LATEST} available (you have v${INSTALLED}). Run: npx github:onedot-digital-crew/npx-ai-setup"
    fi
    exit 0
  fi
fi

# Stale or no cache — background fetch
(
  LATEST=""

  # Preferred when package is published on npm.
  if command -v npm >/dev/null 2>&1; then
    LATEST=$(npm view @onedot/ai-setup version 2>/dev/null | head -n1 | tr -d '[:space:]' | sed 's/^v//')
  fi

  # Fallback for GitHub-only installs.
  if [ -z "$LATEST" ] && command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    LATEST=$(curl -fsSL --max-time 5 "https://api.github.com/repos/onedot-digital-crew/npx-ai-setup/releases/latest" 2>/dev/null \
      | jq -r '.tag_name // empty' \
      | head -n1 \
      | tr -d '[:space:]' \
      | sed 's/^v//')
  fi

  # Fallback if there is no release yet.
  if [ -z "$LATEST" ] && command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    LATEST=$(curl -fsSL --max-time 5 "https://api.github.com/repos/onedot-digital-crew/npx-ai-setup/tags?per_page=1" 2>/dev/null \
      | jq -r '.[0].name // empty' \
      | head -n1 \
      | tr -d '[:space:]' \
      | sed 's/^v//')
  fi

  [ -n "$LATEST" ] && printf '%s\n' "$LATEST" > "$CACHE"
) &
exit 0
````

## File: .claude/settings.json
````json
{
  "permissions": {
    "allow": [
      "Read(src/**)",
      "Read(.planning/**)",
      "Bash(date:*)",
      "Bash(echo:*)",
      "Bash(cat:*)",
      "Bash(ls:*)",
      "Bash(mkdir:*)",
      "Bash(wc:*)",
      "Bash(head:*)",
      "Bash(tail:*)",
      "Bash(sort:*)",
      "Bash(grep:*)",
      "Bash(tr:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git status:*)",
      "Bash(git log:*)",
      "Bash(git diff:*)",
      "Bash(git tag:*)",
      "Bash(git branch:*)",
      "Bash(git checkout:*)",
      "Bash(git stash:*)",
      "Bash(git push -u origin claude/*)",
      "Bash(npm run *)",
      "Bash(npm test *)",
      "Bash(npm install *)",
      "Bash(npx eslint *)",
      "Bash(npx prettier *)",
      "Bash(npx vitest *)",
      "Bash(npx playwright *)",
      "Bash(gh pr *)",
      "Bash(gh issue *)",
      "Bash(jq:*)",
      "Bash(curl:*)"
    ],
    "deny": [
      "Read(.env*)",
      "Bash(rm -r *)",
      "Bash(rm -rf *)",
      "Bash(git reset --hard *)",
      "Bash(git clean *)",
      "Bash(git checkout -- *)",
      "Bash(git restore *)",
      "Bash(npm publish *)"
    ]
  },
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/cross-repo-context.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/update-check.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/post-edit-lint.sh",
            "timeout": 30
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/protect-files.sh"
          },
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/circuit-breaker.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/context-freshness.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/update-check.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude Code is ready\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  },
  "enabledPlugins": {
    "code-review@claude-plugins-official": true,
    "feature-dev@claude-plugins-official": true,
    "frontend-design@claude-plugins-official": true
  },
  "_cacheNote": "Keep tool/permission order stable — reordering the allow list mid-session breaks Claude's prompt cache prefix and increases cost."
}
````

## File: .github/workflows/release-from-changelog.yml
````yaml
name: Release From Changelog

on:
  push:
    tags:
      - "v*"
  create:
  workflow_dispatch:
    inputs:
      tag:
        description: "Release tag (e.g. v1.2.5)"
        required: true
        type: string

permissions:
  contents: write

jobs:
  release:
    if: ${{ github.event_name != 'create' || (github.event.ref_type == 'tag' && startsWith(github.event.ref, 'v')) }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Resolve tag
        id: vars
        run: |
          if [ "${{ github.event_name }}" = "workflow_dispatch" ]; then
            TAG="${{ inputs.tag }}"
          elif [ "${{ github.event_name }}" = "create" ]; then
            TAG="${{ github.event.ref }}"
          else
            TAG="${GITHUB_REF_NAME}"
          fi

          if [ -z "$TAG" ]; then
            echo "Tag could not be resolved."
            exit 1
          fi

          echo "tag=$TAG" >> "$GITHUB_OUTPUT"
          echo "Using tag: $TAG"

      - name: Extract changelog section
        run: |
          TAG="${{ steps.vars.outputs.tag }}"
          HEADING="## [$TAG]"

          if [ ! -f CHANGELOG.md ]; then
            echo "CHANGELOG.md not found."
            exit 1
          fi

          if ! grep -Fq "$HEADING" CHANGELOG.md; then
            echo "No changelog section found for $TAG (expected heading: $HEADING)."
            exit 1
          fi

          awk -v heading="$HEADING" '
            {
              if (in_section && $0 ~ "^## \\[" && index($0, heading) != 1) exit
              if (index($0, heading) == 1) in_section=1
              if (in_section) print
            }
          ' CHANGELOG.md > release_notes.md

          if [ ! -s release_notes.md ]; then
            echo "Extracted release notes are empty for $TAG."
            exit 1
          fi

          echo "Release notes extracted:"
          sed -n '1,120p' release_notes.md

      - name: Create or update GitHub release
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          TAG="${{ steps.vars.outputs.tag }}"

          if gh release view "$TAG" >/dev/null 2>&1; then
            gh release edit "$TAG" --title "$TAG" --notes-file release_notes.md
            echo "Updated release $TAG"
          else
            gh release create "$TAG" --title "$TAG" --notes-file release_notes.md
            echo "Created release $TAG"
          fi
````

## File: lib/detect.sh
````bash
#!/bin/bash
# System detection and template filtering
# Requires: $SYSTEM, $UPD_* flags

# Detect system from codebase signals when SYSTEM="auto"
# Updates SYSTEM in-place if a concrete signal is found
detect_system() {
  [ "$SYSTEM" != "auto" ] && return 0

  if find . -maxdepth 4 -name "theme.liquid" -not -path "*/node_modules/*" 2>/dev/null | grep -q . \
    || [ -f "shopify.app.toml" ] \
    || [ -f "shopify.web.toml" ] \
    || find . -maxdepth 5 -name "shopify.extension.toml" -not -path "*/node_modules/*" 2>/dev/null | grep -q . \
    || { [ -f package.json ] && grep -Eq '"@shopify/(shopify-api|shopify-app-remix|app-bridge|app-bridge-react|polaris)"' package.json 2>/dev/null; }; then
    SYSTEM="shopify"
  elif [ -f composer.json ] && [ -f artisan ]; then
    SYSTEM="laravel"
  elif [ -f composer.json ] && {
    [ -d vendor/shopware ] ||
    grep -Eq '"type"[[:space:]]*:[[:space:]]*"shopware-(platform-plugin|bundle)"' composer.json 2>/dev/null ||
    grep -Eq '"shopware/(core|storefront|administration|elasticsearch|recovery|platform)"' composer.json 2>/dev/null ||
    grep -Eq '"store\.shopware\.com/' composer.json 2>/dev/null ||
    [ -f manifest.xml ] ||
    { [ -d src ] && find src -maxdepth 2 \( -name "*Plugin.php" -o -name "*Bundle.php" \) 2>/dev/null | grep -q .; }
  }; then
    SYSTEM="shopware"
  elif [ -f package.json ] && grep -q '"nuxt"' package.json 2>/dev/null; then
    SYSTEM="nuxt"
  elif [ -f package.json ] && grep -q '"next"' package.json 2>/dev/null; then
    SYSTEM="next"
  elif [ -f package.json ] && grep -q '"@storyblok' package.json 2>/dev/null; then
    SYSTEM="storyblok"
  fi

  if [ "$SYSTEM" != "auto" ]; then
    echo "  🔍 Detected system: $SYSTEM"
  fi
}

# Distinguish Shopware plugin project from full shop repository.
# Sets SHOPWARE_TYPE to "plugin" or "shop".
# Called from run_generation() after SYSTEM is set.
detect_shopware_type() {
  SHOPWARE_TYPE=""
  [ "$SYSTEM" != "shopware" ] && return 0

  # Shop indicator: custom/plugins or custom/static-plugins directory
  if [ -d "custom/plugins" ] || [ -d "custom/static-plugins" ]; then
    SHOPWARE_TYPE="shop"
    return 0
  fi

  # Plugin indicator: composer.json type field
  local ctype
  ctype=$(jq -r '.type // ""' composer.json 2>/dev/null)
  if [ "$ctype" = "shopware-platform-plugin" ] || [ "$ctype" = "shopware-bundle" ]; then
    SHOPWARE_TYPE="plugin"
    return 0
  fi

  # Plugin indicator: bootstrap PHP class in src/
  if find src -maxdepth 2 \( -name "*Plugin.php" -o -name "*Bundle.php" \) 2>/dev/null | grep -q .; then
    SHOPWARE_TYPE="plugin"
    return 0
  fi

  # Plugin indicator: app-system manifest
  if [ -f manifest.xml ]; then
    SHOPWARE_TYPE="plugin"
    return 0
  fi

  # Fallback: assume plugin (smaller scope, safer default)
  SHOPWARE_TYPE="plugin"
}

# Returns 0 (true) if the given mapping's target path matches the selected update categories.
# Returns 1 (false) if the category is deselected — caller should skip this file.
# Defaults to "yes" for all categories when UPD_* flags are unset (fresh install / reinstall paths).
should_update_template() {
  local mapping="$1"
  local target="${mapping#*:}"
  if [[ "$target" == .claude/hooks/* ]] || [[ "$target" == .claude/rules/* ]]; then
    [ "${UPD_HOOKS:-yes}" = "yes" ] && return 0 || return 1
  elif [[ "$target" == .claude/settings* ]]; then
    [ "${UPD_SETTINGS:-yes}" = "yes" ] && return 0 || return 1
  elif [[ "$target" == "CLAUDE.md" ]]; then
    [ "${UPD_CLAUDE_MD:-yes}" = "yes" ] && return 0 || return 1
  elif [[ "$target" == "AGENTS.md" ]]; then
    [ "${UPD_AGENTS_MD:-yes}" = "yes" ] && return 0 || return 1
  elif [[ "$target" == .claude/commands/* ]]; then
    [ "${UPD_COMMANDS:-yes}" = "yes" ] && return 0 || return 1
  elif [[ "$target" == .claude/agents/* ]]; then
    [ "${UPD_AGENTS:-yes}" = "yes" ] && return 0 || return 1
  else
    [ "${UPD_OTHER:-yes}" = "yes" ] && return 0 || return 1
  fi
}
````

## File: specs/completed/034-multi-agent-command-upgrades.md
````markdown
# Spec: Multi-Agent Verification for /bug Command

> **Spec ID**: 034 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/034-multi-agent-command-upgrades

## Goal
Upgrade /bug to automatically verify and review fixes using subagents instead of asking the user to run tests manually.

## Context
/bug currently tells the user to "run existing tests" manually after fixing. Adding verify-app + code-reviewer as automatic post-fix steps closes the loop: the bug command now confirms the fix works and flags any introduced issues. /techdebt and /spec stay monolithic — /techdebt is designed for quick end-of-session sweeps, and Opus in /spec can search directly without subagent overhead.

## Steps
- [x] Step 1: In `templates/commands/bug.md`, add `Agent` to `allowed-tools`
- [x] Step 2: Replace Step 4 (manual verify instructions) with: spawn `verify-app` after the fix; if FAIL stop and report issues with suggestion to re-investigate
- [x] Step 3: If verify-app returns PASS, spawn `code-reviewer` to review the fix; include verdict in output; CONCERNS or PASS = done, FAIL = flag for manual review
- [x] Step 4: Run smoke tests (`./tests/smoke.sh`) to verify template parses correctly

## Acceptance Criteria
- [x] `/bug` automatically spawns verify-app after every fix
- [x] `/bug` spawns code-reviewer if verify-app passes
- [x] A broken fix (verify-app FAIL) stops the command and reports clearly
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/bug.md` — add Agent tool, replace manual verify step with subagent steps

## Out of Scope
- /techdebt parallel agents (wrong design intent — sweep should stay fast)
- /spec parallel research agents (Opus can search directly, no subagent overhead needed)
- /review, /grill, /commit changes
````

## File: specs/completed/035-analyze-command-parallel-exploration.md
````markdown
# Spec: /analyze Command with Parallel Codebase Exploration

> **Spec ID**: 035 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/035-analyze-command-parallel-exploration

## Goal
Add an /analyze command that uses 3 parallel Explore agents to produce a structured codebase overview in minutes instead of hours.

## Context
Projects have no fast way to get a full codebase overview. feature-dev shows the pattern: launch parallel specialized agents (architecture, hotspots, risks) simultaneously and synthesize results. Our /analyze command delivers this as a reusable, generic command installed in every project. Replaces the manual "explain this codebase" session-start pattern.

## Steps
- [x] Step 1: Create `templates/commands/analyze.md` with model: sonnet, allowed-tools including Agent
- [x] Step 2: Agent 1 focus: Architecture — entry points, data flow, module boundaries, key abstractions (reads `.agents/context/ARCHITECTURE.md` first if exists, then explores)
- [x] Step 3: Agent 2 focus: Hotspots — most-changed files (`git log --format="%f" | sort | uniq -c | sort -rn | head -20`), largest files, complex areas
- [x] Step 4: Agent 3 focus: Risks — TODOs/FIXMEs/HACKs, dead code patterns, missing error handling, inconsistent naming
- [x] Step 5: Orchestrator synthesizes all 3 results into a structured report: `## Architecture`, `## Hotspots`, `## Risks`, `## Recommendations`
- [x] Step 6: Verify that `analyze.md` is auto-discovered and installed during setup (templates/commands/ is auto-scanned — no code change in ai-setup.sh needed)
- [x] Step 7: Run smoke tests (`./tests/smoke.sh`) to verify the new template deploys correctly

## Acceptance Criteria
- [x] `/analyze` spawns 3 agents simultaneously (visible in output as parallel launches)
- [x] Report has 4 structured sections: Architecture, Hotspots, Risks, Recommendations
- [x] Command is installed to `.claude/commands/analyze.md` during `npx @onedot/ai-setup`
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/analyze.md` — create new command (only file needed; ai-setup.sh auto-discovers templates/commands/)

## Out of Scope
- Project-specific agent customization (generic command only)
- Persistent storage of analysis results (report is output only)
- Integration with spec creation (separate concern)
````

## File: specs/completed/041-skill-descriptions-best-practices.md
````markdown
# Spec: Improve Command Descriptions to Follow Anthropic Best Practices

> **Spec ID**: 041 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/041-skill-descriptions-best-practices

## Goal
Rewrite the first body line (description) of all 15 `templates/commands/*.md` to state what the command does AND when to use it, in third person, under 120 characters.

## Context
Anthropic's skill best practices require descriptions that include both purpose and trigger conditions for reliable discovery. Our current descriptions only state the action ("Stage all changes...") but not when Claude should select them. The first line after YAML frontmatter is used as the discovery description in the system prompt.

## Steps
- [x] Step 1: Read all 15 `templates/commands/*.md` files and document current first-body-line descriptions
- [x] Step 2: Rewrite each description to format: "[What it does]. Use when [trigger condition]." — third person, max 120 chars
- [x] Step 3: For commands with `$ARGUMENTS` (bug, spec, spec-work, spec-review), keep the argument reference in the description
- [x] Step 4: Verify no description exceeds 120 characters by running a length check across all files
- [x] Step 5: Run smoke tests (`bash tests/smoke-test.sh`) to ensure templates still install correctly

## Acceptance Criteria
- [x] All 15 command descriptions follow the "what + when" pattern
- [x] All descriptions are in third person (no "you" or imperative-only)
- [x] No description exceeds 120 characters
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/analyze.md` — description
- `templates/commands/bug.md` — description
- `templates/commands/commit.md` — description
- `templates/commands/context-full.md` — description
- `templates/commands/grill.md` — description
- `templates/commands/pr.md` — description
- `templates/commands/release.md` — description
- `templates/commands/review.md` — description
- `templates/commands/spec-board.md` — description
- `templates/commands/spec-review.md` — description
- `templates/commands/spec-work-all.md` — description
- `templates/commands/spec-work.md` — description
- `templates/commands/spec.md` — description
- `templates/commands/techdebt.md` — description
- `templates/commands/test.md` — description

## Out of Scope
- Adding `description:` frontmatter field (not confirmed supported by Claude Code)
- Changing command body/instructions beyond the first line
- Agent template descriptions (`templates/agents/*.md`)

## Review Feedback
Frontmatter fields were stripped from 4 files during description rewrite:
- `spec-work.md`: lost `disable-model-invocation: true` and `argument-hint: "[spec number]"`
- `bug.md`: lost `argument-hint: "[bug description]"` and `Agent` from allowed-tools
- `spec.md`: lost `argument-hint: "[task description]"`
- `spec-review.md`: lost `argument-hint: "[spec number]"`
Fix: restore all original frontmatter fields — only the first body line (description) should change.
````

## File: templates/claude/hooks/cross-repo-context.sh
````bash
#!/bin/bash
# cross-repo-context.sh — SessionStart hook
# Emits compact sibling-repo context across related repositories.
# Priority:
#   1) Explicit map: .agents/context/repo-group.json (framework-agnostic)
#   2) Fallback discovery: naming pattern sw-<module>-<suite>

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
REPO_NAME="$(basename "$PROJECT_DIR")"

repo_summary() {
  local repo="$1"
  local module="$2"
  local summary=""
  local file
  for file in "$repo/.agents/context/ROLE.md" "$repo/.agents/context/ARCHITECTURE.md" "$repo/.agents/context/STACK.md"; do
    if [ -f "$file" ]; then
      summary="$(sed -n '1,20p' "$file" | sed -E '/^[[:space:]]*$/d; /^#/d' | head -n1)"
      [ -n "$summary" ] && break
    fi
  done
  if [ -z "$summary" ]; then
    case "$module" in
      theme) summary="base storefront theme repository" ;;
      sub-theme) summary="project-specific storefront theme customizations" ;;
      plugin) summary="custom plugin and business logic repository" ;;
      shop) summary="integration/runtime repository" ;;
      frontend) summary="frontend application repository" ;;
      backend) summary="backend application repository" ;;
      api) summary="API/backend service repository" ;;
      *) summary="related project repository" ;;
    esac
  fi
  printf '%s' "$summary" | tr '\r\n' ' ' | sed 's/[[:space:]]\+/ /g' | cut -c1-180
}

emit_repo_line() {
  local repo="$1"
  local name="$2"
  local module="$3"

  local branch_info="no-git"
  if git -C "$repo" rev-parse --git-dir >/dev/null 2>&1; then
    local branch dirty state
    branch="$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)"
    dirty="$(git -C "$repo" status --porcelain -uno 2>/dev/null | head -n1)"
    state="clean"
    [ -n "$dirty" ] && state="dirty"
    branch_info="branch=${branch:-unknown},${state}"
  fi
  local marker=""
  [ "$name" = "$REPO_NAME" ] && marker=" (current)"
  printf -- "- %s%s [%s, %s]\n" "$name" "$marker" "${module:-unknown}" "$branch_info"
  printf "  context: %s\n" "$(repo_summary "$repo" "$module")"
}

emit_repo() {
  local repo="$1"
  local name="${2:-$(basename "$repo")}"
  local module="${3:-unknown}"
  emit_repo_line "$repo" "$name" "$module"
}

# 1) Explicit repo-group map (recommended, works for any naming convention).
GROUP_FILE="$PROJECT_DIR/.agents/context/repo-group.json"
if [ -f "$GROUP_FILE" ] && command -v jq >/dev/null 2>&1; then
  GROUP_NAME="$(jq -r '.group // "workspace"' "$GROUP_FILE" 2>/dev/null)"
  ENTRY_COUNT="$(jq -r '.repos | length' "$GROUP_FILE" 2>/dev/null)"
  case "$ENTRY_COUNT" in
    ''|null|*[!0-9]*) ENTRY_COUNT=0 ;;
  esac
  if [ "$ENTRY_COUNT" -gt 0 ]; then
    printed=0
    echo "=== Cross-Repo Context (group: ${GROUP_NAME}) ==="
    while IFS= read -r entry; do
      rel_path="$(printf '%s' "$entry" | jq -r '.path // empty')"
      [ -n "$rel_path" ] || continue
      if [[ "$rel_path" = /* ]]; then
        abs_path="$rel_path"
      else
        abs_path="$(cd "$PROJECT_DIR" 2>/dev/null && cd "$rel_path" 2>/dev/null && pwd)" || continue
      fi
      [ -n "$abs_path" ] || continue
      [ -d "$abs_path" ] || continue
      name="$(printf '%s' "$entry" | jq -r '.name // empty')"
      module="$(printf '%s' "$entry" | jq -r '.module // empty')"
      emit_repo "$abs_path" "$name" "$module"
      printed=$((printed + 1))
    done < <(jq -c '.repos[]?' "$GROUP_FILE" 2>/dev/null)
    [ "$printed" -gt 1 ] && exit 0
    # If map exists but resolves to <=1 repo, silently continue to fallback.
  fi
fi

# 2) Fallback: Shopware suite naming like sw-theme-acme, sw-plugin-acme, ...
if [[ ! "$REPO_NAME" =~ ^sw-([a-z0-9-]+)-([a-z0-9]+)$ ]]; then
  exit 0
fi
SUITE_ID="${BASH_REMATCH[2]}"
PARENT_DIR="$(cd "$PROJECT_DIR/.." 2>/dev/null && pwd)"
[ -n "$PARENT_DIR" ] || exit 0

repos=()
while IFS= read -r repo_path; do
  repos+=("$repo_path")
done < <(find "$PARENT_DIR" -maxdepth 1 -mindepth 1 -type d -name "sw-*-${SUITE_ID}" | sort)

# If no sibling repos found, skip noise.
[ "${#repos[@]}" -gt 1 ] || exit 0

echo "=== Cross-Repo Context (suite: ${SUITE_ID}) ==="

for repo in "${repos[@]}"; do
  name="$(basename "$repo")"
  module="unknown"
  if [[ "$name" =~ ^sw-([a-z0-9-]+)-([a-z0-9]+)$ ]]; then
    module="${BASH_REMATCH[1]}"
  fi
  emit_repo "$repo" "$name" "$module"
done

exit 0
````

## File: templates/claude/hooks/notify.sh
````bash
#!/bin/bash
# Cross-platform notification hook for Claude Code
# Supports: macOS (osascript), Linux (notify-send), silent fallback
# Claude Code passes notification data via stdin as JSON:
# {"message": "Task complete", "title": "Claude Code", "level": "info"}

# Read stdin payload
PAYLOAD=$(cat /dev/stdin 2>/dev/null || echo "{}")

MSG=""
TTL=""
if command -v jq >/dev/null 2>&1; then
  MSG=$(echo "$PAYLOAD" | jq -r '.message // empty' 2>/dev/null)
  TTL=$(echo "$PAYLOAD" | jq -r '.title // empty' 2>/dev/null)
fi

TITLE="${TTL:-Claude Code}"
MESSAGE="${MSG:-Claude Code is ready}"

case "$(uname -s)" in
  Darwin)
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null || true
    ;;
  Linux)
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "$TITLE" "$MESSAGE" 2>/dev/null || true
    fi
    ;;
  *)
    # Silent fallback for unsupported platforms
    ;;
esac
````

## File: templates/claude/hooks/protect-files.sh
````bash
#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED=(".env" "package-lock.json" "pnpm-lock.yaml" "yarn.lock" "bun.lockb" "composer.lock" ".git/")

for pattern in "${PROTECTED[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH is protected ('$pattern')" >&2
    exit 2
  fi
done

# Block direct edits to assets/ in Vite-based projects (build output)
if [[ "$FILE_PATH" == */assets/* ]]; then
  for cfg in vite.config.js vite.config.ts vite.config.mjs vite.config.mts; do
    if [ -f "$cfg" ]; then
      echo "Blocked: $FILE_PATH is in assets/ (build output — edit src/ instead)" >&2
      exit 2
    fi
  done
fi

exit 0
````

## File: templates/claude/hooks/update-check.sh
````bash
#!/bin/bash
# SessionStart/UserPromptSubmit hook: update check + circuit breaker reset
# Fast path runs from cache; network lookup is backgrounded.

# Auto-reset circuit breaker — user sending a message = they've acknowledged the loop
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
PROJ_HASH=$(echo "$PROJECT_ROOT" | shasum | cut -c1-8)
CB_LOG="/tmp/claude-cb-${PROJ_HASH}.log"
[ -f "$CB_LOG" ] && rm -f "$CB_LOG"

SETUP_JSON="$PROJECT_ROOT/.ai-setup.json"
[ ! -f "$SETUP_JSON" ] && exit 0

INSTALLED=$(jq -r '.version // empty' "$SETUP_JSON" 2>/dev/null | sed 's/^v//' | tr -d '[:space:]')
[ -z "$INSTALLED" ] && exit 0

# Cache per project (24h TTL)
CACHE="/tmp/ai-setup-update-$(echo "$PROJECT_ROOT" | cksum | cut -d' ' -f1).txt"

if [ -f "$CACHE" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    AGE=$(( $(date +%s) - $(stat -f %m "$CACHE") ))
  else
    AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
  fi

  if [ "$AGE" -lt 86400 ]; then
    LATEST=$(tr -d '[:space:]' < "$CACHE" | sed 's/^v//')
    if [ -n "$LATEST" ] && [ "$LATEST" != "$INSTALLED" ]; then
      # Semver compare: only notify if registry version is strictly newer
      _gt=0
      IFS=. read -ra _a <<< "$LATEST"
      IFS=. read -ra _b <<< "$INSTALLED"
      for _i in 0 1 2; do
        [ "${_a[$_i]:-0}" -gt "${_b[$_i]:-0}" ] 2>/dev/null && _gt=1 && break
        [ "${_a[$_i]:-0}" -lt "${_b[$_i]:-0}" ] 2>/dev/null && break
      done
      [ "$_gt" -eq 1 ] && echo "ai-setup v${LATEST} available (you have v${INSTALLED}). Run: npx github:onedot-digital-crew/npx-ai-setup"
    fi
    exit 0
  fi
fi

# Stale or no cache — background fetch
(
  LATEST=""

  # Preferred when package is published on npm.
  if command -v npm >/dev/null 2>&1; then
    LATEST=$(npm view @onedot/ai-setup version 2>/dev/null | head -n1 | tr -d '[:space:]' | sed 's/^v//')
  fi

  # Fallback for GitHub-only installs.
  if [ -z "$LATEST" ] && command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    LATEST=$(curl -fsSL --max-time 5 "https://api.github.com/repos/onedot-digital-crew/npx-ai-setup/releases/latest" 2>/dev/null \
      | jq -r '.tag_name // empty' \
      | head -n1 \
      | tr -d '[:space:]' \
      | sed 's/^v//')
  fi

  # Fallback if there is no release yet.
  if [ -z "$LATEST" ] && command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    LATEST=$(curl -fsSL --max-time 5 "https://api.github.com/repos/onedot-digital-crew/npx-ai-setup/tags?per_page=1" 2>/dev/null \
      | jq -r '.[0].name // empty' \
      | head -n1 \
      | tr -d '[:space:]' \
      | sed 's/^v//')
  fi

  [ -n "$LATEST" ] && printf '%s\n' "$LATEST" > "$CACHE"
) &
exit 0
````

## File: templates/commands/context-full.md
````markdown
---
model: sonnet
allowed-tools: Bash, Read
---

Generates a compressed full-codebase snapshot via repomix. Use before large refactors or architecture reviews.

## Steps

1. **Run repomix** with tree-sitter compression:

```bash
_t=""; command -v timeout &>/dev/null && _t="timeout 120"; command -v gtimeout &>/dev/null && _t="gtimeout 120"
$_t npx -y repomix --compress --style markdown \
  --ignore "node_modules,dist,.git,.next,.nuxt,coverage,.turbo,*.lock,*.lockb" \
  --output .agents/repomix-snapshot.md
```

If repomix fails (not available, permission error), report the error and stop.

2. **Report token count**: After completion, run:

```bash
wc -l .agents/repomix-snapshot.md
```

Report: "Snapshot written to `.agents/repomix-snapshot.md` — [N] lines."

3. **Read the snapshot** and give a 3-5 sentence summary of what the codebase contains: key modules, entry points, notable patterns.

## Rules

- Do NOT read every file manually — repomix handles the aggregation.
- Do NOT commit `.agents/repomix-snapshot.md` — it is gitignored.
- The snapshot is a read-only artifact. Do not modify it.
- If `.agents/repomix-snapshot.md` already exists and is less than 30 minutes old (check mtime), skip re-generation and report "Using cached snapshot."
````

## File: templates/commands/grill.md
````markdown
---
model: opus
mode: plan
allowed-tools: Read, Glob, Grep, Bash
---

Runs an adversarial code review blocking approval until all issues are resolved. Use before merging high-risk changes.

## Step 0: Scope Challenge

Before reading any code, challenge the scope of this review.

1. **Does this already exist?** Run Grep to search for similar functions, patterns, or logic already present in the codebase. If the change duplicates existing code, flag it immediately.
2. **Is this the minimum viable change?** Consider whether a smaller diff would solve the problem equally well.

Present the following three paths using AskUserQuestion:

```
A) Scope reduction — you identify a smaller version of this change and suggest it before proceeding
B) Full adversarial review — continue with the complete grill (all steps below)
C) Compressed review — quick pass, report top 3 issues only, no deep dive
```

Wait for the user's choice before proceeding. If A is chosen, suggest the smaller scope and stop. If C is chosen, skip to the issue list and report only the three most critical findings.

## Process

1. Run `git diff main...HEAD` (or `git diff` if on main) to identify all changes under review.
2. Read every changed file **completely** — not just the diff, the full file for context.
3. **What already exists** — Before flagging any issue, run Grep to find similar functions, patterns, or logic already present in the codebase. Document what was found. Do not flag existing patterns as new problems.
4. Act as a senior engineer who does NOT want to ship this. Challenge everything:
   - **Edge cases**: What happens with empty input, null, zero, max values, concurrent access?
   - **Error handling**: Are all error paths covered? Can errors propagate silently?
   - **Security**: Any injection, auth bypass, data exposure, SSRF, or path traversal?
   - **Race conditions**: Any shared state, async operations without proper synchronization?
   - **Missing validation**: Are inputs validated at system boundaries?
   - **Breaking changes**: Does this break any existing API, behavior, or contract?
   - **Data integrity**: Any risk of data loss, corruption, or inconsistency?
5. List every issue found. For each issue:
   - Severity: CRITICAL / HIGH / MEDIUM
   - File and line number
   - What could go wrong (concrete scenario, not theoretical)
   - Present resolution options in A/B/C format:

     ```
     **Option A** — [approach]: [tradeoff]
     **Option B** — [approach]: [tradeoff]
     **Option C** — [approach]: [tradeoff]
     -> Recommended: Option [X] because [reason]
     ```

   For each CRITICAL or HIGH issue, use AskUserQuestion to let the user choose which option to apply before continuing to the next issue.

6. **NOT reviewed** — At the end of the output, explicitly list what was out of scope for this review. Common exclusions: generated files in `dist/` or `.output/`, `node_modules/`, test fixtures, lock files (`package-lock.json`, `yarn.lock`), binary assets.
7. Verdict: BLOCK (has critical/high issues) or PASS (only medium or no issues).
8. **Self-verification table** — As the final step, double-check every single claim made in this review. Create a markdown table with the following columns:

   | Claim | File:Line | Verified |
   |-------|-----------|----------|
   | [each finding summarized in one line] | [exact file and line] | yes / no / partial |

   Every finding from step 5 must appear in this table. If a claim cannot be verified against an exact file and line, mark it as `no` and remove it from the blocking issues list.

## Rules
- Do NOT approve by default. The bar is: "Would I bet production uptime on this?"
- Do NOT make changes. Only report. The author fixes.
- Read the full file, not just the diff — bugs hide in context.
- Ignore style, formatting, and naming preferences — focus on correctness.
````

## File: templates/commands/spec-board.md
````markdown
---
model: haiku
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
````

## File: templates/commands/test.md
````markdown
---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Runs the project test suite and fixes failures in source code. Use when tests are failing or before submitting changes.

## Process

1. **Detect test command**: Check `package.json` scripts for `test`, `test:unit`, `vitest`, or `jest`. If none found, check for `vitest.config.*` or `jest.config.*` files.
2. **Run tests**: Execute the detected test command.
3. **If all pass**: Report success and stop.
4. **If failures**: For each failing test:
   - Read the failing test file to understand what it expects
   - Read the source file being tested
   - Fix the **source code** (not the tests) to make tests pass
   - Re-run tests
5. **Repeat** with explicit attempt tracking:
   - **Attempt 1**: Apply fixes, re-run tests. If all pass: report success and stop.
   - **Attempt 2**: If still failing, read new error output, apply further fixes, re-run tests. If all pass: report success and stop.
   - **Attempt 3**: If still failing, apply one final round of fixes, re-run tests. If all pass: report success and stop.
6. If still failing after Attempt 3, report what was tried in each attempt and what remains broken.

## Rules
- Fix source code, not tests (unless the test itself has a clear bug).
- Do not delete or skip failing tests.
- Do not install new dependencies without asking.
- If no test framework is detected, tell the user and stop.
````

## File: templates/commands/update.md
````markdown
---
name: update
description: Check for ai-setup updates and install from within Claude Code
allowed-tools:
  - Bash
  - AskUserQuestion
  - Read
---

Check for ai-setup updates, show what changed, and install if the user confirms.

## Process

### Step 1: Detect installed version

```bash
jq -r '.version // empty' "${CLAUDE_PROJECT_DIR:-.}/.ai-setup.json" 2>/dev/null || echo ""
```

If no `.ai-setup.json` exists, tell the user ai-setup is not installed in this project and suggest running `npx github:onedot-digital-crew/npx-ai-setup`.

### Step 2: Check latest version

Try npm first, fall back to GitHub API:

```bash
npm view @onedot/ai-setup version 2>/dev/null || curl -fsSL --max-time 5 "https://api.github.com/repos/onedot-digital-crew/npx-ai-setup/releases/latest" 2>/dev/null | jq -r '.tag_name // empty' | sed 's/^v//'
```

If both fail, tell the user to check their network connection.

### Step 3: Compare versions

Parse both versions as semver (major.minor.patch). Only proceed if latest > installed.

- If **same version**: "Already up to date (vX.Y.Z)." — stop.
- If **installed > latest**: "You're ahead of the latest release (dev version?)." — stop.
- If **latest > installed**: continue to step 4.

### Step 4: Fetch changelog

```bash
curl -fsSL --max-time 5 "https://raw.githubusercontent.com/onedot-digital-crew/npx-ai-setup/main/CHANGELOG.md" 2>/dev/null | head -80
```

Extract entries between installed and latest version. If no CHANGELOG.md exists, skip this step.

### Step 5: Show update summary and confirm
Show:
```
## ai-setup Update Available

**Installed:** vX.Y.Z
**Latest:**    vA.B.C

### What's New
(changelog entries if available)

Will review customized templates, optionally regenerate AI context, and back up modified files.
```
Use AskUserQuestion: "Proceed with update?" Options: "Yes, update now" / "No, cancel"
If user cancels, stop.

### Step 6: Run update

```bash
npx github:onedot-digital-crew/npx-ai-setup
```

This launches the interactive update flow.

### Step 7: Clear update cache

```bash
rm -f /tmp/ai-setup-update-*.txt /tmp/ai-setup-cli-latest-version.txt
```

### Step 8: Display result
```
ai-setup updated: vX.Y.Z -> vA.B.C
Restart Claude Code to pick up new hooks and settings.
```
````

## File: templates/github/workflows/release-from-changelog.yml
````yaml
name: Release From Changelog

on:
  push:
    tags:
      - "v*"
  create:
  workflow_dispatch:
    inputs:
      tag:
        description: "Release tag (e.g. v1.2.5)"
        required: true
        type: string

permissions:
  contents: write

jobs:
  release:
    if: ${{ github.event_name != 'create' || (github.event.ref_type == 'tag' && startsWith(github.event.ref, 'v')) }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Resolve tag
        id: vars
        run: |
          if [ "${{ github.event_name }}" = "workflow_dispatch" ]; then
            TAG="${{ inputs.tag }}"
          elif [ "${{ github.event_name }}" = "create" ]; then
            TAG="${{ github.event.ref }}"
          else
            TAG="${GITHUB_REF_NAME}"
          fi

          if [ -z "$TAG" ]; then
            echo "Tag could not be resolved."
            exit 1
          fi

          echo "tag=$TAG" >> "$GITHUB_OUTPUT"
          echo "Using tag: $TAG"

      - name: Extract changelog section
        run: |
          TAG="${{ steps.vars.outputs.tag }}"
          HEADING="## [$TAG]"

          if [ ! -f CHANGELOG.md ]; then
            echo "CHANGELOG.md not found."
            exit 1
          fi

          if ! grep -Fq "$HEADING" CHANGELOG.md; then
            echo "No changelog section found for $TAG (expected heading: $HEADING)."
            exit 1
          fi

          awk -v heading="$HEADING" '
            {
              if (in_section && $0 ~ "^## \\[" && index($0, heading) != 1) exit
              if (index($0, heading) == 1) in_section=1
              if (in_section) print
            }
          ' CHANGELOG.md > release_notes.md

          if [ ! -s release_notes.md ]; then
            echo "Extracted release notes are empty for $TAG."
            exit 1
          fi

          echo "Release notes extracted:"
          sed -n '1,120p' release_notes.md

      - name: Create or update GitHub release
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          TAG="${{ steps.vars.outputs.tag }}"

          if gh release view "$TAG" >/dev/null 2>&1; then
            gh release edit "$TAG" --title "$TAG" --notes-file release_notes.md
            echo "Updated release $TAG"
          else
            gh release create "$TAG" --title "$TAG" --notes-file release_notes.md
            echo "Created release $TAG"
          fi
````

## File: .gitignore
````
node_modules/
.DS_Store

# Claude Code / AI Setup
.claude/settings.local.json
.ai-setup.json
.ai-setup-backup/
.agents/context/.state
.agents/repomix-snapshot.md

.idea
.claude/worktrees/
CLAUDE.local.md
````

## File: templates/agents/context-refresher.md
````markdown
---
name: context-refresher
description: Regenerates .agents/context/ files (STACK.md, ARCHITECTURE.md, CONVENTIONS.md) when project config has changed.
tools: Read, Write, Glob, Bash
model: haiku
max_turns: 15
---

You are a context generation agent. Your job is to analyze the project and write accurate context files to `.agents/context/`.

## Behavior

1. **Gather project info**: Read `package.json`, `README.md` (if exists), `tsconfig.json`, `.eslintrc*`, `prettierrc*` (if they exist). Run `ls -la` and scan the top-level directory structure.
2. **Sample source files**: Read 3-5 representative source files to understand conventions and architecture.
3. **Write exactly 3 files**:

**`.agents/context/STACK.md`** — runtime, framework (with versions), key dependencies (categorized: UI, state, data, testing, build), package manager, build tooling, libraries/patterns to avoid.

**`.agents/context/ARCHITECTURE.md`** — project type, directory structure, entry points, data flow, key patterns, how the pieces connect.

**`.agents/context/CONVENTIONS.md`** — naming patterns, import style, component structure, error handling, TypeScript usage, testing patterns. Be specific — actual patterns found in code, not generic advice.

4. **Update state file**: After writing the 3 files, run:
```bash
echo "PKG_HASH=$(cksum package.json 2>/dev/null | cut -d' ' -f1,2)" > .agents/context/.state
echo "TSCONFIG_HASH=$(cksum tsconfig.json 2>/dev/null | cut -d' ' -f1,2)" >> .agents/context/.state
```

5. **Generate repomix snapshot** (optional, best-effort): Run:
```bash
_t=""; command -v timeout &>/dev/null && _t="timeout 120"; command -v gtimeout &>/dev/null && _t="gtimeout 120"
if [ -f "repomix.config.json" ]; then
  $_t npx -y repomix 2>/dev/null
else
  $_t npx -y repomix --compress --style markdown \
    --ignore "node_modules,dist,.git,.next,.nuxt,coverage,.turbo,*.lock,*.lockb" \
    --output .agents/repomix-snapshot.md 2>/dev/null
fi
```
If this fails or times out, skip silently — the 3 context files are the primary output.

## Rules
- Keep each file under 80 lines — terse and factual, no padding.
- Write only what you observed, not what you assumed.
- Overwrite existing files completely — do not append.
- Do NOT read `.env` files.
- The repomix snapshot is optional — never block or fail because of it.
````

## File: templates/claude/hooks/context-monitor.sh
````bash
#!/bin/bash
# context-monitor.sh — PostToolUse hook
# Warns when context window is approaching exhaustion by reading bridge file
# written by statusline.sh on every render.
#
# Outputs additionalContext JSON at <=35% remaining (WARNING) and <=25% (CRITICAL).
# Debounces via a counter file — 5 tool calls between warnings at same severity.
# Severity escalation (WARNING -> CRITICAL) bypasses debounce.
# Silent exit 0 when bridge file missing, stale (>60s), or jq unavailable.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""' 2>/dev/null)
SESSION_ID=$(echo "$SESSION_ID" | tr -cd 'a-zA-Z0-9_-')
[ -z "$SESSION_ID" ] && exit 0

BRIDGE_FILE="/tmp/claude-ctx-${SESSION_ID}.json"
[ -f "$BRIDGE_FILE" ] || exit 0

# Read bridge file
BRIDGE=$(cat "$BRIDGE_FILE" 2>/dev/null) || exit 0
[ -z "$BRIDGE" ] && exit 0

# Check staleness (>60s old = ignore)
TS=$(echo "$BRIDGE" | jq -r '.timestamp // 0' 2>/dev/null)
case "$TS" in ''|null|*[!0-9]*) TS=0 ;; esac
NOW=$(date +%s)
AGE=$(( NOW - TS ))
[ "$AGE" -gt 60 ] && exit 0

REMAINING=$(echo "$BRIDGE" | jq -r '.remaining_percentage // 100' 2>/dev/null)
case "$REMAINING" in ''|null|*[!0-9]*) exit 0 ;; esac

# Determine severity
SEVERITY=""
if [ "$REMAINING" -le 25 ]; then
  SEVERITY="CRITICAL"
elif [ "$REMAINING" -le 35 ]; then
  SEVERITY="WARNING"
fi

[ -z "$SEVERITY" ] && exit 0

# Debounce: track call counter and last severity
COUNTER_FILE="/tmp/claude-ctx-warn-${SESSION_ID}"
COUNTER=0
LAST_SEVERITY=""
if [ -f "$COUNTER_FILE" ]; then
  COUNTER=$(head -1 "$COUNTER_FILE" 2>/dev/null || echo 0)
  LAST_SEVERITY=$(tail -1 "$COUNTER_FILE" 2>/dev/null || echo "")
  case "$COUNTER" in ''|null|*[!0-9]*) COUNTER=0 ;; esac
fi

COUNTER=$(( COUNTER + 1 ))

# Bypass debounce on severity escalation (WARNING -> CRITICAL)
ESCALATED=false
if [ "$SEVERITY" = "CRITICAL" ] && [ "$LAST_SEVERITY" = "WARNING" ]; then
  ESCALATED=true
fi

# Suppress if under debounce threshold (5 calls between warnings) and no escalation
if [ "$COUNTER" -lt 6 ] && [ "$ESCALATED" = "false" ] && [ "$LAST_SEVERITY" = "$SEVERITY" ]; then
  printf '%s\n%s\n' "$COUNTER" "$SEVERITY" > "$COUNTER_FILE" 2>/dev/null || true
  exit 0
fi

# Reset counter and write state
printf '%s\n%s\n' "0" "$SEVERITY" > "$COUNTER_FILE" 2>/dev/null || true

# Build message
if [ "$SEVERITY" = "CRITICAL" ]; then
  MESSAGE="CRITICAL: Context window at ${REMAINING}% remaining. Compaction is imminent. Consider saving state to HANDOFF.md. Wrapping up should begin before context is truncated."
else
  MESSAGE="WARNING: Context window at ${REMAINING}% remaining. Context compaction will fire at 30%. Consider saving state to HANDOFF.md soon."
fi

# Output additionalContext JSON to stdout (via jq for safe escaping)
jq -n --arg msg "$MESSAGE" '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":$msg}}'

exit 0
````

## File: templates/commands/analyze.md
````markdown
---
model: sonnet
allowed-tools: Read, Glob, Grep, Bash, Agent
---

Produces a structured codebase overview via 3 parallel agents. Use when exploring or preparing for major changes.

## Process

### 1. Launch 3 agents simultaneously

Spawn all three agents at the same time using the Agent tool in parallel:

**Agent 1 — Architecture**

```
You are an Architecture exploration agent. Analyze this codebase and report:

1. Read `.agents/context/ARCHITECTURE.md` if it exists — use it as the starting point.
2. Identify entry points (main files, index files, CLI entrypoints, server bootstraps).
3. Trace the primary data flow from input to output.
4. Map module/package boundaries and their responsibilities.
5. Identify key abstractions (base classes, interfaces, core utilities, shared types).
6. Note the directory structure and what lives where.

Return a concise report under the heading: ## Architecture
Include sub-sections: Entry Points, Data Flow, Module Boundaries, Key Abstractions.
Keep it factual and dense — no padding.
```

**Agent 2 — Hotspots**

```
You are a Hotspots exploration agent. Find the most active and complex areas of this codebase:

1. Run: git log --format="%f" | sort | uniq -c | sort -rn | head -20
   List the top 20 most-changed files with their change counts.
2. Find the 10 largest files by line count (use: find . -name "*.{js,ts,py,rb,go,sh}" -not -path "*/node_modules/*" -not -path "*/.git/*" | xargs wc -l 2>/dev/null | sort -rn | head -15).
3. Identify complex areas: deeply nested functions, files with many responsibilities, long functions.
4. Note any files that appear in both "most changed" and "largest" — these are highest-risk hotspots.

Return a concise report under the heading: ## Hotspots
Include sub-sections: Most Changed Files, Largest Files, Complexity Areas.
```

**Agent 3 — Risks**

```
You are a Risk exploration agent. Find quality issues and risk areas in this codebase:

1. Search for TODO/FIXME/HACK/XXX comments: grep -rn "TODO\|FIXME\|HACK\|XXX" --include="*.{js,ts,py,rb,go,sh,md}" --exclude-dir={node_modules,.git,dist,build} . 2>/dev/null | head -40
2. Look for dead code patterns: exported symbols never imported, commented-out code blocks.
3. Check for missing error handling: unhandled promise rejections, bare catch blocks, unchecked return values.
4. Identify inconsistent naming: mixed camelCase/snake_case, inconsistent file naming conventions.
5. Note any security-adjacent patterns: hardcoded strings that look like credentials, unvalidated inputs.

Return a concise report under the heading: ## Risks
Include sub-sections: TODOs/FIXMEs, Dead Code, Error Handling Gaps, Naming Inconsistencies.
```

### 2. Synthesize results

After all 3 agents return, combine their output into a single structured report:

```
## Architecture
[Agent 1 output]

## Hotspots
[Agent 2 output]

## Risks
[Agent 3 output]

## Recommendations
[Derive 3-5 actionable recommendations based on the findings above:
 - Address the highest-risk hotspots first
 - Resolve critical TODOs/FIXMEs
 - Fix missing error handling in high-traffic code paths
 - Standardize naming where inconsistencies were found
 - Any architectural improvements suggested by the data flow analysis]
```

## Rules

- Launch all 3 agents simultaneously — do not wait for one before starting the next.
- Each agent works independently — no shared state between them.
- The report is output only — do not write it to a file unless the user asks.
- Keep each section dense and factual; omit padding and filler phrases.
- If a command fails (e.g. git not available), note it and continue with available data.
````

## File: templates/commands/reflect.md
````markdown
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

Read `CLAUDE.md`, `.agents/context/CONVENTIONS.md`, `.agents/context/ARCHITECTURE.md`, and `.agents/context/STACK.md` first to avoid duplicates.

For each signal, draft a rule or fact addition:
- Maximum 1-2 lines per entry
- Corrections/affirmations: phrase as a directive ("Always X", "Never Y", "Use X instead of Y")
- Architectural findings: phrase as a factual statement ("Component X depends on Y", "All API calls route through Z")
- Stack findings: phrase as a factual statement ("Requires Node >= 18", "Uses pnpm as package manager")
- Do NOT duplicate content already present in the target file

If no actionable signals were found in this session, report that clearly and stop.

### 4. Show proposed changes for approval
Use AskUserQuestion to present the proposed additions and ask for approval before writing anything.
Format the proposal as a diff preview showing exactly what will be appended to each file.
Example:
```
Proposed additions from this session:

File: .agents/context/CONVENTIONS.md
+ Always use kebab-case for script filenames

File: CLAUDE.md (Critical Rules)
+ Never modify template files directly — use generation logic instead

Apply the same format for `.agents/context/ARCHITECTURE.md` and `.agents/context/STACK.md` when needed.

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
````

## File: AGENTS.md
````markdown
# AGENTS.md

## Purpose
Universal passive context for AGENTS.md-compatible tools (Cursor, Windsurf, Cline, and others).
Read this file before making multi-file edits, architectural changes, or release-impacting updates.

## Project Overview
<!-- Auto-Init populates this -->

## Project Context
For detailed project context, read:
- `.agents/context/STACK.md` - runtime, frameworks, key dependencies, and toolchain
- `.agents/context/ARCHITECTURE.md` - structure, entry points, boundaries, and data flow
- `.agents/context/CONVENTIONS.md` - coding conventions, testing patterns, and Definition of Done

If these files are missing or stale, regenerate with:
`npx @onedot/ai-setup --regenerate`

## Architecture Summary
<!-- Auto-Init populates this -->

## Commands
<!-- Auto-Init populates this -->

## Code Style Guidelines
- Follow existing lint and formatter config; do not introduce conflicting style rules.
- Prefer small, focused changes with clear intent and minimal side effects.
- Keep naming, folder structure, and abstraction patterns consistent with neighboring code.
- Add or update tests for behavior changes when a test framework is available.
- Avoid new dependencies unless there is a clear net benefit.

## Critical Rules
<!-- Auto-Init populates this -->

## Verification
- Run relevant lint, test, and build commands before marking work complete.
- Validate integrations affected by your changes (API calls, UI flows, background jobs).
- Summarize what was verified and the result.
````

## File: templates/commands/review.md
````markdown
---
model: opus
mode: plan
allowed-tools: Read, Glob, Grep, Bash
---

Reviews uncommitted changes and reports bugs, security issues, and improvements. Use before committing to catch issues.

## Context

- Current branch: `!git rev-parse --abbrev-ref HEAD`
- Unstaged changes: `!git diff`
- Staged changes: `!git diff --staged`
- Branch diff vs main: `!git diff main...HEAD 2>/dev/null`

## Process

1. Analyze all changes shown in Context above. If all diffs are empty, report "No changes found." and stop.
2. For each changed file, read the full file to understand context around the changes.
3. **What already exists** — Before reporting any finding, run one Grep pass across the codebase to check for similar functions, patterns, or logic. If duplicated logic is detected, note it explicitly: "Similar pattern already exists at [file:line] — verify this is intentional and not a copy-paste." Do not flag existing patterns as new problems.
4. Analyze each change for:
   - **Bugs**: Logic errors, off-by-one, null/undefined, race conditions
   - **Security**: Injection, XSS, secrets exposure, OWASP top 10
   - **Performance**: N+1 queries, unnecessary re-renders, memory leaks
   - **Readability**: Unclear names, missing context, overly complex logic
   - **Missing tests**: Changed logic without test coverage
5. Report findings with confidence levels (HIGH / MEDIUM / LOW).
6. Only report HIGH and MEDIUM confidence issues — skip stylistic preferences.

## Rules
- Do NOT make any changes. Only report findings.
- Read the actual code before commenting — never speculate.
- Focus on what matters: bugs and security over style.
- If no issues found, say so clearly.
````

## File: templates/commands/techdebt.md
````markdown
---
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

Scans recently changed files for tech debt and fixes safe wins. Use at end of session to clean up before committing.

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

5. **Verify fixes**: Spawn `verify-app` via Agent tool with the prompt:
   > "Run the project's test suite and build command. Report PASS or FAIL with details."
   - If **PASS**: report what was cleaned up and stop.
   - If **FAIL**: read the error output, fix only the regressions caused by the debt cleanup (do not introduce new changes), then re-run verify-app.
   - Retry up to **2 times**. If still failing after 2 retries: revert the last change (`git checkout -- <file>`), report the failure, and stop.

## Rules
- Only scan recently changed files — not the entire codebase.
- Fix only clear, safe wins. Do not refactor working code.
- Do not change public APIs or behavior.
- Report but do not fix anything you're unsure about.
````

## File: lib/tui.sh
````bash
#!/bin/bash
# Interactive TUI menus: system selection, regeneration parts, update parts
# Sets: $SYSTEM, $REGEN_*, $UPD_*

# System/framework selection menu (multiselect with arrow-key navigation)
select_system() {
  local options=("auto" "shopify" "nuxt" "next" "laravel" "shopware" "storyblok")
  local descriptions=("Claude detects automatically" "Shopify Theme" "Nuxt 4 / Vue" "Next.js / React" "Laravel / PHP" "Shopware 6" "Storyblok CMS")
  local selected=0
  local count=${#options[@]}
  local -a checked=()

  # Initialize all as unchecked
  for ((i=0; i<count; i++)); do
    checked[$i]=0
  done

  echo ""
  echo "Which system/framework does this project use?"
  echo "  (Use ↑↓ arrows, Space to toggle, Enter to confirm)"
  echo ""

  # Hide cursor
  printf '\033[?25l'
  # Restore cursor on exit
  trap 'printf "\033[?25h"' RETURN 2>/dev/null || true

  # Print initial menu
  for ((i=0; i<count; i++)); do
    local checkbox="[ ]"
    [ "${checked[$i]}" -eq 1 ] && checkbox="[✓]"

    if [ $i -eq $selected ]; then
      printf '  \033[7m ▸ %s %-12s %s \033[0m\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
    else
      printf '    %s %-12s %s\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
    fi
  done

  while true; do
    # Read a single keypress
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')  # Escape sequence (arrow keys)
        read -rsn2 seq
        case "$seq" in
          '[A') # Up
            selected=$(( (selected - 1 + count) % count ))
            ;;
          '[B') # Down
            selected=$(( (selected + 1) % count ))
            ;;
        esac
        ;;
      " ")  # Space - toggle selection
        if [ "${options[$selected]}" = "auto" ]; then
          # Auto is exclusive - uncheck all others
          for ((i=0; i<count; i++)); do
            checked[$i]=0
          done
          checked[$selected]=1
        else
          # Toggle current selection
          if [ "${checked[$selected]}" -eq 1 ]; then
            checked[$selected]=0
          else
            checked[$selected]=1
            # If any other is selected, uncheck "auto"
            checked[0]=0
          fi
        fi
        ;;
      "")  # Enter
        break
        ;;
    esac

    # Redraw menu (move cursor up)
    printf "\033[${count}A"
    for ((i=0; i<count; i++)); do
      local checkbox="[ ]"
      [ "${checked[$i]}" -eq 1 ] && checkbox="[✓]"

      if [ $i -eq $selected ]; then
        printf '  \033[7m ▸ %s %-12s %s \033[0m\033[K\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
      else
        printf '    %s %-12s %s\033[K\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
      fi
    done
  done

  # Show cursor
  printf '\033[?25h'

  # Build comma-separated list of selected systems
  local selected_systems=()
  for ((i=0; i<count; i++)); do
    if [ "${checked[$i]}" -eq 1 ]; then
      selected_systems+=("${options[$i]}")
    fi
  done

  # If nothing selected, default to auto
  if [ ${#selected_systems[@]} -eq 0 ]; then
    SYSTEM="auto"
  else
    SYSTEM=$(IFS=,; echo "${selected_systems[*]}")
  fi

  echo ""
  echo "  Selected: $SYSTEM"
}

# ==============================================================================
# REGENERATION PART SELECTOR
# ==============================================================================
# Sets REGEN_CLAUDE_MD, REGEN_AGENTS_MD, REGEN_CONTEXT, REGEN_COMMANDS,
# REGEN_AGENTS, REGEN_SKILLS globals.
# Returns 1 if the user selected nothing (skip).
ask_regen_parts() {
  # Arrow keys + Space to toggle + Enter to confirm (same style as select_system)
  local options=("CLAUDE.md" "AGENTS.md" "Context" "Commands" "Agents" "Skills")
  local descriptions=("Main instructions + project guardrails" "Agent workflow + role guidelines" ".agents/context/{STACK,ARCHITECTURE,CONVENTIONS}" ".claude/commands/ slash commands" ".claude/agents/ subagent templates" "External + bundled skills (.claude/skills)")
  local count=6
  local selected=0
  local checked=(1 1 1 1 1 1)  # all pre-selected

  echo ""
  echo "  Select what to regenerate:"
  echo "  (Use ↑↓ arrows, Space to toggle, Enter to confirm)"
  echo ""

  printf '\033[?25l'
  trap 'printf "\033[?25h"' RETURN 2>/dev/null || true

  for ((i=0; i<count; i++)); do
    local checkbox="[ ]"
    [ "${checked[$i]}" -eq 1 ] && checkbox="[✓]"
    if [ $i -eq $selected ]; then
      printf '  \033[7m ▸ %s %-12s %s \033[0m\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
    else
      printf '    %s %-12s %s\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
    fi
  done

  while true; do
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')
        read -rsn2 seq
        case "$seq" in
          '[A') selected=$(( (selected - 1 + count) % count )) ;;
          '[B') selected=$(( (selected + 1) % count )) ;;
        esac
        ;;
      " ")
        [ "${checked[$selected]}" -eq 1 ] && checked[$selected]=0 || checked[$selected]=1
        ;;
      "")
        break
        ;;
    esac

    printf "\033[${count}A"
    for ((i=0; i<count; i++)); do
      local checkbox="[ ]"
      [ "${checked[$i]}" -eq 1 ] && checkbox="[✓]"
      if [ $i -eq $selected ]; then
        printf '  \033[7m ▸ %s %-12s %s \033[0m\033[K\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
      else
        printf '    %s %-12s %s\033[K\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
      fi
    done
  done

  printf '\033[?25h'

  REGEN_CLAUDE_MD="no"; REGEN_AGENTS_MD="no"; REGEN_CONTEXT="no"; REGEN_COMMANDS="no"; REGEN_AGENTS="no"; REGEN_SKILLS="no"
  [ "${checked[0]}" -eq 1 ] && REGEN_CLAUDE_MD="yes"
  [ "${checked[1]}" -eq 1 ] && REGEN_AGENTS_MD="yes"
  [ "${checked[2]}" -eq 1 ] && REGEN_CONTEXT="yes"
  [ "${checked[3]}" -eq 1 ] && REGEN_COMMANDS="yes"
  [ "${checked[4]}" -eq 1 ] && REGEN_AGENTS="yes"
  [ "${checked[5]}" -eq 1 ] && REGEN_SKILLS="yes"

  if [ "$REGEN_CLAUDE_MD" = "no" ] && [ "$REGEN_AGENTS_MD" = "no" ] && [ "$REGEN_CONTEXT" = "no" ] && [ "$REGEN_COMMANDS" = "no" ] && [ "$REGEN_AGENTS" = "no" ] && [ "$REGEN_SKILLS" = "no" ]; then
    echo ""
    return 1
  fi
  return 0
}

# ==============================================================================
# UPDATE PART SELECTOR
# ==============================================================================
# Sets UPD_HOOKS, UPD_SETTINGS, UPD_CLAUDE_MD, UPD_AGENTS_MD, UPD_COMMANDS,
# UPD_AGENTS, UPD_OTHER globals.
# Returns 1 if the user selected nothing (skip template update).
ask_update_parts() {
  local options=("Hooks" "Settings" "CLAUDE.md" "AGENTS.md" "Commands" "Agents" "Other")
  local descriptions=(".claude/hooks + .claude/rules" ".claude/settings.json (permissions, hooks, env)" "Root CLAUDE.md template" "Root AGENTS.md template" ".claude/commands/ (spec, review, commit...)" ".claude/agents/ (reviewers, planners, validators...)" "specs/, .github/, misc templates")
  local count=7
  local selected=0
  local checked=(1 1 1 1 1 1 1)  # all pre-selected

  echo ""
  echo "  Select which categories to update:"
  echo "  (Use ↑↓ arrows, Space to toggle, Enter to confirm)"
  echo ""

  printf '\033[?25l'
  trap 'printf "\033[?25h"' RETURN 2>/dev/null || true

  for ((i=0; i<count; i++)); do
    local checkbox="[ ]"
    [ "${checked[$i]}" -eq 1 ] && checkbox="[✓]"
    if [ $i -eq $selected ]; then
      printf '  \033[7m ▸ %s %-12s %s \033[0m\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
    else
      printf '    %s %-12s %s\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
    fi
  done

  while true; do
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')
        read -rsn2 seq
        case "$seq" in
          '[A') selected=$(( (selected - 1 + count) % count )) ;;
          '[B') selected=$(( (selected + 1) % count )) ;;
        esac
        ;;
      " ")
        [ "${checked[$selected]}" -eq 1 ] && checked[$selected]=0 || checked[$selected]=1
        ;;
      "")
        break
        ;;
    esac

    printf "\033[${count}A"
    for ((i=0; i<count; i++)); do
      local checkbox="[ ]"
      [ "${checked[$i]}" -eq 1 ] && checkbox="[✓]"
      if [ $i -eq $selected ]; then
        printf '  \033[7m ▸ %s %-12s %s \033[0m\033[K\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
      else
        printf '    %s %-12s %s\033[K\n' "$checkbox" "${options[$i]}" "${descriptions[$i]}"
      fi
    done
  done

  printf '\033[?25h'

  UPD_HOOKS="no"; UPD_SETTINGS="no"; UPD_CLAUDE_MD="no"; UPD_AGENTS_MD="no"; UPD_COMMANDS="no"; UPD_AGENTS="no"; UPD_OTHER="no"
  [ "${checked[0]}" -eq 1 ] && UPD_HOOKS="yes"
  [ "${checked[1]}" -eq 1 ] && UPD_SETTINGS="yes"
  [ "${checked[2]}" -eq 1 ] && UPD_CLAUDE_MD="yes"
  [ "${checked[3]}" -eq 1 ] && UPD_AGENTS_MD="yes"
  [ "${checked[4]}" -eq 1 ] && UPD_COMMANDS="yes"
  [ "${checked[5]}" -eq 1 ] && UPD_AGENTS="yes"
  [ "${checked[6]}" -eq 1 ] && UPD_OTHER="yes"

  if [ "$UPD_HOOKS" = "no" ] && [ "$UPD_SETTINGS" = "no" ] && [ "$UPD_CLAUDE_MD" = "no" ] && [ "$UPD_AGENTS_MD" = "no" ] && [ "$UPD_COMMANDS" = "no" ] && [ "$UPD_AGENTS" = "no" ] && [ "$UPD_OTHER" = "no" ]; then
    echo ""
    return 1
  fi
  return 0
}

# ==============================================================================
# OVERWRITE CONFIRMATION
# ==============================================================================
# Prompts user to confirm overwriting a user-modified file.
# Returns 0 if user confirms overwrite, 1 to keep user's version.
ask_overwrite_modified() {
  local file="$1"
  printf "  ⚠️  %s (user-modified) — Overwrite with template? [y/N]: " "$file"
  local answer
  IFS= read -r answer </dev/tty
  case "$answer" in
    y|Y|yes|YES|Yes) return 0 ;;
    *)               return 1 ;;
  esac
}
````

## File: templates/claude/hooks/post-edit-lint.sh
````bash
#!/bin/bash
# Dead-loop prevention:
# Keep formatter/linter output suppressed unless there is a genuine syntax issue that
# must reach the model. Exposing normal lint output here can trigger repetitive
# self-correction loops on the same file.
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

# Ignore events without a concrete file (or deleted/moved files).
[ -n "$FILE_PATH" ] || exit 0
[ -f "$FILE_PATH" ] || exit 0

# Optional project formatter script.
# Try file-scoped format first; on failure, continue with per-file fallback below.
if [ -f "package.json" ] && jq -e '.scripts.format' package.json >/dev/null 2>&1; then
  if command -v bun >/dev/null 2>&1 && bun run format -- "$FILE_PATH" >/dev/null 2>&1; then
    exit 0
  fi
  if command -v npm >/dev/null 2>&1 && npm run -s format -- "$FILE_PATH" >/dev/null 2>&1; then
    exit 0
  fi
fi

# ESLint for JS/TS files
if [[ "$FILE_PATH" == *.js || "$FILE_PATH" == *.ts || "$FILE_PATH" == *.jsx || "$FILE_PATH" == *.tsx ]]; then
  if [ -x "node_modules/.bin/eslint" ]; then
    OUTPUT=$(./node_modules/.bin/eslint "$FILE_PATH" --fix 2>&1)
  else
    OUTPUT=$(npx eslint "$FILE_PATH" --fix 2>&1)
  fi
  # Silent by design: lint output must not be shown to Claude.

fi

# Validate JSON syntax for Shopify schema/config files
if [[ "$FILE_PATH" == */config/*.json || "$FILE_PATH" == */templates/*.json || "$FILE_PATH" == */locales/*.json ]]; then
  if command -v jq >/dev/null 2>&1; then
    if ! jq . "$FILE_PATH" >/dev/null 2>&1; then
      echo "JSON syntax error in $FILE_PATH" >&2
    fi
  fi
fi

# Prettier for other supported files (css, html, json, md, yaml, vue, svelte)
if [[ "$FILE_PATH" == *.css || "$FILE_PATH" == *.html || "$FILE_PATH" == *.json || "$FILE_PATH" == *.md || "$FILE_PATH" == *.yaml || "$FILE_PATH" == *.yml || "$FILE_PATH" == *.vue || "$FILE_PATH" == *.svelte ]]; then
  if [ -x "node_modules/.bin/prettier" ]; then
    ./node_modules/.bin/prettier --write "$FILE_PATH" 2>/dev/null
  fi
fi

exit 0
````

## File: templates/claude/hooks/README.md
````markdown
# Hook Configuration Guide

See `AGENTS.md` for the full active-hook inventory and customization overview.
Hook scripts use these exit codes: `0` = pass, `1` = fail with feedback, `2` = blocked

## Dead-Loop Prevention Notes

- `circuit-breaker.sh` warning output is intentionally strict even on `exit 0`, so the model is told not to keep editing the same file before the hard block triggers.
- `context-monitor.sh` uses advisory wording only. It should suggest saving state and wrapping up, but it must not issue imperative workflow commands that can trigger unnecessary tool calls.
- `post-edit-lint.sh` suppresses normal formatter/linter output to avoid fix-loop prompts from non-fatal lint noise.

## Debugging

```bash
# Test a hook manually
echo '{"tool_input":{"file_path":"test.js"}}' | ./.claude/hooks/protect-files.sh
echo $?  # 0 = allowed, 2 = blocked

# View/clear circuit breaker log
cat /tmp/claude-cb-*.log
rm /tmp/claude-cb-*.log
```

## Disabling Hooks

Remove the hook block from `.claude/settings.json`, or add `exit 0` at the top of the script.
````

## File: templates/commands/bug.md
````markdown
---
model: sonnet
argument-hint: "[bug description]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

Investigates and fixes bug: $ARGUMENTS. Use when a defect needs root-cause analysis and a minimal targeted fix.

## Process

### 1. Reproduce
- Identify the exact condition that triggers the bug
- If steps to reproduce are unclear, ask before proceeding
- Locate the relevant code path (use Grep/Glob, read 2-3 files max)

### 2. Root cause
- Trace the execution path to find where behavior diverges from expected
- State the root cause in one sentence before fixing

### 3. Fix
- Make the minimal change that fixes the root cause
- Do NOT refactor surrounding code or add unrelated improvements
- If the fix touches more than 3 files, stop and suggest creating a spec instead

### 4. Verify
Spawn `verify-app` via Agent tool:
> "Verify the bug fix. Run the test suite if available. Run the build if available. Report PASS or FAIL."
- If **FAIL**: report the output and stop. Do NOT proceed to review. Suggest: re-investigate the root cause.
- If **PASS**: continue to Step 5.

### 5. Review
Spawn `code-reviewer` via Agent tool. Pass the changed files and a one-line description of the fix.
- Verdict **PASS** or **CONCERNS**: done, report fix as complete.
- Verdict **FAIL**: flag for manual review, report the issues.

## Rules
- Fix only what is broken. No scope creep.
- If the bug is unclear or cannot be reproduced, ask the user before writing any code.
- If the root cause requires architectural changes, stop and recommend `/spec` instead.
````

## File: templates/commands/commit.md
````markdown
---
model: haiku
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

Stages changes and creates a conventional commit message. Use when work is ready and a well-scoped message is needed.

## Context

- Current status: `!git status`
- Staged changes: `!git diff --staged`
- Unstaged changes: `!git diff`
- Recent commits: `!git log --oneline -5`

## Process

1. Analyze the changes shown in Context above — determine if this is a new feature, enhancement, bug fix, refactor, test, or docs update.
2. Stage relevant files by name (`git add <file>...`). Do NOT use `git add -A` or `git add .` — avoid accidentally staging secrets or binaries.
3. Write a concise conventional commit message (1-2 sentences) focusing on **why**, not what.
4. Commit. Do NOT push. Do NOT use `--no-verify`.

## Post-Commit

After a successful commit, suggest:
> "Run `/reflect` to capture any learnings from this session before they leave context."

## Rules
- Never stage `.env`, credentials, or large binaries.
- Never push — only commit locally.
- Never skip hooks (`--no-verify`).
- If there are no changes, say so and stop.
````

## File: templates/commands/release.md
````markdown
---
model: sonnet
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
---

Bumps version, updates CHANGELOG, commits, and tags the release. Use when shipping a new version.

## Process

1. **Read current state**
   - Run `git log --oneline $(git describe --tags --abbrev=0 2>/dev/null)..HEAD 2>/dev/null || git log --oneline` to see commits since last tag
   - Read `CHANGELOG.md` — find the `## [Unreleased]` section and collect its entries
   - Read `package.json` to get current version

2. **Determine version bump**
   - Show the unreleased commits and CHANGELOG entries to the user
   - Ask which version bump to apply:
     - **patch** (1.1.4 → 1.1.5): bug fixes, small improvements
     - **minor** (1.1.4 → 1.2.0): new features, backward-compatible
     - **major** (1.1.4 → 2.0.0): breaking changes
   - Calculate the new version from the current one

3. **Check README counts**
   - Commands: `ls .claude/commands/*.md 2>/dev/null | wc -l` — compare to stated count in README ("15 commands", etc.)
   - Agents: `ls .claude/agents/*.md 2>/dev/null | wc -l` — compare to stated count in README ("8 agents", etc.)
   - Hooks: `ls .claude/hooks/*.sh 2>/dev/null | wc -l` — compare to stated count in README ("6 hooks", etc.)
   - If any count differs, report all discrepancies and ask user to fix README before proceeding

4. **Update package.json**
   - Replace `"version": "X.Y.Z"` with the new version
   - Show the change as a diff

5. **Update CHANGELOG.md**
   - Replace the `## [Unreleased]` heading with `## [vX.Y.Z] — YYYY-MM-DD` (today's date)
   - Add a new empty `## [Unreleased]` section above it:
     ```
     ## [Unreleased]


     ## [vX.Y.Z] — YYYY-MM-DD
     <previous entries>
     ```
   - If `[Unreleased]` is empty, still add it but note there were no unreleased entries

6. **Commit and tag**
   - Stage: `git add package.json CHANGELOG.md`
   - Commit: `git commit -m "release: vX.Y.Z"`
   - Tag: `git tag vX.Y.Z`
   - Report: "Tagged vX.Y.Z. Run `git push && git push --tags` when ready."
   - AI Setup installs `.github/workflows/release-from-changelog.yml` by default: pushing `vX.Y.Z` auto-creates/updates the GitHub Release body from the matching `CHANGELOG.md` section (`## [vX.Y.Z]`), so Slack release notifications include the changelog text.
   - Fallback safety: if no push-triggered release run appears within ~60 seconds after pushing the tag, run `gh workflow run release-from-changelog.yml -f tag=vX.Y.Z`.

## Rules
- Never push automatically — always leave push to the user
- Never skip the CHANGELOG update
- If [Unreleased] section is missing from CHANGELOG.md, stop and ask the user to run the CHANGELOG migration first
- Do NOT bump version if there are uncommitted changes (run `git status` check first)
````

## File: templates/commands/spec.md
````markdown
---
model: opus
mode: plan
argument-hint: "[task description]"
allowed-tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

Creates a structured spec for the task: $ARGUMENTS. Use before implementing any multi-file or architectural change.

## Phase 1 — Challenge & Think Through

Before writing anything: challenge the idea hard, then think it completely through. Present findings in the chat.

### 1a — Load Skills
If `.claude/skills/` exists, glob all skill directories and read each `SKILL.md` (first 5 lines only). Apply their guidance throughout the entire process.

### 1b — Clarify
If the request is ambiguous or underspecified, ask 1-3 focused questions before proceeding. Wait for answers. Skip if the task is clear.

### 1c — Concept Fit
Read `.agents/context/CONCEPT.md` if it exists. Answer:
- Does this align with the project's core principles?
- Is it in scope for this codebase/tool?
- Would this belong in the core, or is it a plugin/workaround?

Rate: **ALIGNED / BORDERLINE / MISALIGNED**. If MISALIGNED → **REJECT** immediately.

### 1d — Necessity
- What specific problem does this solve? Is it real or hypothetical?
- What breaks or stays painful if we don't build it?
- Who reported this problem — users, or us?

### 1e — Think It Through
Sketch the full implementation mentally before writing the spec.
**Use `AskUserQuestion` at any decision point** — don't assume, ask. Multiple rounds are fine.
Checklist:
- Files/systems touched; exact change in each
- Integration path; what calls what; data/state flow
- Edge cases; failure behavior; recoverability
- Hidden complexity; hard-to-test/debug parts; 6-month maintenance pain
- Implicit dependencies and side effects

### 1f — Overhead & Risk
- Maintenance burden added?
- Does it increase surface area (more config, more flags, more docs)?
- What's the risk if the implementation is wrong?

### 1g — Simpler Alternatives
List 1-3 alternatives:
- A smaller scope version
- A workaround that avoids building anything
- **"Don't build it"** — explicitly if it applies
Scan with Glob and Grep for similar existing functionality. Check installed skills for overlap.

### 1h — Verdict
Present a clear summary of the thinking above, then choose exactly one:
**GO** — Needed, fits, complexity is understood. The implementation sketch from 1e becomes the basis for the spec steps.
**SIMPLIFY** — Merits exist but scope is too large. State the reduced scope. Ask user to confirm before proceeding.
**REJECT** — Misaligned, unnecessary, or risk outweighs benefit. State reason. Stop here.

---

## Phase 2 — Write the Spec

Only proceed if verdict is GO or user confirmed a SIMPLIFY scope.

### Step 1 — Determine spec number
Scan `specs/` (including `specs/completed/`) for existing `NNN-*.md` files, find the highest number, increment by 1. Use 3-digit zero-padded numbers.

### Step 2 — Analyze the task
Read the 2-3 most relevant source files. Use the implementation sketch from Phase 1e — do not re-analyze from scratch.

List any relevant installed skills in the spec Context section.

### Step 3 — Create the spec file
Translate the Phase 1e implementation sketch into spec steps. Steps should reflect actual implementation path, not generic placeholders.

### Step 4 — Present the spec
Show the spec to the user for review and refinement.

### Step 5 — Branch
Use `AskUserQuestion` to ask: "Branch fuer diese Spec erstellen?"
- **Ja** — run `git checkout -b spec/NNN-<slug>` (slug = spec filename without number prefix)
- **Nein** — skip, user bleibt auf aktuellem Branch
- **Spaeter** — skip, user entscheidet selbst

## Spec Template

```markdown
# Spec: [Clear Title]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft | **Branch**: —

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->
<!-- Branch is set automatically by /spec-work-all (worktree mode) or manually -->

## Goal
[One sentence]

## Context
[2-3 sentences. Why needed, what approach was chosen, relevant skills if any.]

## Steps
- [ ] Step 1: description
- [ ] Step 2: description
- [ ] Step 3: description

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Files to Modify
- `path/to/file` - reason

## Out of Scope
- What is NOT part of this task
```

## Constraints & Rules
- **Total spec: max 60 lines.** If more, split into multiple specs.
- **Goal**: 1 sentence. **Context**: 2-3 sentences.
- **Steps**: Flat checkbox list, max 8 items. No nested sub-steps.
- **Acceptance Criteria**: max 5 items. **Out of Scope**: max 3 items.
- Steps must come from the Phase 1e implementation sketch — be specific, include file paths.
- Use today's date. Filename: lowercase with hyphens.
- Always create `specs/` and `specs/completed/` if they don't exist.
````

## File: tests/smoke.sh
````bash
#!/usr/bin/env bash
# Smoke test for bin/ai-setup.sh and lib/ modules
# Checks syntax and key function presence — does NOT execute the script interactively.

set -euo pipefail

PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "=== Smoke test: modular ai-setup ==="

# Step 1: Verify all lib modules exist
echo ""
echo "--- Module existence ---"
MODULES=("_loader.sh" "core.sh" "process.sh" "detect.sh" "tui.sh" "skills.sh" "generate.sh" "update.sh" "setup.sh" "plugins.sh")
for mod in "${MODULES[@]}"; do
  if [ -f "lib/$mod" ]; then
    pass "lib/$mod exists"
  else
    fail "lib/$mod missing"
  fi
done

# Step 2: Syntax check all files
echo ""
echo "--- Syntax checks (bash -n) ---"
if bash -n bin/ai-setup.sh 2>&1; then
  pass "bin/ai-setup.sh syntax"
else
  fail "bin/ai-setup.sh syntax"
fi

for mod in "${MODULES[@]}"; do
  if [ -f "lib/$mod" ]; then
    if bash -n "lib/$mod" 2>&1; then
      pass "lib/$mod syntax"
    else
      fail "lib/$mod syntax"
    fi
  fi
done

# Step 3: Key function presence in expected modules
echo ""
echo "--- Function location checks ---"
CHECKS=(
  "core.sh:build_template_map"
  "core.sh:get_package_version"
  "core.sh:compute_checksum"
  "core.sh:write_metadata"
  "core.sh:backup_file"
  "core.sh:collect_project_files"
  "process.sh:kill_tree"
  "process.sh:progress_bar"
  "process.sh:wait_parallel"
  "detect.sh:detect_system"
  "detect.sh:should_update_template"
  "tui.sh:select_system"
  "tui.sh:ask_regen_parts"
  "tui.sh:ask_update_parts"
  "skills.sh:search_skills"
  "skills.sh:get_keyword_skills"
  "skills.sh:install_skill"
  "generate.sh:run_generation"
  "update.sh:show_cli_update_notice"
  "update.sh:handle_version_check"
  "update.sh:run_smart_update"
  "update.sh:run_clean_reinstall"
  "setup.sh:check_requirements"
  "setup.sh:cleanup_legacy"
  "setup.sh:install_hooks"
  "setup.sh:install_commands"
  "setup.sh:install_agents"
  "setup.sh:repair_canonical_skill_links"
  "setup.sh:ensure_skills_alias"
  "setup.sh:setup_repo_group_context"
  "setup.sh:update_gitignore"
  "plugins.sh:install_gsd"
  "plugins.sh:install_claude_mem"
  "plugins.sh:install_coderabbit_plugin"
  "plugins.sh:install_context7"
  "plugins.sh:install_playwright"
  "plugins.sh:show_installation_summary"
  "plugins.sh:show_next_steps"
)

for check in "${CHECKS[@]}"; do
  IFS=':' read -r mod fn <<< "$check"
  if grep -q "${fn}()" "lib/$mod" 2>/dev/null; then
    pass "${fn}() in lib/$mod"
  else
    fail "${fn}() missing from lib/$mod"
  fi
done

# Step 4: Verify main script sources modules
echo ""
echo "--- Module sourcing in bin/ai-setup.sh ---"
for mod in "${MODULES[@]}"; do
  if grep -q "$mod" bin/ai-setup.sh 2>/dev/null; then
    pass "bin/ai-setup.sh sources $mod"
  else
    fail "bin/ai-setup.sh does not source $mod"
  fi
done

# Step 5: Verify package.json includes lib/
echo ""
echo "--- Distribution checks ---"
if grep -q '"lib/"' package.json 2>/dev/null; then
  pass "package.json includes lib/ in files"
else
  fail "package.json missing lib/ in files"
fi

# Step 6: Verify update-check hook is wired for startup and prompt submit
echo ""
echo "--- Hook wiring checks ---"
if awk '/"SessionStart"[[:space:]]*:[[:space:]]*\[/,/^[[:space:]]*\],?$/' templates/claude/settings.json | grep -q 'update-check.sh'; then
  pass "templates/claude/settings.json wires update-check.sh on SessionStart"
else
  fail "templates/claude/settings.json missing SessionStart update-check.sh hook"
fi

if awk '/"SessionStart"[[:space:]]*:[[:space:]]*\[/,/^[[:space:]]*\],?$/' templates/claude/settings.json | grep -q 'cross-repo-context.sh'; then
  pass "templates/claude/settings.json wires cross-repo-context.sh on SessionStart"
else
  fail "templates/claude/settings.json missing SessionStart cross-repo-context.sh hook"
fi

if grep -q 'repo-group.json' templates/claude/hooks/cross-repo-context.sh 2>/dev/null; then
  pass "cross-repo-context hook supports repo-group.json map"
else
  fail "cross-repo-context hook missing repo-group.json map support"
fi

if awk '/"UserPromptSubmit"[[:space:]]*:[[:space:]]*\[/,/^[[:space:]]*\],?$/' templates/claude/settings.json | grep -q 'update-check.sh'; then
  pass "templates/claude/settings.json wires update-check.sh on UserPromptSubmit"
else
  fail "templates/claude/settings.json missing UserPromptSubmit update-check.sh hook"
fi

# Step 7: Verify skills alias migration is wired in both setup and update paths
echo ""
echo "--- Skills alias migration wiring ---"
if grep -q 'ensure_skills_alias' bin/ai-setup.sh 2>/dev/null; then
  pass "bin/ai-setup.sh calls ensure_skills_alias on install"
else
  fail "bin/ai-setup.sh missing ensure_skills_alias call"
fi

if grep -q 'ensure_skills_alias' lib/update.sh 2>/dev/null; then
  pass "lib/update.sh calls ensure_skills_alias during smart update"
else
  fail "lib/update.sh missing ensure_skills_alias call"
fi

if grep -q 'repair_canonical_skill_links' lib/setup.sh 2>/dev/null; then
  pass "lib/setup.sh contains looping skill-link repair helper"
else
  fail "lib/setup.sh missing looping skill-link repair helper"
fi

if grep -Eq 'repair_canonical_skill_links .*\$canonical.*\$canonical_abs' lib/setup.sh 2>/dev/null; then
  pass "ensure_skills_alias invokes looping skill-link repair"
else
  fail "ensure_skills_alias missing looping skill-link repair call"
fi

# Summary
echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
````

## File: templates/commands/spec-work-all.md
````markdown
---
model: sonnet
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

Executes all draft specs in parallel using isolated worktrees. Use to batch-implement multiple independent specs.

## Process

### 1. Discover draft specs
Scan `specs/` for all `NNN-*.md` files (excluding `specs/completed/`). Only pick specs with `Status: draft`. Read each spec's Goal and Out of Scope to build a dependency map.

### 2. Dependency detection
A spec is **dependent** on another if its "Out of Scope" section explicitly names another spec number (e.g. "Spec 010", "spec 009"). Dependent specs must run after the spec they reference.

Group specs into:
- **Parallel group**: specs with no dependencies on each other
- **Sequential queue**: specs that depend on a parallel spec (run after their dependency completes)

### 3. Execute in waves

#### Wave setup — before launching subagents
For each spec in the current wave:

1. Derive branch name: `spec/NNN-title` (lowercase, hyphens, from spec filename without `.md`)
2. Update spec header in the **main working directory** spec file:
   - Set `**Status**: in-progress`
   - Set `**Branch**: spec/NNN-title`

#### Wave execution — parallel subagents
Launch one Agent subagent per spec simultaneously using `isolation: "worktree"`. Each subagent receives:
**Prompt for each subagent:**
```
Execute this spec. You are running in an isolated Git worktree.
Do first:
1. Rename the current branch to `spec/NNN-title`:
   git branch -m spec/NNN-title
2. Get the main repo path (the parent of this worktree):
   MAIN_REPO=$(git worktree list | head -1 | awk '{print $1}')
3. Copy .env files from the main repo (skip .env.example and .env.template):
   for f in "$MAIN_REPO"/.env*; do
     [[ -f "$f" ]] || continue
     base=$(basename "$f")
     [[ "$base" == ".env.example" || "$base" == ".env.template" ]] && continue
     cp "$f" . 2>/dev/null || echo "⚠️  Could not copy $base — continuing"
   done
4. Install dependencies if a lockfile exists (run from worktree root):
   if [ -f "bun.lockb" ]; then bun install --frozen-lockfile 2>/dev/null || echo "⚠️  bun install failed"
   elif [ -f "package-lock.json" ]; then npm ci 2>/dev/null || echo "⚠️  npm ci failed"
   elif [ -f "pnpm-lock.yaml" ]; then pnpm install --frozen-lockfile 2>/dev/null || echo "⚠️  pnpm install failed"
   elif [ -f "yarn.lock" ]; then yarn install --frozen-lockfile 2>/dev/null || echo "⚠️  yarn install failed"
   fi
Then follow the `/spec-work` process for this spec inside the worktree: read context, load referenced skills, execute each step in order, verify acceptance criteria, then commit with `git add -A && git commit -m "spec(NNN): [spec title]"`.
Spec content:
[full spec content here]
```

#### Wave post-processing — after each subagent returns
For each completed subagent, using the branch and worktree path from the Agent result:

1. Check all spec steps off in `specs/NNN-*.md`
2. Mark all acceptance criteria as checked
3. Set spec status to `in-review`
4. Prepend CHANGELOG entry under `## [Unreleased]`:
   - Add: `- **Spec NNN**: [Title] — [1-sentence summary]`
   - Insert after the `## [Unreleased]` heading
5. Remove the worktree (branch is preserved for `/spec-review`):
   `git worktree remove --force <worktree-path-from-agent-result>`

**Wave 2+**: After each wave completes, launch the next wave of specs that are now unblocked.

### 4. Final summary
After all waves complete, report:
- Completed specs (with spec ID, title, and branch name)
- Failed specs (with spec ID and reason)
- Total: N completed, M failed
- Next step: `Run /spec-review NNN for each completed spec, or /spec-board for overview`

## Rules
- Follow each spec exactly — no scope creep
- If a step in a spec is blocked or unclear, mark it unchecked and continue remaining steps
- If `specs/` has no draft specs, report "No draft specs found" and stop
- If an Agent subagent fails, mark the spec as `blocked` and report the error
````

## File: templates/commands/spec-work.md
````markdown
---
model: sonnet
disable-model-invocation: true
argument-hint: "[spec number]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion, Agent
---

Executes spec $ARGUMENTS step by step and verifies acceptance criteria. Use to implement a single approved spec.

## Process

1. **Find the spec**: If `$ARGUMENTS` is a number (e.g. `001`), open `specs/001-*.md`. If it's a filename, open that directly. If empty, list all draft specs in `specs/` and ask which one to work on.

2. **Read the spec** and understand Goal, Steps, and Files to Modify.

3. **Branch setup**: Ask the user whether to create a new branch before starting work.
   - Derive the branch name from the spec filename: `spec/NNN-title` (lowercase, hyphens, strip `.md`)
   - If user says yes: run `git checkout -b spec/NNN-title`. If the branch already exists, offer to switch to it with `git checkout spec/NNN-title`.
   - Update the spec header: set `**Branch**: spec/NNN-title` (or `—` if no branch created).

4. **Read project context**: Skim `.agents/context/CONVENTIONS.md` and `.agents/context/STACK.md` to follow project patterns and use correct libraries.

5. **Load relevant skills**: If the spec's Context section mentions skills, read `.claude/skills/<name>/SKILL.md` for each and apply throughout execution. Skip if none listed.

6. **Architectural review** (high-complexity specs only): Check if the spec header contains `**Complexity**: high`. If yes, spawn the `code-architect` agent via Agent tool, passing the full spec content as the prompt. Then:
   - If the verdict is **REDESIGN**: stop immediately, report all concerns to the user, and do not proceed.
   - If the verdict is **PROCEED WITH CHANGES**: report the concerns to the user, then continue.
   - If the verdict is **PROCEED**: continue normally.

7. **Start work**: Update the spec header — set `**Status**: in-progress`.

8. **Output progress checklist**: Before executing, print a checklist of all steps found in the spec:
   ```
   Progress — Spec NNN
   [ ] Step 1: <title>
   [ ] Step 2: <title>
   ...
   ```
   Check off each item (`[x]`) as you complete it so the user can follow along.

9. **Execute each step** in order:
   - Implement the change
   - After completing a step, edit the spec file to check it off: `- [ ]` -> `- [x]`
   - Update the printed progress checklist to reflect the completed step
   - If a step is blocked or unclear, stop and ask the user

10. **Verify acceptance criteria**: After all steps are done, check each acceptance criterion. Mark them as checked in the spec.

11. **Update CHANGELOG.md**: Add an entry to the `## [Unreleased]` section in `CHANGELOG.md`:
    - Find the `## [Unreleased]` heading (it's just below the `<!-- Entries are prepended below this line, newest first -->` comment)
    - Insert after `## [Unreleased]`: `- **Spec NNN**: [Spec title] — [1-sentence summary of what changed]`
    - Do NOT create date headings — entries accumulate under [Unreleased] until `/release` is run

12. **Verify implementation**: Spawn `verify-app` via Agent tool with the prompt:
    > "Verify that the implementation for spec NNN is correct. Check if the project has a test suite and run it. Check if there is a build command and run it. Report PASS or FAIL."
    - If verify-app returns **PASS**: continue to the next step.
    - If verify-app returns **FAIL**: trigger the **Haiku Investigator** (exactly once — never in a loop):

    > **Haiku Investigator** — spawn a sub-agent with these constraints:
    > - Model: haiku | Allowed tools: Read, Glob, Grep, Bash (read-only: `cat`, `ls`, `grep`, `find`) | **Forbidden: Write, Edit**
    > - Prompt: "Diagnose this build/test failure. Read the error output and relevant source files. Identify the root cause. Output: (1) root cause in one sentence, (2) the specific line(s) to fix, (3) exact fix to apply. Do NOT edit any files."
    > - Pass the full verify-app error output to the investigator.
    
    Apply the investigator's suggested fix as a **single targeted edit**, then run verify-app once more.
    - If the second verify-app returns **PASS**: continue normally.
    - If the second verify-app returns **FAIL**: set status to `in-review`, report the investigator's diagnosis and remaining error, **stop**. Do NOT proceed to step 13 (code-reviewer). Do NOT run the investigator again. Suggest: `Fix the reported issues and re-run /spec-work NNN`.

13. **Auto-review**: Spawn the `code-reviewer` agent via Agent tool to review the changes. Pass the spec content and the current branch name so the agent can run the correct diff.
    - If verdict is **FAIL**: set status to `in-review`. Report the issues. Suggest: `Run /spec-review NNN to review manually.`
    - If verdict is **PASS** or **CONCERNS**: set status to `completed`, move spec file `specs/NNN-*.md` → `specs/completed/NNN-*.md`. Report: "Auto-review passed. Spec NNN completed."

## Rules
- Follow the spec exactly — nothing outside the Steps and within scope.
- Check off each step in the spec file as you complete it (progress tracking).
- If a step fails or is blocked, leave it unchecked, set status to `blocked`, and ask the user.
- Commit after logical groups of changes, not after every single step.
- If called with `--complete` flag, skip steps 12-13: set status directly to `completed` and move to `specs/completed/` (legacy behavior).
````

## File: lib/core.sh
````bash
#!/bin/bash
# Core utilities: template map, version management, checksums, backup
# Requires: SCRIPT_DIR, TPL

# Files with special handling excluded from generic TEMPLATE_MAP (e.g. mcp.json uses merge logic)
TEMPLATE_EXCLUDES=("mcp.json" "statusline.sh")

# Build TEMPLATE_MAP dynamically from templates/ directory.
# Applies consistent prefix rules:
#   claude/    -> .claude/
#   github/    -> .github/
#   commands/  -> .claude/commands/
#   agents/    -> .claude/agents/
#   specs/     -> specs/
#   (root)     -> (root, e.g. CLAUDE.md)
build_template_map() {
  TEMPLATE_MAP=()
  local tpl_dir="$SCRIPT_DIR/templates"

  while IFS= read -r -d '' file; do
    local rel="${file#$tpl_dir/}"
    local filename="${rel##*/}"

    # Skip excluded filenames
    local excluded=false
    for excl in "${TEMPLATE_EXCLUDES[@]}"; do
      [ "$filename" = "$excl" ] && excluded=true && break
    done
    [ "$excluded" = "true" ] && continue

    # Skip skills/ — handled explicitly by SHOPIFY_SKILLS_MAP with system check
    [[ "$rel" == skills/* ]] && continue

    # Skip typescript.md — handled conditionally by TS_RULES_MAP in install_rules()
    [[ "$rel" == "claude/rules/typescript.md" ]] && continue

    # Map source path to install target path
    local target
    case "$rel" in
      claude/*)   target=".${rel}" ;;
      github/*)   target=".${rel}" ;;
      commands/*) target=".claude/${rel}" ;;
      agents/*)   target=".claude/${rel}" ;;
      specs/*)    target="${rel}" ;;
      *)          target="${rel}" ;;
    esac

    TEMPLATE_MAP+=("templates/${rel}:${target}")
  done < <(find "$tpl_dir" -type f -print0 | sort -z)
}

# Populate TEMPLATE_MAP at startup
build_template_map

# Shopify-specific skills (only added when system includes shopify)
SHOPIFY_SKILLS_MAP=(
  "templates/skills/shopify-theme-dev/SKILL.md:.claude/skills/shopify-theme-dev/SKILL.md"
  "templates/skills/shopify-liquid/SKILL.md:.claude/skills/shopify-liquid/SKILL.md"
  "templates/skills/shopify-app-dev/SKILL.md:.claude/skills/shopify-app-dev/SKILL.md"
  "templates/skills/shopify-graphql-api/SKILL.md:.claude/skills/shopify-graphql-api/SKILL.md"
  "templates/skills/shopify-hydrogen/SKILL.md:.claude/skills/shopify-hydrogen/SKILL.md"
  "templates/skills/shopify-checkout/SKILL.md:.claude/skills/shopify-checkout/SKILL.md"
  "templates/skills/shopify-functions/SKILL.md:.claude/skills/shopify-functions/SKILL.md"
  "templates/skills/shopify-cli-tools/SKILL.md:.claude/skills/shopify-cli-tools/SKILL.md"
  "templates/skills/shopify-new-section/SKILL.md:.claude/skills/shopify-new-section/SKILL.md"
  "templates/skills/shopify-new-block/SKILL.md:.claude/skills/shopify-new-block/SKILL.md"
)

# TypeScript-specific rules (only added when *.ts or *.tsx files are detected)
TS_RULES_MAP=(
  "templates/claude/rules/typescript.md:.claude/rules/typescript.md"
)

# Return 0 if $1 > $2 in semver (major.minor.patch, ignores pre-release)
_semver_gt() {
  local -a a b
  IFS=. read -ra a <<< "$1"
  IFS=. read -ra b <<< "$2"
  for i in 0 1 2; do
    local ai=${a[$i]:-0} bi=${b[$i]:-0}
    [ "$ai" -gt "$bi" ] 2>/dev/null && return 0
    [ "$ai" -lt "$bi" ] 2>/dev/null && return 1
  done
  return 1  # equal
}

VALID_SYSTEMS=(auto shopify nuxt next laravel shopware storyblok)

# Get package version from package.json
get_package_version() {
  jq -r '.version' "$SCRIPT_DIR/package.json" 2>/dev/null || echo "unknown"
}

# Get installed version from .ai-setup.json
get_installed_version() {
  if [ -f .ai-setup.json ] && jq -e . .ai-setup.json >/dev/null 2>&1; then
    jq -r '.version // empty' .ai-setup.json 2>/dev/null || echo ""
  else
    echo ""
  fi
}

# Compute checksum for a file (cksum outputs: checksum size filename)
compute_checksum() {
  if [ -f "$1" ]; then
    cksum "$1" 2>/dev/null | awk '{print $1, $2}' || echo ""
  else
    echo ""
  fi
}

# Write .ai-setup.json with current version and checksums
write_metadata() {
  local version
  version=$(get_package_version)
  local timestamp
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Preserve original install time if updating
  local install_time="$timestamp"
  if [ -f .ai-setup.json ] && jq -e . .ai-setup.json >/dev/null 2>&1; then
    local prev
    prev=$(jq -r '.installed_at // empty' .ai-setup.json 2>/dev/null)
    [ -n "$prev" ] && install_time="$prev"
  fi

  # Build JSON with jq
  local json
  json=$(jq -n \
    --arg ver "$version" \
    --arg inst "$install_time" \
    --arg upd "$timestamp" \
    --arg sys "${SYSTEM:-}" \
    '{version: $ver, installed_at: $inst, updated_at: $upd, system: $sys, files: {}}')

  for mapping in "${TEMPLATE_MAP[@]}"; do
    local tpl="${mapping%%:*}"
    local target="${mapping#*:}"
    if [ -f "$target" ]; then
      local cs
      cs=$(compute_checksum "$target")
      json=$(echo "$json" | jq --arg f "$target" --arg c "$cs" '.files[$f] = $c')
    fi
  done

  # Include Shopify skills if system includes shopify
  if [[ "${SYSTEM:-}" == *shopify* ]]; then
    for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
      local tpl="${mapping%%:*}"
      local target="${mapping#*:}"
      if [ -f "$target" ]; then
        local cs
        cs=$(compute_checksum "$target")
        json=$(echo "$json" | jq --arg f "$target" --arg c "$cs" '.files[$f] = $c')
      fi
    done
  fi

  # Include TypeScript rules if installed
  for mapping in "${TS_RULES_MAP[@]}"; do
    local tpl="${mapping%%:*}"
    local target="${mapping#*:}"
    if [ -f "$target" ]; then
      local cs
      cs=$(compute_checksum "$target")
      json=$(echo "$json" | jq --arg f "$target" --arg c "$cs" '.files[$f] = $c')
    fi
  done

  echo "$json" > .ai-setup.json
}

# Returns 0 when the target path is still managed by the current installer config.
# Includes conditional maps that may or may not apply in the current project.
is_current_managed_target() {
  local target="$1"
  local mapping

  for mapping in "${TEMPLATE_MAP[@]}"; do
    [ "${mapping#*:}" = "$target" ] && return 0
  done

  if [[ "${SYSTEM:-}" == *shopify* ]]; then
    for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
      [ "${mapping#*:}" = "$target" ] && return 0
    done
  fi

  for mapping in "${TS_RULES_MAP[@]}"; do
    [ "${mapping#*:}" = "$target" ] && return 0
  done

  return 1
}

# Backup a file to .ai-setup-backup/ with timestamp
backup_file() {
  local file="$1"
  local ts
  ts=$(date +"%Y%m%d_%H%M%S")
  mkdir -p .ai-setup-backup

  # Use flat filename with path separators replaced
  local safe_name
  safe_name=$(echo "$file" | tr '/' '_')
  local backup_path=".ai-setup-backup/${safe_name}.${ts}"
  cp "$file" "$backup_path"
  echo "$backup_path"
}

# Efficiently collect project files (git-aware with fallback)
collect_project_files() {
  local max_files=${1:-80}

  # Try git first (10x faster)
  if git rev-parse --git-dir >/dev/null 2>&1; then
    git ls-files -z '*.js' '*.ts' '*.jsx' '*.tsx' '*.vue' '*.svelte' \
      '*.css' '*.scss' '*.liquid' '*.php' '*.html' '*.twig' \
      '*.blade.php' '*.erb' '*.py' '*.rb' '*.go' '*.rs' '*.astro' \
      2>/dev/null | tr '\0' '\n' | head -n "$max_files"
  else
    # Fallback: optimized find with early pruning
    find . -maxdepth 4 \
      \( -name node_modules -o -name .git -o -name dist -o -name build \
         -o -name assets -o -name .next -o -name vendor -o -name .nuxt \) -prune -o \
      -type f \( \
        -iname '*.js' -o -iname '*.ts' -o -iname '*.jsx' -o -iname '*.tsx' \
        -o -iname '*.vue' -o -iname '*.svelte' -o -iname '*.css' -o -iname '*.scss' \
        -o -iname '*.liquid' -o -iname '*.php' -o -iname '*.html' -o -iname '*.twig' \
        -o -iname '*.blade.php' -o -iname '*.erb' -o -iname '*.py' -o -iname '*.rb' \
        -o -iname '*.go' -o -iname '*.rs' -o -iname '*.astro' \
      \) -print | head -n "$max_files"
  fi
}
````

## File: lib/generate.sh
````bash
#!/bin/bash
# AI generation: CLAUDE.md extension, context generation, skill discovery
# Requires: core.sh, process.sh, detect.sh, skills.sh
# Requires: $SYSTEM, $TEMPLATE_MAP, $SHOPIFY_SKILLS_MAP, $REGEN_*

# Gather Shopware-specific context for Claude prompts.
# Sets: CTX_SHOPWARE, SHOPWARE_INSTRUCTION, SHOPWARE_RULE
gather_shopware_context() {
  CTX_SHOPWARE=""
  SHOPWARE_INSTRUCTION=""
  SHOPWARE_RULE=""

  [ "$SYSTEM" != "shopware" ] && return 0

  # Read composer.json
  local composer_content
  composer_content=$(cat composer.json 2>/dev/null || echo "")

  # Extract Shopware plugins from composer require
  local composer_plugins
  composer_plugins=$(jq -r '
    (.require // {}) + (.["require-dev"] // {}) | to_entries[]
    | select(.key | startswith("store.shopware.com/") or startswith("swag/") or startswith("shopware/"))
    | "\(.key): \(.value)"
  ' composer.json 2>/dev/null || echo "none")

  # Scan custom/ subdirectories for plugins and apps
  local custom_plugins="none"
  local custom_apps="none"
  if [ -d "custom/static-plugins" ]; then
    custom_plugins=$(ls -1 custom/static-plugins/ 2>/dev/null)
    [ -z "$custom_plugins" ] && custom_plugins="none"
  elif [ -d "custom/plugins" ]; then
    custom_plugins=$(ls -1 custom/plugins/ 2>/dev/null)
    [ -z "$custom_plugins" ] && custom_plugins="none"
  fi
  if [ -d "custom/apps" ]; then
    custom_apps=$(ls -1 custom/apps/ 2>/dev/null)
    [ -z "$custom_apps" ] && custom_apps="none"
  fi

  # Check for deployment overrides (patched vendor packages)
  local deploy_overrides="none"
  if [ -d "deployment-overrides" ]; then
    deploy_overrides=$(find deployment-overrides -maxdepth 3 -type d 2>/dev/null | head -20)
    [ -z "$deploy_overrides" ] && deploy_overrides="none"
  fi

  CTX_SHOPWARE="--- composer.json ---
$composer_content
--- Shopware plugins (composer) ---
$composer_plugins
--- Custom plugins (filesystem) ---
$custom_plugins
--- Custom apps (filesystem) ---
$custom_apps
--- Deployment overrides ---
$deploy_overrides
--- Shopware project type ---
$SHOPWARE_TYPE"

  # System-specific instructions for context generation (Step 2)
  if [ "$SHOPWARE_TYPE" = "shop" ]; then
    SHOPWARE_INSTRUCTION="
This is a Shopware 6 full shop installation.

Shopware 6 directory structure:
  bin/              - CLI (bin/console)
  config/           - Symfony/Shopware config (packages/shopware.yaml, services.yaml)
  custom/           - Plugins and apps
    static-plugins/ - Developer-managed plugins, committed to Git (YOUR WORKING AREA)
      MeinPlugin/
        src/
          MeinPlugin.php       - Plugin base class
          Controller/
          Service/
          Entity/
          Migration/           - DB migrations
          Resources/
            config/services.xml - Dependency Injection
            config/routes.xml
            views/             - Twig templates
            public/            - Assets (JS, CSS)
        composer.json
    plugins/        - Plugins installed via Shopware Admin UI (DO NOT MODIFY)
    apps/           - Shopware Apps (lightweight)
  public/           - Web root (index.php, compiled assets)
  src/              - Project-level PHP overrides (Controllers etc.)
  var/              - Cache, logs, temporary files
  vendor/           - Composer dependencies
  deployment-overrides/ - Patched vendor files (DO NOT MODIFY)

In ARCHITECTURE.md, include a 'Working Scope' section:
- Allowed working directories: custom/static-plugins/, config/
- READ-ONLY: vendor/, public/, var/, bin/, files/ (managed by Shopware/Composer)
- NEVER TOUCH: custom/plugins/ (managed by Shopware Admin), deployment-overrides/ (managed by deployment pipeline)
- List installed custom plugins and apps from custom/ and their paths
- Core Shopware code in vendor/shopware/ must NEVER be modified"

    SHOPWARE_RULE="
Add a 'Shopware 6' section under Critical Rules:
- DAL-First: Always use EntityRepository -- never raw DBAL/SQL queries
- Service-Container: Business logic belongs in Services, registered in
  src/Resources/config/services.xml using Constructor Injection only
- Migrations: SQL migrations go in src/Migration/ and must be idempotent
- Criteria Performance: Add only required associations -- avoid over-fetching
- Code Style: PSR-12, strict_types=1 declarations in every PHP file
- Admin: Vue.js 3 + Shopware meteor-component-library for Admin extensions
- Cache: Always run bin/console cache:clear after config/container changes
- Only modify files in custom/static-plugins/ and config/
- Never modify custom/plugins/ (admin-managed), vendor/, public/, var/, deployment-overrides/, or core Shopware files
- Use Shopware plugin hooks and decorators for customization
- Plugin structure: src/ (PHP), Resources/config/ (DI, routes), Resources/views/ (Twig), Resources/public/ (assets)
- Run bin/console commands for cache clear, plugin lifecycle

Also add a 'MCP Servers' section to CLAUDE.md:
## MCP Servers
### shopware-admin-mcp
Configured in .mcp.json -- provides direct access to the Shopware Admin API.

Use it when you need to:
- Inspect live entity data (products, orders, customers, categories, properties)
- Look up field names, associations, or entity schemas before writing DAL code
- Verify that a plugin's data changes actually persisted correctly
- Create or update entities to set up test fixtures or seed data
- Debug data issues without writing a one-off console command

Do NOT use it for:
- Code generation or file edits (use standard tools)
- Tasks that only touch the local codebase with no data dependency"
  else
    SHOPWARE_RULE="
Add a 'Shopware 6 Plugin' section under Critical Rules:
- DAL-First: Always use EntityRepository -- never raw DBAL/SQL queries
- Service-Container: Logic in Services, registered in src/Resources/config/services.xml
  using Constructor Injection; never use service locator pattern
- Migrations: SQL migrations in src/Migration/ -- must be idempotent (CREATE TABLE IF NOT EXISTS)
- Subscribers: New event subscribers need both the PHP class AND the XML service tag
  (shopware.event.subscriber) in services.xml
- Controllers: Use Symfony routing attributes/annotations with correct RouteScope
- Tests: Integration tests extend KernelTestBase; unit tests are plain PHPUnit
- Criteria Performance: Minimize associations -- only add what the use-case requires
- Code Style: PSR-12 standards, strict_types=1, typed properties

Also add a 'MCP Servers' section to CLAUDE.md:
## MCP Servers
### shopware-admin-mcp
Configured in .mcp.json -- provides direct access to the Shopware Admin API of the target shop.

Use it when you need to:
- Inspect live entity data (products, orders, customers, categories, properties)
- Look up field names, associations, or entity schemas before writing DAL code
- Verify that the plugin's data changes actually persisted correctly in the shop
- Create or update entities to set up test fixtures or reproduce a bug
- Debug data issues without writing a one-off console command

Do NOT use it for:
- Code generation or file edits (use standard tools)
- Tasks that only touch the local plugin codebase with no data dependency"

    SHOPWARE_INSTRUCTION="
This is a standalone Shopware 6 plugin project.
Stack: Shopware 6.6+, Symfony 7.x, Vue.js 3, PHP 8.3+.

Standard Shopware plugin structure:
  src/
    PluginName.php       - Plugin base class (extends Plugin)
    Controller/          - Storefront/API controllers
    Service/             - Business logic services
    Entity/              - Custom entities (ORM)
    Migration/           - Database migrations
    Subscriber/          - Event subscribers
    Resources/
      config/
        services.xml     - Dependency Injection definitions
        routes.xml       - Route definitions
      views/             - Twig templates (storefront, admin)
      public/            - Static assets (JS, CSS, images)
  tests/                 - PHPUnit tests
  composer.json          - Plugin metadata and dependencies

In ARCHITECTURE.md, include:
- Plugin namespace and bootstrap class location (src/*Plugin.php or src/*Bundle.php)
- Standard directory conventions as above
- Key patterns: DAL (EntityRepository for all DB access), Services (DI container),
  Subscribers (event-driven hooks), Admin Extensions (Vue.js 3 components)
- This plugin installs into a Shopware 6 shop via Composer"
  fi
}

setup_shopware_mcp() {
  [ "$SYSTEM" != "shopware" ] && return 0

  # Ensure .mcp.json exists
  [ -f ".mcp.json" ] || echo '{"mcpServers":{}}' > .mcp.json

  # Warn if an existing server stores credentials in a git-tracked file
  if jq -e '(.mcpServers["shopware-admin-mcp"].env.SHOPWARE_API_CLIENT_ID? != null) or (.mcpServers["shopware-admin-mcp"].env.SHOPWARE_API_CLIENT_SECRET? != null)' .mcp.json >/dev/null 2>&1; then
    echo "  ⚠️  shopware-admin-mcp credentials found in .mcp.json."
    echo "     Move secrets to local shell env vars (do not commit credentials)."
  fi

  # Idempotency: skip if already configured
  if jq -e '.mcpServers["shopware-admin-mcp"]' .mcp.json >/dev/null 2>&1; then
    return 0
  fi

  echo ""
  echo "Shopware Admin MCP"
  echo "   Gives Claude direct access to the Shopware Admin API."

  # Try to read APP_URL from .env early (needed for the integration link)
  local ENV_URL=""
  if [ -f ".env" ]; then
    ENV_URL=$(grep -E '^APP_URL=' .env | cut -d= -f2- | tr -d '"' | tr -d "'")
  fi

  if [ -n "$ENV_URL" ]; then
    echo "   Create an integration at: ${ENV_URL}/admin#/sw/integration/index"
  fi

  read -r -p "   Set up Shopware Admin MCP? [y/N]: " SETUP_MCP
  if [ "$SETUP_MCP" != "y" ] && [ "$SETUP_MCP" != "Y" ]; then
    echo "   Skipped."
    return 0
  fi
  echo ""

  if [ -n "$ENV_URL" ]; then
    echo "   Found APP_URL in .env: $ENV_URL"
    read -r -p "   Use this URL? [Y/n]: " USE_ENV
    if [ -z "$USE_ENV" ] || [ "$USE_ENV" = "y" ] || [ "$USE_ENV" = "Y" ]; then
      SW_URL="$ENV_URL"
    else
      read -r -p "   Shop URL (optional, e.g. https://your-shop.com): " SW_URL
    fi
  else
    read -r -p "   Shop URL (optional, e.g. https://your-shop.com): " SW_URL
  fi

  local TMP_MCP
  TMP_MCP=$(mktemp)
  if [ -n "$SW_URL" ]; then
    jq --arg url "$SW_URL" \
      '.mcpServers["shopware-admin-mcp"] = {
        "command": "npx",
        "args": ["-y", "@shopware-ag/admin-mcp"],
        "env": {
          "SHOPWARE_API_URL": $url
        }
      }' .mcp.json > "$TMP_MCP" && mv "$TMP_MCP" .mcp.json
  else
    jq \
      '.mcpServers["shopware-admin-mcp"] = {
        "command": "npx",
        "args": ["-y", "@shopware-ag/admin-mcp"]
      }' .mcp.json > "$TMP_MCP" && mv "$TMP_MCP" .mcp.json
  fi

  echo "   shopware-admin-mcp added to .mcp.json"
  echo "   ℹ️  Set credentials locally before starting Claude Code:"
  echo "      export SHOPWARE_API_CLIENT_ID=..."
  echo "      export SHOPWARE_API_CLIENT_SECRET=..."
  if [ -z "$SW_URL" ]; then
    echo "      export SHOPWARE_API_URL=https://your-shop.com"
  fi
}

# Main generation orchestrator
# Called by both normal setup (Auto-Init) and --regenerate mode.
# Requires: $SYSTEM is set, claude CLI is available
# Sets: $INSTALLED (number of skills installed)
run_generation() {
  # Disable errexit — background processes, wait, and command substitutions
  # cause silent exits with set -e (especially bash 3.2 on macOS).
  # This function has comprehensive error handling for all steps.
  set +e
  local regen_failed=0

  # Default: regenerate everything unless flags were explicitly set by ask_regen_parts
  : "${REGEN_CLAUDE_MD:=yes}"
  : "${REGEN_AGENTS_MD:=${REGEN_CLAUDE_MD}}"
  : "${REGEN_CONTEXT:=yes}"
  : "${REGEN_COMMANDS:=yes}"
  : "${REGEN_AGENTS:=${REGEN_COMMANDS}}"
  : "${REGEN_SKILLS:=yes}"

  # Keep a single canonical skills directory and expose it under .agents/skills as alias.
  if command -v ensure_skills_alias >/dev/null 2>&1; then
    ensure_skills_alias
  fi

  local regen_ai_context="no"
  if [ "$REGEN_CLAUDE_MD" = "yes" ] || [ "$REGEN_AGENTS_MD" = "yes" ] || [ "$REGEN_CONTEXT" = "yes" ]; then
    regen_ai_context="yes"
  fi

  # Re-deploy slash commands and/or agent templates from package templates.
  if [ "$REGEN_COMMANDS" = "yes" ] || [ "$REGEN_AGENTS" = "yes" ]; then
    echo "📋 Updating command and agent templates..."
    local cmd_updated=0
    for mapping in "${TEMPLATE_MAP[@]}"; do
      local tpl="${mapping%%:*}"
      local target="${mapping#*:}"
      if { [[ "$tpl" == templates/commands/* ]] && [ "$REGEN_COMMANDS" = "yes" ]; } \
        || { [[ "$tpl" == templates/agents/* ]] && [ "$REGEN_AGENTS" = "yes" ]; }; then
        if [ -f "$SCRIPT_DIR/$tpl" ]; then
          mkdir -p "$(dirname "$target")"
          cp "$SCRIPT_DIR/$tpl" "$target"
          cmd_updated=$((cmd_updated + 1))
        fi
      fi
    done
    echo "  ✅ $cmd_updated file(s) updated"
  fi

  if [ "$regen_ai_context" = "yes" ]; then
    echo "🚀 Generating project context (System: $SYSTEM)..."

    # Detect Shopware sub-type and gather system-specific context
    detect_shopware_type
    if [ -n "$SHOPWARE_TYPE" ]; then
      echo "  Shopware type: $SHOPWARE_TYPE"
    fi
    gather_shopware_context
    setup_shopware_mcp

    # Cache file list once (avoid running collect_project_files 3x)
    CACHED_FILES=$(collect_project_files 80)

    # Gather all context upfront
    CONTEXT="--- package.json ---
$(cat package.json 2>/dev/null)
--- package.json scripts ---
$(jq -r '.scripts | to_entries[] | "- \(.key): \(.value)"' package.json 2>/dev/null)
--- Directory structure (max 80 files) ---
$CACHED_FILES
--- ESLint Config ---
$(cat eslint.config.* .eslintrc* 2>/dev/null | head -100)
--- Prettier Config ---
$(cat .prettierrc* 2>/dev/null)
--- CLAUDE.md (current) ---
$(cat CLAUDE.md 2>/dev/null)
--- AGENTS.md (current) ---
$(cat AGENTS.md 2>/dev/null)"

    # Extended context for project context generation
    CTX_PKG=$(cat package.json 2>/dev/null || echo "No package.json")
    CTX_TSCONFIG=$(cat tsconfig.*.json 2>/dev/null; [ -f tsconfig.json ] && cat tsconfig.json 2>/dev/null || echo "No tsconfig")
    CTX_TSCONFIG=$(echo "$CTX_TSCONFIG" | head -80)
    CTX_DIRS=$(find . -maxdepth 3 -type d \
      \( -name node_modules -o -name .git -o -name dist -o -name build \
         -o -name .next -o -name vendor -o -name .nuxt -o -name .output \) -prune -o \
      -type d -print 2>/dev/null | head -60)
    CTX_FILES="$CACHED_FILES"
    CTX_CONFIGS=$(ls -1 *.config.* .eslintrc* .prettierrc* tailwind.config.* \
      vite.config.* nuxt.config.* next.config.* astro.config.* \
      webpack.config.* rollup.config.* docker-compose* Dockerfile \
      Makefile Cargo.toml go.mod requirements.txt pyproject.toml \
      biome.json 2>/dev/null || echo "No config files found")
    CTX_README=$(head -50 README.md 2>/dev/null || echo "No README")

    # Sample source files (generic: first 3 project files)
    CTX_SAMPLE=""
    for f in $(echo "$CACHED_FILES" | head -3); do
      CTX_SAMPLE+="
--- $f (first 50 lines) ---
$(head -50 "$f" 2>/dev/null)"
    done

    # Temp files for error capture (cleaned up on exit/interrupt)
    ERR_CM=$(mktemp)
    ERR_AM=$(mktemp)
    ERR_CTX=$(mktemp)
    trap "rm -f '$ERR_CM' '$ERR_AM' '$ERR_CTX'" RETURN

    # Detect test framework for conditional TDD rule
    HAS_TESTS=""
    if cat package.json 2>/dev/null | grep -qE '"(jest|vitest|mocha|jasmine|ava)"'; then
      HAS_TESTS="jest/vitest/mocha"
    elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] && grep -q "pytest" pyproject.toml 2>/dev/null; then
      HAS_TESTS="pytest"
    elif [ -f "requirements.txt" ] && grep -qi "pytest" requirements.txt 2>/dev/null; then
      HAS_TESTS="pytest"
    fi

    TDD_INSTRUCTION=""
    if [ -n "$HAS_TESTS" ]; then
      TDD_INSTRUCTION="
## TDD Workflow ($HAS_TESTS detected)
If a test framework is present, add a 'TDD Workflow' subsection under Critical Rules:
- Before implementing ANY logic, write a failing test first (Red)
- Implement minimum code to make the test pass (Green)
- Refactor if needed, keep tests green (Refactor)
- Never write implementation code without a test first"
    fi

    # Step 1a: Extend CLAUDE.md (sonnet, background)
    PID_CM=""
    PID_AM=""
    CLAUDE_MD_BEFORE=""
    AGENTS_MD_BEFORE=""

    if [ "$REGEN_CLAUDE_MD" = "yes" ]; then
      if [ ! -f CLAUDE.md ] && [ -f "$SCRIPT_DIR/templates/CLAUDE.md" ]; then
        cp "$SCRIPT_DIR/templates/CLAUDE.md" CLAUDE.md
      fi
      CLAUDE_MD_BEFORE=$(cksum CLAUDE.md 2>/dev/null || echo "none")

      claude -p --model claude-sonnet-4-6 --permission-mode acceptEdits --max-turns 3 "IMPORTANT: All project context is provided below. Do NOT read any files. Directly edit CLAUDE.md in a single turn.

Replace the ## Commands and ## Critical Rules sections in CLAUDE.md (remove any HTML comments in those sections).

## Commands
Based on the package.json scripts below, document the most important ones (dev, build, lint, test, etc.) as a bullet list.

## Critical Rules
Based on the eslint/prettier config below and the framework/system ($SYSTEM), write concrete, actionable rules. Max 5 sections, 3-5 bullet points each.
Cover these categories where evidence exists: code style (formatting, naming), TypeScript (strict mode, type patterns), imports (path aliases, barrel files), framework-specific (SSR, routing, state), testing (commands, patterns). Omit categories where no evidence exists in the config — do not fabricate rules.
$TDD_INSTRUCTION
$SHOPWARE_RULE

Rules:
- Edit CLAUDE.md directly. Replace both sections including any <!-- comments -->.
- No umlauts. English only.
- Keep CLAUDE.md content stable and static — it is a prompt cache layer. Do not add timestamps, random IDs, or session-specific data.

$CONTEXT
$CTX_SHOPWARE" >"$ERR_CM" 2>&1 &
      PID_CM=$!
    fi

    # Step 1b: Extend AGENTS.md (sonnet, background, parallel with CLAUDE.md)
    if [ "$REGEN_AGENTS_MD" = "yes" ]; then
      if [ ! -f AGENTS.md ] && [ -f "$SCRIPT_DIR/templates/AGENTS.md" ]; then
        cp "$SCRIPT_DIR/templates/AGENTS.md" AGENTS.md
      fi
      AGENTS_MD_BEFORE=$(cksum AGENTS.md 2>/dev/null || echo "none")

      claude -p --model claude-sonnet-4-6 --permission-mode acceptEdits --max-turns 3 "IMPORTANT: All project context is provided below. Do NOT read any files. Directly edit AGENTS.md in a single turn.

Replace the ## Project Overview, ## Architecture Summary, ## Commands, and ## Critical Rules sections in AGENTS.md (remove any HTML comments in those sections).

## Project Overview
Write 4-6 concise bullet points: project purpose, main system/framework ($SYSTEM), runtime/language, key dependencies, and delivery/runtime context if available.

## Architecture Summary
Write 4-6 concise bullet points covering entry points, directory layout, data flow, and important boundaries.

## Commands
Based on package.json scripts, list the most important commands (dev, build, lint, test, etc.) with a short description.

## Critical Rules
Based on eslint/prettier and detected framework/system ($SYSTEM), write actionable engineering rules.
Max 5 sections, 3-5 bullet points each.
Cover categories only if evidence exists: formatting/naming, typing patterns, imports/module boundaries, framework conventions, testing.
$TDD_INSTRUCTION

Rules:
- Edit AGENTS.md directly. Replace all four sections including any <!-- comments -->.
- Keep content deterministic and static; do not add timestamps, random IDs, or session-specific data.
- No umlauts. English only.

$CONTEXT
$CTX_SHOPWARE" >"$ERR_AM" 2>&1 &
      PID_AM=$!
    fi

    # Step 2: Generate project context (sonnet, background, parallel with Step 1)
    PID_CTX=""
    if [ "$REGEN_CONTEXT" = "yes" ]; then
    mkdir -p .agents/context

  claude -p --model claude-sonnet-4-6 --permission-mode acceptEdits --max-turns 4 "IMPORTANT: All project context is provided below. Do NOT read any files. Create all 3 files directly in a single turn.

Create exactly 3 files in .agents/context/ using the Write tool:

- **.agents/context/STACK.md** — runtime, framework (with versions), key dependencies (categorized: UI, state, data, testing, build), package manager, build tooling, and libraries/patterns to avoid
- **.agents/context/ARCHITECTURE.md** — project type, directory structure, entry points, data flow, key patterns
- **.agents/context/CONVENTIONS.md** — naming patterns, import style, component structure, error handling, TypeScript usage, testing patterns. Include a "## Definition of Done" section with project-appropriate quality gates derived from detected tools (e.g. linter: no lint errors, TypeScript: no explicit any/type errors, test runner: all tests green, formatter: code formatted). If a tool is not detected, omit its gate.

Project system/framework: $SYSTEM

Rules:
- Create all 3 files in one turn using the Write tool.
- Base ALL content on the provided context. Do not invent details.
- Keep each file concise: 30-60 lines max.
- Use markdown headers and bullet points.
- If information is not available, write 'Not determined from available context.'
- No umlauts. English only.
$SHOPWARE_INSTRUCTION

--- package.json ---
$CTX_PKG
--- tsconfig ---
$CTX_TSCONFIG
--- Directory tree ---
$CTX_DIRS
--- File list ---
$CTX_FILES
--- Config files present ---
$CTX_CONFIGS
--- README (first 50 lines) ---
$CTX_README
--- Sample source files ---
$CTX_SAMPLE
$CTX_SHOPWARE" >"$ERR_CTX" 2>&1 &
    PID_CTX=$!
    fi

    # Wait for background processes
    WAIT_ARGS=()
    [ -n "$PID_CM" ] && WAIT_ARGS+=("$PID_CM:CLAUDE.md:30:120")
    [ -n "$PID_AM" ] && WAIT_ARGS+=("$PID_AM:AGENTS.md:30:120")
    [ -n "$PID_CTX" ] && WAIT_ARGS+=("$PID_CTX:Project context:45:180")
    echo ""
    [ ${#WAIT_ARGS[@]} -gt 0 ] && wait_parallel "${WAIT_ARGS[@]}"

    # Verify Step 1a: CLAUDE.md was actually modified
    if [ -n "$PID_CM" ]; then
    EXIT_CM=0
    wait "$PID_CM" 2>/dev/null || EXIT_CM=$?
    CLAUDE_MD_AFTER=$(cksum CLAUDE.md 2>/dev/null || echo "none")
    if [ "$EXIT_CM" -ne 0 ] || [ "$CLAUDE_MD_BEFORE" = "$CLAUDE_MD_AFTER" ]; then
      regen_failed=1
      echo ""
      echo "  ⚠️  CLAUDE.md was not updated (exit code $EXIT_CM)."
      if [ -s "$ERR_CM" ]; then
        echo "  Output: $(tail -5 "$ERR_CM")"
      fi
      echo "  Fix: Run 'claude' in your terminal to check authentication, then re-run."
    fi
    fi

    # Verify Step 1b: AGENTS.md was actually modified
    if [ -n "$PID_AM" ]; then
    EXIT_AM=0
    wait "$PID_AM" 2>/dev/null || EXIT_AM=$?
    AGENTS_MD_AFTER=$(cksum AGENTS.md 2>/dev/null || echo "none")
    if [ "$EXIT_AM" -ne 0 ] || [ "$AGENTS_MD_BEFORE" = "$AGENTS_MD_AFTER" ]; then
      regen_failed=1
      echo ""
      echo "  ⚠️  AGENTS.md was not updated (exit code $EXIT_AM)."
      if [ -s "$ERR_AM" ]; then
        echo "  Output: $(tail -5 "$ERR_AM")"
      fi
      echo "  Fix: Run 'claude' in your terminal to check authentication, then re-run."
    fi
    fi

    # Verify Step 2: context files were created
    if [ -n "$PID_CTX" ]; then
    EXIT_CTX=0
    wait "$PID_CTX" 2>/dev/null || EXIT_CTX=$?
    CTX_COUNT=0
    [ -f .agents/context/STACK.md ] && CTX_COUNT=$((CTX_COUNT + 1))
    [ -f .agents/context/ARCHITECTURE.md ] && CTX_COUNT=$((CTX_COUNT + 1))
    [ -f .agents/context/CONVENTIONS.md ] && CTX_COUNT=$((CTX_COUNT + 1))

    if [ "$CTX_COUNT" -eq 3 ]; then
      echo "  ✅ All 3 context files created in .agents/context/"
    elif [ "$CTX_COUNT" -gt 0 ]; then
      regen_failed=1
      echo "  ⚠️  $CTX_COUNT of 3 context files created (partial, exit code $EXIT_CTX)"
      if [ -s "$ERR_CTX" ]; then
        echo "  Output: $(tail -5 "$ERR_CTX")"
      fi
    else
      regen_failed=1
      echo "  ⚠️  Context generation failed (exit code $EXIT_CTX)."
      if [ -s "$ERR_CTX" ]; then
        echo "  Output: $(tail -5 "$ERR_CTX")"
      fi
      echo "  Fix: Check 'claude' works, then run: npx @onedot/ai-setup --regenerate"
    fi
    fi

    # Save state for freshness detection
    STATE_FILE=".agents/context/.state"
    if [ -d ".agents/context" ]; then
      echo "PKG_HASH=$(cksum package.json 2>/dev/null | cut -d' ' -f1,2)" > "$STATE_FILE"
      echo "TSCONFIG_HASH=$(cksum tsconfig.json 2>/dev/null | cut -d' ' -f1,2)" >> "$STATE_FILE"
      echo "DIR_HASH=$(echo "$CACHED_FILES" | cksum | cut -d' ' -f1,2)" >> "$STATE_FILE"
      echo "GENERATED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$STATE_FILE"
      if [ "$SYSTEM" = "shopware" ] && [ -f composer.json ]; then
        echo "COMPOSER_HASH=$(cksum composer.json 2>/dev/null | cut -d' ' -f1,2)" >> "$STATE_FILE"
        echo "SHOPWARE_TYPE=$SHOPWARE_TYPE" >> "$STATE_FILE"
      fi
    fi
  else
    echo "⏭️  Skipping AI context generation (not selected)."
  fi

  # Step 3: Search and install skills (AI-curated, haiku for ranking)
  if [ "$REGEN_SKILLS" = "yes" ]; then
  # Ensure bundled Shopify skills are present when relevant.
  if [[ "${SYSTEM:-}" == *shopify* ]]; then
    for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
      local tpl="${mapping%%:*}"
      local target="${mapping#*:}"
      if [ -f "$SCRIPT_DIR/$tpl" ]; then
        mkdir -p "$(dirname "$target")"
        cp "$SCRIPT_DIR/$tpl" "$target"
      fi
    done
  fi

  echo ""
  echo "🔌 Searching and installing skills..."
  INSTALLED=0
  SKIPPED=0

  KEYWORDS=()
  if [ -f package.json ]; then
    DEPS=$(jq -r '(.dependencies // {} | keys[]) , (.devDependencies // {} | keys[])' package.json 2>/dev/null | sort -u)

    for dep in $DEPS; do
      case "$dep" in
        # Frontend frameworks (specific patterns before general globs)
        vue|vue-router|@vue/*) [[ ! " ${KEYWORDS[*]} " =~ " vue " ]] && KEYWORDS+=("vue") ;;
        @nuxt/ui|@nuxt/ui-pro) [[ ! " ${KEYWORDS[*]} " =~ " nuxt-ui " ]] && KEYWORDS+=("nuxt-ui") ;;
        nuxt|@nuxt/*) [[ ! " ${KEYWORDS[*]} " =~ " nuxt " ]] && KEYWORDS+=("nuxt") ;;
        react|react-dom|@react/*) [[ ! " ${KEYWORDS[*]} " =~ " react " ]] && KEYWORDS+=("react") ;;
        next|@next/*) [[ ! " ${KEYWORDS[*]} " =~ " next " ]] && KEYWORDS+=("next") ;;
        svelte|@sveltejs/*) [[ ! " ${KEYWORDS[*]} " =~ " svelte " ]] && KEYWORDS+=("svelte") ;;
        astro|@astrojs/*) [[ ! " ${KEYWORDS[*]} " =~ " astro " ]] && KEYWORDS+=("astro") ;;
        # UI libraries
        tailwindcss|@tailwindcss/*) [[ ! " ${KEYWORDS[*]} " =~ " tailwind " ]] && KEYWORDS+=("tailwind") ;;
        @shadcn/*|shadcn-ui) [[ ! " ${KEYWORDS[*]} " =~ " shadcn " ]] && KEYWORDS+=("shadcn") ;;
        @radix-ui/*) [[ ! " ${KEYWORDS[*]} " =~ " radix " ]] && KEYWORDS+=("radix") ;;
        @headlessui/*) [[ ! " ${KEYWORDS[*]} " =~ " headless-ui " ]] && KEYWORDS+=("headless-ui") ;;
        reka-ui) [[ ! " ${KEYWORDS[*]} " =~ " reka-ui " ]] && KEYWORDS+=("reka-ui") ;;
        primevue|@primevue/*) [[ ! " ${KEYWORDS[*]} " =~ " primevue " ]] && KEYWORDS+=("primevue") ;;
        vuetify) [[ ! " ${KEYWORDS[*]} " =~ " vuetify " ]] && KEYWORDS+=("vuetify") ;;
        element-plus) [[ ! " ${KEYWORDS[*]} " =~ " element-plus " ]] && KEYWORDS+=("element-plus") ;;
        quasar|@quasar/*) [[ ! " ${KEYWORDS[*]} " =~ " quasar " ]] && KEYWORDS+=("quasar") ;;
        # Languages & runtimes
        typescript) [[ ! " ${KEYWORDS[*]} " =~ " typescript " ]] && KEYWORDS+=("typescript") ;;
        # Backend
        express) [[ ! " ${KEYWORDS[*]} " =~ " express " ]] && KEYWORDS+=("express") ;;
        @nestjs/*) [[ ! " ${KEYWORDS[*]} " =~ " nestjs " ]] && KEYWORDS+=("nestjs") ;;
        @hono/*|hono) [[ ! " ${KEYWORDS[*]} " =~ " hono " ]] && KEYWORDS+=("hono") ;;
        # E-commerce
        @shopify/*|shopify-*) [[ ! " ${KEYWORDS[*]} " =~ " shopify " ]] && KEYWORDS+=("shopify") ;;
        @angular/*|angular) [[ ! " ${KEYWORDS[*]} " =~ " angular " ]] && KEYWORDS+=("angular") ;;
        # Databases & ORMs
        prisma|@prisma/*) [[ ! " ${KEYWORDS[*]} " =~ " prisma " ]] && KEYWORDS+=("prisma") ;;
        drizzle-orm|drizzle-kit) [[ ! " ${KEYWORDS[*]} " =~ " drizzle " ]] && KEYWORDS+=("drizzle") ;;
        # BaaS
        supabase|@supabase/*) [[ ! " ${KEYWORDS[*]} " =~ " supabase " ]] && KEYWORDS+=("supabase") ;;
        firebase|@firebase/*|firebase-admin) [[ ! " ${KEYWORDS[*]} " =~ " firebase " ]] && KEYWORDS+=("firebase") ;;
        # Testing
        vitest) [[ ! " ${KEYWORDS[*]} " =~ " vitest " ]] && KEYWORDS+=("vitest") ;;
        playwright|@playwright/*) [[ ! " ${KEYWORDS[*]} " =~ " playwright " ]] && KEYWORDS+=("playwright") ;;
        # State management
        pinia) [[ ! " ${KEYWORDS[*]} " =~ " pinia " ]] && KEYWORDS+=("pinia") ;;
        @tanstack/*) [[ ! " ${KEYWORDS[*]} " =~ " tanstack " ]] && KEYWORDS+=("tanstack") ;;
        zustand) [[ ! " ${KEYWORDS[*]} " =~ " zustand " ]] && KEYWORDS+=("zustand") ;;
      esac
    done

    if [ ${#KEYWORDS[@]} -eq 0 ]; then
      echo "  No technologies detected."
    else
      echo "  Detected: ${KEYWORDS[*]}"

      ALL_SKILLS=""
      SEARCH_TMPDIR=$(mktemp -d)
      declare -a SEARCH_PIDS=()
      declare -a SEARCH_KWS=()

      for kw in "${KEYWORDS[@]}"; do
        # Skip keywords with curated skills — installed directly via KEYWORD_SKILLS below
        if [ -n "$(get_keyword_skills "$kw")" ]; then
          printf "  ✅ %-20s (curated)\n" "$kw:"
          continue
        fi
        printf "  🔍 Searching: %s ...\n" "$kw"
        SEARCH_KWS+=("$kw")
        (
          FOUND=$(search_skills "$kw")
          # Retry once on failure
          if [ -z "$FOUND" ]; then
            sleep 1
            FOUND=$(search_skills "$kw")
          fi
          echo "$FOUND" > "$SEARCH_TMPDIR/$(printf '%s' "$kw" | tr -cd 'a-zA-Z0-9_-')"
        ) &
        SEARCH_PIDS+=($!)
      done

      # Wait for all parallel searches to complete
      for pid in "${SEARCH_PIDS[@]}"; do
        wait "$pid" 2>/dev/null || true
      done

      # Collect results in keyword order
      for kw in "${SEARCH_KWS[@]}"; do
        SAFE_KW=$(printf '%s' "$kw" | tr -cd 'a-zA-Z0-9_-')
        FOUND=$(cat "$SEARCH_TMPDIR/$SAFE_KW" 2>/dev/null || true)
        if [ -n "$FOUND" ]; then
          COUNT=$(printf '%s\n' "$FOUND" | wc -l | tr -d ' ')
          printf "  ✅ %-20s %s skills found\n" "$kw:" "$COUNT"
          ALL_SKILLS="${ALL_SKILLS}${FOUND}"$'\n'
        else
          printf "  ⚠️  %-20s no skills found\n" "$kw:"
        fi
      done
      rm -rf "$SEARCH_TMPDIR"

      # Remove duplicates
      ALL_SKILLS=$(echo "$ALL_SKILLS" | sort -u | sed '/^$/d')

      if [ -n "$ALL_SKILLS" ]; then
        TOTAL_FOUND=$(echo "$ALL_SKILLS" | wc -l | tr -d ' ')

        # Cache search results for fallback
        ALL_SKILLS_CACHE=$(mktemp)
        echo "$ALL_SKILLS" > "$ALL_SKILLS_CACHE"

        # Phase 1.5: Fetch weekly install counts from skills.sh (parallel)
        echo ""
        echo "  📊 Fetching popularity metrics from skills.sh..."
        echo "     (Used to rank skills by real-world usage)"
        INSTALLS_DIR=$(mktemp -d)
        while IFS= read -r sid; do
          if [ -n "$sid" ]; then
            # Cap parallel curl jobs at 8 to avoid overwhelming the server
            while (( $(jobs -r 2>/dev/null | wc -l) >= 8 )); do sleep 0.1; done
            URL_PATH="${sid/@//}"
            (
              COUNT=$(curl -s --max-time 5 "https://skills.sh/$URL_PATH" 2>/dev/null \
                | grep -oE '[0-9]+\.[0-9]+K|[0-9]+K' | head -1)
              SAFE_SID="${sid//\//_}"
              echo "${COUNT:-0}" > "$INSTALLS_DIR/${SAFE_SID//@/_at_}"
            ) &
          fi
        done <<< "$ALL_SKILLS"
        wait

        # Build skills list with install counts
        SKILLS_WITH_COUNTS=""
        while IFS= read -r sid; do
          if [ -n "$sid" ]; then
            SAFE_NAME="${sid//\//_}"
            SAFE_NAME="${SAFE_NAME//@/_at_}"
            COUNT=$(cat "$INSTALLS_DIR/$SAFE_NAME" 2>/dev/null || echo "0")
            SKILLS_WITH_COUNTS="${SKILLS_WITH_COUNTS}${sid} (${COUNT} weekly installs)"$'\n'
          fi
        done <<< "$ALL_SKILLS"
        rm -rf "$INSTALLS_DIR"

        echo "  🤖 Claude selecting best skills ($TOTAL_FOUND found)..."

        # Phase 2: Claude selects the most relevant skills (haiku, 60s timeout)
        CLAUDE_TMP=$(mktemp)
        claude -p --model haiku --max-turns 1 "You are a skill curator for AI coding agents. Select the best skills for this project.

Project technologies: ${KEYWORDS[*]}

Available skills (with weekly install counts from skills.sh):
$SKILLS_WITH_COUNTS

Rules:
- Select EXACTLY the top 5 most relevant skills (or fewer if less available)
- Prefer skills with HIGHER install counts (more popular = better quality)
- Avoid duplicates (e.g. not 3x vue-best-practices from different authors)
- Prefer skills from well-known maintainers (antfu, vercel-labs, vuejs-ai, etc.)
- Reply ONLY with skill IDs, one per line, no other text. Format: owner/repo@skill-name" > "$CLAUDE_TMP" 2>/dev/null &
        CLAUDE_PID=$!
        CLAUDE_WAIT=0
        while kill -0 "$CLAUDE_PID" 2>/dev/null && [ "$CLAUDE_WAIT" -lt 60 ]; do
          sleep 1
          CLAUDE_WAIT=$((CLAUDE_WAIT + 1))
        done
        if kill -0 "$CLAUDE_PID" 2>/dev/null; then
          kill_tree "$CLAUDE_PID"
          echo "  ⚠️  Claude timed out (${CLAUDE_WAIT}s). Using fallback..."
          SELECTED=""
        else
          wait "$CLAUDE_PID" 2>/dev/null || true
          SELECTED=$(cat "$CLAUDE_TMP")
        fi
        rm -f "$CLAUDE_TMP"

        if [ -n "$SELECTED" ]; then
          # Extract only valid skill IDs, clean whitespace, strip backticks, enforce max 5
          SELECTED=$(echo "$SELECTED" \
            | sed 's/`//g' \
            | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
            | grep -E '^[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+@[a-zA-Z0-9_.-]+$' \
            | sort -u \
            | head -5)
        fi

        if [ -n "$SELECTED" ]; then
          SELECTED_COUNT=$(printf '%s\n' "$SELECTED" | wc -l | tr -d ' ')
          echo "  ✨ $SELECTED_COUNT skills selected:"
          echo ""

          # Phase 3: Install selected skills in parallel (30s timeout per install)
          INSTALL_TMPDIR=$(mktemp -d)
          declare -a INSTALL_PIDS=()
          declare -a INSTALL_IDS=()
          while IFS= read -r skill_id; do
            # Trim whitespace via parameter expansion (no subshell)
            skill_id="${skill_id#"${skill_id%%[! ]*}"}"
            skill_id="${skill_id%"${skill_id##*[! ]}"}"
            if [ -n "$skill_id" ]; then
              INSTALL_IDS+=("$skill_id")
              (
                install_skill "$skill_id"
                echo $? > "$INSTALL_TMPDIR/$(printf '%s' "$skill_id" | tr -cd 'a-zA-Z0-9_-').exit"
              ) &
              INSTALL_PIDS+=($!)
            fi
          done <<< "$SELECTED"

          # Wait for all installs to finish
          for pid in "${INSTALL_PIDS[@]}"; do
            wait "$pid" 2>/dev/null || true
          done

          # Tally results
          for sid in "${INSTALL_IDS[@]}"; do
            SAFE_ID=$(printf '%s' "$sid" | tr -cd 'a-zA-Z0-9_-')
            EXIT_CODE=$(cat "$INSTALL_TMPDIR/${SAFE_ID}.exit" 2>/dev/null || echo "1")
            if [ "$EXIT_CODE" = "0" ]; then
              INSTALLED=$((INSTALLED + 1))
            fi
          done
          rm -rf "$INSTALL_TMPDIR"
          echo ""
          if [ $SKIPPED -gt 0 ]; then
            echo "  Total: $INSTALLED installed, $SKIPPED skipped (already present)"
          else
            echo "  Total: $INSTALLED skills installed"
          fi
        else
          echo "  ⚠️  Claude could not select skills. Installing top 3 per technology..."
          # Fallback: Top 3 per keyword using cached results
          for kw in "${KEYWORDS[@]}"; do
            SKILL_IDS=$(grep -iE "$kw" "$ALL_SKILLS_CACHE" 2>/dev/null | head -3)
            if [ -n "$SKILL_IDS" ]; then
              while IFS= read -r skill_id; do
                # Trim whitespace via parameter expansion (no subshell)
                skill_id="${skill_id#"${skill_id%%[! ]*}"}"
                skill_id="${skill_id%"${skill_id##*[! ]}"}"
                if [ -n "$skill_id" ]; then
                  install_skill "$skill_id" && INSTALLED=$((INSTALLED + 1))
                fi
              done <<< "$SKILL_IDS"
            fi
          done
          echo ""
          if [ $SKIPPED -gt 0 ]; then
            echo "  Total: $INSTALLED installed, $SKIPPED skipped (fallback)"
          else
            echo "  Total: $INSTALLED skills installed (fallback)"
          fi
        fi
        rm -f "$ALL_SKILLS_CACHE"
      fi
    fi
  else
    echo "  No package.json found."
  fi

  # System-specific default skills (always installed for known systems)
  # Support multiple systems (comma-separated)
  SYSTEM_SKILLS=()
  IFS=',' read -ra SYSTEMS <<< "$SYSTEM"
  for sys in "${SYSTEMS[@]}"; do
    case "$sys" in
      shopify)
        SYSTEM_SKILLS+=(
          "sickn33/antigravity-awesome-skills@shopify-development"
          "jeffallan/claude-skills@shopify-expert"
          "henkisdabro/wookstar-claude-code-plugins@shopify-theme-dev"
        ) ;;
      nuxt)
        SYSTEM_SKILLS+=(
          "antfu/skills@nuxt"
          "onmax/nuxt-skills@nuxt"
          "onmax/nuxt-skills@vue"
          "onmax/nuxt-skills@vueuse"
          "vuejs-ai/skills@vue-best-practices"
          "vuejs-ai/skills@vue-testing-best-practices"
        )
        # Only add nuxt-ui skill if project actually uses it
        if [[ " ${KEYWORDS[*]} " =~ " nuxt-ui " ]]; then
          SYSTEM_SKILLS+=("nuxt/ui@nuxt-ui")
        fi
        ;;
      next)
        SYSTEM_SKILLS+=(
          "vercel-labs/agent-skills@vercel-react-best-practices"
          "vercel-labs/next-skills@next-best-practices"
          "vercel-labs/next-skills@next-cache-components"
          "jeffallan/claude-skills@nextjs-developer"
          "wshobson/agents@nextjs-app-router-patterns"
          "sickn33/antigravity-awesome-skills@nextjs-best-practices"
        ) ;;
      laravel)
        SYSTEM_SKILLS+=(
          "jeffallan/claude-skills@laravel-specialist"
          "iserter/laravel-claude-agents@eloquent-best-practices"
        ) ;;
      shopware)
        SYSTEM_SKILLS+=(
          "bartundmett/skills@shopware6-best-practices"
        ) ;;
      storyblok)
        SYSTEM_SKILLS+=(
          "bartundmett/skills@storyblok-best-practices"
        ) ;;
    esac
  done

  # Add curated keyword-based skills (from detected package.json dependencies)
  if [ ${#KEYWORDS[@]} -gt 0 ]; then
    for kw in "${KEYWORDS[@]}"; do
      kw_skills=$(get_keyword_skills "$kw")
      if [ -n "$kw_skills" ]; then
        for sid in $kw_skills; do
          SYSTEM_SKILLS+=("$sid")
        done
      fi
    done
  fi

  if [ ${#SYSTEM_SKILLS[@]} -gt 0 ]; then
    SYSTEM_SKILLS_UNIQ=()
    while IFS= read -r sid; do
      [ -n "$sid" ] && SYSTEM_SKILLS_UNIQ+=("$sid")
    done <<EOF
$(printf '%s\n' "${SYSTEM_SKILLS[@]}" | sed '/^$/d' | sort -u)
EOF
    SYSTEM_SKILLS=("${SYSTEM_SKILLS_UNIQ[@]}")

    echo ""
    echo "  📦 Installing system-specific skills ($SYSTEM)..."

    # Install system skills in parallel; tally results after all complete
    SYS_INSTALL_TMPDIR=$(mktemp -d)
    declare -a SYS_PIDS=()

    for skill_id in "${SYSTEM_SKILLS[@]}"; do
      (
        install_skill "$skill_id"
        echo $? > "$SYS_INSTALL_TMPDIR/$(printf '%s' "$skill_id" | tr -cd 'a-zA-Z0-9_-').exit"
      ) &
      SYS_PIDS+=($!)
    done

    for pid in "${SYS_PIDS[@]}"; do
      wait "$pid" 2>/dev/null || true
    done

    for skill_id in "${SYSTEM_SKILLS[@]}"; do
      SAFE_ID=$(printf '%s' "$skill_id" | tr -cd 'a-zA-Z0-9_-')
      EXIT_CODE=$(cat "$SYS_INSTALL_TMPDIR/${SAFE_ID}.exit" 2>/dev/null || echo "1")
      if [ "$EXIT_CODE" = "0" ]; then
        INSTALLED=$((INSTALLED + 1))
      fi
    done
    rm -rf "$SYS_INSTALL_TMPDIR"
  fi
  fi # REGEN_SKILLS

  set -e
  if [ "$regen_failed" -ne 0 ]; then
    return 1
  fi
  return 0
}
````

## File: templates/commands/pr.md
````markdown
---
model: haiku
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep, Agent
---

Drafts a pull request with staff review and PR body. Use when a feature branch is ready to be submitted for review.

## Context

- Current status: `!git status`
- Unstaged changes: `!git diff`
- Commits ahead of main: `!git log --oneline main..HEAD`
- Current branch: `!git branch --show-current`

## Process

1. **Build validation**: Spawn `build-validator` via Agent tool.
   - If build-validator returns **FAIL**: stop immediately and tell the user: "Fix the build before creating a PR." Show the build output. Do not proceed.
   - If build-validator returns **PASS**: continue.
2. Analyze the changes shown in Context above to understand all modifications on this branch.
3. Stage and commit any remaining uncommitted changes (descriptive message, no `git add .`).
4. **Staff review**: Spawn `staff-reviewer` via Agent tool with the prompt:
   > "Review this branch for production readiness before PR creation. Branch: <branch-name>. Recent commits: <commits from git log --oneline main..HEAD>."
   - If staff-reviewer returns **APPROVE**: continue drafting PR normally; note "Staff review: APPROVED" in the output.
   - If staff-reviewer returns **APPROVE WITH CONCERNS**: continue drafting PR; include the concerns under `## Staff Review Concerns` in the PR body.
   - If staff-reviewer returns **REQUEST CHANGES**: stop, show the reviewer's concerns, and tell the user: "Fix the reported issues before creating the PR."
5. Draft the PR title (short, under 70 chars) and body (`## Summary` with 2-3 bullets + `## Test plan` checklist).
6. Show the user the PR details and the commands to run:
   ```
   git push -u origin <branch>
   gh pr create --title "..." --body "..."
   ```
7. Do NOT push or create the PR — the user does this manually.

## Post-PR

After presenting the PR commands to the user, suggest:
> "Run `/reflect` to capture any learnings from this session before they leave context."

## Rules
- Never push (`git push` is denied by settings).
- Never push to main/master directly.
- If the branch is `main` or `master`, stop and ask the user to create a feature branch first.
- If `gh` CLI is not installed, provide the GitHub URL for manual PR creation.
````

## File: templates/commands/spec-review.md
````markdown
---
model: opus
mode: plan
argument-hint: "[spec number]"
allowed-tools: Read, Glob, Grep, Bash, AskUserQuestion, Agent
---

Reviews spec $ARGUMENTS and its code changes against acceptance criteria. Use after spec-work to validate and close.

## Process

### 1. Find the spec
If `$ARGUMENTS` is a number (e.g. `011`), open `specs/011-*.md`. If it's a filename, open that directly. If empty, list all specs with status `in-review` in `specs/` and ask which one to review.

### 2. Validate status
The spec's status must be `in-review`. If it's `draft` or `in-progress`, report: "Spec is not ready for review (status: X). Run `/spec-work NNN` first." and stop. If it's `completed`, report: "Spec is already completed." and stop.

### 3. Read the spec
Understand Goal, Steps, Acceptance Criteria, Files to Modify, and Out of Scope. Note which steps and criteria are checked off.

### 4. Inspect code changes
Read the `**Branch**` field from the spec header. Then:

- If a branch exists (not `—`): run `git diff main...BRANCH` to see all changes on that branch
- If no branch: run `git diff` and `git diff --staged` to see uncommitted changes

For each changed file, read the full file to understand context around the changes. **Cap**: Read at most the 5 most significantly changed files in full; for remaining files, review only the diff hunks.

### 5. Review against spec

#### 5a — Spec compliance & acceptance criteria
- Are ALL steps checked off and matching what was described?
- Are acceptance criteria genuinely met (verify against diff, not checkboxes)?
- Was anything built that's listed in "Out of Scope"? Flag scope creep.

#### 5b — Definition of Done
If `.agents/context/CONVENTIONS.md` contains a `## Definition of Done` section, verify the code changes satisfy those global quality gates. Report unmet gates as blocking issues.

#### 5c — Code quality
Spawn `code-reviewer` agent via Agent tool. Pass the full spec content and branch name. Use the agent's verdict (PASS / CONCERNS / FAIL) and issue list as code quality input. Do NOT duplicate its analysis inline.

#### 5d — Quality scoring

Based on evidence from 5a–5c, score 10 metrics (0–100 each):

| # | Metric | What to check |
|---|--------|---------------|
| 1 | **Spec Compliance** | All steps implemented exactly as described? |
| 2 | **Acceptance Criteria** | Every criterion genuinely met (verified, not assumed)? |
| 3 | **Test Coverage** | New functionality has tests; existing tests still pass? |
| 4 | **Requirements Fidelity** | Implementation matches the spec goal — no drift, no gold-plating? |
| 5 | **Code Clarity** | Code is readable, named well, no magic numbers or unexplained logic? |
| 6 | **Error Handling** | Failure paths handled; no silent failures, no unguarded throws? |
| 7 | **Security** | No credentials in code, no unsafe patterns, no exposed internals? |
| 8 | **Scope Adherence** | Nothing built outside the spec; no accidental scope creep? |
| 9 | **No Regressions** | Existing functionality unaffected; no broken imports or side effects? |
| 10 | **Completeness** | No TODOs, no stubs, no placeholder comments left in the diff? |

Display the score table:

```
Quality Score — Spec NNN
─────────────────────────────────────────
 1. Spec Compliance ........... XX
 2. Acceptance Criteria ........ XX
 3. Test Coverage .............. XX
 4. Requirements Fidelity ....... XX
 5. Code Clarity ............... XX
 6. Error Handling .............. XX
 7. Security .................... XX
 8. Scope Adherence ............. XX
 9. No Regressions .............. XX
10. Completeness ................. XX
─────────────────────────────────────────
   Average: XX.X    Minimum: XX
   Threshold: 85 avg / 70 min
```

### 6. Verdict

Present the review findings + quality score, then choose exactly one:

**APPROVED** — All criteria met AND avg ≥ 85 AND no metric < 70 AND code-reviewer PASS or CONCERNS.
1. Status → `completed`, move to `specs/completed/NNN-*.md`
2. Report: "Spec NNN approved. Score: XX.X avg / XX min."

**CHANGES REQUESTED** — code-reviewer FAIL, spec failures, avg < 85, or any metric < 70.
1. Add `## Review Feedback` with failing metrics and concrete fix instructions
2. Status → `in-progress`
3. Report: "Run `/spec-work NNN` to address feedback, then `/spec-review NNN` again."

**REJECTED** — Score < 60 avg or critical security/regression issue.
1. Status → `blocked`, add `## Review Feedback` with rejection reason
2. Report why and suggest next steps.

## Rules
- Do NOT make code changes. Only review and update spec status/feedback.
- Read the actual code before commenting — never speculate.
- Focus on what matters: spec compliance and bugs over style.
- If the diff is empty (no changes found), report this and ask the user to verify.
- Never push to remote or create PRs automatically.
````

## File: lib/plugins.sh
````bash
#!/bin/bash
# Plugin & extension installation: Claude-Mem, official plugins, Context7
# Requires: $AI_CLI

PENDING_PLUGINS=""

# Legacy compatibility shim.
# GSD is intentionally optional and no longer auto-installed by ai-setup.
install_gsd() {
  echo "  🧩 GSD integration removed from default setup."
  return 0
}

# Legacy compatibility shim.
# Playwright auto-install was removed; keep function for older callers/tests.
install_playwright() {
  echo "  🎭 Playwright auto-install is deprecated and skipped."
  return 0
}

# Claude-Mem (Marketplace Plugin — persistent memory)
install_claude_mem() {
  CLAUDE_MEM_DIR="${HOME}/.claude/plugins/cache/thedotmack/claude-mem"

  if [ -d "$CLAUDE_MEM_DIR" ]; then
    echo "  🧠 Claude-Mem already installed, skipping."
  else
    # Merge extraKnownMarketplaces + enabledPlugins into .claude/settings.json
    if command -v jq &>/dev/null && [ -f .claude/settings.json ]; then
      CLAUDE_MEM_MERGE='{
        "extraKnownMarketplaces": {
          "thedotmack": {
            "source": { "source": "github", "repo": "thedotmack/claude-mem" }
          }
        },
        "enabledPlugins": {
          "claude-mem@thedotmack": true
        }
      }'
      TMP_SETTINGS=$(mktemp)
      jq --argjson merge "$CLAUDE_MEM_MERGE" '. * $merge' .claude/settings.json > "$TMP_SETTINGS" && mv "$TMP_SETTINGS" .claude/settings.json
      echo "  🧠 Claude-Mem marketplace registered in .claude/settings.json"
    fi

    # Try CLI install (works if claude is available)
    if command -v claude &>/dev/null; then
      echo "  🧠 Attempting Claude-Mem install via CLI..."
      if claude plugin install claude-mem@thedotmack --scope project 2>/dev/null; then
        echo "  ✅ Claude-Mem installed via CLI"
      else
        PENDING_PLUGINS="${PENDING_PLUGINS}claude-mem "
        echo "  📋 Claude-Mem registered — will be prompted on next Claude Code session"
      fi
    else
      PENDING_PLUGINS="${PENDING_PLUGINS}claude-mem "
      echo "  📋 Claude-Mem registered — teammates will be prompted to install when they trust this project"
    fi
  fi
}

# CodeRabbit Claude Plugin (Marketplace Plugin — PR review companion)
install_coderabbit_plugin() {
  CODERABBIT_DIR="${HOME}/.claude/plugins/cache/coderabbitai/claude-plugin"

  if [ -d "$CODERABBIT_DIR" ]; then
    echo "  🐇 CodeRabbit plugin already installed, skipping."
    return 0
  fi

  # Merge marketplace + enabled plugin hints into project settings.
  if command -v jq &>/dev/null && [ -f .claude/settings.json ]; then
    CODERABBIT_MERGE='{
      "extraKnownMarketplaces": {
        "coderabbitai": {
          "source": { "source": "github", "repo": "coderabbitai/claude-plugin" }
        }
      },
      "enabledPlugins": {
        "claude-plugin@coderabbitai": true
      }
    }'
    TMP_SETTINGS=$(mktemp)
    jq --argjson merge "$CODERABBIT_MERGE" '. * $merge' .claude/settings.json > "$TMP_SETTINGS" && mv "$TMP_SETTINGS" .claude/settings.json
    echo "  🐇 CodeRabbit marketplace registered in .claude/settings.json"
  fi

  # Try CLI install (first marketplace id, then full repo fallback).
  if command -v claude &>/dev/null; then
    echo "  🐇 Attempting CodeRabbit plugin install via CLI..."
    if claude plugin install claude-plugin@coderabbitai --scope project 2>/dev/null || \
       claude plugin install coderabbitai/claude-plugin --scope project 2>/dev/null; then
      echo "  ✅ CodeRabbit plugin installed via CLI"
    else
      PENDING_PLUGINS="${PENDING_PLUGINS}coderabbit-plugin "
      echo "  📋 CodeRabbit plugin registered — will be prompted on next Claude Code session"
    fi
  else
    PENDING_PLUGINS="${PENDING_PLUGINS}coderabbit-plugin "
    echo "  📋 CodeRabbit plugin registered — teammates will be prompted to install when they trust this project"
  fi
}

# Official Claude Code Plugins (code-review, feature-dev, etc.)
install_official_plugins() {
  OFFICIAL_PLUGINS=(
    "code-review:Automated PR review with 4 parallel agents + confidence scoring"
    "feature-dev:7-phase feature workflow (discovery → architecture → review)"
    "frontend-design:Anti-generic design guidance for frontend projects"
  )

  INSTALLED_PLUGINS=""
  for i in "${!OFFICIAL_PLUGINS[@]}"; do
    IFS=':' read -r PNAME PDESC <<< "${OFFICIAL_PLUGINS[$i]}"

    # Check if already installed (plugin cache or .claude/settings.json)
    if [ -d "${HOME}/.claude/plugins/cache/anthropics/${PNAME}" ] 2>/dev/null; then
      echo "  🔌 ${PNAME} already installed, skipping."
      continue
    fi

    # Try CLI install
    if command -v claude &>/dev/null; then
      echo "  🔌 Installing ${PNAME}..."
      if claude plugin install "${PNAME}" --scope project 2>/dev/null; then
        INSTALLED_PLUGINS="${INSTALLED_PLUGINS}${PNAME} "
        echo "  ✅ ${PNAME} installed"
      else
        PENDING_PLUGINS="${PENDING_PLUGINS}${PNAME} "
        echo "  📋 ${PNAME} — install manually: /plugin install ${PNAME}"
      fi
    else
      PENDING_PLUGINS="${PENDING_PLUGINS}${PNAME} "
      echo "  📋 ${PNAME} — install manually: /plugin install ${PNAME}"
    fi
  done
}

# Context7 MCP Server (up-to-date library docs)
install_context7() {
  # Create or merge .mcp.json
  CTX7_CONFIG='{"mcpServers":{"context7":{"command":"npx","args":["-y","@upstash/context7-mcp"]}}}'

  if [ -f .mcp.json ]; then
    if grep -q '"context7"' .mcp.json 2>/dev/null; then
      echo "  📚 Context7 already configured in .mcp.json, skipping."
    elif command -v jq &>/dev/null; then
      TMP_MCP=$(mktemp)
      jq --argjson ctx "$CTX7_CONFIG" '.mcpServers += $ctx.mcpServers' .mcp.json > "$TMP_MCP" && mv "$TMP_MCP" .mcp.json
      echo "  📚 Context7 MCP server added to .mcp.json"
    else
      echo "  ⚠️  .mcp.json exists but jq not available to merge. Add manually."
    fi
  else
    echo "$CTX7_CONFIG" | jq '.' > .mcp.json 2>/dev/null || echo "$CTX7_CONFIG" > .mcp.json
    echo "  📚 Context7 MCP server configured in .mcp.json"
  fi

  # Add Context7 rule to CLAUDE.md
  if [ -f CLAUDE.md ] && ! grep -q "context7" CLAUDE.md 2>/dev/null; then
    cat >> CLAUDE.md << 'CTX7EOF'

## Documentation Lookup
Always use Context7 MCP when you need library/API documentation, code generation,
setup or configuration steps. Add "use context7" to prompts or it will be auto-invoked.
CTX7EOF
    echo "  📚 Context7 rule added to CLAUDE.md"
  fi
}

# Show pending plugin install instructions
show_plugin_summary() {
  if [ -n "$PENDING_PLUGINS" ]; then
    echo ""
    echo "  ⚡ Pending plugin installations (run in a Claude Code session):"
    for PP in $PENDING_PLUGINS; do
      case "$PP" in
        claude-mem)
          echo "     /plugin marketplace add thedotmack/claude-mem"
          echo "     /plugin install claude-mem"
          ;;
        coderabbit-plugin)
          echo "     /plugin marketplace add coderabbitai/claude-plugin"
          echo "     /plugin install claude-plugin@coderabbitai"
          echo "     # fallback:"
          echo "     /plugin install coderabbitai/claude-plugin"
          ;;
        *)
          echo "     /plugin install ${PP}"
          ;;
      esac
    done
    echo ""
    echo "  Then restart Claude Code."
  fi
}

# Show installation summary
show_installation_summary() {
  echo ""
  echo "🎉 AI Setup complete! Your project is ready for AI-assisted development."
  echo ""
  echo "📦 Installation Summary"
  echo "   ──────────────────────────────────────────────────────────"
  echo ""
  echo "✅ Files created:"
  [ -f CLAUDE.md ] && echo "   - CLAUDE.md (project rules)"
  [ -f AGENTS.md ] && echo "   - AGENTS.md (universal passive agent context)"
  [ -f .claude/settings.json ] && echo "   - .claude/settings.json (permissions)"
  [ -f .github/copilot-instructions.md ] && echo "   - .github/copilot-instructions.md"
  echo "   - .claude/hooks/ (protect-files, post-edit-lint, circuit-breaker, context-freshness, update-check)"
  [ -f .mcp.json ] && echo "   - .mcp.json (MCP server config)"
  [ -d specs ] && echo "   - specs/ (spec-driven workflow)"
  [ -d .claude/commands ] && echo "   - .claude/commands/ (spec, spec-work, commit, pr, review, test, techdebt, bug, grill)"
  [ -d .claude/agents ] && echo "   - .claude/agents/ (verify-app, build-validator, staff-reviewer, context-refresher, code-reviewer, code-architect, perf-reviewer, test-generator)"

  echo ""
  echo "✅ Tools & Plugins:"
  local CLAUDE_MEM_DIR="${HOME}/.claude/plugins/cache/thedotmack/claude-mem"
  if [ -d "$CLAUDE_MEM_DIR" ]; then
    echo "   - Claude-Mem (persistent memory) ✅"
  else
    echo "   - Claude-Mem (pending — run install commands in Claude Code)"
  fi
  local CODERABBIT_DIR="${HOME}/.claude/plugins/cache/coderabbitai/claude-plugin"
  if [ -d "$CODERABBIT_DIR" ]; then
    echo "   - CodeRabbit plugin ✅"
  else
    echo "   - CodeRabbit plugin (pending — run install commands in Claude Code)"
  fi
  [ -n "${INSTALLED_PLUGINS:-}" ] && echo "   - Plugins: ${INSTALLED_PLUGINS}"
  [ -f .mcp.json ] && echo "   - Context7 MCP server (.mcp.json)"
  if [ -n "$PENDING_PLUGINS" ]; then
    echo "   - ⚠️  Pending plugins: ${PENDING_PLUGINS}(see install commands above)"
  fi

  if [ "$AI_CLI" = "claude" ] && [[ ! "${RUN_INIT:-N}" =~ ^[Nn]$ ]]; then
    echo ""
    if [ "${AUTO_INIT_OK:-yes}" = "yes" ]; then
      echo "✅ Auto-Init completed (System: ${SYSTEM:-not set}):"
      echo "   - CLAUDE.md + AGENTS.md extended with project-specific sections"
      [ -d .agents/context ] && echo "   - .agents/context/ (STACK.md, ARCHITECTURE.md, CONVENTIONS.md)"
      if [ ${INSTALLED:-0} -gt 0 ]; then
        echo "   - ${INSTALLED} skills installed"
      fi
    else
      echo "⚠️  Auto-Init finished with warnings — review output above."
    fi
  fi

  echo ""
  echo "📂 Project structure ready for AI development"
}

# Show next steps and cheat sheet
show_next_steps() {
  echo ""
  echo "🎯 Next Steps"
  echo "   ──────────────────────────────────────────────────────────"
  echo ""
  echo "Start a Claude Code session and begin working."
  echo "Your project context, CLAUDE.md, and AGENTS.md are ready."
  echo ""
  echo "Spec-driven workflow:"
  echo "  /spec \"task description\"    Create a structured spec before coding"
  echo "  /spec-work 001              Execute a spec step by step"
  echo ""
  echo "To regenerate context files later:"
  echo "  npx @onedot/ai-setup --regenerate"

  echo ""
  echo "🔗 Links"
  echo "   ──────────────────────────────────────────────────────────"
  echo ""
  echo "  Skills:   https://skills.sh/"
  echo "  Memory:   https://claude-mem.ai"
  echo "  Claude:   https://docs.anthropic.com/en/docs/claude-code"
  echo "  Hooks:    https://docs.anthropic.com/en/docs/claude-code/hooks"
  echo ""
}
````

## File: templates/statusline.sh
````bash
#!/bin/bash
# Claude Code statusline script
# Receives JSON via stdin, outputs two lines to stdout
# Usage: echo '{"model":{"display_name":"Sonnet"},...}' | ./.claude/statusline.sh

command -v jq >/dev/null 2>&1 || { echo "Claude"; echo "jq required"; exit 0; }

INPUT=$(cat)

MODEL=$(echo "$INPUT" | jq -r '.model.display_name // "Claude"')
WORK_DIR=$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // "."')
PROJECT_DIR=$(echo "$INPUT" | jq -r '.workspace.project_dir // .workspace.current_dir // .cwd // "."')
DIR_NAME=$(basename "$WORK_DIR")
PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$INPUT" | jq -r '.cost.total_cost_usd // 0')
DURATION=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""' | tr -cd 'a-zA-Z0-9_-')
REMAINING_PCT=$(echo "$INPUT" | jq -r '100 - (.context_window.used_percentage // 0)' | awk '{printf "%d", ($1+0.5)}')

# Ensure numeric values are valid (fallback to 0 on null/empty)
case "$PCT" in ''|null|*[!0-9]*) PCT=0 ;; esac
case "$REMAINING_PCT" in ''|null|*[!0-9]*) REMAINING_PCT=100 ;; esac
case "$COST" in ''|null) COST=0 ;; esac
case "$DURATION" in ''|null|*[!0-9]*) DURATION=0 ;; esac

# Cache expensive git status calls (stable cache file per project path).
BRANCH=""
STAGED=0
MODIFIED=0
UPDATE_BADGE=""
CACHE_ROOT="/tmp/claude-statusline-cache"
mkdir -p "$CACHE_ROOT" 2>/dev/null || true
DIR_KEY=$(printf '%s' "$PROJECT_DIR" | cksum | awk '{print $1}')
CACHE_FILE="$CACHE_ROOT/git-${DIR_KEY}.txt"
CACHE_MAX_AGE=5

cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] && return 0
  local now mtime
  now=$(date +%s)
  mtime=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
  [ $((now - mtime)) -gt "$CACHE_MAX_AGE" ]
}

if cache_is_stale; then
  if git -C "$WORK_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    BRANCH=$(git -C "$WORK_DIR" branch --show-current 2>/dev/null || echo "")
    STAGED=$(git -C "$WORK_DIR" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git -C "$WORK_DIR" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    printf '%s|%s|%s\n' "$BRANCH" "${STAGED:-0}" "${MODIFIED:-0}" > "$CACHE_FILE" 2>/dev/null || true
  else
    printf '||\n' > "$CACHE_FILE" 2>/dev/null || true
  fi
fi

if [ -f "$CACHE_FILE" ]; then
  IFS='|' read -r BRANCH STAGED MODIFIED < "$CACHE_FILE"
fi

case "$STAGED" in ''|null|*[!0-9]*) STAGED=0 ;; esac
case "$MODIFIED" in ''|null|*[!0-9]*) MODIFIED=0 ;; esac

# ai-setup update badge (reads cached update-check result; no network call here).
SETUP_META="$PROJECT_DIR/.ai-setup.json"
if [ -f "$SETUP_META" ]; then
  INSTALLED_AI_SETUP=$(jq -r '.version // empty' "$SETUP_META" 2>/dev/null | sed 's/^v//' | tr -d '[:space:]')
  if [ -n "$INSTALLED_AI_SETUP" ]; then
    UPDATE_CACHE="/tmp/ai-setup-update-$(printf '%s' "$PROJECT_DIR" | cksum | awk '{print $1}').txt"
    if [ -f "$UPDATE_CACHE" ]; then
      LATEST_AI_SETUP=$(tr -d '[:space:]' < "$UPDATE_CACHE" | sed 's/^v//')
      if [ -n "$LATEST_AI_SETUP" ] && [ "$LATEST_AI_SETUP" != "$INSTALLED_AI_SETUP" ]; then
        # Semver compare: only show badge if registry version is strictly newer
        _upd_gt=0
        IFS=. read -ra _upd_a <<< "$LATEST_AI_SETUP"
        IFS=. read -ra _upd_b <<< "$INSTALLED_AI_SETUP"
        for _upd_i in 0 1 2; do
          [ "${_upd_a[$_upd_i]:-0}" -gt "${_upd_b[$_upd_i]:-0}" ] 2>/dev/null && _upd_gt=1 && break
          [ "${_upd_a[$_upd_i]:-0}" -lt "${_upd_b[$_upd_i]:-0}" ] 2>/dev/null && break
        done
        [ "$_upd_gt" -eq 1 ] && UPDATE_BADGE=" | ai-setup v${INSTALLED_AI_SETUP} -> v${LATEST_AI_SETUP}"
      fi
    fi
  fi
fi

# Write bridge file for context-monitor hook
if [ -n "$SESSION_ID" ]; then
  EPOCH=$(date +%s)
  printf '{"session_id":"%s","remaining_percentage":%s,"used_pct":%s,"timestamp":%s}\n' \
    "$SESSION_ID" "$REMAINING_PCT" "$PCT" "$EPOCH" \
    > "/tmp/claude-ctx-${SESSION_ID}.json" 2>/dev/null || true
fi

# Color coding for context bar
if [ "$PCT" -ge 80 ]; then
  COLOR="\033[31m"   # red
elif [ "$PCT" -ge 50 ]; then
  COLOR="\033[33m"   # yellow
else
  COLOR="\033[32m"   # green
fi
RESET="\033[0m"

# Line 1: model + dir + branch
BRANCH_PART=""
[ -n "$BRANCH" ] && BRANCH_PART=" (${BRANCH} +${STAGED} ~${MODIFIED})"
echo -e "${MODEL} · ${DIR_NAME}${BRANCH_PART}${UPDATE_BADGE}"

# Line 2: context bar + cost + duration
MINS=$(( DURATION / 60000 ))
printf "${COLOR}ctx: ${PCT}%%${RESET}  \$%.4f  %dm\n" "$COST" "$MINS"
````

## File: lib/update.sh
````bash
#!/bin/bash
# Update/reinstall logic: version detection, smart update, clean reinstall
# Requires: core.sh, detect.sh, tui.sh, generate.sh

# Show a lightweight CLI notice when a newer ai-setup version exists.
# Uses a cached npm registry lookup to avoid slowing normal runs.
show_cli_update_notice() {
  local current latest cache age ttl
  current=$(get_package_version)
  [ -n "$current" ] || return 0
  [ "$current" = "unknown" ] && return 0

  cache="/tmp/ai-setup-cli-latest-version.txt"
  ttl=21600 # 6h cache
  latest=""

  if [ -f "$cache" ]; then
    if [ "$(uname -s)" = "Darwin" ]; then
      age=$(( $(date +%s) - $(stat -f %m "$cache" 2>/dev/null || echo 0) ))
    else
      age=$(( $(date +%s) - $(stat -c %Y "$cache" 2>/dev/null || echo 0) ))
    fi
    if [ "$age" -lt "$ttl" ]; then
      latest=$(tr -d '[:space:]' < "$cache")
    fi
  fi

  if [ -z "$latest" ] && command -v npm >/dev/null 2>&1; then
    local timeout_cmd=""
    if command -v timeout >/dev/null 2>&1; then
      timeout_cmd="timeout 3"
    elif command -v gtimeout >/dev/null 2>&1; then
      timeout_cmd="gtimeout 3"
    fi
    if [ -n "$timeout_cmd" ]; then
      latest=$($timeout_cmd npm view @onedot/ai-setup version 2>/dev/null | head -n1 | tr -d '[:space:]')
    else
      latest=$(npm view @onedot/ai-setup version 2>/dev/null | head -n1 | tr -d '[:space:]')
    fi
    [ -n "$latest" ] && printf '%s\n' "$latest" > "$cache"
  fi

  # GitHub fallback for environments using github: installs without npm publish.
  if [ -z "$latest" ] && command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    latest=$(curl -fsSL --max-time 4 "https://api.github.com/repos/onedot-digital-crew/npx-ai-setup/releases/latest" 2>/dev/null \
      | jq -r '.tag_name // empty' \
      | head -n1 \
      | tr -d '[:space:]' \
      | sed 's/^v//')
    if [ -z "$latest" ]; then
      latest=$(curl -fsSL --max-time 4 "https://api.github.com/repos/onedot-digital-crew/npx-ai-setup/tags?per_page=1" 2>/dev/null \
        | jq -r '.[0].name // empty' \
        | head -n1 \
        | tr -d '[:space:]' \
        | sed 's/^v//')
    fi
    [ -n "$latest" ] && printf '%s\n' "$latest" > "$cache"
  fi

  [ -n "$latest" ] || return 0
  # Only show notice when registry version is strictly newer (semver compare)
  if [ "$latest" != "$current" ] && _semver_gt "$latest" "$current"; then
    echo ""
    echo "ℹ️  New version available: @onedot/ai-setup v${latest} (current: v${current})"
    echo "   Update command: npx github:onedot-digital-crew/npx-ai-setup"
    echo ""
  fi
}

# Handle version check and route to update, reinstall, or exit
# Called when .ai-setup.json exists. May exit the script.
handle_version_check() {
  INSTALLED_VERSION=$(get_installed_version)
  PACKAGE_VERSION=$(get_package_version)
  local update_rc=0

  if [ -n "$INSTALLED_VERSION" ] && [ "$INSTALLED_VERSION" = "$PACKAGE_VERSION" ]; then
    # Same version — already up to date
    echo ""
    echo "✅ Already up to date (v${PACKAGE_VERSION})."
    echo ""
    echo "   1) Update files  — review template files, ask about user-modified ones"
    echo "   2) Regenerate    — choose exactly what to regenerate (docs/context/commands/agents/skills)"
    echo "   3) Skip          — exit without changes"
    echo ""
    read -p "   Choose [1/2/3]: " UPTODATE_CHOICE

    case "$UPTODATE_CHOICE" in
      1)
        update_rc=0
        run_smart_update --skip-regen || update_rc=$?
        exit "$update_rc"
        ;;
      2)
        regen_ok=0
        if command -v claude &>/dev/null; then
          if ask_regen_parts; then
            if [ -z "$SYSTEM" ] && [ -f .ai-setup.json ]; then
              SYSTEM=$(jq -r '.system // empty' .ai-setup.json 2>/dev/null)
              [ -n "$SYSTEM" ] && echo "  🔍 Restored system from previous run: $SYSTEM"
            fi
            if [ -z "$SYSTEM" ]; then
              select_system
            fi
            detect_system
            run_generation || regen_ok=$?
            write_metadata
            echo ""
            if [ "$regen_ok" -eq 0 ]; then
              echo "✅ Regeneration complete!"
            else
              echo "⚠️  Regeneration finished with warnings. Review output above."
            fi
          fi
        else
          echo ""
          echo "  ⚠️  Claude CLI not found. Regeneration requires Claude Code."
          echo "  Install: npm i -g @anthropic-ai/claude-code"
          regen_ok=1
        fi
        exit "$regen_ok"
        ;;
      *)
        echo "   Skipped. No changes made."
        exit 0
        ;;
    esac

  elif [ -n "$INSTALLED_VERSION" ]; then
    # Different version — offer update options
    echo ""
    echo "🔄 Update available: v${INSTALLED_VERSION} → v${PACKAGE_VERSION}"
    echo ""
    echo "   1) Update       — smart update (backup modified files, update templates)"
    echo "   2) Reinstall    — delete managed files, fresh install from scratch"
    echo "   3) Skip         — exit without changes"
    echo ""
    read -p "   Choose [1/2/3]: " UPDATE_CHOICE

    case "$UPDATE_CHOICE" in
      1)
        update_rc=0
        run_smart_update || update_rc=$?
        exit "$update_rc"
        ;;
      2)
        run_clean_reinstall
        # Fall through to normal setup below (caller continues)
        ;;
      *)
        echo "   Skipped. No changes made."
        exit 0
        ;;
    esac
  fi
}

# Smart update: checksum diffing, selective category update, backup user-modified files
# Usage: run_smart_update [--skip-regen]
run_smart_update() {
  local skip_regen=0
  local regen_failed=0
  [ "${1:-}" = "--skip-regen" ] && skip_regen=1
  echo ""
  echo "🔍 Analyzing templates..."
  echo ""

  # Restore SYSTEM from metadata if not set via --system flag
  if [ -z "$SYSTEM" ] && [ -f .ai-setup.json ]; then
    SYSTEM=$(jq -r '.system // empty' .ai-setup.json 2>/dev/null)
    [ -n "$SYSTEM" ] && echo "  🔍 Restored system from previous run: $SYSTEM"
  fi

  # Normalize legacy skills layout in existing projects.
  if command -v ensure_skills_alias >/dev/null 2>&1; then
    ensure_skills_alias
  fi

  UPD_UPDATED=0
  UPD_SKIPPED=0
  UPD_NEW=0
  UPD_BACKED_UP=0
  UPD_REMOVED=0
  UPD_REMOVED_BACKED_UP=0

  # Ask which template categories to update
  ask_update_parts || echo "  ⏭️  No categories selected — skipping template updates"
  echo ""

  for mapping in "${TEMPLATE_MAP[@]}"; do
    should_update_template "$mapping" || continue
    tpl="${mapping%%:*}"
    target="${mapping#*:}"

    # Target doesn't exist — install as new
    if [ ! -f "$target" ]; then
      if [ -f "$SCRIPT_DIR/$tpl" ]; then
        mkdir -p "$(dirname "$target")"
        cp "$SCRIPT_DIR/$tpl" "$target"
        [[ "$target" == *.sh ]] && chmod +x "$target"
        echo "  ✨ $target (new)"
        UPD_NEW=$((UPD_NEW + 1))
      fi
      continue
    fi

    # Compare template to installed file
    tpl_cs=$(compute_checksum "$SCRIPT_DIR/$tpl")
    cur_cs=$(compute_checksum "$target")

    if [ "$tpl_cs" = "$cur_cs" ]; then
      # Template and installed file are identical — skip
      echo "  ⏭️  $target (unchanged)"
      UPD_SKIPPED=$((UPD_SKIPPED + 1))
      continue
    fi

    # Template differs — check if user modified the file
    stored_cs=$(jq -r --arg f "$target" '.files[$f] // empty' .ai-setup.json 2>/dev/null)

    if [ -n "$stored_cs" ] && [ "$stored_cs" != "$cur_cs" ]; then
      # User modified — ask before overwriting
      if ask_overwrite_modified "$target"; then
        bp=$(backup_file "$target")
        cp "$SCRIPT_DIR/$tpl" "$target"
        [[ "$target" == *.sh ]] && chmod +x "$target"
        echo "  ✅ $target (updated — backed up to $bp)"
        UPD_BACKED_UP=$((UPD_BACKED_UP + 1))
      else
        echo "  ⏭️  $target (kept — user version preserved)"
        UPD_SKIPPED=$((UPD_SKIPPED + 1))
        continue
      fi
    else
      # Not modified by user — silent update
      cp "$SCRIPT_DIR/$tpl" "$target"
      [[ "$target" == *.sh ]] && chmod +x "$target"
      echo "  ✅ $target (updated)"
    fi
    UPD_UPDATED=$((UPD_UPDATED + 1))
  done

  # Also update Shopify-specific skills if system includes shopify
  if [[ "${SYSTEM:-}" == *shopify* ]]; then
    for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
      should_update_template "$mapping" || continue
      tpl="${mapping%%:*}"
      target="${mapping#*:}"
      if [ ! -f "$target" ]; then
        if [ -f "$SCRIPT_DIR/$tpl" ]; then
          mkdir -p "$(dirname "$target")"
          cp "$SCRIPT_DIR/$tpl" "$target"
          echo "  ✨ $target (new)"
          UPD_NEW=$((UPD_NEW + 1))
        fi
        continue
      fi
      tpl_cs=$(compute_checksum "$SCRIPT_DIR/$tpl")
      cur_cs=$(compute_checksum "$target")
      if [ "$tpl_cs" = "$cur_cs" ]; then
        echo "  ⏭️  $target (unchanged)"
        UPD_SKIPPED=$((UPD_SKIPPED + 1))
        continue
      fi
      stored_cs=$(jq -r --arg f "$target" '.files[$f] // empty' .ai-setup.json 2>/dev/null)
      if [ -n "$stored_cs" ] && [ "$stored_cs" != "$cur_cs" ]; then
        # User modified — ask before overwriting
        if ask_overwrite_modified "$target"; then
          bp=$(backup_file "$target")
          cp "$SCRIPT_DIR/$tpl" "$target"
          echo "  ✅ $target (updated — backed up to $bp)"
          UPD_BACKED_UP=$((UPD_BACKED_UP + 1))
        else
          echo "  ⏭️  $target (kept — user version preserved)"
          UPD_SKIPPED=$((UPD_SKIPPED + 1))
          continue
        fi
      else
        cp "$SCRIPT_DIR/$tpl" "$target"
        echo "  ✅ $target (updated)"
      fi
      UPD_UPDATED=$((UPD_UPDATED + 1))
    done
  fi

  cleanup_obsolete_managed_files

  echo ""
  echo "📊 Update summary:"
  echo "   Updated:   $UPD_UPDATED"
  [ $UPD_NEW -gt 0 ] && echo "   New:       $UPD_NEW"
  [ $UPD_REMOVED -gt 0 ] && echo "   Removed:   $UPD_REMOVED"
  [ $UPD_SKIPPED -gt 0 ] && echo "   Unchanged: $UPD_SKIPPED"
  [ $UPD_BACKED_UP -gt 0 ] && echo "   Backed up: $UPD_BACKED_UP (see .ai-setup-backup/)"
  [ $UPD_REMOVED_BACKED_UP -gt 0 ] && echo "   Backed up before removal: $UPD_REMOVED_BACKED_UP"
  _upd_cats=""
  [ "${UPD_HOOKS:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Hooks"
  [ "${UPD_SETTINGS:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Settings"
  [ "${UPD_CLAUDE_MD:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }CLAUDE.md"
  [ "${UPD_AGENTS_MD:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }AGENTS.md"
  [ "${UPD_COMMANDS:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Commands"
  [ "${UPD_AGENTS:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Agents"
  [ "${UPD_OTHER:-yes}" = "yes" ] && _upd_cats="${_upd_cats:+$_upd_cats, }Other"
  [ -n "$_upd_cats" ] && echo "   Categories: $_upd_cats"

  # Update metadata
  write_metadata

  # Check context files and offer AI regeneration (skipped when called from same-version menu)
  if [ "$skip_regen" -eq 0 ]; then
    if command -v claude &>/dev/null; then
      echo ""
      # Count existing .agents/context/ files (Steps 1-2)
      CTX_EXISTING=0
      [ -f ".agents/context/STACK.md" ] && CTX_EXISTING=$((CTX_EXISTING + 1))
      [ -f ".agents/context/ARCHITECTURE.md" ] && CTX_EXISTING=$((CTX_EXISTING + 1))
      [ -f ".agents/context/CONVENTIONS.md" ] && CTX_EXISTING=$((CTX_EXISTING + 1))
      CTX_MISSING=$((3 - CTX_EXISTING))
      if [ "$CTX_MISSING" -gt 0 ]; then
        echo "  ⚠️  $CTX_MISSING of 3 context files missing in .agents/context/ — regeneration recommended"
        echo ""
      fi
      # Use granular selector instead of binary y/N (Steps 3-4)
      if ask_regen_parts; then
        if [ -z "$SYSTEM" ]; then
          select_system
        fi
        detect_system
        regen_ok=0
        run_generation || regen_ok=$?
        write_metadata
        echo ""
        if [ "$regen_ok" -eq 0 ]; then
          echo "✅ Regeneration complete!"
        else
          regen_failed=1
          echo "⚠️  Regeneration finished with warnings. Review output above."
        fi
      fi
    else
      echo ""
      echo "  ⚠️  Skipping regeneration (claude CLI not found)."
      echo "  Install: npm i -g @anthropic-ai/claude-code"
    fi
  fi

  update_gitignore
  generate_repomix_snapshot

  echo ""
  local _version_info="v${PACKAGE_VERSION}"
  [ "$INSTALLED_VERSION" != "$PACKAGE_VERSION" ] && _version_info="v${INSTALLED_VERSION} → v${PACKAGE_VERSION}"
  if [ "$regen_failed" -eq 0 ]; then
    echo "✅ Update complete! (${_version_info})"
    return 0
  fi
  echo "⚠️  Update complete with warnings (${_version_info})"
  return 1
}

# Clean reinstall: remove all managed files, reset metadata
run_clean_reinstall() {
  echo ""
  echo "🗑️  Removing managed files..."

  cleanup_obsolete_managed_files reinstall

  for mapping in "${TEMPLATE_MAP[@]}"; do
    target="${mapping#*:}"
    if [ -f "$target" ]; then
      rm -f "$target"
      echo "   Removed: $target"
    fi
  done

  # Also remove Shopify-specific skills
  for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
    target="${mapping#*:}"
    if [ -f "$target" ]; then
      rm -f "$target"
      echo "   Removed: $target"
    fi
  done

  # Remove metadata and backup dir
  rm -f .ai-setup.json
  echo ""
  echo "   Clean slate ready. Running fresh install..."
  echo ""
  # Caller continues to normal setup
}

# Remove files that were managed by an older ai-setup version but are no longer
# part of the current template maps. Smart update backs up user-modified files
# first; reinstall removes all historical managed files outright.
cleanup_obsolete_managed_files() {
  local mode="${1:-smart}"
  local target stored_cs cur_cs bp
  local -a old_targets=()

  [ -f .ai-setup.json ] || return 0
  command -v jq >/dev/null 2>&1 || return 0
  jq -e . .ai-setup.json >/dev/null 2>&1 || return 0

  while IFS= read -r target; do
    [ -n "$target" ] && old_targets+=("$target")
  done < <(jq -r '.files | keys[]?' .ai-setup.json 2>/dev/null)

  [ "${#old_targets[@]}" -gt 0 ] || return 0

  for target in "${old_targets[@]}"; do
    is_current_managed_target "$target" && continue
    should_update_template "_:$target" || continue
    [ -f "$target" ] || continue

    if [ "$mode" = "reinstall" ]; then
      rm -f "$target"
      echo "   Removed obsolete: $target"
      continue
    fi

    stored_cs=$(jq -r --arg f "$target" '.files[$f] // empty' .ai-setup.json 2>/dev/null)
    cur_cs=$(compute_checksum "$target")

    if [ -n "$stored_cs" ] && [ "$stored_cs" != "$cur_cs" ]; then
      bp=$(backup_file "$target")
      rm -f "$target"
      echo "  🧹 $target (obsolete — backed up to $bp, then removed)"
      UPD_BACKED_UP=$((UPD_BACKED_UP + 1))
      UPD_REMOVED_BACKED_UP=$((UPD_REMOVED_BACKED_UP + 1))
    else
      rm -f "$target"
      echo "  🧹 $target (obsolete — removed)"
    fi
    UPD_REMOVED=$((UPD_REMOVED + 1))
  done
}
````

## File: templates/CLAUDE.md
````markdown
# CLAUDE.md

## Memory

**Built-in Auto Memory** — Claude automatically saves notes to `~/.claude/projects/<hash>/memory/MEMORY.md`. No setup required. Claude writes to this file during sessions and reads it back at the start of each conversation to maintain continuity.

**claude-mem** (optional) — structured observation database with semantic search across sessions. Install if you want cross-session search and team-shared memory:
```
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

## Tips

- `ultrathink:` prefix — triggers extended reasoning without switching models.
  Example: `ultrathink: refactor this auth module`
- `! command` — run a bash command instantly without token overhead.
  Example: `! git log --oneline -10`
- `@path/to/file` — import file contents compactly into context.
  Example: `@src/auth/index.ts`
- One task per conversation — start a fresh session for unrelated work to prevent context bleed.
- `Esc Esc` — rewind or summarize the last response to recover tokens when context grows large.
- `/rename` + `/resume` — rename the current session for easy retrieval, then resume it later with `/resume`.
- Commit after each completed task — creates a checkpoint you can revert to if later changes go wrong.

## MCP Servers

Each MCP server adds its tools to every request — only enable servers actively used in this project.

```bash
claude mcp list                 # show configured servers and status
claude mcp disable <name>       # deactivate without removing from .mcp.json
claude mcp enable <name>        # reactivate when needed
```

## Communication Protocol
No small talk. Just do it.
Confirmations one word (Done, Fixed). Show code changes as diff only.
If you edit the same file 3+ times without progress, stop and ask for guidance.

## Project Context (read before complex tasks)
Before multi-file changes or new features, read `.agents/context/`:
- `STACK.md` - Technology stack, versions, key dependencies, and what to avoid
- `ARCHITECTURE.md` - System architecture, directory structure, and data flow
- `CONVENTIONS.md` - Coding standards, naming patterns, error handling, and testing

## Commands
<!-- Auto-Init populates this -->

## Critical Rules
<!-- Auto-Init populates this -->

## Build Artifact Rules

Never read or search inside build output directories (dist/, .output/, .nuxt/, .next/, build/, coverage/). These directories contain generated artifacts that waste tokens and pollute context.

## Task Complexity Routing
Before starting, classify and state the task tier:

- **Simple** (typos, single-file fixes, config tweaks): proceed directly
- **Medium** (new feature, 2-3 files, component): use plan mode
- **Complex** (architecture, refactor, new system): stop and ask for explicit
  quality mode confirmation (for example `claude --model claude-opus-4-6`)

Never start a complex task without flagging the model requirement first.

## Verification
After completing work, verify before marking done:
- Run tests if available (`/test`)
- For UI changes: use browser tools or describe expected result
- For API changes: make a test request
- Check the build still passes

Never mark work as completed without BOTH:
1. Automated checks pass (tests green, linter clean, build succeeds)
2. Explicit statement: "Verification complete: [what was checked and result]"

## Context Management
Your context will be compacted automatically — this is normal. Before compaction:
- Commit current work or save state to HANDOFF.md
- Track remaining work in the spec or a todo list
After fresh start: review git log, open specs, check test state.

If you see `[CONTEXT STALE]` in your context: note that project context files may be outdated, but continue with the current task. Do not interrupt work to refresh context.

## Prompt Cache Strategy
Claude caches prompts as a prefix — static content first, dynamic content last maximizes cache hits:
1. **System prompt + tools** — globally cached across all sessions
2. **CLAUDE.md** — cached per project (do not edit mid-session)
3. **Session context** (`.agents/context/`) — cached per session
4. **Conversation messages** — dynamic, appended each turn

Do not edit CLAUDE.md or tool definitions mid-session — it breaks the cache for all subsequent turns.
Pass dynamic updates (timestamps, file changes) via messages, not by editing static layers.

## Working Style
Read relevant code before answering questions about it.
Implement changes rather than only suggesting them.
Use subagents for parallel or isolated work. For simple tasks, work directly.

## Parallel Orchestration
Use subagents by default for focused delegated work.
If teammates must coordinate directly, use experimental agent teams (enable only when needed):
- Set `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in local Claude settings or environment
- Start with 3-5 teammates for independent tasks
- Clean up the team after completion

## Automation (Agent SDK CLI)
For non-interactive runs, use `claude -p "<prompt>"`.
For CI-safe output, use `--output-format json` and parse structured fields.
Constrain execution with `--allowedTools` instead of broad permissions.

## Skills Discovery
When current capabilities are insufficient, search the skills.sh marketplace for additional agent skills:
- Search: `npx -y skills@latest find "<keyword>"`
- Install: `npx -y skills@latest add <owner/repo@skill-name> --agent claude-code --agent github-copilot -y`

Check `.claude/skills/` first to avoid installing duplicates. Only install when genuinely needed for the task.

## Spec-Driven Development
Specs live in `specs/` -- structured task plans created before coding.

**When to suggest a spec:** Changes across 3+ files, new features, architectural changes, ambiguous requirements.
**Skip specs for:** Single-file fixes, typos, config changes.

**Spec status lifecycle:** `draft` → `in-progress` → `in-review` → `completed` (or `blocked` at any stage)

**Workflow:**
1. `/spec "task"` — Plan: Opus challenges the idea, creates spec if approved (status: `draft`)
2. Review and refine spec if needed
3. `/spec-work NNN` — Execute: Sonnet implements the spec step-by-step; prompts for branch creation and optional auto-review (status: `in-progress` → `in-review` or `completed`)
4. `/spec-work-all` — Execute all: parallel agents using native `isolation: "worktree"`, one branch per spec
5. `/spec-review NNN` — Review: Opus reviews changes against acceptance criteria (status: `completed`)
6. `/spec-board` — Overview: Kanban-style board showing all specs with status and step progress

**Parallel execution (`/spec-work-all`):**
- Uses native `isolation: "worktree"` — Claude Code manages worktrees automatically
- Each agent gets its own branch (`spec/NNN-title`) with no merge conflicts
- Specs with dependencies run in sequential waves
- After completion, each spec is ready for `/spec-review`

See `specs/README.md` for details.

<claude-mem-context></claude-mem-context>
````

## File: package.json
````json
{
  "name": "@onedot/ai-setup",
  "version": "1.2.8",
  "description": "AI project setup: Claude Code, Hooks, and AI-curated skills",
  "bin": {
    "ai-setup": "./bin/ai-setup.sh"
  },
  "files": [
    "bin/",
    "lib/",
    "templates/",
    "README.md"
  ],
  "keywords": [
    "claude-code",
    "ai-setup",
    "onedot"
  ],
  "scripts": {
    "test": "bash tests/smoke.sh",
    "hooks:install": "git config core.hooksPath .githooks",
    "hooks:status": "git config --get core.hooksPath"
  },
  "license": "MIT"
}
````

## File: bin/ai-setup.sh
````bash
#!/bin/bash

# ==============================================================================
# @onedot/ai-setup - AI infrastructure for projects
# ==============================================================================
# Installs Claude Code hooks, project context, and AI-curated skills
# Usage: npx @onedot/ai-setup [--system <name>] [--regenerate]
# Auto-detects updates: if .ai-setup.json exists with older version, offers update/reinstall
# ==============================================================================

set -e

# Package root (one level above bin/)
# Resolve symlinks so npx installs work correctly (macOS-compatible, no readlink -f)
_SCRIPT="${BASH_SOURCE[0]}"
while [ -L "$_SCRIPT" ]; do
  _DIR="$(cd -P "$(dirname "$_SCRIPT")" && pwd)"
  _SCRIPT="$(readlink "$_SCRIPT")"
  [[ "$_SCRIPT" != /* ]] && _SCRIPT="$_DIR/$_SCRIPT"
done
SCRIPT_DIR="$(cd -P "$(dirname "$_SCRIPT")/.." && pwd)"
unset _SCRIPT _DIR
TPL="$SCRIPT_DIR/templates"

# Parse flags
SYSTEM=""
REGENERATE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --regenerate) REGENERATE="yes"; shift ;;
    --system)
      if [[ $# -lt 2 ]]; then
        echo "❌ --system requires a value (auto|shopify|nuxt|next|laravel|shopware|storyblok)"
        exit 1
      fi
      SYSTEM="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Load modules
source "$SCRIPT_DIR/lib/_loader.sh"
source_lib "core.sh"
source_lib "process.sh"
source_lib "detect.sh"
source_lib "tui.sh"
source_lib "skills.sh"
source_lib "generate.sh"
source_lib "update.sh"
source_lib "setup.sh"
source_lib "plugins.sh"

# Validate --system value (supports comma-separated list)
if [ -n "$SYSTEM" ]; then
  IFS=',' read -ra SYSTEMS_TO_VALIDATE <<< "$SYSTEM"
  for sys in "${SYSTEMS_TO_VALIDATE[@]}"; do
    VALID=false
    for s in "${VALID_SYSTEMS[@]}"; do
      [ "$sys" = "$s" ] && VALID=true
    done
    if [ "$VALID" = false ]; then
      echo "❌ Unknown system: $sys"
      echo "   Valid options: ${VALID_SYSTEMS[*]}"
      exit 1
    fi
  done
  # Ensure "auto" is not combined with other systems
  if [[ "$SYSTEM" == *"auto"* ]] && [[ "$SYSTEM" == *","* ]]; then
    echo "❌ 'auto' cannot be combined with other systems"
    exit 1
  fi
fi

# Lightweight registry check (cached) to hint when a newer ai-setup is available.
show_cli_update_notice

# ==============================================================================
# REGENERATE MODE (--regenerate flag)
# ==============================================================================
if [ "$REGENERATE" = "yes" ]; then
  if ! command -v claude &>/dev/null; then
    echo "❌ Claude CLI required for regeneration."
    echo "   Install: npm i -g @anthropic-ai/claude-code"
    exit 1
  fi

  # Select system if not provided via --system flag
  if [ -z "$SYSTEM" ]; then
    # Try to restore from previous run stored in .ai-setup.json
    if [ -f .ai-setup.json ] && jq -e . .ai-setup.json >/dev/null 2>&1; then
      STORED_SYSTEM=$(jq -r '.system // empty' .ai-setup.json 2>/dev/null)
      if [ -n "$STORED_SYSTEM" ] && [ "$STORED_SYSTEM" != "auto" ]; then
        SYSTEM="$STORED_SYSTEM"
        echo "  🔍 Restored system from previous run: $SYSTEM"
      fi
    fi
  fi
  if [ -z "$SYSTEM" ]; then
    select_system
  fi
  detect_system

  if run_generation; then
    echo ""
    echo "✅ Regeneration complete! (System: $SYSTEM)"
    echo "   - CLAUDE.md + AGENTS.md updated"
    [ -d .agents/context ] && echo "   - .agents/context/ regenerated"
    [ ${INSTALLED:-0} -gt 0 ] && echo "   - $INSTALLED skills installed"
    exit 0
  fi
  echo ""
  echo "⚠️  Regeneration finished with warnings (System: $SYSTEM)."
  echo "   Review the warnings above and re-run after fixing the underlying issue."
  exit 1
fi

# ==============================================================================
# AUTO-DETECT: UPDATE / REINSTALL / FRESH INSTALL
# ==============================================================================
if [ -f .ai-setup.json ] && jq -e . .ai-setup.json >/dev/null 2>&1; then
  handle_version_check
fi

# ==============================================================================
# NORMAL SETUP MODE
# ==============================================================================
echo "🚀 Starting AI Setup (Claude Code + Skills)..."

check_requirements
cleanup_legacy
install_claude_md
install_agents_md
install_settings
install_hooks
install_rules
install_copilot
mkdir -p .agents
ensure_skills_alias
install_specs
install_commands
install_shopify_skills
install_agents
setup_repo_group_context
echo "📋 Writing installation metadata..."
write_metadata
update_gitignore
install_repomix_config
generate_repomix_snapshot

# Plugins & extensions
echo ""
echo "🔌 Plugins & Extensions"
echo "   ──────────────────────────────────────────────────────────"

install_claude_mem
install_coderabbit_plugin
install_official_plugins
install_context7
show_plugin_summary

# OpenCode compatibility (generates opencode.json from .mcp.json)
generate_opencode_config

# Statusline (project-level — only in fresh install mode, skip if already configured)
if ! jq -e '.statusLine' ".claude/settings.json" >/dev/null 2>&1; then
  echo ""
  echo "Statusline"
  echo "   ──────────────────────────────────────────────────────────"
  read -p "   Install statusline for Claude Code? (y/N) " INSTALL_STATUSLINE
  if [[ "$INSTALL_STATUSLINE" =~ ^[Yy]$ ]]; then
    install_statusline_project
  fi
fi

# Auto-Init
echo ""
echo "✅ Setup complete!"
echo ""

if [ "$AI_CLI" = "claude" ]; then
  read -p "🤖 Run Auto-Init now? (Y/n) " RUN_INIT
  if [[ ! "$RUN_INIT" =~ ^[Nn]$ ]]; then
    # Select system if not provided via --system flag
    if [ -z "$SYSTEM" ]; then
      select_system
    fi
    detect_system

    AUTO_INIT_OK="no"
    if run_generation; then
      AUTO_INIT_OK="yes"
      echo ""
      echo "✅ Auto-Init complete!"
      _NOTIFY_MSG="Auto-Init complete!"
    else
      echo ""
      echo "⚠️  Auto-Init finished with warnings. Review output above."
      _NOTIFY_MSG="Auto-Init finished with warnings"
    fi
    case "$(uname -s)" in
      Darwin) osascript -e "display notification \"$_NOTIFY_MSG\" with title \"AI Setup\" sound name \"Glass\"" 2>/dev/null || true ;;
      Linux) command -v notify-send >/dev/null 2>&1 && notify-send "AI Setup" "$_NOTIFY_MSG" 2>/dev/null || true ;;
    esac
  fi
elif [ "$AI_CLI" = "copilot" ]; then
  echo "💡 GitHub Copilot detected (no claude CLI)."
  echo "   Manual steps required:"
  echo ""
  echo "   1. Open VS Code / GitHub Copilot Chat"
  echo "   2. Ask Copilot to extend CLAUDE.md and AGENTS.md with project-specific sections"
else
  echo "⚠️  No AI CLI detected (neither claude nor gh copilot)."
  echo "   Install Claude Code: npm i -g @anthropic-ai/claude-code"
  echo "   Then run the setup steps in NEXT STEPS below"
fi

show_installation_summary
show_next_steps
````

## File: templates/claude/settings.json
````json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "model": "opusplan",
  "plansDirectory": ".claude/plans",
  "enableAllProjectMcpServers": true,
  "_cacheNote": "Keep tool/permission order stable — reordering the allow list mid-session breaks Claude's prompt cache prefix and increases cost.",
  "respectGitignore": true,
  "attribution": {
    "coAuthoredBy": true,
    "template": "Co-Authored-By: Claude <noreply@anthropic.com>"
  },
  "env": {
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "70",
    "ENABLE_TOOL_SEARCH": "true"
  },
  "sandbox": {
    "enabled": true,
    "allowedNetworkHosts": [
      "github.com",
      "api.github.com",
      "npmjs.org",
      "registry.npmjs.org",
      "skills.sh",
      "api.skills.sh"
    ]
  },
  "permissions": {
    "allow": [
      "Read(src/**)",
      "Read(.planning/**)",
      "Bash(date:*)",
      "Bash(echo:*)",
      "Bash(cat:*)",
      "Bash(ls:*)",
      "Bash(mkdir:*)",
      "Bash(wc:*)",
      "Bash(head:*)",
      "Bash(tail:*)",
      "Bash(sort:*)",
      "Bash(grep:*)",
      "Bash(tr:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git status:*)",
      "Bash(git log:*)",
      "Bash(git diff:*)",
      "Bash(git tag:*)",
      "Bash(git branch:*)",
      "Bash(git checkout:*)",
      "Bash(git stash:*)",
      "Bash(git push -u origin claude/*)",
      "Bash(npm run *)",
      "Bash(npm test *)",
      "Bash(npm install *)",
      "Bash(npx eslint *)",
      "Bash(npx prettier *)",
      "Bash(npx vitest *)",
      "Bash(gh pr *)",
      "Bash(gh issue *)",
      "Bash(jq:*)",
      "Bash(curl:*)"
    ],
    "deny": [
      "Read(.env*)",
      "Read(dist/**)",
      "Read(.output/**)",
      "Read(.nuxt/**)",
      "Read(coverage/**)",
      "Read(.next/**)",
      "Read(build/**)",
      "Read(package-lock.json)",
      "Read(yarn.lock)",
      "Read(pnpm-lock.yaml)",
      "Read(bun.lockb)",
      "Read(composer.lock)",
      "Read(.turbo/**)",
      "Read(.vercel/**)",
      "Read(.svelte-kit/**)",
      "Read(.cache/**)",
      "Read(.parcel-cache/**)",
      "Read(storybook-static/**)",
      "Read(*.min.js)",
      "Read(*.min.css)",
      "Read(*.map)",
      "Read(*.chunk.js)",
      "Bash(rm -r *)",
      "Bash(rm -rf *)",
      "Bash(git reset --hard *)",
      "Bash(git clean *)",
      "Bash(git checkout -- *)",
      "Bash(git restore *)",
      "Bash(npm publish *)"
    ]
  },
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'for f in STACK.md CONVENTIONS.md; do [ -f \"${CLAUDE_PROJECT_DIR:-.}/.agents/context/$f\" ] && echo \"=== $f ==\" && cat \"${CLAUDE_PROJECT_DIR:-.}/.agents/context/$f\"; done'",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/cross-repo-context.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/mcp-health.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/update-check.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/post-edit-lint.sh",
            "timeout": 30
          }
        ]
      }
    ],
    "PostToolUseFailure": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/post-tool-failure-log.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "ConfigChange": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/config-change-audit.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/protect-files.sh"
          },
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/circuit-breaker.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/context-freshness.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/update-check.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/notify.sh"
          }
        ]
      }
    ],
    "TaskCompleted": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/task-completed-gate.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'cd \"${CLAUDE_PROJECT_DIR:-.}\" && command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1 && [ -n \"$(git status --porcelain 2>/dev/null)\" ] && git add -A && git commit -m \"wip: auto-save before context compaction\" --no-verify || true'",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
````

## File: lib/setup.sh
````bash
#!/bin/bash
# Fresh install steps: requirements, templates, hooks, commands, agents
# Requires: core.sh ($TPL, $TEMPLATE_MAP, $SHOPIFY_SKILLS_MAP)

# Install a template file, updating it if the template is newer.
# Skips if installed file matches template checksum.
# Updates silently if user hasn't modified the file (checksum matches .ai-setup.json).
# Skips with notice if user has modified the file (preserves user changes).
# Usage: _install_or_update_file <template_path> <target_path>
_install_or_update_file() {
  local src="$1"
  local target="$2"
  local name="${target##*/}"

  if [ ! -f "$target" ]; then
    mkdir -p "$(dirname "$target")"
    cp "$src" "$target"
    [[ "$target" == *.sh ]] && chmod +x "$target"
    return 0
  fi

  # File exists — compare checksums
  local tpl_cs cur_cs
  tpl_cs=$(compute_checksum "$src")
  cur_cs=$(compute_checksum "$target")

  # Already identical — skip silently
  [ "$tpl_cs" = "$cur_cs" ] && return 1

  # Template is newer — check if user modified the installed file
  if [ -f .ai-setup.json ] && command -v jq >/dev/null 2>&1; then
    local stored_cs
    stored_cs=$(jq -r --arg f "$target" '.files[$f] // empty' .ai-setup.json 2>/dev/null)
    if [ -n "$stored_cs" ] && [ "$stored_cs" != "$cur_cs" ]; then
      # User modified this file — don't overwrite
      echo "  ⏭️  $target (user-modified, kept)"
      return 1
    fi
  fi

  # Not user-modified — safe to update
  cp "$src" "$target"
  [[ "$target" == *.sh ]] && chmod +x "$target"
  echo "  ✅ $target (updated)"
  return 0
}

# Check requirements: node >= 18, npm, jq, AI CLI detection
# Sets: $AI_CLI
check_requirements() {
  MISSING=()
  ! command -v node &>/dev/null && MISSING+=("node (>= 18)")
  ! command -v npm &>/dev/null && MISSING+=("npm")
  ! command -v jq &>/dev/null && MISSING+=("jq (brew install jq)")

  if [ ${#MISSING[@]} -gt 0 ]; then
    echo "❌ Missing requirements:"
    for m in "${MISSING[@]}"; do echo "   - $m"; done
    echo ""
    echo "Install the missing tools and try again."
    exit 1
  fi

  # Node.js version check (>= 18)
  NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//' | cut -d. -f1)
  if [ -n "$NODE_VERSION" ] && [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js >= 18 required (found v$NODE_VERSION)"
    exit 1
  fi

  # Template directory validation
  if [ ! -d "$TPL" ]; then
    echo "❌ Template directory not found: $TPL"
    echo "   The package may be corrupted. Try: npm cache clean --force && npx @onedot/ai-setup"
    exit 1
  fi

  # AI CLI detection (optional, for Auto-Init)
  AI_CLI=""
  if command -v claude &>/dev/null; then
    AI_CLI="claude"
  elif command -v gh &>/dev/null && gh copilot --version &>/dev/null 2>&1; then
    AI_CLI="copilot"
  fi
  echo "✅ Requirements OK (AI CLI: ${AI_CLI:-none detected})"
}

# Detect and remove legacy AI structures
cleanup_legacy() {
  FOUND=()
  [ -d ".ai" ] && FOUND+=(".ai/")
  [ -d ".claude/skills/create-spec" ] && FOUND+=(".claude/skills/create-spec/")
  [ -d ".claude/skills/spec-work" ] && FOUND+=(".claude/skills/spec-work/")
  [ -d ".claude/skills/template-skill" ] && FOUND+=(".claude/skills/template-skill/")
  [ -d ".claude/skills/learn" ] && FOUND+=(".claude/skills/learn/")
  [ -f ".claude/INIT.md" ] && FOUND+=(".claude/INIT.md")
  [ -d "skills/" ] && FOUND+=("skills/")
  [ -d ".skillkit/" ] && FOUND+=(".skillkit/")
  [ -f "skillkit.yaml" ] && FOUND+=("skillkit.yaml")

  if [ ${#FOUND[@]} -gt 0 ]; then
    echo "⚠️  Legacy AI structures found:"
    for f in "${FOUND[@]}"; do echo "   - $f"; done
    echo ""
    read -p "Delete? (Y/n) " CLEANUP
    if [[ ! "$CLEANUP" =~ ^[Nn]$ ]]; then
      for f in "${FOUND[@]}"; do rm -rf "$f"; done
      echo "✅ Cleanup done."
    else
      echo "⏭️  Cleanup skipped."
    fi
  else
    echo "✅ No legacy structures found."
  fi
}

# Copy CLAUDE.md template
install_claude_md() {
  echo "📝 Writing CLAUDE.md..."
  if [ ! -f CLAUDE.md ]; then
    cp "$TPL/CLAUDE.md" CLAUDE.md
    echo "  CLAUDE.md created (template — customize as needed)."
  else
    echo "  CLAUDE.md already exists, skipping."
  fi
}

# Copy AGENTS.md template
install_agents_md() {
  echo "📝 Writing AGENTS.md..."
  if [ ! -f AGENTS.md ]; then
    cp "$TPL/AGENTS.md" AGENTS.md
    echo "  AGENTS.md created (template — customize as needed)."
  else
    echo "  AGENTS.md already exists, skipping."
  fi
}

# Create .claude/settings.json
install_settings() {
  echo "⚙️  Writing .claude/settings.json..."
  mkdir -p .claude
  _install_or_update_file "$TPL/claude/settings.json" .claude/settings.json
}

# Install hook scripts
install_hooks() {
  echo "🛡️  Creating hooks..."
  mkdir -p .claude/hooks

  while IFS= read -r -d '' _hook_path; do
    _hook_name="${_hook_path##*/}"
    _install_or_update_file "$_hook_path" ".claude/hooks/$_hook_name"
  done < <(find "$TPL/claude/hooks" -maxdepth 1 -type f -print0 | sort -z)
}

# Install rule templates
install_rules() {
  echo "📐 Installing rules..."
  mkdir -p .claude/rules

  while IFS= read -r -d '' _rule_path; do
    _rule_name="${_rule_path##*/}"
    # Skip typescript.md — handled conditionally below via TS_RULES_MAP
    [ "$_rule_name" = "typescript.md" ] && continue
    _install_or_update_file "$_rule_path" ".claude/rules/$_rule_name"
  done < <(find "$TPL/claude/rules" -maxdepth 1 -type f -print0 | sort -z)

  # Conditional: install TypeScript rules only when TS files are detected
  local _ts_found
  _ts_found=$(find . \( -name "*.ts" -o -name "*.tsx" \) -not -path "*/node_modules/*" 2>/dev/null | head -1)
  if [ -n "$_ts_found" ]; then
    echo "  TypeScript detected — installing typescript.md rules..."
    for _ts_mapping in "${TS_RULES_MAP[@]}"; do
      local _ts_tpl="${_ts_mapping%%:*}"
      local _ts_target="${_ts_mapping#*:}"
      _install_or_update_file "$SCRIPT_DIR/$_ts_tpl" "$_ts_target"
    done
  fi
}

# Install all GitHub templates (copilot instructions + workflows)
install_copilot() {
  mkdir -p .github
  while IFS= read -r -d '' _gh_path; do
    local _rel="${_gh_path#$TPL/github/}"
    local _target=".github/$_rel"
    _install_or_update_file "$_gh_path" "$_target"
  done < <(find "$TPL/github" -type f -print0 | sort -z)
}

# Create specs/ directory structure
install_specs() {
  echo "📋 Setting up spec-driven workflow..."
  mkdir -p specs/completed
  _install_or_update_file "$TPL/specs/TEMPLATE.md" specs/TEMPLATE.md
  _install_or_update_file "$TPL/specs/README.md" specs/README.md
  if [ ! -f specs/completed/.gitkeep ]; then
    touch specs/completed/.gitkeep
  fi
}

# Install slash commands
install_commands() {
  echo "⚡ Installing slash commands..."
  mkdir -p .claude/commands
  while IFS= read -r -d '' _cmd_path; do
    _cmd_name="${_cmd_path##*/}"
    _install_or_update_file "$_cmd_path" ".claude/commands/$_cmd_name"
  done < <(find "$TPL/commands" -maxdepth 1 -type f -print0 | sort -z)
}

# Install Shopify-specific template skills (when system includes shopify)
install_shopify_skills() {
  if [[ "${SYSTEM:-}" == *shopify* ]]; then
    echo "  🛍️  Installing Shopify skills..."
    for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
      local local_tpl="${mapping%%:*}"
      local local_target="${mapping#*:}"
      local skill_dir
      skill_dir="$(dirname "$local_target")"
      mkdir -p "$skill_dir"
      # Backwards-compat: rename legacy prompt.md to SKILL.md if present
      if [ -f "$skill_dir/prompt.md" ] && [ ! -f "$skill_dir/SKILL.md" ]; then
        mv "$skill_dir/prompt.md" "$skill_dir/SKILL.md"
      fi
      _install_or_update_file "$TPL/${local_tpl#templates/}" "$local_target"
    done
  fi
}

# Install subagent templates
install_agents() {
  echo "🤖 Installing subagent templates..."
  mkdir -p .claude/agents
  while IFS= read -r -d '' _agent_path; do
    _agent_name="${_agent_path##*/}"
    _install_or_update_file "$_agent_path" ".claude/agents/$_agent_name"
  done < <(find "$TPL/agents" -maxdepth 1 -type f -print0 | sort -z)
  _inject_agent_skills
}

# Inject skills: field into agent YAML headers based on detected system.
# Runs after agent templates are copied. Idempotent — skips if skills: already present.
_inject_agent_skills() {
  # Insert a skills block before the closing --- in an agent's YAML frontmatter.
  # Usage: _inject_skill "agent-name.md" "skill1" "skill2" ...
  _inject_skill() {
    local agent_file=".claude/agents/$1"
    shift
    [ -f "$agent_file" ] || return 0
    grep -q '^skills:' "$agent_file" && return 0

    local skills_block="skills:"
    for s in "$@"; do
      skills_block="$skills_block
  - $s"
    done

    # Build new file: insert skills block before closing ---
    local in_front=false
    local done_inject=false
    local tmpfile
    tmpfile=$(mktemp)
    while IFS= read -r line; do
      if [ "$done_inject" = "true" ]; then
        printf '%s\n' "$line" >> "$tmpfile"
      elif [ "$in_front" = "false" ] && [ "$line" = "---" ]; then
        in_front=true
        printf '%s\n' "$line" >> "$tmpfile"
      elif [ "$in_front" = "true" ] && [ "$line" = "---" ]; then
        printf '%s\n' "$skills_block" >> "$tmpfile"
        printf '%s\n' "$line" >> "$tmpfile"
        done_inject=true
      else
        printf '%s\n' "$line" >> "$tmpfile"
      fi
    done < "$agent_file"
    mv "$tmpfile" "$agent_file"
  }

  if [ "$SYSTEM" = "shopify" ]; then
    _inject_skill "liquid-linter.md" "shopify-liquid" "shopify-theme-dev"
    _inject_skill "code-reviewer.md" "shopify-theme-dev"
  fi

  if [ "$SYSTEM" = "shopware" ]; then
    _inject_skill "code-reviewer.md" "shopware6-best-practices"
  fi

  # vitest skill for test-generator (any system, if vitest is installed)
  if [ -d ".claude/skills/vitest" ]; then
    _inject_skill "test-generator.md" "vitest"
  fi
}

# Merge top-level skill items from $1 into $2.
# Non-conflicting items are moved, conflicts are moved to backup dir and counted.
merge_skills_dir_into_canonical() {
  local source_dir="$1"
  local canonical_dir="$2"
  local backup_dir="$3"
  local moved_ref="$4"
  local conflicts_ref="$5"
  local item
  local name
  local target

  [ -d "$source_dir" ] || return 0

  while IFS= read -r -d '' item; do
    name="${item##*/}"
    target="$canonical_dir/$name"
    if [ ! -e "$target" ]; then
      if mv "$item" "$target" 2>/dev/null; then
        eval "$moved_ref=\$(( $moved_ref + 1 ))"
      else
        mkdir -p "$backup_dir"
        mv "$item" "$backup_dir/$name" 2>/dev/null || true
        eval "$conflicts_ref=\$(( $conflicts_ref + 1 ))"
      fi
    else
      mkdir -p "$backup_dir"
      mv "$item" "$backup_dir/$name" 2>/dev/null || true
      eval "$conflicts_ref=\$(( $conflicts_ref + 1 ))"
    fi
  done < <(find "$source_dir" -mindepth 1 -maxdepth 1 -print0)
}

# Repair looping skill symlinks inside canonical dir, e.g.
# .claude/skills/nuxt -> ../../.agents/skills/nuxt while .agents/skills links back.
# Restores from ~/.agents/skills or ~/.claude/skills when available.
repair_canonical_skill_links() {
  local canonical_dir="$1"
  local canonical_abs="$2"
  local repaired=0
  local removed=0
  local link
  local name
  local target_rel
  local target_abs
  local src

  [ -d "$canonical_dir" ] || return 0

  while IFS= read -r -d '' link; do
    name="${link##*/}"
    target_rel=$(readlink "$link" 2>/dev/null || echo "")
    target_abs=$(cd "$(dirname "$link")" 2>/dev/null && cd "$target_rel" 2>/dev/null && pwd -P)

    case "$target_rel" in
      *".agents/skills/$name"|*".claude/skills/$name")
        rm -f "$link" 2>/dev/null || true
        src=""
        [ -d "$HOME/.agents/skills/$name" ] && src="$HOME/.agents/skills/$name"
        [ -z "$src" ] && [ -d "$HOME/.claude/skills/$name" ] && src="$HOME/.claude/skills/$name"
        if [ -n "$src" ]; then
          cp -R "$src" "$canonical_dir/$name" 2>/dev/null || mkdir -p "$canonical_dir/$name"
          repaired=$((repaired + 1))
          echo "  🛠️  Repaired skill link loop: $name (restored from $(basename "$(dirname "$src")"))"
        else
          removed=$((removed + 1))
          echo "  ⚠️  Removed looping skill link: $name (reinstall if needed)"
        fi
        ;;
      *)
        # Self-referential absolute resolution also indicates a loop.
        if [ -n "$target_abs" ] && [ "$target_abs" = "$canonical_abs/$name" ]; then
          rm -f "$link" 2>/dev/null || true
          removed=$((removed + 1))
          echo "  ⚠️  Removed self-referential skill link: $name"
        fi
        ;;
    esac
  done < <(find "$canonical_dir" -mindepth 1 -maxdepth 1 -type l -print0)

  [ "$repaired" -gt 0 ] && echo "  ✅ Repaired $repaired looping skill link(s)"
  [ "$removed" -gt 0 ] && echo "  ℹ️  Removed $removed broken skill link(s)"
  return 0
}

# Keep .claude/skills as canonical and expose .agents/skills as symlink alias.
# Falls back gracefully when symlinks are not available.
ensure_skills_alias() {
  local canonical=".claude/skills"
  local alias=".agents/skills"
  local moved=0
  local conflicts=0
  local ts
  local backup_dir
  local canonical_abs
  local project_abs
  local canonical_target
  local canonical_target_abs
  local alias_target
  local alias_abs

  mkdir -p .claude .agents
  ts=$(date +"%Y%m%d_%H%M%S")
  backup_dir=".ai-setup-backup/skills-migration-$ts"
  project_abs=$(pwd -P 2>/dev/null || pwd)

  # Canonical path must be a real directory (not a symlink), otherwise loops can occur.
  if [ -L "$canonical" ]; then
    canonical_target=$(readlink "$canonical" 2>/dev/null || echo "")
    canonical_target_abs=$(cd "$(dirname "$canonical")" 2>/dev/null && cd "$canonical_target" 2>/dev/null && pwd -P)
    echo "  ♻️  Converting legacy symlink $canonical -> ${canonical_target:-<unresolved>} to canonical directory"
    rm -f "$canonical" 2>/dev/null || true
    mkdir -p "$canonical"

    # Only migrate automatically from in-project targets (e.g. .agents/skills).
    if [ -n "$canonical_target_abs" ] && [ -d "$canonical_target_abs" ]; then
      case "$canonical_target_abs" in
        "$project_abs"/*)
          merge_skills_dir_into_canonical "$canonical_target_abs" "$canonical" "$backup_dir" moved conflicts
          ;;
        *)
          echo "  ℹ️  Skipping auto-migration from external target: $canonical_target_abs"
          ;;
      esac
    fi
  fi

  # Guard against unexpected file at canonical path.
  if [ ! -d "$canonical" ]; then
    if [ -e "$canonical" ]; then
      mkdir -p "$backup_dir"
      mv "$canonical" "$backup_dir/skills-canonical-path-$ts" 2>/dev/null || rm -f "$canonical" 2>/dev/null || true
      conflicts=$((conflicts + 1))
    fi
    mkdir -p "$canonical"
  fi

  canonical_abs=$(cd "$canonical" 2>/dev/null && pwd -P)
  repair_canonical_skill_links "$canonical" "$canonical_abs"

  if [ -L "$alias" ]; then
    alias_target=$(readlink "$alias" 2>/dev/null || echo "")
    alias_abs=$(cd "$(dirname "$alias")" 2>/dev/null && cd "$alias_target" 2>/dev/null && pwd -P)
    if [ -n "$alias_abs" ] && [ -n "$canonical_abs" ] && [ "$alias_abs" = "$canonical_abs" ]; then
      return 0
    fi
    echo "  ♻️  Repointing legacy symlink $alias -> $alias_target to canonical $canonical"
    if [ -n "$alias_abs" ] && [ -d "$alias_abs" ]; then
      merge_skills_dir_into_canonical "$alias_abs" "$canonical" "$backup_dir" moved conflicts
    fi
    rm -f "$alias" 2>/dev/null || true
  fi

  # Migrate legacy non-symlink layout (.agents/skills as real directory).
  if [ -d "$alias" ] && [ -n "$(ls -A "$alias" 2>/dev/null)" ]; then
    echo "  ♻️  Migrating legacy skills layout ($alias -> $canonical)..."
    merge_skills_dir_into_canonical "$alias" "$canonical" "$backup_dir" moved conflicts
  fi

  [ "$moved" -gt 0 ] && echo "  ✅ Migrated $moved skill item(s) into $canonical" || true
  [ "$conflicts" -gt 0 ] && echo "  ⚠️  $conflicts conflicting item(s) backed up to $backup_dir" || true

  if [ -d "$alias" ]; then
    rm -rf "$alias" 2>/dev/null || true
  fi

  if ln -s ../.claude/skills "$alias" 2>/dev/null; then
    echo "  🔗 Linked $alias -> ../.claude/skills"
  else
    echo "  ℹ️  Symlink not available on this system. Using $canonical only."
  fi
}

# Heuristic module detection from repository name.
_detect_repo_module() {
  local _name
  _name=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
  case "$_name" in
    *sub-theme*) echo "sub-theme" ;;
    *theme*) echo "theme" ;;
    *plugin*) echo "plugin" ;;
    *shop*) echo "shop" ;;
    *frontend*|*front-end*|*client*|*ui*) echo "frontend" ;;
    *backend*|*back-end*|*api*|*server*) echo "backend" ;;
    *core*) echo "core" ;;
    *) echo "app" ;;
  esac
}

# Optional wizard: creates .agents/context/repo-group.json for cross-repo context.
setup_repo_group_context() {
  local group_file=".agents/context/repo-group.json"
  mkdir -p .agents/context

  if [ -f "$group_file" ]; then
    echo "🔗 Multi-repo context map already exists, skipping."
    return 0
  fi

  echo ""
  echo "🔗 Multi-Repo Context (optional)"
  read -p "   Setup shared repo map (.agents/context/repo-group.json)? (y/N) " SETUP_MULTI_REPO
  [[ "$SETUP_MULTI_REPO" =~ ^[Yy]$ ]] || return 0

  local current_repo parent_dir default_group group_name
  current_repo="$(basename "$PWD")"
  parent_dir="$(cd .. && pwd)"
  default_group="$current_repo"
  if [[ "$current_repo" == *-* ]]; then
    default_group="${current_repo##*-}"
  fi

  read -p "   Group name [${default_group}]: " group_name
  [ -n "$group_name" ] || group_name="$default_group"

  local repos_json
  repos_json=$(jq -n --arg g "$group_name" '{group:$g,repos:[]}')

  local selected=0
  local dir repo_name include_ans module module_default rel_path
  while IFS= read -r dir; do
    [ -d "$dir" ] || continue
    repo_name="$(basename "$dir")"

    # Filter obvious non-project directories.
    if [ ! -d "$dir/.git" ] && [ ! -f "$dir/package.json" ] && [ ! -f "$dir/composer.json" ]; then
      continue
    fi

    if [ "$repo_name" = "$current_repo" ]; then
      read -p "   Include ${repo_name} (current repo)? (Y/n) " include_ans
      [[ "$include_ans" =~ ^[Nn]$ ]] && continue
    else
      read -p "   Include ${repo_name}? (y/N) " include_ans
      [[ "$include_ans" =~ ^[Yy]$ ]] || continue
    fi

    module_default="$(_detect_repo_module "$repo_name")"
    read -p "      Module for ${repo_name} [${module_default}]: " module
    [ -n "$module" ] || module="$module_default"

    if [ "$repo_name" = "$current_repo" ]; then
      rel_path="."
    else
      rel_path="../${repo_name}"
    fi

    repos_json=$(printf '%s' "$repos_json" \
      | jq --arg n "$repo_name" --arg m "$module" --arg p "$rel_path" '.repos += [{name:$n,module:$m,path:$p}]')
    selected=$((selected + 1))
  done < <(find "$parent_dir" -maxdepth 1 -mindepth 1 -type d ! -name ".*" | sort)

  # Ensure current repo is present.
  if ! printf '%s' "$repos_json" | jq -e --arg n "$current_repo" '.repos[]? | select(.name == $n)' >/dev/null 2>&1; then
    module_default="$(_detect_repo_module "$current_repo")"
    repos_json=$(printf '%s' "$repos_json" \
      | jq --arg n "$current_repo" --arg m "$module_default" --arg p "." '.repos += [{name:$n,module:$m,path:$p}]')
    selected=$((selected + 1))
  fi

  if [ "$selected" -lt 2 ]; then
    echo "   ⏭️  Skipping map (need at least 2 repos in group)."
    return 0
  fi

  printf '%s\n' "$repos_json" | jq '.' > "$group_file"
  echo "   ✅ Created $group_file (${selected} repos)"
}

# Update .gitignore with AI setup entries
update_gitignore() {
  echo "🚫 Updating .gitignore..."
  if [ -f .gitignore ]; then
    if ! grep -q "claude/settings.local" .gitignore 2>/dev/null; then
      echo "" >> .gitignore
      echo "# Claude Code / AI Setup" >> .gitignore
      echo ".claude/settings.local.json" >> .gitignore
      echo ".ai-setup.json" >> .gitignore
      echo ".ai-setup-backup/" >> .gitignore
      echo ".agents/context/.state" >> .gitignore
      echo ".agents/repomix-snapshot.md" >> .gitignore
      echo "CLAUDE.local.md" >> .gitignore
    else
      # Add new entries if missing from existing block
      grep -q "\.ai-setup\.json" .gitignore 2>/dev/null || echo ".ai-setup.json" >> .gitignore
      grep -q "\.ai-setup-backup" .gitignore 2>/dev/null || echo ".ai-setup-backup/" >> .gitignore
      grep -q "\.agents/context/\.state" .gitignore 2>/dev/null || echo ".agents/context/.state" >> .gitignore
      grep -q "repomix-snapshot" .gitignore 2>/dev/null || echo ".agents/repomix-snapshot.md" >> .gitignore
      grep -q "CLAUDE\.local\.md" .gitignore 2>/dev/null || echo "CLAUDE.local.md" >> .gitignore
    fi
  else
    echo "# Claude Code / AI Setup" > .gitignore
    echo ".claude/settings.local.json" >> .gitignore
    echo ".ai-setup.json" >> .gitignore
    echo ".ai-setup-backup/" >> .gitignore
    echo ".agents/context/.state" >> .gitignore
    echo ".agents/repomix-snapshot.md" >> .gitignore
    echo "CLAUDE.local.md" >> .gitignore
  fi

  # AGENTS.md should be tracked like CLAUDE.md (never ignored)
  if grep -Eq '^[[:space:]]*/?AGENTS\.md[[:space:]]*$' .gitignore 2>/dev/null; then
    local tmp_gitignore
    tmp_gitignore=$(mktemp)
    awk '!/^[[:space:]]*\/?AGENTS\.md[[:space:]]*$/' .gitignore > "$tmp_gitignore" && mv "$tmp_gitignore" .gitignore
    echo "  Removed AGENTS.md from .gitignore (must be committed)."
  fi
}

# Map Claude Code model shorthand to OpenCode provider/model format
_oc_model() {
  case "$1" in
    haiku)  echo "anthropic/claude-haiku-4-5" ;;
    opus)   echo "anthropic/claude-opus-4-6" ;;
    *)      echo "anthropic/claude-sonnet-4-6" ;;
  esac
}

# Generate opencode.json for OpenCode compatibility
# Translates agents, commands, MCP servers from Claude Code format
generate_opencode_config() {
  if [ -f opencode.json ]; then
    echo "  opencode.json already exists, skipping."
    return 0
  fi

  command -v jq &>/dev/null || return 0

  # MCP servers from .mcp.json
  local mcp_block="{}"
  if [ -f .mcp.json ]; then
    mcp_block=$(jq '.mcpServers // {}' .mcp.json 2>/dev/null || echo "{}")
  fi

  # Agents from .claude/agents/*.md
  local agents_json="{}"
  if [ -d .claude/agents ]; then
    for agent_file in .claude/agents/*.md; do
      [ -f "$agent_file" ] || continue
      local aname amodel adesc atools
      aname=$(basename "$agent_file" .md)
      # Extract frontmatter fields (awk for macOS/BSD compat)
      adesc=$(awk '/^---$/{n++; next} n==1 && /^description:/{sub(/^description: */, ""); print}' "$agent_file" | head -1)
      amodel=$(awk '/^---$/{n++; next} n==1 && /^model:/{sub(/^model: */, ""); print}' "$agent_file" | head -1)
      atools=$(awk '/^---$/{n++; next} n==1 && /^tools:/{sub(/^tools: */, ""); print}' "$agent_file" | head -1)

      [ -z "$adesc" ] && adesc="$aname agent"

      # Map tools to OpenCode permissions
      local t_read=false t_write=false t_bash=false
      case "$atools" in *Read*|*Glob*|*Grep*) t_read=true ;; esac
      case "$atools" in *Write*|*Edit*) t_write=true ;; esac
      case "$atools" in *Bash*) t_bash=true ;; esac

      agents_json=$(printf '%s' "$agents_json" | jq -c \
        --arg name "$aname" \
        --arg desc "$adesc" \
        --arg model "$(_oc_model "$amodel")" \
        --arg file "$agent_file" \
        --argjson r "$t_read" --argjson w "$t_write" --argjson b "$t_bash" \
        '.[$name] = {
          "description": $desc,
          "mode": "subagent",
          "model": $model,
          "prompt": ("{file:" + $file + "}"),
          "tools": {"read": $r, "write": $w, "edit": $w, "bash": $b}
        }')
    done
  fi

  # Commands from .claude/commands/*.md
  local commands_json="{}"
  if [ -d .claude/commands ]; then
    for cmd_file in .claude/commands/*.md; do
      [ -f "$cmd_file" ] || continue
      local cname cmodel
      cname=$(basename "$cmd_file" .md)
      cmodel=$(awk '/^---$/{n++; next} n==1 && /^model:/{sub(/^model: */, ""); print}' "$cmd_file" | head -1)

      # Derive description from filename (kebab-case to words)
      local cdesc
      cdesc=$(echo "$cname" | tr '-' ' ')

      commands_json=$(printf '%s' "$commands_json" | jq -c \
        --arg name "$cname" \
        --arg desc "$cdesc" \
        --arg file "$cmd_file" \
        '.[$name] = {"description": $desc, "template": ("{file:" + $file + "}\\n\\n$ARGUMENTS")}')
    done
  fi

  # Assemble final config
  jq -n \
    --arg schema "https://opencode.ai/config.json" \
    --arg model "anthropic/claude-sonnet-4-6" \
    --arg small "anthropic/claude-haiku-4-5" \
    --argjson mcp "$mcp_block" \
    --argjson agents "$agents_json" \
    --argjson commands "$commands_json" \
    '{
      "$schema": $schema,
      "model": $model,
      "small_model": $small,
      "instructions": ["CLAUDE.md"],
      "mcp": $mcp,
      "agent": $agents,
      "command": $commands
    }' > opencode.json 2>/dev/null

  if [ -f opencode.json ]; then
    local ac=0 cc=0
    ac=$(echo "$agents_json" | jq 'keys | length' 2>/dev/null || echo 0)
    cc=$(echo "$commands_json" | jq 'keys | length' 2>/dev/null || echo 0)
    echo "  opencode.json created ($ac agents, $cc commands, OpenCode compatibility)"
  fi
}

# Install repomix.config.json for codebase snapshot configuration
install_repomix_config() {
  if [ ! -f repomix.config.json ]; then
    cp "$TPL/repomix.config.json" repomix.config.json
  else
    echo "  repomix.config.json already exists, skipping."
  fi
}

# Install statusline script into project (.claude/statusline.sh) and configure
# project settings (.claude/settings.json).
install_statusline_project() {
  # Idempotency: skip if statusLine is already configured
  if [ -f ".claude/settings.json" ] && jq -e '.statusLine' ".claude/settings.json" >/dev/null 2>&1; then
    return 0
  fi
  mkdir -p ".claude"
  cp "$SCRIPT_DIR/templates/statusline.sh" ".claude/statusline.sh"
  chmod +x ".claude/statusline.sh"
  # Merge statusLine into .claude/settings.json
  local status_cmd='"${CLAUDE_PROJECT_DIR:-.}"/.claude/statusline.sh'
  if [ -f ".claude/settings.json" ]; then
    local TMP
    TMP=$(mktemp)
    jq --arg cmd "$status_cmd" '.statusLine = {"type":"command","command":$cmd,"padding":2}' ".claude/settings.json" > "$TMP" && mv "$TMP" ".claude/settings.json"
  else
    jq -n --arg cmd "$status_cmd" '{"statusLine":{"type":"command","command":$cmd,"padding":2}}' > ".claude/settings.json"
  fi
  echo "  Statusline installed -> .claude/statusline.sh"
}

# Generate repomix codebase snapshot in background (once, if not already present)
generate_repomix_snapshot() {
  if [ -f ".agents/repomix-snapshot.md" ]; then
    return 0
  fi
  mkdir -p .agents
  echo "📸 Generating codebase snapshot (repomix)..."

  local _repomix_timeout=""
  command -v timeout &>/dev/null && _repomix_timeout="timeout 120"
  command -v gtimeout &>/dev/null && _repomix_timeout="gtimeout 120"

  # Use repomix.config.json if present (user-customizable), otherwise fall back to defaults
  if [ -f "repomix.config.json" ]; then
    $_repomix_timeout npx -y repomix >/dev/null 2>&1 &
  else
    $_repomix_timeout npx -y repomix --compress --style markdown \
      --ignore "node_modules,dist,.git,.next,.nuxt,coverage,.turbo,*.lock,*.lockb" \
      --output .agents/repomix-snapshot.md >/dev/null 2>&1 &
  fi
  REPOMIX_PID=$!

  SPIN='-\|/'
  i=0
  while kill -0 $REPOMIX_PID 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    printf "\r  ${SPIN:$i:1} Analyzing codebase..."
    sleep 0.2
  done

  REPOMIX_EXIT=0
  wait $REPOMIX_PID 2>/dev/null || REPOMIX_EXIT=$?

  if [ $REPOMIX_EXIT -eq 0 ] && [ -f ".agents/repomix-snapshot.md" ]; then
    LINES=$(wc -l < .agents/repomix-snapshot.md 2>/dev/null || echo "?")
    printf "\r  ✅ Snapshot written to .agents/repomix-snapshot.md (%s lines)%*s\n" "$LINES" 10 ""
  else
    printf "\r  ⏭️  repomix unavailable, skipping snapshot%*s\n" 20 ""
    rm -f .agents/repomix-snapshot.md
  fi
}
````

## File: README.md
````markdown
# @onedot/ai-setup

Production-ready AI infrastructure for Claude Code. One command installs hooks, slash commands, subagents, project context, and AI-curated skills — then Claude analyzes the codebase and populates everything automatically.

```bash
npx github:onedot-digital-crew/npx-ai-setup
```

Supports Shopify, Nuxt, Next.js, Laravel, Shopware, Storyblok, or auto-detection.

---

## What it installs

| Layer | What |
|-------|------|
| **CLAUDE.md** | Communication protocol, task routing (simple/medium/complex), verification gate |
| **AGENTS.md** | Universal passive context for Cursor, Windsurf, Cline, and AGENTS.md-compatible tools |
| **Settings** | Granular bash permissions, opusplan model, AUTOCOMPACT=30, ENABLE_TOOL_SEARCH |
| **Hooks** | protect-files, auto-lint, circuit-breaker, context-freshness, update-check, cross-repo-context, notifications, SessionStart context reload, PostToolUseFailure log, ConfigChange audit, TaskCompleted gate, Stop quality gate |
| **Rules** | `.claude/rules/` — general, testing, git, typescript (conditional) |
| **Commands** | 16 slash commands for spec-driven development, reviews, releases, debugging |
| **Agents** | 8 subagent templates for parallel verification, review, and architectural assessment |
| **Context** | `.agents/context/` — STACK.md, ARCHITECTURE.md, CONVENTIONS.md (auto-generated) |
| **GitHub** | `.github/copilot-instructions.md` + `.github/workflows/release-from-changelog.yml` |
| **Skills** | AI-curated Claude Code skills matched to your stack via skills.sh |

---

## Multi-Repo Context (without naming convention)

For projects split across multiple repositories (e.g. Shopware theme/plugin/shop or Laravel frontend/backend), add an optional map file:

` .agents/context/repo-group.json `

Example:

```json
{
  "group": "or24",
  "repos": [
    { "name": "sw-theme-or24", "module": "theme", "path": "../sw-theme-or24" },
    { "name": "sw-sub-theme-or24", "module": "sub-theme", "path": "../sw-sub-theme-or24" },
    { "name": "sw-plugin-or24", "module": "plugin", "path": "../sw-plugin-or24" },
    { "name": "sw-shop-or24", "module": "shop", "path": "../sw-shop-or24" }
  ]
}
```

On `SessionStart`, the `cross-repo-context` hook reads this file and injects a compact sibling-repo summary automatically.

If the file is absent, it falls back to automatic discovery for `sw-<module>-<project>` naming.

During `ai-setup`, you can create this file via an interactive prompt (`Multi-Repo Context` wizard).

---

## Slash Commands

| Command | Model | Description |
|---------|-------|-------------|
| `/spec "task"` | Opus | Challenge idea first, then create structured spec |
| `/spec-work 001` | Sonnet | Execute a spec step by step |
| `/spec-work-all` | Sonnet | Execute all draft specs in parallel via Git worktrees |
| `/spec-review 001` | Opus | Review spec changes against acceptance criteria |
| `/spec-board` | Sonnet | Kanban-style overview of all specs |
| `/bug "description"` | Sonnet | Reproduce → root cause → fix → verify → code review |
| `/commit` | Sonnet | Stage changes + create descriptive commit |
| `/pr` | Sonnet | Draft PR title/body, run build validation |
| `/review` | Opus | Review uncommitted changes — bugs, security, performance |
| `/test` | Sonnet | Run tests + fix failures (up to 3 attempts) |
| `/techdebt` | Sonnet | End-of-session sweep — dead code, unused imports |
| `/release` | Sonnet | Bump version, update CHANGELOG, commit + git tag |
| `/grill` | Opus | Adversarial code review — blocks until all issues resolved |
| `/analyze` | Sonnet | 3 parallel agents — architecture, hotspots, risks |
| `/reflect` | Sonnet | Detect session corrections → write as permanent CLAUDE.md rules |
| `/context-full` | Sonnet | Full codebase snapshot via repomix |

## Subagents

| Agent | Purpose |
|-------|---------|
| `verify-app` | Run tests + build, report PASS/FAIL |
| `build-validator` | Quick build check (Haiku) |
| `code-reviewer` | HIGH/MEDIUM confidence review — PASS/CONCERNS/FAIL |
| `code-architect` | Architectural assessment before implementation |
| `staff-reviewer` | Skeptical staff engineer review |
| `perf-reviewer` | Performance analysis — FAST/CONCERNS/SLOW |
| `test-generator` | Generate missing tests for changed files |
| `context-refresher` | Regenerate `.agents/context/` on `[CONTEXT STALE]` |

---

## Installation flags

```bash
npx github:onedot-digital-crew/npx-ai-setup [flags]

--system nuxt,storyblok   # Set framework (auto, shopify, nuxt, next, laravel, shopware, storyblok)
--regenerate              # Re-run Auto-Init without reinstalling files
```

---

## Update

Run the same command again — the script auto-detects and offers:

- **Update files** — compare each template, ask before overwriting user-modified files
- **Regenerate** — re-run Claude analysis (CLAUDE.md, AGENTS.md, context, commands, skills)
- **Clean reinstall** — remove all managed files, fresh install

### Update existing projects in ~60s

```bash
npx github:onedot-digital-crew/npx-ai-setup
```

Recommended flow in existing repositories:

1. Choose **Update** (not Reinstall).
2. In category selection, keep at least **Hooks** and **Settings** enabled.
3. For modified files, review each prompt:
   - `y` = update file (your previous version is backed up to `.ai-setup-backup/`)
   - `N` = keep your local customization
4. Legacy skills layout is auto-normalized:
   - canonical path: `.claude/skills/`
   - alias path: `.agents/skills -> ../.claude/skills`
   - conflicting legacy items are backed up to `.ai-setup-backup/skills-migration-*`
5. If prompted, enable **Multi-Repo Context** to generate `.agents/context/repo-group.json` (works without naming convention).
6. Optional: run **Regenerate** if your stack/architecture changed.

---

## Testing

Run local smoke checks before publishing:

```bash
npm test
```

CI also runs `tests/smoke.sh` automatically on every pull request and push to `main`.

To enforce tests before every push, install the tracked git hook once per clone:

```bash
npm run hooks:install
```

Check current hook path:

```bash
npm run hooks:status
```

Temporary bypass (only if needed):

```bash
SKIP_PREPUSH_TESTS=1 git push
```

---

## GitHub Releases (Slack-ready)

AI Setup installs `.github/workflows/release-from-changelog.yml` into target projects.
When you push a version tag like `v1.2.5`, it creates or updates the GitHub Release body from the matching `CHANGELOG.md` section:

- Required heading format: `## [vX.Y.Z]`
- Fallback if tag push is delayed: `gh workflow run release-from-changelog.yml -f tag=vX.Y.Z`
- Slack GitHub App (`/github subscribe owner/repo releases`) will show this release body in channel notifications.

---

## Requirements

- Node.js >= 18 + npm
- `jq` — `brew install jq`
- Claude Code CLI (`claude`) — for Auto-Init (optional, Copilot as fallback)

---

## Built-in Plugins & Extensions

All plugins and integrations are installed automatically — no flags needed.

| Plugin | What it does |
|--------|-------------|
| **claude-mem** | Persistent memory across sessions, MCP search tools |
| **claude-plugin@coderabbitai** | CodeRabbit PR review companion plugin for Claude Code |
| **code-review** | 4 parallel review agents — `/code-review` |
| **feature-dev** | 7-phase feature workflow — `/feature-dev` |
| **frontend-design** | Anti-generic design guidance for frontend projects |
| **Context7** | Up-to-date library docs in context — "use context7" |

Team sharing: marketplace plugins via `extraKnownMarketplaces` in `.claude/settings.json`, MCP servers via `.mcp.json` — both committed to git.

---

## Optional Extensions

### rtk (Reduce Token Cost)

CLI proxy that compresses command outputs before they hit the context window. 60-90% token reduction on git, grep, test outputs.

```bash
brew install rtk && rtk init --global
```

More info: [rtk-ai/rtk](https://github.com/rtk-ai/rtk)

---

## Default skills by system

| System | Skills installed |
|--------|-----------------|
| **Shopify** | shopify-development, shopify-expert, shopify-theme-dev |
| **Nuxt / Vue** | nuxt, vue, vueuse |
| **Next.js / React** | vercel-react-best-practices, nextjs-developer, nextjs-app-router-patterns |
| **Laravel** | laravel-specialist, eloquent-best-practices |
| **Shopware** | shopware6-best-practices |
| **Storyblok** | storyblok-best-practices |

---

---

## Links

- [Skills marketplace](https://skills.sh/)
- [Claude-Mem](https://claude-mem.ai)
- [CodeRabbit Claude Plugin](https://github.com/coderabbitai/claude-plugin)
- [Context7](https://github.com/upstash/context7)
- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)
- [Concept & Design Decisions](.agents/context/CONCEPT.md)
````

## File: CHANGELOG.md
````markdown
# Changelog

All notable changes are recorded here automatically when specs are completed via `/spec-work`.

Format: grouped by version. New entries go under `## [Unreleased]` and are moved to a versioned heading when `/release` is run.

---

<!-- Entries are prepended below this line, newest first -->

## [Unreleased]

## [v1.2.8] — 2026-03-09

- **Agent skill injection**: installer now injects `skills:` into agent YAML headers based on detected system — Shopify agents get `shopify-liquid`/`shopify-theme-dev`, Shopware agents get `shopware6-best-practices`, and `test-generator` gets `vitest` when available. Idempotent; skips if already present.
- **Agent delegation rules**: new `templates/claude/rules/agents.md` with trigger-condition table for all 9 agents, scope limits, and anti-patterns to prevent over-delegation.
- **Spec backlog cleanup**: pruned 11 backlog specs to 0 — deleted 10 obsolete/redundant specs, consolidated 4 documentation specs into #069, added `BACKLOG.md` with rejected ideas and evaluation items.
- **Template token optimization** (Spec 060): ~2,600 tokens (~11%) saved across 6 templates — compressed `spec.md` Phase 1e from 30 lines to 5-line checklist, deduplicated 4 identical example blocks in `reflect.md`, consolidated duplicated emit logic in `cross-repo-context.sh`, removed inline bash commentary in `update.md`, replaced spec-work duplication in `spec-work-all.md` with reference, removed AGENTS.md table duplication in hooks README.
- **Deadloop prevention hardening** (Spec 059): circuit-breaker WARNING now explicitly says "DO NOT edit this file again" (matches BLOCK tone), context-monitor switched from imperative directives ("Commit current work") to advisory language ("Consider saving state"), post-edit-lint.sh documents why all output is suppressed (deadloop prevention), hooks README adds dead-loop prevention notes section.

## [v1.2.7] — 2026-03-06

- **Release automation hardening**: `release-from-changelog` now supports `create` tag events as a fallback for delayed push events; release docs/command include a manual workflow trigger backup.
- **CodeRabbit plugin integration**: automatic registration of `coderabbitai/claude-plugin` in `extraKnownMarketplaces` + `enabledPlugins`, CLI install with fallback (`claude-plugin@coderabbitai` and `coderabbitai/claude-plugin`), plus installation summary and README coverage.
- **Update visibility improvements**: `update-check` now runs on `SessionStart` and `UserPromptSubmit`; version source fallback chain (`npm` -> GitHub Release -> GitHub Tag); added CLI update notice and statusline badge `ai-setup vX -> vY`.
- **Cross-repo context (framework-agnostic)**: new `cross-repo-context` SessionStart hook with preferred `.agents/context/repo-group.json` map and optional Shopware naming fallback.
- **Multi-repo setup wizard**: `ai-setup` now offers an interactive prompt to create `.agents/context/repo-group.json` with parent-directory repo discovery and module assignment.
- **Quality gates/tests**: smoke tests expanded for new functions and hook wiring (`show_cli_update_notice`, `setup_repo_group_context`, SessionStart hooks incl. `cross-repo-context`, and `repo-group.json` support).


## [v1.2.6] — 2026-03-06

- **Template modernization**: migrated command templates and docs from deprecated `Task` tool wording to `Agent` wording for current Claude Code semantics
- **Hooks expansion**: added `PostToolUseFailure` logging, `ConfigChange` auditing guard, and `TaskCompleted` gate hook templates with settings wiring
- **Statusline improvements**: switched to workspace JSON fields, added lightweight git caching, and standardized generated `statusLine` settings (`type: command`, `padding`)
- **Detection + safety**: improved Shopware/Shopify auto-detection signals, introduced local Shopware skill fallback, and hardened Shopware MCP setup to avoid writing credentials into `.mcp.json`
- **Setup efficiency**: skipped expensive context regeneration in skills-only runs and deduplicated skill installs
- **Quality gates**: added CI smoke workflow for PRs/main pushes and a tracked pre-push hook that runs `npm test`

## [v1.2.5] — 2026-03-05

- **Spec 054**: Bang-Syntax Context Injection — `## Context` sections with `!git` commands in commit, review, pr commands eliminate 2-3 tool-call round-trips for context gathering
- **Spec 053**: Context Monitor Hook — PostToolUse hook warns agent at <=35% (WARNING) and <=25% (CRITICAL) remaining context via statusline bridge file and `additionalContext` injection
- **Spec 052**: Agent Delegation Rules — new `rules/agents.md` template with trigger/scope/model guidance for all 8 agents and anti-patterns to prevent over-delegation
- **Spec 051**: PreCompact Hook — prompt-type hook in `settings.json` that auto-instructs Claude to commit or write HANDOFF.md before context compaction
- **Spec 050**: Post-Edit Hooks — `post-edit-lint.sh` extended with `tsc --noEmit` type-check (TS files, blocking) and `console.log` warning (non-blocking stderr)
- **Spec 049**: /evaluate command — project-local command for systematic evaluation of external ideas against existing template inventory
- **Slack-ready releases**: Added `release-from-changelog.yml` workflow to create/update GitHub releases from `CHANGELOG.md` on pushed `v*` tags
- **Template rollout**: Added workflow template under `templates/github/workflows/` so generated projects get the same release-note automation by default
- **Installer hardening**: `install_copilot()` now installs all files under `templates/github/` recursively, not only `copilot-instructions.md`
- **Release docs/command updates**: README and `/release` command now document the automatic changelog-to-Slack release flow

## [v1.2.4] — 2026-03-04

- **Mandatory plugins**: Context7, claude-mem, and all official plugins (code-review, feature-dev, frontend-design) now install automatically without prompts
- **Removed Playwright & GSD**: Playwright MCP removed from setup; GSD moved to README as optional extension
- **Token optimization**: 15 new deny patterns (lock files, cache dirs, minified assets, source maps), `plansDirectory` and `enableAllProjectMcpServers` settings added
- **Session tips**: CLAUDE.md template now includes `Esc Esc` rewind, `/rename`+`/resume`, commit-checkpoint advice
- **Reflect routing**: `/reflect` now routes architectural discoveries to ARCHITECTURE.md and stack decisions to STACK.md
- **Haiku routing rule**: New rule ensures Explore subagents always use haiku model (60x cost reduction)

## [v1.2.3] — 2026-03-02

- **OpenCode compatibility**: `generate_opencode_config()` generates `opencode.json` from `.claude/agents/`, `.claude/commands/`, and `.mcp.json` — translates model tiers, tool permissions, and MCP servers for OpenCode CLI compatibility
- **Haiku model routing**: Downgraded 4 mechanical commands/agents from sonnet to haiku — `commit.md`, `pr.md`, `spec-board.md`, `context-refresher.md` — reduces token cost for high-frequency low-complexity tasks
- **Agent/command sync**: Added missing `perf-reviewer.md`, `test-generator.md` agents and `analyze.md`, `context-full.md`, `reflect.md`, `release.md`, `spec-board.md` commands to project

## [v1.2.2] — 2026-03-01

- **MCP Health Hook**: `mcp-health.sh` SessionStart hook — validates `.mcp.json` JSON syntax, required fields per server type (`url` for http/sse, `command` for stdio), and base command availability via `command -v`; silent on success, warnings to stderr

## [v1.2.1] — 2026-02-28

- **Spec 047**: Settings + hooks + agent memory — SessionStart hook, AUTOCOMPACT=30, ENABLE_TOOL_SEARCH, PostToolUse failure log, Stop quality gate, agent memory:project + isolation:worktree fields
- **Spec 046**: Statusline global install — optional `~/.claude/statusline.sh` setup with color-coded context bar, model, cost, and git branch display
- **Spec 045**: /grill enhancements — scope challenge step, A/B/C options format, "What already exists" + "NOT reviewed" sections, self-verification table
- **Spec 044**: .claude/rules/ template expansion — testing.md, git.md, typescript.md (conditional), opusplan model, CLAUDE.md memory + tips sections
- **Review fixes**: find precedence bug in TS detection, TS metadata tracking, statusline null-safety + jq guard, SessionStart matcher, idempotent statusline prompt

## [v1.2.0] — 2026-02-27

- **Update UX**: per-file [y/N] prompt before overwriting user-modified files; Update files option available without version change
- **Spec 043**: Self-Improvement Reflect System — new /reflect command detects session corrections and writes them as permanent CLAUDE.md/CONVENTIONS.md rules with user approval
- **Spec 042**: Feedback Loop Patterns — techdebt.md now verifies changes via verify-app, spec-work.md has progress checklist, test.md has explicit attempt tracking
- **Spec 041**: Skill Descriptions Best Practices — all 15 command descriptions now follow "what + when" format in third person, under 120 chars
- **Spec 040**: README & CHANGELOG sync — fix counts (15 cmds/8 agents/6 hooks), compact sections, /release validates all counts
- **Spec 039**: Claude-Mem as team standard — default Y, `<claude-mem-context>` in CLAUDE.md, documents as required plugin
- **Spec 038**: Global Definition of Done — DoD in CONVENTIONS.md, build-artifact rules, /spec-review DoD validation
- **Spec 037**: Claude Code best practices — SKILL.md frontmatter, disable-model-invocation, enriched settings.json, notify.sh
- **Spec 036**: Bash performance — parallel skills search/install, 8-job curl pool, parameter expansion (100+ second runtime reduction)
- **Spec 035**: /analyze command — 3 parallel Explore agents produce architecture/hotspots/risks overview
- **Spec 034**: /bug multi-agent verification — verify-app auto-runs after fix, code-reviewer after verification passes
- **Spec 033**: /pr + /review improvements — build-validator in /pr pipeline, /review covers full branch diff
- **Spec 032**: Local skill templates — bundles tailwind, pinia, drizzle, tanstack, vitest; skips slow skills.sh search
- **Spec 031**: CLAUDE.md generation timeout fix — 120s→180s, correct "timed out" error message
- **Spec 030**: Granular update regeneration — missing context detection, checkbox UI instead of binary prompt

## [v1.1.6] — 2026-02-24

- **Spec 029**: Add perf-reviewer and test-generator agent templates — two new universal agents for performance analysis (read-only, FAST/CONCERNS/SLOW verdict) and test generation (write-guarded to test directories only)
- **Spec 028**: Fully automatic agent integration — `verify-app` auto-runs after spec implementation (blocks code-reviewer on FAIL), `staff-reviewer` auto-runs in `/pr` before draft
- **Spec 027**: Add code-architect agent — new opus agent for architectural assessment, auto-spawned by `spec-work` when spec has `**Complexity**: high`
- **Spec 026**: Add code-reviewer Agent — new reusable `code-reviewer` agent (sonnet) wired automatically into `spec-work` and `spec-review`, replacing inline review logic
- **Spec 025**: Add .claude/rules/general.md template + agent max_turns — installs a universal coding safety rules file and caps agent turn counts as a cost guard
- **Spec 024**: Smoke Test for bin/ai-setup.sh — added tests/smoke.sh and npm test script for syntax and function-presence checks
- **Spec 023**: Fix git add -A in Worktree Prompt — replaced git add -A with git add -u in spec-work-all subagent commit step
- **Spec 022**: Deduplicate Auto-Review Logic — removed duplicated review criteria from spec-work.md auto-review step, replaced with compact summary referencing `/spec-review` for full criteria
- **Spec 021**: /release command and git tagging — added `/release` slash command template, reformatted CHANGELOG with `[Unreleased]` + versioned headings, updated `/spec-work` to target `[Unreleased]`, backfilled git tags v1.1.0–v1.1.4, bumped version to 1.1.5

## [v1.1.4] — 2026-02-23

- **Spec 020**: Granular template update selector — smart update now shows a 5-category checkbox UI (Hooks, Settings, Commands, Agents, Other) before processing templates, so users can update only the categories they want

- **Spec 019**: Shopify templates moved to skills — relocated 8 Shopify knowledge templates from `templates/commands/shopify/` to `templates/skills/shopify-*/prompt.md`, updated all install/update/uninstall references to target `.claude/skills/`, removed redundant `dragnoir/Shopify-agent-skills` marketplace entries

## [v1.1.3] — 2026-02-23

- **Spec 018**: Native worktree rewrite — replaced manual `git worktree add/remove` in spec-work-all with Claude Code's native `Agent(isolation: "worktree")`; subagent now handles .env copy, dep install, and branch rename

- **Spec 016**: Worktree env and deps — `spec-work-all` now auto-copies `.env*` files and runs dependency install (bun/npm/pnpm/yarn) into each worktree before launching agents; failures are warnings, not blockers

## [v1.1.2] — 2026-02-22

- **Spec 015**: Spec workflow branch and review improvements — `/spec-work` now prompts for branch creation before starting and offers auto-review with corrections after execution; `/spec-review` APPROVED verdict no longer suggests PR commands

- **Spec 014**: Skills Discovery Section — added `## Skills Discovery` to `templates/CLAUDE.md` so Claude can search and install skills on demand using `npx skills find` and `npx skills add`

- **feat**: Mini-VibeKanban spec workflow — full status lifecycle (`draft` → `in-progress` → `in-review` → `completed` / `blocked`), `/spec-board` Kanban overview with step progress, `/spec-review NNN` Opus-powered review with PR drafting, `/spec-work-all` rewritten to use Git worktrees for isolated parallel execution, `/spec-work` updated with status transitions

- **Spec 013**: Dynamic Template Map — replaced hardcoded TEMPLATE_MAP array and install loops with dynamic generation from `templates/` directory

- **feat**: `/spec` challenge phase deepened — now thinks through implementation before verdict, mirrors plan mode
- **feat**: `/spec` challenge uses `AskUserQuestion` at decision points during analysis
- **feat**: `/spec` and `/spec-work` auto-load relevant installed skills from `.claude/skills/`
- **feat**: `update-check.sh` hook — notifies at session start when a new `@onedot/ai-setup` version is available
- **fix**: Circuit breaker auto-resets when user sends next message

## [v1.1.1] — 2026-02-21

- **Spec 012**: /bug command — added `/bug` slash command template with structured reproduce → root cause → fix → verify workflow

## [v1.1.0] — 2026-02-21

- **feat**: Merge `/challenge` into `/spec` — spec now challenges the idea first (GO/SIMPLIFY/REJECT verdict) before writing the spec; `/challenge` command removed
- **feat**: Interactive checkbox selector for regeneration — replaces y/N prompt with arrow+space UI; 4 options: CLAUDE.md, Context, Commands, Skills
- **feat**: Split regeneration Skills into Commands (internal slash commands/agents) and Skills (external skills.sh)
- **fix**: Replace full model IDs with short aliases (`sonnet`) in all command/agent frontmatter — fixes IDE validation errors
- **docs**: Add ccusage to README as recommended tool for session token usage analysis
- **Spec 011**: Bulk Spec Execution via Agents — adds `/spec-work-all` slash command for parallel spec execution via subagents
- **feat**: Add `/challenge` command to `templates/commands/`
- **feat**: Expand system skill sets with verified skills — Nuxt adds vue+vueuse, Shopify adds shopify-theme-dev, Next.js adds nextjs-app-router-patterns, Laravel adds eloquent-best-practices
- **fix**: Add skills.sh registry pre-check in `install_skill()` — invalid skills skipped with warning
- **feat**: Add Next.js/React system option with auto-detection and skill routing
- **Spec 010**: Aura Frog Quality Patterns — Added Task Complexity Routing, dual-condition verification gate, and conditional TDD enforcement to `templates/CLAUDE.md`
- **Spec 009**: Auto-Detect System from Codebase Signals — Added `detect_system()` to resolve `--system auto`
- **Spec 008**: Feature Challenge Skill — Added `.claude/commands/challenge.md` with GO/SIMPLIFY/REJECT decision
- **Spec 007**: Deny list security hardening — Added `git clean`, `git checkout --`, `git restore` to deny list
- **Spec (untracked)**: Context-Refresher Subagent + Auto-Trigger
- **Spec (untracked)**: Project Concept Documentation — Added `docs/` with CONCEPT.md, ARCHITECTURE.md, DESIGN-DECISIONS.md
- **Spec 007**: Auto-Updated CHANGELOG.md on Spec Completion
````
