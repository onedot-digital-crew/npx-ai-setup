# Brainstorm: Claude Code v2.1.88 Source Internals

> **Source**: https://github.com/sanbuphy/claude-code-source-code
> **Erstellt**: 2026-04-01
> **Quelle**: Decompiled TypeScript aus `@anthropic-ai/claude-code` npm-Paket (educational)
> **Zweck**: Interne Mechanismen verstehen, npx-ai-setup optimieren

---

## Executive Summary

Das Repo enthält dekompilierten TypeScript-Code aus Claude Code v2.1.88. Drei Kernbereiche sind für uns relevant: (1) das Hook-System hat 26 Events — wir nutzen nur 10–12; (2) die Settings-Prioritätskette erklärt Plugin-Verhalten für Spec 603; (3) KAIROS + Coordinator Mode zeigen die Richtung für zukünftige Automatisierung.

---

## Bestandsvergleich

| Bereich | Intern (CC v2.1.88) | Unser Setup | Status |
|---------|---------------------|-------------|--------|
| Hook Events | 26 definiert | ~12 genutzt | ⚠️ Partial |
| Hook Sources | plugin / session / builtin / policy | nur file-based | ⚠️ Partial |
| Agent-based Hooks | execAgentHook (LLM-powered) | nicht genutzt | ❌ Missing |
| Settings Priority | 6-stufig plugin→policy | 3-stufig user/project/local | ⚠️ Partial |
| PostCompact Hook | vorhanden | fehlt | ❌ Missing |
| PermissionDenied Hook | vorhanden | fehlt | ❌ Missing |
| SubagentStart/Stop Hooks | vorhanden | fehlt | ❌ Missing |
| InstructionsLoaded Hook | vorhanden | fehlt | ❌ Missing |
| KAIROS Autonomy | in source, feature-flagged | nicht relevant | ✅ Covered (future) |
| Model Codenames | Fennec→Opus, Numbat=next | hardcoded model IDs | ⚠️ Partial |

---

## Kernfunde mit Optimierungspotenzial

### 1. Hook-System: 14 ungenutzte Events

**Quelle**: `src/utils/hooks/hooksConfigManager.ts`

Definierte Hook-Events (26 total):
```
PreToolUse, PostToolUse, PostToolUseFailure       ← wir nutzen alle
PermissionDenied, PermissionRequest               ← WIR NUTZEN NICHT
SessionStart, SessionEnd, Stop, StopFailure       ← SessionStart+Stop genutzt
SubagentStart, SubagentStop                       ← WIR NUTZEN NICHT
PreCompact, PostCompact                           ← PreCompact genutzt, PostCompact fehlt
ConfigChange, InstructionsLoaded                  ← ConfigChange genutzt, InstructionsLoaded fehlt
Notification, UserPromptSubmit, Elicitation, ElicitationResult  ← Notification+UserPromptSubmit genutzt
WorktreeCreate, WorktreeRemove, CwdChanged, FileChanged  ← WIR NUTZEN NICHT
TeammateIdle, TaskCreated, TaskCompleted           ← TaskCompleted genutzt
Setup                                             ← WIR NUTZEN NICHT
```

**Hochwertig für uns**:
- `PostCompact` → Ergänzung zu unserem `pre-compact-state.sh` (Spec 607)
- `SubagentStart/Stop` → Model-Routing-Enforcement, Kosten-Tracking
- `PermissionDenied` → Logging, Lern-Feedback für Entwickler
- `InstructionsLoaded` → Validierung beim CLAUDE.md-Load (Spec 609)

---

### 2. Agent-Based Hooks (execAgentHook)

**Quelle**: `src/utils/hooks/execAgentHook.ts`

Neben Shell-Hooks gibt es **LLM-basierte Hooks**: Ein vollständiger Agent wird gespawnt (max 50 Turns, 60s Timeout), der `$ARGUMENTS` verarbeitet und ein strukturiertes Ergebnis zurückgibt:
- `success` — Bedingung erfüllt
- `blocking` — Bedingung nicht erfüllt, mit Fehlermessage
- `cancelled` — Timeout oder Max-Turns
- `non_blocking_error` — Ausführungsfehler

Tool-Zugriff im Hook-Agent ist gefiltert (keine nested Agents, kein Plan-Mode).

**Für uns**: Komplexe Validierungen die Shell nicht kann — z.B. "Prüfe ob dieser Commit message semantisch korrekt ist" oder "Validiere ob die Spec vollständig ist".

---

### 3. Settings-Prioritätskette

**Quelle**: `src/utils/settings/settings.ts`

