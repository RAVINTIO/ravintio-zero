#!/usr/bin/env bash
# Test: 0000388 req-004 question-form
# The discovery coaching reference sets a choice menu for closed questions,
# plain text for open ones, and all, some, change options for list approval.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

echo "=== AC-1: closed and open rules ==="
assert_rule question-closed "choice tool" "AskUserQuestion" "recommended option first" "one decision" "Example"
assert_rule question-open "plain text" "never invent options" "p95" "Example"

echo "=== AC-2: list approval and fallback ==="
assert_rule question-list "Agree to all" "Agree to some" "Change wording" "Other" "Example"
assert_rule question-no-tool "no choice tool" "text form"
assert_rule question-agreement "Yes, I agree to all six" "explicit agreement"

print_summary
