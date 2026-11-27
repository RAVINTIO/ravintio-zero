#!/usr/bin/env bash
# 0000574 req-001: rule 6 of I-E Delivery names the order of the step table.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"


echo "=== REQ-001 AC-1: rule 6 names the table order ==="
assert_rule rm-delivery-pr-body "step table" 'ascending `Version` order' "merge order" "reshape-initiative.mjs"

print_summary
