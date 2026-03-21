#!/usr/bin/env bash
# context-reinforcement.sh — SessionStart hook
# Re-injects critical rules after context compaction to prevent rule drift.
# Rules are hardcoded (no runtime file reads) to stay <50ms.

cat <<'EOF'
{"additionalContext": "IRON LAWS (enforced always — survive compaction):\n1. READ-BEFORE-MODIFY: Always read a file with the Read tool before editing it. Never assume contents from memory.\n2. SKILL-FIRST: Before implementing anything, check .claude/skills/ and invoke a matching skill via the Skill tool. Do not reimplement what a skill already covers.\n3. HUMAN-APPROVAL-GATE: Before finalizing any deliverable, present a summary and wait for explicit user confirmation. Never advance to the next phase without approval.\n4. VERIFY-BEFORE-DONE: Never mark work complete without (a) automated checks passing and (b) stating \"Verification complete: [what was checked]\".\n5. NO-SANDBOX-BYPASS: Never set dangerouslyDisableSandbox:true without explaining why and receiving explicit user confirmation first."}
EOF
