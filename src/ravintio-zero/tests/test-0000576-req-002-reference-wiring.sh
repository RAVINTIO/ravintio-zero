#!/usr/bin/env bash
# Test: 0000576 req-002 reference-wiring
# The Phase Invocation reference names the build-log check on phase Start times.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

echo "=== AC-1: the reference names the check ==="
assert_rule phase-start-time-check "build-log-check.mjs" "Start" "first artifact commit"

print_summary
