#!/usr/bin/env bash
# Tests for feature 0000315-isolated-test-state, req-001: the runners clear every
# RAVINTIO_* variable before each suite, except RAVINTIO_PWSH, RAVINTIO_TIMING_FILE, and RAVINTIO_TEST_QUIET.
# Each case runs a copy of a real runner over a small tests/ folder that holds one probe suite.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# The nested runners must print probe lines, so a quiet outer run must not reach them.
unset RAVINTIO_TEST_QUIET
source "$SCRIPT_DIR/helpers/assert.sh"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

make_tests_dir() {
  local dir="$WORK/$1"
  mkdir -p "$dir/tests/helpers" "$dir/tests/regression"
  cp "$SCRIPT_DIR/run-tests.sh" "$SCRIPT_DIR/run-tests.ps1" "$dir/tests/"
  cp "$SCRIPT_DIR/helpers/assert.sh" "$dir/tests/helpers/"
  printf '{"tests":[]}\n' > "$dir/tests/regression/regression-manifest.json"
  cat > "$dir/tests/test-probe.sh" <<'PROBE'
#!/usr/bin/env bash
echo "PROBE_STEP=${RAVINTIO_INITIATIVE_STEP-unset}"
echo "PROBE_QUIET=${RAVINTIO_TEST_QUIET-unset}"
echo "PROBE_OTHER=${RAVINTIO_SOMETHING_ELSE-unset}"
echo "PROBE_PWSH=${RAVINTIO_PWSH-unset}"
exit 0
PROBE
  printf '%s' "$dir"
}

echo ""
echo "=== req-001 (a): run-tests.sh clears the variables ==="
D="$(make_tests_dir a)"
OUT="$(RAVINTIO_INITIATIVE_STEP=1 RAVINTIO_SOMETHING_ELSE=x RAVINTIO_PWSH=/nonexistent/pwsh bash "$D/tests/run-tests.sh" 2>&1)"
assert_contains "PROBE_STEP=unset" "$OUT" "AC-1: RAVINTIO_INITIATIVE_STEP is unset in the suite"
assert_contains "PROBE_OTHER=unset" "$OUT" "AC-1: an unlisted RAVINTIO_ variable is unset in the suite"
assert_contains "PROBE_PWSH=/nonexistent/pwsh" "$OUT" "AC-2: RAVINTIO_PWSH reaches the suite"
assert_contains "All tests passed." "$OUT" "AC-1: the run passes"

echo ""
echo "=== req-001 (b): the quiet setting still works and reaches the suite ==="
OUT="$(RAVINTIO_TEST_QUIET=1 RAVINTIO_PWSH=/nonexistent/pwsh bash "$D/tests/run-tests.sh" 2>&1)"
assert_not_contains "PROBE_STEP" "$OUT" "AC-3: quiet mode hides the suite output"
cat > "$D/tests/test-quiet-probe.sh" <<'PROBE'
#!/usr/bin/env bash
echo "PROBE_QUIET=${RAVINTIO_TEST_QUIET-unset}"
exit 1
PROBE
OUT="$(RAVINTIO_TEST_QUIET=1 RAVINTIO_PWSH=/nonexistent/pwsh bash "$D/tests/run-tests.sh" 2>&1)"
assert_contains "PROBE_QUIET=1" "$OUT" "AC-3: RAVINTIO_TEST_QUIET reaches the suite, and a failing suite still prints"
rm -f "$D/tests/test-quiet-probe.sh"

echo ""
echo "=== req-001 (c): the header names the rule ==="
assert_contains "every RAVINTIO_" "$(sed -n '1,25p' "$SCRIPT_DIR/run-tests.sh")" "run-tests.sh header states the rule"
assert_contains "every RAVINTIO_" "$(sed -n '1,25p' "$SCRIPT_DIR/run-tests.ps1")" "run-tests.ps1 header states the rule"

echo ""
echo "=== req-001 (d): run-tests.ps1 clears the variables ==="
PWSH="${RAVINTIO_PWSH:-pwsh}"
if command -v "$PWSH" >/dev/null 2>&1; then
  D="$(make_tests_dir d)"
  rm -f "$D/tests/test-probe.sh"
  cat > "$D/tests/test-probe.ps1" <<'PROBE'
foreach ($n in 'RAVINTIO_INITIATIVE_STEP','RAVINTIO_SOMETHING_ELSE') {
    $v = [Environment]::GetEnvironmentVariable($n)
    if ($null -eq $v) { Write-Host "PROBE_${n}=unset" } else { Write-Host "PROBE_${n}=$v" }
}
exit 0
PROBE
  OUT="$(RAVINTIO_INITIATIVE_STEP=1 RAVINTIO_SOMETHING_ELSE=x "$PWSH" -NoProfile -File "$D/tests/run-tests.ps1" 2>&1)"
  assert_contains "PROBE_RAVINTIO_INITIATIVE_STEP=unset" "$OUT" "AC-1: a PowerShell suite sees the step variable unset"
  assert_contains "PROBE_RAVINTIO_SOMETHING_ELSE=unset" "$OUT" "AC-1: a PowerShell suite sees an unlisted variable unset"
else
  echo "  SKIP: pwsh not found"
fi

echo ""
echo "=== req-001 (e): a suite can still set a variable for its own call ==="
D="$(make_tests_dir e)"
cat > "$D/tests/test-sets.sh" <<'PROBE'
#!/usr/bin/env bash
echo "OWN_CALL=$(RAVINTIO_INITIATIVE_STEP=1 bash -c 'echo ${RAVINTIO_INITIATIVE_STEP-unset}')"
exit 0
PROBE
OUT="$(RAVINTIO_INITIATIVE_STEP=1 RAVINTIO_PWSH=/nonexistent/pwsh bash "$D/tests/run-tests.sh" 2>&1)"
assert_contains "OWN_CALL=1" "$OUT" "the suite's own setting still reaches its call"

print_summary
