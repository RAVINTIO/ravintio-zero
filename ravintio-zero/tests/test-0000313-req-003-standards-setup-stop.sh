#!/usr/bin/env bash
# Tests for feature 0000313-driver-setup-stop, req-003: the roadmap standards document the
# Setup: stop and the manifest lists it.
#
# AC-1: the Setup stop section holds the lines, the watched paths, and the rerun steps.
# AC-2: component.yml responsibilities name the Setup: stop.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
MANIFEST="$ZERO_DIR/component.yml"

echo ""
echo "=== req-003 AC-1: the standards name the stop ==="
assert_rule rm-setup-stop-bullets "I-D Advance: Setup:" "Restart: Setup:" "Confirmation:" ".claude/settings.json"
assert_rule rm-setup-stop-intro "ravintio-zero/skills/" "ravintio-zero/hooks/" "ravintio-zero/setup.sh" "ravintio-zero/setup/"

echo ""
echo "=== req-003 AC-2: the manifest lists the stop ==="
RESP=$(awk '/^responsibilities:/{f=1;next} /^[a-z_]+:/{f=0} f' "$MANIFEST")
assert_contains "Setup:" "$RESP" "req-003 AC-2: responsibilities name the Setup: stop"

print_summary
