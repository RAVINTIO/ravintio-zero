#!/usr/bin/env bash
# Tests for feature 0000390-prose-checks, REQ-002: the baseline only shrinks.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LINT="$ZERO_DIR/scripts/prose-check.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

lint() { (cd "$TMP" && node "$LINT" "$@" 2>&1); }
tgit() { (cd "$TMP" && git "$@"); }

mkdir -p "$TMP/docs"
tgit init -q
tgit config user.email t@example.com
tgit config user.name Tester
printf 'One; two.\n\nThree; four.\n' > "$TMP/docs/a.md"
tgit add docs/a.md
tgit commit -q -m "add a" --no-verify

echo ""
echo "=== no baseline: breaches fail ==="
OUT="$(lint check)"; RC=$?
assert_equals "1" "$RC" "a missing baseline counts as empty"
assert_contains "docs/a.md:1 semicolon" "$OUT" "the first breach is listed"

echo ""
echo "=== update --init writes the first baseline ==="
OUT="$(lint update)"; RC=$?
assert_equals "2" "$RC" "update with no baseline asks for --init"
OUT="$(lint update --init)"; RC=$?
assert_equals "0" "$RC" "update --init exits 0"
assert_contains '"semicolon": 2' "$(cat "$TMP/plan/state/prose-baseline.json")" "the baseline holds the count"
OUT="$(lint update --init)"; RC=$?
assert_equals "2" "$RC" "update --init fails when a baseline exists"

echo ""
echo "=== AC-1: a baselined breach passes and a new one fails ==="
OUT="$(lint check)"; RC=$?
assert_equals "0" "$RC" "two baselined semicolons pass"
printf 'Five; six.\n' >> "$TMP/docs/a.md"
OUT="$(lint check)"; RC=$?
assert_equals "1" "$RC" "a third semicolon fails"
assert_contains "count 3 is above the baseline 2" "$OUT" "the output states both counts"

echo ""
echo "=== AC-2: update never raises a count ==="
OUT="$(lint update)"; RC=$?
assert_equals "1" "$RC" "update exits 1 when a count is above the baseline"
assert_contains '"semicolon": 2' "$(cat "$TMP/plan/state/prose-baseline.json")" "the baseline stays at 2"
printf 'One; two.\n' > "$TMP/docs/a.md"
OUT="$(lint update)"; RC=$?
assert_equals "0" "$RC" "update exits 0 when counts fall"
assert_contains '"semicolon": 1' "$(cat "$TMP/plan/state/prose-baseline.json")" "the baseline falls to 1"
printf 'One, two.\n' > "$TMP/docs/a.md"
lint update >/dev/null
assert_not_contains "docs/a.md" "$(cat "$TMP/plan/state/prose-baseline.json")" "a clean file leaves the baseline"

echo ""
echo "=== AC-2: update leaves a new file's breach unrecorded ==="
printf 'New; file.\n' > "$TMP/docs/b.md"
tgit add docs/b.md
OUT="$(lint update)"; RC=$?
assert_equals "1" "$RC" "a new file with a breach makes update exit 1"
assert_not_contains "docs/b.md" "$(cat "$TMP/plan/state/prose-baseline.json")" "the new file is not recorded"
tgit rm -q -f docs/b.md

echo ""
echo "=== AC-3: diff fails when the baseline rises ==="
printf 'One; two.\n' > "$TMP/docs/a.md"
rm -f "$TMP/plan/state/prose-baseline.json"
lint update --init >/dev/null
tgit add plan/state/prose-baseline.json docs/a.md
tgit commit -q -m "baseline" --no-verify
OUT="$(lint diff --base HEAD)"; RC=$?
assert_equals "0" "$RC" "an unchanged baseline passes"
sed -i.bak 's/"semicolon": 1/"semicolon": 4/' "$TMP/plan/state/prose-baseline.json"; rm -f "$TMP/plan/state/prose-baseline.json.bak"
OUT="$(lint diff --base HEAD)"; RC=$?
assert_equals "1" "$RC" "a raised count fails"
assert_contains "docs/a.md: semicolon baseline rises from 1 to 4" "$OUT" "the output names the file and rule"
tgit checkout -q -- plan/state/prose-baseline.json

echo ""
echo "=== AC-3: a base ref with no baseline passes ==="
tgit rm -q --cached plan/state/prose-baseline.json
tgit commit -q -m "drop baseline" --no-verify
OUT="$(lint diff --base HEAD)"; RC=$?
assert_equals "0" "$RC" "a base with no baseline file passes"
assert_contains "no baseline at HEAD" "$OUT" "the output says why"

echo ""
echo "=== invalid baseline ==="
printf 'not json' > "$TMP/plan/state/prose-baseline.json"
OUT="$(lint check)"; RC=$?
assert_equals "2" "$RC" "an invalid baseline exits 2"

print_summary
