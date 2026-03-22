# Spec 139: Build-Fix Command

> **Status**: completed
> **Quelle**: specs/136-evaluate-everything-claude-code.md (Kandidat #3)
> **Ziel**: Aktiver Build-Fixer Command der Fehler inkrementell behebt statt nur zu reporten

## Context

Unser build-validator Agent meldet nur pass/fail. ECC hat einen aktiven Build-Error-Resolver der einen inkrementellen Fix-Loop faehrt: Fehler lesen, minimal fixen, rebuild, naechster Fehler. Ziel: Build green mit minimalen Diffs.

## Steps

- [x] 1. Erstelle `templates/commands/build-fix.md` als neuen Slash-Command
- [x] 2. Implementiere inkrementellen Fix-Loop: Build ausfuehren → ersten Fehler parsen → minimal fixen → rebuild → wiederholen
- [x] 3. Fuege Guard Rails hinzu: max 10 Iterationen, max 5% Datei-Aenderung pro Fix, keine Architektur-Aenderungen
- [x] 4. Fuege "When NOT to Use" Section hinzu mit Verweis auf andere Agents (refactor, architect, tdd)
- [x] 5. Kopiere nach `.claude/commands/build-fix.md`
- [x] 6. Registriere in README.md Command-Table
- [x] 7. Verifiziere: Command ist via `/build-fix` aufrufbar

## Acceptance Criteria

- Command fuehrt inkrementellen Fix-Loop aus
- Guard Rails verhindern uebermaessige Aenderungen
- Success-Metrik: Build exitcode 0 mit minimalen Diffs
- "When NOT to Use" Section vorhanden

## Files to Modify

- `templates/commands/build-fix.md` (neu)
- `.claude/commands/build-fix.md` (neu)
- `README.md` (Command-Table Update)
