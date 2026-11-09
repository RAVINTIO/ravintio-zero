#!/usr/bin/env bash
# Tests for feature 0000316-hooks-fail-closed, req-003 and req-004: guard-run.mjs.
#
# The launcher runs one hook script that sits beside it. In guard mode a missing
# script or any exit other than 0 and 2 becomes exit 2. In advisory mode a
# missing script exits 0 and is reported once.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SRC="$ZERO_DIR/hooks/enforcement/guard-run.mjs"

TMP=$(mktemp -d -t ravintio_0000316_XXXXXX)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/hooks" "$TMP/tmpdir"

echo ""
echo "=== req-003 and req-004: guard-run.mjs ==="
if [ ! -f "$SRC" ]; then
  assert_equals "exists" "missing" "req-003: guard-run.mjs exists"
  exit 1
fi
cp "$SRC" "$TMP/hooks/guard-run.mjs"
LAUNCH="$TMP/hooks/guard-run.mjs"

printf 'process.exit(0);\n' > "$TMP/hooks/ok.mjs"
printf 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{console.error("reason: "+s);process.exit(2);});\n' > "$TMP/hooks/block.mjs"
printf 'throw new Error("boom");\n' > "$TMP/hooks/crash.mjs"
printf 'console.log("context line");process.exit(0);\n' > "$TMP/hooks/ctx.mjs"

# run <mode> <script> [stdin]: sets OUT, ERR, CODE. TMPDIR isolates the once-marker.
run() {
  OUT=$(printf '%s' "${3:-}" | TMPDIR="$TMP/tmpdir" node "$LAUNCH" "$1" "$2" 2>"$TMP/err")
  CODE=$?
  ERR=$(cat "$TMP/err")
}

run guard ok.mjs
assert_equals "0" "$CODE" "req-003: guard passes exit 0"
run guard block.mjs "payload-x"
assert_equals "2" "$CODE" "req-003: guard passes exit 2"
assert_contains "reason: payload-x" "$ERR" "req-003: stdin and stderr pass through"
run guard crash.mjs
assert_equals "2" "$CODE" "req-003: a crashing guard exits 2"
assert_contains "crash.mjs" "$ERR" "req-003: crash message names the script"
assert_contains "exit 1" "$ERR" "req-003: crash message names the code"
run guard missing.mjs
assert_equals "2" "$CODE" "req-003: a missing guard exits 2"
assert_contains "missing.mjs" "$ERR" "req-003: missing message names the script"
run guard ../ok.mjs
assert_equals "2" "$CODE" "req-003: a script name with a path is refused"

run advisory missing.mjs
assert_equals "0" "$CODE" "req-004: a missing advisory script exits 0"
assert_contains "missing.mjs" "$ERR" "req-004: first report names the script"
run advisory missing.mjs
assert_equals "0" "$CODE" "req-004: second run exits 0"
assert_equals "" "$ERR" "req-004: second run stays quiet"
run advisory ctx.mjs
assert_equals "context line" "$OUT" "req-004: advisory stdout passes through"
run advisory crash.mjs
assert_equals "1" "$CODE" "req-004: advisory exit code passes through"

# Strictness: a real guard gives the same exit code through the launcher as a direct run.
cp "$ZERO_DIR/hooks/enforcement/"*.mjs "$TMP/hooks/"
cp "$SRC" "$TMP/hooks/guard-run.mjs"
PAYLOAD='{"tool_name":"Write","tool_input":{"file_path":"plan/current/x.md","content":"a — b"}}'
DIRECT=$(printf '%s' "$PAYLOAD" | node "$TMP/hooks/em-dash-guard.mjs" 2>&1); DCODE=$?
OUT=$(printf '%s' "$PAYLOAD" | node "$LAUNCH" guard em-dash-guard.mjs 2>&1); CODE=$?
assert_equals "$DCODE" "$CODE" "req-003: em-dash-guard exit code matches a direct run"
assert_equals "$DIRECT" "$OUT" "req-003: em-dash-guard output matches a direct run"

print_summary
