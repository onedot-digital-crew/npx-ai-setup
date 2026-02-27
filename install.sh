#!/bin/bash
# @onedot/ai-setup installer
# Usage: curl -fsSL https://raw.githubusercontent.com/onedot/npx-ai-setup/main/install.sh | bash
#        curl -fsSL https://raw.githubusercontent.com/onedot/npx-ai-setup/main/install.sh | bash -s -- --with-gsd

set -e

REPO="https://github.com/onedot/npx-ai-setup"
ARCHIVE="$REPO/archive/refs/heads/main.tar.gz"
TMP=$(mktemp -d)

cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "Downloading @onedot/ai-setup..."
if ! curl -fsSL "$ARCHIVE" | tar -xz -C "$TMP" --strip-components=1; then
  echo "❌ Download failed. Check your internet connection and that the repo is accessible."
  echo "   URL: $ARCHIVE"
  exit 1
fi

# Reopen stdin from terminal so interactive prompts work under curl | bash
if [ -t 0 ]; then
  bash "$TMP/bin/ai-setup.sh" "$@"
else
  bash "$TMP/bin/ai-setup.sh" "$@" < /dev/tty
fi
