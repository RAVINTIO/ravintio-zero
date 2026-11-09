#!/usr/bin/env bash
# Test: 0000358 req-004 failed-suite-list
# The runners print each failed suite's file name under the totals, with and
# without RAVINTIO_TEST_QUIET=1, and print no list when every suite passes.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

make_repo() {
  local dir="$WORK/$1" failing="$2"
  mkdir -p "$dir/tests/helpers" "$dir/tests/regression"
  cp "$SCRIPT_DIR/run-tests.sh" "$SCRIPT_DIR/run-tests.ps1" "$dir/tests/"
  cp "$SCRIPT_DIR/helpers/assert.sh" "$dir/tests/helpers/"
  printf '{"tests":[]}\n' > "$dir/tests/regression/regression-manifest.json"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$dir/tests/test-zz-pass.sh"
  if [ "$failing" = yes ]; then
    printf '#!/usr/bin/env bash\nexit 1\n' > "$dir/tests/test-zz-broken.sh"
    printf '#!/usr/bin/env bash\nexit 1\n' > "$dir/tests/regression/test-zz-regress-broken.sh"
  fi
  git -C "$dir" init -q
  git -C "$dir" stage -A
  git -C "$dir" -c user.name=t -c user.email=t@example.com commit -qm base
  printf '%s' "$dir"
}

run_runner() {
  RAVINTIO_PWSH=/nonexistent/pwsh bash "$1/tests/run-tests.sh" 2>&1
}

# after_totals <output>: the text after the Feature suites line.
after_totals() { printf '%s\n' "$1" | sed -n '/^Feature suites:/,$p'; }

echo ""
echo "=== req-004 (a): a failed suite is named after the totals ==="
D="$(make_repo a yes)"
OUT="$(run_runner "$D")"
TAIL="$(after_totals "$OUT")"
assert_contains "Failed suites:" "$TAIL" "req-004 (a): the list has a heading after the totals"
assert_contains "test-zz-broken.sh" "$TAIL" "req-004 (a): the feature suite name is listed"
assert_contains "test-zz-regress-broken.sh" "$TAIL" "req-004 (a): the regression suite name is listed"
assert_not_contains "test-zz-pass.sh" "$TAIL" "req-004 (a): a passing suite is not listed"

echo ""
echo "=== req-004 (b): quiet mode lists too ==="
QOUT="$(RAVINTIO_TEST_QUIET=1 RAVINTIO_PWSH=/nonexistent/pwsh bash "$D/tests/run-tests.sh" 2>&1)"
QTAIL="$(after_totals "$QOUT")"
assert_contains "Failed suites:" "$QTAIL" "req-004 (b): quiet mode prints the heading"
assert_contains "test-zz-broken.sh" "$QTAIL" "req-004 (b): quiet mode prints the name"

echo ""
echo "=== req-004 (c): a clean run prints no list ==="
G="$(make_repo b no)"
GOUT="$(run_runner "$G")"
assert_not_contains "Failed suites:" "$GOUT" "req-004 (c): no heading when every suite passes"

echo ""
echo "=== req-004 (d): the PowerShell runner uses the same heading ==="
assert_contains "Failed suites:" "$(cat "$SCRIPT_DIR/run-tests.ps1")" "req-004 (d): run-tests.ps1 prints the heading"

print_summary
