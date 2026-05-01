# Changelog

All notable changes are recorded here automatically when specs are completed via `/spec-work`.

Format: grouped by version. New entries go under `## [Unreleased]` and are moved to a versioned heading when `bash bin/release.sh` is run (this repo only — target projects do not ship a release skill).

---

<!-- Entries are prepended below this line, newest first -->

## [Unreleased]

## [v2.3.0] — 2026-05-01

<!-- slack-announcement -->
:package: *@onedot/ai-setup v2.3.0 — schlanker, leiser, schlauer*

*Was ihr im Projekt merkt:*
:broom: *Weniger Setup-Müll* — `--patch` räumt 28+ veraltete Skills, tote Hooks und Doctor-Reste automatisch raus. Bestandsprojekte werden 21% kleiner ohne dass ihr was tun müsst.
:mute: *Boilerplate Pull leise* — Statt jedes Mal prominent "Pulling..." nur noch 1 Zeile bei Cache-Hit. TTL 7 Tage statt 24h, weniger gh-API-Calls pro Setup.
:dart: *Bessere Routing-Defaults* — Reviewer-Agents kennen jetzt den Liquid-Graph (Hub-Snippets ≥5 Renderer triggern Performance-Check), Delegation-Mandates schärfer (≥3 Bash → bash-runner, ≥2 Edits → implementer).

*Migration:* `npx github:onedot-digital-crew/npx-ai-setup` — räumt automatisch auf.
<!-- /slack-announcement -->

### Added
- `cleanup_known_orphans()` — räumt 28+ veraltete Skills, Hooks, Scripts in Bestandsprojekten per `--patch`

### Changed
- Boilerplate Pull: Section-Header nur bei echten Pulls, 1-Liner bei Cache-Hit, TTL 24h → 7d
- `LOCAL_ONLY_SKILLS` + `LOCAL_ONLY_SCRIPTS` um `release` + `release-prep.sh` erweitert

### Removed
- `templates/scripts/{doctor,changelog-prep,docs-audit,statusline,test-setup,pr-prep,build-summary}.sh`
- `templates/claude/hooks/{shellcheck-guard.sh,README.md}`
- Stale Fallback-Kopien in `templates/skills/agent-browser/references/` + `templates/` (Skill wird via External-Install gepflegt, lokale Kopien waren outdated)
- `templates/skills/release/` (setup-only, nicht für Target-Projekte)

## [v2.2.4] — 2026-04-30

<!-- slack-announcement -->
:package: *@onedot/ai-setup v2.2.4 — Delegation Mandates + Drift Sync*

*Was ist neu:*
:sparkles: *Delegation Mandates* — Opus delegiert automatisch: ≥3 Bash-Calls → `bash-runner` (haiku), ≥2 Edits → `implementer` (sonnet), Arch-Review → `staff-reviewer` (opus). MUST-Trigger in CLAUDE.md + agents.md.
:gear: *Template Drift Sync* — `.claude/` und `templates/claude/` wieder in sync (9 Diffs → 0). Pre-commit Hook + `scripts/template-drift-check.sh` verhindert künftigen Drift.
:wrench: *agent-dispatch.md* — rewritten: 14 veraltete Einträge → 8 reale Agents mit korrekten Triggern.
:sparkles: *repomix Fast-Path* — `/analyze` nutzt repomix als opt-in Context-Snapshot, mit Drift-Detection in context-freshness Hook.
:wrench: *tool-redirect Cleanup* — Hook entfernt, ersetzt durch direkte `Bash(rtk:*)` + native Tool-Grants in settings.json. Weniger Hook-Latency, gleiche RTK-Coverage.

*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

### Added
- `.claude/agents/bash-runner.md` — haiku subagent für Bash-Chains ≥3
- `.claude/agents/implementer.md` — sonnet subagent für Edit/Write-Clusters ≥2
- `scripts/template-drift-check.sh` — diff-rq based drift detection mit allowlists
- `.claude/scripts/analyze-fast.sh` — repomix Fast-Path für /analyze (opt-in)
- `.claude/scripts/measure-context-cost.sh` — token auditor

### Changed
- `staff-reviewer.md` model: sonnet → opus
- `agent-dispatch.md` rewritten (14 stale → 8 real agents)
- `.claude/rules/agents.md` + mandate table: 8 MUST-delegate Triggers
- `CLAUDE.md` Delegation Mandates Block (compact, 1 Zeile + Link)
- Pre-commit hook: drift-check eingehängt (skip via `SKIP_PRECOMMIT_DRIFT=1`)
- Rules/hooks/scripts synced local↔templates (agents.md, general.md, mcp.md, workflow.md, context-freshness.sh, README.md)
- `templates/CLAUDE.md` RTK constraint: explicit examples (`rtk git status`, `rtk grep ...`)
- `.claude/settings.json` permissions.allow: `rtk:*`, `grep:*`, `find:*`, `cat:*`, `awk:*`, `rg:*`, `diff:*`, `head:*`, `which:*`, `test:*`, `pwd:*`, `bash .claude/scripts/*` (replaces tool-redirect rewrite chain)
- `.claude/scripts/analyze-sessions.sh` Bash histogram: strip env-var prefixes, flatten heredoc multi-lines, reject JS/TS keywords leaking from embedded scripts
- `lib/migrations/2.3.0.sh` skips tool-redirect.sh update (file removed)

### Removed
- `.claude/hooks/tool-redirect.sh` + `templates/claude/hooks/tool-redirect.sh` (replaced by direct `Bash(rtk:*)` allow + native tool grants in settings.json)
- Matching PreToolUse hook block in `.claude/settings.json`

### Specs
- 649 completed (template drift sync), 651 completed (repomix), 652 completed (delegation mandates)
- 647+648 superseded, 650 closed as research

## [v2.2.3] — 2026-04-28

### Removed
- `Stop` hook registration in `templates/claude/settings.json` and local `.claude/settings.json`
- `templates/claude/hooks/spec-stop-guard.sh` and `.claude/hooks/spec-stop-guard.sh`

### Why
Hook fired on every turn-end when any spec had `Status: in-progress`, blocking Stop with a 60s double-tap bypass. UX cost outweighed the value — spec status in markdown is sufficient documentation. Targets pick up removal on next `npx ai-setup --force-update`.

## [v2.2.2] — 2026-04-28

<!-- slack-announcement -->
:package: *@onedot/ai-setup v2.2.2 — Cleanup & Hook-Drift-Sync*

*Was ist neu:*
:wrench: *Hook-Drift fixed* — 5 Hooks waren in `.claude/hooks/` (lokal) neuer als in `templates/claude/hooks/`. Zielprojekte bekamen veraltete Versionen. Jetzt synced: `precompact-guidance` (Spec-in-progress Block), `spec-stop-guard` (case-insensitive Status), `protect-files` (Vite-Assets-Guard schlanker), `context-freshness` (Directory-Guard), `tool-redirect` (RTK_SKIP-Bypass auch lokal).
:gear: *Effort-Levels integriert* — `xhigh` für Opus 4.7, `${CLAUDE_EFFORT}`-Awareness in `spec-work` und `analyze` Skills. `agents.md` template + lokal mit Effort-Tabelle.
:memo: *MCP alwaysLoad* — `context7` MCP ist jetzt mit `alwaysLoad: true` konfiguriert (kein Tool-Search-Deferral). Kritische Dokumentations-Lookups immer verfügbar.
:zap: *1h Prompt-Cache TTL* — `ENABLE_PROMPT_CACHING_1H: "1"` ins Template — alle neu installierten Projekte nutzen 1h statt 5min Cache.
:broom: *Dead-Code raus* — `install_spec_skills()` + `SPEC_SKILLS_MAP` aus `lib/`, `Skill(spec-validate)` aus settings.local.json, doppelte Spec-IDs konsolidiert.
:bug: *Integration-Test repariert* — pre-existing Hang in `tests/integration.sh` (find als bash function statt binary) gefixt + `claude-mem` graceful skip wenn `~/.claude-mem` read-only.

*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

### Added
- `alwaysLoad: true` for context7 in `.mcp.json` and `templates/mcp.json` (Claude Code 2.1.121 feature)
- `ENABLE_PROMPT_CACHING_1H: "1"` in `templates/claude/settings.json` env-Block
- `${CLAUDE_EFFORT}` Override-Block in `spec-work` and `analyze` skill templates (xhigh/max → opus + full review agents)
- `paths:` YAML frontmatter in `templates/claude/rules/workflow.md` for selective rule loading
- Effort-Levels section (`medium → high → xhigh → max`) in `templates/claude/rules/agents.md`
- Model-Routing section in root `CLAUDE.md` with haiku/sonnet/opus scope rules
- Status reports under `specs/`: `setup-cleanup-audit-2026-04-28.md`, `setup-cleanup-audit-FULL-2026-04-28.md`, `changelog-audit-full-2026-04-28.md`

### Changed
- Sync `precompact-guidance.sh` template ← local: blocks compact when a spec is `Status: in-progress`
- Sync `spec-stop-guard.sh` template ← local: case-insensitive status detection
- Sync `protect-files.sh` template ← local: leaner Vite-Assets-Guard, removes deny-rule duplicates
- Sync `context-freshness.sh` template ← local: directory-guard for Bash-CLI-repos
- Sync `tool-redirect.sh` local ← template: `RTK_SKIP=1` emergency bypass + `command -v rtk` guard before git rewrites
- Sync 7 skills (`analyze`, `challenge`, `commit`, `release`, `research`, `spec-work`, `spec-work-all`) frontmatter local ← template (added `effort:`, `model:`, `allowed-tools:` YAML)
- `tool-redirect.sh` comment: "ripgrep" → "bfs/ugrep" (Claude Code 2.1.117 native search)
- `agents.md` (.claude/rules): wording aligned with `routing-check.sh` ("default for implementation subagents", "never for implementation")

### Fixed
- (plugins): merge missing template keys into ~/.claude-mem/settings.json on update; warn on misplaced CLAUDE_MEM_* keys in project .claude/settings.json
- (plugins): `install_claude_mem_settings` no longer hard-fails when `~/.claude-mem` is read-only — graceful skip
- (tests): `tests/integration.sh` `link_tool` uses `type -P` instead of `command -v` to skip bash-function wrappers (find/ls); `run_install` captures install rc to `.rc` file instead of triggering `set -e`
- (tests): `tests/claude-runtime.sh` replaces removed `/context-load STACK.md` skill with `@.agents/context/STACK.md` direct read
- (tests): `tests/smoke.sh` removes obsolete `install_spec_skills` requirement check, removes `docs/claude-governance.md` existence check, skips brainstorm/research files in spec-status assertion

