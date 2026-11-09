#!/usr/bin/env bash
# Test: 0000387 req-003 and req-005 coaching checks
# P0 coaching checks that content exists before it confirms a content criterion,
# offers a reworded criterion when none exists, and asks the major-bump question.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

FIXTURE="$SCRIPT_DIR/fixtures/0000387-mermaid-no-diagram"

# Greps a repo for Mermaid code fences and prints the rule's expectation.
check_mermaid_content() {
  if grep -rq '```mermaid' "$1" 2>/dev/null; then
    echo "instance-found"
  else
    echo "reworded-offer"
  fi
}

echo "=== REQ-003: criterion content check ==="
assert_rule criterion-content-exists "existing content" "at least one" "grep"
assert_rule criterion-reword-offer "reworded" "design gate" "Mermaid" "SVG"

echo "=== REQ-003: fixture ==="
assert_contains "reworded-offer" "$(check_mermaid_content "$FIXTURE")" \
  "fixture has no mermaid fence, so the rule offers a reworded criterion"

echo "=== REQ-005: major-bump coaching ==="
assert_rule major-bump-question "advisory" "major bump" "pre-approved" "only fix"
assert_rule major-bump-record "Approved dependencies" "design.md"

print_summary
