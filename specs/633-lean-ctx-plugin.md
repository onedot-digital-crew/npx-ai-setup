# Spec: lean-ctx Opt-in Plugin Integration

> **Spec ID**: 633 | **Created**: 2026-04-13 | **Status**: draft | **Complexity**: low | **Branch**: feat/lean-ctx-plugin

## Goal
lean-ctx als optionales Plugin in npx-ai-setup integrieren -- Detection, MCP-Config, CLAUDE.md-Rules. RTK bleibt primaer fuer CLI-Compression, lean-ctx ergaenzt mit MCP-basiertem Read-Caching.

## Context
Research 632 zeigt: lean-ctx ist komplementaer zu RTK. RTK optimiert CLI-Output (git, npm, cargo), lean-ctx optimiert File-Reads via MCP-Tools (Session-Caching, AST-Signatures, Entropy-Filtering). Beide zusammen decken den gesamten Token-Flow ab.

Entscheidung aus Interview: Opt-in Plugin, ergaenzend (nicht ersetzend), native Read/Grep bleiben als Fallback verfuegbar.

## Steps

- [ ] Step 1: `install_lean_ctx()` Funktion in `lib/plugins.sh` erstellen
  - Detection: `command -v lean-ctx` pruefen
  - Wenn nicht installiert: Info-Zeile mit Install-Link (`cargo install lean-ctx` / `npm install -g lean-ctx-bin`)
  - Wenn installiert: MCP-Config in `.mcp.json` mergen + CLAUDE.md-Rules injizieren

- [ ] Step 2: MCP-Config-Template erstellen
  - Server-Name: `lean-ctx`
  - Command: `lean-ctx mcp`
  - In `.mcp.json` mergen (wie Context7-Pattern)

- [ ] Step 3: CLAUDE.md-Rules-Section schreiben
  - Ergaenzende Empfehlung (nicht ersetzend): "Prefer ctx_read for large files, use native Read for files you will edit"
  - Kompatibilitaets-Hinweis: "Edit/Write/Glob bleiben unveraendert"
  - Max 5 Zeilen (Token-Budget beachten)

- [ ] Step 4: `.claude/rules/mcp.md` Template um lean-ctx-Eintrag erweitern
  - Neue Zeile in "Expected Global Servers" Tabelle
  - Oder eigene Section "Optional MCP Servers"

- [ ] Step 5: `install_lean_ctx` in Setup-Flow einbinden
  - Nach `install_context7()` aufrufen
  - In `show_installation_summary()` lean-ctx-Status anzeigen

- [ ] Step 6: Tests
  - Integration-Test: Setup mit/ohne lean-ctx Binary im PATH
  - Verify: `.mcp.json` enthaelt lean-ctx Config wenn Binary vorhanden
  - Verify: `.mcp.json` unveraendert wenn Binary nicht vorhanden
  - Verify: CLAUDE.md enthaelt Rules-Section wenn Binary vorhanden

## Acceptance Criteria
- [ ] `npx ai-setup` mit installiertem lean-ctx: `.mcp.json` enthaelt `lean-ctx` Server-Config
- [ ] `npx ai-setup` ohne lean-ctx: keine lean-ctx-Referenzen in Config-Dateien, nur Info-Zeile im Output
- [ ] CLAUDE.md-Rules-Section ist max 5 Zeilen und empfiehlt lean-ctx ergaenzend (nicht ersetzend)
- [ ] RTK tool-redirect.sh Hook funktioniert weiterhin unveraendert
- [ ] `bash -n lib/plugins.sh` hat keine Syntax-Fehler
- [ ] Bestehende Integration-Tests passen weiterhin

## Files to Modify
- `lib/plugins.sh` - neue `install_lean_ctx()` Funktion + Aufruf in Summary
- `templates/CLAUDE.md` - optionale lean-ctx Rules-Section (nur wenn installiert)
- `templates/claude/rules/mcp.md` - lean-ctx in MCP-Server-Tabelle

## Out of Scope
- lean-ctx Binary automatisch installieren (User-Verantwortung)
- RTK ersetzen oder modifizieren
- PreToolUse Hook fuer Read-to-ctx_read Rewriting (lean-ctx macht das selbst via eigenen Hook)
- lean-ctx Shell-Compression (RTK bleibt dafuer zustaendig)
- Dashboard/TUI Features von lean-ctx
