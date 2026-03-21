# Brainstorm: Context-System Evaluation & Optimierung

> **Spec ID**: 133 | **Created**: 2026-03-21 | **Status**: brainstorm | **Branch**: —
> **Zweck**: Vollständige Evaluierung des Context-Generierung-Systems — ist der aktuelle Ansatz sinnvoll, wo sind Schwächen, was kann repomix besser?

---

## Ist-Zustand: 3 Wege zur Context-Generierung

Das Projekt hat **drei verschiedene Mechanismen** für Context-Erzeugung — das ist der Kern des Problems:

### 1. One-Shot in `lib/generate.sh` (Step 2)
- `claude -p --model claude-sonnet-4-6 --max-turns 8`
- Input: Shell-gesammelte Snippets (package.json, tsconfig, dir tree, 80 file list, eslint/prettier config, README, 3 Sample-Dateien)
- Output: STACK.md, ARCHITECTURE.md, CONVENTIONS.md
- **Problem**: Blind — sieht nur Fragmente, nicht den echten Code. Sample-Dateien sind die ersten 3 aus der File-Liste (zufällig, nicht repräsentativ).

### 2. `context-refresher` Agent (`.claude/agents/context-refresher.md`)
- Haiku-Model, 15 max turns
- Liest package.json, README, tsconfig, eslintrc/prettierrc, scannt Verzeichnisse, samplet 3-5 Source-Dateien
- Schreibt die gleichen 3 Context-Files
- **Plus**: Generiert optional repomix Snapshot am Ende
- **Problem**: Haiku ist zu schwach für qualitative Analyse. Repomix-Snapshot kommt NACH der Context-Generierung (umgekehrte Reihenfolge).

### 3. `/context-full` Command
- Sonnet-Model, nur Read/Bash erlaubt
- Generiert repomix Snapshot und fasst ihn zusammen
- **Problem**: Schreibt KEINE Context-Files — ist nur ein manueller Snapshot-Befehl.

### Hooks
- `context-freshness.sh`: Prüft ob package.json/tsconfig sich geändert haben → warnt wenn stale
- `context-monitor.sh`: Überwacht Context-Window-Verbrauch (unrelated)
- `cross-repo-context.sh`: Multi-Repo-Context (nur bei Shopware-Suites relevant)

---

## Diagnose: Was ist schlecht?

### A. Drei Wege, keine Qualitätsgarantie
Der One-Shot und der context-refresher erzeugen beide die gleichen 3 Files — aber keiner nutzt repomix als Input. Beide sammeln Fragmente per Shell und hoffen, dass das LLM daraus guten Context ableitet.

### B. Repomix-Snapshot zu groß (731 KB)
Der aktuelle Snapshot ist **731 KB** (~180k Tokens). Kein LLM kann das komplett lesen. Selbst mit 1M-Context würde der Snapshot allein 18% des Fensters belegen — und das für einmalige Context-Generierung.

### C. Repomix-Config zu generisch
```json
{
  "output": { "compress": true, "removeComments": true, "removeEmptyLines": true },
  "ignore": { "customPatterns": ["node_modules", "dist", ".git", "*.lock"] }
}
```
Keine project-type-spezifische Filterung. Shopify-Projekte bräuchten andere Ignore-Patterns als Next.js oder Laravel.

### D. Staleness-Detection zu eng
Nur `package.json` und `tsconfig.json` werden geprüft. Änderungen an:
- Directory-Struktur (neue Module/Ordner)
- .env.example (neue Env-Vars)
- Docker/CI-Config
- Neue Config-Files (vite.config, nuxt.config etc.)
... triggern **keine** Staleness-Warnung.

### E. context-refresher nutzt Haiku
Haiku ist zu schwach, um aus 3-5 Sample-Dateien akkurate Architektur-Beschreibungen zu erstellen. Für eine Aufgabe die 1x pro Setup läuft, ist Sonnet der richtige Trade-off.

---

## Spec 131 Bewertung