### Removed
- `lib/setup-skills.sh:install_spec_skills()` — superseded by generic `install_skills()` (loops `templates/skills/`)
- `lib/core.sh:SPEC_SKILLS_MAP` — superseded by dynamic `TEMPLATE_MAP`
- `lib/update.sh:367` — `SPEC_SKILLS_MAP` reference in `all_mappings`
- `Skill(spec-validate)` from `.claude/settings.local.json` (skill cleaned up via `cleanup_known_orphans`)
- Root files: `30` (0-byte artifact), `BACKLOG.md`, `ONBOARDING.md`, `docs/claude-governance.md`
- Stale eval artifacts: `.claude/findings-log.md`, `.claude/token-optimizer-eval-2-response.md`, `.claude/skills/skill-creator-workspace/` (~500 KB, 50 token-optimizer eval files)
- Duplicate brainstorm: `specs/brainstorms/113-octopus-adaptation-brainstorm.md` (moved to `specs/completed/`)
- Spec ID 633 collision: `633-claudemd-auto-compression.md` renumbered → `648-`

## [v2.2.1] — 2026-04-24

<!-- slack-announcement -->
:package: *@onedot/ai-setup v2.2.1 — Stack-Aware Setup*

*Was ist neu:*
:dart: *Stack-Profile* — `lib/detect-stack.sh` erkennt `nuxt-storyblok`, `nuxtjs`, `shopify-liquid`, `laravel`, `nextjs` automatisch. Context-Bundles werden bei bekanntem Stack direkt kopiert — **zero LLM cost**, spart 2-3k Tokens pro Setup.
:scroll: *Curated MCPs* — `context7` global und `shopify-dev-mcp` bei Shopify-Themes automatisch als Vorschlag in `.mcp.json`. Kein Auth, kein Slug-Raten.
:mag: *Liquid Dependency Graph* — Shopify-Themes bekommen `.agents/context/liquid-graph.json` mit section→snippet→template Edges. Grep-freie Cross-File Navigation.
:hammer_and_wrench: *Skill-Filter* — Skills mit `stacks:` Frontmatter werden nur passend zum Profil installiert. Nuxt-Projekt lädt keine Shopify-Skills mehr.
:no_entry_sign: *.claudeignore per Stack* — managed block mit `.nuxt/`, `config/settings_data.json`, `vendor/` etc. automatisch ausgeblendet. Idempotent + User-Lines preserved.
:bar_chart: *Token Budget* — Hook-Token-Audit mit 300/2000 Caps, Context-File Size Caps (SUMMARY ≤40, STACK ≤100, ARCHITECTURE ≤150, CONVENTIONS ≤80 Zeilen).
:brain: *Graphify Opt-in* — grosse Projekte (Nuxt ≥50 .vue, Shopify ≥30 .liquid, Laravel ≥100 .php) kriegen optional Graphify-Skill. `pipx install graphifyy`, dann Knowledge-Graph on-demand.
:eye: *Graph-Before-Read Hook* — PreToolUse Hint bei >500 Zeilen oder 4x Grep in Folge, verweist auf graph.json-Queries. Exit 0, nie blockierend.

*Neue Flags:* `--force-skip-graphify`, `--force-all-skills`, `--relax-context-caps`

*Entfernt:* n8n + mcp-server Profile (nicht Primary Targets), repomix (bereits in 2.2)
<!-- /slack-announcement -->

### Added
- Stack-profile detection (`lib/detect-stack.sh`): `nuxt-storyblok`, `nuxtjs`, `shopify-liquid`, `laravel`, `nextjs`, `default` + `graphify_candidate` signal (spec/638, spec/637)
- Context bundles (`templates/context-bundles/`): 6 profile-specific STACK.md/ARCHITECTURE.md/CONVENTIONS.md starting points
- `lib/generate-summary.sh` merges bundle abstracts into tiered-loading SUMMARY.md
- Bundle-aware `--patch` protection: manually edited files (no `<!-- bundle: -->` marker) saved as `.new` instead of overwritten
- Liquid dependency graph generator (`lib/build-liquid-graph.sh`) + refresher + ARCHITECTURE.md docs (spec/639)
- Curated standard MCPs (`lib/mcp-suggest.sh`, `lib/data/mcp-defaults.json`): context7 global, shopify-dev-mcp for Shopify (spec/640)
- Stack-specific `.claudeignore` installer (`lib/install-claudeignore.sh`) + 7 templates + managed-block markers (spec/641)
- Skill frontmatter filter (`lib/skill-filter.sh`) at boilerplate pull + setup-skills with `stacks:` field support (spec/642)
- Hook token audit (`lib/hook-token-audit.sh`) + policy template (300/2000 caps) (spec/643)
- Context-file size caps (`lib/context-size-check.sh`, `lib/data/context-caps.json`) + doctor.sh integration (spec/644)
- Graph-before-read PreToolUse hint hook (`templates/claude/hooks/graph-before-read.sh`) for files >500 lines or 4x-grep patterns (spec/645)
- Graphify knowledge-graph opt-in skill (`templates/skills/graphify/`) with file-count thresholds (spec/637)
- New flags: `--force-skip-graphify`, `--force-all-skills`, `--relax-context-caps`
- `doctor.sh` checks: skill stack-drift, context size violations, hook token caps, graphify binary, .claudeignore freshness, graph-before-read sanity
- `README.md` sections: Context Bundles, Skill Stack-Filter, Default MCPs, Turn-Token Budget, Context File Budget, Graph-First Navigation, Claude Ignore Patterns, Optional Knowledge Graph
- `rules/agents.md`: Effort Levels section for Opus 4.7 (`xhigh`/`max`, Pro/Max defaults)
- `hooks/README.md`: document new `type: "mcp_tool"` hook type (Claude Code v2.1.118)

### Changed
- `bin/ai-setup.sh` context install phase reordered: bundle install runs BEFORE LLM generation, `REGEN_CONTEXT=no` set when bundle installed (spec/638 ordering fix)
- `lib/generate.sh` CONTEXT_PROMPT respects `<!-- bundle: -->` marker, skips already-bundled files on regen; adds explicit line-count caps
- `lib/boilerplate.sh` + `lib/setup-skills.sh` honor skill stack-filter; `skipped` counter in summary
- `lib/plugins.sh` refactored: `_mcp_add_entry` helper, `install_mcp_suggestions` replaces `install_context7` for stack-aware MCP install
- `hooks/protect-files.sh` slimmed: `.env`, lockfiles, `.git/` are already blocked via `permissions.deny` — hook now only covers Vite `assets/` build-output check (no duplicate enforcement)
- `rules/mcp.md`: correct stale claim that project `.mcp.json` is empty (it pins `context7` for all contributors)

### Removed
- `n8n` and `mcp-server` stack profiles (not primary targets per stakeholder decision)
- `rules/terse-output.md` (opt-in rule, never referenced, dead weight)
- `.claude/plans/`: 3 stale random-name plan files (Claude Code v2.1.111 changed plan naming to prompt-based)

## [v2.2.0] — 2026-04-17

<!-- slack-announcement -->
:rocket: *@onedot/ai-setup v2.2.0*

*Was ist neu:*
:compass: *Claude Code native Alignment* — Setup folgt ab jetzt konsequent den neuen Claude Code Standards (2.1.89 bis 2.1.112). Viele eigene Hooks und Workarounds raus, Native Features rein.
:sparkles: *Features* — PreCompact-Hook preserviert Session-State vor AutoCompact (2.1.105+), Bash-Matcher mit `if`-condition reduziert Hook-Overhead ~70%, Lockfile Write-Protection schliesst Bypass via Write-Tool, Model-Upgrade auf `claude-opus-4-7`
:broom: *Cleanup* — 13 Skills + 4 Hooks + 2 Rule-Files entfernt, templates/claude/settings.json 1:1 mit lokalem Setup synchronisiert
:wrench: *Fixes* — spec-stop-guard aus PreCompact-Chain raus (blockte AutoCompact bei in-progress Specs, Codex-Review P1), disableSkillShellExecution-Warning in Template dokumentiert

*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

### Removed
- Skills: `/spec-run`, `/spec-run-all`, `/setup-optimize`, `/debug`, `/build-fix`, `/lint`, `/scan`, `/techdebt`, `/health`, `/update`, `/context-refresh`, `/context-load`, `/apply-learnings` — verschlankt auf 22 user-invokable slash commands
- Hooks: `memory-recall.sh`, `transcript-ingest.sh`, `notify.sh` — redundant seit claude-mem `SessionStart`-Hook Events konsumiert
- Rules: `terse-output.md` als Projekt-Rule entfernt (bleibt Global-Rule); hooks/README.md Referenzen auf entfernte `context-monitor.sh`, `file-index.sh`, `subagent-*`, `tdd-checker.sh`, `permission-denied-log.sh` bereinigt

### Added
- `precompact-guidance.sh` Hook via PreCompact Event — preserviert Session-Intent/Files/Decisions/NextSteps vor AutoCompact (Claude Code 2.1.105+)
- Lockfile Write-Protection: `Write(**/package-lock.json|yarn.lock|pnpm-lock.yaml|bun.lockb|composer.lock)` in `permissions.deny` — schließt Bypass via Write-Tool
- `Bash` matcher mit `if`-condition für `tool-redirect.sh` — reduziert Hook-Overhead ~70% durch conditional invocation (nur bei grep/find/cat/head/tail/git)
- `templates/CLAUDE.md`: `disableSkillShellExecution` Warning Section

### Changed
- Model-Upgrade auf `claude-opus-4-7` (production-ready seit 2.1.96)
- `.claude/rules/agents.md`: 82 → 31 Zeilen — TDD-Tutorials und Modell-Boilerplate entfernt, Kern-Dispatch-Regeln behalten
- `.claude/rules/testing.md`: 66 → 30 Zeilen — Standard-Test-Knowledge raus, nur noch projektspezifische Policies
- `settings.json` Hook-Config gestrippt: UserPromptSubmit 3 → 2 Hooks, Stop 2 → 1, Notification komplett entfernt
- `templates/claude/settings.json` 1:1-Sync mit lokaler `settings.json` — Hook-Registrierungen, permissions.deny, if-conditions identisch
- `README.md` + `WORKFLOW-GUIDE.md` + `hooks/README.md`: stale refs auf entfernte Commands/Hooks entfernt, Inventar synchronisiert
- `lib/update.sh` Cross-Project-Cleanup-Array um 9 Einträge erweitert; `precompact-guidance.sh` aus Orphan-Liste entfernt (jetzt registriert)

