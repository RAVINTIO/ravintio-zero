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
assert_rule piv-p3-missing-programs 'command -v {program}' 'before a report says a program is missing' '/opt/homebrew/bin' '/usr/local/bin' '~/.local/bin'

echo ""
echo "=== req-001 AC-2: the skill defines the docs-only status ==="
assert_rule piv-p3-unverified-status '`unverified (docs only)`' 'never counts as `verified`' 'documentation alone'

echo ""
echo "=== req-001 AC-3: the evidence rules ask for the search and the list ==="
assert_rule piv-p3-gate-search-evidence 'the `PATH` check commands' 'each unverified claim by name'
assert_rule piv-p3-autonomous-evidence 'never raw command output'

print_summary
