# Plan: pause/resume Skills + Session-State-Infrastruktur entfernen

## Context

claude-mem liefert seit Sessions persistenten Cross-Session-Kontext via Observations/Decisions. Das macht den ursprünglichen Zweck von `/pause` + `/resume` obsolet. Analyse bestätigt: das Feature wird faktisch nicht benutzt.

**Nutzungs-Audit (6 Monate Git-History, 50 Commits):**
- Manuelle `/pause`-Commits: **2** (eb55867, cff25bc)
- "save session state"-Checkpoint-Commits: 13 — aber **keiner** enthält die session-state.json selbst (alle rein Working-Directory-Commits mit Convention-Message)
- Aktueller Zustand on disk: `session-state.json` ist 6 Tage alt, `has_active_spec: false`, `active_specs: []` — der Auto-Hook produziert **leere State-Files**
- `.continue-here.md` ist 1 Tag alt und inhaltlich bereits komplett veraltet (referenziert Specs 626-629, die längst completed sind)
- post-compact-restore.sh exited seit Tagen bei `has_active_spec: false` **silent** (Script Zeile 27) → **null funktionaler Output**

**Fazit:** Die Infrastruktur produziert seit Tagen nichts Sinnvolles. Das ganze Subsystem (Skills + Commands + 2 Hooks + Hook-Suggestions + Smoke-Tests + Docs) kann weg.

**Was bleibt erhalten:** spec-work und spec-run refreshen session-state.json zwar an Phase-Checkpoints — aber weil nichts mehr liest, ist das toter Code. Entfernen.

**Was ich NICHT anfasse:** claude-mem selbst, `/reflect`, Spec-Workflow (nur die session-state-Schreibaufrufe innerhalb spec-work/spec-run), post-compact SessionStart-Fallback (den Hook-Slot könnten wir später umnutzen).

## Ziel

Komplette Entfernung von pause/resume + session-state.json-Infrastruktur. claude-mem übernimmt Cross-Session-Context. Spec-Navigation läuft über `/spec-board` + `git status`.

## Änderungen

### Phase 1: Skills + Commands entfernen

**Löschen:**
- `.claude/skills/pause/` — komplettes Verzeichnis
- `.claude/skills/resume/` — komplettes Verzeichnis
- `.claude/commands/pause.md`
- `.claude/commands/resume.md`
- `templates/skills/pause/` — komplettes Verzeichnis
- `templates/skills/resume/` — komplettes Verzeichnis

### Phase 2: Hooks entfernen

**Löschen:**
- `.claude/hooks/pre-compact-state.sh`
- `.claude/hooks/post-compact-restore.sh`
- `templates/claude/hooks/pre-compact-state.sh`
- `templates/claude/hooks/post-compact-restore.sh`

**Modifizieren:**
- `.claude/settings.json` + `templates/claude/settings.json` — Hook-Registrierungen für PreCompact + PostCompact + SessionStart(compact) entfernen. Verifizieren dass die Slots nicht noch von anderen Scripts belegt sind.
- `.claude/hooks/circuit-breaker.sh` + Template — Zeile 11: `.continue-here.md` aus Whitelist-Glob entfernen (harmlos da Datei gelöscht, aber Code aufräumen)
- `.claude/hooks/context-monitor.sh` + Template — Zeilen 71, 73: Warnungen zu session-state/continue-here entfernen, durch neutrale "Kontext knapp" Meldung ersetzen
- `.claude/hooks/session-length.sh` + Template — Zeilen 36, 40: `/pause`-Empfehlungen entfernen, durch "/clear" oder neutrale Wrap-up-Hint ersetzen

### Phase 3: Skill-Internals säubern

**Modifizieren:**
- `.claude/skills/spec-work/SKILL.md` + Template — Zeilen 17, 32: session-state.json-Refresh-Anweisungen entfernen
- `.claude/skills/spec-run/SKILL.md` + Template — Zeilen 18, 24, 31, 35, 42: alle 5 session-state.json-Refresh-Anweisungen entfernen
- `.claude/skills/reflect/SKILL.md` + Template — Zeile 168: `/pause`-Next-Step-Hint entfernen (ersatzlos)
- `.claude/skills/session-optimize/SKILL.md` — session-state-Referenzen prüfen und entfernen

### Phase 4: Lib + Setup

