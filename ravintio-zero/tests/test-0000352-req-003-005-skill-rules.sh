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

echo "=== req-002 AC-2: the initiative skill routes admin ==="
assert_rule orc-init-queue-item 'item.md' '**Step:**' '{id}'
assert_rule orc-init-queue-route '`chore/` PR'

echo ""
echo "=== req-002 AC-3: the initiative skill stays under 120 lines ==="
LINES="$(wc -l < "$INIT" | tr -d ' ')"
assert_equals "ok" "$([ "$LINES" -lt 120 ] && echo ok || echo long)" "AC-3: $LINES lines"

echo ""
echo "=== req-003 AC-3: ship and the orchestrator point to I-C Run ==="
assert_rule orc-ship-queue-commit 'plan/.initiative-queue/' 'I-C Run'
assert_rule p0-start-backlog-pickup 'plan/.initiative-queue/' 'I-C Run'

echo ""
echo "=== req-004 AC-1: the initiative skill names the full squash command ==="
assert_rule orc-init-squash-delete 'gh pr merge --squash --delete-branch {n}'

echo ""
echo "=== req-005 AC-1: callers of --commit name the route ==="
assert_rule ob-reserve-commit-initiative 'reserve-id.mjs --commit' 'refuses on `initiative/*`' 'feat/'
assert_rule ob-reserve-commit-postmortem 'reserve-id.mjs --commit' 'refuses on `initiative/*`' 'feat/'
assert_rule oa-retro-source-named 'reserve-id.mjs --commit' 'refuses on `initiative/*`' 'feat/'

print_summary
