#!/usr/bin/env bash
# Tests for feature 0000552 REQ-001: backlog-index.mjs --check fails on a duplicate backlog id.
# AC-1: --check exits 1 and names the id and both folders when two entries share an id.
# AC-2: --check exits 0 when ids are unique and the index is current.
# AC-3: the generate mode and --review ignore a duplicate id, so the merge queue can renumber.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

GEN="$ZERO_DIR/scripts/backlog-index.mjs"
WS=$(mktemp -d)
trap 'rm -rf "${WS:?}"' EXIT

# add_entry REPO ID-SLUG: one valid entry folder.
add_entry() {
  mkdir -p "$1/plan/backlog/$2"
  printf -- '---\ntitle: "Backlog Entry: %s"\nstatus: "open"\n---\n# Entry\n\n**Date filed:** 2026-11-16\n' "$2" > "$1/plan/backlog/$2/entry.md"
}

DUP="$WS/dup"
add_entry "$DUP" 0000476-first-entry
add_entry "$DUP" 0000476-second-entry
add_entry "$DUP" 0000477-other-entry
node "$GEN" --root "$DUP" >/dev/null 2>&1; GEN_CODE=$?

echo "=== AC-1: --check fails on a duplicate id ==="
node "$GEN" --root "$DUP" --check >"$WS/out" 2>"$WS/err"; CODE=$?
ERR=$(cat "$WS/err")
assert_equals "1" "$CODE" "--check exits 1 with a current index and a duplicate id"
assert_contains "duplicate backlog id 0000476" "$ERR" "stderr names the id"
assert_contains "0000476-first-entry" "$ERR" "stderr names the first folder"
assert_contains "0000476-second-entry" "$ERR" "stderr names the second folder"
assert_not_contains "0000477" "$ERR" "stderr leaves out the unique id"

echo "=== AC-2: --check passes on unique ids ==="
UNI="$WS/uni"
add_entry "$UNI" 0000476-first-entry
add_entry "$UNI" 0000477-other-entry
node "$GEN" --root "$UNI" >/dev/null 2>&1
node "$GEN" --root "$UNI" --check >/dev/null 2>&1; CODE=$?
assert_equals "0" "$CODE" "--check exits 0 with unique ids and a current index"

echo "=== AC-3: generate mode and --review ignore a duplicate ==="
assert_equals "0" "$GEN_CODE" "generate mode exits 0 with a duplicate id"
assert_equals "yes" "$([ -f "$DUP/plan/backlog/index.md" ] && echo yes || echo no)" "generate mode writes the index"
node "$GEN" --root "$DUP" --review --today 2026-11-16 >/dev/null 2>&1; CODE=$?
assert_equals "0" "$CODE" "--review exits 0 with a duplicate id"

print_summary
