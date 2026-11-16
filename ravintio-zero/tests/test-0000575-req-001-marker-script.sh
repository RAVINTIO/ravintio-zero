#!/usr/bin/env bash
# Test: 0000575 req-001 marker-script
# build-log-mark.mjs appends a RED, GREEN, or Done line with a clock-read time,
# and refuses bad input without changing a file.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MARK="$ZERO_DIR/scripts/build-log-mark.mjs"
CHECK="$ZERO_DIR/scripts/build-log-check.mjs"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

run_mark() { OUT=$(node "$MARK" "$@" 2>&1); CODE=$?; }
TIME_RE='[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z'

echo "=== AC-1: RED and GREEN lines ==="
printf '# Build Log\n\n### P2: Implement\n\n' > "$TMP/log.md"
run_mark RED "U1 thing" --log "$TMP/log.md"
assert_equals "0" "$CODE" "AC-1: RED exits 0"
run_mark green "U1 thing" --log "$TMP/log.md"
assert_equals "0" "$CODE" "AC-1: a lower-case kind exits 0"
LAST_TWO="$(tail -2 "$TMP/log.md")"
if printf '%s\n' "$LAST_TWO" | head -1 | grep -Eq "^- RED: U1 thing \($TIME_RE\)$"; then
  _pass_line "AC-1: the RED line has the unit and a clock time"
else
  _fail_line "AC-1: the RED line has the unit and a clock time"; FAIL=$((FAIL+1))
fi
if printf '%s\n' "$LAST_TWO" | tail -1 | grep -Eq "^- GREEN: U1 thing \($TIME_RE\)$"; then
  _pass_line "AC-1: the GREEN line has the unit and a clock time"
else
  _fail_line "AC-1: the GREEN line has the unit and a clock time"; FAIL=$((FAIL+1))
fi

echo "=== AC-2: Done line ==="
run_mark Done "U1 thing" --class code --tier inline --effort none --log "$TMP/log.md"
assert_equals "0" "$CODE" "AC-2: Done exits 0"
if tail -1 "$TMP/log.md" | grep -Eq "^- Done: U1 thing \(code, inline, none, $TIME_RE\)$"; then
  _pass_line "AC-2: the Done line has the dispatch standard form"
else
  _fail_line "AC-2: the Done line has the dispatch standard form"; FAIL=$((FAIL+1))
fi

echo "=== A line goes before a Summary heading ==="
printf '# Log\n\n### P2: Implement\n\n## Summary\n\n| a | b |\n' > "$TMP/sum.md"
run_mark RED U9 --log "$TMP/sum.md"
assert_equals "0" "$CODE" "a log with a Summary exits 0"
LINE_RED=$(grep -n '^- RED: U9' "$TMP/sum.md" | cut -d: -f1)
LINE_SUM=$(grep -n '^## Summary' "$TMP/sum.md" | cut -d: -f1)
if [ -n "$LINE_RED" ] && [ "$LINE_RED" -lt "$LINE_SUM" ]; then
  _pass_line "the line lands before the Summary heading"
else
  _fail_line "the line lands before the Summary heading"; FAIL=$((FAIL+1))
fi

echo "=== The checker accepts what the script wrote ==="
printf '# Log\n\n### P2: Implement\n\n' > "$TMP/chk.md"
node "$MARK" RED U1 --log "$TMP/chk.md"
node "$MARK" GREEN U1 --log "$TMP/chk.md"
node "$MARK" Done U1 --class content --tier inline --effort none --log "$TMP/chk.md"
OUT=$(node "$CHECK" "$TMP/chk.md" 2>&1)
assert_not_contains "U1" "$OUT" "build-log-check names no finding for U1"

echo "=== AC-3: refusals ==="
cp "$TMP/log.md" "$TMP/before.md"
run_mark BLUE U1 --log "$TMP/log.md"
assert_equals "2" "$CODE" "AC-3: a bad kind exits 2"
run_mark RED --log "$TMP/log.md"
assert_equals "2" "$CODE" "AC-3: a missing unit exits 2"
run_mark Done U1 --class code --log "$TMP/log.md"
assert_equals "2" "$CODE" "AC-3: a Done with missing fields exits 2"
run_mark RED U1 --log "$TMP/none.md"
assert_equals "2" "$CODE" "AC-3: a missing log exits 2"
assert_equals "$(wc -l < "$TMP/before.md")" "$(wc -l < "$TMP/log.md")" "AC-3: a refusal changes no file"
ln -s "$TMP/log.md" "$TMP/link.md"
run_mark RED U1 --log "$TMP/link.md"
assert_equals "2" "$CODE" "AC-3: a symlinked log exits 2"
assert_equals "$(wc -l < "$TMP/before.md")" "$(wc -l < "$TMP/log.md")" "AC-3: a symlink refusal changes no file"

print_summary
