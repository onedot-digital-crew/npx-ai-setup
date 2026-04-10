# Setup-Optimierung: Was fehlt für maximale Effizienz

## Context

Das Setup ist solide: 6-Layer Token-Optimierung, 26 Hooks, tiered context loading, prep-script Green-Paths, RTK, model routing. Trotzdem gibt es 9 konkrete Lücken — von echten Bugs bis zu stillschweigend inaktiven Features.

---

## Befunde nach Priorität

### 1. `.mcp.json` ist leer — context7 fehlt (HIGH TOKEN IMPACT)

**Problem:** CLAUDE.md und docs/token-optimization.md verweisen auf Context7 MCP für Library-Docs, aber `.mcp.json` hat `"mcpServers": {}`. Der `tool-redirect.sh`-Hook leitet WebFetch-Calls um, aber ohne MCP-Server läuft alles über WebFetch — nicht über das token-effiziente Context7.

**Fix:** `context7` und `memory` (offizieller Anthropic Memory MCP) in `.mcp.json` und `templates/mcp.json` eintragen.

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    }
  }
}
```

---

### 2. `graph.json` existiert nicht — graph-context.sh ist inaktiv (MEDIUM TOKEN IMPACT)

**Problem:** `graph-context.sh` läuft bei jedem Read/Edit und gibt Dependency-Kontext in <50ms — aber nur wenn `.agents/context/graph.json` existiert. Die Datei fehlt. Hook exitiert immer mit `exit 0` ohne Output.

**Fix:** `/analyze` ausführen um `graph.json` zu generieren. Das aktiviert sofort den graph-context.sh Hook und ersetzt grep-heavy Codebase-Navigation durch 20-Token-Lookups.

---

### 3. Dead code: delegate-codex.sh + delegate-gemini.sh (CLARITY)

**Problem:** AUDIT.md dokumentiert diese als Dead Code (D1, D2), aber sie liegen noch in `.claude/scripts/` und `templates/scripts/`. Codex ist seit 2023 deprecated; das npm-Paket für Gemini existiert nicht.

**Fix:** Beide Dateien aus `.claude/scripts/` und `templates/scripts/` löschen. Aktualisiert AUDIT.md (diese Einträge entfernen).

---

### 4. Bug: protect-files.sh blockiert environment.md (CORRECTNESS C3)

**Problem:** `protect-files.sh:8` prüft auf Substring `env` — blockiert dadurch auch `environment.md`, `environments/`, etc. Steht als C3 im AUDIT.

**Datei:** `.claude/hooks/protect-files.sh` und `templates/claude/hooks/protect-files.sh`

**Fix:** Pattern von Substring-Match auf exakten Dateinamen-Match ändern:
```bash
# Vorher (blockiert zuviel):
case "$FILE_PATH" in *env*) ...

# Nachher (nur .env Dateien):
case "$FILE_PATH" in .env|.env.*|**/.env|**/.env.*) ...
```

---

### 5. Bug: memory-recall.sh Cache-Expiry-Warning geht nach stderr, nicht zu Claude (RELIABILITY)

**Problem:** In `memory-recall.sh:21` wird die "Prompt-Cache abgelaufen"-Warnung mit `echo ... >&2` ausgegeben — geht also nur ins Terminal, nicht als `additionalContext` zu Claude. Claude sieht die Warnung nie.

**Fix:** Output auf stdout als JSON umstellen:
```bash
printf '{"additionalContext": "[CACHE EXPIRED] %dmin idle — prompt cache abgelaufen. Dieser Turn kostet 10x mehr."}\n' "$IDLE_MIN"
```

---

### 6. Fehlende YAML-Frontmatter in AUDIT.md und PATTERNS.md (CONTEXT LOADING)

**Problem:** `context-loader.sh` lädt nur Dateien mit YAML-Frontmatter (`---` in Zeile 1). AUDIT.md und PATTERNS.md haben kein Frontmatter → werden bei Session-Start nie geladen. Wichtige Hotspot- und Pattern-Infos fehlen in L0.

**Fix:** Frontmatter-Abstracts zu `.agents/context/AUDIT.md` und `.agents/context/PATTERNS.md` hinzufügen:

```yaml
---
abstract: "Known issues: 5 HIGH security, 7 reliability, 5 correctness bugs. Hotspots: tui.sh, update.sh, setup.sh."
sections:
  - "Security: json.sh injection, notify.sh command injection, setup-skills.sh eval"
  - "Reliability: npm exit code unchecked, generate.sh set+e, temp leaks"
  - "Dead code: delegate-codex.sh, delegate-gemini.sh"
