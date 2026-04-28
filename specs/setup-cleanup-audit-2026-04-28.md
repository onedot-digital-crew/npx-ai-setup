# Setup Cleanup Audit — 2026-04-28

## Executive Summary

Das Repo hat 3 Cruft-Kategorien: (1) Root-Dateien die weder publiziert noch in Zielprojekte installiert werden (`BACKLOG.md`, `ONBOARDING.md`, Datei `30`), (2) Dead Code in `lib/` — `install_spec_skills()` + `SPEC_SKILLS_MAP` sind in `core.sh` definiert aber nirgends aufgerufen, (3) AI-Tool-Configs (`.codex/`, `.gemini/`, `.opencode/`, `codex/`, `gemini/`, `opencode.json`) sind legitim **da sie durch den Setup-Flow erzeugt werden** — aber 3 davon fehlen in `.gitignore`. Reduzierungs-Potential: ~560KB Logfiles in `.claude/` + ~27KB Brainstorm-Datei + ~15 removable root-files.

---

## DEAD (sicher löschen)

| File | Beweis | Anmerkung |
|------|--------|-----------|
| `/root/30` (0 bytes) | `wc -c = 0`, kein Verweis irgendwo | Leere Datei, Zufalls-Artefakt |
| `lib/setup-skills.sh:install_spec_skills()` (Funktion) | Definiert in `setup-skills.sh:5`, aber `grep -rn "install_spec_skills"` liefert **nur** die Definition — kein Aufruf in `bin/`, `lib/` | SPEC_SKILLS_MAP wird nur noch in `update.sh:367` als Append zu all_mappings genutzt; die Funktion selbst ist dead |
| `.claude/subagent-usage.log` (445 KB) | Reines Laufzeit-Log, in `.gitignore` drin (`.claude/*.log`), kein Code liest es | Kann gelöscht werden — gitignored |
| `.claude/tool-failures.log` (56 KB) | Gleiche Kategorie, gitignored | Kann gelöscht werden |
| `.claude/config-changes.log` (38 KB) | Gleiche Kategorie, gitignored | Kann gelöscht werden |
| `specs/brainstorms/113-octopus-adaptation-brainstorm.md` (26 KB) | Vom 21. März, kein aktiver Spec verlinkt darauf, das Thema ist längst in Core implementiert | Archiv oder löschen |

---

## DUPLICATE (konsolidieren)

| Situation | Gewinner | Verlierer |
|-----------|----------|-----------|
| `templates/claude/hooks/` ≈ `.claude/hooks/` | `templates/` ist Source of Truth | Nicht löschen, aber: `shellcheck-guard.sh` ist in `.claude/hooks/` aber **nicht in** `templates/claude/hooks/` — d.h. es wird nie in Zielprojekte installiert. Das ist entweder ein vergessenes Template-Add oder ein bewusst lokales Hook. Klären. |
| `templates/claude/rules/hooks-token-policy.md` existiert als Template, aber `lib/setup.sh` liefert keinen Beweis, dass es installiert wird | — | `hooks-token-policy.md` ist in `templates/claude/rules/` vorhanden aber **nicht** in der `core.sh` build_template_map-Ausnahmeliste. Es WIRD installiert (generic loop), aber es fehlt im README-Inventory. Kein richtiger Duplicate, aber dokumentationsarm. |
| `AGENTS.md` (Root) und `.agents/context/SUMMARY.md` | AGENTS.md bleibt (wird installiert), SUMMARY.md bleibt (auto-generiert) | Kein Duplicate — beide haben klar verschiedene Rollen |
| `SPEC_SKILLS_MAP` in `core.sh:67-74` dupliziert funktional was `install_skills()` (generic) tut | Generic install_skills() gewinnt | SPEC_SKILLS_MAP-Array + `install_spec_skills()`-Funktion können raus sobald der `update.sh:367`-Aufruf angepasst wird (dort als Teil von all_mappings angehängt — das ist das letzte Hängen) |

---

## QUESTIONABLE (User-Input nötig)

