#!/usr/bin/env bash
# 0000352 req-002 AC-2 and AC-3, req-003 AC-3, req-004, req-005: the skills carry the queue
# rules and name the feat/ route for reserve-id.mjs --commit.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

INIT="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"
POST="$ZERO_DIR/skills/ravintio-postmortem/SKILL.md"
RETRO="$ZERO_DIR/skills/ravintio-retrospective/SKILL.md"
P0="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md"

INIT_TEXT="$(cat "$INIT")"
QUEUE="$(awk '$0 == "## Backlog queue" {on=1; next} on && /^## / {exit} on {print}' "$INIT")"

echo "=== req-002 AC-2: the initiative skill routes admin ==="
assert_contains 'item.md' "$QUEUE" "AC-2: queue section names item.md"
assert_contains '**Step:**' "$QUEUE" "AC-2: names the Step field"
assert_contains '`chore/` PR' "$QUEUE" "AC-2: unaligned admin goes through a chore/ PR"
assert_contains '{id}' "$QUEUE" "AC-2: a queued entry carries an {id} placeholder"

echo ""
echo "=== req-002 AC-3: the initiative skill stays under 120 lines ==="
LINES="$(wc -l < "$INIT" | tr -d ' ')"
assert_equals "ok" "$([ "$LINES" -lt 120 ] && echo ok || echo long)" "AC-3: $LINES lines"

echo ""
echo "=== req-003 AC-3: ship and the orchestrator point to I-C Run ==="
assert_contains 'plan/.initiative-queue/' "$(cat "$SHIP")" "AC-3: ship names the queue"
assert_contains 'I-C Run' "$(grep -F 'plan/.initiative-queue/' "$SHIP")" "AC-3: ship cites I-C Run for the queue"
assert_contains 'plan/.initiative-queue/' "$(cat "$P0")" "AC-3: backlog pickup names the queue"
assert_contains 'I-C Run' "$(grep -F 'plan/.initiative-queue/' "$P0")" "AC-3: backlog pickup cites I-C Run for the queue"

echo ""
echo "=== req-004 AC-1: the initiative skill names the full squash command ==="
assert_contains 'gh pr merge --squash --delete-branch {n}' "$INIT_TEXT" "AC-1: initiative skill names --delete-branch"

echo ""
echo "=== req-005 AC-1: callers of --commit name the route ==="
for f in "$INIT" "$POST" "$RETRO"; do
  LINE="$(grep -F 'reserve-id.mjs --commit' "$f" | head -1)"
  CTX="$(grep -F -A2 'reserve-id.mjs --commit' "$f")"
  assert_contains 'refuses on `initiative/*`' "$CTX" "AC-1: $(basename "$(dirname "$f")") says --commit refuses on initiative/*"
  assert_contains 'feat/' "$CTX" "AC-1: $(basename "$(dirname "$f")") names the feat/ route"
done
[ -n "${LINE:-}" ] || true

print_summary