### Fixed
- PreCompact-Chain-Blocker: `spec-stop-guard.sh` aus `PreCompact`-Hook entfernt — verhinderte Auto-Compaction bei in-progress Specs via exit 2 (Codex-Review P1)

## [v2.1.3] — 2026-04-15

<!-- slack-announcement -->
:rocket: *@onedot/ai-setup v2.1.3*

*Was ist neu:*
:sparkles: *Features* — SUMMARY.md @-Import ersetzt context-loader.sh Hook (statisch gecacht, kein API-Call), `/health` Command ersetzt `/doctor`
:wrench: *Fixes* — spec-stop-guard matched nicht mehr README.md (numerischer Prefix-Guard), tool-redirect.sh blockt keine piped git Commands mehr, test-Suite erkennt Lock-Konflikte als SKIP
:gear: *Verbesserungen* — context-freshness warnt erst bei ≥5 Commits statt bei jedem Commit, Context7-Priorität in Web-Fetching-Regeln verstärkt

*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

- **Added**: `build-summary.sh` Generator — AUDIT/ARCH Frontmatter + CONCEPT.md + graph.json Top-Hubs → `.agents/context/SUMMARY.md` (max 50 Zeilen)
- **Added**: `@.agents/context/SUMMARY.md` @-Import in `CLAUDE.md` + `templates/CLAUDE.md` — statisch gecacht, kein SessionStart-Hook-API-Call
- **Added**: `context-refresh` Skill ruft `build-summary.sh` auf, `context-loader.sh` Hook entfernt
- **Added**: `/health` Command (umbenennung von `/doctor`), orphan cleanup für veraltete doctor-Dateien
- **Fixed**: `spec-stop-guard.sh` — numerischer Prefix-Guard verhindert false positives auf README.md und andere Nicht-Spec-Dateien
- **Fixed**: `tool-redirect.sh` — POSIX-Regex ersetzt Perl-Syntax, `.git/`-Pfade werden nicht mehr blockiert
- **Fixed**: `context-freshness.sh` — Commit-Counter statt Hash-Diff, Shallow-clone Guard, Threshold ≥5 Commits
- **Fixed**: `tests/claude-runtime.sh` — Skill-Probe wird als SKIP statt FAIL gewertet bei Lock-Konflikt (parallele claude-Session)

## [v2.1.2] — 2026-04-13

<!-- slack-announcement -->
:rocket: *@onedot/ai-setup v2.1.2*

*Was ist neu:*
:sparkles: *Features* — PreCompact Hook (Session-State-Preservation vor AutoCompact), Search-before-Read Navigationshierarchie (Glob/Grep → targeted Read → full-file Read), Skill Trigger Phrases in Frontmatter-Descriptions, Output Offloading Rule für große Agenten-Outputs
:wrench: *Fixes* — `spec-review-prep.sh` SPEC_BRANCH + STATUS Extraktion, `spec-validate-prep.sh` Step-Count-Schwelle, CLAUDE.md Model Routing Section, Migration 2.1.0 bricht bei fehlendem Agent-Template nicht mehr ab

*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

- **Fixed**: CLAUDE.md — Model Routing Section re-added (routing-check.sh erwartet sie)
- **Fixed**: `spec-review-prep.sh` — `SPEC_BRANCH` Extraktion korrigiert, `STATUS` Extraktion via sed repariert
- **Fixed**: `spec-validate-prep.sh` — Step-Count-Warning-Schwelle auf `>8` angepasst
- **Added**: PreCompact Hook — gibt strukturiertes `{"additionalContext": ...}` JSON aus, bewahrt Session Intent / Files / Decisions / Next Steps vor AutoCompact
- **Added**: Search-before-Read Regel in `agents.md` + `quality.md` — Glob/Grep zuerst, dann targeted Read, dann Full-file Read
- **Added**: Skill Trigger Phrases — kombiniert mit technischen Details in SKILL.template.md Descriptions
- **Added**: Output Offloading Rule in `agents.md` — Agenten-Outputs >2KB nach `$TMPDIR` schreiben

## [v2.1.1] — 2026-04-10

<!-- slack-announcement -->
:rocket: *@onedot/ai-setup v2.1.1*

*Was ist neu:*
:broom: *Cleanup* — 13 Monitoring-Hooks + 9 built-in Agents entfernt (durch Claude Code Builtins ersetzt), pause/resume Infrastruktur entfernt (superseded by claude-mem)
:sparkles: *Features* — `ci-prep.sh` mit Green-Path-Pattern, `shellcheck-guard` PreToolUse Hook, `quality-gate.sh` für lokale Bash-Validierung, MCP-Merge beim Update (context7 wird in bestehende `.mcp.json` gemergt)
:wrench: *Fixes* — Shell-Injection in `graph-context.sh` behoben, `memory-recall.sh` Cache-Expiry-Warning geht jetzt zu Claude (nicht nur Terminal), YAML-Frontmatter in AUDIT.md + PATTERNS.md
:gear: *Update* — `KNOWN_ORPHANS` deckt jetzt alle seit v2.0.x entfernten Hooks/Agents/Scripts ab

*Zahlen:* 11 Hooks | 8 Rules
*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

- **Removed**: pause/resume skills + session-state.json infrastructure (superseded by claude-mem cross-session memory)
- **Removed**: 13 monitoring/logging hooks (context-monitor, tdd-checker, file-index, mcp-health, cli-health, etc.) — replaced by Claude Code built-ins
- **Removed**: 9 custom agents (backend-developer, test-generator, verify-app, etc.) — replaced by Claude Code built-ins
- **Removed**: deprecated `delegate-codex.sh` and `delegate-gemini.sh` scripts (dead code)
- **Added**: `ci-prep.sh` — Green-path CI status check (zero tokens on all-pass)
- **Added**: `shellcheck-guard.sh` — PreToolUse advisory validation before shell script edits
- **Added**: `quality-gate.sh` — local bash validation (bash -n + shellcheck + smoke)
- **Fixed**: Shell injection vulnerability in `graph-context.sh` (unquoted variable expansion)
- **Fixed**: `memory-recall.sh` cache-expiry warning now outputs JSON to stdout (Claude sees it)
- **Fixed**: MCP merge-on-update — `install_context7` runs during `run_smart_update` to add context7 without overwriting existing servers
- **Fixed**: `KNOWN_ORPHANS` updated to cover all hooks/agents/scripts removed since v2.0.x
- **Improved**: YAML frontmatter added to `AUDIT.md` and `PATTERNS.md` for context-loader.sh

## [v2.1.0] — 2026-04-08

<!-- slack-announcement -->
:rocket: *@onedot/ai-setup v2.1.0*

*Was ist neu:*
:sparkles: *Features* — Graph-basiertes Kontext-System: `graph-context` PreToolUse Hook surfact Dependency-Nachbarn bei File-Zugriff, `build-graph.sh` generiert Dependency-Graph mit Nuxt + Auto-Import Support
:wrench: *Skills* — Neue Skills: `architectural-decisions` (ADR Auto-Trigger) und `pre-modification` (Risk Assessment), `/analyze` generiert jetzt `graph.json` Artefakt mit Graph-Statistiken
:gear: *CLI Tools* — Tool-Registry mit Smoke Tests (jq, gh, delta), RTK DB Auto-Init, delta als Standard-Git-Pager (60-90% Token-Ersparnis)
:books: *Docs* — Context7 als primäres Dokumentations-Tool dokumentiert (Library/API Docs), Tool-Hierarchie: Context7 → defuddle → WebFetch

*Zahlen:* 36 Skills | 11 Agents | 27 Hooks | 9 Rules
*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

- **Graph Context**: `graph-context.sh` PreToolUse Hook zeigt Dependency-Nachbarn (imports/importedBy) bei File-Zugriff, `build-graph.sh` Python-Script mit Nuxt `~` Alias und Auto-Import Support
- **Architectural Decisions Skill**: `architectural-decisions/` Template mit Auto-Trigger für ARCHITECTURE.md-Änderungen
- **Pre-Modification Skill**: `pre-modification/` Template für Risk Assessment vor File-Modifikation
- **CLI Tool Registry**: `lib/cli-tools.sh` mit generalisiertem Smoke-Test-System für 10+ Tools, RTK DB Auto-Init, `lib/global-settings.sh` mit delta als Git-Pager
- **Context7 Docs**: `general.md` und `CLAUDE.md` mit klarer Tool-Hierarchie für Dokumentations-Lookups
- **Analyze Skill**: Graph-Statistiken (top hubs, edge count) in `ARCHITECTURE.md` generiert, `graph.json` als Artefakt
- **Test Fix**: `claude-runtime.sh` Fixture renamed `SKILL.template.md` → `SKILL.md` für korrekte Claude-Skill-Invocation im Test-Sandbox
- **Specs**: Research-Specs 624 (CocoIndex), 625 (Repowise), 626 (Graphify) — Implementation-Specs 627 (ADR Skill), 628 (Pre-Modification Skill), 629 (Dependency Graph)

## [v2.0.9] — 2026-04-07

<!-- slack-announcement -->
:rocket: *@onedot/ai-setup v2.0.9*

*Was ist neu:*
:sparkles: *Skills* — Multi-File Skills mit `references/*.md` Support, Frontmatter normalisiert ohne `ais:` Prefix
:wrench: *Hooks* — memory-recall.sh aktiviert, alle 27 Hooks jetzt executable, protect-and-breaker.sh entfernt
:gear: *Routing* — Sonnet als Default für Implementation Subagents, Haiku-never-for-implementation Regel, Spawn-Threshold ≥3 tool calls
:shield: *Tests* — smoke.sh TMPDIR-safe (Sandbox-kompatibel), 392 passed / 0 failed

*Zahlen:* 34 Skills | 11 Agents | 27 Hooks | 9 Rules
*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

- **Spec 628**: Skill Progressive Disclosure — multi-file skill support with `references/*.md` (install, update, orphan cleanup), analyze skill split into SKILL.md + 2 reference files, `scripts/skill-lint.sh` for template validation (30/30 pass), doctor.sh `name:` field check
- **Spec 627**: Skill Frontmatter Normalization — removed `ais:` prefix from all 30 skill templates, trimmed descriptions, added `effort:`, `disable-model-invocation:`, and `argument-hint:` fields where applicable
- **Spec 626**: Hook System Drift Fix — activated tool-redirect.sh (WebFetch→defuddle), added file-index.sh + session-length.sh to hook docs, documented 3 template-only hooks with rationale, corrected README.md hook count (25→23) and names
- **Spec 619**: Claude Code 2.1.89+ Alignment — tdd-checker absolute path fix, permission-denied retry logic, TaskCreated hook, disableSkillShellExecution warning
- **Hook Cleanup**: memory-recall.sh registered under UserPromptSubmit, protect-and-breaker.sh removed, all hooks chmod +x
- **Routing Rules**: Concrete spawn threshold (≥3 tool calls), Sonnet default for implementation subagents, Haiku never for implementation
- **Test Hardening**: smoke.sh mktemp uses TMPDIR for sandbox compatibility

