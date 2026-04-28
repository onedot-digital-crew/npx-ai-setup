# Setup Full File-by-File Audit — 2026-04-28

> Vorheriger Report: `specs/setup-cleanup-audit-2026-04-28.md` — Findings dort nicht wiederholt.
> Dieser Report geht tiefer: jede Datei bewertet, Beweise statt Behauptungen.

---

## Summary

| Kategorie | Anzahl |
|-----------|--------|
| Dateien total (ohne `.git`, ohne Logfiles) | ~370 |
| ACTIVE | ~290 |
| KEEP-BUT-STALE | ~18 |
| DEAD / ORPHAN | ~12 |
| DUPLICATE | ~6 |
| MISPLACED | ~4 |
| TOO-LARGE | 0 |
| BROKEN | 0 (Symlinks valide) |

---

## Top 10 Konkrete Aktionen (priorisiert)

| # | Aktion | Impact | Effort |
|---|--------|--------|--------|
| 1 | **Templates → Local-Hook Drift schließen**: 6 Hooks und 2 Rules in `.claude/` sind neuer als in `templates/claude/` — Template-Updates nicht zurück-gemergt | Hoch — deployed Zielprojekte kriegen veraltete Hooks | Medium |
| 2 | **`scripts/build-graph.sh` ≠ `templates/scripts/build-graph.sh`**: Template hat verbessertes Cycle-Detection-Algo, `scripts/` hat alte Version | Medium — Zielprojekte kriegen neuen Algo, aber Dev-Dir hat Bug | Low |
| 3 | **`install_spec_skills()` + `SPEC_SKILLS_MAP` (Dead Code)**: Funktion in `setup-skills.sh` nie aufgerufen, Array in `core.sh` noch als `all_mappings`-Anhang in `update.sh:367` — bereinigen | Medium — konfuse Redundanz | Medium |
| 4 | **`workflow.md` lokal hat YAML Frontmatter mit `paths:`, Template hat das nicht**: Lokale `.claude/rules/workflow.md` startet mit `paths: - "**/*.ts"` etc., Template nicht — kritisch weil Template deployed wird | Hoch — path-scoped Kontext-Ladeverhalten fehlt in Zielprojekten | Low |
| 5 | **Doppelte Spec-ID 633**: `specs/633-claudemd-auto-compression.md` und `specs/633-lean-ctx-plugin.md` — beide Status: draft | Low — Verwirrung bei `/spec-board` | Low |
| 6 | **`specs/` Aufräumen**: 6 completed/cancelled Specs im aktiven `specs/`-Root, 4 changelog-audit-*.md Dateien + 1 bisheriger audit — in `completed/` oder löschen | Low | Low |
| 7 | **`settings.local.json` hat `Skill(spec-validate)`**: Skill wird via `cleanup_known_orphans()` entfernt — Permission bleibt als toter Eintrag | Low — harmlos aber unclean | Low |
| 8 | **`.claude/skills/skill-creator-workspace/`**: 50 Eval-Dateien (Iteration 1+2 für token-optimizer-Skill) nie deployed, in `.claudeignore` escaped, aber committed — ~500KB Eval-Artefakte | Low | Low |
| 9 | **`agents.md` lokal vs Template**: Local stark reduziert (kein Graphify-Abschnitt, kein Liquid-Graph), Template hat mehr Kontext — manueller Update nötig | Medium | Low |
| 10 | **`spec-validate-prep.sh` in `templates/scripts/`**: Wird noch von `spec/SKILL.template.md:127` referenziert, Skill-Datei `/spec-validate` ist aber entfernt — entweder Script entfernen oder Skill-Referenz anpassen | Medium | Low |

---

## `bin/` — Entry Scripts

| Datei | Zeilen | Status | Begründung | Action |
|-------|--------|--------|------------|--------|
| `ai-setup.sh` | 308 | ACTIVE | Entry Point für `npx ai-setup`. Lädt via `_loader.sh` alle lib-Module. Ruft Stack-Detection, Template-Installation, Skills, Hooks, MCP-Suggestions. | KEEP |
| `global-setup.sh` | 186 | ACTIVE | Entry für `ai-setup-global`. Lädt nur `tui.sh`, `cli-tools.sh`, `global-settings.sh`. Installiert globale Claude-Workstation-Einstellungen. | KEEP |

**Befund**: Beide Entry Scripts korrekt. `bin/` in `package.json:files` — wird publiziert.

---

## `lib/` — Bash-Module

