#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-001: roadmap drafts.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
TPL="$ZERO_DIR/templates/initiative.template.md"

echo "=== req-001 (a): template exists with the required fields ==="
assert_equals "yes" "$([ -f "$TPL" ] && echo yes || echo no)" "req-001 (a): initiative.template.md exists"
T="$(cat "$TPL" 2>/dev/null)"
for f in 'title:' 'summary:' 'status:' '**Goal:**' '**Branch:**' '**Status:**' '**Position:**' 'Stop conditions'; do
  assert_contains "$f" "$T" "req-001 (a): template has $f"
done
for s in proposed charted active delivered blocked; do
  assert_contains "$s" "$T" "req-001 (a): template names status $s"
done
assert_contains '| Step | Feature id | Title | Backlog entries | Bump | Version | Status |' "$T" \
  "req-001 (a): template has the six-column step table"

echo ""
echo "=== req-001 (b) and (c): filing a draft ==="
assert_rule rm-filing-draft 'seven-digit sequence' 'plan/backlog/.next-id' 'reserve-id.mjs' \
  'no prefix' 'any branch and in any phase' 'only after the human confirms' \
  'plan/roadmap/{id}-{slug}/initiative.md'

print_summary
