# Spec 582: CLAUDE.md Autonomie-Dokumentation

> **Status**: completed
> **Branch**: spec/582-claude-md-autonomy-docs
> **Quelle**: [580-research-claude-code-auto-mode](./580-research-claude-code-auto-mode.md) (K2+K3+K7+K9+K10)
> **Complexity**: Simple

## Problem

Das CLAUDE.md Template dokumentiert `-p` und `--output-format json` für Automation, aber verschweigt kritische Flags und Konzepte:
- `--bare` (wird zukünftig Default für `-p`, deaktiviert Hooks/Skills/MCP)
- Permission Modes (`Shift+Tab`-Cycling, auto, dontAsk, acceptEdits)
- `--fallback-model`, `--no-session-persistence`, `--max-budget-usd`

## Solution

Zwei Sections im CLAUDE.md Template erweitern:

1. **Automation Section**: `--bare` als CI-Empfehlung ergänzen, Budget/Turn-Controls, `--fallback-model`, `--no-session-persistence`
2. **Neue Section "Permission Modes"**: Kurze Referenz der Modi mit `Shift+Tab`-Hinweis

Constraint: Max 5-8 Zeilen pro Section (CLAUDE.md Edit Rule).

## Steps

- [x] Step 1: `templates/CLAUDE.md` lesen, aktuelle Automation Section analysieren
- [x] Step 2: Automation Section um `--bare`, Budget/Turn-Controls, Fallback erweitern
- [x] Step 3: Permission Modes Mini-Referenz hinzufügen (5 Zeilen max)
- [x] Step 4: Verify Token-Impact (Section darf nicht > 200 Tokens sein)

## Acceptance Criteria

- [x] `--bare` als CI-Empfehlung in Automation Section
- [x] `--max-budget-usd` und `--max-turns` erwähnt
- [x] Permission Modes Section mit Shift+Tab-Hinweis und Modus-Liste
- [x] Jede Section ≤ 8 Zeilen
- [x] Template-Token-Overhead < 200 Tokens total

## Risks

- Token-Budget: Neue Sections dürfen CLAUDE.md nicht aufblähen
- Volatilität: `--bare` und Auto Mode sind in Flux — Doku muss versionsneutral bleiben
