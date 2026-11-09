#!/usr/bin/env bash
# Tests for feature 0000319-initiative-history-checks, req-005.
#
# A pack doc names the GitHub ruleset that allows only the merge commit method on main.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
DOC="$ZERO_DIR/docs/main-ruleset.md"

echo "=== req-005 AC-1: the doc names the setting ==="
if [ -f "$DOC" ]; then R=present; else R=missing; fi
assert_equals "present" "$R" "req-005 AC-1: docs/main-ruleset.md exists"
TEXT="$(cat "$DOC" 2>/dev/null)"
assert_contains 'ruleset' "$TEXT" "req-005 AC-1: names the ruleset"
assert_contains 'merge commit' "$TEXT" "req-005 AC-1: names the merge commit method"
assert_contains '`main`' "$TEXT" "req-005 AC-1: names main"
assert_contains 'initiative/**' "$TEXT" "req-005 AC-1: names initiative/**"
assert_contains 'squash' "$TEXT" "req-005 AC-1: says squash stays allowed"
assert_contains 'human applies' "$TEXT" "req-005 AC-1: says the human applies it"

print_summary
