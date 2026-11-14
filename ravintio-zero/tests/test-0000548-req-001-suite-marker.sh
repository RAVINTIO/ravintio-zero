#!/usr/bin/env bash
# Tests for feature 0000548-ack-write-mid-suite-fails-run, req-001: the runners write
# plan/.suite-running, and the strict hook stays quiet for a step session while the marker
# names a live process. The tree check still fails when a suite changes the ack.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
unset RAVINTIO_TEST_QUIET
source "$SCRIPT_DIR/helpers/assert.sh"

HOOK="$SCRIPT_DIR/../hooks/enforcement/check-orchestrator-presence.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# A workspace in strict mode with an ack for session OLD.
make_ws() {
  local ws="$WORK/$1"
  mkdir -p "$ws/plan"
  echo "0000548-test" > "$ws/plan/.orchestrator-active"
  : > "$ws/plan/.orchestrator-strict"
  echo "OLD" > "$ws/plan/.orchestrator-ack"
  printf '%s' "$ws"
}

# run_hook <workspace> <step: 1 or 0>: prints the hook output for session NEW.
run_hook() {
  local ws="$1" step="$2" payload
  payload="$(printf '{"cwd":"%s","session_id":"NEW"}' "$ws")"
  if [ "$step" = "1" ]; then
    printf '%s' "$payload" | RAVINTIO_INITIATIVE_STEP=1 node "$HOOK" 2>/dev/null
  else
    printf '%s' "$payload" | env -u RAVINTIO_INITIATIVE_STEP node "$HOOK" 2>/dev/null
  fi
}

echo ""
echo "=== AC-1: a live marker silences the hook for a step session ==="
WS="$(make_ws a)"
sleep 30 & LIVE=$!
echo "$LIVE" > "$WS/plan/.suite-running"
assert_equals "" "$(run_hook "$WS" 1)" "AC-1: no banner for a step session with a live marker"

echo ""
echo "=== AC-2: every other case keeps the strict banner ==="
assert_contains "STRICT MODE" "$(run_hook "$WS" 0)" "AC-2: a non-step session still gets the banner"
kill "$LIVE" 2>/dev/null; wait "$LIVE" 2>/dev/null
assert_contains "STRICT MODE" "$(run_hook "$WS" 1)" "AC-2: a dead pid still gets the banner"
echo "not a pid" > "$WS/plan/.suite-running"
assert_contains "STRICT MODE" "$(run_hook "$WS" 1)" "AC-2: text that is not a pid still gets the banner"
rm -f "$WS/plan/.suite-running"
assert_contains "STRICT MODE" "$(run_hook "$WS" 1)" "AC-2: no marker still gets the banner"

echo ""
echo "=== AC-3: the runner writes the marker and removes it on exit ==="
make_repo() {
  local dir="$WORK/$1"
  mkdir -p "$dir/tests/helpers" "$dir/tests/regression" "$dir/plan"
  cp "$SCRIPT_DIR/run-tests.sh" "$SCRIPT_DIR/run-tests.ps1" "$dir/tests/"
  cp "$SCRIPT_DIR/helpers/assert.sh" "$dir/tests/helpers/"
  printf '{"tests":[]}\n' > "$dir/tests/regression/regression-manifest.json"
  echo "0000548-test" > "$dir/plan/.orchestrator-active"
  : > "$dir/plan/.orchestrator-strict"
  echo "OLD" > "$dir/plan/.orchestrator-ack"
  git -C "$dir" init -q
  git -C "$dir" add -A
  git -C "$dir" -c user.name=t -c user.email=t@example.com commit -qm base
  printf '%s' "$dir"
}
run_runner() {
  RAVINTIO_PWSH=/nonexistent/pwsh bash "$1/tests/run-tests.sh" 2>&1
}

D="$(make_repo c)"
cat > "$D/tests/test-sees-marker.sh" <<'STUB'
#!/usr/bin/env bash
M="$(dirname "$0")/../plan/.suite-running"
[ -s "$M" ] || { echo "no marker"; exit 1; }
kill -0 "$(cat "$M")" 2>/dev/null || { echo "marker pid not live"; exit 1; }
exit 0
STUB
OUT="$(run_runner "$D")"; CODE=$?
assert_equals "0" "$CODE" "AC-3: a suite sees a live marker, and the run passes"
assert_equals "no" "$([ -e "$D/plan/.suite-running" ] && echo yes || echo no)" "AC-3: the runner removed the marker on exit"

echo ""
echo "=== AC-4: a prompt mid-run no longer fails the run ==="
D="$(make_repo d)"
cat > "$D/tests/test-prompt-mid-run.sh" <<STUB
#!/usr/bin/env bash
ROOT="\$(cd "\$(dirname "\$0")/.." && pwd)"
OUT="\$(printf '{"cwd":"%s","session_id":"NEW"}' "\$ROOT" | RAVINTIO_INITIATIVE_STEP=1 node "$HOOK" 2>/dev/null)"
# Act as the model would: write the ack only when the hook asks for it.
[ -n "\$OUT" ] && echo NEW > "\$ROOT/plan/.orchestrator-ack"
exit 0
STUB
OUT="$(run_runner "$D")"; CODE=$?
assert_equals "0" "$CODE" "AC-4: the runner exits 0"
assert_equals "OLD" "$(tr -d '\n' < "$D/plan/.orchestrator-ack")" "AC-4: the ack is unchanged"

echo ""
echo "=== AC-5: the tree check still fails when a suite changes the ack ==="
D="$(make_repo e)"
printf '#!/usr/bin/env bash\necho NEW > "$(dirname "$0")/../plan/.orchestrator-ack"\nexit 0\n' > "$D/tests/test-writes-ack.sh"
OUT="$(run_runner "$D")"; CODE=$?
assert_equals "1" "$CODE" "AC-5: the runner exits 1"
assert_contains "plan/.orchestrator-ack" "$OUT" "AC-5: the runner names the ack"

echo ""
echo "=== AC-6: both runners and the ignore file carry the marker ==="
assert_contains ".suite-running" "$(cat "$SCRIPT_DIR/run-tests.sh")" "run-tests.sh names the marker"
assert_contains ".suite-running" "$(cat "$SCRIPT_DIR/run-tests.ps1")" "run-tests.ps1 names the marker"
TOP="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
assert_contains "plan/.suite-running" "$(cat "$TOP/.gitignore")" ".gitignore ignores the marker"

print_summary
