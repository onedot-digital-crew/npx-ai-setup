# Hook Configuration Guide

## Active Hooks

### PreToolUse Hooks (Run BEFORE Edit/Write)

#### 1. protect-files.sh
**Purpose:** Prevents accidental edits to sensitive files
**Protected patterns:** `.env`, `package-lock.json`, `.git/`
**Exit codes:**
- `0` - File is safe to edit
- `2` - File is protected, edit blocked

**Customization:** Edit `PROTECTED` array in `protect-files.sh`

#### 2. circuit-breaker.sh
**Purpose:** Detects infinite loops and repetitive behavior
**Thresholds:**
- Warning at 5 edits to same file within 10 minutes
- Hard block at 8 edits to same file within 10 minutes

**Customization:** Edit `WARN`, `BLOCK`, and `WINDOW` variables

### PostToolUse Hooks (Run AFTER Edit/Write)

#### 1. post-edit-lint.sh
**Purpose:** Auto-fix linting issues after every edit
**File types:** `.js`, `.ts`
**Behavior:** Runs `npx eslint <file> --fix`

**Customization:**
- Add more file extensions: `[[ "$FILE_PATH" == *.jsx || "$FILE_PATH" == *.tsx ]]`
- Change linter: Replace `npx eslint` with `npx prettier --write`

## Debugging Hooks

Test a hook manually:
```bash
echo '{"tool_input":{"file_path":"test.js"}}' | ./.claude/hooks/protect-files.sh
echo $?  # 0 = allowed, 2 = blocked
```

View circuit breaker log:
```bash
cat /tmp/claude-cb-*.log
```

## Disabling Hooks

Remove the hook block from `.claude/settings.json`, or comment out the hook in the script with `exit 0` at the top.