## [v2.0.8] — 2026-04-03

<!-- slack-announcement -->
:rocket: *@onedot/ai-setup v2.0.8*

*Was ist neu:*
:sparkles: *Skills* — Workflow-Hints in allen 35 Skills, `model:` Frontmatter für explizites Model-Routing — kein teures Opus-Erbe mehr
:wrench: *Neue Tools* — `subagent-start.sh` / `subagent-stop.sh` — strukturiertes Subagent-Logging mit Dauer und Token-Tracking
:zap: *Token-Optimierung* — `model:` in jedem Skill-Spawn gesetzt — verhindert ungewollte Opus-Vererbung (bis zu 5x Kosteneinsparung)
:gear: *CLI Tools* — Auto-Update bei jedem Setup-Run, Doctor erkennt veraltete Packages
:shield: *Hooks* — 21 aktive Hooks (Circuit-Breaker, Permission-Log, Context-Reinforcement, MCP-Health, CLI-Health u.a.)
:page_facing_up: *Docs* — Hook-Zahl von 11 → 25 korrigiert, Template-Parity durchgesetzt

*Zahlen:* 35 Skills | 11 Agents | 25 Hooks | 9 Rules
*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

### Skills & Workflow Hints
- **Skills**: `## Next Step` Hints in allen 35 deployed Skills — Nutzer weiß immer was nach `/spec-work`, `/commit`, `/review` etc. kommt
- **Model Routing**: Explizites `model:` Frontmatter in allen Skills (haiku/sonnet/opus) — kein teures Opus-Erbe bei Skill-Spawns
- **Template Parity**: `templates/skills/spec/SKILL.md` auf Stand des deployed Skills gebracht (Code-Flow-Analyse, Step-Dedup-Check)

### Neue Hooks & Infrastruktur
- **`subagent-start.sh`** + **`subagent-stop.sh`** — strukturiertes Logging aller Subagent-Starts mit Model, Typ und Dauer
- **`permission-denied-log.sh`** — loggt alle Sandbox-Denials zur Analyse
- **Hook-Konsolidierung**: 21 aktive Hooks in deployed Setup, 25 in Templates (inkl. circuit-breaker, context-reinforcement, mcp-health, cli-health, tool-redirect)
- **`tests/claude-runtime.sh`** — Runtime-Validation für Claude Code Hooks und Settings

### CLI Tools
- **Auto-Update**: `lib/setup.sh` prüft und aktualisiert externe CLI-Tools (rtk, defuddle, claude) bei jedem Setup-Run
- **Doctor**: Version-Freshness-Check für CLI-Tools — warnt bei veralteten Packages

### Fixes
- **fix(spec-validate-prep)**: Octal-Interpretation von 3-stelligen Spec-IDs verhindert
- **refactor**: 8 Hook- und Governance-Specs mit defensiven Implementierungen abgeschlossen

## [v2.0.7] — 2026-03-31

<!-- slack-announcement -->
:package: *@onedot/ai-setup v2.0.7*

*Was ist neu:*
:brain: *Routing* — Haiku nur für dedizierte Explore-Agents, Sonnet Default für alle Implementierungs-Subagents. Kein Qualitätsverlust durch Downgrade.
:zap: *Delegation* — Spawn-Threshold ≥3 Tool-Calls+Write → Agent, bei ≥8 gemachten Calls Delegation prüfen, bei >30 ohne Subagents Re-check.
:shield: *Routing Guard* — `tests/routing-check.sh` mit 13 Assertions prüft Routing-Konsistenz vor jedem Commit und Release automatisch.
:gear: *Setup* — Opus als Session-Default, bash-defensive-patterns 88% schlanker, spec-validate-prep sucht in specs/completed/
:sparkles: *Session Metrics* — session-extract.sh trennt aktive Arbeitszeit von Idle-Zeit
:shield: *Quality Hooks* — TDD-Checker warnt bei Code ohne Tests, Stop-Guard blockt bei aktiver Spec, Auto-Compact sichert Spec-State
:page_facing_up: *Rules* — testing.md mit TDD-Zyklus + Anti-Patterns, quality.md mit Debugging-Patterns, code-review-reception.md neu

*Zahlen:* 35 Skills | 11 Agents | 15 Hooks | 9 Rules
*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

### Routing & Delegation
- **Routing**: Haiku auf dedizierte Explore-Agents beschränkt — kein Downgrade bei Implementierungs-Subagents, Sonnet bleibt Standard für spec-work medium
- **Delegation**: Spawn-Threshold ≥3 tool calls + write, Eskalation bei 8 Tool-Calls, Re-check bei >30 ohne Subagents
- **Spec 601**: Routing-Regeln in CLAUDE.md, agents.md, spec-work dokumentiert und durch Smoke-Tests gesichert

### Spec Implementations
- **Spec 602**: Routing Consistency Check Script — `tests/routing-check.sh` mit 13 Assertions, Pre-commit Hook blockiert Commits bei Widersprüchen
- **Spec 600**: Session Extract Active Duration — session-extract.sh trennt aktive Arbeitszeit von Idle-Zeit
- **Spec 599**: Sandbox-Safe Global Side Effects — best-effort writes, kein Abbruch bei LOCKED_HOME
- **Spec 598**: Setup Consistency Hardening — unsupported Flags schlagen fehl, jq-optional JSON-Fallback
- **Spec 597**: bash-defensive-patterns/SKILL.md trimmen — 533 → 64 Zeilen (88% Reduktion), ~2.400 Token gespart pro Trigger

### Quality Enforcement (pilot-shell Research)
- **Spec 605**: TDD Enforcement Hook — `tdd-checker.sh` warnt bei Code-Edits ohne passende Testdatei (Py/TS/JS/Go), non-blocking
- **Spec 606**: Spec Stop Guard — `spec-stop-guard.sh` blockt Stop bei aktiver Spec, 60s Cooldown verhindert Loops
- **Spec 607**: Auto Compact State — `pre-compact-state.sh` + `post-compact-restore.sh` sichern Spec-State automatisch ueber Compaction
- **Hook**: `tool-redirect.sh` — WebFetch→defuddle Redirect wenn verfuegbar (~80% Token-Savings)
- **Rule**: `testing.md` — TDD-Zyklus (RED→VERIFY→GREEN→VERIFY→REFACTOR), Mock-Audit, Anti-Patterns, Zero-Tolerance
- **Rule**: `quality.md` — Debugging-Sektion (Revert-First, Ghost Constraints, systematische Phasen)
- **Rule**: `code-review-reception.md` — strukturiertes Review-Feedback-Handling (neu)
- **Decision D4**: Hook > Regel — kritisches Verhalten wird per Hook erzwungen, nicht nur empfohlen

### Fixes
- **Opus als Session-Default** — `claude-opus-4-6` zurück in settings.json; Sonnet bleibt Default für Subagents
- **agents.md**: Selbstwiderspruch "Haiku is the default" behoben
- **Template-Skills**: `name:` Frontmatter-Feld in 19 Skills ergänzt

## [v2.0.6] — 2026-03-28

<!-- slack-announcement -->
:package: *@onedot/ai-setup v2.0.6*

*Was ist neu:*
:sparkles: *Skills* — `/spec-run`, `/spec-run-all` — Full Pipeline-Skills jetzt in Templates, erscheinen im `/`-Autocomplete
:brain: *Context* — System-aware Bash Scanners fuer Nuxt, Laravel, Shopware, Storyblok + `sections:` im Scanner-Frontmatter
:zap: *SessionStart* — `file-index.sh` Hook: Zero-Grep File Discovery beim Session-Start
:gear: *Verbesserungen* — Update auto-overwrite ohne Prompt, Repomix-Orphan-Cleanup, context-freshness Hook

*Zahlen:* 35 Skills | 12 Agents | 11 Hooks
*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

### Skills

- **`/spec-run` + `/spec-run-all` in Templates** — Fehlten bisher in `templates/skills/`, damit unsichtbar im Slash-Autocomplete anderer Projekte. Beide jetzt eingepflegt.
- **`/spec-run` + `/spec-run-all` in WORKFLOW-GUIDE + README** — Skills dokumentiert, Count 32 → 35.
- **`/context-refresh` in README** — Bisher undokumentiert trotz Template-Skill.

### Context-Scanner

- **System-aware Scanners** — Nuxt, Laravel, Shopware, Storyblok Bash-Scanner fuer L0-Context-Abstracts (Spec 596).
- **`sections:` Frontmatter** — Scanner koennen L0-Sections deklarieren; Glob-basierter Context-Loader fuer generische Stack-Erkennung.
- **Shopify-Scanner** — System-aware Shopify Scanner + Glob Context-Loader.

### Hooks & Update

- **`file-index.sh` SessionStart Hook** — Indiziert Dateien beim Session-Start fuer Zero-Grep File Discovery.
- **Update auto-overwrite** — `update.sh` ueberschreibt user-modifizierte Dateien ohne interaktiven Prompt.
- **Repomix-Orphan-Cleanup** — Veraltete Repomix-Dateien werden bei jedem Update entfernt.

## [v2.0.5] — 2026-03-27

<!-- slack-announcement -->
:package: *@onedot/ai-setup v2.0.5*

*Was ist neu:*
:sparkles: *Skills* — `/spec-run` — Unified Pipeline: validate, implement, review, commit in einem Befehl mit Self-healing
:gear: *Spec-Qualitaet* — `/spec` macht jetzt Code-Flow-Analyse vor Step-Generierung, verhindert redundante Steps
:zap: *Token-Optimierung* — 3 Commands opus zu sonnet, `/reflect` migriert, Release-Duplikat entfernt
:wrench: *Hooks* — 16 zu 11 konsolidiert, protect-and-breaker gemerged

*Zahlen:* 22 Commands | 12 Agents | 11 Hooks | 19 Skills
*Update:* `npx github:onedot-digital-crew/npx-ai-setup`
<!-- /slack-announcement -->

### Spec-Workflow verbessert

