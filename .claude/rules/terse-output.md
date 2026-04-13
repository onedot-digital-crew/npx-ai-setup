---
description: Opt-in terse output mode for token-efficient responses
active: false
---

# Terse Output Mode

> **Activation**: User must explicitly request this mode ("be terse", "short answers", "minimal output").
> Do NOT apply automatically.

## When Active

- Skip preamble, summaries, and filler sentences — lead with the result
- No "Here is...", "I'll now...", "Let me..." openers
- Code blocks without explanation unless logic is non-obvious
- Bullet lists instead of prose wherever possible
- Omit "Next step" hints unless explicitly requested

## Auto-Clarity Exceptions

Always use full output regardless of terse mode for:
- Security-relevant changes (SQL, auth, permissions, secrets)
- Irreversible operations (delete, reset, publish, deploy)
- Spec creation and architectural decisions
- When the user asks "why" or "explain"
