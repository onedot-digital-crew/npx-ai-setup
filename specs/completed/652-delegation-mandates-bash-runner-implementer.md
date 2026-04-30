# Spec: Delegation Mandates — bash-runner + implementer Subagents

> **Spec ID**: 652 | **Created**: 2026-04-30 | **Status**: completed | **Complexity**: medium | **Branch**: feat/652-delegation-mandates

## Goal

Opus Main Agent delegiert Daily-Tasks (Bash-Chains, Code-Edits) automatisch an günstigere Modelle, behält sich Architektur/Strategie. Token-Reduktion ~60-70% auf Routine-Workload bei gleichbleibender Qualität.

## Context

Multi-Projekt-Audit (5 Sessions × 4 Projekte: npx-ai-setup, sb-nuxt-boilerplate, nuxt-onedot, mcp-platform, qa-engine) zeigt:

- **459 Bash-Calls vs 226 Edit/Write** über alle Projekte → Bash dominiert
- **Bash-Ketten 11-14 in Folge** in jedem aktiven Projekt → Opus läuft auf Shell-Mechanik
- **0-3.4% Delegation-Rate** trotz vorhandener 6 Reviewer-Subagents → Main Agent triggert nicht
- Edit-Cluster 4-6 in Folge in 4/4 Projekten → Implementer-Lücke universell

Bestehende Subagents (code-reviewer, performance-reviewer, security-reviewer, staff-reviewer, test-generator, context-scanner) decken Review/Test/Scan ab — fehlen: **Daily-Driver für Execution**.

`/spec-work` Skill hat bereits Model-Routing (Sonnet default, Opus bei `Complexity: high`). Spec-Execution braucht keinen separaten Subagent.

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**: none — bash-runner und implementer sind generisch. Audit zeigt Edit-Patterns gleich auf .ts/.vue/.js/.sh/.md.

## Steps

- [x] Step 1: `.claude/agents/bash-runner.md` — neuer Subagent (haiku, Bash+Read tools, MUST-trigger description)
- [x] Step 2: `.claude/agents/implementer.md` — neuer Subagent (sonnet, Read+Edit+Write+Glob+Grep+Bash, MUST-trigger description)
- [x] Step 3: `templates/agents/bash-runner.md` + `templates/agents/implementer.md` — mirror für Target-Projekte via `npx ai-setup`
- [x] Step 4: `CLAUDE.md` — kompakter Mandates-Block (1 Zeile + Link auf agents.md, token-effizient)
- [x] ~~Step 5~~: **SKIPPED** — `templates/CLAUDE.md` ist schlanke Version, verlinkt nur. Mandates Single-Source in agents.md
- [x] Step 6: `.claude/rules/agents.md` — Mandate-Tabelle (8 Subagents, Trigger, Model)
- [x] Step 7: `templates/claude/rules/agents.md` — synced 1:1
- [x] Step 8: `.claude/agents/staff-reviewer.md` — model: opus
- [x] Step 9: `templates/agents/staff-reviewer.md` — model: opus
- [x] ~~Step 10~~: **DEFERRED** — Reviewer-description Refactor separater Spec
- [x] Step 11: Smoke-Test passed: 8 Agents, 0 drift auf 3 berührte Files, Frontmatter valid
- [ ] Step 12: `/spec-review` nach 1 Woche Real-Usage (Validation-Phase)

## Acceptance Criteria

- [ ] `ls .claude/agents/*.md` zeigt 8 Agents (6 alte + bash-runner + implementer), keine README/Test-Files
- [ ] Jeder Agent hat valid frontmatter: `name`, `description`, `tools`, `model`, `max_turns`
- [ ] `staff-reviewer.md` frontmatter `model: opus`
- [ ] CLAUDE.md enthält `## Delegation Mandates`-Block mit min. 3 MUST-Rules (Bash-Chains, Code-Edits, Architektur-Skepsis)
- [ ] Templates-Mirror: `diff .claude/agents/bash-runner.md templates/agents/bash-runner.md` → 0 lines
- [ ] Templates-Mirror: `diff .claude/agents/implementer.md templates/agents/implementer.md` → 0 lines
- [ ] `bash -n` clean auf alle geänderten Bash-Scripts (keine, aber pre-flight)
- [ ] Manueller Test: nächste Session mit ≥3 Bash-Chain triggert `bash-runner`-Spawn (delegation-rate >0%)

## Files to Modify

- `.claude/agents/bash-runner.md` — neu (done)
- `.claude/agents/implementer.md` — neu (done)
- `templates/agents/bash-runner.md` — mirror (done)
- `templates/agents/implementer.md` — mirror (done)
- `.claude/agents/staff-reviewer.md` — model upgrade
- `templates/agents/staff-reviewer.md` — model upgrade
- `CLAUDE.md` — Delegation Mandates Block hinzufügen
- `templates/claude/CLAUDE.md` — sync
- `.claude/rules/agents.md` — Subagent-Tabelle erweitern
- `templates/claude/rules/agents.md` — sync

## Out of Scope

- `explore`-Subagent (haiku) — Audit zeigt unklares Bild, defer auf späteren Spec wenn Nuxt/Vue-Sessions häufiger werden
- `spec-executor` — `/spec-work` Skill löst es bereits via `Complexity:`-Routing
- Stack-spezifische Subagents (vue-implementer, liquid-editor) — Daten zeigen generic Sonnet-Implementer reicht
- PreToolUse-Hooks die Bash-Spam blocken — zu aggressiv, Mandate-Rules + Subagent-Existenz sollten reichen
- Reviewer-description Refactoring (alle 4 Reviewer auf "MUST use" umschreiben) — separater Spec, sonst zu groß
- RTK-Integration ändern — läuft schon global + projekt-lokal, kein Touch nötig

## Risks

- **R1**: Main Opus ignoriert MUST-Mandate trotz CLAUDE.md → Mitigation: Mandate-Block prominent platzieren, klare Trigger-Kriterien, nach 3 Tagen Delegation-Rate erneut messen
- **R2**: Bash-Runner zu aggressiv triggert → Subagent-Overhead frisst Savings → Mitigation: max_turns=10, Trigger ab ≥3 Chain (nicht ≥2)
- **R3**: Implementer macht Scope-Creep trotz "no scope creep"-Rule → Mitigation: max_turns=25, klare Brief-Pflicht in description

## Validation

Nach 1 Woche Real-Usage erneut Multi-Project-Audit fahren (gleiche Methodik wie Pre-Spec). Erwartung:
- Delegation-Rate von 0-3% auf ≥30%
- Consecutive Bash-Runs ≥10 verschwinden komplett (gehen an bash-runner)
- Edit-Runs ≥4 reduzieren sich um ≥50% (gehen an implementer)