- **`/spec-run` Skill** — Neuer unified Pipeline-Skill: validate → implement → review → commit in einem Befehl. Self-healing bei Grade C und CHANGES REQUESTED, automatischer Retry mit konfigurierbaren Limits.
- **Code-Flow-Analyse in `/spec`** — Specs analysieren jetzt Laufzeit-Logik (Guards, Conditions, Variables) bevor Steps generiert werden. Verhindert redundante Steps und übersehene Guard-Logik (Spec 595).
- **Review-Gate vor Commits** — `/spec-work` committet nicht mehr pro Step. Stattdessen: implementieren → `/spec-review` → `/commit`. Verhindert unreviewed Code im Repo.

### Boilerplate Auto-Sync

- **`detect_installed_system()` + `sync_boilerplate()`** — Bei `npx ai-setup` Updates wird das installierte Boilerplate-System erkannt und automatisch nachsynchronisiert (Spec 594).

### Kostenoptimierung

- **3 Commands opus → sonnet** — `/discover`, `/research`, `/review` liefen unnötig auf Opus. Sonnet reicht für Code-Reading und Pattern-Matching.
- **`/reflect` migriert** — Von altem Command-Format (opus) zu Skills-Format (sonnet). Spart pro Aufruf ~5x Kosten.
- **Release-Duplikat entfernt** — Command war reiner Delegator zum Skill (~48 Zeilen Token-Overhead pro Session weg).

### Hooks konsolidiert

- **16 → 11 Hooks** — 6 redundante Hooks entfernt, `protect-files` + `circuit-breaker` zu `protect-and-breaker` gemerged. API timeout guards für transcript-ingest.

## [v2.0.4] — 2026-03-27

### Subagent-Architektur optimiert

**Globale Agents.** Universelle Agents (code-reviewer, security-reviewer, etc.) werden jetzt nach `~/.claude/agents/` installiert — verfügbar in allen Projekten ohne Projekt-Setup. Stack-spezifische Agents (liquid-linter, shopware-reviewer, storyblok-reviewer) kommen aus den Boilerplate-Repos.

**Neuer Agent: backend-developer.** Konditionell deployed bei Node.js/Nuxt-Projekten. Fokus: API-Routes, Server-Middleware, Third-Party-Integrationen (Shopify, Storyblok, Klaviyo), Error Handling und Rate Limiting.

**Skills dispatchen jetzt Agents.** `/review` spawnt code-reviewer + security-reviewer + performance-reviewer. `/test` spawnt test-generator bei Coverage-Lücken. `/scan` spawnt security-reviewer bei CRITICAL/HIGH. `/spec-work` dispatcht konditionell security-reviewer, performance-reviewer, test-generator, frontend-developer und backend-developer.

**Model-Routing korrigiert.** verify-app von Sonnet auf Haiku (führt Commands aus, kein Code-Verständnis nötig). perf-reviewer umbenannt zu performance-reviewer.

### Fixes

- Smoke test crash bei Specs mit non-standard Status-Feldern
- Template sync nach Migrations bei minor/patch Updates
- Operator precedence in Shell Conditionals
- Lint output suppression

### Sonstiges

- WORKFLOW-GUIDE ins Projekt-Root verschoben mit vollständiger Skill-Referenz
- Boilerplate-Pull erweitert: fetcht jetzt auch `.claude/agents/*.md` aus Stack-Repos

## [v2.0.3] — 2026-03-26

### Was ist neu für dich

**Alle Skills jetzt automatisch erkennbar.**
33 von 33 Template-Skills haben jetzt eine `description` im Frontmatter. Claude Code erkennt dadurch den passenden Skill automatisch, ohne den gesamten Skill-Body lesen zu müssen. Vorher fehlte die Description bei 20 Skills.

**Model-Routing direkt im Projekt.**
Neue Projekte bekommen über `templates/CLAUDE.md` eine Haiku/Sonnet/Opus-Routing-Tabelle. Subagents laufen damit von Anfang an auf dem richtigen Modell — kein manuelles Nachkonfigurieren nötig.

**spec-work um 62% schlanker.**
Der meistgenutzte Skill (`/spec-work`) ist von 11.5KB auf 4.4KB getrimmt — spart ~1.400 Tokens pro Aufruf bei gleichem Verhalten.

**Statusline zeigt mehr Kontext.**
Specs-Count, ai-setup-Version und Kalenderwochen-Datum direkt in der Claude Code Statusline sichtbar.

### Technische Details

- All 33 template skills now have `description:` frontmatter for Claude Code skill discovery
- `templates/CLAUDE.md`: Model Routing section added (Haiku for search/explore, Sonnet for implementation, Opus for architecture)
- `spec-work/SKILL.md`: 141 → 81 lines, 11.5KB → 4.4KB — removed debugging discipline, condensed Haiku Investigator, trimmed stall detection
- Statusline: specs count via `ls specs/*.md`, ai-setup version from `.ai-setup.json`, weekly date in English format
- `findings-log.md`: deduplication pre-filter prevents session-optimize from re-reporting addressed findings
- `session-extract.sh`: progress message and Agent-tool-call fallback for accurate subagent counts

**Update:** `npx github:onedot-digital-crew/npx-ai-setup`

## [v2.0.2] — 2026-03-25

### Was ist neu für dich

**Learnings fließen jetzt automatisch an den richtigen Ort.**
`/apply-learnings` liest offene Einträge aus `LEARNINGS.md` und schreibt sie direkt in `CLAUDE.md`, `ARCHITECTURE.md` oder `CONVENTIONS.md` — kein manuelles Kopieren mehr. Einträge werden als `applied` markiert, damit nichts doppelt landet.

**Clean Reinstall mit einem Klick.**
Das Update-Menü hat jetzt eine "Reset"-Option: entfernt alle installierten Dateien und installiert frisch. Nützlich wenn sich das Setup in einen inkonsistenten Zustand manövriert hat.

**Günstigere Kosten durch konsequentes Haiku-Routing.**
Alle Explore-, Discover- und Research-Agents laufen jetzt auf Haiku (war: Sonnet/Opus). `reflect` und `review` nutzen Sonnet statt Opus. Spart 12-60x Kosten je nach Task — ohne Qualitätsverlust.

**yolo mit Sicherheitsnetz.**
`/yolo` unterstützt jetzt `--max-budget-usd` und `--max-turns` als Kostenbremse. Stall-Detection stoppt bei hängenden Loops. Gut für unbeaufsichtigte Runs.

**CI-freundliche Autonomie-Doku.**
`CLAUDE.md` Template dokumentiert jetzt Permission Modes (`--bare`, `bypassPermissions`, `acceptEdits`) — hilfreich wenn Claude in CI-Pipelines läuft.

**Spec Commands laufen jetzt als Skills.**
`/spec-board`, `/spec-work`, `/spec-done` sind auf den Claude Code 2.x Skills-Standard migriert — keine separaten Command-Dateien mehr, alles einheitlich.

**session-optimize deutlich präziser.**
Der Skill nutzt jetzt JSONL-Metriken statt nur MCP-Suche, erkennt veraltete Spec-Statuses automatisch und schlägt Korrekturen vor.

**Schlankeres CLAUDE.md Template.**
Von 89 auf 20 Zeilen getrimmt — jedes neue Projekt startet mit deutlich weniger Token-Overhead pro Session.

**Skills zeigen Tips als Callouts.**
Hinweise und Next-Steps in Skills erscheinen jetzt als farbige `tui_hint`-Blöcke statt als Plaintext — besser lesbar, weniger Rauschen.

**Saubere Updates ohne Altlasten.**
Orphan-Dateien aus älteren Versionen werden beim Update automatisch erkannt und entfernt. Context-Staleness-Detection greift zuverlässiger an.

### Technische Details

**Spec 586** — Smart Merge bei ai-setup-Updates: `_smart_merge_file` in `lib/setup.sh` ruft `claude -p --model claude-haiku-4-5` auf wenn user-modifizierte .md-Dateien einen Template-Update haben. Lokale Additions überleben, Template-Neuheiten landen trotzdem. Fallback auf Skip wenn `claude` nicht im PATH.

**Spec 585** — `/apply-learnings` Skill: LEARNINGS.md als Transit-Log, Kategorie-Mapping auf Zieldateien (Process/CLI → CLAUDE.md, Architecture → ARCHITECTURE.md), Applied-Section mit Timestamp-Tracking, reflect Skill verlinkt auf apply-learnings als Next Step, skill in `templates/skills/` für Neuinstallationen verfügbar.

**Spec 582** — CLAUDE.md Template: `--bare` CI-Empfehlung ergänzt, Budget/Turn-Controls dokumentiert, neue "Permission Modes" Section (~80 Tokens), Autonomie-Flags mit Beispielen.

**Spec 581** — yolo Safety Guards: `--max-budget-usd`, `--max-turns`, Stall-Detection nach 3 identischen Tool-Calls dokumentiert. Skill nutzt jetzt model-Override und todo-Loop.

**Spec 579** — Model Routing: `reflect` und `review` von `model: opus` → `model: sonnet`. `review` Mode C (Adversarial) bleibt als optionaler Opus-Aufruf dokumentiert.

**Spec 578** — Haiku-Routing: `model: haiku` explizit in discover/research/spec-review Skills, agents.md erweitert um "No default means Sonnet — always be explicit".

**Spec 577** — templates/CLAUDE.md: leere Sektionen `## Commands` und `## Critical Rules` entfernt (~120 Token/Session gespart).

**Spec 576** — Spec-Commands in Skills konsolidiert: `spec-board`, `spec-work`, `spec-done` als Skills statt Commands — Claude Code 2.x Unified Standard.

**Spec 575** — Token Optimization: `specs/`, `templates/`, `CHANGELOG.md`, `.claude/*.log` in `.claudeignore` (~236K Token-Risiko geschlossen). orchestrate-Skill-Description auf ≤200 Zeichen getrimmt.

**Spec 583** — spec-review Agents auf Sonnet umgestellt (war Opus/Sonnet gemischt), spart ~5x pro Review-Run.

**Infra**
- verify-app Agent auf Haiku umgestellt
- CLAUDE.md Template von 89 → 20 Zeilen getrimmt (größtes Token-Saving im Template)
- 4 separate quality rules → 1 konsolidierte `quality.md`
- Playwright komplett aus Setup entfernt
- Dead plugin stubs + nicht mehr genutzte default plugins bereinigt
- Diff-basiertes Orphan-Cleanup nach Installs
- Context-Staleness-Detection verbessert
- `tui_hint` Callout-System für Tips und Next-Step-Hints
- session-optimize Skill mit JSONL-Metriken + `session-extract.sh`
- agent-browser Skill-Description getrimmt

**Update:** `npx github:onedot-digital-crew/npx-ai-setup`

## [v2.0.1] — 2026-03-23

