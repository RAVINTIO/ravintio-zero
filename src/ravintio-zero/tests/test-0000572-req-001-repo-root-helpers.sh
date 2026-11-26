#!/usr/bin/env bash
# Tests for feature 0000572-tests-share-a-repo-root-helper, req-001 (the repo-root helpers).
#
# AC-1: repo_root prints the same folder from a start folder in each pack tree.
# AC-2: pack_tree_src and pack_tree_installed print the two tree paths.
# AC-3: repo_root prints nothing and returns 1 when no product.yml sits above the start folder.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

# The root comes from git, so the check does not depend on the helper under test.
ROOT="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo ""
echo "=== AC-1: the root is the same from both trees ==="
assert_equals "$ROOT" "$(repo_root "$ROOT/src/ravintio-zero/tests")" "REQ-001 AC-1: repo_root from the source tree"
assert_equals "$ROOT" "$(repo_root "$ROOT/ravintio-zero/tests")" "REQ-001 AC-1: repo_root from the installed tree"
assert_equals "$ROOT" "$(repo_root)" "REQ-001 AC-1: repo_root with no argument starts at the calling script"

echo ""
echo "=== AC-2: the tree helpers return both trees ==="
assert_equals "$ROOT/src/ravintio-zero" "$(pack_tree_src "$ROOT/ravintio-zero/tests")" "REQ-001 AC-2: pack_tree_src"
assert_equals "$ROOT/ravintio-zero" "$(pack_tree_installed "$ROOT/src/ravintio-zero/tests")" "REQ-001 AC-2: pack_tree_installed"

echo ""
echo "=== AC-3: a missing root fails loudly ==="
mkdir -p "$WORK/a/b"
OUT="$(repo_root "$WORK/a/b")"
RC=$?
assert_equals "" "$OUT" "REQ-001 AC-3: repo_root prints nothing when no product.yml sits above"
assert_equals "1" "$RC" "REQ-001 AC-3: repo_root returns 1 when no product.yml sits above"
touch "$WORK/product.yml"
assert_equals "$WORK" "$(repo_root "$WORK/a/b")" "REQ-001 AC-3: repo_root finds a product.yml in a scratch tree"

echo ""
echo "=== NFR-002: sourcing assert.sh prints nothing ==="
assert_equals "" "$(bash -c 'source "$1"' _ "$SCRIPT_DIR/helpers/assert.sh" 2>&1)" "NFR-002: sourcing assert.sh prints nothing"

print_summary
