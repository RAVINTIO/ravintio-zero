#!/usr/bin/env bash
# 0000574 req-001: rule 6 of I-E Delivery names the order of the step table.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STD="$ZERO_DIR/standards/roadmap-standards.md"
DELIVERY="$(awk '/^### I-E Delivery/{f=1;next} f' "$STD")"
RULE6="$(printf '%s\n' "$DELIVERY" | grep -E '^6\. ')"

echo "=== REQ-001 AC-1: rule 6 names the table order ==="
assert_contains "step table" "$RULE6" "REQ-001 AC-1: rule 6 names the step table"
assert_contains 'ascending `Version` order' "$RULE6" "REQ-001 AC-1: rule 6 names ascending Version order"
assert_contains "merge order" "$RULE6" "REQ-001 AC-1: rule 6 says it is merge order"
assert_contains "reshape-initiative.mjs" "$RULE6" "REQ-001 AC-1: rule 6 names the script that prints the table"

print_summary
