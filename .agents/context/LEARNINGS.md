# Learnings

> Curated session learnings from /reflect. Persistent across updates — generate.sh never touches this file.
> After /reflect: review entries and move each into the correct project file manually (CLAUDE.md, rules, skill docs). Applied entries move to `## Applied`.

## Architecture

- Direkte Edits an `.claude/skills/*/SKILL.md` überleben `/update` nicht — Änderungen immer in `templates/skills/*/SKILL.template.md` vornehmen
- `nuxt` ist ein erkanntes System ohne Boilerplate-Repo — `get_boilerplate_repo()` kennt nur `shopify`, `shopware`, `nuxt-storyblok`, `next`, `storyblok`

## Corrections

## Applied

_Entries moved here after manual incorporation into target files._

- ~~`sync_boilerplate()` muss `get_boilerplate_repo()` prüfen bevor `pull_boilerplate_files()` aufgerufen wird~~ → `lib/boilerplate.sh:283` (guard already implemented via `if ! get_boilerplate_repo "$system" >/dev/null 2>&1; then return 0; fi`)

- ~~`/research` muss Kandidaten gegen CONCEPT.md und Projektphilosophie validieren BEVOR Specs erstellt werden~~ → `.claude/rules/general.md` (Research & Spec Gate)
- ~~`session-optimize` Findings IMMER gegen aktuellen File-State verifizieren bevor Spec erstellt wird~~ → `.claude/rules/general.md` (Research & Spec Gate)
- ~~Stack-spezifische Skills gehören in Boilerplate-Repos, nicht in Base-Setup~~ → `.agents/context/ARCHITECTURE.md` (Directory Ownership)
- ~~Dev-Tools gehören in .claude/, nicht in templates/~~ → `.agents/context/ARCHITECTURE.md` (Directory Ownership)
- ~~SubagentStart und SubagentStop sind valide Claude Code Hook-Types~~ → `.agents/context/ARCHITECTURE.md` (Key Patterns)
- ~~claude-mem Observations können auf Worktree-Files referenzieren~~ → `.claude/rules/agents.md`
- ~~Skills mit `disable-model-invocation: true` UND ohne `model:` erben Parent-Session-Modell~~ → `.claude/rules/agents.md`
