#!/usr/bin/env bash
# Test: 0000387 req-004 audit refresh at plan
# The plan skill re-runs the dependency audit before the gate, logs an Audit line,
# and stops on a fix outside the approved list. The build log template documents the line.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE="$(cat "$ZERO_DIR/templates/build-log.template.md")"

echo "=== AC-1: re-run before the gate ==="
assert_rule plan-audit-refresh "advisories" "dependency versions" "re-run" "before the plan gate" "stack declaration"

echo "=== AC-2: log line ==="
assert_rule plan-audit-refresh 'Audit: re-run at P1 ({result})'
assert_contains 'Audit: re-run at P1' "$TEMPLATE" "template documents the Audit line"

echo "=== AC-3: stop ==="
assert_rule plan-audit-refresh "Approved dependencies" "dependency exception stop" "Blocked: new dependency {name} is not on the approved list. Approve it or choose an approved alternative."

print_summary 2>/dev/null || true
