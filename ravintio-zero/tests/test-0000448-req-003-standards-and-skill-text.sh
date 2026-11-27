#!/usr/bin/env bash
# Tests for feature 0000448-driver-runs-approved-setup-command, req-003: the roadmap standards and
# the initiative skill state that the driver runs the approved setup command.
#
# AC-1: the Setup stop section names setup-command.mjs, the allowed form, and the stop cases.
# AC-2: the Stops section of the initiative skill says the driver runs the command.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"


echo ""
echo "=== req-003 AC-1: the Setup stop section ==="
assert_rule rm-setup-stop-bullets "setup-command.mjs" "Confirmation:" "ran the approved setup command" "no shell" "The approved setup command failed"

echo ""
echo "=== req-003 AC-2: the Stops section of the skill ==="
assert_rule ini-setup-stop "runs the approved setup command" "did not run"

print_summary