Merge-Reihenfolge (niedrigste→höchste Priorität):
```
pluginSettings → userSettings → projectSettings → localSettings → flagSettings → policySettings
```

**Kritisch für Spec 603 (Plugin-First)**:
- Plugin-Settings haben die **niedrigste** Priorität — werden von allem überschrieben
- Das ist ein Feature: Plugins setzen Defaults, Projekte überschreiben sie
- Unser Plugin soll Defaults liefern, die projektlokal überschreibbar sind — das passt

**Kritisch für Spec 610 (Governance)**:
- `hasAutoModeOptIn()` prüft bewusst **nicht** Project-Sources — nur User+
- `hasSkipDangerousModePermissionPrompt()` excludes Projects aus trusted sources
- Policy: remote > HKLM/plist > file > HKCU (Unternehmens-Policy schlägt User-Settings)

---

### 4. Modell-Codenames und Zukunft

**Quelle**: `docs/en/05-future-roadmap.md`

Bekannte Codename-Kette:
```
Fennec → Opus 4.6 (aktuell)
Numbat → nächstes Modell (Commit-Marker: @[MODEL LAUNCH])
Opus 4.7, Sonnet 4.8 in Entwicklung
```

**Für unser Model Routing**: Hardcodierte Modell-IDs in `agents.md` und `CLAUDE.md` werden beim Launch-Wechsel veraltet. Wir sollten Routing auf Familien-Basis statt exakter IDs setzen.

Aktuelle Regel: `claude-opus-4-6` explizit gesetzt. Besser: `claude-opus-4` + latest-Suffix-Logik.

---

### 5. KAIROS: Autonomer Agentenmodus

**Quelle**: `docs/en/05-future-roadmap.md`

KAIROS ist ein feature-geflagter autonomer Betriebsmodus mit `<tick>`-Heartbeat-Prompts:
- "Unfocused: The user is away. Lean heavily into autonomous action."
- "Focused: The user is watching. Be more collaborative."
- Tools: `SleepTool`, `BriefTool`, `PushNotificationTool`, `SubscribePRTool`

**Für uns jetzt**: KAIROS ist noch feature-flagged. Aber unser `/schedule`-Skill und Cron-Triggers spielen in dieselbe Richtung. Die Tick-Architektur bestätigt unseren Ansatz mit Remote Triggers.

**Für die Zukunft**: Wenn KAIROS public wird, sollten Hooks wie `SubagentStart/Stop` und unser Context-Budget-System bereits stabil sein — sie werden stärker beansprucht.

---

### 6. Weitere unreleased Features

| Feature | Flag | Relevanz |
|---------|------|----------|
| WebBrowserTool | `WEB_BROWSER_TOOL` | ersetzt agent-browser für uns |
| SnipTool | `HISTORY_SNIP` | Context-Budget Management |
| WorkflowTool | `WORKFLOW_SCRIPTS` | unser Skill-System komplementiert das |
| DreamTask | `tengu_onyx_plover` | Background Memory = unser claude-mem |
| Voice Mode | `VOICE_MODE` | OAuth-only, nicht relevant für CLI |
| Buddy System | intern | 18 Species, 5 Stats — Marketing-Feature |

---

## Direkter Bezug zu laufenden Specs

### Spec 608 (Context Budget Hardening)
- `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` und `BASH_MAX_OUTPUT_LENGTH` sind **echte** Env Vars (bestätigt)
- `SnipTool` (feature-flagged) macht was unser `context-monitor.sh` manuell macht
- `PostCompact` Hook fehlt uns — ergänzt Spec 607 (auto-compact-hooks)

### Spec 609 (Runtime Consistency)
- `InstructionsLoaded` Hook: Feuert wenn CLAUDE.md geladen wird — ideal für Validierung
- Bestätigt: `context-monitor.sh` thresholds müssen mit `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` aligned sein

### Spec 610 (Permissions & Governance)
- Settings-Priorität bestätigt: Plugin-Settings werden von Project-Settings überschrieben — das ist Absicht
- `hasAutoModeOptIn()` excludes Projects — dontAsk/auto Mode muss User-Level gesetzt sein, nicht Project-Level
- Policy-Source-Hierarchie: Remote > Managed File > User — Unternehmens-Setups können Claude zwingen

### Spec 603 (Plugin-First)
- Plugin-Hooks sind first-class HookSource (`pluginHook` type)
- Plugin-Settings haben niedrigste Priorität — genau das wollen wir: Defaults die überschreibbar sind
- `sortMatchersByPriority()` gibt Plugin-Hooks niedrigste Priorität (999) — bewusste Design-Entscheidung

