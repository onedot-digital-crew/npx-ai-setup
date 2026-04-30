# Code Reuse (Pflicht vor jedem Edit)

Vor neuer Funktion/Type/Helper/Konstante: scannen ob es das schon gibt — im Projekt oder in installierten Deps. Eigener Code nur wenn beide leer.

## 1. Projekt-Scan

```bash
# Funktion / Helper / Composable / Type / Klasse
grep -rn "<name>" --include="*.{ts,js,vue,php,liquid,py,rb,go}" .
grep -rn "type <Name>\|interface <Name>\|class <Name>\|use<Name>" .
```

Treffer → importieren/erweitern, niemals duplizieren.

## 2. Package-Inventory

Vor eigenem Util **immer** Deps prüfen — Cloud-Agent-Klassiker: eigenes `debounce` trotz lodash-es im `package.json`.

```bash
jq -r '.dependencies, .devDependencies | keys[]' package.json 2>/dev/null
jq -r '.require, ."require-dev" | keys[]' composer.json 2>/dev/null
cat requirements*.txt pyproject.toml Gemfile go.mod 2>/dev/null
```

| Brauchst du...                                                 | Bevorzugt nutzen wenn installiert |
| -------------------------------------------------------------- | --------------------------------- |
| `debounce`/`throttle`/`pick`/`omit`/`groupBy`/`uniq`/`isEmpty` | `lodash-es`, `radash`, `remeda`   |
| `useDebounce`/`useFetch`/`useStorage`/`useEventListener`       | `@vueuse/core`                    |
| Date-Math, Format                                              | `date-fns`, `dayjs`               |
| Schema-Validation                                              | `zod`, `yup`, `joi`               |
| HTTP-Client                                                    | `ofetch`, `axios`, `ky`           |
| String-Casing                                                  | `change-case`, `lodash-es`        |
| UUID / Slug                                                    | `nanoid`, `slugify`               |

Lib fehlt aber Function ist Standard-Util? → User fragen ob Lib hinzufügen, **bevor** eigener Helper.

## 3. Where to put what

| Was                           | Layer (typisch)                       |
| ----------------------------- | ------------------------------------- |
| Pure Helper (kein State)      | `utils/`, `lib/`, `helpers/`          |
| Reactive Logic / Side-Effects | `composables/`, `hooks/`, `services/` |
| Types / Schemas               | `types/`, `*.d.ts`, `schemas/`        |
| Konstanten / Enums            | `constants/`, `config/`               |
| API / Data-Fetching           | `api/`, `services/`, `repositories/`  |

Heuristik: `ls` Repo-Root + `ls src/` + `ls app/` zeigt Layer. Keine neuen erfinden.

## 4. Naming Match

```bash
ls <layer>/   # camelCase? kebab-case? use*-Prefix?
```

Neuer Code = Stil des Layers. Nie neuen Stil einführen ohne User-Beschluss.

## Anti-Pattern

- Helper inline in Component wenn 2+ Stellen ihn brauchen
- Eigener Type wenn Lib typed Definitions liefert (`unknown` + Cast = Red Flag)
- Re-implement Standard-Util (`debounce`, `pick`, `isEmpty`) statt Dep-Import
- Magic Number / URL / Config-Key ohne `grep` ob existiert
- `lodash` (full) statt `lodash-es` (tree-shake)

## Skip

Refactor bestehender Funktion · One-shot Bash · User sagt explizit "neu von Grund auf".
