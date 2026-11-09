#!/usr/bin/env bash
# Tests for feature 0000251-driver-step-fixes, req-002: the driver keeps every attempt log.
#
# scripts/initiative-run.mjs renames an existing plan/.initiative-logs/step-{n}.log to
# step-{n}.attempt-{k}.log before it opens a fresh step-{n}.log, and names the attempt logs
# in a stop line.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
STANDARDS="$SCRIPT_DIR/../standards/roadmap-standards.md"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/bin"
cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
# Stub claude. It writes STUB_TEXT, then stops without merging, so the driver stops on step 1.
printf '%s\n' "${STUB_TEXT:-first}"
exit 0
STUB
chmod +x "$WORK/bin/claude"

make_fixture() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current"
  cat > "$d/plan/current-initiative/initiative.md" <<EOF2
---
title: "Initiative: demo"
status: active
---
goal: demo
branch: initiative/0000050-demo
status: active
position: 1
EOF2
  : > "$d/plan/current/build-log.md"
  printf '%s' "$d"
}

# run_driver <root> <text>: sets OUT and CODE. The stub stops without merging, so each run stops.
run_driver() {
  rm -f "$1/plan/.initiative-runner.lock"
  OUT="$(cd "$1" && PATH="$WORK/bin:$PATH" STUB_TEXT="$2" node "$DRIVER" --root "$1" 2>/dev/null)"
  CODE=$?
}

mode_of() { stat -c %a "$1" 2>/dev/null || stat -f %Lp "$1"; }
LOGS=plan/.initiative-logs

echo ""
echo "=== req-002 (a): a first run leaves only the current log ==="
R="$(make_fixture a-once)"
run_driver "$R" first
assert_equals "first" "$(cat "$R/$LOGS/step-1.log")" "req-002 (a): step-1.log holds the first output"
assert_equals "1" "$(ls "$R/$LOGS" | wc -l | tr -d ' ')" "req-002 (a): the folder holds one file"
assert_equals "0" "$(printf '%s\n' "$OUT" | grep -c 'Earlier:')" "req-002 (a): a first run names no earlier log"

echo ""
echo "=== req-002 (b): a second run keeps the first log ==="
run_driver "$R" second
assert_equals "first" "$(cat "$R/$LOGS/step-1.attempt-1.log")" "req-002 (b): attempt-1 holds the first output"
assert_equals "second" "$(cat "$R/$LOGS/step-1.log")" "req-002 (b): step-1.log holds the second output"
assert_equals "2" "$(ls "$R/$LOGS" | wc -l | tr -d ' ')" "req-002 (b): the folder holds two files"

echo ""
echo "=== req-002 (c): a third run keeps both earlier logs ==="
run_driver "$R" third
assert_equals "first" "$(cat "$R/$LOGS/step-1.attempt-1.log")" "req-002 (c): attempt-1 keeps the first output"
assert_equals "second" "$(cat "$R/$LOGS/step-1.attempt-2.log")" "req-002 (c): attempt-2 holds the second output"
assert_equals "third" "$(cat "$R/$LOGS/step-1.log")" "req-002 (c): step-1.log holds the third output"
assert_equals "600" "$(mode_of "$R/$LOGS/step-1.attempt-1.log")" "req-002 (c): attempt-1 has mode 600"
assert_equals "600" "$(mode_of "$R/$LOGS/step-1.attempt-2.log")" "req-002 (c): attempt-2 has mode 600"
assert_equals "700" "$(mode_of "$R/$LOGS")" "req-002 (c): the folder has mode 700"

echo ""
echo "=== req-002 (d): the stop line names the attempt logs ==="
STOP="$(printf '%s\n' "$OUT" | grep 'I-C Run: Blocked:' | head -1)"
assert_contains "Earlier: $LOGS/step-1.attempt-1.log, $LOGS/step-1.attempt-2.log" "$STOP" "req-002 (d): both attempts are named in order"
assert_equals "yes" "$(printf '%s' "$STOP" | grep -q "Log: $LOGS/step-1.log\$" && echo yes || echo no)" "req-002 (d): the line still ends with the current log"

echo ""
echo "=== req-002 (e): a regular file at an attempt path moves the number up ==="
R="$(make_fixture e-gap)"
mkdir -p "$R/$LOGS"
printf 'older\n' > "$R/$LOGS/step-1.attempt-1.log"
printf 'current\n' > "$R/$LOGS/step-1.log"
run_driver "$R" next
assert_equals "older" "$(cat "$R/$LOGS/step-1.attempt-1.log")" "req-002 (e): attempt-1 is untouched"
assert_equals "current" "$(cat "$R/$LOGS/step-1.attempt-2.log")" "req-002 (e): the old current log becomes attempt-2"

echo ""
echo "=== req-002 (f): a symlink stops the driver ==="
R="$(make_fixture f-link)"
mkdir -p "$R/$LOGS"
printf 'current\n' > "$R/$LOGS/step-1.log"
printf 'victim bytes\n' > "$WORK/victim"
ln -s "$WORK/victim" "$R/$LOGS/step-1.attempt-1.log"
run_driver "$R" next
assert_equals "1" "$CODE" "req-002 (f): a symlink at the attempt path exits 1"
assert_contains "I-C Run: Blocked: refused a symlinked step log path" "$OUT" "req-002 (f): the symlink refusal prints"
assert_equals "0" "$(printf '%s\n' "$OUT" | grep -c "$WORK")" "req-002 (f): the stop line omits the target path"
assert_equals "victim bytes" "$(cat "$WORK/victim")" "req-002 (f): the victim keeps its bytes"
assert_equals "current" "$(cat "$R/$LOGS/step-1.log")" "req-002 (f): the current log is not renamed"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "req-002 (f): the lock is released"

echo ""
echo "=== req-002 (g): documentation ==="
HEAD_TXT="$(sed -n '1,60p' "$DRIVER")"
for f in "$HEAD_TXT" "$(cat "$STANDARDS")"; do
  assert_contains "attempt-" "$f" "req-002 (g): names the attempt log"
  assert_contains "Earlier:" "$f" "req-002 (g): names the Earlier field"
done

print_summary
