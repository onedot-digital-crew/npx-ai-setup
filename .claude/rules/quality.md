# Quality Principles

## Fix Strategy

Never disable or remove a feature as a first fix. Always find and fix the root cause with a targeted change.
If tempted to disable something (e.g., `payloadExtraction: false`), stop and ask the user first.

## Debugging

**Revert-First**: When something breaks during implementation, simplify — don't add more code.
1. Revert the breaking change. Clean state.
2. Can the broken thing be deleted entirely?
3. One-liner minimal targeted fix only.
3+ failed fixes = architectural problem — question the approach, not the fix.

**Investigation budget**: Max 3 diagnostic attempts per hypothesis. If no new information after 3 tries, switch strategy or ask the user. Never repeat the same approach with minor variations.

**Diagnose → Fix gate**: Once the root cause is confirmed, immediately switch to implementing a fix. Do not continue diagnosing or re-confirming with additional grep/curl/read cycles. Max 2 confirmation rounds, then act.

**Systematic phases**: Root Cause → Pattern Analysis → Hypothesis (specific, falsifiable) → Implement.
Treat your own code as foreign. Your mental model is a guess — the code's behavior is truth.

**When challenged**: If the user disputes your conclusion, re-investigate the actual code before defending your answer. The initial analysis may be wrong.

**Constraint Classification**: Hard (non-negotiable), Soft (negotiable if stated), Ghost (past constraints that no longer apply). Ghost constraints lock out options nobody knows are available — ask "why can't we do X?"