Spec 131 ("Repomix-First Context Generation") geht **in die richtige Richtung**, hat aber eine kritische Lücke:

### Was 131 richtig macht
- Repomix VOR Context-Generierung (richtige Reihenfolge)
- Dedizierter Agent statt One-Shot
- Eliminiert doppelte Generierung

### Was 131 fehlt
1. **Repomix-Snapshot ist zu groß** — der Agent kann 731KB nicht sinnvoll lesen
2. **Keine Strategie für Snapshot-Reduktion** — braucht entweder:
   - Aggressive Filterung (nur Key-Files ins Repomix)
   - `--top-files-len N` Parameter
   - Selektives Lesen (Agent sucht im Snapshot statt alles zu lesen)
3. **Kein Qualitäts-Gate** — keine Validierung der erzeugten Context-Files
4. **Template-Config nicht project-aware** — gleiche repomix.config.json für alle Stacks

---

## Bessere Ansätze mit Repomix

### Option A: Repomix mit aggressiver Filterung (empfohlen)
Statt den gesamten Codebase zu snapshooten, nur die für Context relevanten Files:
- `package.json`, `tsconfig.json`, `*.config.*`, `README.md`
- Top-Level Source-Dateien (Entry Points)
- Max 30 repräsentative Files
- Ergebnis: ~50-80KB statt 731KB

**Wie**: Zweite repomix-Config `repomix-context.config.json` mit strikter Include-Liste.

### Option B: Repomix File-Map + selektives Lesen
1. Repomix mit `--style plain --compress` für die File-Map (Verzeichnis + Funktions-Signaturen)
2. Agent liest die komprimierte Map (~30-50KB)
3. Agent entscheidet welche Files er tiefer lesen will
4. Agent liest 5-10 Key-Files direkt per Read-Tool

**Vorteil**: Agent sieht die Gesamtstruktur UND kann gezielt tiefer gehen.

### Option C: Zweistufiger Agent (best of both)
1. **Stage 1**: Repomix generiert komprimierte Struktur-Map (~30KB)
2. **Stage 2**: Sonnet-Agent liest die Map, identifiziert die 10 wichtigsten Files
3. **Stage 3**: Agent liest diese Files direkt und schreibt Context

Das ist im Grunde was Spec 131 vorschlägt, aber mit dem fehlenden Puzzle-Stück: **Snapshot-Größen-Management**.

---

## Repomix-Config Deep-Dive

### Aktuelle Architektur (3 Schichten)

**1. `repomix.config.json`** (Template, wird kopiert)
```json
{
  "output": { "filePath": ".agents/repomix-snapshot.xml", "style": "xml", "compress": true, "removeComments": true, "removeEmptyLines": true },
  "ignore": { "useGitignore": true, "useDefaultPatterns": true, "customPatterns": ["node_modules", "dist", ".git", "*.lock", "*.lockb"] }
}
```

**2. `.repomixignore`** (generiert per `install_repomixignore()`, gitignored)
- Base: `node_modules/`, `vendor/`, `dist/`, `build/`, `coverage/`, binaries, fonts, images
- Stack-Append: Shopware (`var/cache/`, `var/log/`), Nuxt (`.nuxt/`, `.output/`), Next (`.next/`), Laravel (`bootstrap/cache/`, `storage/`)

**3. `generate_repomix_snapshot()`** (in `setup-compat.sh`)
- Einmalig (skippt wenn `.agents/repomix-snapshot.xml` existiert)
- 120s Timeout, Background-Process mit Spinner
- Fallback ohne Config: inline `--ignore` Flags

### Problem-Analyse des Snapshots

**Aktueller Snapshot dieses Repos**: 20.101 Zeilen, 731 KB, **211 Dateien**

