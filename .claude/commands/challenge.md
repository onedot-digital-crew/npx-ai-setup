---
model: sonnet
allowed-tools: Read, Glob, Grep
---

Challenge and critically evaluate this feature idea before any implementation: **$ARGUMENTS**

## Process

### Phase 1 — Restate the Idea
Summarize the proposed feature in 1-2 sentences in your own words to confirm understanding.

### Phase 2 — Concept Fit
Read `docs/CONCEPT.md` now. Then answer:
- Does this align with the project's core principles: **one command, zero config, template-based**?
- Does it fit the "templates not generation" distinction?
- Would this belong in the scaffolding layer, or is it scope creep?

Rate concept fit: **ALIGNED / BORDERLINE / MISALIGNED**

### Phase 3 — Necessity
Is this actually needed? Challenge it hard:
- What problem does it solve? Is that problem real or hypothetical?
- What happens if we don't build it? Can users work without it?
- Is this solving a problem that users have reported, or a problem we imagined?

### Phase 4 — Overhead & Maintenance Cost
- How much ongoing maintenance does this add?
- Does it increase the surface area of the tool (more flags, more config, more docs)?
- What breaks if this feature has a bug?
- Does it add complexity that slows down the "one command" promise?

### Phase 5 — Complexity & Risks
- How many files need to change?
- Does this require new dependencies?
- What edge cases or failure modes exist?
- Does this interact with hooks, agents, or the CLI in unexpected ways?

### Phase 6 — Simpler Alternatives
List 1-3 alternatives, including:
- A simpler version of the same idea (scope reduction)
- A workaround that avoids building anything new
- **"Don't build it"** — explicitly state this as an option if it applies

Also scan the codebase with Glob and Grep to check if similar functionality already exists.

### Phase 7 — Verdict

Choose exactly one:

**GO** — Concept fits, clearly needed, manageable complexity. Recommend proceeding.

**SIMPLIFY** — The idea has merit but the proposed scope is too large. State the smaller version worth building.

**REJECT** — Misaligned with concept, unnecessary, or adds unjustified overhead. State the reason explicitly.

---

## Rules
- Be direct and skeptical. The default stance is skepticism, not encouragement.
- Do NOT modify any files.
- Cite specific lines from `docs/CONCEPT.md` when evaluating concept fit.
- The verdict must be unambiguous — no "it depends" conclusions.
