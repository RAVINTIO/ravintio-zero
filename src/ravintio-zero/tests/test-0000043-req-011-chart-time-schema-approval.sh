#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-011: chart-time schema approval.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
TPL="$ZERO_DIR/templates/initiative.template.md"
echo "=== req-011 (a) and (b): Chart predicts and approves schema changes ==="
T="$(cat "$TPL")"
assert_rule rm-chart-also 'Chart-time schema approval'
assert_rule rm-schema-steps 'data contracts' '`## Schema changes`' 'approves, edits, or strikes each row' \
  'approves every row left in the table' "pre-approve additive changes that Chart didn't predict" \
  'The default is `stop`'
assert_rule rm-schema-step-bullets 'Hard Limit 4'
assert_contains '## Schema changes' "$T" "req-011 (b): template has a Schema changes section"
assert_contains '| Step | Component | Change | Kind |' "$T" "req-011 (b): template has the Schema changes table"
assert_contains '**Unpredicted additive changes:**' "$T" "req-011 (b): template records the fallback answer"

echo ""
echo "=== req-011 (c): a step matches chart-approved changes ==="
assert_rule icrun-schema-row 'Chart-time schema approval'
assert_rule rm-schema-step-bullets 'still writes the proposal' 'same component, the same field names and types' \
  '`approved (initiative chart)`' 'carry on without stopping' 'normal schema-change exception stop' \
  '`approved (initiative chart fallback)`' 'A destructive change always stops'
assert_rule rm-impl-schema-changes 'roadmap-standards.md'

print_summary
