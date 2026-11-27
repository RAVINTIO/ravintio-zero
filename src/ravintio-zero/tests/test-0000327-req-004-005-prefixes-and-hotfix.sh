#!/usr/bin/env bash
# Tests for feature 0000327-squash-before-main, req-004 and req-005.
#
# The standards and ruleset doc name the branches that may target main.
# A run outside an initiative cuts a hotfix branch.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STANDARDS="$ZERO_DIR/standards/roadmap-standards.md"
RULESET="$ZERO_DIR/docs/main-ruleset.md"

RULES="$(cat "$RULESET")"

echo "=== req-004 AC-1: prefixes named ==="
for P in 'initiative/*' 'chore/*' 'hotfix/*'; do
  assert_rule rm-carveout-prefix-list "\`$P\`"
  assert_contains "\`$P\`" "$RULES" "req-004 AC-1: ruleset doc names $P"
done
assert_rule carveout-feat-targets '`feat/*` branch targets an initiative branch' 'PRs into main' 'never merges'
assert_contains 'never targets `main`' "$RULES" "req-004 AC-1: ruleset doc says feat/* never targets main"
assert_contains 'never merges' "$RULES" "req-004 AC-1: ruleset doc says the agent never merges into main"

echo "=== req-004 AC-2: ruleset doc names the job ==="
assert_contains 'squash-before-main' "$RULES" "req-004 AC-2: names squash-before-main"

echo "=== req-005 AC-1: hotfix cut ==="
assert_rule p0-start-preflight 'git checkout -b hotfix/{feature-id}'
assert_not_contains 'feat/{feature-id}' "$(rule_text p0-start-preflight)" "req-005 AC-1: step 2 drops feat/{feature-id}"

echo "=== req-005 AC-2: no other pack text ==="
HITS="$(grep -rn 'checkout -b feat/' "$ZERO_DIR/skills" "$ZERO_DIR/standards" "$ZERO_DIR/templates" "$ZERO_DIR"/setup.sh "$ZERO_DIR"/setup.ps1 2>/dev/null | grep -v '/tests/')"
assert_equals "" "$HITS" "req-005 AC-2: nothing cuts a feat/ branch"

print_summary
