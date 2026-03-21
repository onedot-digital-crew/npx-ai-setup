# Spec 138: Code Reviewer Confidence + AI-Code Upgrade

> **Status**: in-review
> **Quelle**: specs/136-evaluate-everything-claude-code.md (Kandidat #2)
> **Ziel**: Confidence-basiertes Filtering und AI-Generated-Code-Checks im Code Reviewer

## Context

ECC's Code Reviewer filtert Findings auf >80% Confidence und hat spezielle Checks fuer AI-generierten Code (Stubs, Placeholders, TODOs). Unser code-reviewer hat keine Confidence-Schwelle und kein AI-Code-Handling.

## Steps

- [x] 1. Lese `templates/agents/code-reviewer.md` und identifiziere Einfuegepunkte
- [x] 2. Fuege Confidence-Filtering hinzu: "Only report issues with >80% confidence they are real problems"
- [x] 3. Fuege AI-Generated-Code-Checks hinzu: Stub detection, placeholder implementations, TODO-marked incomplete code, unnecessary complexity patterns
- [x] 4. Fuege "Common False Positives" Section hinzu (analog zu Security Reviewer)
- [x] 5. Kopiere Aenderungen nach `.claude/agents/code-reviewer.md`
- [x] 6. Verifiziere: Keine bestehende Funktionalitaet gebrochen

## Acceptance Criteria

- Confidence-Schwelle (>80%) dokumentiert im Agent
- AI-Code-Checks: mindestens 4 spezifische Patterns (stubs, placeholders, TODOs, unnecessary complexity)
- False Positives Section vorhanden
- Bestehende Review-Funktionalitaet unveraendert

## Files to Modify

- `templates/agents/code-reviewer.md`
- `.claude/agents/code-reviewer.md`
