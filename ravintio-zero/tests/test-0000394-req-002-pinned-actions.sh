#!/usr/bin/env bash
# Tests for feature 0000394-github-security-and-ci-lint, req-002 and req-003.
# req-002: every action is pinned by SHA, and the dependency review and
# Scorecard workflows exist.
# req-003: the workflow-lint job runs actionlint and zizmor, and both pass
# when they are installed.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
WF_DIR="$ROOT/.github/workflows"
TPL="$SCRIPT_DIR/../hooks/ravintio.yml"

echo ""
echo "=== req-002 AC-1: no action uses a floating tag ==="
FLOATING="$(grep -hE '^\s*(-\s+)?uses:' "$WF_DIR"/*.yml "$TPL" | grep -vE 'uses:\s+\./' | grep -vE '@[0-9a-f]{40}(\s|$)' || true)"
assert_equals "" "$FLOATING" "req-002 AC-1: every uses line ends in a 40-character SHA"

echo ""
echo "=== req-002 AC-2: the supply-chain workflows exist ==="
DEP="$(cat "$WF_DIR/dependency-review.yml" 2>/dev/null)"
SCO="$(cat "$WF_DIR/scorecard.yml" 2>/dev/null)"
assert_contains "actions/dependency-review-action@" "$DEP" "req-002 AC-2: dependency review runs its action"
assert_contains "ossf/scorecard-action@" "$SCO" "req-002 AC-2: Scorecard runs its action"
assert_contains "contents: read" "$DEP" "req-002: dependency review keeps read-only contents"
assert_contains "contents: read" "$SCO" "req-002: Scorecard keeps read-only contents"
if command -v ruby >/dev/null 2>&1; then
  for f in dependency-review scorecard; do
    assert_equals "" "$(bash "$SCRIPT_DIR/helpers/unguarded-jobs.sh" "$WF_DIR/$f.yml")" "req-002 AC-2: every job in $f.yml carries the guard or the marker"
  done
fi

echo ""
echo "=== req-003 AC-1: the lint job runs both tools ==="
WF="$(cat "$WF_DIR/ravintio.yml")"
JOB="$(printf '%s\n' "$WF" | awk '/^  workflow-lint:/{f=1;print;next} f&&/^  [A-Za-z0-9_-]+:/{f=0} f')"
assert_contains "actionlint" "$JOB" "req-003 AC-1: the job runs actionlint"
assert_contains "zizmor" "$JOB" "req-003 AC-1: the job runs zizmor"
assert_contains ".github/workflows" "$JOB" "req-003 AC-1: the job lints .github/workflows"
if command -v ruby >/dev/null 2>&1; then
  assert_equals "" "$(bash "$SCRIPT_DIR/helpers/unguarded-jobs.sh" "$WF_DIR/ravintio.yml")" "req-003: every job in ravintio.yml carries the guard or the marker"
fi

echo ""
echo "=== req-003 AC-2: the workflows pass the linters ==="
if command -v actionlint >/dev/null 2>&1; then
  ( cd "$ROOT" && actionlint .github/workflows/*.yml >/dev/null 2>&1 )
  assert_equals "0" "$?" "req-003 AC-2: actionlint exits 0"
else
  echo "  NOTE: actionlint not installed, CI checks it"
fi
if command -v zizmor >/dev/null 2>&1; then
  ( cd "$ROOT" && zizmor --no-online-audits .github/workflows >/dev/null 2>&1 )
  assert_equals "0" "$?" "req-003 AC-2: zizmor exits 0"
else
  echo "  NOTE: zizmor not installed, CI checks it"
fi

print_summary