Breakdown nach Kategorien:
| Kategorie | Dateien | Problem |
|-----------|---------|---------|
| `specs/completed/*.md` | ~70+ | Abgeschlossene Specs = historisch, nicht für Context nötig |
| `templates/skills/*.md` | ~10 | Skill-Prompts (Drizzle, Pinia, Vitest etc.) — riesig, irrelevant für Projekt-Context |
| `templates/commands/*.md` | ~15 | Template-Kopien der Commands |
| `templates/claude/**` | ~15 | Template-Kopien von hooks/rules/settings |
| `lib/*.sh` | ~10 | **Kerncode — relevant** |
| `bin/ai-setup.sh` | 1 | **Kerncode — relevant** |
| `.claude/**` | ~30 | Aktive Config — teils relevant |
| `.agents/context/*` | 5 | Meta-Files über sich selbst — Zirkel |

**Kernproblem**: ~60% des Snapshots sind completed Specs und Skill-Templates — Ballast für Context-Generierung.

### Testlauf: Lean-Config Simulation

Selbst NACH Excludes von `specs/completed/`, `templates/skills/`, `templates/commands/`, `templates/claude/` bleiben:
- **187 Files, 1.1 MB raw** — immer noch zu groß!

**Neu entdeckter Ballast** (nicht in den Original-Excludes):
| Datei/Dir | Größe | Relevanz für Context |
|-----------|-------|---------------------|
| `SUPERPOWERS_SCRAPE.md` | 245 KB | Keine — temporärer Scrape |
| `.claude/superpowers-scrape/` | 180+ KB | Keine — Scrape-Artefakte |
| `CHANGELOG.md` | 25 KB | Minimal — Versions-History |
| `specs/brainstorms/` | 26+ KB | Keine — Brainstorm-Docs |
| `specs/1xx-evaluate-*.md` | 37+ KB | Keine — Evaluation-Docs |

**Zusätzliche Excludes nötig**: `SUPERPOWERS_SCRAPE.md`, `.claude/superpowers-scrape/`, `CHANGELOG.md`, `specs/brainstorms/`, `specs/*evaluate*`

**Nach allen Excludes**: Geschätzt ~400-500 KB raw → mit Repomix-Kompression (~50-60%) → **~200-250 KB Lean-Snapshot**. Mit `topFilesLength: 30` nochmal deutlich weniger (~80-120 KB).

### Was der Snapshot für Context-Gen wirklich braucht

Für STACK.md, ARCHITECTURE.md, CONVENTIONS.md braucht der Agent:

| Muss-haben | Warum |
|------------|-------|
| `package.json` | Dependencies, Scripts, Version |
| `bin/ai-setup.sh` | Entry Point, Flow-Überblick |
| `lib/*.sh` | Kernlogik, Module-Struktur |
| `README.md` | Projekt-Beschreibung |
| Config-Files (`*.config.*`, `tsconfig`, `.eslintrc`) | Stack-Erkennung |
| Directory-Struktur | Architektur-Überblick |

| Nice-to-have | Warum |
|-------------|-------|
| `templates/CLAUDE.md` | Template-Struktur verstehen |
| `templates/agents/*.md` | Agent-Ökosystem |
| `CLAUDE.md` | Aktuelle Projekt-Regeln |
| `.claude/settings.json` | Permissions/Hooks |

| Nicht-brauchen | Warum raus |
|---------------|-----------|
| `specs/completed/*` | Historisch, 70+ Files |
| `templates/skills/*` | Skill-Prompts sind Content, nicht Architektur |
| `.agents/context/*` | Zirkulär (generiert was es selbst beschreibt) |
| `templates/commands/*` | Kopien der aktiven Commands |
| `templates/claude/hooks/*` | Kopien der aktiven Hooks |

### Vorschlag: Dual-Config-Strategie

**Config A: `repomix.config.json`** (bleibt wie ist)
- Für `/context-full` und manuelle Nutzung
- Vollständiger Codebase-Snapshot

