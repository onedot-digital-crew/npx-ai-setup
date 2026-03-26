# Spec: Generate PATTERNS.md + AUDIT.md during setup via analyze-prep.sh

> **Spec ID**: 592 | **Created**: 2026-03-26 | **Status**: rejected | **Complexity**: medium | **Branch**: —

## Goal
Generate PATTERNS.md and AUDIT.md during setup installation using a Shell prep-script (Map) + Haiku (Reduce), so every project starts with codebase analysis from day one.

## Context
Setup generates 3 context files (STACK, ARCHITECTURE, CONVENTIONS) via Haiku from pre-collected context. PATTERNS.md and AUDIT.md only exist via on-demand `/analyze` — most projects never get them. New approach: `analyze-prep.sh` collects hotspots, TODOs, and identifies core files via multi-language import analysis (zero dependencies, pure shell). Haiku reads the actual core files and synthesizes structured PATTERNS.md + AUDIT.md. Security analysis stays in `/scan` — no duplication. `/analyze` remains for deep on-demand refresh.

### Verified Assumptions
- `run_generation()` spawns parallel `claude -p` for CLAUDE.md, AGENTS.md, context — Evidence: `lib/generate.sh:265-287` | Confidence: High
- Context generation uses Haiku `--max-turns 8` — Evidence: `lib/generate.sh:285` | Confidence: High
- `count_generated_context_files()` counts only 3 files — Evidence: `lib/generate.sh:7-13` | Confidence: High
- Existing prep-scripts pattern: shell collects, AI formats — Evidence: `.claude/scripts/*-prep.sh` | Confidence: High
- `$CTX_DIRS`, `$CTX_FILES`, `$CTX_SAMPLE` already collected before prompts — Evidence: `lib/generate.sh:60-141` | Confidence: High

## Steps
- [ ] Step 1: Create `templates/scripts/analyze-prep.sh` — Pure shell script that collects: (a) Hotspots via `git log --name-only --format="" | sort | uniq -c | sort -rn | head -20` + largest files via `wc -l`, (b) TODOs/FIXMEs via `grep -rnE "TODO|FIXME|HACK|XXX"` filtered to source dirs, (c) Core files via multi-language import counting: JS/TS (`from '...'`/`require('...')`), Python (`import`/`from X import`), Go (`import "`), PHP (`use`), with `case` on detected language from package.json/requirements.txt/go.mod. Output: structured sections with `--- Hotspots ---`, `--- TODOs ---`, `--- Core Files (top 10) ---`, `--- Core File Contents (top 5, first 80 lines each) ---`.
- [ ] Step 2: `lib/generate.sh` — Run `analyze-prep.sh` early in `run_generation()` (before prompts, after context collection). Capture output in `$CTX_ANALYZE`. Add `ANALYZE_PROMPT` that creates PATTERNS.md + AUDIT.md from `$CTX_ANALYZE` + `$CTX_DIRS` + `$CTX_FILES`. Spawn as `PID_ANALYZE` parallel to existing processes. Model: Haiku, `--max-turns 8`.
- [ ] Step 3: `lib/generate.sh` — Update `count_generated_context_files()` to count 5 files. Update verify logic (expect 5/5). Add `PID_ANALYZE` to `WAIT_ARGS`, `ERR_ANALYZE` temp file with cleanup. Add `REGEN_ANALYZE` flag gated same as `REGEN_CONTEXT`. Retry logic matching existing pattern.
- [ ] Step 4: `WORKFLOW-GUIDE.md` + `templates/WORKFLOW-GUIDE.md` — Update Context-Dateien section to list all 5 files. Move `/analyze` from Onboarding to "Weitere Commands" as refresh.
- [ ] Step 5: `README.md` — Update "What it installs" Context row to mention 5 files.
- [ ] Step 6: Sync `analyze-prep.sh` to `.claude/scripts/`, run `npm test`.

## Acceptance Criteria

### Truths
- [ ] "`analyze-prep.sh` runs in <5s on a 500-file repo"
- [ ] "Fresh install generates 5 files in .agents/context/"
- [ ] "`count_generated_context_files` returns 5 when all present"
- [ ] "PATTERNS.md contains Module Boundaries and Key Abstractions based on actual core file contents"
- [ ] "AUDIT.md contains Hotspots (git churn + file size) and TODOs sections — no security analysis"

### Artifacts
- [ ] `templates/scripts/analyze-prep.sh` — multi-language prep script (new file)
- [ ] `.agents/context/PATTERNS.md` — module boundaries, key abstractions, established patterns
- [ ] `.agents/context/AUDIT.md` — hotspots, TODOs, recommendations

### Key Links
- [ ] `lib/generate.sh` calls `analyze-prep.sh` → captures `$CTX_ANALYZE`
- [ ] `lib/generate.sh` → ANALYZE_PROMPT → `.agents/context/PATTERNS.md` + `AUDIT.md`

## Files to Modify
- `templates/scripts/analyze-prep.sh` — new file, multi-language prep script
- `.claude/scripts/analyze-prep.sh` — synced copy
- `lib/generate.sh` — call prep script, add ANALYZE_PROMPT, PID_ANALYZE, verify logic, counter update
- `WORKFLOW-GUIDE.md` — update Context section, move /analyze
- `templates/WORKFLOW-GUIDE.md` — same
- `README.md` — update Context row

## Out of Scope
- Security analysis (belongs to `/scan`)
- Dead code detection (too error-prone with grep, belongs to dedicated tools)
- External dependencies (knip, semgrep, dependency-cruiser)
- Changing `/analyze` skill (remains for deep on-demand refresh)
