#!/usr/bin/env bash
# migrate-adr-home.sh - Move every ADR into docs/adr under a four-digit number.
# Idempotent: safe to run multiple times. A second run changes nothing.
# Run from the consumer project root, the folder that holds ravintio-zero/.
# Usage: migrate-adr-home.sh [--dry-run] [--root <dir>] [--no-restore] [--include-current]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v node >/dev/null 2>&1; then
    echo "ERROR: node is not installed. Install Node.js, then run this helper again."
    exit 1
fi

exec node "$SCRIPT_DIR/migrate-adr-home.mjs" "$@"
