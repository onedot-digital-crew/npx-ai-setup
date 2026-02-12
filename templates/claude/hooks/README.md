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
- ⚠️  Warning at 5 edits to same file within 10 minutes
- ⛔ Hard block at 8 edits to same file within 10 minutes

**What happens when triggered:**
- Provides diagnostic context about why the loop occurred
- Suggests alternative approaches
- Shows how to clear the circuit breaker if needed

**Customization:**
- Edit `WARN`, `BLOCK`, and `WINDOW` variables in the script
- For large refactoring sessions, consider raising `BLOCK` to 12-15

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

Clear circuit breaker for a fresh start:
```bash
rm /tmp/claude-cb-*.log
```

Check how many times a file was edited recently:
```bash
grep "path/to/file" /tmp/claude-cb-*.log | wc -l
```

## Disabling Hooks

Remove the hook block from `.claude/settings.json`, or comment out the hook in the script with `exit 0` at the top.
