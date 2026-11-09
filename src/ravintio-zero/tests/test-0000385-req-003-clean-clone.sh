#!/usr/bin/env bash
# Test: 0000385 req-003 clean-clone
# clean-clone-test.mjs runs a command in a clone of HEAD and removes the clone.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPT="$ZERO_DIR/scripts/clean-clone-test.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

REPO="$WORK/repo"
mkdir -p "$REPO/.github/workflows"
git -C "$REPO" init -q
git -C "$REPO" config user.email t@example.com
git -C "$REPO" config user.name t
printf 'committed\n' > "$REPO/tracked.txt"
printf 'jobs:\n  a:\n    runs-on: ubuntu-latest\n  b:\n    runs-on: windows-latest\n' > "$REPO/.github/workflows/ravintio.yml"
git -C "$REPO" commit -q --allow-empty -m empty
git -C "$REPO" update-index --add tracked.txt .github/workflows/ravintio.yml
git -C "$REPO" commit -q -m init
printf 'local only\n' > "$REPO/untracked.txt"

echo "=== AC-1: the command runs in a clone that is removed ==="
OUT="$(cd "$REPO" && node "$SCRIPT" -- pwd)"; RC=$?
CLONE="$(printf '%s\n' "$OUT" | tail -1)"
assert_equals "0" "$RC" "the script returns the command's exit code"
assert_equals "no" "$([ "$CLONE" = "$REPO" ] || [ "$CLONE" = "$(cd "$REPO" && pwd -P)" ] && echo yes || echo no)" "the command ran outside the repository"
assert_equals "no" "$([ -e "$CLONE" ] && echo yes || echo no)" "the clone no longer exists"
(cd "$REPO" && node "$SCRIPT" -- bash -c 'exit 7') >/dev/null; RC=$?
assert_equals "7" "$RC" "a failing command's exit code passes through"

echo "=== AC-2: an untracked file the suite needs makes it fail ==="
(cd "$REPO" && node "$SCRIPT" -- test -f untracked.txt) >/dev/null; RC=$?
assert_equals "1" "$RC" "an untracked file is missing in the clone"
(cd "$REPO" && node "$SCRIPT" -- test -f tracked.txt) >/dev/null; RC=$?
assert_equals "0" "$RC" "a committed file is present in the clone"

echo "=== AC-3: the OS gap is named ==="
printf 'jobs:\n  a:\n    runs-on: solaris-1\n' > "$WORK/other.yml"
OUT="$(cd "$REPO" && node "$SCRIPT" --workflow "$WORK/other.yml" -- true)"
assert_contains "OS gap: local" "$OUT" "a workflow without the local OS prints an OS gap line"
assert_contains "solaris" "$OUT" "the line names the CI OS"
printf 'jobs:\n  a:\n    runs-on: ubuntu-latest\n  b:\n    runs-on: macos-latest\n  c:\n    runs-on: windows-latest\n' > "$WORK/all.yml"
OUT="$(cd "$REPO" && node "$SCRIPT" --workflow "$WORK/all.yml" -- true)"
assert_not_contains "OS gap" "$OUT" "no gap line when the local OS is a CI OS"

echo "=== outside a repository ==="
(cd "$WORK" && node "$SCRIPT" -- true) >/dev/null 2>&1; RC=$?
assert_equals "2" "$RC" "outside a git repository the script exits 2"

echo "=== skill text ==="
assert_rule p3-clean-clone "clean-clone-test.mjs" "clean clone" "HEAD"

print_summary
