#!/bin/bash

# ==============================================================================
# @onedot/ai-setup - AI Setup fuer Projekte
# ==============================================================================
# Installiert GSD, Memory Bank, Hooks, Auto-Init
# Usage: npx @onedot/ai-setup
# ==============================================================================

set -e

# Package-Root (ein Level ueber bin/)
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TPL="$SCRIPT_DIR/templates"

echo "🚀 Starte AI Setup (GSD + Lean Memory Bank)..."

# ------------------------------------------------------------------------------
# 0. REQUIREMENTS CHECK
# ------------------------------------------------------------------------------
MISSING=()
! command -v node &>/dev/null && MISSING+=("node (>= 18)")
! command -v npm &>/dev/null && MISSING+=("npm")
! command -v jq &>/dev/null && MISSING+=("jq (brew install jq)")

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "❌ Fehlende Requirements:"
  for m in "${MISSING[@]}"; do echo "   - $m"; done
  echo ""
  echo "Installiere die fehlenden Tools und starte erneut."
  exit 1
fi

# AI CLI Detection (optional, fuer Auto-Init)
AI_CLI=""
if command -v claude &>/dev/null; then
  AI_CLI="claude"
elif command -v gh &>/dev/null && gh copilot --version &>/dev/null 2>&1; then
  AI_CLI="copilot"
fi
echo "✅ Requirements OK (AI CLI: ${AI_CLI:-keiner erkannt})"

# ------------------------------------------------------------------------------
# 1. CLEANUP (alte AI-Strukturen erkennen und entfernen)
# ------------------------------------------------------------------------------
FOUND=()
[ -d ".ai" ] && FOUND+=(".ai/")
[ -d ".claude/skills/create-spec" ] && FOUND+=(".claude/skills/create-spec/")
[ -d ".claude/skills/work-spec" ] && FOUND+=(".claude/skills/work-spec/")
[ -d ".claude/skills/template-skill" ] && FOUND+=(".claude/skills/template-skill/")
[ -d ".claude/skills/learn" ] && FOUND+=(".claude/skills/learn/")
[ -f ".claude/INIT.md" ] && FOUND+=(".claude/INIT.md")
[ -f "specs/TEMPLATE.md" ] && FOUND+=("specs/TEMPLATE.md")
[ -d "skills/" ] && FOUND+=("skills/")
[ -d ".skillkit/" ] && FOUND+=(".skillkit/")
[ -f "skillkit.yaml" ] && FOUND+=("skillkit.yaml")