| File | Hypothese | Test um zu bestätigen |
|------|-----------|----------------------|
| `BACKLOG.md` | Nirgends referenziert (nicht in CLAUDE.md, nicht in README, nicht durch Setup installiert). Intern-only Dev-Notiz. | `grep -rn "BACKLOG" lib/ bin/ templates/` → 0 hits = deleteable |
| `ONBOARDING.md` | Gleiche Situation wie BACKLOG.md. Nicht in `package.json:files`, nicht installiert, nicht in CLAUDE.md verlinkt. | Prüfen ob es in README.md gelinkt ist — wenn nein: löschen oder zu `docs/` verschieben |
| `decisions.md` (Root) | Wird durch `migrations/1.4.0.sh` installiert und ist in Skills referenziert (`spec-work/SKILL.template.md`, `reflect/SKILL.template.md`). KEEP — aber klären ob die Root-Instanz (`/decisions.md`) vs Template-Instanz konsistent ist | Aktiv, legitim |
| `.ai-setup-backup/` (gitignored, vom 6. Apr) | Auto-Backup vom `--patch`-Lauf. In `.gitignore` korrekt. Kann nach erfolgreichem Update manuell gelöscht werden. | `ls .ai-setup-backup/` → alle Files stammen vom 6. Apr, nichts Neueres — sicher löschen |
| `specs/brainstorms/640b-mcp-platform-discovery.md` | Kleine Datei (2KB), vom 20. Apr. Kein aktiver Spec. Möglicherweise Vorarbeit für einen geplanten Spec. | Prüfen ob ein aktiver Spec 640b referenziert |
| `docs/claude-governance.md` | Einziger Inhalt in `docs/`. Wird nicht durch Setup installiert, nicht in CLAUDE.md verlinkt. | `grep -rn "claude-governance" . | grep -v ".git"` → 0 hits = DEAD |
| `.claude/findings-log.md` (6.4 KB) | Manuelles Log. Nicht gitignored, aber auch kein Code liest es. | Kann in `specs/` oder gelöscht werden |
| `.claude/token-optimizer-eval-2-response.md` | Eval-Output, 3 KB, vom März. Experiment-Artefakt. | Löschen |
| `scripts/build-graph.sh` (13 KB, Python-embedded) | Nur in sich selbst referenziert. Kein Aufruf aus `bin/`, `lib/`, `tests/` (`grep` zeigt nur Selbstreferenz). Scripts-Dir nicht in `package.json:files` — wird nicht publiziert. | Prüfen ob `scripts/build-graph.sh` in einem der `.claude/scripts/` aufgerufen wird |
| `tests/hook-tokens-baseline.sh` | Ruft `lib/hook-token-audit.sh` auf, aber nicht in `package.json:scripts` verankert. Kein CI-Run. | Entscheiden ob das ein aktiver Test ist oder Experiment |

---

## MISPLACED

| File | Sollte sein |
|------|-------------|
| `/30` (Root, 0 Bytes) | Nirgends — löschen |
| `.claude/token-optimizer-eval-2-response.md` | `specs/` oder gar nicht committed |
| `.claude/findings-log.md` | `specs/` oder gitignored |
| `docs/claude-governance.md` | Wenn relevant: in `.claude/rules/` oder `specs/`; sonst löschen |

---

## TEMPLATE-OUTPUT

Was wird in Zielprojekte installiert — Größenübersicht:

### Skills (größte zuerst, in Bytes)
| Skill | Größe |
|-------|-------|
| `spec/SKILL.template.md` | 7.172 |
| `spec-work/SKILL.template.md` | 5.864 |
| `challenge/SKILL.template.md` | 4.627 |
| `spec-review/SKILL.template.md` | 3.615 |
| `review/SKILL.template.md` | 3.526 |
| `release/SKILL.template.md` | 3.508 |
| `reflect/SKILL.template.md` | 3.495 |
| Alle 16 Skills gesamt | **~54 KB** |

Alle Skills sind vernünftig groß (kein Ausreißer). `spec/` ist der größte, was erwartet ist.

### Hooks (in Zielprojekte)
| Hook | Größe |
|------|-------|
| `tool-redirect.sh` | ~4 KB |
| Alle 11 Hooks gesamt | ~30 KB |

`shellcheck-guard.sh` ist in `.claude/hooks/` (lokal) aber **nicht in** `templates/claude/hooks/` — wird nicht in Zielprojekte deployed. Möglicherweise gewollt (nur für Bash-CLI-Entwicklung sinnvoll), aber undokumentiert.

### Agents (in Zielprojekte)
7 Agents × ~3-6 KB = ~24 KB. Keine Auffälligkeiten.

### Scripts (in Zielprojekte via `.claude/scripts/`)
`doctor.sh` ist mit 19 KB das größte einzelne Script. Insgesamt 33 Scripts in `.claude/scripts/` — einige davon Stack-spezifisch (`context-nuxt.sh`, `context-shopify.sh`, etc.) und werden nur bei passendem Stack sinnvoll.

---

## ROOT-CRUFT

