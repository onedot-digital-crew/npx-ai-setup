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
