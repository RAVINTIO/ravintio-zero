#!/usr/bin/env bash
# Tests for feature 0000448-driver-runs-approved-setup-command, req-003: the roadmap standards and
# the initiative skill state that the driver runs the approved setup command.
#
# AC-1: the Setup stop section names setup-command.mjs, the allowed form, and the stop cases.
# AC-2: the Stops section of the initiative skill says the driver runs the command.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STANDARDS="$SCRIPT_DIR/../standards/roadmap-standards.md"
SKILL="$SCRIPT_DIR/../skills/ravintio-initiative/SKILL.md"

echo ""
echo "=== req-003 AC-1: the Setup stop section ==="
SETUP=$(awk '/^#### Setup stop/{f=1;next} /^#{1,4} /{f=0} f' "$STANDARDS")
assert_contains "setup-command.mjs" "$SETUP" "req-003 AC-1: names the helper"
assert_contains "Confirmation:" "$SETUP" "req-003 AC-1: names the Confirmation row"
assert_contains "ran the approved setup command" "$SETUP" "req-003 AC-1: names the ran line"
assert_contains "no shell" "$SETUP" "req-003 AC-1: says the driver uses no shell"
assert_contains "The approved setup command failed" "$SETUP" "req-003 AC-1: names the failure sentence"

echo ""
echo "=== req-003 AC-2: the Stops section of the skill ==="
STOPS=$(awk '/^## Stops/{f=1;next} /^## /{f=0} f' "$SKILL")
assert_contains "runs the approved setup command" "$STOPS" "req-003 AC-2: the driver runs the command"
assert_contains "did not run" "$STOPS" "req-003 AC-2: a Setup: line means it did not run"

print_summary
