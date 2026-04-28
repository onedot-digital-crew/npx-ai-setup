# Spec: Skill-Audit und Konsolidierung der Template-Skills

> **Spec ID**: 622 | **Created**: 2026-04-04 | **Status**: completed | **Complexity**: medium | **Branch**: —

## Goal
Audit aller Template-Skills auf realen Nutzen, überflüssige entfernen, sinnvolle Konsolidierungen umsetzen.

## Context
~35 Skills werden via `templates/skills/` in jedes Projekt installiert. Nicht alle bringen in jedem Projekt Wert — die Skill-Liste ist Noise für User die nur 15 davon nutzen. Ziel: ausmisten und zusammenlegen wo es Sinn macht.

Keine Tier-basierte Installation, kein neuer Install-Flow — nur Cleanup.
Challenge-Ergebnis: Tier-System + `.ai-setup.json` Persistierung wurde als Over-Engineering verworfen (Token-Savings ~800/Session zu gering für die Komplexität).

### Verified Assumptions
- Skills werden 1:1 aus `templates/skills/` nach `.claude/skills/` kopiert — Evidence: `lib/setup.sh:install_skills()` | Confidence: High
- Kein Projekt nutzt alle Skills aktiv — Evidence: Session-Erfahrung | Confidence: High

### Bereits erledigt
- `ci` Skill gelöscht (CLI-Shortcut `! gh pr checks` reicht)
- `orchestrate` Skill gelöscht (braucht externe Tools die kaum jemand hat)
- `discover` Skill gelöscht (Einmal-Onboarding-Tool)
- `token-optimizer` Skill gelöscht (nur für ai-setup-Entwicklung, nicht Zielprojekte)
- `pr` Skill gelöscht (CLI-Shortcut `gh pr create` reicht)
- CLI-Shortcuts Block im Template CLAUDE.md eingefügt
- Alle Referenzen in WORKFLOW-GUIDE.md, commit, spec-review, workflow.md bereinigt
- **35 → 30 Skills** (davon test-setup internal-only, also 29 für Zielprojekte)

## Steps
- [x] Step 1: Jeden Template-Skill einzeln prüfen — braucht ein typisches Zielprojekt diesen Skill? Remove-Kandidaten markieren.
- [x] Step 2: Konsolidierungskandidaten identifizieren — keine sinnvollen Kandidaten gefunden. Verbleibende Skills sind distinkt.
- [x] Step 3: Remove-Kandidaten entfernen aus `templates/skills/` (ci, orchestrate, discover, token-optimizer, pr)
- [x] Step 4: Konsolidierungen — nicht nötig (Step 2 Ergebnis)
- [x] Step 5: Referenzen bereinigen (WORKFLOW-GUIDE.md, commit, spec-review, workflow.md). Smoke-Tests hatten keine Referenzen.

## Acceptance Criteria

### Truths
- [ ] "Entfernte Skills sind weder in `templates/skills/` noch in Smoke-Tests referenziert"
- [ ] "Konsolidierte Skills behalten alle Trigger-Patterns der Ursprungs-Skills"
- [ ] "Smoke-Tests laufen grün nach Änderungen"

### Artifacts
- [ ] `templates/skills/` — bereinigte Skill-Sammlung (weniger als heute)

### Key Links
- [ ] `lib/setup.sh` → `templates/skills/` via `install_skills()` Funktion

## Files to Modify
- `templates/skills/` — Skills entfernen/konsolidieren
- Smoke-Test-Dateien — Referenzen auf entfernte Skills bereinigen

## Out of Scope
- Stack-basierte Skill-Filterung (z.B. nur Vue-Skills für Vue-Projekte) — eigene Spec
- Skill-Inhalt optimieren (SKILL.md kürzen/verbessern) — eigene Spec
- `.claude/skills/` interne Skills dieses Repos (agent-browser, session-optimize etc.)