### New Features
- **L0/L1/L2 Tiered Context Loading** — SessionStart injects only abstracts (~400 tokens vs ~2000). Full context on demand via `/context-load`. YAML frontmatter in `.agents/context/` files.
- **Transcript Auto-Ingestion** — Stop hook extracts learnings from sessions via haiku summarization. Supports claude-mem MCP with fallback to `.agents/memory/`. Memory limits: 50 files, 200KB max.
- **Memory-Recall Injection** — UserPromptSubmit hook searches relevant memories and injects as context. Keyword-based grep with 500-token budget. claude-mem → auto-memory → skip fallback chain.
- **`/yolo` Autonomous Mode** — Execute tasks without confirmation gates, auto-commit after each logical unit.

### Improvements
- **Spec 169**: Slash command consolidation — `/evaluate` renamed to `/research`, `/spec` Phase 1 streamlined with Quick Triage gate, `/challenge` sharpened with When to Use/When NOT to Use
- `/reflect` now writes to dedicated `.agents/context/LEARNINGS.md` with smart merge (ADD/UPDATE/REMOVE)
- Merge `project-audit` into `/analyze` — writes `PATTERNS.md` + `AUDIT.md`, `--audit` flag removed
- Replace framework selection menu with auto-detection (Nuxt, Next.js, Shopify)
- Stack-aware sandbox permissions — auto-removes framework-specific deny entries

