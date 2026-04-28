#!/bin/bash
# Process management: kill_tree, progress_bar, wait_parallel

# Kill process + all child processes (Claude spawns sub-agents)
kill_tree() {
  local pid=$1
  pkill -P "$pid" 2> /dev/null || true
  kill "$pid" 2> /dev/null || true
  wait "$pid" 2> /dev/null || true
}

_progress_bar_chars() {
  _tui_init
  local filled="$1"
  local empty="$2"
  printf '%s%s' \
    "$(tui_repeat_char "$TUI_BAR_FILL" "$filled")" \
    "$(tui_repeat_char "$TUI_BAR_EMPTY" "$empty")"
}

# Progress bar for a single process
# Usage: progress_bar <pid> <label> [est_seconds] [max_seconds]
progress_bar() {
  _tui_init
  local pid=$1 label=$2 est=${3:-120} max=${4:-600}
  local width=30 elapsed=0
  while kill -0 "$pid" 2> /dev/null; do
    if [ "$elapsed" -ge "$max" ]; then
      kill_tree "$pid"
      printf "\r\033[K"
      tui_warn "$label cancelled after ${elapsed}s (timeout)"
      return 0
    fi
    local pct=$((elapsed * 100 / est))
    [ "$pct" -gt 95 ] && pct=95
    local filled=$((pct * width / 100))
    local empty=$((width - filled))
    local bar
    bar=$(_progress_bar_chars "$filled" "$empty")
    printf "\r  %b%s%b %-24s [%s] %3d%% (%ds)" "$TUI_CYAN" "$TUI_INFO" "$TUI_RESET" "$label" "$bar" "$pct" "$elapsed"
    sleep 1
    elapsed=$((elapsed + 1))
  done
  local bar
  bar=$(_progress_bar_chars "$width" 0)
  printf "\r\033[K"
  printf "  %b%s%b %-24s [%s] 100%% (%ds)\n" "$TUI_GREEN" "$TUI_OK" "$TUI_RESET" "$label" "$bar" "$elapsed"
}

# Parallel progress bars for multiple processes
# Usage: wait_parallel "PID:Label:Est:Max" "PID:Label:Est:Max" ...
wait_parallel() {
  _tui_init
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
  for ((i = 0; i < count; i++)); do echo ""; done

  local elapsed=0

  while true; do
    local running=0
    # Move cursor up to overwrite
    printf "\033[${count}A"

    for ((i = 0; i < count; i++)); do
      local pid=${pids[$i]}
      local label=${labels[$i]}
      local est=${ests[$i]}
      local max=${maxes[$i]}

      if [ "${done_at[$i]}" -gt 0 ]; then
        # Already finished
        local bar
        bar=$(_progress_bar_chars "$width" 0)
        printf "\r\033[K  %b%s%b %-25s [%s] 100%% (%ds)\n" "$TUI_GREEN" "$TUI_OK" "$TUI_RESET" "$label" "$bar" "${done_at[$i]}"
      elif ! kill -0 "$pid" 2> /dev/null; then
        # Just finished
        done_at[$i]=$((elapsed > 0 ? elapsed : 1))
        local bar
        bar=$(_progress_bar_chars "$width" 0)
        printf "\r\033[K  %b%s%b %-25s [%s] 100%% (%ds)\n" "$TUI_GREEN" "$TUI_OK" "$TUI_RESET" "$label" "$bar" "$elapsed"
      elif [ "$elapsed" -ge "$max" ]; then
        # Timeout
        kill_tree "$pid"
        done_at[$i]=$elapsed
        printf "\r\033[K  %b%s%b %-25s cancelled after %ds (timeout)\n" "$TUI_YELLOW" "$TUI_WARN" "$TUI_RESET" "$label" "$elapsed"
      else
        # Still running
        running=$((running + 1))
        local pct=$((elapsed * 100 / est))
        [ "$pct" -gt 95 ] && pct=95
        local filled=$((pct * width / 100))
        local empty=$((width - filled))
        local bar
        bar=$(_progress_bar_chars "$filled" "$empty")
        printf "\r\033[K  %b%s%b %-25s [%s] %3d%% (%ds)\n" "$TUI_CYAN" "$TUI_INFO" "$TUI_RESET" "$label" "$bar" "$pct" "$elapsed"
      fi
    done

    [ "$running" -eq 0 ] && break
    sleep 1
    elapsed=$((elapsed + 1))
  done
}