---

## Neue Kandid aten (nicht in bestehenden Specs)

### K1: PostCompact Hook (Ergänzung zu Spec 607)
**Was**: Hook nach Compaction — ergänzt pre-compact-state.sh
**Gap**: Wir haben nur Pre-Compact; Post-Compact wäre die logische Ergänzung
**Aufwand**: niedrig (1 Shell-Script)
**Wert**: ★★★★ — rundet 607 ab

### K2: SubagentStart/Stop Hooks
**Was**: Hooks die beim Agent-Spawn und -Stop feuern
**Gap**: Kein Model-Enforcement bei Subagent-Spawns, kein Kosten-Tracking
**Aufwand**: mittel (2 Scripts + Settings)
**Wert**: ★★★ — hilft bei Model-Routing-Violations erkennen

### K3: PermissionDenied Hook
**Was**: Feuert wenn eine Permission-Request geblockt wird
**Gap**: Wir loggen Tool-Failures, aber nicht Permission-Denials
**Aufwand**: niedrig (1 Shell-Script)
**Wert**: ★★★ — Development-Feedback, erklärt warum etwas nicht geht

### K4: InstructionsLoaded Hook
**Was**: Feuert wenn CLAUDE.md / Rules geladen werden
**Gap**: Kein Validierungsschritt beim Load
**Aufwand**: mittel (Hook + Validierungslogik)
**Wert**: ★★ — nett, aber Spec 609 adressiert das anders

### K5: Model Routing Zukunftssicherheit
**Was**: Statt `claude-opus-4-6` → Pattern `claude-opus-4` mit Fallback
**Gap**: Beim Numbat/Opus-4.7-Launch werden hardcodierte IDs veraltet
**Aufwand**: niedrig (Docs-Edit)
**Wert**: ★★★ — wartungsarm

### K6: Agent-Based Hook für Spec-Validierung
**Was**: execAgentHook — LLM-Hooks für komplexe Checks
**Gap**: Unser spec-stop-guard.sh ist Shell-basiert, LLM-Hook wäre präziser
**Aufwand**: hoch (neue Hook-Kategorie im Setup)
**Wert**: ★★ — Overkill für jetzigen Stand

---

## Gesamtranking nach Aufwand/Nutzen

| Prio | Kandidat | Wert | Aufwand | Empfehlung |
|------|----------|------|---------|------------|
| 1 | PostCompact Hook (K1) | ★★★★ | niedrig | Jetzt, Anhang zu Spec 607 |
| 2 | Model Routing Zukunftssicherheit (K5) | ★★★ | niedrig | Jetzt, 5-Minuten-Fix |
| 3 | SubagentStart/Stop Hooks (K2) | ★★★ | mittel | Eigener Spec |
| 4 | PermissionDenied Hook (K3) | ★★★ | niedrig | Anhang zu Spec 610 |
| 5 | InstructionsLoaded Hook (K4) | ★★ | mittel | Optional, nach Spec 609 |
| 6 | Agent-Based Hooks (K6) | ★★ | hoch | Zurückstellen |

---

## Philosophy-Check

Alle Kandidaten gegen DESIGN-DECISIONS.md geprüft:

| Kandidat | Check | Verdict |
|----------|-------|---------|
| PostCompact Hook | Bash, keine Runtime-Dep, ergänzt bestehenden Hook | GO |
| Model Routing Fix | Nur Docs/Config-Edit | GO |
| SubagentStart/Stop | Bash-Hook, passt ins Hook-Schema | GO |
| PermissionDenied | Bash-Hook, passt ins Hook-Schema | GO |
| InstructionsLoaded | Bash-Hook, aber Nutzen unklar | PIVOT — erst nach Spec 609 beurteilen |
| Agent-Based Hooks | Bringt LLM-Dependency in Hooks — verletzt "No Runtime needed" | SKIP |

---

## Quellen

- README: Claude Code v2.1.88 Architektur-Übersicht
- `hooksConfigManager.ts`: 26 Hook-Events, HookSource-Typen
- `hooksSettings.ts`: Hook-Deduplication, Priority-Sorting
- `hookEvents.ts`: Event-Emission, allHookEventsEnabled Flag
- `execAgentHook.ts`: LLM-basierte Hooks, 50-Turn-Limit, Structured Output
- `settings.ts`: 6-stufige Settings-Prioritätskette
- `docs/en/05-future-roadmap.md`: KAIROS, Numbat, Voice, unreleased Tools
