---
model: sonnet
allowed-tools: Read, Bash, Glob
---

Scans project dependencies for security vulnerabilities. Detects available tools and reports findings grouped by severity.

## Process

1. **Detect project type and scanner**:
   - Node.js: check for `package.json` → use `npm audit --json`
   - Python: check for `requirements.txt` or `Pipfile` → use `pip-audit` (if installed) or `safety check`
   - Ruby: check for `Gemfile.lock` → use `bundle-audit check --update` (if installed)
   - Snyk: if `snyk` is installed globally → prefer `snyk test --json` for any project type

2. **Run the scanner**:
   - Execute the detected command
   - Capture output (JSON where possible for reliable parsing)
   - If the command fails due to missing tool, report which tool is needed and how to install it

3. **Parse and group findings by severity**:
   ```
   CRITICAL: N
   HIGH: N
   MEDIUM: N
   LOW: N
   ```
   For each finding include: package name, installed version, fixed version (if available), CVE/advisory ID.

4. **Report results**:
   - If no vulnerabilities: "No vulnerabilities found."
   - If vulnerabilities found: show grouped output, then print remediation hint:
     - Node.js: `npm audit fix` (non-breaking) or `npm audit fix --force` (breaking)
     - Python: `pip install --upgrade <package>`
     - Ruby: `bundle update <gem>`
     - Snyk: `snyk fix`

5. **If no scanner is detected**: report clearly — "No supported scanner found. Install one of: snyk, npm (Node.js), pip-audit (Python), bundler-audit (Ruby)." Do not fail silently.

## Rules
- Do NOT auto-fix — only report and suggest fix commands.
- Do NOT install any tools — only use what is already available.
- If `npm audit` returns exit code 1 (vulnerabilities found), treat as FAIL — do not suppress.
- Run in the project root.