if [ ${#FOUND[@]} -gt 0 ]; then
  echo "⚠️  Alte AI-Strukturen gefunden:"
  for f in "${FOUND[@]}"; do echo "   - $f"; done
  echo ""
  read -p "Loeschen? (Y/n) " CLEANUP
  if [[ ! "$CLEANUP" =~ ^[Nn]$ ]]; then
    for f in "${FOUND[@]}"; do rm -rf "$f"; done
    echo "✅ Cleanup erledigt."
  else
    echo "⏭️  Cleanup uebersprungen."
  fi
else
  echo "✅ Keine alten Strukturen gefunden."
fi

# ------------------------------------------------------------------------------
# 2. MEMORY BANK (aus Templates kopieren)
# ------------------------------------------------------------------------------
echo "🧠 Erstelle Lean Memory Bank..."
mkdir -p memory-bank

[ ! -f memory-bank/projectbrief.md ] && cp "$TPL/memory-bank/projectbrief.md" memory-bank/projectbrief.md
[ ! -f memory-bank/systemPatterns.md ] && cp "$TPL/memory-bank/systemPatterns.md" memory-bank/systemPatterns.md

echo "✅ Memory Bank erstellt."

# ------------------------------------------------------------------------------
# 3. CLAUDE.md
# ------------------------------------------------------------------------------
echo "📝 Schreibe CLAUDE.md..."

if [ ! -f CLAUDE.md ]; then
  cp "$TPL/CLAUDE.md" CLAUDE.md
  echo "  CLAUDE.md erstellt (Template - bitte anpassen)."
else
  echo "  CLAUDE.md existiert bereits, uebersprungen."
fi

# ------------------------------------------------------------------------------
# 4. SETTINGS.JSON (Granulare Permissions)
# ------------------------------------------------------------------------------
echo "⚙️  Schreibe .claude/settings.json..."
mkdir -p .claude

if [ ! -f .claude/settings.json ]; then
  cp "$TPL/claude/settings.json" .claude/settings.json
else
  echo "  .claude/settings.json existiert bereits, uebersprungen."
fi

# ------------------------------------------------------------------------------
# 5. HOOKS
# ------------------------------------------------------------------------------
echo "🛡️  Erstelle Hooks..."
mkdir -p .claude/hooks

for hook in protect-files.sh post-edit-lint.sh circuit-breaker.sh; do
  if [ ! -f ".claude/hooks/$hook" ]; then
    cp "$TPL/claude/hooks/$hook" ".claude/hooks/$hook"
    chmod +x ".claude/hooks/$hook"
  else
    echo "  .claude/hooks/$hook existiert bereits, uebersprungen."
  fi
done

# ------------------------------------------------------------------------------
# 6. COPILOT INSTRUCTIONS
# ------------------------------------------------------------------------------
mkdir -p .github

if [ ! -f .github/copilot-instructions.md ]; then
  cp "$TPL/github/copilot-instructions.md" .github/copilot-instructions.md
else
  echo "  .github/copilot-instructions.md existiert bereits, uebersprungen."
fi

# ------------------------------------------------------------------------------
# 7. GITIGNORE
# ------------------------------------------------------------------------------
if ! grep -q "claude/settings.local" .gitignore 2>/dev/null; then
  echo "" >> .gitignore
  echo "# Claude Code local settings" >> .gitignore
  echo ".claude/settings.local.json" >> .gitignore
fi

# ------------------------------------------------------------------------------
# 8. GSD INSTALLIEREN (project-lokal, non-interactive)
# ------------------------------------------------------------------------------
echo "🎯 Installiere GSD (Get Shit Done)..."
npx -y get-shit-done-cc@latest --claude --local 2>/dev/null || echo "  GSD Installation fehlgeschlagen. Manuell: npx get-shit-done-cc@latest --claude --local"

# GSD Companion Skill
npx skills add https://github.com/ctsstc/get-shit-done-skills --skill gsd --agent claude-code --agent github-copilot -y 2>/dev/null || echo "  Skills CLI nicht verfuegbar, uebersprungen."

# ------------------------------------------------------------------------------
# 9. AI-SETUP.md
# ------------------------------------------------------------------------------
echo "📚 Erstelle AI-SETUP.md..."

if [ ! -f AI-SETUP.md ]; then
  cp "$TPL/AI-SETUP.md" AI-SETUP.md
else
  echo "  AI-SETUP.md existiert bereits, uebersprungen."
fi

# ------------------------------------------------------------------------------
# 10. INIT PROMPT
# ------------------------------------------------------------------------------
if [ ! -f .claude/init-prompt.md ]; then
  cp "$TPL/claude/init-prompt.md" .claude/init-prompt.md
else
  echo "  .claude/init-prompt.md existiert bereits, uebersprungen."
fi

# ------------------------------------------------------------------------------
# 11. AUTO-INIT (Claude Code befuellt Memory Bank + CLAUDE.md)
# ------------------------------------------------------------------------------

# Kill Prozess + alle Kindprozesse (Claude spawnt Sub-Agents)
kill_tree() {
  local pid=$1
  pkill -P "$pid" 2>/dev/null
  kill "$pid" 2>/dev/null
  wait "$pid" 2>/dev/null
}

# Progress Bar fuer einzelnen Prozess
# Usage: progress_bar <pid> <label> [est_seconds] [max_seconds]
progress_bar() {
  local pid=$1 label=$2 est=${3:-120} max=${4:-600}
  local width=30 elapsed=0
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$elapsed" -ge "$max" ]; then
      kill_tree "$pid"
      printf "\r  ⚠️  %s abgebrochen nach %ds (Timeout)%*s\n" "$label" "$elapsed" 20 ""
      return 0
    fi
    local pct=$((elapsed * 100 / est))
    [ "$pct" -gt 95 ] && pct=95
    local filled=$((pct * width / 100))
    local empty=$((width - filled))
    local bar=$(printf '█%.0s' $(seq 1 $filled 2>/dev/null) ; printf '░%.0s' $(seq 1 $empty 2>/dev/null))
    printf "\r  %s %s [%s] %d%% (%ds)" "⏳" "$label" "$bar" "$pct" "$elapsed"
    sleep 1
    elapsed=$((elapsed + 1))
  done
  local bar=$(printf '█%.0s' $(seq 1 $width))
  printf "\r  ✅ %s [%s] 100%% (%ds)\n" "$label" "$bar" "$elapsed"
}

# Parallele Progress Bars fuer mehrere Prozesse
# Usage: wait_parallel "PID:Label:Est:Max" "PID:Label:Est:Max" ...
wait_parallel() {
  local specs=("$@")
  local count=${#specs[@]}
  local width=30

  # Parse specs
  local pids=() labels=() ests=() maxes=() done_at=()
  for spec in "${specs[@]}"; do
    IFS=: read -r pid label est max <<< "$spec"
    pids+=("$pid")
    labels+=("$label")
    ests+=("$est")
    maxes+=("$max")
    done_at+=(0)
  done

  # Reserve lines
  for ((i=0; i<count; i++)); do echo ""; done

  local elapsed=0

  while true; do
    local running=0
    # Move cursor up to overwrite
    printf "\033[${count}A"

    for ((i=0; i<count; i++)); do
      local pid=${pids[$i]}
      local label=${labels[$i]}
      local est=${ests[$i]}
      local max=${maxes[$i]}

      if [ "${done_at[$i]}" -gt 0 ]; then
        # Already finished
        local bar=$(printf '█%.0s' $(seq 1 $width))
        printf "\r  ✅ %-25s [%s] 100%% (%ds)%*s\n" "$label" "$bar" "${done_at[$i]}" 5 ""
      elif ! kill -0 "$pid" 2>/dev/null; then
        # Just finished
        done_at[$i]=$((elapsed > 0 ? elapsed : 1))
        local bar=$(printf '█%.0s' $(seq 1 $width))
        printf "\r  ✅ %-25s [%s] 100%% (%ds)%*s\n" "$label" "$bar" "$elapsed" 5 ""
      elif [ "$elapsed" -ge "$max" ]; then
        # Timeout
        kill_tree "$pid"
        done_at[$i]=$elapsed
        printf "\r  ⚠️  %-25s abgebrochen nach %ds (Timeout)%*s\n" "$label" "$elapsed" 10 ""
      else
        # Still running
        running=$((running + 1))
        local pct=$((elapsed * 100 / est))
        [ "$pct" -gt 95 ] && pct=95
        local filled=$((pct * width / 100))
        local empty=$((width - filled))
        local bar=$(printf '█%.0s' $(seq 1 $filled 2>/dev/null) ; printf '░%.0s' $(seq 1 $empty 2>/dev/null))
        printf "\r  ⏳ %-25s [%s] %d%% (%ds)%*s\n" "$label" "$bar" "$pct" "$elapsed" 5 ""
      fi
    done

    [ "$running" -eq 0 ] && break
    sleep 1
    elapsed=$((elapsed + 1))
  done
}

echo ""
echo "✅ Setup abgeschlossen!"
echo ""

if [ "$AI_CLI" = "claude" ]; then
  read -p "🤖 Auto-Init jetzt ausfuehren? (Y/n) " RUN_INIT
  if [[ ! "$RUN_INIT" =~ ^[Nn]$ ]]; then
    echo "🚀 Scanne Projekt-Struktur..."

    # Kontext komplett in Bash sammeln (Claude muss nur noch schreiben)
    CONTEXT="--- package.json ---
$(cat package.json 2>/dev/null)
--- package.json scripts ---
$(jq -r '.scripts | to_entries[] | "- \(.key): \(.value)"' package.json 2>/dev/null)
--- Ordnerstruktur (max 80 Dateien) ---
$(find . -maxdepth 4 -type f \( -name '*.js' -o -name '*.ts' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.vue' -o -name '*.svelte' -o -name '*.css' -o -name '*.scss' -o -name '*.liquid' -o -name '*.php' -o -name '*.html' -o -name '*.twig' -o -name '*.blade.php' -o -name '*.erb' -o -name '*.py' -o -name '*.rb' -o -name '*.go' -o -name '*.rs' -o -name '*.astro' \) ! -path './node_modules/*' ! -path './.git/*' ! -path './dist/*' ! -path './build/*' ! -path './assets/*' ! -path './.next/*' ! -path './vendor/*' ! -path './.nuxt/*' 2>/dev/null | sort | head -80)
--- ESLint Config ---
$(cat eslint.config.* .eslintrc* 2>/dev/null | head -100)
--- Prettier Config ---
$(cat .prettierrc* 2>/dev/null)
--- CLAUDE.md (aktuell) ---
$(cat CLAUDE.md 2>/dev/null)"

    # Step 1: Memory Bank befuellen (PARALLEL mit Step 2)
    claude -p --model sonnet --max-turns 3 "Befuelle memory-bank/ basierend auf dem Projekt-Kontext.

1. memory-bank/projectbrief.md (via Bash, ist write-protected):
   Goal, Tech Stack (mit Versionen), Architecture, Constraints
2. memory-bank/systemPatterns.md:
   Architecture Decisions, Coding Standards, Key Patterns

Regeln: NUR was im Kontext steht. Keine Umlaute. Max 60 Zeilen pro Datei. Antworte 'Done'.

$CONTEXT" >/dev/null 2>&1 &
    PID_MB=$!

    # Step 2: CLAUDE.md erweitern (PARALLEL mit Step 1)
    claude -p --model sonnet --max-turns 3 "Ergaenze CLAUDE.md um zwei Sektionen:

## Commands
Lies package.json scripts, dokumentiere die wichtigsten (dev, build, lint, test).

## Critical Rules
Analysiere Linting-Config (eslint, prettier). Identifiziere Framework-Patterns.
Schreibe konkrete, actionable Rules. Max 5 Sektionen, je 3-5 Bullet Points.

Regeln: NUR was im Kontext steht. Keine Umlaute. Antworte 'Done'.

$CONTEXT" >/dev/null 2>&1 &
    PID_CM=$!

    # Parallele Progress Bars
    echo ""
    wait_parallel "$PID_MB:Memory Bank:30:120" "$PID_CM:CLAUDE.md:30:120"

    # Step 3: GSD Map Codebase (sequentiell, erst nach 1+2)
    echo ""
    claude -p "/gsd:map-codebase" >/dev/null 2>&1 &
    progress_bar $! "Codebase-Analyse (GSD)" 180 600

    # Step 4: Skills (Hinweis, nicht automatisch)
    echo ""
    echo "✅ Auto-Init abgeschlossen!"
    echo "💡 Skills suchen: claude -p 'Lies package.json, suche passende Skills mit npx skills find'"
    osascript -e 'display notification "Auto-Init abgeschlossen. Starte /gsd:new-project" with title "AI Setup" sound name "Glass"' 2>/dev/null
  fi
elif [ "$AI_CLI" = "copilot" ]; then
  echo "💡 GitHub Copilot erkannt (kein claude CLI)."
  echo "   Auto-Init muss manuell in Copilot Chat ausgefuehrt werden:"
  echo ""
  echo "   1. Oeffne VS Code / GitHub Copilot Chat"
  echo "   2. Kopiere den Inhalt aus: .claude/init-prompt.md"
  echo "   3. Fuehre /gsd:map-codebase und /gsd:new-project aus"
else
  echo "⚠️  Kein AI CLI erkannt (weder claude noch gh copilot)."
  echo "   Installiere Claude Code: npm i -g @anthropic-ai/claude-code"
  echo "   Oder fuehre den Init-Prompt manuell aus: .claude/init-prompt.md"
fi

echo ""
echo "--------------------------------------------------------"
echo "NAECHSTE SCHRITTE:"
echo ""
if [ "$AI_CLI" = "claude" ]; then
  echo "1. /gsd:new-project (interaktiv, in Claude Code Session)"
else
  echo "1. Init-Prompt ausfuehren (.claude/init-prompt.md)"
  echo "2. /gsd:map-codebase"
  echo "3. /gsd:new-project"
fi
echo "--------------------------------------------------------"
echo ""
echo "📚 Dokumentation: AI-SETUP.md"
