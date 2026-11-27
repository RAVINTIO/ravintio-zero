#!/usr/bin/env bash
# Tests for feature 0000327-squash-before-main, req-003: the ship skill
# squashes before main, limits force-push, and waits for CI.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"

section() {
  awk -v h="$1" '
    $0 == h { on = 1; lvl = index(h, " "); next }
    on && /^#+ / { if (index($0, " ") <= lvl) exit }
    on { print }' "$2"
}
has() { printf '%s\n' "$2" | grep -qF -- "$1" && echo yes || echo no; }

echo ""
echo "=== req-003 AC-1: force-push limit ==="
assert_equals "yes" "$(grep -q '^## PRs into main' "$SHIP" && echo yes || echo no)" "AC-1: section '## PRs into main' exists"
SEC="$(for id in shp-main-single-commit shp-main-commit-title shp-main-replacement-pr shp-main-no-force-push shp-main-wait-ci; do rule_text "$id"; done)"
assert_equals "no" "$(has '--force-with-lease' "$SEC")" "AC-1: no --force-with-lease"
assert_rule shp-main-replacement-pr 'replacement PR' 'hotfix/*' 'chore/*'
assert_rule shp-main-no-force-push 'never force-push' 'main' 'initiative/*' 'feat/*' 'hotfix/*' 'chore/*'

echo ""
echo "=== req-003 AC-2: squash and wait ==="
assert_rule shp-main-single-commit 'one commit on `origin/main`'
assert_rule shp-main-commit-title 'commit-standards.md' 'PR number' 'squashed'
assert_rule shp-main-wait-ci 'green CI' 'before you ask'
assert_rule shp-hard-limit-merge '## PRs into main'
HL="$(grep -E '^5\. ' "$SHIP")"
assert_equals "yes" "$(has '## PRs into main' "$HL")" "AC-2: Hard Limit 5 still opens with its number"

echo ""
echo "=== req-003 AC-3: size ==="
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "AC-3: skill text $TOTAL <= 1720"

print_summary
