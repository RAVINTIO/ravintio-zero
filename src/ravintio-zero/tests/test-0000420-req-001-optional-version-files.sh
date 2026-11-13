#!/usr/bin/env bash
# Tests for feature 0000420-version-both-copies, req-001: a version-files entry with a "? " prefix is
# optional. The scripts read and write it when the file exists and skip it when it does not. The
# shipped list names the pack source copy of component.yml as optional.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="$SCRIPT_DIR/../scripts/version-files.mjs"
LIST_REAL="$SCRIPT_DIR/../version-files.txt"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# make_fixture NAME: a repo with a required product.yml and an optional src copy that exists.
make_fixture() {
  local d="$WORK/$1"
  mkdir -p "$d/src/pack"
  printf 'id: demo\nversion: "0.1.0"\n' > "$d/product.yml"
  printf 'id: demo\nversion: "0.1.0"\n' > "$d/src/pack/component.yml"
  printf '# list\nproduct.yml\n? src/pack/component.yml\n? src/missing/component.yml\n' > "$d/list.txt"
}

run() { OUT="$(node "$TOOL" "$@" 2>&1)"; CODE=$?; }

# AC-1: an optional file that exists gets the version, and a missing one is skipped.
make_fixture ac1
run set 0.2.0 --root "$WORK/ac1" --list "$WORK/ac1/list.txt"
assert_equals "0" "$CODE" "REQ-001 AC-1: set passes with a missing optional file ($OUT)"
assert_contains 'version: "0.2.0"' "$(cat "$WORK/ac1/product.yml")" "REQ-001 AC-1: the required file holds the new version"
assert_contains 'version: "0.2.0"' "$(cat "$WORK/ac1/src/pack/component.yml")" "REQ-001 AC-1: the present optional file holds the new version"
assert_equals "no" "$([ -e "$WORK/ac1/src/missing/component.yml" ] && echo yes || echo no)" "REQ-001 AC-1: the missing optional file stays missing"
run check --root "$WORK/ac1" --list "$WORK/ac1/list.txt"
assert_equals "0" "$CODE" "REQ-001 AC-1: check passes with a missing optional file ($OUT)"

PRESENT="$(node --input-type=module -e "
import { presentPaths } from '$TOOL';
console.log(presentPaths('$WORK/ac1', '$WORK/ac1/list.txt').join(','));
")"
assert_equals "product.yml,src/pack/component.yml" "$PRESENT" "REQ-001: presentPaths lists the files that exist"

# AC-2: a missing required file still fails.
make_fixture ac2
rm "$WORK/ac2/product.yml"
run set 0.2.0 --root "$WORK/ac2" --list "$WORK/ac2/list.txt"
assert_equals "yes" "$([ "$CODE" -ne 0 ] && echo yes || echo no)" "REQ-001 AC-2: set fails on a missing required file"
assert_contains "file not found: product.yml" "$OUT" "REQ-001 AC-2: set names the missing file"
run check --root "$WORK/ac2" --list "$WORK/ac2/list.txt"
assert_contains "file not found: product.yml" "$OUT" "REQ-001 AC-2: check names the missing file"

# An optional path that escapes the root still fails.
make_fixture escape
printf 'product.yml\n? ../outside/component.yml\n' > "$WORK/escape/list.txt"
run check --root "$WORK/escape" --list "$WORK/escape/list.txt"
assert_contains "path outside the root" "$OUT" "REQ-001: an optional path outside the root fails"

# AC-3: the shipped list names the pack source copy as optional.
assert_contains "? src/ravintio-zero/component.yml" "$(cat "$LIST_REAL")" "REQ-001 AC-3: the shipped list names the source copy as optional"
assert_contains "ravintio-zero/component.yml" "$(grep -v '^?' "$LIST_REAL")" "REQ-001 AC-3: the installed copy stays required"

QUEUE="$SCRIPT_DIR/../scripts/merge-queue.mjs"
assert_contains "presentPaths" "$(cat "$QUEUE")" "REQ-001: the queue stages present files only"

print_summary
