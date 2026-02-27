---
model: sonnet
allowed-tools: Bash, Read
---

Generate a compressed full-codebase snapshot using repomix.

## Steps

1. **Run repomix** with tree-sitter compression:

```bash
_t=""; command -v timeout &>/dev/null && _t="timeout 120"; command -v gtimeout &>/dev/null && _t="gtimeout 120"
$_t npx -y repomix --compress --style markdown \
  --ignore "node_modules,dist,.git,.next,.nuxt,coverage,.turbo,*.lock,*.lockb" \
  --output .agents/repomix-snapshot.md
```

If repomix fails (not available, permission error), report the error and stop.

2. **Report token count**: After completion, run:

```bash
wc -l .agents/repomix-snapshot.md
```

Report: "Snapshot written to `.agents/repomix-snapshot.md` — [N] lines."

3. **Read the snapshot** and give a 3-5 sentence summary of what the codebase contains: key modules, entry points, notable patterns.

## Rules

- Do NOT read every file manually — repomix handles the aggregation.
- Do NOT commit `.agents/repomix-snapshot.md` — it is gitignored.
- The snapshot is a read-only artifact. Do not modify it.
- If `.agents/repomix-snapshot.md` already exists and is less than 30 minutes old (check mtime), skip re-generation and report "Using cached snapshot."
