#!/usr/bin/env bash
# Test: 0000580 req-002 class-on-markers
# build-log-mark.mjs writes RED and GREEN lines that carry a class.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MARK="$ZERO_DIR/scripts/build-log-mark.mjs"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
TIME_RE='[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z'
run_mark() { OUT=$(node "$MARK" "$@" 2>&1); CODE=$?; }

printf '# Build Log\n\n### P2: Implement\n\n' > "$TMP/log.md"

echo "=== AC-1: a class on GREEN ==="
run_mark GREEN "U1 docs" --class docs --log "$TMP/log.md"
assert_equals "0" "$CODE" "AC-1: exits 0"
if tail -1 "$TMP/log.md" | grep -Eq "^- GREEN: U1 docs \(docs, $TIME_RE\)$"; then
  _pass_line "AC-1: the GREEN line carries the class"
else
  _fail_line "AC-1: the GREEN line carries the class"; FAIL=$((FAIL+1))
fi

echo "=== AC-1: a class on RED ==="
run_mark RED "U1 docs" --class docs --log "$TMP/log.md"
if tail -1 "$TMP/log.md" | grep -Eq "^- RED: U1 docs \(docs, $TIME_RE\)$"; then
  _pass_line "AC-1: the RED line carries the class"
else
  _fail_line "AC-1: the RED line carries the class"; FAIL=$((FAIL+1))
fi

echo "=== AC-2: no class keeps the old form ==="
run_mark RED "U2 thing" --log "$TMP/log.md"
if tail -1 "$TMP/log.md" | grep -Eq "^- RED: U2 thing \($TIME_RE\)$"; then
  _pass_line "AC-2: the RED line keeps its old form"
else
  _fail_line "AC-2: the RED line keeps its old form"; FAIL=$((FAIL+1))
fi

echo "=== AC-3: a bad class is refused ==="
cp "$TMP/log.md" "$TMP/before.md"
run_mark RED U3 --class "a,b" --log "$TMP/log.md"
assert_equals "2" "$CODE" "AC-3: a comma in the class exits 2"
run_mark GREEN U3 --class "a(b" --log "$TMP/log.md"
assert_equals "2" "$CODE" "AC-3: a parenthesis in the class exits 2"
if cmp -s "$TMP/before.md" "$TMP/log.md"; then
  _pass_line "AC-3: a refusal changes no file"
else
  _fail_line "AC-3: a refusal changes no file"; FAIL=$((FAIL+1))
fi

print_summary