| Datei | Zeilen | Status | Begründung | Action |
|-------|--------|--------|------------|--------|
| `_loader.sh` | 14 | ACTIVE | `source_lib()` Helper — von `bin/ai-setup.sh:65` und `bin/global-setup.sh:34` geladen | KEEP |
| `json.sh` | 90 | ACTIVE | `source_lib "json.sh"` in `ai-setup.sh:66` | KEEP |
| `core.sh` | 291 | ACTIVE | `source_lib "core.sh"` in `ai-setup.sh:67`. Enthält `build_template_map()`, `SPEC_SKILLS_MAP`, `TS_RULES_MAP`, `_semver_gt()` | KEEP, aber `SPEC_SKILLS_MAP` Dead Code (siehe unten) |
| `process.sh` | 118 | ACTIVE | `source_lib "process.sh"` in `ai-setup.sh:68`. Kill-Tree + Progress-Bar-Utilities | KEEP |
| `detect.sh` | 41 | ACTIVE | `source_lib "detect.sh"` in `ai-setup.sh:69`. Template-Kategorie-Filter | KEEP |
| `tui.sh` | 1029 | ACTIVE | `source_lib "tui.sh"` — größtes Modul. TUI-Output-Funktionen + interaktive Prompts | KEEP |
| `skills.sh` | 80 | ACTIVE | `source_lib "skills.sh"` in `ai-setup.sh:71`. `install_skills()` Generic-Loop | KEEP |
| `generate.sh` | 409 | ACTIVE | `source_lib "generate.sh"` in `ai-setup.sh:72`. LLM-basierter Context-Generierungs-Flow | KEEP — hat veraltete Modellnamen (siehe Modell-Check) |
| `migrate.sh` | 255 | ACTIVE | `source_lib "migrate.sh"` in `ai-setup.sh:73`. `run_migrations()` ruft 3 Migration-Skripte auf | KEEP |
| `update.sh` | 691 | ACTIVE | `source_lib "update.sh"` in `ai-setup.sh:74`. `--patch`-Flow, `cleanup_known_orphans()` | KEEP |
| `setup.sh` | 773 | ACTIVE | `source_lib "setup.sh"` in `ai-setup.sh:75`. Fresh-Install-Steps, `_smart_merge_file()`, `_install_or_update_file()` | KEEP |
| `setup-skills.sh` | 429 | ACTIVE (teilweise) | `source_lib "setup-skills.sh"` in `ai-setup.sh:76`. **`install_spec_skills()` auf Zeile 5 ist Dead Code** — 0 Aufrufer außerhalb der Funktion selbst (bestätigt: `grep -rn "install_spec_skills"` liefert nur Definition + `core.sh`-Kommentar) | KEEP Module, aber `install_spec_skills()` löschen |
| `setup-compat.sh` | 164 | ACTIVE | `source_lib "setup-compat.sh"` in `ai-setup.sh:77`. Agentfiles-Format, opencode-JSON-Generierung | KEEP |
| `skill-filter.sh` | 70 | ACTIVE | `source_lib "skill-filter.sh"` in `ai-setup.sh:78`. Skill-Profil-Filterung | KEEP |
| `plugins.sh` | 399 | ACTIVE | `source_lib "plugins.sh"` in `ai-setup.sh:79`. Claude-mem, MCP-Suggestions, Codex/Gemini | KEEP |
| `boilerplate.sh` | 397 | ACTIVE | `source_lib "boilerplate.sh"` in `ai-setup.sh:80`. Boilerplate-Repo-Clone-Flow | KEEP |
| `cli-tools.sh` | 283 | ACTIVE | `source_lib "cli-tools.sh"` in `global-setup.sh:36`. Nicht in `ai-setup.sh` direkt, aber via `global-setup.sh` | KEEP |
| `global-settings.sh` | 273 | ACTIVE | `source_lib "global-settings.sh"` in `global-setup.sh:37`. | KEEP |
| `detect-stack.sh` | 184 | ACTIVE | Nicht source'd — wird via `bash "$SCRIPT_DIR/lib/detect-stack.sh"` als Subprocess aufgerufen (aus `bin/ai-setup.sh:155`, `setup-skills.sh:12`, `boilerplate.sh:141`) | KEEP |
| `build-liquid-graph.sh` | 277 | ACTIVE | Subprocess-Aufruf aus `bin/ai-setup.sh:299` (nur für `shopify-liquid` Stack) + aus `.claude/scripts/liquid-graph-refresh.sh` | KEEP |
| `context-size-check.sh` | 88 | ACTIVE | Subprocess aus `.claude/scripts/doctor.sh:487` | KEEP |
| `generate-summary.sh` | 105 | ACTIVE | Subprocess aus `bin/ai-setup.sh:244` | KEEP |
| `hook-token-audit.sh` | 229 | ACTIVE | Subprocess aus `tests/hook-tokens-baseline.sh:9` und `.claude/scripts/doctor.sh:508` | KEEP |
| `mcp-suggest.sh` | 92 | ACTIVE | Subprocess aus `lib/plugins.sh:184` | KEEP |
| `data/context-caps.json` | — | ACTIVE | Eingelesen von `context-size-check.sh:12` | KEEP |
| `data/mcp-defaults.json` | — | ACTIVE | Eingelesen von `mcp-suggest.sh:11` | KEEP |

### Dead Code in `lib/core.sh`: `SPEC_SKILLS_MAP` + `install_spec_skills()`

```
core.sh:64-74 — SPEC_SKILLS_MAP Array (6 Einträge, explizit als "Legacy" kommentiert)
setup-skills.sh:5-? — install_spec_skills() Funktion
update.sh:367 — SPEC_SKILLS_MAP in all_mappings angehängt
```

Alle drei zusammen löschen. `install_skills()` in `skills.sh` macht dasselbe generisch.

### Migration-Scripts

| Datei | Zeilen | Status | Begründung |
|-------|--------|--------|------------|
| `migrations/1.4.0.sh` | 65 | ACTIVE | Via `run_migrations()` in `migrate.sh` aufgerufen wenn Zielversion >= 1.4.0 |
| `migrations/2.1.0.sh` | 31 | ACTIVE | Gleich |
| `migrations/2.3.0.sh` | 38 | ACTIVE | Gleich |

---

## `scripts/` — Dev-Tooling Scripts

Diese werden **nicht publiziert** (`package.json:files` enthält `scripts/` nicht). Pure Dev-Tooling.

| Datei | Zeilen | Status | Begründung | Action |
|-------|--------|--------|------------|--------|
| `build-graph.sh` | 331 | KEEP-BUT-STALE | Referenziert in `CHANGELOG.md` und `specs/completed/629`. **Enthält ältere Cycle-Detection-Version als `templates/scripts/build-graph.sh`** (diff zeigt: Template hat improved `explicit_edge_map` + `has_path()`, scripts/ hat noch den rekursiven `has_cycle()` Ansatz) | UPDATE: Template-Version nach `scripts/` übernehmen |
| `lint-agents.sh` | ~80 | ACTIVE | Referenziert in `specs/completed/159-agent-yaml-frontmatter-standard.md`. Validiert Agent-Frontmatter. Kein `package.json:scripts`-Eintrag, aber als Dev-Tool per Doku nutzbar. | KEEP — docs-only |
| `skill-lint.sh` | ~70 | ACTIVE | Referenziert in `specs/627-adr-skill.md` als Step: `bash scripts/skill-lint.sh`. Validiert Skill-Templates. | KEEP |
| `validate-no-hardcoded-paths.sh` | ~80 | ACTIVE | Spec 126. Kein CI-Hook, aber als Pre-Release-Check dokumentiert. | KEEP — manual run |
| `validate-release.sh` | ~50 | ACTIVE | Spec 127. Via `verify:release` in `package.json` indirekt referenziert? — Nein, `verify:release` ruft `npm run test && tests/routing-check.sh` auf, nicht `scripts/validate-release.sh`. **0 direkte Refs in package.json**. | ORPHAN — docs erwähnen es, aber kein automatischer Trigger |

---

## `templates/` — Root-Dateien

| Datei | Größe | Status | Begründung | Action |
|-------|-------|--------|------------|--------|
| `templates/CLAUDE.md` | ~120 Zeilen | ACTIVE | via `build_template_map()` in `core.sh` als `CLAUDE.md` installiert | KEEP |
| `templates/AGENTS.md` | ~50 Zeilen | ACTIVE | Installiert als `AGENTS.md` | KEEP |
| `templates/WORKFLOW-GUIDE.md` | ~150 Zeilen | ACTIVE | Installiert als `WORKFLOW-GUIDE.md`. Referenziert `/orchestrate` und `/claude-changelog` — beide Skills existieren | KEEP |
| `templates/decisions.md` | ~20 Zeilen | ACTIVE | Installiert als `decisions.md`. Referenziert in `spec-work/SKILL.template.md` und `reflect/SKILL.template.md` | KEEP |
| `templates/.claudeignore` | 104 Zeilen | ACTIVE | Installiert als `.claudeignore`. Enthält skill-creator-workspace/, .opencode/, .codex/ etc. | KEEP |
| `templates/mcp.json` | ~10 Zeilen | ACTIVE | Spezial-Handling via `TEMPLATE_EXCLUDES` in `core.sh` (merge-Logik) | KEEP |

---

## `templates/claude/` — Hooks, Rules, Scripts, Docs, Settings

### `templates/claude/hooks/`