---
```

---

### 7. Security HIGH: notify.sh unescaped vars (SECURITY S2)

**Problem:** AUDIT S2 — `notify.sh` interpoliert Variablen direkt in `osascript`/`notify-send` Kommandos → Command Injection möglich.

**Datei:** `.claude/hooks/notify.sh` und `templates/claude/hooks/notify.sh`

**Fix:** Variablen durch `printf %q` escapen oder `osascript -e "display notification $(printf %q "$MSG")"` verwenden.

---

### 8. Unangewendetes Learning: sync_boilerplate() Bug (CORRECTNESS)

**Problem:** `LEARNINGS.md` enthält: `sync_boilerplate() muss get_boilerplate_repo() prüfen bevor pull_boilerplate_files() aufgerufen wird`. Das wurde nie in Code umgesetzt — steht noch in LEARNINGS.md unter "## Corrections", nicht unter "## Applied".

**Fix:** `lib/boilerplate.sh` patchen um `get_boilerplate_repo()` zu prüfen, dann Entry nach `## Applied` verschieben.

---

### 9. Fehlender `ci-prep.sh` Green-Path (TOKEN EFFICIENCY)

**Problem:** CLAUDE.md empfiehlt `! gh pr checks` als Zero-Token CI-Check. Aber es gibt kein `ci-prep.sh` im Muster der anderen Prep-Scripts (mit Green-Path-Exit `ALL_CHECKS_PASSED`). Dadurch kein einheitliches Muster.

**Fix:** `.claude/scripts/ci-prep.sh` + `templates/scripts/ci-prep.sh` erstellen:
```bash
#!/usr/bin/env bash
# Green path: "ALL_CHECKS_PASSED" → 0 tokens
gh pr checks --watch 2>/dev/null | tail -1 | grep -q "All checks were successful" && echo "ALL_CHECKS_PASSED" && exit 0
# ... failures only output
```

---

## Abhängigkeiten & Reihenfolge

```
Dead Code entfernen (3)
       ↓
Bug Fixes (4, 5, 7, 8) — unabhängig voneinander, parallel machbar
       ↓
Context Improvements (6) — AUDIT.md/PATTERNS.md Frontmatter
       ↓
MCP Setup (1) — .mcp.json + templates/mcp.json
       ↓
graph.json generieren (2) — /analyze ausführen
       ↓
ci-prep.sh (9) — neues Script
```

Items 3-8 betreffen ausschließlich existierende Dateien. Item 1 fügt .mcp.json Content hinzu. Item 9 ist ein neues Script.

---

## Verification

Nach allen Änderungen:
1. `bash .claude/scripts/doctor.sh` — Health Check
2. `bash tests/smoke.sh` — Smoke Tests  
3. Neues Projekt mit `npx @onedot/ai-setup` aufsetzen → context7 in `.mcp.json` prüfen
4. `graph-context.sh` testen: eine Datei öffnen, `[GRAPH]` im additionalContext prüfen
5. `notify.sh` testen: Notification triggern, kein Command-Injection-Risiko
6. AUDIT.md nach Session-Start auf Erscheinen in context-loader Output prüfen

---

## Kritische Dateien

| Datei | Änderung |
|-------|----------|
| `.mcp.json` | context7 Server eintragen |
| `templates/mcp.json` | context7 Server eintragen |
| `.claude/hooks/protect-files.sh` | env Substring-Bug fixen |
| `templates/claude/hooks/protect-files.sh` | env Substring-Bug fixen |
| `.claude/hooks/notify.sh` | Variable escaping |
| `templates/claude/hooks/notify.sh` | Variable escaping |
| `.claude/hooks/memory-recall.sh` | stderr → stdout JSON |
| `templates/claude/hooks/memory-recall.sh` | stderr → stdout JSON |
| `.agents/context/AUDIT.md` | YAML frontmatter hinzufügen |
| `.agents/context/PATTERNS.md` | YAML frontmatter hinzufügen |
| `.claude/scripts/delegate-codex.sh` | Löschen |
| `.claude/scripts/delegate-gemini.sh` | Löschen |
| `templates/scripts/delegate-codex.sh` | Löschen |
| `templates/scripts/delegate-gemini.sh` | Löschen |
| `lib/boilerplate.sh` | sync_boilerplate guard hinzufügen |
| `.agents/context/LEARNINGS.md` | Correction als Applied markieren |
| `.claude/scripts/ci-prep.sh` | Neu erstellen |
| `templates/scripts/ci-prep.sh` | Neu erstellen |
