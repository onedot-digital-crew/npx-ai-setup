# Spec: Skill-Audit und Konsolidierung der Template-Skills

> **Spec ID**: 622 | **Created**: 2026-04-04 | **Status**: draft | **Complexity**: medium | **Branch**: —

## Goal
Audit aller 35 Template-Skills auf realen Nutzen in Zielprojekten, Token-Overhead eliminieren durch Entfernung und Konsolidierung.

## Context
35 Skills werden via `templates/skills/` in jedes Projekt installiert. Jeder Skill kostet ~20-30 Tokens Listing-Overhead pro Session (Name+Description in System Prompt), gesamt ~700-1000 Tokens. Die vollen SKILL.md (~30k Tokens total) laden erst bei Invocation. Die Frage ist nicht primär Token-Cost, sondern: welche Skills bringen in Shopify/Nuxt/Vue-Zielprojekten echten Wert vs. verschmutzen die Skill-Liste mit Noise. Aktuell gibt es keine Differenzierung - jedes Projekt bekommt alle 35.

### Verified Assumptions
- Skills werden 1:1 aus `templates/skills/` nach `.claude/skills/` kopiert — Evidence: `lib/setup.sh:install_skills()` | Confidence: High | If Wrong: Installation-Mechanik muss anders geprüft werden
- Skill-Listing im System Prompt ist proportional zur Anzahl installierter Skills — Evidence: System-Reminder in Session zeigt alle 35 | Confidence: High | If Wrong: Token-Overhead wäre fix unabhängig von Anzahl
- Kein Projekt nutzt alle 35 Skills aktiv — Evidence: Session-Erfahrung, viele Skills sind situationsbedingt | Confidence: High | If Wrong: Kein Handlungsbedarf

## Steps
- [ ] Step 1: Jeden der 35 Template-Skills kategorisieren in Tiers: **Core** (jedes Projekt braucht), **Workflow** (Spec-Pipeline, nützlich bei regelmäßiger Nutzung), **Situational** (nur bei bestimmten Anlässen), **Remove** (kein Nutzen oder redundant)
- [ ] Step 2: Konsolidierungskandidaten identifizieren — Skills die zusammengelegt werden können (z.B. spec-run/spec-run-all, spec-work/spec-work-all, pause/resume)
- [ ] Step 3: Remove-Kandidaten entfernen aus `templates/skills/` (und ggf. `.claude/skills/`)
- [ ] Step 4: Konsolidierungen umsetzen — zusammengelegte Skills in einzelne SKILL.md mergen
- [ ] Step 5: `install_skills()` in `lib/setup.sh` prüfen ob Tier-basierte Installation sinnvoll ist (z.B. nur Core+Workflow default, Situational opt-in)
- [ ] Step 6: Smoke-Tests anpassen falls entfernte Skills dort referenziert werden

## Acceptance Criteria

### Truths
- [ ] "Entfernte Skills sind weder in `templates/skills/` noch in Smoke-Tests referenziert"
- [ ] "Konsolidierte Skills behalten alle Trigger-Patterns der Ursprungs-Skills"
- [ ] "Smoke-Tests laufen grün nach Änderungen"

### Artifacts
- [ ] `templates/skills/` — bereinigte Skill-Sammlung (Ziel: <=28 Skills)
- [ ] `specs/622-skill-audit-and-consolidation.md` — Tier-Tabelle als Dokumentation der Entscheidungen

### Key Links
- [ ] `lib/setup.sh` → `templates/skills/` via `install_skills()` Funktion

## Files to Modify
- `templates/skills/` — Skills entfernen/konsolidieren
- `lib/setup.sh` — ggf. Tier-basierte Installation
- Smoke-Test-Dateien — Referenzen auf entfernte Skills bereinigen

## Out of Scope
- Stack-basierte Skill-Filterung (z.B. nur Vue-Skills für Vue-Projekte) — eigene Spec
- Skill-Inhalt optimieren (SKILL.md kürzen/verbessern) — eigene Spec
- `.claude/skills/` interne Skills dieses Repos (agent-browser, session-optimize etc.)
