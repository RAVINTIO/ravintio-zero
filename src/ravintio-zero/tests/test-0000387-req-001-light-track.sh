#!/usr/bin/env bash
# Test: 0000387 req-001 light-track
# The light discovery track is offered for fixes and small changes, asks three
# questions, still writes the full record set, and switches to full when a change grows.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

REF="$_ASSERT_PACK_ROOT/skills/ravintio-orchestrator/references/orchestrator-light-discovery.md"
SKILL="$_ASSERT_PACK_ROOT/skills/ravintio-orchestrator/SKILL.md"
DISC="$_ASSERT_PACK_ROOT/templates/discovery.template.md"

echo "=== AC-1: offer ==="
assert_rule light-offer "fix" "small change" "confirm" "chart"
assert_rule light-questions "expected behaviour" "acceptance check" "version bump"
assert_rule light-skips "Scope Lock Challenge" "Discovery Gate Checklist"

echo "=== AC-2: complete records ==="
assert_rule light-records "discovery.md" "design.md" "build log"
assert_rule light-marker "Track: light" "Track: full" "missing" "full"
for h in "## Feature" "## Product Layer" "## Architecture Layer" "## Engineering Layer" \
  "## Component Paths" "## Scope" "## Assumptions" "## Risks" "## Dependencies" \
  "## Active Skills" "## Skill Map" "## Repo Instructions" "## Confirmation"; do
  assert_contains "$h" "$(cat "$REF" 2>/dev/null)" "reference lists design heading $h"
done
assert_contains "| Track |" "$(cat "$DISC" 2>/dev/null)" "discovery template has a Track field"

echo "=== AC-3: switch ==="
assert_rule light-switch "full track" "Track switched: light to full ({reason})" "build log"

echo "=== Pack Index ==="
assert_contains "references/orchestrator-light-discovery.md" "$(cat "$SKILL")" "Pack Index points to the reference"
SIZE="$(wc -c < "$SKILL" | tr -d ' ')"
if [ "$SIZE" -le 9000 ]; then _pass_line "SKILL.md is $SIZE bytes"; ((PASS++)) || true
else _fail_line "SKILL.md is $SIZE bytes, over 9000"; ((FAIL++)) || true; fi
assert_contains "grouping rule" "$(cat "$SKILL")" "SKILL.md names the records reference"

print_summary
