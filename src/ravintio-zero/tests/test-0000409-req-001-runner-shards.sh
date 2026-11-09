#!/usr/bin/env bash
# Tests for feature 0000409-ci-shards, req-001: the runners run shard i of n from RAVINTIO_SHARD.
# Each world copies run-tests.sh into a temporary tests folder with five passing suites, two of them
# in regression/, and no git repository, so the tree check stays off.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

T="$WORK/tests"
mkdir -p "$T/regression"
cp "$SCRIPT_DIR/run-tests.sh" "$T/run-tests.sh"
for name in a b c; do printf '#!/usr/bin/env bash\necho "ran %s"\n' "$name" > "$T/test-$name.sh"; done
for name in d e; do printf '#!/usr/bin/env bash\necho "ran %s"\n' "$name" > "$T/regression/test-$name.sh"; done

# run_shard VALUE: sets OUT, CODE, and RAN (the sorted suite letters that ran).
run_shard() {
  unset RAVINTIO_TEST_QUIET
  OUT="$(RAVINTIO_SHARD="$1" RAVINTIO_PWSH=/nonexistent bash "$T/run-tests.sh" 2>&1)"
  CODE=$?
  RAN="$(printf '%s\n' "$OUT" | sed -n 's/^ran \([a-e]\)$/\1/p' | LC_ALL=C sort | tr -d '\n')"
}

run_shard ""
assert_equals "0" "$CODE" "REQ-001 AC-2: an unset shard passes ($OUT)"
assert_equals "abcde" "$RAN" "REQ-001 AC-2: an unset shard runs every suite"

run_shard "1/2"; ONE="$RAN"; C1="$CODE"
run_shard "2/2"; TWO="$RAN"; C2="$CODE"
assert_equals "0 0" "$C1 $C2" "REQ-001 AC-1: both shards pass"
assert_equals "abcde" "$(printf '%s%s' "$ONE" "$TWO" | fold -w1 | LC_ALL=C sort | tr -d '\n')" \
  "REQ-001 AC-1: the two shards together run each suite exactly once ($ONE + $TWO)"
assert_equals "yes" "$([ -n "$ONE" ] && [ -n "$TWO" ] && echo yes || echo no)" "REQ-001 AC-1: neither shard is empty"

run_shard "2/3"
assert_equals "0" "$CODE" "REQ-001 AC-1: shard 2 of 3 passes"
assert_equals "be" "$RAN" "REQ-001 AC-1: shard 2 of 3 runs suites 2 and 5 of the ordered list, regression included"

for bad in "3/2" "0/2" "x" "1/0" "1/2/3"; do
  run_shard "$bad"
  assert_equals "2" "$CODE" "REQ-001 AC-3: RAVINTIO_SHARD=$bad exits 2"
  assert_equals "" "$RAN" "REQ-001 AC-3: RAVINTIO_SHARD=$bad runs no suite"
  assert_contains "RAVINTIO_SHARD must be i/n" "$OUT" "REQ-001 AC-3: RAVINTIO_SHARD=$bad names the form"
done

PS_RUNNER="$SCRIPT_DIR/run-tests.ps1"
assert_contains 'RAVINTIO_SHARD' "$(cat "$PS_RUNNER")" "REQ-001: run-tests.ps1 reads RAVINTIO_SHARD"
assert_contains 'RAVINTIO_SHARD must be i/n' "$(cat "$PS_RUNNER")" "REQ-001 AC-3: run-tests.ps1 names the form on a bad value"

print_summary