### Datei `30` (Root)
- 0 Bytes, kein Inhalt, kein Verweis, kein `git add` Grund erkennbar
- Vermutlich versehentliches `touch 30` oder Alias-Tippfehler
- **Sicher löschen**

### `.ai-setup-backup/` 
- In `.gitignore` korrekt
- 14 Backup-Files, alle vom 6. April (einmaliger `--patch`-Lauf)
- Nicht im Repo committed — lokal clean-up genügt

### AI-Tool-Configs — Status

| File/Dir | Erzeugt durch Setup? | In `.gitignore`? | Urteil |
|----------|---------------------|------------------|--------|
| `.codex/config.toml` | Ja (`install_codex_config()` wenn codex installiert) | Nein — nur `.codex/skills` ignoriert | MISPLACED aus gitignore-Sicht — die config selbst sollte committed bleiben (Template-Inhalt) |
| `.gemini/settings.json` | Ja (`install_gemini_config()`) | Nein — nur `.gemini/agents` ignoriert | Gleich wie codex |
| `.opencode/skills` | Ja (symlink via `setup-skills.sh`) | Ja (`.opencode/skills`) | OK |
| `opencode.json` | Ja (`generate_opencode_config()`) | Nein — wird committed | Korrekt: lokale opencode.json ist das Live-Dokument |
| `codex/config.toml` | Template-Datei (wird nach `.codex/config.toml` installiert) | Nein | KEEP — ist Template-Source |
| `gemini/settings.json` | Template-Datei (wird nach `.gemini/settings.json` installiert) | Nein | KEEP — ist Template-Source |
| `.rtk/filters.toml` | User-Config für RTK-Tool | Nein | KEEP — projekteigene RTK-Filter; sinnvoll committed |
| `cmux.json` | User-Config für cmux (Terminal-Multiplexer) | Nein | QUESTIONABLE — nützlich für den Maintainer, aber kein Setup-Output |

**Befund:** Die AI-Tool-Configs gehören ins Repo, weil das Setup-Tool selbst Multi-AI-Tool ist. Kein echter Cruft — aber `cmux.json` ist Entwickler-Komfort, kein Setup-Artefakt.

---

## REDUCED-FOOTPRINT

| Aktion | Files | Größe |
|--------|-------|-------|
| Datei `30` löschen | 1 | 0 KB |
| Logfiles in `.claude/` leeren/löschen | 3 | ~550 KB (gitignored, nur lokal) |
| `BACKLOG.md` löschen (nach Bestätigung) | 1 | 2 KB |
| `ONBOARDING.md` löschen oder nach `docs/` | 1 | 5 KB |
| `docs/claude-governance.md` löschen (nach Bestätigung) | 1 | 4 KB |
| Brainstorm `113-octopus-adaptation-brainstorm.md` archivieren | 1 | 27 KB |
| `install_spec_skills()` + `SPEC_SKILLS_MAP` (dead code) entfernen | — | ~20 Zeilen Code |
| `.ai-setup-backup/` löschen (lokal) | 14 | ~50 KB |
| `.claude/token-optimizer-eval-2-response.md` + `findings-log.md` | 2 | ~10 KB |

**Gesamt:** ~10-15 Files publishable-clean, ~600 KB lokal-clean (v.a. Logs).

---

## Top 5 Empfehlungen

| # | Aktion | Effort | Impact |
|---|--------|--------|--------|
| 1 | **Datei `30` löschen** — `git rm 30` | low | Kein echter Impact, aber sauber |
| 2 | **`install_spec_skills()` + `SPEC_SKILLS_MAP` entfernen** — `core.sh:64-74` + `setup-skills.sh:5-20` + `update.sh:367` anpassen (SPEC_SKILLS_MAP-Teil aus all_mappings entfernen, da Skills via generic `TEMPLATE_MAP` bereits drin sind) | medium | Dead-Code-Elimination, ~30 Zeilen |
| 3 | **`shellcheck-guard.sh` in `templates/claude/hooks/` eintragen** wenn es für Zielprojekte sinnvoll ist — oder in `.claude/hooks/` als lokal-only dokumentieren | low | Konsistenz zwischen lokal und deployed |
| 4 | **`BACKLOG.md` + `ONBOARDING.md` prüfen und löschen** wenn kein externer Link existiert | low | Reduziert Verwirrung: was gehört zum Projekt, was zum Tool? |
| 5 | **`specs/brainstorms/113-octopus-adaptation-brainstorm.md` (27 KB) löschen** — Inhalt ist in `specs/completed/` längst implementiert | low | 27 KB weniger im Repo |
