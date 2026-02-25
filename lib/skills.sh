#!/bin/bash
# Skill search, curation, and installation
# Requires: $TIMEOUT_CMD (optional, set at call time)

SKILL_PATTERN='^[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+@[a-zA-Z0-9_.-]+'

# Detect timeout command availability
TIMEOUT_CMD=""
command -v timeout &>/dev/null && TIMEOUT_CMD="timeout 30"
command -v gtimeout &>/dev/null && TIMEOUT_CMD="gtimeout 30"

# Search skills.sh registry with timeout
search_skills() {
  local kw=$1
  local result=""
  if [ -n "$TIMEOUT_CMD" ]; then
    result=$($TIMEOUT_CMD npx -y skills@latest find "$kw" 2>/dev/null \
      | sed 's/\x1b\[[0-9;]*m//g' \
      | grep -E "$SKILL_PATTERN" || true)
  else
    local tmp=$(mktemp)
    npx -y skills@latest find "$kw" > "$tmp" 2>/dev/null &
    local pid=$!
    local wait_s=0
    while kill -0 "$pid" 2>/dev/null && [ "$wait_s" -lt 30 ]; do
      sleep 1
      wait_s=$((wait_s + 1))
    done
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
    else
      wait "$pid" 2>/dev/null || true
      result=$(sed 's/\x1b\[[0-9;]*m//g' "$tmp" \
        | grep -E "$SKILL_PATTERN" || true)
    fi
    rm -f "$tmp"
  fi
  echo "$result"
}

# Returns space-separated skill IDs curated from the skills.sh directory.
# Bash 3.2 safe (no declare -A). Update this list when new skills are published.
get_keyword_skills() {
  local kw="$1"
  case "$kw" in
    vue)        echo "vuejs-ai/skills@vue-best-practices antfu/skills@vue" ;;
    react)      echo "0xbigboss/claude-code@react-best-practices wshobson/agents@react-state-management" ;;
    typescript) echo "wshobson/agents@typescript-advanced-types sickn33/antigravity-awesome-skills@typescript-expert" ;;
    shadcn)     echo "google-labs-code/stitch-skills@shadcn-ui" ;;
    playwright) echo "microsoft/playwright-cli@playwright-cli" ;;
    prisma)     echo "sickn33/antigravity-awesome-skills@prisma-expert" ;;
    supabase)   echo "supabase/agent-skills@supabase-postgres-best-practices" ;;
    nestjs)     echo "kadajett/agent-nestjs-skills@nestjs-best-practices" ;;
    svelte)     echo "ejirocodes/agent-skills@svelte5-best-practices" ;;
    angular)    echo "analogjs/angular-skills@angular-component analogjs/angular-skills@angular-signals" ;;
    nuxt-ui)    echo "" ;;  # handled conditionally in system skills (nuxt case)
    vitest)     echo "antfu/skills@vitest" ;;
    pinia)      echo "vuejs-ai/skills@vue-pinia-best-practices" ;;
    tanstack)   echo "jezweb/claude-skills@tanstack-query" ;;
    tailwind)   echo "wshobson/agents@tailwind-design-system" ;;
    express)    echo "wshobson/agents@nodejs-backend-patterns" ;;
    hono)       echo "elysiajs/skills@elysiajs" ;;
    firebase)      echo "" ;;
    reka-ui)       echo "" ;;
    primevue)      echo "" ;;
    vuetify)       echo "" ;;
    element-plus)  echo "" ;;
    quasar)        echo "" ;;
    *)             echo "" ;;
  esac
}

# Install a single skill with duplicate detection and registry verification
# Uses $TIMEOUT_CMD if available
install_skill() {
  local sid=$1
  local skill_name="${sid##*@}"  # Extract skill name after @
  local owner_repo="${sid%@*}"
  local owner="${owner_repo%/*}"
  local repo="${owner_repo#*/}"

  # Check if already installed (local or global)
  if [ -d ".claude/skills/$skill_name" ] || [ -d "${HOME}/.claude/skills/$skill_name" ]; then
    printf "     ⏭️  %s (already installed)\n" "$sid"
    SKIPPED=$((SKIPPED + 1))
    return 0
  fi

  # Verify skill exists on skills.sh registry before attempting install
  if command -v curl >/dev/null 2>&1; then
    local status
    status=$(curl -s -o /dev/null -w "%{http_code}" \
      "https://skills.sh/$owner/$repo/$skill_name" 2>/dev/null)
    if [ "$status" != "200" ]; then
      printf "     ⚠️  %s (not in registry, skipping)\n" "$sid"
      return 0
    fi
  fi

  printf "     ⏳ %s ..." "$sid"
  if ${TIMEOUT_CMD:-} npx -y skills@latest add "$sid" --agent claude-code --agent github-copilot -y </dev/null >/dev/null 2>&1; then
    printf "\r     ✅ %s\n" "$sid"
    return 0
  else
    printf "\r     ❌ %s (install failed)\n" "$sid"
    return 1
  fi
}
