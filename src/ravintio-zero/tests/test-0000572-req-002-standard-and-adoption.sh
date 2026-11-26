#!/usr/bin/env bash
# Tests for feature 0000572-tests-share-a-repo-root-helper, req-002 (standard and adoption).
#
# AC-1: the testing standards name the helpers and the both-trees rule.
# AC-2: the step-clock and handoff-text suites call repo_root and build no root from ../..
# AC-3: the two pack trees match for the files the step edits.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ROOT="$(repo_root)"
STANDARDS="$(cat "$ROOT/src/ravintio-zero/standards/testing-standards.md")"

echo ""
echo "=== AC-1: the standard names the helpers and the rule ==="
assert_contains "pack_tree_src" "$STANDARDS" "REQ-002 AC-1: the standard names pack_tree_src"
assert_contains "pack_tree_installed" "$STANDARDS" "REQ-002 AC-1: the standard names pack_tree_installed"
assert_rule ob-testing-two-trees "repo_root" "runs from both trees before it counts as green"

echo ""
echo "=== AC-2: the two suites use the helper ==="
for name in test-0000534-req-001-003-step-clock.sh test-0000493-req-004-handoff-text.sh; do
  TEXT="$(cat "$ROOT/src/ravintio-zero/tests/$name")"
  assert_contains "repo_root" "$TEXT" "REQ-002 AC-2: $name calls repo_root"
  assert_not_contains '/../..' "$TEXT" "REQ-002 AC-2: $name builds no root from ../.."
done

echo ""
echo "=== AC-3: the pack trees match ==="
for rel in standards/testing-standards.md tests/helpers/assert.sh tests/test-0000534-req-001-003-step-clock.sh \
  tests/test-0000493-req-004-handoff-text.sh tests/test-0000572-req-001-repo-root-helpers.sh \
  tests/test-0000572-req-002-standard-and-adoption.sh; do
  if cmp -s "$ROOT/src/ravintio-zero/$rel" "$ROOT/ravintio-zero/$rel"; then
    assert_equals "same" "same" "REQ-002 AC-3: $rel matches in both trees"
  else
    assert_equals "same" "different" "REQ-002 AC-3: $rel matches in both trees"
  fi
done

print_summary
