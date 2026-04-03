#!/usr/bin/env bash
# cli-health.sh — SessionStart hook: warn about missing token-saving tools
# Silent when all OK. Max 100ms execution time.
# Outputs warnings to stderr (visible to user, not consumed as tool output).

warnings=()

if ! command -v rtk >/dev/null 2>&1; then
  warnings+=("rtk not found — install with 'brew install rtk' for 60-90% token savings")
else
  rtk_gain_output="$(rtk gain 2>&1 || true)"
  if [ -n "$rtk_gain_output" ]; then
    if printf '%s' "$rtk_gain_output" | grep -qiE 'Failed to initialize tracking database|unable to open database file|Error code 14'; then
      warnings+=("rtk installed but tracking DB is unavailable — check RTK write permissions or local RTK config")
    elif printf '%s' "$rtk_gain_output" | grep -qiE 'hook|init'; then
      warnings+=("rtk installed but hooks not active — run 'rtk init --global' to enable")
    else
      warnings+=("rtk installed but health check failed — run 'rtk gain' manually to inspect")
    fi
  fi
fi

if ! command -v defuddle >/dev/null 2>&1; then
  warnings+=("defuddle not found — install with 'npm i -g defuddle' for 80% savings on web content")
fi

if ! command -v jq >/dev/null 2>&1; then
  warnings+=("jq not found — many hooks depend on it and will silently fail without it")
fi

if [[ ${#warnings[@]} -gt 0 ]]; then
  for w in "${warnings[@]}"; do
    echo "[cli-health] $w" >&2
  done
fi

exit 0
