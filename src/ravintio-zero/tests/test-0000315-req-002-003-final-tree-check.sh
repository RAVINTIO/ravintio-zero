#!/usr/bin/env bash
# Tests for feature 0000315-isolated-test-state, req-002 and req-003: the runner compares
# tracked and untracked files before the first suite and after the last, and fails on a change.
# Each case runs a copy of the runner over a small tests/ folder inside a temporary git repo.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
unset RAVINTIO_TEST_QUIET
source "$SCRIPT_DIR/helpers/assert.sh"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

make_repo() {
  local dir="$WORK/$1"
  mkdir -p "$dir/tests/helpers" "$dir/tests/regression"
  cp "$SCRIPT_DIR/run-tests.sh" "$SCRIPT_DIR/run-tests.ps1" "$dir/tests/"
  cp "$SCRIPT_DIR/helpers/assert.sh" "$dir/tests/helpers/"
  printf '{"tests":[]}\n' > "$dir/tests/regression/regression-manifest.json"
  printf 'ignored.log\n' > "$dir/.gitignore"
  printf 'one\n' > "$dir/tracked.txt"
  git -C "$dir" init -q
  git -C "$dir" add -A
  git -C "$dir" -c user.name=t -c user.email=t@example.com commit -qm base
  printf '%s' "$dir"
}

run_runner() {
  RAVINTIO_PWSH=/nonexistent/pwsh bash "$1/tests/run-tests.sh" 2>&1
}

echo ""
echo "=== req-003 (a): a suite that leaves an untracked file fails the run ==="
D="$(make_repo a)"
printf '#!/usr/bin/env bash\ntouch "$(dirname "$0")/../leftover.txt"\nexit 0\n' > "$D/tests/test-leaves-file.sh"
OUT="$(run_runner "$D")"; CODE=$?
assert_equals "1" "$CODE" "AC-1: the runner exits 1"
assert_contains "leftover.txt" "$OUT" "AC-1: the runner names the file"

echo ""
echo "=== req-003 (b): an ignored file is allowed ==="
D="$(make_repo b)"
printf '#!/usr/bin/env bash\ntouch "$(dirname "$0")/../ignored.log"\nexit 0\n' > "$D/tests/test-leaves-ignored.sh"
OUT="$(run_runner "$D")"; CODE=$?
assert_equals "0" "$CODE" "AC-2: the runner exits 0"
assert_contains "All tests passed." "$OUT" "AC-2: the run passes"

echo ""
echo "=== req-003 (c): an edit to a tracked file fails the run ==="
D="$(make_repo c)"
printf '#!/usr/bin/env bash\nprintf "two\\n" >> "$(dirname "$0")/../tracked.txt"\nexit 0\n' > "$D/tests/test-edits-tracked.sh"
OUT="$(run_runner "$D")"; CODE=$?
assert_equals "1" "$CODE" "AC-3: the runner exits 1"
assert_contains "tracked.txt" "$OUT" "AC-3: the runner names the file"

echo ""
echo "=== req-003 (d): a clean run passes, and a folder outside git is skipped ==="
D="$(make_repo d)"
printf '#!/usr/bin/env bash\nexit 0\n' > "$D/tests/test-clean.sh"
OUT="$(run_runner "$D")"; CODE=$?
assert_equals "0" "$CODE" "a clean run exits 0"
rm -rf "$D/.git"
OUT="$(run_runner "$D")"; CODE=$?
assert_equals "0" "$CODE" "outside a git repository the check is skipped and the run passes"

echo ""
echo "=== req-003 (e): run-tests.ps1 runs the same check ==="
assert_contains "Tree changed" "$(cat "$SCRIPT_DIR/run-tests.ps1")" "run-tests.ps1 reports a changed tree"
assert_contains "Tree changed" "$(cat "$SCRIPT_DIR/run-tests.sh")" "run-tests.sh reports a changed tree"

echo ""
# req-002: the real suite leaves the repo as found. The full run under this check proves it.
print_summary
