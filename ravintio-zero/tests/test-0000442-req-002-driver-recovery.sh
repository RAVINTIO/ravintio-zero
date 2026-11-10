#!/usr/bin/env bash
# Tests for feature 0000442-ready-file-helper, req-002: the driver recovers the PR number from the
# step branch when the ready file is empty or invalid, and stops when it cannot find exactly one PR.
#
# A stub gh stands in for GitHub through RAVINTIO_GH_BIN. GH_MODE one prints one PR, none prints
# an empty list, two prints two PRs, junk prints text that is not JSON, and fail exits 1.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

mkdir -p "$WORK/bin"
cat > "$WORK/bin/gh-stub" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_DIR/gh.log"
case "${GH_MODE:-one}" in
  one) echo '[{"number":77}]' ;;
  none) echo '[]' ;;
  two) echo '[{"number":77},{"number":78}]' ;;
  bad) echo '[{"number":"7; touch pwned"}]' ;;
  junk) echo 'not json' ;;
  fail) exit 1 ;;
esac
STUB
chmod +x "$WORK/bin/gh-stub"

yes_no() { [ -e "$1" ] && echo yes || echo no; }

# recover <name> <mode> <ready content>: runs the driver with a bad ready file and a stub gh.
recover() {
  R="$(make_repo "$1" 1 '1||')"
  S="$(dirname "$R")/stub"
  mkdir -p "$R/plan/.initiative-control/step-1"
  printf '%s' "$3" > "$R/plan/.initiative-control/step-1/ready"
  GH_MODE="$2" RAVINTIO_GH_BIN="$WORK/bin/gh-stub" STUB_DIR="$S" run_sched "$R"
}

echo ""
echo "=== req-002 AC-1: an empty ready file is recovered ==="
recover empty one ""
assert_equals "0" "$CODE" "AC-1: driver exits 0"
assert_equals "1 77," "$(tr '\n' ',' < "$S/queue.log")" "AC-1: the queue ran for the recovered PR"
assert_contains "recovered PR #77 from the step branch" "$OUT" "AC-1: prints the recovery line"
assert_contains "--head feat/0000051-s1" "$(cat "$S/gh.log")" "AC-1: looks up the step branch"
assert_contains "--state open" "$(cat "$S/gh.log")" "AC-1: looks up open PRs only"
assert_equals "no" "$(yes_no "$S/1.started")" "AC-1: no new session started"

echo ""
echo "=== req-002 AC-2: a timestamp is recovered ==="
recover stamp one "2026-11-10T14:00:00Z
"
assert_equals "0" "$CODE" "AC-2: driver exits 0"
assert_equals "1 77," "$(tr '\n' ',' < "$S/queue.log")" "AC-2: the queue ran for the recovered PR"

echo ""
echo "=== req-002 AC-3: no single PR keeps the stop ==="
for mode in none two bad junk fail; do
  recover "stop-$mode" "$mode" "1; rm -rf /
"
  assert_equals "1" "$CODE" "AC-3 ($mode): driver exits 1"
  assert_contains "I-C Run: Blocked: step 1 wrote an invalid ready file" "$OUT" "AC-3 ($mode): names the invalid file"
  assert_equals "no" "$(yes_no "$S/queue.log")" "AC-3 ($mode): the queue never ran"
  assert_equals "no" "$(yes_no "$R/pwned")" "AC-3 ($mode): gh output ran nothing"
done

echo ""
echo "=== req-002: a valid ready file never calls gh ==="
recover valid one "101
"
assert_equals "0" "$CODE" "valid: driver exits 0"
assert_equals "1 101," "$(tr '\n' ',' < "$S/queue.log")" "valid: the queue ran for the file's PR"
assert_equals "no" "$(yes_no "$S/gh.log")" "valid: gh never ran"

print_summary
