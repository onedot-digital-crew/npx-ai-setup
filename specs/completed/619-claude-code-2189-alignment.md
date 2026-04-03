# Spec: Claude Code 2.1.89+ Feature Alignment

> **Spec ID**: 619 | **Created**: 2026-04-03 | **Status**: completed | **Complexity**: medium | **Branch**: main

## Goal
Hook-System und Settings an Claude Code 2.1.89–2.1.91 anpassen — neue Events nutzen, absolute file_path handling absichern, Doppelbauten vermeiden.

## Context
Claude Code 2.1.89–2.1.91 bringt neue Hook-Events (TaskCreated, defer), absolute file_path in PreToolUse/PostToolUse, autocompact thrash-loop Fix, und Hook-Output >50K → File. Audit ergab: keine kritischen Redundanzen, aber 4 Hooks lesen file_path und brauchen absolute-path Toleranz. 6 Skills nutzen `!` Shell-Execution — `disableSkillShellExecution` Risk muss dokumentiert werden.

### Verified Assumptions
- `protect-and-breaker.sh` extrahiert file_path via jq `.tool_input.file_path` — Glob-Match `*/specs/*.md` funktioniert auch mit absoluten Pfaden | Confidence: High | If Wrong: Protected-file checks brechen
- `post-edit-lint.sh` nutzt `-f "$FILE_PATH"` — absoluter Pfad funktioniert | Confidence: High | If Wrong: Lint-after-edit bricht
- `permission-denied-log.sh` loggt nur, nutzt kein `{retry: true}` | Confidence: High | If Wrong: Schon implementiert, Step entfällt
- Kein Hook produziert >50K Output | Confidence: High | If Wrong: Hook-Output wird gekappt statt injected

## Steps
- [x] Step 1: file_path absolute-path Toleranz in 4 Hooks verifizieren (`protect-and-breaker.sh`, `post-edit-lint.sh`, `tdd-checker.sh`, `config-change-audit.sh`) — basename-Extraktion wo nötig, Glob-Matches auf `*/pattern` statt `pattern`
- [x] Step 2: `permission-denied-log.sh` um optionalen `{retry: true}` Output erweitern — wenn Source `auto_classifier` ist und der Command ein bekannter Safe-Pattern (grep, cat, ls), retry erlauben
- [x] Step 3: Smoke-Tests für absolute file_path und retry-Output ergänzen in `tests/smoke.sh`
- [x] Step 4: `disableSkillShellExecution` Risk-Warnung in `templates/CLAUDE.md` dokumentieren — 6 Skills betroffen (doctor, spec-board, review, ci, test-setup, session-optimize)
- [x] Step 5: Template `settings.json` um `TaskCreated` Event-Hook ergänzen — loggt Task-Erstellung, blockiert bei TODO/WIP im Task-Titel (analog task-completed-gate.sh pattern)

## Acceptance Criteria

### Truths
- [ ] "bash tests/smoke.sh exitiert mit 0 — alle bestehenden + neuen Assertions grün"
- [ ] "protect-and-breaker.sh mit absolutem Pfad `/Users/x/project/specs/foo.md` matcht korrekt als protected"
- [ ] "permission-denied-log.sh gibt `{retry: true}` JSON auf stdout bei auto_classifier + safe command"

### Artifacts
- [ ] `templates/claude/hooks/permission-denied-log.sh` — retry-Logic für safe patterns
- [ ] `templates/CLAUDE.md` — disableSkillShellExecution Warning Section

### Key Links
- [ ] `tests/smoke.sh` → `templates/claude/hooks/permission-denied-log.sh` via grep assertion

## Files to Modify
- `.claude/hooks/protect-and-breaker.sh` — absolute path Toleranz prüfen/fixen
- `.claude/hooks/post-edit-lint.sh` — absolute path Toleranz prüfen
- `.claude/hooks/tdd-checker.sh` — absolute path Toleranz prüfen
- `.claude/hooks/permission-denied-log.sh` — retry-Output hinzufügen
- `templates/claude/hooks/permission-denied-log.sh` — retry-Output (Template-Parity)
- `templates/claude/settings.json` — TaskCreated Hook Registration
- `templates/CLAUDE.md` — disableSkillShellExecution Warnung
- `tests/smoke.sh` — neue Assertions

## Out of Scope
- Hook-Entfernung oder Konsolidierung — Audit bestätigt: keine Redundanzen
- `defer` Permission für CI-Pipelines — eigene Spec wenn `-p` Mode aktiv genutzt wird
- autocompact thrash-loop — built-in Fix in 2.1.89, kein custom Code nötig