### Bug Fixes
- Fix TUI file links (GitHub URLs → file:// → hardcoded repo URL)
- Default to "Update" instead of "Skip" in update menu
- Remove duplicate Reference output after update

## [v2.0.0] — 2026-03-22

### Highlights

🚀 **Pure Generic Base Layer** — System-spezifischer Code entfernt. ai-setup ist jetzt ein reiner generischer Base Layer. Shopify, Nuxt, Shopware etc. kommen via [Boilerplate Pull](https://github.com/onedot-digital-crew/npx-ai-setup#installation-flags).

🔧 **Neue Tools**
- `/ci` — CI-Status checken via `gh pr checks` / `gh run list`
- `/explore` — Read-only Denkpartner: Ideen durchspielen, Tradeoffs aufzeigen, Codebase erkunden
- `/lint` — Linter ausfuehren, Findings gruppiert, Auto-Fix mit `--fix`
- `/orchestrate` — Tasks an [Gemini CLI](https://github.com/google-gemini/gemini-cli) oder [Codex CLI](https://github.com/openai/codex) delegieren

🧠 **Agents & Skills**
- Alle 12 Agents mit [YAML-Frontmatter](https://docs.anthropic.com/en/docs/claude-code/sub-agents) — maschinenlesbares Routing
- `project-auditor` Agent — analysiert Codebase, erstellt PATTERNS.md + AUDIT.md
- `agent-browser`, `gh-cli` Skills jetzt Standard bei jeder Installation
- Skill-Installation vereinfacht: 3 globale Skills statt keyword-basiertes Mapping

⚡ **Token-Optimierung**
- 4 Prep-Scripts (build, lint, pr, changelog) — null Tokens auf Green Paths
- [RTK](https://github.com/rtk-ai/rtk) wird automatisch bei Setup aktiviert (60-90% CLI-Output-Ersparnis)
- CLI-Health Hook prueft Tool-Verfuegbarkeit beim Session-Start

🛡️ **Quality & Verification**
- 4 Quality Rules ([general](templates/claude/rules/quality-general.md), [security](templates/claude/rules/quality-security.md), [performance](templates/claude/rules/quality-performance.md), [maintainability](templates/claude/rules/quality-maintainability.md))
- Strukturierte 3-Check Verification in `/spec-review`
- WHEN/THEN Szenarien in Spec Acceptance Criteria

📦 **Zahlen:** 27 Commands | 12 Agents | 14 Hooks | 12 Skills | 9 Rules

📖 **Workflow-Guide:** `.claude/WORKFLOW-GUIDE.md` — Komplette Referenz

**Update:** `npx github:onedot-digital-crew/npx-ai-setup`

---

### New Features (post-initial)
- **Spec 156**: Prep-script expansion — 4 new prep scripts (build, lint, pr, changelog) with zero-token green paths, wired into build-fix/lint/pr/release skills
- **Spec 157**: Token optimization strategy — RTK activation in setup, shared prep-lib.sh, green-path hardening, CLI health check hook, developer guide
- **Spec 159**: Gemini & Codex minimal integration — optional config templates, skills symlinks, and AGENTS.md as multi-tool workflow router
- **Spec 160**: Smart skill installation — reduced to 3 global skills (agent-browser, find-skills, gh-cli), removed keyword-based mapping, extracted skills into own setup step, cleaned up dead code
- **Spec 162**: Read-only `/explore` skill — thinking partner for exploring problem spaces before committing to specs
- **Spec 163**: Structured verification in `/spec-review` — 3-check mechanical verification
- **Spec 164**: WHEN/THEN scenarios in spec acceptance criteria
- `/ci` command — check CI status via `gh pr checks` / `gh run list`
- `/orchestrate` skill — delegate tasks to Gemini CLI or Codex CLI
- `/project-audit` skill — analyze codebase, produce PATTERNS.md and AUDIT.md
- Agent-browser, gh-cli skills promoted to standard installation
- 4 quality rules added (`quality-general`, `quality-security`, `quality-performance`, `quality-maintainability`)
- Major TUI library expansion with interactive prompts
- All 12 agent templates updated with YAML frontmatter
- 14 hooks (added `cli-health` for CLI tool availability checks)
- Context docs refreshed (STACK.md, ARCHITECTURE.md, CONVENTIONS.md)

### Breaking Changes
- **Spec 115**: Remove all system-specific code — ai-setup is now a pure generic base layer (system config via boilerplate pull)
- **Spec 151**: Remove repomix completely — snapshot/config/install flow removed, Claude Code native tools replace it
- **Spec 150**: Curated-only skill installation — removed network discovery (search, popularity scraping, Haiku ranking), ~260 lines deleted

### New Features
- **Spec 134**: Versioned migration system — incremental updates via `lib/migrations/*.sh` instead of template overwrite
- **Spec 135**: Boilerplate pull via gh CLI — fresh installs can pull system config from canonical boilerplate repos
- **Spec 137**: Security reviewer agent — OWASP Top 10 checklist, 12 pattern table, false positives section
- **Spec 138**: Code reviewer confidence upgrade — >80% confidence filtering, AI-generated code checks
- **Spec 138**: Context monitor hook — PostToolUse hook warns at ≤35% (WARNING) and ≤25% (CRITICAL) context remaining
- **Spec 139**: Assumptions surfacing in /spec — structured assumptions step with Evidence/Confidence/If-Wrong
- **Spec 139**: Build-fix command — incremental fix loop with guard rails (max 10 iterations, max 5% change)
- **Spec 140**: YAML frontmatter migration — all 12 agents have machine-readable frontmatter
- **Spec 140**: Pause/resume commands — structured session handoff via `.continue-here.md`
- **Spec 141**: Agent-browser promoted to required npm tool with auto Chrome install
- **Spec 144**: Finishing gate in spec-review — 4-option AskUserQuestion after APPROVED verdict

### Improvements
- **Spec 154**: Compact setup installers — `_install_template_dir()` helper reduces duplication in setup.sh
- **Spec 155**: Script source of truth — parity checks enforce templates/scripts/ as canonical source
- Context monitor hook optimized (single-pass jq, read instead of head/tail)
- bash 3.2 compatibility fix (declare -A replaced with case function)

### Previous (pre-2.0.0)
- **Spec 130**: Docs sync — updated README (counts, tables, hooks), WORKFLOW-GUIDE (commands, agents, hooks), CHANGELOG (specs 108–128)
- **Spec 129**: Lean review flow with complexity gate — removed 10-metric scoring from spec-review, added staff-reviewer for high-complexity specs
- **Spec 128**: Global developer workstation setup — `npx @onedot/ai-setup-global` installs CLI tools, global Claude settings, and API key checks
- **Spec 127**: Pre-release validation script — `scripts/validate-release.sh` checks version, CHANGELOG, template integrity before release
- **Spec 126**: Validate no hardcoded paths — CI script to detect hardcoded user paths in templates
- **Spec 125**: Stall Detection for /spec-work — adds per-step retry limit (>3 retries → blocked), consecutive no-change detection (2 steps without git diff → user prompt), and completion stats summary
- **Spec 124**: Quality principles as reusable rule templates — 4 new files in `templates/claude/rules/quality-*.md` (general, security, performance, maintainability)
- **Spec 123**: Frontend-developer agent template — React, Vue, Nuxt, Next.js specialist subagent
- **Spec 122**: Agent routing metadata — added `When to Use` and `Avoid If` sections to all 11 agent templates
- **Spec 121**: Context reinforcement hook — SessionStart hook reloads context after compaction
- **Spec 120**: Rename /bug to /debug — hypothesis-first methodology with structured investigation flow
- **Spec 119**: Merge /review + /grill — single `/review` command with selectable intensity (Quick Scan / Standard / Adversarial Grill)
- **Spec 118**: Review-prep scripts — `review-prep.sh` and `spec-validate-prep.sh` for zero-token data collection
- **Spec 117**: Hybrid script commands — `scan-prep.sh`, `commit-prep.sh`, `test-prep.sh` for script-assisted commands
- **Spec 116**: Pure script commands — `spec-board`, `doctor`, `release` delegate to shell scripts
- **Spec 115**: Boilerplate-first architecture with release migrations
- **Spec 114**: CONCEPT.md — project concept and design philosophy document
- **Spec 112**: Numeric quality scoring for /spec-validate — weighted 0-10 criteria replacing PASS/FAIL
- **Spec 109**: Stakeholder perspectives in /challenge — Phase 6b adds multi-perspective evaluation
- **Spec 108**: /discover command — reverse-engineers draft specs from existing codebases for legacy onboarding
- **Spec 080**: System plugin architecture — extracted system-specific code into `lib/systems/*.sh` (shopware, shopify, nuxt, next, laravel, storyblok) with loader pattern and plugin interface
- **Spec 111**: Split large lib modules — extracted shopware.sh (269 LOC), setup-skills.sh (335 LOC), setup-compat.sh (276 LOC) from generate.sh and setup.sh for better maintainability
- **Spec 110**: Draft-First Interview Mode — `/spec` now detects file-path arguments and enters an exhaustive AskUserQuestion interview loop to refine existing draft specs before writing them back
- **Spec 081**: /scan command — security vulnerability scanner that detects snyk/npm audit/pip-audit/bundler-audit and reports findings grouped by CRITICAL/HIGH/MEDIUM/LOW severity

## [v1.3.5] — 2026-03-16

- **Spec 107**: SessionStart head-truncation — `cat` → `head -20` for STACK.md/CONVENTIONS.md injection, saves ~60-70% tokens per session
- **Spec 106**: Aggressive .claudeignore — 54 patterns covering builds, caches, maps, binaries, locks + system-specific additions (Shopware, Nuxt, Next, Laravel); idempotent merge on re-runs
- **Spec 105**: Monorepo auto-discovery — detects npm/yarn/pnpm workspaces + lerna.json; auto-generates repo-group.json; non-monorepo projects unaffected
- **Spec 104**: Repomix system-specific ignore — generates .repomixignore with base + SYSTEM patterns before snapshot; reduces snapshot size for large frameworks
- **Spec 103**: jq-to-Node fallback — `lib/json.sh` wrapper provides `_json_read`, `_json_valid`, `_json_merge`; jq now optional (Node.js fallback); 5+ call sites migrated
- **Spec 102**: code-reviewer numeric confidence — findings include score `[HIGH:92]`; items below 80 suppressed; FAIL/CONCERNS/PASS thresholds updated
- **Spec 101**: commit-commands added to official plugins — installs /commit, /commit-push-pr, /clean_gone on setup
- **Spec 098**: Project onboarding audit — `--audit` flag + `/project-audit` skill; agent produces PATTERNS.md and AUDIT.md from efficient codebase read; asks before creating specs
- **Spec 100**: gitignore team boundary — documents team-vs-local split; PATTERNS.md/AUDIT.md listed in CLAUDE.md and WORKFLOW-GUIDE as team-committed context
- **Spec 099**: Circuit breaker batch detection — raises BLOCK to 40 / WARN to 25 when ≥2 specs are in-progress simultaneously (spec-work-all scenario)
- **Spec 079**: Storyblok dump auto-install — copies storyblok-dump.ts to Storyblok projects and adds npm script; enables token-efficient MCP workflows via local story cache
- **Spec 096**: Snapshot freshness detection — hook warns [SNAPSHOT STALE] when repomix snapshot is older than 7 days; writes SNAPSHOT_AT/SNAPSHOT_HASH to .state
- **Spec 097**: Skill search caching — skips curl + Claude ranking on re-runs when package.json + STACK.md unchanged; --force-skills flag bypasses cache
- **Spec 095**: repomix XML output — switches snapshot format to XML with comment/whitespace stripping for ~15-20% token reduction; all 4 locations updated consistently
- **Spec 078**: WORKFLOW-GUIDE Local API Dumps section — documents the dump→read→targeted-MCP pattern for token-efficient CMS/API workflows (Storyblok example)

## [1.3.4] — 2026-03-15
- **Spec 094**: Circuit Breaker spec-aware — raises block threshold (8→20) when a spec is in-progress; prevents false positives during planned migrations

## [1.3.3] — 2026-03-15
- **Spec 093**: Fast --patch flag — sync specific template files without full update flow (e.g. `--patch spec-work`)
- **Spec 092**: spec-work low complexity executes directly — no subagent overhead for simple specs; subagents only for medium (Sonnet) and high (Opus)
- **Spec 091**: Complexity-based Model Routing in spec-work — Haiku/Sonnet/Opus automatically selected for implementation based on `**Complexity**` field; Opus sets the field when creating specs
- **Spec 090**: Validation Gate in spec-work — spec-work now scores specs on 10 criteria before executing; blocks weak specs with actionable feedback
- **Spec 089**: Personal Config Token Optimization — MEMORY.md deduplicated, unused skills archived, context7 duplicate removed, global BASH_MAX_OUTPUT_LENGTH and MAX_MCP_OUTPUT_TOKENS set
- **Spec 088**: Template Token Optimization — BASH_MAX_OUTPUT_LENGTH added to template settings, agents.md dispatch table extracted to docs/, CLAUDE.md Context Management trimmed

## [1.3.2-patch] — 2026-03-13

- **Spec 087**: Token Optimization — reduced per-session overhead by removing duplicate rules, trimming CLAUDE.md, capping MCP output, fixing skill descriptions
- **fix**: Remove autocompactBuffer from powerline config — reclaims ~20% context per session
- **fix**: Remove ineffective paths: scoping from git.md and agents.md — both load unconditionally as intended
- **fix**: Register context-monitor.sh as PostToolUse hook (was installed but never executed)
- **fix**: AUTOCOMPACT threshold 70% → 80%, aligns with /compact guidance and buffer removal
- **fix**: circuit-breaker whitelist for specs/*.md and HANDOFF.md; fix substring count bug
- **fix**: update command PRE_UPDATE_SHA via temp file (bash vars don't persist between blocks)
- **fix**: Remove empty claude-mem-context tag from template CLAUDE.md
- **fix**: Default model opusplan → sonnet in template settings (Opus reserved for /spec creation)

## [v1.3.2] — 2026-03-13

- **Spec 086**: Challenge & Evaluate in templates — `challenge.md` and `evaluate.md` added to `templates/commands/`, generalized for any project
- **Spec 085**: Context budget awareness — CLAUDE.md and spec-work now prioritize handoff when context is low
- **Spec 084**: Debugging discipline — 6-point methodology added to `debug.md` and spec-work verification failure path
- **Spec 083**: Structured verification — acceptance criteria use Truths/Artifacts/Key Links categories; `spec-review` and `verify-app` verify mechanically
- **Spec 082**: Decisions register — append-only `decisions.md` for architectural decisions; `spec-work` and `reflect` append automatically
- **Spec 081**: Understanding confirmation — `spec-work` shows Goal/Approach/Files summary before branching for high-complexity specs

## [v1.3.1] — 2026-03-11

- **Spec 078+079**: Skill-First principle — Claude discovers installed skills before implementing manually; `Skill-First` rule added to rules, CLAUDE.md, and agent definitions
- **fix**: PreCompact auto-commit — `git add -u` instead of `-A`, proper conventional commit message, removed `--no-verify`
- **fix**: Silent sandbox bypass prevention — new Sandbox Safety rule requires explicit user confirmation before `dangerouslyDisableSandbox`
- **fix**: Silent early exit in setup script — `_install_or_update_file` returns `0` for skip/user-modified cases

## [v1.3.0] — 2026-03-10

- **Spec 076**: /simplify in spec-work — optional cleanup step between verify-app and code-reviewer; Web Fetching rule and Advanced Techniques section in WORKFLOW-GUIDE
- **Spec 075**: Replace Statusline with claude-powerline — `@owloops/claude-powerline` via npx with dark theme; custom `statusline.sh` removed
- **Spec 074**: Multi-tool skills symlinks — `.claude/skills/` auto-linked to `.codex/skills` and `.opencode/skills` when respective CLIs are installed
- **Spec 073**: Generation reliability — raised turn budgets, single-retry fallbacks, offline integration test for installed templates
- **Spec 072**: Crash resilience — `spec-work` detects completed steps and resumes; per-step commits; `spec-board` detects inconsistent states; `spec` auto-splits oversized specs
- **Spec 071**: Developer Workflow Guide — `.claude/WORKFLOW-GUIDE.md` installed with Quick Start, commands, subagents, hooks, and troubleshooting
- **feat**: Faster commands — pre-loaded git context, `argument-hint`, `disable-model-invocation`, `max_turns` caps for agents
- **feat**: Stricter quality gates — `spec-review` 10-metric scoring (0–100), `grill` scope challenge with A/B/C options
- **feat**: /reflect captures architectural discoveries and stack decisions in addition to corrections
- **feat**: 5 new monitoring hooks (config-change-audit, context-monitor, mcp-health, post-tool-failure-log, task-completed-gate) + 4 rules files
- **feat**: /spec-validate and /update commands — spec quality scoring and in-session ai-setup updates
- **feat**: Automated GitHub Releases — `release-from-changelog.yml` populates release body from CHANGELOG on `vX.Y.Z` tags

## [v1.2.8] — 2026-03-09

- **feat**: Agent skill injection — agents receive system-specific skills (Shopify, Shopware, generic) automatically on install
- **feat**: Agent delegation rules — `rules/agents.md` with trigger-condition table, scope limits, and anti-patterns
- **chore**: Spec backlog cleanup — 11 specs → 0; dead specs deleted, good ideas moved to `BACKLOG.md`
- **perf**: ~11% context reduction (~2,600 fewer tokens) — compressed spec.md, deduplicated reflect.md, consolidated cross-repo-context.sh
- **fix**: Deadloop prevention hardening — clearer circuit-breaker warnings, advisory language in hooks

## [v1.2.7] — 2026-03-06

- **fix**: Reliable GitHub releases — `create` tag event fallback for delayed push events; manual workflow trigger backup
- **feat**: Automatic CodeRabbit integration — `coderabbitai/claude-plugin` installed and activated on setup
- **feat**: Always-visible update notifications — `update-check` runs on SessionStart and UserPromptSubmit; npm → GitHub Release → Tag fallback chain
- **feat**: Cross-repo context — SessionStart hook loads sibling repo context via `repo-group.json` or Shopware naming fallback

## [v1.2.6] — 2026-03-06

- **refactor**: Commands use correct Tool API — all templates migrated from `Task` → `Agent` wording
- **feat**: 3 new hooks out of the box — PostToolUseFailure logging, ConfigChange audit, TaskCompleted gate
- **perf**: Faster statusline — workspace JSON fields, lightweight git caching
- **fix**: Safer Shopify/Shopware detection — improved auto-detection signals, credentials never written to `.mcp.json`
- **perf**: Smarter setup runs — skip context regeneration in skills-only runs, deduplicate skill installs

## [v1.2.5] — 2026-03-05

- **Spec 054**: Bang-Syntax Context Injection — `## Context` sections with `!git` commands in commit, review, pr commands eliminate 2-3 tool-call round-trips for context gathering
- **Spec 053**: Context Monitor Hook — PostToolUse hook warns agent at <=35% (WARNING) and <=25% (CRITICAL) remaining context via statusline bridge file and `additionalContext` injection
- **Spec 052**: Agent Delegation Rules — new `rules/agents.md` template with trigger/scope/model guidance for all 8 agents and anti-patterns to prevent over-delegation
- **Spec 051**: PreCompact Hook — prompt-type hook in `settings.json` that auto-instructs Claude to commit or write HANDOFF.md before context compaction
- **Spec 050**: Post-Edit Hooks — `post-edit-lint.sh` extended with `tsc --noEmit` type-check (TS files, blocking) and `console.log` warning (non-blocking stderr)
- **Spec 049**: /evaluate command — project-local command for systematic evaluation of external ideas against existing template inventory
- **Slack-ready releases**: Added `release-from-changelog.yml` workflow to create/update GitHub releases from `CHANGELOG.md` on pushed `v*` tags
- **Template rollout**: Added workflow template under `templates/github/workflows/` so generated projects get the same release-note automation by default
- **Installer hardening**: `install_copilot()` now installs all files under `templates/github/` recursively, not only `copilot-instructions.md`
- **Release docs/command updates**: README and `/release` command now document the automatic changelog-to-Slack release flow

## [v1.2.4] — 2026-03-04

- **Mandatory plugins**: Context7, claude-mem, and all official plugins (code-review, feature-dev, frontend-design) now install automatically without prompts
- **Removed Playwright & GSD**: Playwright MCP removed from setup; GSD moved to README as optional extension
- **Token optimization**: 15 new deny patterns (lock files, cache dirs, minified assets, source maps), `plansDirectory` and `enableAllProjectMcpServers` settings added
- **Session tips**: CLAUDE.md template now includes `Esc Esc` rewind, `/rename`+`/resume`, commit-checkpoint advice
- **Reflect routing**: `/reflect` now routes architectural discoveries to ARCHITECTURE.md and stack decisions to STACK.md
- **Haiku routing rule**: New rule ensures Explore subagents always use haiku model (60x cost reduction)

## [v1.2.3] — 2026-03-02

- **OpenCode compatibility**: `generate_opencode_config()` generates `opencode.json` from `.claude/agents/`, `.claude/commands/`, and `.mcp.json` — translates model tiers, tool permissions, and MCP servers for OpenCode CLI compatibility
- **Haiku model routing**: Downgraded 4 mechanical commands/agents from sonnet to haiku — `commit.md`, `pr.md`, `spec-board.md`, `context-refresher.md` — reduces token cost for high-frequency low-complexity tasks
- **Agent/command sync**: Added missing `perf-reviewer.md`, `test-generator.md` agents and `analyze.md`, `context-full.md`, `reflect.md`, `release.md`, `spec-board.md` commands to project

## [v1.2.2] — 2026-03-01

- **MCP Health Hook**: `mcp-health.sh` SessionStart hook — validates `.mcp.json` JSON syntax, required fields per server type (`url` for http/sse, `command` for stdio), and base command availability via `command -v`; silent on success, warnings to stderr

## [v1.2.1] — 2026-02-28

- **Spec 047**: Settings + hooks + agent memory — SessionStart hook, AUTOCOMPACT=30, ENABLE_TOOL_SEARCH, PostToolUse failure log, Stop quality gate, agent memory:project + isolation:worktree fields
- **Spec 046**: Statusline global install — optional `~/.claude/statusline.sh` setup with color-coded context bar, model, cost, and git branch display
- **Spec 045**: /grill enhancements — scope challenge step, A/B/C options format, "What already exists" + "NOT reviewed" sections, self-verification table
- **Spec 044**: .claude/rules/ template expansion — testing.md, git.md, typescript.md (conditional), opusplan model, CLAUDE.md memory + tips sections
- **Review fixes**: find precedence bug in TS detection, TS metadata tracking, statusline null-safety + jq guard, SessionStart matcher, idempotent statusline prompt

## [v1.2.0] — 2026-02-27

- **Update UX**: per-file [y/N] prompt before overwriting user-modified files; Update files option available without version change
- **Spec 043**: Self-Improvement Reflect System — new /reflect command detects session corrections and writes them as permanent CLAUDE.md/CONVENTIONS.md rules with user approval
- **Spec 042**: Feedback Loop Patterns — techdebt.md now verifies changes via verify-app, spec-work.md has progress checklist, test.md has explicit attempt tracking
- **Spec 041**: Skill Descriptions Best Practices — all 15 command descriptions now follow "what + when" format in third person, under 120 chars
- **Spec 040**: README & CHANGELOG sync — fix counts (15 cmds/8 agents/6 hooks), compact sections, /release validates all counts
- **Spec 039**: Claude-Mem as team standard — default Y, `<claude-mem-context>` in CLAUDE.md, documents as required plugin
- **Spec 038**: Global Definition of Done — DoD in CONVENTIONS.md, build-artifact rules, /spec-review DoD validation
- **Spec 037**: Claude Code best practices — SKILL.md frontmatter, disable-model-invocation, enriched settings.json, notify.sh
- **Spec 036**: Bash performance — parallel skills search/install, 8-job curl pool, parameter expansion (100+ second runtime reduction)
- **Spec 035**: /analyze command — 3 parallel Explore agents produce architecture/hotspots/risks overview
- **Spec 034**: /bug multi-agent verification — verify-app auto-runs after fix, code-reviewer after verification passes
- **Spec 033**: /pr + /review improvements — build-validator in /pr pipeline, /review covers full branch diff
- **Spec 032**: Local skill templates — bundles tailwind, pinia, drizzle, tanstack, vitest; skips slow skills.sh search
- **Spec 031**: CLAUDE.md generation timeout fix — 120s→180s, correct "timed out" error message
- **Spec 030**: Granular update regeneration — missing context detection, checkbox UI instead of binary prompt

## [v1.1.6] — 2026-02-24

- **Spec 029**: Add perf-reviewer and test-generator agent templates — two new universal agents for performance analysis (read-only, FAST/CONCERNS/SLOW verdict) and test generation (write-guarded to test directories only)
- **Spec 028**: Fully automatic agent integration — `verify-app` auto-runs after spec implementation (blocks code-reviewer on FAIL), `staff-reviewer` auto-runs in `/pr` before draft
- **Spec 027**: Add code-architect agent — new opus agent for architectural assessment, auto-spawned by `spec-work` when spec has `**Complexity**: high`
- **Spec 026**: Add code-reviewer Agent — new reusable `code-reviewer` agent (sonnet) wired automatically into `spec-work` and `spec-review`, replacing inline review logic
- **Spec 025**: Add .claude/rules/general.md template + agent max_turns — installs a universal coding safety rules file and caps agent turn counts as a cost guard
- **Spec 024**: Smoke Test for bin/ai-setup.sh — added tests/smoke.sh and npm test script for syntax and function-presence checks
- **Spec 023**: Fix git add -A in Worktree Prompt — replaced git add -A with git add -u in spec-work-all subagent commit step
- **Spec 022**: Deduplicate Auto-Review Logic — removed duplicated review criteria from spec-work.md auto-review step, replaced with compact summary referencing `/spec-review` for full criteria
- **Spec 021**: /release command and git tagging — added `/release` slash command template, reformatted CHANGELOG with `[Unreleased]` + versioned headings, updated `/spec-work` to target `[Unreleased]`, backfilled git tags v1.1.0–v1.1.4, bumped version to 1.1.5

## [v1.1.4] — 2026-02-23

- **Spec 020**: Granular template update selector — 5-category checkbox UI (Hooks, Settings, Commands, Agents, Other) for selective updates
- **Spec 019**: Shopify templates moved to skills — relocated 8 templates to `templates/skills/shopify-*/prompt.md`

## [v1.1.3] — 2026-02-23

- **Spec 018**: Native worktree rewrite — `Agent(isolation: "worktree")` replaces manual git worktree management in spec-work-all
- **Spec 016**: Worktree env and deps — auto-copies `.env*` files and runs dep install in each worktree before agents

## [v1.1.2] — 2026-02-22

- **Spec 015**: Spec workflow branch and review — branch creation prompt before start, auto-review with corrections after execution
- **Spec 014**: Skills Discovery Section — `## Skills Discovery` in CLAUDE.md for on-demand skill search/install
- **feat**: Mini-VibeKanban spec workflow — full status lifecycle, `/spec-board` Kanban, `/spec-review` with PR drafting, worktree-based parallel execution
- **Spec 013**: Dynamic Template Map — replaced hardcoded TEMPLATE_MAP with dynamic generation from `templates/`
- **feat**: `/spec` challenge phase deepened — thinks through implementation before verdict
- **feat**: `/spec` challenge uses `AskUserQuestion` at decision points during analysis
- **feat**: `/spec` and `/spec-work` auto-load relevant installed skills from `.claude/skills/`
- **feat**: `update-check.sh` hook — notifies at session start when a new `@onedot/ai-setup` version is available
- **fix**: Circuit breaker auto-resets when user sends next message

## [v1.1.1] — 2026-02-21

- **Spec 012**: /bug command — added `/bug` slash command template with structured reproduce → root cause → fix → verify workflow

## [v1.1.0] — 2026-02-21

- **feat**: Merge `/challenge` into `/spec` — spec now challenges the idea first (GO/SIMPLIFY/REJECT verdict) before writing the spec; `/challenge` command removed
- **feat**: Interactive checkbox selector for regeneration — replaces y/N prompt with arrow+space UI; 4 options: CLAUDE.md, Context, Commands, Skills
- **feat**: Split regeneration Skills into Commands (internal slash commands/agents) and Skills (external skills.sh)
- **fix**: Replace full model IDs with short aliases (`sonnet`) in all command/agent frontmatter — fixes IDE validation errors
- **docs**: Add ccusage to README as recommended tool for session token usage analysis
- **Spec 011**: Bulk Spec Execution via Agents — adds `/spec-work-all` slash command for parallel spec execution via subagents
- **feat**: Add `/challenge` command to `templates/commands/`
- **feat**: Expand system skill sets with verified skills — Nuxt adds vue+vueuse, Shopify adds shopify-theme-dev, Next.js adds nextjs-app-router-patterns, Laravel adds eloquent-best-practices
- **fix**: Add skills.sh registry pre-check in `install_skill()` — invalid skills skipped with warning
- **feat**: Add Next.js/React system option with auto-detection and skill routing
- **Spec 010**: Aura Frog Quality Patterns — Added Task Complexity Routing, dual-condition verification gate, and conditional TDD enforcement to `templates/CLAUDE.md`
- **Spec 009**: Auto-Detect System from Codebase Signals — Added `detect_system()` to resolve `--system auto`
- **Spec 008**: Feature Challenge Skill — Added `.claude/commands/challenge.md` with GO/SIMPLIFY/REJECT decision
- **Spec 007**: Deny list security hardening — Added `git clean`, `git checkout --`, `git restore` to deny list
- **Spec (untracked)**: Context-Refresher Subagent + Auto-Trigger
- **Spec (untracked)**: Project Concept Documentation — Added `docs/` with CONCEPT.md, ARCHITECTURE.md, DESIGN-DECISIONS.md
- **Spec 007**: Auto-Updated CHANGELOG.md on Spec Completion