| Datei | Status | Begründung | Action |
|-------|--------|------------|--------|
| `circuit-breaker.sh` | ACTIVE | Identisch mit `.claude/hooks/circuit-breaker.sh` (diff: 0) | KEEP |
| `context-freshness.sh` | KEEP-BUT-STALE | **Lokal neuer**: Template prüft `package.json` ohne Directory-Guard; local hat zusätzlich `src/`, `app/`, `pages/` Guard um False-Positives bei Bash-CLI-Repos zu vermeiden. Template muss angepasst werden | UPDATE TEMPLATE |
| `graph-before-read.sh` | ACTIVE | Identisch | KEEP |
| `graph-context.sh` | ACTIVE | Identisch | KEEP |
| `post-edit-lint.sh` | ACTIVE | Identisch | KEEP |
| `precompact-guidance.sh` | KEEP-BUT-STALE | **Lokal neuer** (+16 Zeilen): Local hat Block-Logik wenn Spec in-progress ist (verhindert Compact bei aktivem Spec). Template fehlt das komplett. | UPDATE TEMPLATE |
| `protect-files.sh` | KEEP-BUT-STALE | **Lokal neuer** (14 hinzugefügt, 21 entfernt): Lokal fokussiert auf Vite `assets/`-Guard, Template hat noch breiten PROTECTED-Array (`.env`, lock-files) der mit `permissions.deny` doppelt. | UPDATE TEMPLATE |
| `README.md` | KEEP-BUT-STALE | Unterschied vorhanden (lokal wohl aktualisiert) | UPDATE TEMPLATE |
| `spec-stop-guard.sh` | KEEP-BUT-STALE | **Lokal neuer** (+30 Zeilen): Local hat besseres Status-Pattern-Matching (case-insensitive regex, numerische Dateinamen-Filter), Template hat älteres `grep -q '^\> .*Status.*in-progress'` | UPDATE TEMPLATE |
| `task-completed-gate.sh` | ACTIVE | Identisch | KEEP |
| `tool-redirect.sh` | KEEP-BUT-STALE | **Lokal neuer**: Template hat `RTK_SKIP=1` Emergency-Bypass, andere grep-Beschreibung ("bfs/ugrep" vs "ripgrep"), und das Git-rtk-Check ist in Template robuster (prüft `command -v rtk` vor Weiterleitung). Template ist in diesem Fall **besser** als lokal. | UPDATE LOCAL von Template |
| `update-check.sh` | ACTIVE | Identisch | KEEP |
| `shellcheck-guard.sh` | ORPHAN (lokal only) | Nur in `.claude/hooks/`, nicht in `templates/claude/hooks/`. Settings.json **lokal** hat den Hook (`Edit|Write *.sh`). Settings-Template hat ihn nicht. Bewusste Entscheidung: Bash-CLI-Tooling braucht shellcheck, generische Zielprojekte evtl. nicht. | DOKUMENTIEREN oder als OPT-IN in Template aufnehmen |

**Zusammenfassung Hooks**: 5 von 11 Template-Hooks sind hinter dem lokalen Stand. Lokale Verbesserungen wurden nicht zurück ins Template gemergt.

### `templates/claude/rules/`

| Datei | Status | Begründung | Action |
|-------|--------|------------|--------|
| `agents.md` | KEEP-BUT-STALE | **Template ist umfangreicher** (+48 Zeilen): Template hat detaillierte Graphify-Abschnitt mit 3 Graph-Typen (graph.json, liquid-graph.json, graphify-out/graph.json). Lokal wurde auf 2-Zeilen-Kurzform reduziert. Beides ist vertretbar — aber Liquid-Graph fehlt lokal. | Entscheiden: volle oder kurze Version ins Template? |
| `code-review-reception.md` | ACTIVE | Identisch | KEEP |
| `general.md` | KEEP-BUT-STALE | Minimaler diff (Zeilenumbrüche, Stacks-Beispiele): lokal `(Nuxt, Storyblok, Shopify, Laravel, etc.)` hinzugefügt. Kein semantischer Unterschied. | Trivial — KEEP |
| `git.md` | ACTIVE | Identisch | KEEP |
| `hooks-token-policy.md` | ORPHAN | Nur in `templates/claude/rules/`, nicht in `.claude/rules/`. Via `build_template_map()` wird es in Zielprojekte installiert. Lokal nie angewendet — vermutlich absichtlich (kein Hook-Token-Enforcement auf diesem Repo). | KEEP in Templates, lokal kein KEEP nötig |
| `mcp.md` | KEEP-BUT-STALE | Minimaler Unterschied — lokal hat ggf. andere MCP-Server-Liste | Prüfen |
| `quality.md` | ACTIVE | Identisch | KEEP |
| `testing.md` | ACTIVE | Identisch | KEEP |
| `typescript.md` | ACTIVE | Nur in Templates (beabsichtigt: `TS_RULES_MAP` installiert es conditional). | KEEP |
| `workflow.md` | KEEP-BUT-STALE | **Kritisch**: Lokale Version hat YAML-Frontmatter mit `paths:` Filter (`**/*.ts`, `**/*.vue`, `specs/**`, `.claude/skills/**`). Template hat das **nicht**. Das bedeutet: in Zielprojekten lädt das Workflow-Rule immer, lokal nur bei passenden Dateipfaden (effizienter). | UPDATE TEMPLATE — Frontmatter aus lokal in Template übernehmen |

### `templates/claude/scripts/`

Alle werden via `build_template_map()` als `.claude/scripts/` installiert.

