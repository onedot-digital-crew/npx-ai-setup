# Spec 079 — Storyblok Dump Script Auto-Install

**Status:** draft
**Created:** 2026-03-12

## Goal

Automatically install a `storyblok-dump` script into Storyblok projects during ai-setup, giving Claude a local cache of all stories for token-efficient MCP workflows.

## Context

The storyblok-dump script fetches all Storyblok stories (draft version) and writes a token-optimized JSONL file with a summary header. This eliminates blind MCP roundtrips: Claude reads the dump for IDs/slugs, then makes only targeted `storyblok_get_story(id)` calls.

ai-setup already detects Storyblok projects (`detect.sh:31`) and installs system-specific skills (`generate.sh:964`). The `install_shopify_skills()` pattern in `lib/setup.sh:220` serves as the model for system-specific file installation.

## Steps

- [ ] **1. Create template script** `templates/scripts/storyblok-dump.ts` — the TSX script that fetches all stories via Storyblok CDN API and writes JSONL to `scripts/storyblok-dump.json`. Supports `STORYBLOK_TOKEN` and `STORYBLOK_REGION` from `.env`.
- [ ] **2. Add `install_storyblok_scripts()` to `lib/setup.sh`** — following the `install_shopify_skills()` pattern. When `SYSTEM` contains `storyblok`: (a) copy `storyblok-dump.ts` to target `scripts/`, (b) add `"storyblok-dump": "tsx scripts/storyblok-dump.ts"` to package.json scripts if not present.
- [ ] **3. Add template mapping** for the storyblok-dump script in the appropriate mapping array (check `TEMPLATE_MAP` or system-specific arrays in `lib/setup.sh` or `lib/generate.sh`).
- [ ] **4. Call `install_storyblok_scripts`** from `bin/ai-setup.sh` after `install_shopify_skills` (line ~145).
- [ ] **5. Add `scripts/storyblok-dump.json` to `.gitignore` template** — the dump output should not be committed.
- [ ] **6. Test idempotency** — running setup twice must not duplicate the npm script or corrupt `package.json`.

## Acceptance Criteria

- [ ] `templates/scripts/storyblok-dump.ts` exists and matches the provided script
- [ ] Running ai-setup on a Storyblok project copies the script to `scripts/storyblok-dump.ts`
- [ ] `package.json` gets `storyblok-dump` script entry pointing to `tsx scripts/storyblok-dump.ts`
- [ ] Running setup twice does not duplicate the script entry
- [ ] Non-Storyblok projects are unaffected (function exits early)
- [ ] `scripts/storyblok-dump.json` is gitignored
- [ ] Script handles missing `STORYBLOK_TOKEN` gracefully (exits with error message)

## Files to Modify

- `templates/scripts/storyblok-dump.ts` — **create** (new template)
- `lib/setup.sh` — add `install_storyblok_scripts()` function
- `bin/ai-setup.sh` — call `install_storyblok_scripts` in install flow

## Out of Scope

- WORKFLOW-GUIDE documentation (covered by spec 078)
- Shopify equivalent dump script
- Component-level content extraction (only story metadata)
