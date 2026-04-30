# External Verification

Pflicht in jeder Plan-Phase (Spec, Explore, Discover, Architecture, Feature-Design) **bevor** Code entsteht.

## Wann Context7 Pflicht

Trigger — sobald **einer** zutrifft, C7-Lookup vorab:

- Lib/Framework/SDK/CLI/Cloud-Service genannt (Vue, Nuxt, Storyblok, Shopify, Laravel, Next, Tailwind, etc.)
- Built-in Filter/Property/Helper einer fremden Engine touched (Liquid `image_url`, `aspect_ratio`; Vue `defineProps`; Nuxt `useFetch`)
- Filter-Math oder Type-Coercion (Liquid `times: 1.0` Float-Bug, Vue ref vs reactive)
- Neue Dependency, Version Bump, Major-Migration
- API-Signatur, Endpoint, Schema einer fremden API
- Composable/Hook/Helper aus `node_modules`

## Wann Skip

- Eigener Code, eigene Components, Business-Logic
- Bash, Config, eigene Utils
- User-provided URL (dann WebFetch direkt, kein C7)
- Refactor ohne API-Touch

## Wie dokumentieren

Spec/Plan bekommt Section `## External References`:

```
## External References
- <lib>: <topic> — Source: Context7 /<org>/<project>
  - Verified fact 1 (e.g. "image.aspect_ratio returns Float")
  - Verified fact 2
```

Ein Eintrag pro System. Stichpunkte = verifizierte Facts die Implementer braucht.

## Workflow

1. Plan-Draft schreiben
2. Externe Systeme markieren (siehe Trigger)
3. Pro System: `resolve-library-id` → `query-docs` (max 2 Topics pro Lookup)
4. Section `## External References` füllen
5. Erst dann Approval / Implementation

## Anti-Pattern

- "Kenne ich, brauche kein C7" — Pattern-Match-Bug. Training-Data staled.
- C7 erst nach Review — Kostet Loop. Vorab macht Review unnötig.
- Lookup ohne Doku im Plan — Implementer sieht's nicht, Bug kehrt zurück.

## Cap

Max 2 C7-Lookups pro Spec. Mehr → Spec splitten (zu viele externe Systeme = zu großer Scope).

## Fallback

C7 hat keinen Match → WebFetch/WebSearch + Quelle dokumentieren. Fallback explizit nennen: `Source: WebFetch <url> (kein C7-Match)`.