| Datei | Status | Begründung | Action |
|-------|--------|------------|--------|
| `build-graph.sh` | ACTIVE | Identisch mit `.claude/scripts/build-graph.sh`? Nein — **`.claude/scripts/build-graph.sh` existiert nicht!** Template wird deployed, lokal fehlt es. `.claude/scripts/` hat stattdessen `build-summary.sh`, `quality-gate.sh` etc. Aber `build-graph.sh` ist IN templates/scripts/ — also wird es in Zielprojekte deployed. Der Shortfall: dieses Dev-Repo selbst hat es nicht lokal installiert. | Manuell installieren oder via `--patch` |
| `build-prep.sh` | ACTIVE | In Templates und lokal | KEEP |
| `changelog-prep.sh` | ACTIVE | Lokal und Template | KEEP |
| `ci-prep.sh` | ACTIVE | Referenziert in CLAUDE.md | KEEP |
| `commit-prep.sh` | ACTIVE | Standard | KEEP |
| `context-laravel.sh` | ACTIVE | Stack-spezifisch | KEEP |
| `context-nuxt.sh` | ACTIVE | Stack-spezifisch | KEEP |
| `context-shopify.sh` | ACTIVE | Stack-spezifisch | KEEP |
| `context-shopware.sh` | ACTIVE | Stack-spezifisch | KEEP |
| `context-storyblok.sh` | ACTIVE | Stack-spezifisch | KEEP |
| `debug-prep.sh` | ACTIVE | In CLAUDE.md referenziert | KEEP |
| `docs-audit.sh` | ACTIVE | Standard | KEEP |
| `doctor.sh` | ACTIVE | In CLAUDE.md referenziert, 19KB — größte Script | KEEP |
| `lint-prep.sh` | ACTIVE | In CLAUDE.md | KEEP |
| `pr-prep.sh` | ACTIVE | Standard | KEEP |
| `prep-lib.sh` | ACTIVE | Shared Library für andere Scripts | KEEP |
| `release-prep.sh` | ACTIVE | Standard | KEEP |
| `release.sh` | ACTIVE | Standard | KEEP |
| `review-prep.sh` | ACTIVE | Standard | KEEP |
| `scan-prep.sh` | ACTIVE | Standard | KEEP |
| `spec-board.sh` | ACTIVE | Via spec-board Skill | KEEP |
| `spec-review-prep.sh` | ACTIVE | Via spec-review Skill | KEEP |
| `spec-validate-prep.sh` | KEEP-BUT-STALE | Noch in Templates vorhanden. Referenziert in `templates/skills/spec/SKILL.template.md:127`. `/spec-validate` Skill ist entfernt (in `cleanup_known_orphans()`). Script bleibt trotzdem — es ist unabhängig nutzbar. **Aber**: Der Skill-Verweis in `spec/SKILL.template.md` auf dieses Script impliziert, dass `/spec` noch spec-validate aufruft. Klären ob Referenz entfernt werden soll. | PRÜFEN: Referenz in spec/SKILL.template.md noch aktuell? |
| `statusline.sh` | ACTIVE | Standard (obwohl claude-powerline ersetzt) | KEEP |
| `test-prep.sh` | ACTIVE | In CLAUDE.md + package.json | KEEP |
| `test-setup.sh` | ACTIVE | Standard | KEEP |

### `templates/claude/docs/`

| Datei | Status | Begründung | Action |
|-------|--------|------------|--------|
| `agent-dispatch.md` | ACTIVE | Identisch lokal | KEEP |
| `token-optimization.md` | ACTIVE | Identisch lokal | KEEP |

### `templates/claude/settings.json`

| Status | Befund | Action |
|--------|--------|--------|
| KEEP-BUT-STALE | **Zwei Unterschiede zum lokalen**: (1) Template hat `sandbox.enabled: false` mit Kommentar über macOS-Blockierung. Lokal hat `enabled: true`. (2) Template hat **kein** `shellcheck-guard.sh`-Hook, Lokal hat ihn. → Template-Sandbox-Default ist `false` (korrekt für Zielprojekte), lokal `true` (Opt-in für dieses Repo). | Normal — kein Fix nötig. Shellcheck-Guard ist bewusst lokal-only. |

---

## `templates/skills/` — 16 Skills

Gesamtgröße: ~55 KB. Alle vernünftig groß, kein Ausreißer.

| Skill-Dir | Bytes | Frontmatter-Features | Status | Befund |
|-----------|-------|---------------------|--------|--------|
| `spec/` | 7172 | `user-invocable: true`, `disable-model-invocation: true` | KEEP-BUT-STALE | Referenziert `spec-validate-prep.sh` auf Zeile 127 — `/spec-validate` Skill ist entfernt, aber das Script bleibt. Prüfen ob der Verweis noch Sinn macht. |
| `spec-work/` | 5864 | `user-invocable: true`, `effort: high`, `model: sonnet` | KEEP-BUT-STALE | **Lokal fehlt**: `--effort xhigh/max` Override-Block in Template (Zeile 70-71). Lokal-SKILL.md wurde nicht aktualisiert. |
| `challenge/` | 4627 | `user-invocable: true`, `allowed-tools:` als YAML-Liste | KEEP-BUT-STALE | **Template hat strukturiertes `allowed-tools:` YAML**, lokal hat Inline-Format `allowed-tools: Read, Glob, Grep`. Beide valid, aber inconsistent. |
| `spec-review/` | 3615 | `user-invocable: true` | ACTIVE | Identisch lokal |
| `review/` | 3526 | `user-invocable: true` | ACTIVE | Identisch lokal |
| `release/` | 3508 | `user-invocable: true`, `disable-model-invocation: true`, `model: sonnet`, `allowed-tools: ...` | KEEP-BUT-STALE | **Lokal fehlt**: `effort: medium`, `model: sonnet`, `allowed-tools`-Block. Template ist neuer. |
| `reflect/` | 3495 | `user-invocable: true`, `disable-model-invocation: true` | ACTIVE | Identisch lokal |
| `research/` | 2924 | `user-invocable: true`, `mode: plan` | KEEP-BUT-STALE | **Template hat `mode: plan`** und anderen Description-Text. Lokal fehlt `mode: plan` und `user-invocable`. |
| `analyze/` | 2879 | `user-invocable: true`, Effort-Override-Block | KEEP-BUT-STALE | **Template hat Effort-Override-Block** für `xhigh/max`. Lokal fehlt. |
| `spec-work-all/` | 2852 | `user-invocable: true`, `disable-model-invocation: true`, `effort: high`, `model: sonnet`, `allowed-tools:` | KEEP-BUT-STALE | **Lokal fehlt**: `effort: high`, `model: sonnet`, `allowed-tools:`-Block |
| `agent-browser/` | 2636 | `user-invocable: true` | ACTIVE | Identisch lokal (inkl. references/) |
| `explore/` | 2559 | `user-invocable: true` | ACTIVE | Identisch lokal |
| `test/` | 2403 | `user-invocable: true` | ACTIVE | Identisch lokal |
| `spec-board/` | 2384 | `user-invocable: true` | ACTIVE | Identisch lokal |
| `graphify/` | 2286 | `user-invocable: true` | ORPHAN | **Nicht lokal installiert**: Template existiert, aber `.claude/skills/graphify/` fehlt. Das Skill wird von `templates/.claudeignore:76` (skill-creator-workspace/) nicht berührt. Kein Hinweis warum es nicht installiert ist. `/graphify` Skill ist laut globaler Systemreferenz aktiv via `~/.claude/skills/graphify/` — bewusst nicht project-lokal. | KEEP (global-only) |
| `commit/` | 1965 | `user-invocable: true`, `disable-model-invocation: true`, `effort: low`, `allowed-tools:` YAML | KEEP-BUT-STALE | **Lokal hat anderen Description-Text** und fehlt `effort: low`, `allowed-tools:` YAML-Block. Template ist neuer. |

**Zusammenfassung Skills**: 8 von 16 Skills haben Frontmatter-Divergenzen zwischen Template und lokal installierter Version. Hauptmuster: neue Felder (`effort:`, `model:`, `allowed-tools:` als YAML, `mode: plan`) in Templates, lokal nicht nachgeführt.

---

## `templates/agents/`

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `code-reviewer.md` | ACTIVE | model: sonnet — kein veralteter Modellname | KEEP |
| `context-scanner.md` | ACTIVE | model: haiku — korrekt für Search-Agent | KEEP |
| `performance-reviewer.md` | ACTIVE | model: sonnet | KEEP |
| `security-reviewer.md` | ACTIVE | model: sonnet | KEEP |
| `staff-reviewer.md` | ACTIVE | model: sonnet | KEEP |
| `test-generator.md` | ACTIVE | model: sonnet | KEEP |
| `README.md` | ACTIVE | Template-Doku | KEEP |

