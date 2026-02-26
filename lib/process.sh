#!/bin/bash
# Process management: kill_tree, progress_bar, wait_parallel

# Kill process + all child processes (Claude spawns sub-agents)
kill_tree() {
  local pid=$1
  pkill -P "$pid" 2>/dev/null || true
  kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
}

# Progress bar for a single process
# Usage: progress_bar <pid> <label> [est_seconds] [max_seconds]
progress_bar() {
  local pid=$1 label=$2 est=${3:-120} max=${4:-600}
  local width=30 elapsed=0
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$elapsed" -ge "$max" ]; then
      kill_tree "$pid"
      printf "\r  ⚠️  %s cancelled after %ds (timeout)%*s\n" "$label" "$elapsed" 20 ""
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

# Parallel progress bars for multiple processes
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
        printf "\r  ⚠️  %-25s cancelled after %ds (timeout)%*s\n" "$label" "$elapsed" 10 ""
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
