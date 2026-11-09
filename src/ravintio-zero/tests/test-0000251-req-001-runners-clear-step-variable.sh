#!/usr/bin/env bash
# Tests for feature 0000251-driver-step-fixes, req-001: the runners clear RAVINTIO_INITIATIVE_STEP.
#
# Each case runs a copy of a real runner over a small tests/ folder that holds one probe suite.
# The probe records whether the variable is set when the runner starts it.

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
echo "PROBE_BASH=${RAVINTIO_INITIATIVE_STEP-unset}"
exit 0
PROBE
  cat > "$dir/tests/regression/test-probe-regression.sh" <<'PROBE'
#!/usr/bin/env bash
echo "PROBE_REGRESSION=${RAVINTIO_INITIATIVE_STEP-unset}"
exit 0
PROBE
  printf '%s' "$dir"
}

echo ""
echo "=== req-001 (a): run-tests.sh clears the variable ==="
D="$(make_tests_dir a)"
OUT="$(RAVINTIO_INITIATIVE_STEP=1 RAVINTIO_PWSH=/nonexistent/pwsh bash "$D/tests/run-tests.sh" 2>&1)"
assert_contains "PROBE_BASH=unset" "$OUT" "req-001 (a): a feature suite sees the variable unset"
assert_contains "PROBE_REGRESSION=unset" "$OUT" "req-001 (a): a regression suite sees the variable unset"
assert_contains "All tests passed." "$OUT" "req-001 (a): the run passes"

OUT="$(RAVINTIO_INITIATIVE_STEP=1 RAVINTIO_PREFLIGHT_ONLY=1 bash "$D/tests/run-tests.sh" 2>&1)"
assert_equals "0" "$?" "req-001 (a): the preflight-only mode still exits 0"

echo ""
echo "=== req-001 (b): the header says what the runner does ==="
assert_contains "RAVINTIO_INITIATIVE_STEP" "$(sed -n '1,20p' "$SCRIPT_DIR/run-tests.sh")" "req-001 (b): run-tests.sh header names the variable"
assert_contains "RAVINTIO_INITIATIVE_STEP" "$(sed -n '1,20p' "$SCRIPT_DIR/run-tests.ps1")" "req-001 (b): run-tests.ps1 header names the variable"

echo ""
echo "=== req-001 (c): run-tests.ps1 clears the variable ==="
PWSH="${RAVINTIO_PWSH:-pwsh}"
if command -v "$PWSH" >/dev/null 2>&1; then
  D="$(make_tests_dir c)"
  rm -f "$D/tests/test-probe.sh" "$D/tests/regression/test-probe-regression.sh"
  cat > "$D/tests/test-probe.ps1" <<'PROBE'
$v = [Environment]::GetEnvironmentVariable('RAVINTIO_INITIATIVE_STEP')
if ($null -eq $v) { Write-Host 'PROBE_PS=unset' } else { Write-Host "PROBE_PS=$v" }
exit 0
PROBE
  OUT="$(RAVINTIO_INITIATIVE_STEP=1 "$PWSH" -NoProfile -File "$D/tests/run-tests.ps1" 2>&1)"
  assert_contains "PROBE_PS=unset" "$OUT" "req-001 (c): a PowerShell suite sees the variable unset"
else
  echo "  SKIP: pwsh not found"
fi

echo ""
echo "=== req-001 (d): a suite can still set the variable for its own call ==="
D="$(make_tests_dir d)"
cat > "$D/tests/test-sets.sh" <<'PROBE'
#!/usr/bin/env bash
echo "OWN_CALL=$(RAVINTIO_INITIATIVE_STEP=1 bash -c 'echo ${RAVINTIO_INITIATIVE_STEP-unset}')"
exit 0
PROBE
OUT="$(RAVINTIO_INITIATIVE_STEP=1 RAVINTIO_PWSH=/nonexistent/pwsh bash "$D/tests/run-tests.sh" 2>&1)"
assert_contains "OWN_CALL=1" "$OUT" "req-001 (d): the suite's own setting still reaches its call"

print_summary