Kein diff zwischen `templates/agents/` und `.claude/agents/` — identisch.

---

## `templates/github/`

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `copilot-instructions.md` | ACTIVE | Identisch mit `.github/copilot-instructions.md`. Wird via `build_template_map()` + `install_github_templates()` nur geupdated wenn `.github/` vorhanden. | KEEP |
| `workflows/release-from-changelog.yml` | ACTIVE | Wird via `build_template_map()` installiert | KEEP |

---

## `templates/codex/` und `templates/gemini/`

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `codex/config.toml` | ACTIVE | Identisch mit `codex/config.toml` (Root) — beide 224 Bytes | KEEP (beide) |
| `gemini/settings.json` | ACTIVE | Identisch mit `gemini/settings.json` (Root) — identisch bestätigt | KEEP (beide) |

---

## `templates/context-bundles/`

5 Bundle-Varianten (default, laravel, nextjs, nuxt-storyblok, nuxtjs, shopify-liquid) + README. Werden nie direkt installiert — `generate-summary.sh` liest Stack-Bundle und rendert es nach `.agents/context/`.

| Status | Befund |
|--------|--------|
| ACTIVE | `default/` enthält TODOs in Templates — das ist beabsichtigt (Platzhalter die der User füllt) |
| ACTIVE | Alle bundles vorhanden. `shopify-liquid/` nötig für den 2. häufigsten Stack |

---

## `templates/claude-mem/`

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `settings.json` | ACTIVE | Via `install_claude_mem_settings()` in `plugins.sh:44` nach `~/.claude-mem/settings.json` kopiert | KEEP |

---

## `templates/specs/`

| Datei | Status | Befund |
|-------|--------|--------|
| `README.md` | ACTIVE | Installiert in Zielprojekte als `specs/README.md` |
| `TEMPLATE.md` | ACTIVE | Installiert als `specs/TEMPLATE.md` |

---

## `.claude/` — Lokale Config (nicht in Zielprojekte)

### `.claude/settings.json` und `.claude/settings.local.json`

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `settings.json` | ACTIVE | 246 Zeilen. Enthält alle aktiven Hooks inkl. `shellcheck-guard.sh`. `model: claude-opus-4-7`. `sandbox.enabled: true` (lokal override, Template hat `false`). | KEEP |
| `settings.local.json` | KEEP-BUT-STALE | 84 Zeilen. Enthält `Skill(spec-validate)` — Skill entfernt (in `cleanup_known_orphans`). Enthält viele `WebFetch(domain:...)` Einträge die vom `fewer-permission-prompts` Skill akkumuliert wurden. **Akkumulations-Artefakt** — wird groß mit der Zeit. | TRIM: `Skill(spec-validate)` entfernen |

### `.claude/hooks/`

Alle aktiv. Diff-Status: Siehe `templates/claude/hooks/` Sektion — 5 Hooks lokal neuer als Template.

| Datei | Status | Befund |
|-------|--------|--------|
| `shellcheck-guard.sh` | ACTIVE (lokal-only) | Nur hier, nicht im Template. Bewusst: Bash-CLI-Repo-spezifisch |
| Alle anderen 11 | ACTIVE | Entweder identisch oder lokal-neuer |

### `.claude/rules/`

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `agents.md` | KEEP-BUT-STALE | Local stark reduziert vs Template (kein Liquid-Graph-Abschnitt, kein Graphify-Abschnitt) | Entscheiden ob Kurzversion richtig |
| `code-review-reception.md` | ACTIVE | Identisch | KEEP |
| `general.md` | ACTIVE | Minimaler Diff (Stacks-Beispiele) | KEEP |
| `git.md` | ACTIVE | Identisch | KEEP |
| `mcp.md` | KEEP-BUT-STALE | Minimaler Diff | Prüfen |
| `quality.md` | ACTIVE | Identisch | KEEP |
| `testing.md` | ACTIVE | Identisch | KEEP |
| `workflow.md` | KEEP-BUT-STALE | **Lokal hat `paths:`-Frontmatter, Template nicht.** YAML-Frontmatter am Anfang der Datei steuert selektive Kontextladung. **Lokal ist das korrekte, Token-effiziente Verhalten — muss ins Template zurück.** | UPDATE TEMPLATE SOFORT |
| `hooks-token-policy.md` | ORPHAN (lokal fehlt) | Nur in Template, nicht lokal. Template deployed es in Zielprojekte. Für dieses Repo nicht installiert (kein Hook-Token-Enforcement). | KEEP |

### `.claude/scripts/`

Enthält alle Template-Scripts PLUS 6 zusätzliche lokale Scripts:

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| Alle Template-Scripts | ACTIVE | Alle 26 Scripts aus `templates/scripts/` sind hier installiert — außer `build-graph.sh` (fehlt!) | `build-graph.sh` lokal installieren |
| `build-summary.sh` | ACTIVE | 11 Refs im Projekt (lokal-only, nicht in Templates) | KEEP lokal |
| `codeburn-metrics.sh` | ORPHAN | Nur 1 Ref (sich selbst). Kein Aufruf aus CLAUDE.md oder anderen Scripts. | PRÜFEN: wird es noch genutzt? |
| `liquid-graph-refresh.sh` | ACTIVE | 5 Refs, ruft `lib/build-liquid-graph.sh` auf. Sinnvoll für Shopify-Projekte. | KEEP lokal |
| `quality-gate.sh` | ACTIVE | 22 Refs, in CLAUDE.md als Shortcut dokumentiert | KEEP lokal |
| `session-deep-dive.sh` | ACTIVE | 8 Refs, wird von Skill aufgerufen | KEEP lokal |
| `session-extract.sh` | ACTIVE | 16 Refs | KEEP lokal |

### `.claude/agents/`

Identisch mit `templates/agents/` — kein Diff. **ACTIVE** alle 7 Agents.

### `.claude/docs/`

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `agent-dispatch.md` | ACTIVE | Identisch mit Template | KEEP |
| `token-optimization.md` | ACTIVE | Identisch mit Template | KEEP |
| `rtk-reference.md` | ACTIVE (lokal-only) | RTK-spezifisch für dieses Repo. 0 Refs in anderen Files (wird direkt gelesen). | KEEP lokal |

### `.claude/skills/`

