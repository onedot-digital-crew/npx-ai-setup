#!/bin/bash
# System plugin: Shopify
# Provides: SHOPIFY_SKILLS_MAP, install_shopify_skills, system_get_default_skills,
#           system_inject_agent_skills
# Requires: core.sh ($TPL), setup.sh (_install_or_update_file)

# Shopify-specific template skills (installed into target project)
SHOPIFY_SKILLS_MAP=(
  "templates/skills/shopify-theme-dev/SKILL.md:.claude/skills/shopify-theme-dev/SKILL.md"
  "templates/skills/shopify-liquid/SKILL.md:.claude/skills/shopify-liquid/SKILL.md"
  "templates/skills/shopify-app-dev/SKILL.md:.claude/skills/shopify-app-dev/SKILL.md"
  "templates/skills/shopify-graphql-api/SKILL.md:.claude/skills/shopify-graphql-api/SKILL.md"
  "templates/skills/shopify-hydrogen/SKILL.md:.claude/skills/shopify-hydrogen/SKILL.md"
  "templates/skills/shopify-checkout/SKILL.md:.claude/skills/shopify-checkout/SKILL.md"
  "templates/skills/shopify-functions/SKILL.md:.claude/skills/shopify-functions/SKILL.md"
  "templates/skills/shopify-cli-tools/SKILL.md:.claude/skills/shopify-cli-tools/SKILL.md"
  "templates/skills/shopify-new-section/SKILL.md:.claude/skills/shopify-new-section/SKILL.md"
  "templates/skills/shopify-new-block/SKILL.md:.claude/skills/shopify-new-block/SKILL.md"
)

# Install Shopify-specific template skills
install_shopify_skills() {
  echo "  🛍️  Installing Shopify skills..."
  for mapping in "${SHOPIFY_SKILLS_MAP[@]}"; do
    local local_tpl="${mapping%%:*}"
    local local_target="${mapping#*:}"
    local skill_dir
    skill_dir="$(dirname "$local_target")"
    mkdir -p "$skill_dir"
    # Backwards-compat: rename legacy prompt.md to SKILL.md if present
    if [ -f "$skill_dir/prompt.md" ] && [ ! -f "$skill_dir/SKILL.md" ]; then
      mv "$skill_dir/prompt.md" "$skill_dir/SKILL.md"
    fi
    _install_or_update_file "$TPL/${local_tpl#templates/}" "$local_target"
  done
}

# System plugin interface: default skills for AI-curated installation
system_get_default_skills() {
  SYSTEM_SKILLS+=(
    "sickn33/antigravity-awesome-skills@shopify-development"
    "jeffallan/claude-skills@shopify-expert"
    "henkisdabro/wookstar-claude-code-plugins@shopify-theme-dev"
  )
}

# System plugin interface: inject skills into agent YAML headers
system_inject_agent_skills() {
  _inject_skill "liquid-linter.md" "shopify-liquid" "shopify-theme-dev"
  _inject_skill "code-reviewer.md" "shopify-theme-dev"
}
