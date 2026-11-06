#!/usr/bin/env bash
# 0000352 req-002, req-003, req-004: the roadmap standards state the queue rules
# and every coordinator squash command names --delete-branch.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STD="$ZERO_DIR/standards/roadmap-standards.md"
CPR="$(awk '$0 == "## Coordinator PRs" {on=1; next} on && /^## / {exit} on {print}' "$STD")"
RUN="$(awk '$0 == "### I-C Run" {on=1; next} on && /^### / {exit} on {print}' "$STD")"
ADVANCE="$(awk '$0 == "### I-D Advance" {on=1; next} on && /^### / {exit} on {print}' "$STD")"
SESSIONS="$(awk '$0 == "#### Sessions and ack files" {on=1; next} on && /^###/ {exit} on {print}' "$STD")"

echo "=== req-002 AC-1: the queue item contract ==="
assert_contains 'item.md' "$CPR" "AC-1: Coordinator PRs name item.md"
assert_contains '**Step:**' "$CPR" "AC-1: names the Step field"
assert_contains '**Destination:**' "$CPR" "AC-1: names the Destination field"

echo ""
echo "=== req-002 AC-2: the routes ==="
assert_contains 'Aligned admin' "$CPR" "AC-2: defines aligned admin"
assert_contains 'step PR' "$CPR" "AC-2: aligned admin goes in the step PR"
assert_contains '`chore/` PR' "$CPR" "AC-2: unaligned admin goes through a chore/ PR"
assert_contains 'plan/.initiative-queue/' "$SESSIONS" "AC-2: the sessions section keeps the queue"
assert_not_contains 'After the step merges, it lands them' "$SESSIONS" "AC-2: old landing wording is gone"

echo ""
echo "=== req-003 AC-1 and AC-2: the step commits the items that name it ==="
assert_contains 'plan/.initiative-queue/' "$RUN" "AC-1: I-C Run reads the queue"
assert_contains 'names its number' "$RUN" "AC-1: acts only on items that name its number"
assert_contains 'before P4 raises the PR' "$RUN" "AC-1: commits before P4 raises the PR"
assert_contains 'never moves, renames, or deletes' "$RUN" "AC-2: the step leaves the queue in place"
assert_contains 'coordinator clears' "$RUN" "AC-2: the coordinator clears the items"
assert_contains 'queue' "$ADVANCE" "AC-1: I-D Advance raises the PR after the queue commits"

echo ""
echo "=== req-004 AC-1: the standards name the flag ==="
assert_contains 'gh pr merge --squash --delete-branch {n}' "$CPR" "AC-1: Coordinator PRs name the full command"

echo ""
echo "=== req-004 AC-2: no bare squash command in the pack ==="
BARE=""
for f in "$ZERO_DIR"/skills/*/SKILL.md "$ZERO_DIR"/skills/*/references/*.md "$ZERO_DIR"/standards/*.md; do
  while IFS= read -r line; do
    case "$line" in
      *'--delete-branch'*) ;;
      *) BARE="$BARE$(basename "$f"): $line"$'\n' ;;
    esac
  done < <(grep -E '^[[:space:]]*gh pr merge --squash' "$f")
done
assert_equals "" "$BARE" "AC-2: every command line that starts gh pr merge --squash holds --delete-branch"

print_summary
