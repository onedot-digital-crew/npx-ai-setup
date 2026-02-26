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
