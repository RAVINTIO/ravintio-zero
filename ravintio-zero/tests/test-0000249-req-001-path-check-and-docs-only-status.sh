#!/usr/bin/env bash
# Tests for feature 0000249-check-path-before-missing-claims, req-001: the
# validate-and-accept skill requires a PATH search before a missing-program
# report and defines the unverified (docs only) status.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SKILL="$SCRIPT_DIR/../skills/ravintio-validate-and-accept/SKILL.md"
ALL=$(cat "$SKILL")

echo ""
echo "=== req-001 AC-1: the skill holds the PATH search rule ==="
VERIFY=$(awk '/^## Verify by execution/{f=1;next} /^## /{f=0} f' "$SKILL")
assert_contains 'command -v {program}' "$VERIFY" "req-001 AC-1: the rule runs command -v"
assert_contains 'before a report says a program is missing' "$VERIFY" "req-001 AC-1: the rule applies before a missing-program report"
assert_contains '/opt/homebrew/bin' "$VERIFY" "req-001 AC-1: the rule names /opt/homebrew/bin"
assert_contains '/usr/local/bin' "$VERIFY" "req-001 AC-1: the rule names /usr/local/bin"
assert_contains '~/.local/bin' "$VERIFY" "req-001 AC-1: the rule names ~/.local/bin"

echo ""
echo "=== req-001 AC-2: the skill defines the docs-only status ==="
assert_contains '`unverified (docs only)`' "$VERIFY" "req-001 AC-2: the outcomes list defines the status"
assert_contains 'never counts as `verified`' "$VERIFY" "req-001 AC-2: the status never counts as verified"
assert_contains 'documentation alone' "$VERIFY" "req-001 AC-2: the status covers a claim that documentation alone backs"

echo ""
echo "=== req-001 AC-3: the evidence rules ask for the search and the list ==="
GATE=$(awk '/^## Acceptance gate/{f=1;next} /^## /{f=0} f' "$SKILL")
assert_contains 'the `PATH` check commands' "$GATE" "req-001 AC-3: the gate asks for the PATH check commands"
assert_contains 'each unverified claim by name' "$GATE" "req-001 AC-3: the gate asks for the unverified claims by name"
assert_contains 'never raw command output' "$GATE" "req-001 AC-3: the evidence keeps raw output out"

print_summary
