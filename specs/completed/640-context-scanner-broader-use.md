# Spec: context-scanner — auch von analyze + explore + research nutzen

> **Spec ID**: 640 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: small | **Branch**: —

## Goal

`context-scanner` agent (haiku, read-only) wird heute nur von `/spec` gespawnt. Fünf weitere Skills profitieren von einem Stack-/Convention-Scan vor ihrer Hauptarbeit: `/analyze`, `/explore`, `/research`, `/spec-review`, `/feature-dev`.

## Context

`templates/agents/context-scanner.md` existiert (Spec 646 completed). Sein Job: Stack-Profile detecten, `.agents/context/`-Files lesen, kompakter Stack-Report. Spawn dauert ~3 sec, kostet wenig (haiku).

Heute spawnt nur `templates/skills/spec/SKILL.template.md` Zeile 69. analyze macht eigene Stack-Detection inline (false positives, siehe Spec 635); explore und research starten ohne Stack-Awareness. Resultat: Doppelarbeit + inkonsistente Stack-Erkennung pro Skill.

## Stack Coverage

- **Profiles affected**: alle (context-scanner ist generic)
- **Per-stack difference**: keine — Scanner liest selbst die Profile-Files

## Steps

- [x] Step 1: `templates/skills/analyze/SKILL.template.md` — Step 0a einfügen "Spawn context-scanner (haiku) für Stack/Convention-Profil bevor Mode-Selection". Output dem batch-agent als Stack-Hint mitgeben (gates Spec 635 Step 3)
- [x] Step 2: `templates/skills/explore/SKILL.template.md` — Step 0 "Stack-Scan via context-scanner" einfügen, Output-Block in den Explorer-Prompt injizieren
- [x] Step 3: `templates/skills/research/SKILL.template.md` — Step 0 "Stack-Scan" um Context7-Lookup auf relevante Libs zu fokussieren (Stack determines welche libs Sinn ergeben)
- [x] Step 4: `templates/skills/spec-review/SKILL.template.md` — falls Skill den Stack braucht, gleicher Block
- [x] Step 5: `.claude/skills/{analyze,explore,research,spec-review}/SKILL.md` mirror
- [x] Step 6: `templates/agents/context-scanner.md` — Output-Format prüfen, sicherstellen dass alle 5 Konsumenten dasselbe Format erwarten (≤200 Tokens, structured: stack/conventions/key-paths)

## Acceptance Criteria

- [x] Jeder der 5 Skills (`spec`, `analyze`, `explore`, `research`, `spec-review`) ruft `context-scanner` als ersten Schritt
- [x] Spawn ist konditional: skip wenn `.agents/context/STACK.md` existiert UND <24h alt (sonst redundant)
- [x] context-scanner Output ≤200 Tokens, alle Konsumenten lesen dasselbe Format
- [x] Spot-check auf nuxt-Projekt: `/analyze` und `/explore` produzieren beide Stack-konsistente Outputs (kein "Vue 2" vs "Vue 3" Mismatch)

## Files to Modify

- `templates/skills/analyze/SKILL.template.md`
- `templates/skills/explore/SKILL.template.md`
- `templates/skills/research/SKILL.template.md`
- `templates/skills/spec-review/SKILL.template.md`
- `templates/agents/context-scanner.md` — ggf. Output-Format härten
- `.claude/skills/{analyze,explore,research,spec-review}/SKILL.md` mirror
- `.claude/agents/context-scanner.md` mirror

## Out of Scope

- `/feature-dev` (existiert nicht als Skill — nur als bundled subagents under `Agent`)
- context-scanner Agent neu schreiben (nur konsumieren)
- Auto-Invoke ohne User-Trigger (Skills bleiben user-invocable)
- Cache-Mechanismus für context-scanner Output (separates Spec falls nötig)
