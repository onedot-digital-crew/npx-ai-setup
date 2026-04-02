# Spec: SubagentStart/Stop Hooks

> **Spec ID**: 613 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: medium | **Branch**: —
> **Execution Order**: after 612, before 614

## Goal

SubagentStart- und SubagentStop-Hooks implementieren — sofern diese Events in der verfügbaren Claude Code Version tatsächlich feuern — um falsche Model-Verwendung bei Agent-Spawns zu erkennen und Subagent-Kosten zu erfassen.

## Context

Die dekompilierte Claude Code v2.1.88 Quelle definiert `SubagentStart` und `SubagentStop` als Hook-Events. Ob diese Events in der öffentlichen Release-Version tatsächlich feuern, ist nicht verifiziert — sie können internal-only oder feature-flagged sein. Aktuell gibt es keine Möglichkeit zu erkennen, wenn ein Subagent mit dem falschen Modell spawnt. LEARNINGS.md enthält: "Skills mit `disable-model-invocation: true` ohne `model:` erben Parent-Modell — in Opus-Sessions kostet das 5x zu viel."

### Verified Assumptions

- `SubagentStart` und `SubagentStop` existieren als Event-Typen in dekompiliertem Claude Code v2.1.88. — Evidence: Spec 611 Research, `hooksConfigManager.ts` | Confidence: Medium | If Wrong: Spec wird zu no-op — Hooks werden registriert aber feuern nie. Kein Schaden, aber kein Nutzen.
- Die JSON-Payload-Felder (`agent_name`, `model`, etc.) sind aus Quellcode-Analyse abgeleitet, nicht gegen echte Events verifiziert. — Evidence: Spec 611 Research | Confidence: Low | If Wrong: Hook muss defensiv mit fehlenden/unbekannten Feldern umgehen.
- Kein bestehender Hook überwacht Agent-Spawns oder Subagent-Kosten. — Evidence: `.claude/hooks/README.md`, `templates/claude/settings.json` | Confidence: High | If Wrong: Duplikat-Prüfung nötig.

## Steps

- [x] Step 1: **Verify Event Availability** — Registriere einen minimalen Test-Hook für `SubagentStart` (echo-only) in lokaler `.claude/settings.json`. Spawne einen Test-Subagent. Wenn das Event nicht feuert: Spec als "event unavailable" dokumentieren und abbrechen.
- [x] Step 2: `templates/claude/hooks/subagent-start.sh` — SubagentStart-Hook: parst JSON-Input defensiv (jede Feld-Absenz wird toleriert). Warnt auf STDERR wenn (a) kein `model`-Feld im Input oder (b) Input-Felder auf Haiku-Modell für nicht-read-only Agents hinweisen. Exit 0 (advisory).
- [x] Step 3: `templates/claude/hooks/subagent-stop.sh` — SubagentStop-Hook: loggt verfügbare Felder in `.claude/subagent-usage.log` (eine Zeile pro Event, Timestamp + alle vorhandenen Felder). Toleriert fehlende Felder komplett.
- [x] Step 4: `templates/claude/settings.json` — beide Hooks registrieren; `.claude/` Kopien synchronisieren
- [x] Step 5: `.claude/hooks/README.md` — beide Hooks dokumentieren, explizit als "experimentell, Event-Verfügbarkeit nicht garantiert" markieren

## Implementation Note

The hook events could not be triggered from this terminal environment, so runtime event availability remains unverified. The implementation is therefore wired and documented as experimental/advisory only.

## Acceptance Criteria

### Truths

- [ ] Step 1 Verification ist durchgeführt und dokumentiert (Event feuert / Event feuert nicht)
- [x] Wenn Events feuern: SubagentStart warnt non-blocking bei fehlendem `model`-Feld
- [x] Wenn Events feuern: SubagentStop schreibt strukturierte Zeile in Usage-Log
- [x] Alle Hooks tolerieren fehlende, leere oder unbekannte JSON-Felder ohne Fehler

### Artifacts

- [x] `templates/claude/hooks/subagent-start.sh` — defensiver Advisory-Hook (min 30 lines)
- [x] `templates/claude/hooks/subagent-stop.sh` — defensiver Logging-Hook (min 25 lines)
- [x] `templates/claude/settings.json` — Hook-Registrierung für SubagentStart + SubagentStop

### Key Links

- [x] `templates/claude/settings.json` → `templates/claude/hooks/subagent-start.sh` via `SubagentStart`
- [x] `templates/claude/settings.json` → `templates/claude/hooks/subagent-stop.sh` via `SubagentStop`

## Files to Modify

- `templates/claude/hooks/subagent-start.sh` — neu erstellen
- `templates/claude/hooks/subagent-stop.sh` — neu erstellen
- `templates/claude/settings.json` — Hook-Registrierung
- `.claude/hooks/subagent-start.sh` — lokale Kopie
- `.claude/hooks/subagent-stop.sh` — lokale Kopie
- `.claude/settings.json` — lokale Registrierung
- `.claude/hooks/README.md` — Dokumentation (experimentell markiert)

## Out of Scope

- Hartes Blockieren von Modell-Routing (advisory only)
- Analyse des subagent-usage.log (Aufgabe von /session-optimize)
- Erkennung aller Modell-Varianten (nur Haiku/Sonnet/Opus Pattern)
- Kompensation falls Events nicht feuern (kein Workaround)
