#!/bin/bash
# Module loader for ai-setup
# Requires: SCRIPT_DIR must be set by the caller before sourcing this file.

LIB_DIR="$SCRIPT_DIR/lib"

source_lib() {
  local module="$1"
  if [ ! -f "$LIB_DIR/$module" ]; then
    echo "FATAL: Missing lib/$module" >&2
    exit 1
  fi
  source "$LIB_DIR/$module"
}

# Load system-specific plugin after SYSTEM is detected.
# Sources lib/systems/${SYSTEM}.sh if it exists, silent no-op otherwise.
# Supports comma-separated systems — loads each in order.
load_system_plugins() {
  [ -z "$SYSTEM" ] && return 0
  local sys
  IFS=',' read -ra _SYSTEMS <<< "$SYSTEM"
  for sys in "${_SYSTEMS[@]}"; do
    if [ -f "$LIB_DIR/systems/${sys}.sh" ]; then
      source "$LIB_DIR/systems/${sys}.sh"
    fi
  done
}
