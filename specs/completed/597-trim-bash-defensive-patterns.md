# Spec: bash-defensive-patterns/SKILL.md trimmen (533 → ~60 Zeilen)

> **Spec ID**: 597 | **Created**: 2026-03-28 | **Status**: completed | **Complexity**: simple | **Branch**: —

## Goal
bash-defensive-patterns/SKILL.md von 533 auf ~60 Zeilen reduzieren ohne kritische Konzepte zu verlieren.

## Context
Die Skill-Datei ist 533 Zeilen / 11.5KB und lädt komplett in Context (~2.900 Tokens). Sie enthält primär Code-Snippet-Boilerplate das nicht in ein Trigger-Dokument gehört. Kritische Muster werden als kompakte Konzeptliste behalten.

### Verified Assumptions
- SKILL.md wird bei Trigger vollständig in Context geladen — Evidence: `.claude/skills/bash-defensive-patterns/SKILL.md` | Confidence: High | If Wrong: kein Token-Impact

## Steps
- [ ] Step 1: `.claude/skills/bash-defensive-patterns/SKILL.md` lesen
- [ ] Step 2: Frontmatter (name, description) beibehalten
- [ ] Step 3: "When to Use" auf 4-5 Bullet Points kürzen
- [ ] Step 4: Code-Blöcke durch kompakte Konzeptliste ersetzen — nur Pattern-Name + 1 Zeile Kernaussage
- [ ] Step 5: Kritische Patterns als Inline-Code (kein Block) behalten: `set -Eeuo pipefail`, `command -v`, `mktemp`+`trap EXIT`, `find -print0`+`IFS= read -r -d ''`
- [ ] Step 6: Datei auf ~60 Zeilen bringen und speichern

## Acceptance Criteria

### Truths
- [ ] `wc -l .claude/skills/bash-defensive-patterns/SKILL.md` gibt ≤ 70 aus
- [ ] `wc -c .claude/skills/bash-defensive-patterns/SKILL.md` gibt ≤ 3000 aus
- [ ] Alle 8 kritischen Patterns aus findings-log sind noch auffindbar (grep)

### Artifacts
- [ ] `.claude/skills/bash-defensive-patterns/SKILL.md` — getrimmt, max 70 Zeilen

## Files to Modify
- `.claude/skills/bash-defensive-patterns/SKILL.md` — Trim von 533 → ~60 Zeilen

## Out of Scope
- Andere Skill-Dateien
- Inhaltliche Änderungen an den Bash-Patterns selbst