| Skill | Status | Befund |
|-------|--------|--------|
| `agent-browser/` | ACTIVE | Identisch mit Template (inkl. `references/`, `templates/`) |
| `analyze/` | KEEP-BUT-STALE | Lokal fehlt Effort-Override-Block aus Template |
| `bash-defensive-patterns/` | ACTIVE (lokal-only) | Nicht in `templates/skills/` — global installierter Skill |
| `challenge/` | KEEP-BUT-STALE | Frontmatter-Diff (YAML-Format allowed-tools) |
| `claude-changelog/` | ACTIVE (lokal-only) | Nicht in `templates/skills/` |
| `commit/` | KEEP-BUT-STALE | Lokal fehlt `effort: low`, `allowed-tools:` Block |
| `explore/` | ACTIVE | Identisch |
| `gh-cli/` | ACTIVE (lokal-only) | Global installierter Skill |
| `orchestrate/` | ACTIVE | In `SPEC_SKILLS_MAP` + `update.sh:583` referenziert. Sonderfall: nicht mehr in `templates/skills/`, aber update.sh cleaned es nicht. |
| `reflect/` | ACTIVE | Identisch |
| `release/` | KEEP-BUT-STALE | Lokal fehlt `effort: medium`, `model: sonnet`, `allowed-tools:` |
| `research/` | KEEP-BUT-STALE | Lokal fehlt `mode: plan`, `user-invocable`, `description` aktualisiert |
| `review/` | ACTIVE | Identisch |
| `spec/` | ACTIVE | Identisch |
| `spec-board/` | ACTIVE | Identisch |
| `spec-review/` | ACTIVE | Identisch |
| `spec-work/` | KEEP-BUT-STALE | Lokal fehlt Effort-Override-Block |
| `spec-work-all/` | KEEP-BUT-STALE | Lokal fehlt `effort: high`, `model: sonnet`, `allowed-tools:` |
| `test/` | ACTIVE | Identisch |
| `skill-creator-workspace/` | DEAD (Eval-Artefakt) | 50 Dateien, Token-Optimizer Eval-Iterations. In `.claudeignore` gelistet. Nie in Templates. Committed aber nur für Development-Kontext-Rekonstruktion. **500KB+ Eval-Output, 0 operative Nutzung.** | LÖSCHEN oder via `.gitignore` aus Tracking entfernen |

### `.claude/commands/`

Lokale Slash-Commands (`.md`-Format für Claude Code). Werden via `lib/global-settings.sh` nach `~/.claude/commands/` installiert.

| Datei | Status | Befund |
|-------|--------|--------|
| `ci.md` | ACTIVE (lokal-only) | Lokal projektspezifisch |
| `discover.md` | ACTIVE (lokal-only) | Lokal projektspezifisch |
| `pr.md` | ACTIVE | Via `global-settings.sh:129` nach `~/.claude/commands/pr.md` |
| `test-setup.md` | ACTIVE (lokal-only) | |
| `yolo.md` | ACTIVE (lokal-only) | |

### `.claude/` Root-Dateien

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `agent-metrics.log` | DEAD (gitignored) | 12 KB Runtime-Log | Löschen (lokal) |
| `task-completed.log` | DEAD (gitignored) | 3.4 KB Runtime-Log | Löschen (lokal) |
| `task-created.log` | DEAD (gitignored) | 1.9 KB Runtime-Log | Löschen (lokal) |
| `permission-denied.log` | DEAD (gitignored) | 134 Bytes Runtime-Log | Löschen (lokal) |
| `tool-failures.log` | DEAD (gitignored, 0 Bytes) | Leer | Löschen (lokal) |
| `subagent-usage.log` | DEAD (gitignored, 0 Bytes) | Leer | Löschen (lokal) |
| `config-changes.log` | DEAD (gitignored, 0 Bytes) | Leer | Löschen (lokal) |
| `findings-log.md` | MISPLACED | Manuelles Dev-Log. Nicht gitignored, aber kein Code liest es. | Nach `specs/` oder löschen |
| `token-optimizer-eval-2-response.md` | DEAD | Eval-Artefakt von März. | Löschen |
| `changelog-audit.json` | ACTIVE | 262 Bytes. Von `claude-changelog/SKILL.md` geschrieben/gelesen. | KEEP |
| `claude-powerline.json` | ACTIVE | 1054 Bytes. Von Spec 075 installiert. Konfiguriert `@owloops/claude-powerline`. Keine Code-Leser außer dem NPX-Tool selbst. | KEEP |

---

## `.agents/context/`

Auto-generated Output aus `generate.sh` + `generate-summary.sh`. Letzte Generierung: `.state` vom 15. April 2026.

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `SUMMARY.md` | ACTIVE (stale) | 22 Zeilen. Letzter Stand 15. April. Seit dem: 3 Commits. | Run `/analyze` um zu refreshen |
| `ARCHITECTURE.md` | ACTIVE | 86 Zeilen | KEEP |
| `AUDIT.md` | KEEP-BUT-STALE | 81 Zeilen. Stand 15. April. Neuere Fixes (spec-validate cleanup, etc.) nicht drin. | Refresh via `/analyze` |
| `STACK.md` | ACTIVE | 39 Zeilen | KEEP |
| `CONVENTIONS.md` | ACTIVE | 82 Zeilen | KEEP |
| `DESIGN-DECISIONS.md` | ACTIVE | 67 Zeilen | KEEP |
| `CONCEPT.md` | ACTIVE | 67 Zeilen | KEEP |
| `PATTERNS.md` | ACTIVE | 61 Zeilen | KEEP |
| `LEARNINGS.md` | ACTIVE | 23 Zeilen | KEEP |
| `graph.json` | ACTIVE | JS/TS-Import-Graph. `graph-manifest.json` als Index. | KEEP |
| `.state` | ACTIVE | State-Datei für inkrementellen Rebuild | KEEP |

---

## `specs/`

### Aktive Specs (Root-Level)

| Datei | Status-Feld | Befund | Action |
|-------|-------------|--------|--------|
| `571-ship-command.md` | completed (cancelled) | Abgebrochen — sollte in `completed/` sein | VERSCHIEBEN |
| `572-qa-tiering-review.md` | completed (cancelled) | Abgebrochen — sollte in `completed/` sein | VERSCHIEBEN |
| `598-setup-consistency-hardening.md` | completed | Implementiert — sollte in `completed/` sein | VERSCHIEBEN |
| `599-sandbox-safe-global-side-effects.md` | completed | Implementiert — sollte in `completed/` sein | VERSCHIEBEN |
| `603-claude-plugin-first-foundation.md` | draft | Aktiv | KEEP |
| `605-tdd-enforcement-hook.md` | completed | Implementiert — sollte in `completed/` sein | VERSCHIEBEN |
| `617-targeted-worktree-expansion.md` | parked | Parked | KEEP (oder `completed/`) |
| `618-long-task-visibility-and-notifications.md` | parked | Parked | KEEP (oder `completed/`) |
| `622-skill-audit-and-consolidation.md` | completed | Implementiert — sollte in `completed/` sein | VERSCHIEBEN |
| `627-adr-skill.md` | draft | Aktiv | KEEP |
| `628-pre-modification-skill.md` | draft | Aktiv | KEEP |
| `633-claudemd-auto-compression.md` | draft | **Doppelte ID 633** | RENUMBERN |
| `633-lean-ctx-plugin.md` | draft, Branch aktiv | Aktiv, Branch `feat/lean-ctx-plugin` | KEEP, aber RENUMBERN |
| `647-bundle-path-scoped-rules.md` | draft | Aktiv | KEEP |

