#!/usr/bin/env bash
# Tests for feature 0000397-pack-source-in-src, req-002.
#
# sync-installed.mjs checks and refreshes the installed copy. All work runs in a
# scratch folder through --root.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SYNC="$SCRIPT_DIR/../scripts/sync-installed.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

S="$TMP/src/ravintio-zero"
D="$TMP/ravintio-zero"
mkdir -p "$S/scripts" "$S/docs" "$D"
printf 'one\n' > "$S/a.txt"
printf '#!/bin/sh\necho hi\n' > "$S/scripts/run.sh"
chmod +x "$S/scripts/run.sh"
printf 'doc\n' > "$S/docs/d.md"

run() { node "$SYNC" --root "$TMP" "$@" 2>&1; }

# Refresh makes the folders match.
out=$(run); rc=$?
assert_exit_zero "$rc" "refresh exits 0"
run --check >/dev/null; rc=$?
assert_exit_zero "$rc" "AC-1: parity makes --check exit 0"
[ -x "$D/scripts/run.sh" ] && ok=0 || ok=1
assert_exit_zero "$ok" "refresh keeps the executable bit"

# Plain copy, no symlink.
n=$(find "$D" -type l | wc -l | tr -d ' ')
assert_equals "0" "$n" "installed copy holds no symlink"
[ -L "$D" ] && l=1 || l=0
assert_equals "0" "$l" "installed folder is not a symlink"

# AC-2: a drifted file is named.
printf 'two\n' > "$D/a.txt"
out=$(run --check); rc=$?
assert_equals "1" "$rc" "AC-2: drift makes --check exit 1"
assert_contains "a.txt" "$out" "AC-2: --check names the drifted file"

# Missing and extra files.
rm "$D/docs/d.md"
printf 'x\n' > "$D/extra.txt"
out=$(run --check); rc=$?
assert_equals "1" "$rc" "missing and extra files make --check exit 1"
assert_contains "docs/d.md" "$out" "--check names the missing file"
assert_contains "extra.txt" "$out" "--check names the extra file"

# --check writes nothing.
[ -e "$D/docs/d.md" ] && w=1 || w=0
assert_equals "0" "$w" "--check does not write"

# Refresh repairs drift and deletes extras.
run >/dev/null
run --check >/dev/null; rc=$?
assert_exit_zero "$rc" "refresh repairs drift"
[ -e "$D/extra.txt" ] && e=1 || e=0
assert_equals "0" "$e" "refresh deletes files the source no longer has"

# Refuses symlinks.
rm -rf "$D"; ln -s "$S" "$D"
out=$(run --check); rc=$?
assert_equals "2" "$rc" "refuses a symlinked target"
rm "$D"; mkdir "$D"

print_summary
