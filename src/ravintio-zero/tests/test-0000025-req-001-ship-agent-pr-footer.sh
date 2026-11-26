#!/usr/bin/env bash
# Tests for feature 0000025, req-001: PR bodies carry no AI attribution by
# default. The rule now lives in the ship phase skill (ravintio-ship),
# which owns the PR step behind the always-stop final gate.
#
# ravintio-ship/SKILL.md is a prose skill file, not executable code, so
# these are content-assertion tests against the SKILL.md text.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SHIP_SKILL="$ZERO_DIR/skills/ravintio-ship/SKILL.md"

SHIP_CONTENT=$(cat "$SHIP_SKILL")


echo ""
echo "=== req-001: the PR step exists and offers both delivery paths ==="

assert_equals "yes" "$(grep -q '^### Step 9: PR' "$SHIP_SKILL" && echo yes || echo no)" \
  "req-001: ravintio-ship documents a PR step"
assert_rule shp-pr-title-body "gh pr create"
# The option text sits in a code block, so it has no rule anchor.
assert_contains "give me the PR title and description" "$SHIP_CONTENT" \
  "req-001: human-pushes path hands over title and description"

echo ""
echo "=== req-001: no AI attribution in PR bodies ==="

assert_rule shp-pr-title-body "PR bodies carry no AI attribution"

# 0000169 req-001: the skill names the banned line in prose, so only a line
# that starts with the footer counts as a template.
if printf '%s\n' "$SHIP_CONTENT" | grep -qE '^(🤖 )?Generated with'; then
  echo "  FAIL: req-001: an attribution footer template survives in ravintio-ship"
  ((FAIL++)) || true
else
  echo "  PASS: req-001: no attribution footer template anywhere in ravintio-ship"
  ((PASS++)) || true
fi

echo ""
echo "=== req-001: local-git-only override scan is still present ==="

assert_rule shp-pr-local-git-only "ravintio-overrides/instructions/" "local-git-only"

print_summary
