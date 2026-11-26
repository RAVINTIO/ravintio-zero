#!/usr/bin/env bash
# 0000352 req-002, req-003, req-004: the roadmap standards state the queue rules
# and every coordinator squash command names --delete-branch.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STD="$ZERO_DIR/standards/roadmap-standards.md"

echo "=== req-002 AC-1: the queue item contract ==="
assert_rule rm-coord-aligned 'item.md' '**Step:**' '**Destination:**'

echo ""
echo "=== req-002 AC-2: the routes ==="
assert_rule rm-coord-aligned 'Aligned admin' 'step PR'
assert_rule rm-coord-unaligned '`chore/` PR'
assert_rule rm-sessions-queue 'plan/.initiative-queue/'
assert_not_contains 'After the step merges, it lands them' "$(cat "$STD")" "AC-2: old landing wording is gone"

echo ""
echo "=== req-003 AC-1 and AC-2: the step commits the items that name it ==="
assert_rule icrun-queue 'plan/.initiative-queue/' 'names its number' 'before P4 raises the PR' 'never moves, renames, or deletes' 'coordinator clears'
assert_rule rm-advance-queue-items 'queue'

echo ""
echo "=== req-004 AC-1: the standards name the flag ==="
assert_rule rm-coord-ci 'gh pr merge --squash --delete-branch {n}'

echo ""
echo "=== req-004 AC-2: no bare squash command in the pack ==="
BARE=""
for f in "$ZERO_DIR"/skills/*/SKILL.md "$ZERO_DIR"/skills/*/references/*.md "$ZERO_DIR"/standards/*.md; do
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    case "$line" in
      *'--delete-branch'*) ;;
      *) BARE="$BARE$(basename "$f"): $line"$'\n' ;;
    esac
  done <<< "$(grep -E '^[[:space:]]*gh pr merge --squash' "$f" || true)"
done
assert_equals "" "$BARE" "AC-2: every command line that starts gh pr merge --squash holds --delete-branch"

print_summary
