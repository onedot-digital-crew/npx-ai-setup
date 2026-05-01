# Spec: single-source sync — templates als Truth, `.claude/` generiert

> **Spec ID**: 654 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: medium | **Branch**: —

## Goal

Stoppe Template-vs-local Drift, indem `templates/` die einzige Source of Truth wird und ein lokales Sync-Script `.claude/` deterministisch daraus generiert.

## Context

Aktuell werden Änderungen doppelt gepflegt: `templates/agents/*` plus `.claude/agents/*`, `templates/skills/*/SKILL.template.md` plus `.claude/skills/*/SKILL.md`, `templates/scripts/*` plus `.claude/scripts/*`, Hooks/Rules/Docs analog. Das erzeugt Drift während jeder größeren Spec-Arbeit und macht Reviews schwerer. Bevor `/index`, Hook-Merge oder Skill-Konsolidierung starten, muss die lokale Installationskopie reproduzierbar aus Templates erzeugt werden.

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**: none, applies to the ai-setup development repo and all target installs indirectly

## Steps

- [x] Step 1: `bin/sync-local.sh` — neues dev-only Script erstellen: kopiert template-managed Dateien in die lokale `.claude/`, `.github/`, root docs und `specs/` analog zu `build_template_map`, ohne interaktive Prompts
- [x] Step 2: `bin/sync-local.sh` — Skills korrekt mappen: `templates/skills/<name>/SKILL.template.md` → `.claude/skills/<name>/SKILL.md`, `references/*` rekursiv kopieren
- [x] Step 3: `bin/sync-local.sh` — Agents, hooks, rules, docs und scripts syncen; `templates/codex/config.toml` → `codex/config.toml`; `templates/AGENTS.md` → `AGENTS.md` nur mit explizitem Flag `--root-docs`
- [x] Step 4: `bin/sync-local.sh` — Orphan-Check einbauen: Dateien in `.claude/{agents,hooks,rules,scripts}` melden, wenn es keine Template-Quelle mehr gibt; default nur melden, `--prune` löscht
- [x] Step 5: `scripts/template-drift-check.sh` oder neuer Check — vorhandene Drift-Prüfung auf `bin/sync-local.sh --check` umstellen, sodass CI/quality-gate denselben Single-Source-Mechanismus nutzt
- [x] Step 6: `README.md` + `WORKFLOW-GUIDE.md` — Dev-Regel dokumentieren: Template ändern, dann `bash bin/sync-local.sh`, nie lokale `.claude/` als Source of Truth editieren
- [x] Step 7: `templates/claude/rules/workflow.md` — Hinweis ergänzen: bei ai-setup Repo selbst nach Template-Änderungen Sync-Check laufen lassen
- [x] Step 8: aktuelle Drift bereinigen, indem `bash bin/sync-local.sh --check` grün wird, ohne absichtlich lokale-only Skills aus Marketplace/Plugins zu löschen

## Acceptance Criteria

- [x] `bash bin/sync-local.sh --check` exit 0 nach Sync
- [x] `bash bin/sync-local.sh --dry-run` zeigt geplante Änderungen ohne Dateischreibzugriff
- [x] `bash bin/sync-local.sh --prune --dry-run` listet Orphans, löscht aber nichts
- [x] Template-managed Skill-Mirror sind byte-identisch: `diff -u templates/skills/analyze/SKILL.template.md .claude/skills/analyze/SKILL.md` gibt keine Ausgabe
- [x] Marketplace/plugin/local-only Skills wie `.claude/skills/agent-browser`, `gh-cli`, `orchestrate`, `bash-defensive-patterns` werden nicht gelöscht
- [x] `bash .claude/scripts/quality-gate.sh` grün

## Files to Modify

- `bin/sync-local.sh` - neuer Single-Source-Sync
- `scripts/template-drift-check.sh` - Drift-Check auf Sync-Script ausrichten, falls vorhanden
- `README.md` - Dev-Workflow dokumentieren
- `WORKFLOW-GUIDE.md` - Dev-Workflow dokumentieren
- `templates/claude/rules/workflow.md` - Sync-Hinweis
- `.claude/rules/workflow.md` - Mirror via Sync

## Out of Scope

- Zielprojekt-Update-Flow ändern
- Marketplace/plugin Skills verwalten
- Bestehende Skills/Agents löschen
- `.ai-setup.json` Metadatenformat ändern
