#!/usr/bin/env bash
# Test: 0000573 req-001 unit-report-fields
# The dispatch standard fixes the four fields of a unit report.
# The orchestrator rejects a report that lacks one and resumes the unit once.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STD="$ZERO_DIR/standards/agent-dispatch-standards.md"

echo "=== AC-1: the rule names the four fields ==="
assert_rule dispatch-unit-report "RED line" "GREEN line" "commit hash" "deviation"

echo "=== AC-2: reject and resume once ==="
assert_rule dispatch-unit-report "rejects" "resumes the unit once"

echo "=== NFR-001: the source and the mirror match ==="
SRC_STD="$ZERO_DIR/../src/ravintio-zero/standards/agent-dispatch-standards.md"
same=1
cmp -s "$SRC_STD" "$STD" && same=0
assert_equals "0" "$same" "both copies of the standard match"

print_summary
