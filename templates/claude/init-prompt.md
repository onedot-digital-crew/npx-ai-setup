Analysiere dieses Projekt und befuelle die AI-Konfiguration:

1. **memory-bank/projectbrief.md** (via Bash, ist write-protected):
   - Lies package.json, README.md, und die wichtigsten Source-Dateien
   - Dokumentiere: Goal, Tech Stack (mit Versionen), Architecture, Constraints

2. **memory-bank/systemPatterns.md**:
   - Lies die wichtigsten Source-Dateien (Entry Points, Base Classes, Config)
   - Dokumentiere: Architecture Decisions, Coding Standards, Key Patterns
   - Fokus auf Patterns die sich aus dem Code ergeben, nicht auf Theorie

3. **CLAUDE.md** - Ergaenze zwei Sektionen:
   - **"## Commands"**: Lies package.json scripts, dokumentiere die wichtigsten (dev, build, lint, test)
   - **"## Critical Rules"**: Analysiere Linting-Config (eslint, prettier, etc.)
   - Identifiziere Framework-spezifische Patterns (z.B. Liquid, React, Vue)
   - Schreibe konkrete, actionable Rules (keine generischen Best Practices)
   - Halte es kurz: max 5 Sektionen, je 3-5 Bullet Points

4. **Skills suchen und installieren**:
   - Lies package.json fuer den Tech Stack (z.B. react, vue, shopify, tailwind)
   - Suche: `npx skills find <framework>` fuer jede erkannte Technologie
   - Zeige gefundene Skills und frage welche installiert werden sollen
   - Installiere mit: `npx skills add <owner/repo@skill> --agent claude-code --agent github-copilot -y`

Regeln:
- Schreibe NUR was du im Code siehst, keine Annahmen
- Keine Umlaute in Dateien (ae, oe, ue statt ae, oe, ue)
- Halte alle Dateien unter 60 Zeilen
- Bestaetige mit "Done" wenn fertig