**5 abgeschlossene Specs im aktiven Root**, 1 doppelte Spec-ID (633).

### Changelog-Audit-Files in `specs/`

| Datei | Status | Action |
|-------|--------|--------|
| `changelog-audit-2026-04-15.md` | Ephemeral | Nach `completed/` oder löschen — kein aktiver Wert |
| `changelog-audit-2026-04-17.md` | Ephemeral | Gleich |
| `changelog-audit-2026-04-24.md` | Ephemeral | Gleich |
| `changelog-audit-2026-04-28.md` | Ephemeral | Gleich |
| `changelog-audit-full-2026-04-28.md` | EPHEMERAL | Neues Full-Audit (dieser Report hier nimmt seinen Platz) |
| `setup-cleanup-audit-2026-04-28.md` | ACTIVE | Vorheriger Audit — keep als Referenz |

### `specs/completed/`

251 abgeschlossene Specs. `.gitkeep` vorhanden. Kein Action nötig.

### `specs/brainstorms/`

| Datei | Status | Action |
|-------|--------|--------|
| `113-octopus-adaptation-brainstorm.md` | DEAD | 27KB. Inhalt längst in `specs/completed/113-octopus-adaptation-brainstorm.md` übertragen (confirmed: beide existieren). Das Root-Brainstorm ist Duplikat. | LÖSCHEN |
| `640b-mcp-platform-discovery.md` | ORPHAN | 2KB, April. Kein aktiver Spec verlinkt. | KEEP oder nach completed/ |

---

## `tests/`

| Datei | Zeilen | Status | Package.json-Aufruf | Befund |
|-------|--------|--------|---------------------|--------|
| `smoke.sh` | 542 | ACTIVE | `npm run test:smoke` | Comprehensive Smoke-Tests |
| `integration.sh` | 222 | ACTIVE | `npm run test:integration` | Integration-Tests |
| `claude-runtime.sh` | 309 | ACTIVE | `npm run test:claude-runtime` | Claude-Runtime-Tests |
| `routing-check.sh` | 134 | ACTIVE | `npm run routing-check` + pre-commit hook | Tool-Routing-Validierung |
| `hook-tokens-baseline.sh` | 48 | ORPHAN | **Nicht in `package.json:scripts`** | Verwendet `lib/hook-token-audit.sh`. Kein CI-Run. Manuelles Audit-Tool. | DOKUMENTIEREN oder package.json-Script hinzufügen |
| `fixtures/session-deep-dive-sample.txt` | — | ACTIVE | Von `session-deep-dive.sh` Tests | KEEP |

---

## Root-Files

| Datei | Status | Befund | Action |
|-------|--------|--------|--------|
| `package.json` | ACTIVE | `files:` korrekt (`bin/`, `lib/`, `templates/`, `README.md`). `scripts/` und `tests/` korrekt nicht publisht. `bin.ai-setup` und `bin.ai-setup-global` korrekt. | KEEP |
| `README.md` | ACTIVE | Hauptdoku — publisht | KEEP |
| `CLAUDE.md` | ACTIVE | Projekt-Instruktionen | KEEP |
| `CHANGELOG.md` | ACTIVE | | KEEP |
| `AGENTS.md` | ACTIVE | Root-Level für CI/CD-Kontext | KEEP |
| `decisions.md` | ACTIVE | Via `migrations/1.4.0.sh` installiert | KEEP |
| `30` | DEAD | 0 Bytes, Zufalls-Artefakt. `git rm 30`. (Bereits in Vorherigem Report dokumentiert.) | LÖSCHEN |
| `BACKLOG.md` | ORPHAN | 0 Refs in `lib/`, `bin/`, `templates/`, CLAUDE.md, README. | LÖSCHEN |
| `ONBOARDING.md` | ORPHAN | Gleiche Situation — nicht publiziert, nicht verlinkt | NACH `docs/` oder LÖSCHEN |
| `skills-lock.json` | ACTIVE | 20 Zeilen. Skill-Version-Tracking. | KEEP |
| `.ai-setup.json` | ACTIVE | 122 Zeilen. Setup-State für dieses Repo selbst. | KEEP |
| `opencode.json` | ACTIVE | Via `generate_opencode_config()` generiert | KEEP |
| `cmux.json` | ACTIVE | Dev-Komfort für Maintainer | KEEP |
| `.mcp.json` | ACTIVE | context7 lokal eingetragen | KEEP |
| `.gitignore` | ACTIVE | | KEEP |
| `.ai-setup-backup/` | DEAD (gitignored) | 14 Backup-Files vom 6. April. Lokal cleanbar. | LÖSCHEN (lokal) |
| `.DS_Store` | DEAD | macOS-Artefakt, sollte gitignored sein | Zu `.gitignore` hinzufügen falls nicht da |

---

## `.claude/` Config-Verzeichnisse (lokal)

### `.codex/` und `.opencode/` — Symlinks

| Verzeichnis | Status | Befund |
|-------------|--------|--------|
| `.codex/skills` | ACTIVE | Symlink → `../.claude/skills`. Valide, löst auf. |
| `.opencode/skills` | ACTIVE | Symlink → `../.claude/skills`. Valide, löst auf. |

### `.gemini/settings.json`

ACTIVE — identisch mit `gemini/settings.json` (Root-Template).

### `.rtk/filters.toml`

ACTIVE — RTK-spezifische Filter, sinnvoll committed.

### `.github/copilot-instructions.md`

ACTIVE — identisch mit `templates/github/copilot-instructions.md`.

### `.githooks/`

| Datei | Status | Befund |
|-------|--------|--------|
| `pre-commit` | ACTIVE | Ruft `tests/routing-check.sh` auf. Opt-out via `SKIP_PRECOMMIT_ROUTING=1`. |
| `pre-push` | ACTIVE | Ruft `npm test` auf. Opt-out via `SKIP_PREPUSH_TESTS=1`. |

---

## Konsistenz-Checks

### 1. Templates vs Lokal — Hooks (Kritisch)

```
diff -rq templates/claude/hooks/ .claude/hooks/
```

| Hook | Richtung | Art der Änderung |
|------|----------|-----------------|
| `context-freshness.sh` | Lokal neuer | Directory-Guard für JS/TS-Apps |
| `precompact-guidance.sh` | Lokal neuer | Spec-in-progress Block-Logik |
| `protect-files.sh` | Lokal neuer | Schlankerer Assets/-Guard |
| `spec-stop-guard.sh` | Lokal neuer | Case-insensitive Status-Detection |
| `tool-redirect.sh` | Template neuer | RTK_SKIP-Bypass + bessere Git-Guard |
| `README.md` | Lokal neuer | Lokal aktualisiert |

**Fazit**: 4 von 6 diffs sollten Template-Updates sein (lokal → Template). 1 davon (tool-redirect) sollte lokal von Template übernommen werden.

### 2. Skills — Templates vs Lokal

