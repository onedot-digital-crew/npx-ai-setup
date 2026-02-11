Analyze this project and populate the AI configuration:

1. **memory-bank/projectbrief.md** (via Bash, is write-protected):
   - Read package.json, README.md, and the main source files
   - Document: Goal, Tech Stack (with versions), Architecture, Constraints

2. **memory-bank/systemPatterns.md**:
   - Read the main source files (entry points, base classes, config)
   - Document: Architecture Decisions, Coding Standards, Key Patterns
   - Focus on patterns that emerge from the code, not theory

3. **CLAUDE.md** - Add two sections:
   - **"## Commands"**: Read package.json scripts, document the most important ones (dev, build, lint, test)
   - **"## Critical Rules"**: Analyze linting config (eslint, prettier, etc.)
   - Identify framework-specific patterns (e.g. Liquid, React, Vue)
   - Write concrete, actionable rules (no generic best practices)
   - Keep it short: max 5 sections, 3-5 bullet points each

4. **Search and install skills**:
   - Read package.json for the tech stack (e.g. react, vue, shopify, tailwind)
   - Search: `npx skills find <framework>` for each detected technology
   - Show found skills and ask which ones to install
   - Install with: `npx skills add <owner/repo@skill> --agent claude-code --agent github-copilot -y`

Rules:
- Write ONLY what you see in the code, no assumptions
- No umlauts in files (ae, oe, ue instead)
- Keep all files under 60 lines
- Confirm with "Done" when finished
