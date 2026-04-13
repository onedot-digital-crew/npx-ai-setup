# Spec: Output-Token Compression Skill (Terse Mode)

> **Spec ID**: 632 | **Created**: 2026-04-13 | **Status**: completed | **Complexity**: low | **Branch**: —
> **Related**: 633 (CLAUDE.md Auto-Compression), 631 (Research Caveman)

## Goal

Always-on terse output mode mit Auto-Clarity, der Claude-Antworten um ~65-75% komprimiert ohne technische Substanz zu verlieren.

## Context

Research 631 zeigt: wir optimieren nur Input-Tokens (Context-Loading, tiered abstracts). Output-Tokens — typisch 60-70% der Session-Kosten — bleiben unberührt. Caveman demonstriert, dass ein SKILL.md + SessionStart-Injection zuverlässig ~75% Output-Reduktion erreicht. Auto-Clarity (automatisches Umschalten auf verbose bei Security-Warnungen, irreversiblen Aktionen, User-Verwirrung) löst das Safety-Problem.

## Steps

- [ ] Step 1: `templates/claude/rules/terse-output.md` erstellen — Rule-Datei mit Compression-Regeln, Auto-Clarity-Exceptions, Persistence-Anweisung
- [ ] Step 2: Rule in `templates/claude/CLAUDE.md` referenzieren (1 Zeile)
- [ ] Step 3: `lib/generate.sh` — terse-output.md in die Rule-Generation aufnehmen
- [ ] Step 4: Integration-Test — verify Rule wird korrekt deployed
- [ ] Step 5: Manueller Smoke-Test — Claude antwortet terse, wechselt bei Security-Warning zu verbose

## Acceptance Criteria

- [ ] "Nach `npx ai-setup` existiert `.claude/rules/terse-output.md` im Ziel-Projekt"
- [ ] "Rule enthält: Drop-Liste (articles, filler, pleasantries), Fragment-OK, Technical-Terms-Exact"
- [ ] "Rule enthält: Auto-Clarity Section (Security, irreversible, confused user)"
- [ ] "Rule enthält: Persistence-Anweisung (active every response, off only via 'normal mode')"
- [ ] "`bash tests/integration.sh` passed"

## Files to Modify

- `templates/claude/rules/terse-output.md` — NEU: Terse output compression rule
- `templates/claude/CLAUDE.md` — Referenz auf terse-output Rule
- `lib/generate.sh` — Rule in Generation aufnehmen
- `tests/integration.sh` — Test für terse-output.md Deployment

## Out of Scope

- Intensity Levels (lite/full/ultra) — zu komplex für V1, optional in V2
- Wenyan Mode — nicht relevant für unsere User
- Statusline Badge — eigenes Feature (siehe Inter-Hook State Pattern)
- Output-Token Messung/Evals — siehe Backlog-Item Eval Harness
