# @onedot/ai-setup

AI-Infrastruktur fuer Projekte: Claude Code, GSD, Memory Bank, Hooks.
Ein Command erstellt das komplette Setup, dann analysiert Claude den Code und befuellt alles automatisch.

## Installation

```bash
npx @onedot/ai-setup
```

## Was wird erstellt?

| Datei/Ordner | Funktion |
|-------------|----------|
| `memory-bank/` | Lean Memory Bank (projectbrief + systemPatterns) |
| `CLAUDE.md` | AI-Regeln + Critical Rules |
| `.claude/settings.json` | Granulare Permissions + Hooks |
| `.claude/hooks/` | Auto-Lint, File Protection, Circuit Breaker |
| `.claude/init-prompt.md` | Auto-Init Prompt fuer Claude |
| `.github/copilot-instructions.md` | Copilot-Kontext |
| `AI-SETUP.md` | Ausfuehrliche Dokumentation |

## Requirements

- Node.js >= 18
- npm
- jq (`brew install jq`)
- Claude Code CLI (optional, fuer Auto-Init)

## Dokumentation

Siehe [AI-SETUP.md](templates/AI-SETUP.md) fuer Workflow, Commands und FAQ.