**Modifizieren:**
- `lib/setup.sh` Zeilen 719, 736, 754 — drei `echo ".claude/session-state.json" >> .gitignore` Aufrufe entfernen
- `lib/plugins.sh` Zeile 204 — pause/resume Help-Menü-Text entfernen
- `lib/migrations/1.4.0.sh` Zeilen 25-26 — `_add_file` Calls für pause/resume commands entfernen (Migration läuft nur einmalig, alte Projekte behalten ihre bereits installierten Files — hier nur Code-Hygiene)

### Phase 5: Workflow-Rules

**Modifizieren:**
- `.claude/rules/workflow.md` + `templates/claude/rules/workflow.md`:
  - Zeile 16: Trigger-Row "Session start + .continue-here.md exists" entfernen
  - Zeile 17: "dann `/pause`" aus Reflect-Hint entfernen
  - Zeile 26: `/resume` aus MAY-auto-invoke-Liste entfernen
  - Zeile 30: `/pause` aus user-only-Liste entfernen

### Phase 6: Documentation

**Modifizieren:**
- `WORKFLOW-GUIDE.md` + `templates/WORKFLOW-GUIDE.md`:
  - Zeilen 132-133: pause/resume aus Commands-Tabelle
  - Zeilen 176-177: session-state.json + continue-here.md Doku-Block
  - Zeile 221: "/pause + neue Session + /resume" → "neue Session via /clear"
- `README.md` Zeilen 95-96: pause/resume aus Command-Tabelle
- `CHANGELOG.md` — Eintrag "v2.2.0 (unreleased): Removed pause/resume skills + session-state infrastructure (superseded by claude-mem)" hinzufügen. Spec 140 + 616 Referenzen unverändert lassen (historisch korrekt).

### Phase 7: Tests + Cleanup

**Modifizieren:**
- `tests/smoke.sh` Zeilen 503-517 — drei Test-Blöcke für compact-hooks/pause-resume/spec-work-session-state komplett entfernen
- `.gitignore` Zeile 23: `.claude/session-state.json` Entry entfernen (Datei existiert nicht mehr)

**Aus Working Directory löschen:**
- `.continue-here.md` (veraltet, 2.1K)
- `.claude/session-state.json` (veraltet, 245B)

## Kritische Dateien zum Modifizieren

| File | Grund |
|------|-------|
| `.claude/settings.json` | Hook-Registrierungen müssen raus, sonst Fehler beim Hook-Dispatch |
| `tests/smoke.sh` | Drei Tests würden nach Deletion fail — müssen weg |
| `.claude/skills/spec-work/SKILL.md` | Tote session-state-Writes entfernen |
| `.claude/skills/spec-run/SKILL.md` | Tote session-state-Writes entfernen |
| `lib/setup.sh` | Gitignore-Population darf nicht mehr auf Nicht-Existent referenzieren |

## Rollback

Ein sauberer Rollback ist trivial: `git revert <commit>`. Kein externer State, keine DB-Migration, kein File-Format-Change. Die gelöschten Files sind alle in Git-History erhalten.

## Verifikation

```bash
# 1. Smoke-Test läuft grün
bash tests/smoke.sh

# 2. Keine dangling references
rtk grep -r "session-state\|continue-here\|/pause\|/resume" .claude/ templates/ lib/ WORKFLOW-GUIDE.md README.md CHANGELOG.md

# 3. Hooks starten ohne Fehler
bash .claude/hooks/circuit-breaker.sh < /dev/null
bash .claude/hooks/context-monitor.sh < /dev/null
bash .claude/hooks/session-length.sh < /dev/null

# 4. Doctor-Skill läuft grün
bash .claude/scripts/doctor.sh

# 5. Spec-Workflow funktional (ohne in echte Spec zu gehen)
ls .claude/skills/spec-work/SKILL.md  # existiert
grep -c "session-state" .claude/skills/spec-work/SKILL.md  # 0

# 6. claude-mem-Integration intakt
ls ~/.claude/projects/*/claude-mem/ 2>/dev/null | head -5
```

## Was NICHT gemacht wird

- **Specs 140, 616, 607 im specs/completed/** bleiben unverändert (historischer Record)
- **claude-mem** wird NICHT modifiziert
- **`/reflect`, `/clear`, `/spec-board`** bleiben wie sie sind
- **Compact-Hook-Slots** werden nicht neu belegt (nur deregistriert)

## Out-of-Scope für spätere Iteration

Falls claude-mem ausfällt oder der Compaction-Kontext-Restore wieder gebraucht wird: Einen neuen, schlanken Hook bauen der nur **aktive Spec aus git branch + specs/-Status** ableitet, ohne separates State-File. Das ist ein 10-Zeilen-Script — kein Skill nötig.
