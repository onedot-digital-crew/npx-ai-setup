# Backlog

Ideas and future work for ai-setup. Specs live in `specs/` — this file tracks ideas that don't yet warrant a spec.

## Active Spec

- **#069** Agent Rules & Template Standardization — create `agents.md` rules file, standardize agent metadata

## Ideas (no spec yet)

### Advanced Installation Profile
Opt-in power-user profile with opinionated defaults (more agents, stricter hooks, monorepo support). Rejected as premature — revisit if users request it.

### Analytics Dashboard (Standalone)
Self-hosted Claude Code usage dashboard (OpenTelemetry ingest, PR attribution, ROI metrics). Separate project, not part of ai-setup. Inspired by rudel.ai.

### Monorepo Context Guidance
Document what belongs in root vs local context for monorepos/repo-groups. Low priority — no user requests yet.

## Evaluate

### CocoIndex Code — Semantic Code Search MCP
- **URL:** https://github.com/cocoindex-io/cocoindex-code
- **What:** MCP server for semantic code search via natural language queries
- **Why interesting:** ~70% token savings, AST-based chunking (Tree-sitter), incremental indexing, embedded SQLite vector store, 25+ languages
- **Concerns:** Python dependency (our stack is Shell/Node), Rust build requirements, early-stage project
- **Status:** Watch — evaluate once project matures or when users request semantic search

## Rejected

- **#050** TSC in post-edit hook — too slow (whole-project check per edit), conflicts with deadloop-safe design
- **#051** PreCompact hook — already implemented
- **#063** Spec workflow rewind hardening — already covered by existing retry limits and context-monitor
- **#061** Command/Agent/Skill clarity docs — too generic, no concrete user pain
- **#067** Skill boundary guidance — overlaps with #061, skills are external
- **#064** spec-work-all scope alignment — addressed by #060 token optimization
- **#068** Advanced install profile — premature, moved to Ideas
