#!/usr/bin/env bash
# Tests for feature 0000442-ready-file-helper, req-001: initiative-ready.mjs checks the PR number
# and writes or checks the ready file in the control folder.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HELPER="$SCRIPT_DIR/../scripts/initiative-ready.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

run_helper() {
  local ctl="$1"
  shift
  if [ "$ctl" = "-" ]; then
    OUT="$(env -u RAVINTIO_INITIATIVE_CONTROL node "$HELPER" "$@" 2>&1)"
  else
    OUT="$(RAVINTIO_INITIATIVE_CONTROL="$ctl" node "$HELPER" "$@" 2>&1)"
  fi
  CODE=$?
}

mode_of() { stat -c %a "$1" 2>/dev/null || stat -f %Lp "$1"; }

echo ""
echo "=== req-001 AC-1: a valid number writes the file ==="
mkdir -p "$WORK/c1"
run_helper "$WORK/c1" --pr 42
assert_equals "0" "$CODE" "AC-1: exits 0"
assert_equals "42" "$(cat "$WORK/c1/ready" 2>/dev/null)" "AC-1: ready holds 42"
assert_contains "I-D Advance: Ready: PR #42" "$OUT" "AC-1: prints the ready line"
assert_equals "600" "$(mode_of "$WORK/c1/ready")" "AC-1: mode 600"
assert_equals "1" "$(ls "$WORK/c1" | wc -l | tr -d ' ')" "AC-1: no temporary file stays"

echo ""
echo "=== req-001 AC-2: bad input writes nothing ==="
mkdir -p "$WORK/c2"
for bad in 4x 0 "" 2026-11-10T14:00:00Z 12345678 "-5" "4 2"; do
  rm -f "$WORK/c2/ready"
  run_helper "$WORK/c2" --pr "$bad"
  assert_equals "1" "$CODE" "AC-2: '$bad' exits 1"
  assert_equals "no" "$([ -e "$WORK/c2/ready" ] && echo yes || echo no)" "AC-2: '$bad' writes nothing"
done
run_helper "$WORK/c2"
assert_equals "1" "$CODE" "AC-2: no --pr exits 1"
run_helper - --pr 42
assert_equals "1" "$CODE" "AC-2: no control variable exits 1"
assert_contains "RAVINTIO_INITIATIVE_CONTROL" "$OUT" "AC-2: names the variable"
run_helper "$WORK/missing" --pr 42
assert_equals "1" "$CODE" "AC-2: missing folder exits 1"
mkdir -p "$WORK/real"
ln -s "$WORK/real" "$WORK/linkdir"
run_helper "$WORK/linkdir" --pr 42
assert_equals "1" "$CODE" "AC-2: symlinked folder exits 1"
assert_equals "no" "$([ -e "$WORK/real/ready" ] && echo yes || echo no)" "AC-2: nothing written through the folder link"
mkdir -p "$WORK/c3"
echo secret > "$WORK/target"
ln -s "$WORK/target" "$WORK/c3/ready"
run_helper "$WORK/c3" --pr 42
assert_equals "1" "$CODE" "AC-2: symlinked file exits 1"
assert_equals "secret" "$(cat "$WORK/target")" "AC-2: nothing written through the file link"
run_helper "$WORK/c2" --pr 4x
assert_not_contains "4x" "$OUT" "AC-2: the refusal never echoes the raw value"

echo ""
echo "=== req-001 AC-3: --check ==="
mkdir -p "$WORK/c4"
printf '42\n' > "$WORK/c4/ready"
run_helper "$WORK/c4" --check
assert_equals "0" "$CODE" "AC-3: valid file exits 0"
: > "$WORK/c4/ready"
run_helper "$WORK/c4" --check
assert_equals "1" "$CODE" "AC-3: empty file exits 1"
printf '2026-11-10T14:00:00Z\n' > "$WORK/c4/ready"
run_helper "$WORK/c4" --check
assert_equals "1" "$CODE" "AC-3: timestamp exits 1"
rm -f "$WORK/c4/ready"
run_helper "$WORK/c4" --check
assert_equals "1" "$CODE" "AC-3: missing file exits 1"

print_summary
