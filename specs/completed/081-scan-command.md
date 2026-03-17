# Spec: Add /scan Command for Security Vulnerability Scanning

> **Spec ID**: 081 | **Created**: 2026-03-17 | **Status**: completed | **Branch**: —

## Goal
Add a `/scan` command that detects available security tools and scans project dependencies for vulnerabilities, reporting findings by severity.

## Context
No security scanning exists in the current setup. Inspired by Opencode dotfiles evaluation — fills a real gap with minimal complexity. Uses CLI tools directly (no MCP).

## Steps
- [x] Step 1: Create `templates/commands/scan.md` — command that detects snyk/npm audit/pip audit/bundler-audit and runs the appropriate scanner
- [x] Step 2: Copy to `.claude/commands/scan.md` (mirrors all other commands in the repo)
- [x] Step 3: Register scan in `bin/ai-setup.sh` — n/a: install_commands() auto-discovers all files in templates/commands/

## Acceptance Criteria
- [x] `/scan` detects and runs at least one scanner when called in a JS/Node project (`npm audit`)
- [x] Output groups findings by severity: CRITICAL / HIGH / MEDIUM / LOW
- [x] If no known scanner is detected, reports clearly instead of silently failing
- [x] Command file exists in both `templates/commands/` and `.claude/commands/`

## Files to Modify
- `templates/commands/scan.md` — new file
- `.claude/commands/scan.md` — new file (copy)
- `bin/ai-setup.sh` — add scan.md to command install list (if applicable)

## Out of Scope
- MCP-based scanning (Snyk MCP server)
- Auto-fixing vulnerabilities
- CI/CD integration
