---
name: ais:spec-verify
description: "Visual browser verification for frontend specs via MCP Playwright. Triggers: /spec-verify NNN, 'verify spec NNN in browser', 'browser check spec NNN', 'visually verify spec NNN'."
model: sonnet
---

Runs a visual browser check for spec $ARGUMENTS against a live dev server using MCP Playwright.

## Process

### 1. Find the spec
If `$ARGUMENTS` is a number, open `specs/NNN-*.md`. If empty, list specs with status `completed` or `in-review` and ask.

### 2. Detect frontend files
Scan `Files to Modify` section of the spec. Check if any file matches:
`.tsx`, `.jsx`, `.vue`, `.svelte`, `.css`, `.scss`, `.html`, `.twig`

If no frontend files found: report "No frontend files in this spec — /spec-verify not applicable." and stop.

### 3. Ask for route
`AskUserQuestion`: "Which route should be verified? (e.g. /dashboard, /products/123)"
Use the answer as the target URL path.

### 4. Dev server check
Run: `curl -s -o /dev/null -w "%{http_code}" http://localhost:3000` (try common ports: 3000, 4000, 8080, 5173)

**Server already running**: proceed to Step 5.

**Server not running**:
1. Read `package.json` → find start/dev command (prefer `dev`, then `start`, then `serve`)
2. Start server: `! npm run dev > /tmp/spec-verify-server.log 2>&1 & echo $! > /tmp/spec-verify-server.pid`
3. Wait for server: poll `curl` every 2s, max 30s. If no response after 30s → kill via PID file, report failure, stop.
4. Note PID file path for cleanup in Step 7.

### 5. Navigate and verify
Using MCP Playwright tools:

1. `browser_navigate` → `http://localhost:<port><route>`
2. `browser_snapshot` → capture accessibility snapshot
3. `browser_take_screenshot` → visual capture
4. Check for: console errors (`browser_console_messages`), visible error states, broken layout indicators (overflow, 0-height containers)
5. If the spec mentions interactive elements (buttons, forms, modals): perform 1-2 key interactions via `browser_click` or `browser_fill_form`, take another screenshot

### 6. Report result

**PASS** — No console errors, page renders, key elements visible:
```
spec-verify NNN: PASS
Route: /example
Screenshots: taken
Interactions: [what was tested]
No console errors detected.
```

**CONCERNS** — Issues found:
```
spec-verify NNN: CONCERNS
Route: /example
Issues:
  - Console error: [message]
  - Element [selector] not visible
  - [other finding]
Screenshots: taken
Next: If this is a CMS project (Shopware, Shopify, Storyblok etc.) — check MCP server for content/config issues: missing fields, unpublished entries, wrong slugs.
```

### 7. Cleanup
If server was started by this skill: `! kill $(cat /tmp/spec-verify-server.pid) 2>/dev/null && rm -f /tmp/spec-verify-server.pid /tmp/spec-verify-server.log`

## Rules
- MCP Playwright must be configured globally — if tools unavailable, report and stop.
- Never commit or modify files.
- Port detection: try 3000, 5173, 4000, 8080 in that order.
- Screenshot filenames are not saved to disk — they appear inline in the chat only.

## Next Step

- PASS: `> ⚡ Naechster Schritt: /commit — Changes committen`
- CONCERNS: `> 🔧 Naechster Schritt: Issues fixen, dann /spec-verify NNN erneut`
