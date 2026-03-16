# Spec: Skill Search Result Caching

> **Spec ID**: 097 | **Created**: 2026-03-16 | **Status**: completed | **Branch**: —

## Goal
Cache skill search results and Claude rankings to skip redundant API calls on setup re-runs.

## Context
Skill discovery runs every setup: 8+ parallel curl requests to skills.sh, install count fetches, and a Claude Haiku ranking call (~60s total). On re-runs where `package.json` hasn't changed, this is entirely redundant. Caching the result keyed by `PKG_HASH` avoids the waste while preserving freshness on dependency changes.

## Steps
- [x] Step 1: Define cache file `.agents/.skill-cache.json` with schema: `{ "pkg_hash": "...", "stack_hash": "...", "cached_at": "ISO", "keywords": [...], "selected": [...] }`
- [x] Step 2: At start of skill search in `lib/generate.sh` (~line 645), check if cache exists and both `pkg_hash` (package.json cksum) and `stack_hash` (.agents/context/STACK.md cksum) match — if both match, skip search and use cached `selected` list
- [x] Step 3: After successful Claude ranking (~line 834), write cache file with both hashes, keywords, and selected skill IDs
- [x] Step 4: Add `--force-skills` flag to `bin/ai-setup.sh` that bypasses cache (for manual refresh)
- [x] Step 5: Add `.agents/.skill-cache.json` to `.gitignore` template in `lib/setup.sh`
- [ ] Step 6: Test: run setup twice, verify second run skips search and prints "Using cached skill selection"

## Acceptance Criteria
- [x] Second setup run with unchanged `package.json` skips all curl and Claude calls
- [x] Changed `package.json` OR `STACK.md` triggers fresh search (hash mismatch invalidates cache)
- [x] `--force-skills` flag bypasses cache unconditionally
- [x] Cache file is gitignored and machine-local

## Files to Modify
- `lib/generate.sh` — add cache read/write logic around skill search block
- `bin/ai-setup.sh` — add `--force-skills` flag parsing
- `lib/setup.sh` — add cache file to `.gitignore`

## Out of Scope
- TTL-based expiry (hash-based invalidation is sufficient)
- Caching install count metrics separately
- Sharing cache across machines
