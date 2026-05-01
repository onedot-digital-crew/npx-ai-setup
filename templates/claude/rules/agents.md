# Agent Delegation Rules

## Model Routing (CRITICAL)

Always set `model:` when spawning subagents.

| Model    | Use for                                                                       |
| -------- | ----------------------------------------------------------------------------- |
| `haiku`  | ALL Explore/search/read-only agents (12× cheaper than Sonnet)                 |
| `sonnet` | Implementation, code generation, tests — default for implementation subagents |
| `opus`   | Architecture review, spec creation                                            |

Never spawn Explore/search without `haiku`. Code-writing agents must use `sonnet`. Haiku is never for implementation.

## Effort Levels (Opus 4.7)

`/effort` or `--effort`: `medium` → `high` → `xhigh` → `max`.
Default for Pro/Max: `high`. `xhigh` only on Opus 4.7 — other models fall back to `high`.
Arch review/spec work: `xhigh`. Normal code tasks: default `high`.

## Dispatch

- Threshold: spawn agents only for tasks requiring ≥3 distinct tool calls
- Escalation rule: if you've already made 8 tool calls on a task with no subagents, parallelize the remaining work

Full trigger/model table: `.claude/docs/agent-dispatch.md`.

## Delegation Mandates (Opus Main Agent)

Opus stays dirigent — execution delegates to cheaper models. **MUST delegate**, not optional:

| Trigger                                                                                                                                                                           | Subagent               | Model    |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- | -------- |
| ≥3 **read-only** Bash calls (jq, find, grep, rg, git diff/log/show/status, file system queries)                                                                                   | `bash-runner`          | `haiku`  |
| ≥2 Edit/Write with **explicit file list AND expected change** (issue list, AC checklist, spec files block)                                                                        | `implementer`          | `sonnet` |
| Architecture skepticism on high-complexity changes (new infra, structural refactors, risks)                                                                                       | `staff-reviewer`       | `opus`   |
| Code review after `implementer`-run or before merge                                                                                                                               | `code-reviewer`        | `sonnet` |
| Performance regression check on **stack-gated hotpath** edits (Liquid hub snippets, Vue/Nuxt fetch+render loops, Laravel/Shopware DB loops) — never on docs/config/CSS-only diffs | `performance-reviewer` | `sonnet` |
| Security audit (auth, secrets, injection, OWASP)                                                                                                                                  | `security-reviewer`    | `sonnet` |
| Missing tests after source changes                                                                                                                                                | `test-generator`       | `sonnet` |
| Stack profile detection / context-files scan                                                                                                                                      | `context-scanner`      | `haiku`  |

**Hard rules:**

- **bash-runner only for read-only Bash** — never mutating commands (`rm`, `mv`, `cp`, `mkdir`, `> file`, `sed -i`, `git checkout`, `git reset`, `git restore`, package installs). Mutations are Opus-self or `implementer`-explicit.
- **implementer only when files and expected edits are explicit** — vague tasks ("refactor X", "clean up Y") stay with Opus until file list + intent is defined. Implementer refuses tasks without both.

## Complexity Signals → Model

| Scope                                                     | Model                   |
| --------------------------------------------------------- | ----------------------- |
| 1-2 files, well-defined edit                              | `haiku` or `sonnet`     |
| 3-7 files, spec'd diff, no architecture                   | `sonnet` (implementer)  |
| Multi-system change, new abstractions, design decision    | `opus` (main agent)     |
| Architecture review, spec creation, structural skepticism | `opus` (staff-reviewer) |

**Opus self-handles**: spec creation (`/spec-work` routes by `Complexity:`), strategy discussion, architecture decisions, mutating shell commands without an explicit file list, final quality reviews.
**Skip delegation only for**: single-shot Bash, one-line edits, conversational answers, ≤2 tool calls total.

## Graph-Assisted Navigation

Three graph files may exist — each covers a different layer:

| File                                | What it maps                         | When present            |
| ----------------------------------- | ------------------------------------ | ----------------------- |
| `.agents/context/graph.json`        | JS/TS import graph (auto-generated)  | JS/TS projects          |
| `.agents/context/liquid-graph.json` | Liquid section/snippet/template deps | Shopify only            |
| `graphify-out/graph.json`           | Semantic community graph (opt-in)    | After `/graphify build` |

**JS/TS import graph** (`.agents/context/graph.json`):

```bash
jq -r '.stats.top_hubs[] | "\(.imported_by)x \(.file)"' .agents/context/graph.json
jq -r --arg f "path/file.ts" '.edges[] | select(.target==$f) | .source' .agents/context/graph.json
```

**Graphify semantic graph** (`graphify-out/graph.json`, only when `/graphify` skill is installed):

```bash
# Top communities
jq '.communities[] | {id, size: (.nodes | length), label}' graphify-out/graph.json
# Community for a specific file
jq --arg f "components/Header.vue" \
  '.communities[] | select(.nodes[] == $f) | {id, label}' graphify-out/graph.json
```

20 tokens instead of 500 for a grep. Skip if the relevant graph file is missing.

## Graph-Hints Enforcement

The `graph-hints.sh` hook (PreToolUse: Read/Edit/Grep/Glob/Bash) enforces this rule automatically:

- Read on a file >500 lines → stderr hint to check graph.json first
- 4× Grep in a row without a graph query → hint to use graph instead
- Read/Edit on `.ts/.tsx/.vue/.liquid` → injects forward + reverse import context

Opt-out: `.claude/settings.local.json` `{ "graphBeforeRead": false }`. Hook never blocks.

## Shopify Liquid Graph Navigation

If `.agents/context/liquid-graph.json` exists (shopify-liquid profile), query it before searching Liquid files:

```bash
# Who renders a given snippet?
jq -r --arg s "snippets/product-card.liquid" '.edges[] | select(.target==$s) | .source' .agents/context/liquid-graph.json

# Top rendered snippets (hub ranking)
jq -r '.stats.top_hubs[] | "\(.imported_by)x \(.file)"' .agents/context/liquid-graph.json | head -10

# Orphan snippets (safe to remove candidates)
jq -r '.stats.orphans[]' .agents/context/liquid-graph.json
```

Refresh graph: `bash .claude/scripts/liquid-graph-refresh.sh` (no-op if up to date).
