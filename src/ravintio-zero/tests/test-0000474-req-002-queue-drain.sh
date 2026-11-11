#!/usr/bin/env bash
# Tests for feature 0000474-coordinator-shell-guidance, req-002: the queue drain.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HELPER="$SCRIPT_DIR/../scripts/initiative-queue.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

item() {
  mkdir -p "$1/plan/.initiative-queue/$2"
  printf '**Step:** %s\n**Destination:** %s\n\nContent: x\n' "$3" "$4" > "$1/plan/.initiative-queue/$2/item.md"
}

echo ""
echo "=== req-002 AC-1: drain removes only the named items ==="
R="$WORK/r1"
item "$R" step-a 7 "plan/a.md"
item "$R" step-b 7 "plan/b.md"
item "$R" step-c 8 "plan/c.md"
OUT="$(env -u RAVINTIO_INITIATIVE_ROOT node "$HELPER" drain --step 7 --root "$R" 2>&1)"
CODE=$?
assert_exit_zero "$CODE" "AC-1: drain exits 0"
assert_contains "drained: step-a" "$OUT" "AC-1: prints a line for step-a"
assert_contains "drained: step-b" "$OUT" "AC-1: prints a line for step-b"
assert_equals "no" "$([ -e "$R/plan/.initiative-queue/step-a" ] && echo yes || echo no)" "AC-1: step-a is gone"
assert_equals "yes" "$([ -e "$R/plan/.initiative-queue/step-c" ] && echo yes || echo no)" "AC-1: the step 8 item stays"

echo ""
echo "=== req-002 AC-2: a symlinked folder stays ==="
R="$WORK/r2"
mkdir -p "$WORK/elsewhere"
printf '**Step:** 7\n**Destination:** plan/evil.md\n' > "$WORK/elsewhere/item.md"
mkdir -p "$R/plan/.initiative-queue"
ln -s "$WORK/elsewhere" "$R/plan/.initiative-queue/linked"
OUT="$(env -u RAVINTIO_INITIATIVE_ROOT node "$HELPER" drain --step 7 --root "$R" 2>&1)"
assert_contains "symbolic link" "$OUT" "AC-2: warns about the link"
assert_equals "yes" "$([ -f "$WORK/elsewhere/item.md" ] && echo yes || echo no)" "AC-2: the link target stays"

echo ""
echo "=== req-002 AC-3: an empty queue ==="
R="$WORK/r3"
mkdir -p "$R"
OUT="$(env -u RAVINTIO_INITIATIVE_ROOT node "$HELPER" drain --step 7 --root "$R" 2>&1)"
CODE=$?
assert_exit_zero "$CODE" "AC-3: exits 0"
assert_contains "drained: none" "$OUT" "AC-3: prints drained: none"

echo ""
echo "=== req-002: a missing step exits 2 ==="
env -u RAVINTIO_INITIATIVE_ROOT node "$HELPER" drain --root "$R" >/dev/null 2>&1
assert_equals "2" "$?" "a missing --step exits 2"

print_summary
