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
STANDARDS="$ZERO_DIR/standards/roadmap-standards.md"
MANIFEST="$ZERO_DIR/component.yml"

echo ""
echo "=== req-003 AC-1: the standards name the stop ==="
SETUP=$(awk '/^#### Setup stop/{f=1;next} /^#{1,4} /{f=0} f' "$STANDARDS")
assert_contains "I-D Advance: Setup:" "$SETUP" "req-003 AC-1: the section holds the setup stop line"
assert_contains "Restart: Setup:" "$SETUP" "req-003 AC-1: the section holds the combined line"
for p in "ravintio-zero/skills/" "ravintio-zero/hooks/" "ravintio-zero/setup.sh" "ravintio-zero/setup/"; do
  assert_contains "$p" "$SETUP" "req-003 AC-1: the section names $p"
done
assert_contains "Confirmation:" "$SETUP" "req-003 AC-1: the section names the Confirmation: row"
assert_contains ".claude/settings.json" "$SETUP" "req-003 AC-1: the section names the hook check"

echo ""
echo "=== req-003 AC-2: the manifest lists the stop ==="
RESP=$(awk '/^responsibilities:/{f=1;next} /^[a-z_]+:/{f=0} f' "$MANIFEST")
assert_contains "Setup:" "$RESP" "req-003 AC-2: responsibilities name the Setup: stop"

print_summary