| Skill | Status |
|-------|--------|
| `analyze`, `challenge`, `commit`, `release`, `research`, `spec-work`, `spec-work-all` | LOKAL VERALTET — Template hat neuere Frontmatter |
| `explore`, `reflect`, `review`, `spec`, `spec-board`, `spec-review`, `test`, `agent-browser` | IDENTISCH |
| `graphify` | Nur in Template, lokal nicht installiert (global) |
| `bash-defensive-patterns`, `claude-changelog`, `gh-cli`, `orchestrate`, `skill-creator-workspace` | Nur lokal |

### 3. Rules — Templates vs Lokal

| Rule | Status |
|------|--------|
| `workflow.md` | **KRITISCH**: Lokal hat `paths:` YAML-Frontmatter, Template fehlt das |
| `agents.md` | Template umfangreicher (Graphify + Liquid-Graph-Abschnitte) |
| `general.md` | Marginaler Diff (Stack-Namen) |
| `mcp.md` | Marginaler Diff |
| `hooks-token-policy.md` | Template-only (bewusst) |
| `typescript.md` | Template-only (conditional via TS_RULES_MAP) |

---

## Veraltete Inhalte

### Modell-Strings

Keine veralteten `claude-3-5`- oder `claude-3-7`-Strings. Aktuell verwendete Modelle:

| Verwendung | Modell-String | Aktuell? |
|------------|--------------|----------|
| `lib/setup.sh:48` | `claude-haiku-4-5` | Aktuell (4.5 existiert) |
| `lib/generate.sh:286` | `claude-haiku-4-5-20251001` | OK (versioned ID) |
| `lib/generate.sh:266,277,305,335` | `claude-sonnet-4-6` | OK |
| `lib/setup-compat.sh` | `anthropic/claude-haiku-4-5`, `anthropic/claude-sonnet-4-6` | OK |
| `templates/scripts/doctor.sh:17` | `claude-sonnet-4-6` | OK |

**Befund**: Keine veralteten Modell-Strings im Code. Die Modell-IDs entsprechen aktuellen Claude Code Versionen.

### Veraltete Skill-Referenzen

| Ort | Veraltete Referenz | Befund |
|-----|--------------------|--------|
| `templates/scripts/spec-validate-prep.sh` | `/spec-validate` Skill (im Kommentar) | Skill entfernt, Script bleibt — unklar ob Script relevant |
| `templates/skills/spec/SKILL.template.md:127` | `spec-validate-prep.sh` als Schritt | Referenz auf entfernten Workflow |
| `.claude/settings.local.json` | `Skill(spec-validate)` | Toter Permission-Eintrag |
| `lib/core.sh:67-74` | `SPEC_SKILLS_MAP` mit `orchestrate`-Eintrag | Dead Code — Skill nicht mehr via diesen Map deployed |
| `lib/update.sh:583-584` | `".claude/skills/orchestrate/SKILL.md"` | Sonderbehandlung für orchestrate (nicht in cleanup_known_orphans, aber auch nicht in templates/skills/) |

---

## TODO-Backlog im Code

```
templates/context-bundles/default/*.md — TODOs als Platzhalter (beabsichtigt)
templates/claude/hooks/task-completed-gate.sh — TODO als Pattern-Check (beabsichtigt)
templates/agents/code-reviewer.md — TODO in Review-Instruktionen (beabsichtigt)
lib/build-liquid-graph.sh:64 — /tmp hardcoded (MEDIUM-Bug aus vorherigem Audit, noch offen)
```

Kein unbeabsichtigter TODO/FIXME/HACK in operativem Code außer dem `build-liquid-graph.sh:/tmp`-Fall.

---

## Broken Symlinks

Manuelle Prüfung ergab:
- `.codex/skills` → `../.claude/skills` — **VALID** (aufgelöst, Inhalt lesbar)
- `.opencode/skills` → `../.claude/skills` — **VALID** (aufgelöst, Inhalt lesbar)

Keine broken Symlinks.

---

## `package.json` files-Field — Vollständigkeitsprüfung

Publisht werden: `bin/`, `lib/`, `templates/`, `README.md`.

| Pfad | Existiert? | Vollständig? |
|------|------------|-------------|
| `bin/` | ✓ | 2 Scripts |
| `lib/` | ✓ | 28 Files inkl. `data/`, `migrations/` |
| `templates/` | ✓ | ~100 Files über alle Subdirs |
| `README.md` | ✓ | — |

**Nicht publisht (korrekt)**: `scripts/`, `tests/`, `.claude/`, `specs/`, `docs/`, Root-Configs.

**Nicht in files aber committed**: `BACKLOG.md`, `ONBOARDING.md`, `30`, `cmux.json`, `decisions.md`, `CHANGELOG.md`, `AGENTS.md`, `skills-lock.json`, `.ai-setup.json`, `opencode.json`, `codex/`, `gemini/` — alles Dev-Kontext, kein Publish-Problem.

---

## Appendix: Vollständige Datei-Zählung

| Bereich | Files | Davon ACTIVE | Davon STALE/ORPHAN/DEAD |
|---------|-------|-------------|------------------------|
| `bin/` | 2 | 2 | 0 |
| `lib/` | 28 | 27 | 1 (dead code in core.sh) |
| `lib/migrations/` | 3 | 3 | 0 |
| `scripts/` | 5 | 4 | 1 (validate-release orphan) |
| `templates/` root | 6 | 6 | 0 |
| `templates/claude/hooks/` | 12 | 12 | 5 (stale vs local) |
| `templates/claude/rules/` | 10 | 8 | 2 (stale) |
| `templates/claude/scripts/` | 26 | 25 | 1 (spec-validate-prep unklar) |
| `templates/claude/docs/` | 2 | 2 | 0 |
| `templates/skills/` | ~50 | ~40 | 8 (stale frontmatter) |
| `templates/agents/` | 7 | 7 | 0 |
| `templates/github/` | 2 | 2 | 0 |
| `templates/context-bundles/` | 18 | 18 | 0 |
| `.claude/hooks/` | 12 | 12 | 0 |
| `.claude/rules/` | 8 | 6 | 2 (stale) |
| `.claude/scripts/` | 32 | 31 | 1 (codeburn-metrics?) |
| `.claude/skills/` | ~180 | ~130 | 50 (skill-creator-workspace evals) |
| `.claude/agents/` | 7 | 7 | 0 |
| `.claude/docs/` | 3 | 3 | 0 |
| `.claude/commands/` | 5 | 5 | 0 |
| `.claude/` root | 10 | 2 | 8 (logs, eval-response, findings-log) |
| `.agents/context/` | 12 | 11 | 1 (AUDIT.md stale) |
| `specs/` root | 22 | 8 | 14 (5 completed+, 4 changelogs, 1 dup ID, 1 brainstorm dup) |
| `specs/completed/` | 252 | 252 | 0 |
| `tests/` | 6 | 5 | 1 (hook-tokens-baseline nicht in CI) |
| Root | 15 | 11 | 4 (30, BACKLOG, ONBOARDING, .DS_Store) |
