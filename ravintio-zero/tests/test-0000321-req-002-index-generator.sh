#!/usr/bin/env bash
# Tests for feature 0000321 REQ-002: the backlog index generator.
# AC-1: the index lists every entry with priority and theme, grouped and ordered.
# AC-2: --check exits 1 on a stale index, writes nothing, and exits 0 on a match.
# AC-3: a malformed entry stops the run and writes no index.
# Also: determinism, no body text in output, and defaults for missing fields.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

GEN="$ZERO_DIR/scripts/backlog-index.mjs"
MARKER="BODYMARKER-9f3a1c"

WS=$(mktemp -d)
trap 'rm -rf "${WS:?}"' EXIT

# make_repo NAME: scratch repo with an empty plan/backlog folder.
make_repo() {
  mkdir -p "$WS/$1/plan/backlog"
  echo "$WS/$1"
}
# add_entry REPO ID-SLUG TITLE FIELDS... : FIELDS are raw frontmatter lines.
add_entry() {
  local repo="$1" dir="$2" title="$3"; shift 3
  mkdir -p "$repo/plan/backlog/$dir"
  {
    echo "---"
    echo "title: \"$title\""
    for f in "$@"; do echo "$f"; done
    echo "---"
    echo "# Backlog Entry"
    echo
    echo "**Date filed:** 2026-10-25"
    echo
    echo "$MARKER"
  } > "$repo/plan/backlog/$dir/entry.md"
}
run() { local r="$1"; shift; node "$GEN" --root "$r" "$@" 2>"$WS/stderr"; }

if [ ! -f "$GEN" ]; then
  echo "  FAIL: script missing: $GEN"
  FAIL=$((FAIL + 1))
  print_summary
fi

echo "=== AC-1: index lists every entry ==="
R=$(make_repo ac1)
add_entry "$R" 0000010-low-alpha "Backlog Entry: 0000010 - low alpha" 'status: "open"' 'priority: low' 'theme: tooling'
add_entry "$R" 0000011-high-alpha "Backlog Entry: 0000011 - high alpha" 'status: "open"' 'priority: high' 'theme: tooling'
add_entry "$R" 0000012-med-zed "Backlog Entry: 0000012 - med | zed" 'status: "parked"' 'priority: medium' 'theme: docs'
add_entry "$R" 0000013-none "Backlog Entry: 0000013 - none" 'status: "open"'
OUT=$(run "$R"); CODE=$?
IDX="$R/plan/backlog/index.md"
assert_equals "0" "$CODE" "generator exits 0"
assert_equals "yes" "$([ -f "$IDX" ] && echo yes || echo no)" "index written"
T=$(cat "$IDX")
assert_contains 'title: "Backlog index"' "$T" "frontmatter title"
assert_contains 'node ravintio-zero/scripts/backlog-index.mjs' "$T" "generated note names the script"
assert_contains '| Id | Entry | Priority | Status | Filed |' "$T" "table header"
assert_contains '| 0000011 | high alpha | high | open | 2026-10-25 |' "$T" "high row, prefix stripped"
assert_contains '| 0000012 | med \| zed | medium | parked | 2026-10-25 |' "$T" "parked listed, pipe escaped"
assert_contains '| 0000013 | none | medium | open | 2026-10-25 |' "$T" "defaults to medium"
DOCS=$(grep -n '^## docs$' "$IDX" | cut -d: -f1)
TOOL=$(grep -n '^## tooling$' "$IDX" | cut -d: -f1)
UNS=$(grep -n '^## unsorted$' "$IDX" | cut -d: -f1)
assert_equals "yes" "$([ -n "$DOCS" ] && [ "$DOCS" -lt "$TOOL" ] && [ "$TOOL" -lt "$UNS" ] && echo yes || echo no)" "themes alphabetical, unsorted last"
H=$(grep -n '0000011 |' "$IDX" | cut -d: -f1)
L=$(grep -n '0000010 |' "$IDX" | cut -d: -f1)
assert_equals "yes" "$([ "$H" -lt "$L" ] && echo yes || echo no)" "high before low inside a theme"
assert_equals "4" "$(grep -c '^| 00000' "$IDX")" "one row per entry"
assert_equals "yes" "$([ -z "$(tail -c 1 "$IDX")" ] && [ -n "$(tail -c 2 "$IDX" | head -c 1)" ] && echo yes || echo no)" "ends with a single newline"
assert_equals "" "$(ls "$R/plan" | grep -v '^backlog$')" "creates nothing outside plan/backlog"
assert_equals "" "$(ls "$R/plan/backlog" | grep -v -e '^index.md$' -e '^0000')" "creates only index.md"

echo "=== Determinism and no body text ==="
A=$(cat "$IDX")
OUT2=$(run "$R"); 
assert_equals "$A" "$(cat "$IDX")" "second run gives identical bytes"
assert_not_contains "$MARKER" "$A" "body marker absent from index"
assert_not_contains "$MARKER" "$OUT$OUT2" "body marker absent from stdout"
assert_not_contains "$MARKER" "$(cat "$WS/stderr")" "body marker absent from stderr"

