# Code Reuse (Pflicht vor jedem Edit)

Vor neuer Funktion, Helper, Type, Component, Service oder Konstante: **scannen ob es das schon gibt**. Eigene Erfindung nur wenn Suche leer.

## Pflicht-Scan (≥1 Treffer = wiederverwenden, nicht neu bauen)

Vor jeder neuen Definition:

```bash
# Funktionen / Helper / Methoden
grep -r "<name>\|<altName>" --include="*.{ts,js,vue,php,liquid,py,rb,go}" .

# Types / Interfaces / Klassen
grep -rn "type <Name>\|interface <Name>\|class <Name>" .

# Composables / Hooks / Services
grep -rn "use<Name>\|<Name>Service" .
```

Treffer? → importieren/erweitern. Kein Treffer? → weiter mit "Where to put what".

## Where to put what (stack-agnostisch)

Erkenne Layer am Repo, nicht an Pfad-Annahmen. Typische Locations:

| Was                                | Wohin (Repo-typisch)                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| Pure Helper (kein State, kein I/O) | `utils/`, `lib/`, `helpers/`, `src/utils/`, `app/utils/`     |
| Reactive Logic / Side-Effects      | `composables/`, `hooks/`, `services/` (Framework-spezifisch) |
| Types / Interfaces / Schemas       | `types/`, `*.d.ts`, `schemas/`, `contracts/`                 |
| Konstanten / Enums                 | `constants/`, `config/`, `enums/`                            |
| Geteilte UI-Logik                  | `components/shared/`, `components/ui/`                       |
| API-Calls / Data-Fetching          | `api/`, `services/`, `repositories/`                         |
| Domain-Logic                       | `domain/`, `core/`, `features/<name>/`                       |

**Heuristik:** `ls` im Repo-Root + `ls src/` + `ls app/` zeigt vorhandene Layer. Nutze die — keine neuen erfinden.

## Bevor du eine Datei anlegst

1. `ls <vermuteter-Layer>/` — existiert ähnliche Datei?
2. `grep -rn "<Domain-Keyword>"` — existiert verwandte Logic?
3. Bei Treffer → Datei erweitern, nicht neue anlegen

## Anti-Pattern (häufige Cloud-Agent-Fehler)

- **Helper inline in Component** wenn 2+ Stellen ihn brauchen (sofort raus in `utils/`)
- **Eigener Type** wenn Library typed Definitions liefert (`grep` in `types/`, `*.d.ts`, `node_modules/<lib>/types/`)
- **`unknown` + Cast** wenn ein typed Import möglich ist
- **Re-implement** statt Import (z.B. eigener `debounce`, `isEmpty`, `pick` — meist schon im Projekt oder via lodash-es / radash)
- **Neue Konstante** ohne `grep` ob sie woanders schon existiert (Magic Numbers, URLs, Config-Keys)
- **Neuer Naming-Stil** der zur restlichen Codebase nicht passt (camelCase vs snake_case vs kebab-case)

## Naming Match (Pflicht)

Existierende Files im selben Layer als Vorlage. Beispiele:

```bash
ls composables/        # use* Prefix? camelCase? PascalCase?
ls components/         # PascalCase? kebab-case Files?
ls utils/              # camelCase Files? Single-purpose Files?
```

Neuer Code muss zum bestehenden Stil passen. Nie neuen Stil einführen ohne expliziten User-Beschluss.

## Package-Inventory (Pflicht vor neuem Helper)

Bevor du eine Util-Funktion selbst schreibst: **prüfe installierte Dependencies**. Häufiger Fehler — Cloud-Agent baut eigenes `debounce`, obwohl `lodash-es` oder `vueuse` schon installiert sind.

### Quick-Scan pro Stack

```bash
# JS/TS — alle Deps inkl. devDeps
jq -r '.dependencies, .devDependencies | keys[]' package.json 2>/dev/null

# PHP/Laravel — Composer
jq -r '.require, ."require-dev" | keys[]' composer.json 2>/dev/null

# Python
cat requirements*.txt pyproject.toml 2>/dev/null | grep -E "^[a-zA-Z]"

# Ruby
cat Gemfile 2>/dev/null | grep "^gem"

# Go
grep "^require" go.mod 2>/dev/null
```

### Häufige Util-Libs pro Stack (vor eigenem Helper checken)

| Function                                                    | Library — bevorzugt nutzen      |
| ----------------------------------------------------------- | ------------------------------- |
| `debounce`, `throttle`, `pick`, `omit`, `groupBy`, `uniq`   | `lodash-es`, `radash`           |
| `useDebounce`, `useFetch`, `useStorage`, `useEventListener` | `@vueuse/core`                  |
| Date-Format, `addDays`, `formatDistance`                    | `date-fns`, `dayjs`             |
| Schema-Validation                                           | `zod`, `yup`, `joi`             |
| HTTP-Client                                                 | `axios`, `ofetch`, `ky`         |
| Type-Guards (`isNil`, `isEmpty`)                            | `lodash-es`, `radash`, `remeda` |
| String-Casing (`camelCase`, `kebabCase`)                    | `lodash-es`, `change-case`      |
| UUID                                                        | `nanoid`, `uuid`                |
| Slugify                                                     | `slugify`, `slug`               |

### Workflow

1. `jq` Deps lesen (siehe Quick-Scan)
2. Match gegen Function — Lib installiert? → importieren
3. Lib nicht installiert, aber Function ist Standard-Util? → User fragen ob Lib hinzufügen statt eigenen Helper
4. Wirklich projektspezifisch + nirgends sonst nutzbar? → eigener Helper im richtigen Layer (siehe Where-to-put)

### Anti-Pattern

- Eigenes `debounce` schreiben obwohl `lodash-es` in `package.json`
- Eigene Date-Math obwohl `date-fns` installiert
- Eigene Schema-Validation obwohl `zod` da ist
- `lodash` (full) importieren statt `lodash-es` Tree-shake-friendly

## Type-Reuse (TS/PHP/Python typed)

Vor `interface X`, `type X`, `class X`:

```bash
grep -rn "interface X\|type X\|class X" .
# Plus: Library-Types prüfen
find node_modules -name "*.d.ts" 2>/dev/null | xargs grep -l "X" | head -3
# PHP: composer Vendor-Types
grep -rn "X" vendor/ 2>/dev/null | head -5
```

Wenn Lib einen Type liefert → importieren, nicht neu definieren.

## Trigger-Skip

Skip Code-Reuse-Scan nur wenn:

- One-shot Bash-Operation (kein File-Edit)
- Refactor von **bestehender** Funktion (kein neuer Code)
- User-Instruktion explizit "neu von Grund auf"

## Verstoss-Folge

Wird in Code-Review erkannt → Rework-Loop. Vorab-Scan kostet 5s, Rework kostet 5min + Review-Zyklus.

## Verbindung zu anderen Rules

- External-Verification (`external-verification.md`): fremde Lib-Types vorab via Context7 verifizieren — DANN Code-Reuse-Scan ob im Projekt schon Wrapper existiert
- Quality (`quality.md`): "No dead code, no magic numbers" — Reuse statt Duplikat
- Conventions (`.agents/context/CONVENTIONS.md`): Naming-Style Pflicht-Match
