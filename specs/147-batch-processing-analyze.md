# Spec 147: Batch-Processing fuer /analyze

> **Status**: in-progress
> **Source**: specs/145-evaluate-understand-anything.md (Kandidat #2)
> **Goal**: /analyze auf batched Agent-Dispatch umbauen fuer bessere Qualitaet bei grossen Codebases

## Context

Aktuell dispatched `/analyze` 3 parallele generische Agents. Understand-Anything nutzt einen granulareren Ansatz: 5-10 Files pro Batch, max 3 concurrent Agents. Das verbessert Qualitaet (Agents sehen weniger aber tiefere Kontexte) und Token-Effizienz (kleinere Prompts pro Agent).

## Steps

- [x] 1. Read `.claude/commands/analyze.md` and `templates/commands/analyze.md` to understand current 3-agent architecture
- [x] 2. Add file-scanning pre-step: `git ls-files` filtered by source extensions (ts, tsx, js, jsx, py, go, rs, rb, php, java, kt, swift, vue, svelte, sh, sql). Exclude: lockfiles, .md, .json, .yaml, images, fonts
- [x] 3. Branch: if <=30 source files → use current 3-agent fast path unchanged. If >30 → enter batch mode
- [x] 4. Batch mode: split file list into groups of 8. Dispatch up to 3 Explore agents (model: haiku) per wave. Each agent analyzes its batch and returns structured findings
- [x] 5. After all batches complete: dispatch one Synthesizer agent (model: sonnet) that receives all batch outputs and produces the unified analysis. This agent resolves contradictions and ranks findings
- [x] 6. Mirror changes to template version
- [ ] 7. Test with npx-ai-setup itself (medium-sized codebase)

## Acceptance Criteria

- Projects with >30 source files use batched analysis
- Small projects (<=30 source files) use existing fast path unchanged
- Batch size: 8 files (hardcoded in prompt, not configurable — KISS)
- Max concurrent agents per wave: 3
- Synthesizer agent produces same output format as current /analyze
- Source extension list documented in the command file

## Files to Modify

- `.claude/commands/analyze.md`
- `templates/commands/analyze.md`