**Config B: `repomix-context.config.json`** (NEU, für Context-Generierung)
```json
{
  "output": {
    "filePath": ".agents/repomix-context.xml",
    "style": "xml",
    "compress": true,
    "removeComments": true,
    "removeEmptyLines": true,
    "topFilesLength": 30
  },
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "specs/completed/",
      "templates/skills/",
      "templates/commands/",
      "templates/claude/",
      ".agents/context/",
      ".agents/repomix-*",
      "node_modules", "dist", ".git",
      "*.lock", "*.lockb", "*.map",
      "*.min.js", "*.min.css",
      "*.png", "*.jpg", "*.gif", "*.webp",
      "*.woff", "*.woff2", "*.ttf", "*.pdf"
    ]
  }
}
```
**Erwartete Größe**: ~80-120 KB statt 731 KB (~85% Reduktion)

### Stack-aware Ignore-Patterns (für Template an Zielprojekte)

Die `.repomixignore` hat schon Stack-spezifische Appends. Fehlt aber:

| Stack | Fehlende Excludes | Fehlende Includes (für Focus) |
|-------|-------------------|-------------------------------|
| Shopify | `*.min.js`, `assets/*.css` (compiled) | `sections/`, `snippets/`, `config/` |
| Nuxt | `node_modules/.cache/` | `composables/`, `server/api/` |
| Next | `public/` (static assets) | `app/`, `middleware.ts` |
| Laravel | `public/build/` (Vite output) | `routes/`, `config/`, `database/migrations/` |
| Shopware | `public/theme/` | `custom/plugins/*/src/` |

### Repomix `topFilesLength` Feature

Repomix hat einen `topFilesLength` Parameter der die Output-Größe begrenzt. Statt alle 211 Files:
- `topFilesLength: 30` → nur die 30 meistgeänderten Files (Git-History-basiert)
- Perfekt für Context-Generierung: die aktivsten Files sind die architekturrelevantesten

### Gesamtempfehlung für Config-System

1. **Dual-Config einführen** — `repomix.config.json` (full) + `repomix-context.config.json` (lean)
2. **Template für Zielprojekte**: `repomix-context.config.json` mit stack-aware Excludes generieren
3. **`.repomixignore` erweitern**: Fehlende Stack-Patterns nachrüsten
4. **Spec 131 anpassen**: Agent liest `repomix-context.xml` (lean) statt den vollen Snapshot
5. **`topFilesLength: 30`** in der Context-Config nutzen

---

## Gesamtranking: Was tun?

| # | Maßnahme | Wert ★ | Aufwand | Empfehlung |
|---|----------|--------|---------|------------|
| 1 | **Spec 131 umsetzen + Snapshot-Reduktion** | ★★★★★ | Medium | JA — löst das Kernproblem (Qualität + Deduplizierung) |
| 2 | **Repomix-Config stack-aware machen** | ★★★★ | Klein | JA — massiver Qualitätsgewinn bei minimalem Aufwand |
| 3 | **context-refresher → Sonnet upgraden** | ★★★ | Trivial | JA — ein Wort ändern, aber nur wenn 131 nicht umgesetzt wird |
| 4 | **Staleness-Detection erweitern** | ★★ | Klein | Kann — nice to have, nicht kritisch |
| 5 | **Context-Validierung** (automated quality check) | ★★ | Medium | Später — erst wenn die Generierung selbst besser ist |
| 6 | **Zweite repomix-Config für Context** | ★★★★ | Klein | JA — wenn 131 umgesetzt wird, als Teil davon |

---

## Empfehlung

**Spec 131 ist der richtige Ansatz, braucht aber ein Upgrade:**

1. Repomix-Snapshot für Context-Generierung auf ~50-80KB begrenzen (separate Config oder Include-Filter)
2. Agent nutzt Option B/C: Liest die komprimierte Map, dann selektiv Key-Files
3. Stack-aware Filterung in der Template-Config
4. Sonnet statt Haiku für den Context-Agent (läuft nur 1x pro Setup)
5. `/context-full` Command wird zum manuellen Trigger für Re-Generierung (statt context-refresher)

Das eliminiert:
- Die One-Shot-Generierung (ersetzt durch Agent)
- Den context-refresher (ersetzt durch project-context Agent)
- Die zu-große-Snapshot-Problematik (separate Config)
- Die blinde Fragment-Sammlung (Agent hat echten Codebase-Überblick)