echo "=== Defaults: missing priority and theme ==="
R=$(make_repo defaults)
add_entry "$R" 0000020-bare "Backlog Entry: 0000020 - bare"
run "$R" >/dev/null; CODE=$?
assert_equals "0" "$CODE" "entry without status, priority, theme is accepted"
T=$(cat "$R/plan/backlog/index.md")
assert_contains '## unsorted' "$T" "theme defaults to unsorted"
assert_contains '| 0000020 | bare | medium | open | 2026-10-25 |' "$T" "priority medium, status open"
R=$(make_repo undated)
mkdir -p "$R/plan/backlog/0000021-nodate"
printf -- '---\ntitle: "x"\n---\nBody\n' > "$R/plan/backlog/0000021-nodate/entry.md"
run "$R" >/dev/null
assert_contains '| 0000021 | x | medium | open | undated |' "$(cat "$R/plan/backlog/index.md")" "missing date reads undated"

echo "=== AC-2: --check ==="
R=$(make_repo ac2)
add_entry "$R" 0000030-one "Backlog Entry: 0000030 - one" 'priority: high' 'theme: a'
run "$R" >/dev/null
run "$R" --check >/dev/null; CODE=$?
assert_equals "0" "$CODE" "exits 0 when index matches"
echo "stale" >> "$R/plan/backlog/index.md"
BEFORE=$(cat "$R/plan/backlog/index.md")
run "$R" --check >/dev/null; CODE=$?
assert_equals "1" "$CODE" "exits 1 when index differs"
assert_contains 'backlog-index: plan/backlog/index.md is stale. Run node ravintio-zero/scripts/backlog-index.mjs and commit the result.' "$(cat "$WS/stderr")" "stale message on stderr"
assert_equals "$BEFORE" "$(cat "$R/plan/backlog/index.md")" "--check leaves the index alone"
rm "$R/plan/backlog/index.md"
run "$R" --check >/dev/null; CODE=$?
assert_equals "1" "$CODE" "exits 1 when index missing"
assert_equals "no" "$([ -e "$R/plan/backlog/index.md" ] && echo yes || echo no)" "--check does not create the index"

echo "=== AC-3: malformed entries ==="
R=$(make_repo prio); add_entry "$R" 0000041-bad "t" 'priority: urgent'
run "$R" >/dev/null; CODE=$?
assert_equals "1" "$CODE" "unknown priority exits 1"
assert_contains "check: malformed entry 0000041-bad:" "$(cat "$WS/stderr")" "unknown priority names the entry"
assert_equals "no" "$([ -e "$R/plan/backlog/index.md" ] && echo yes || echo no)" "unknown priority writes no index"
R=$(make_repo theme); add_entry "$R" 0000041-bad "t" 'theme: Bad_Theme'
run "$R" >/dev/null; CODE=$?
assert_equals "1" "$CODE" "bad theme exits 1"
R=$(make_repo status); add_entry "$R" 0000041-bad "t" 'status: "done"'
run "$R" >/dev/null; CODE=$?
assert_equals "1" "$CODE" "bad status exits 1"
R=$(make_repo nofm); mkdir -p "$R/plan/backlog/0000041-bad"; echo "no frontmatter" > "$R/plan/backlog/0000041-bad/entry.md"
run "$R" >/dev/null; CODE=$?
assert_equals "1" "$CODE" "missing frontmatter exits 1"
assert_not_contains "no frontmatter" "$(cat "$WS/stderr")" "stderr omits body text"
R=$(make_repo link); mkdir -p "$R/plan/backlog/0000041-bad"; echo "x" > "$WS/target.md"; ln -s "$WS/target.md" "$R/plan/backlog/0000041-bad/entry.md"
run "$R" >/dev/null; CODE=$?
assert_equals "1" "$CODE" "symlinked entry exits 1"
assert_equals "no" "$([ -e "$R/plan/backlog/index.md" ] && echo yes || echo no)" "symlinked entry writes no index"

echo "=== Symlinked output path ==="
R=$(make_repo outlink); add_entry "$R" 0000041-ok "t"; echo "keep" > "$WS/outside.md"; ln -s "$WS/outside.md" "$R/plan/backlog/index.md"
run "$R" >/dev/null; CODE=$?
assert_equals "1" "$CODE" "symlinked index.md exits 1"
assert_equals "keep" "$(cat "$WS/outside.md")" "symlinked index.md leaves the target unchanged"
R=$(make_repo dirlink); add_entry "$R" 0000041-ok "t"; mkdir "$WS/elsewhere"; mv "$R/plan/backlog" "$WS/elsewhere/backlog"; ln -s "$WS/elsewhere/backlog" "$R/plan/backlog"
run "$R" >/dev/null; CODE=$?
assert_equals "1" "$CODE" "symlinked plan/backlog exits 1"
assert_equals "no" "$([ -e "$WS/elsewhere/backlog/index.md" ] && echo yes || echo no)" "symlinked plan/backlog gets no index"

echo "=== Options ==="
run "$WS/ac2" --bogus >/dev/null; CODE=$?
assert_equals "1" "$CODE" "unknown option exits 1"
assert_contains "--bogus" "$(cat "$WS/stderr")" "unknown option named on stderr"

print_summary
