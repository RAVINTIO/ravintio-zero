#!/usr/bin/env bash
# Tests for feature 0000357-guard-gaps-closed, REQ-004: the prefix-misses log is ignored.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== REQ-004 AC-1: both ignore files hold the rule ==="
for f in "$ROOT/.gitignore" "$ZERO_DIR/.gitignore"; do
  assert_equals "1" "$(grep -cxF 'plan/.prefix-misses.log' "$f")" "REQ-004: ${f#"$ROOT"/} holds the rule once"
done

echo ""
echo "=== REQ-004 AC-1: a fresh repo ignores the log with an empty exclude file ==="
WS=$(mktemp -d -t ravintio_0000357_req004_XXXXXX)
trap 'rm -rf "$WS"' EXIT
git -C "$WS" init -q
cp "$ROOT/.gitignore" "$WS/.gitignore"
: > "$WS/.git/info/exclude"
assert_equals "plan/.prefix-misses.log" "$(git -C "$WS" check-ignore plan/.prefix-misses.log)" "REQ-004: the root .gitignore ignores the log"
cp "$ZERO_DIR/.gitignore" "$WS/.gitignore"
assert_equals "plan/.prefix-misses.log" "$(git -C "$WS" check-ignore plan/.prefix-misses.log)" "REQ-004: the pack .gitignore ignores the log"
print_summary
