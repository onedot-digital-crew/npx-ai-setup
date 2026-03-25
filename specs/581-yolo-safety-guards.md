# Spec 581: yolo Safety Guards

> **Status**: in-review
> **Branch**: spec/581-yolo-safety-guards
> **Quelle**: [580-research-claude-code-auto-mode](./580-research-claude-code-auto-mode.md) (K1+K5)
> **Complexity**: Simple

## Problem

Der yolo-Skill läuft unbegrenzt — kein Budget-Limit, kein Turn-Limit. Eine fehlerhafte Loop oder ein Runaway-Scenario kann beliebig viele Tokens verbrennen.

## Solution

Zwei Safety Guards in den yolo-Skill einbauen:

1. **`--max-budget-usd`**: Default Budget-Cap (z.B. $5) als Empfehlung im Skill dokumentieren
2. **`--max-turns`**: Default Turn-Limit (z.B. 25) als Empfehlung im Skill dokumentieren
3. **Stall-Detection verschärfen**: Bei 3 aufeinanderfolgenden Failures stoppen (inspiriert vom Auto-Mode-Classifier-Fallback)

## Steps

- [x] Step 1: `templates/skills/yolo/SKILL.md` lesen und aktuelle Guard-Rails dokumentieren
- [x] Step 2: Budget-Guard und Turn-Limit als Safety-Empfehlungen im Skill ergänzen
- [x] Step 3: Stall-Detection-Regel prüfen/erweitern (3 consecutive failures → stop)
- [x] Step 4: `.claude/skills/yolo/SKILL.md` synchron halten

## Acceptance Criteria

- [x] yolo-Skill erwähnt `--max-budget-usd` als empfohlenen Guard
- [x] yolo-Skill erwähnt `--max-turns` als optionalen Guard
- [x] Stall-Detection bei 3+ aufeinanderfolgenden Failures dokumentiert
- [x] Keine Breaking Changes — bestehende yolo-Aufrufe funktionieren weiter

## Risks

- Guards dürfen nicht zu restriktiv sein — yolo ist bewusst autonom
- Budget-Wert muss als Empfehlung, nicht als Hard-Default implementiert werden
