#!/usr/bin/env bash
# Tests for feature 0000318-titled-coordinator-prs, req-001, req-002, and req-003 AC-2.
#
# Coordinator work reaches an initiative branch only as a titled squashed PR.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STD="$ZERO_DIR/standards/roadmap-standards.md"
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"

STD_TEXT="$(cat "$STD")"
SKILL_TEXT="$(cat "$SKILL")"
CPR="$(awk '$0 == "## Coordinator PRs" {on=1; next} on && /^## / {exit} on {print}' "$STD")"
CARVE="$(awk '$0 == "## Merge carve-out" {on=1; next} on && /^## / {exit} on {print}' "$STD")"
ADVANCE="$(awk '$0 == "### I-D Advance" {on=1; next} on && /^### / {exit} on {print}' "$STD")"

echo "=== req-001 AC-1: the rule is stated ==="
assert_contains 'Nothing commits directly on `initiative/*`' "$STD_TEXT" "req-001 AC-1: standards state no direct commits"

echo ""
echo "=== req-001 AC-2: the old wording is gone ==="
for f in "$STD" "$SKILL"; do
  if grep -E '[Cc]ommit [^.]*on the initiative branch' "$f" >/dev/null; then
    assert_equals "absent" "present" "req-001 AC-2: $(basename "$f") has no direct-commit wording"
  else
    assert_equals "absent" "absent" "req-001 AC-2: $(basename "$f") has no direct-commit wording"
  fi
done
SKILL_LINES="$(wc -l < "$SKILL" | tr -d ' ')"
[ "$SKILL_LINES" -lt 120 ] && R=ok || R=long
assert_equals "ok" "$R" "req-001: initiative skill stays under 120 lines"

echo ""
echo "=== req-002 AC-1: the section exists ==="
assert_contains '{id}-{slug}: {summary} (#{n})' "$CPR" "req-002 AC-1: names the title form"
assert_contains 'local suite' "$CPR" "req-002 AC-1: names the local suite"
assert_contains 'green' "$CPR" "req-002 AC-1: names green CI"
assert_contains 'gh pr merge --squash' "$CPR" "req-002 AC-1: names the squash"
assert_contains 'driver is stopped' "$CPR" "req-002 AC-1: raised only while the driver is stopped"
assert_contains 'plan/.initiative-queue/' "$CPR" "req-002 AC-1: queue while a step runs"

echo ""
echo "=== req-002 AC-2: the carve-out names coordinator PRs ==="
assert_contains 'coordinator PR' "$CARVE" "req-002 AC-2: carve-out names coordinator PRs"
assert_contains 'own feature branch' "$CARVE" "req-002 AC-2: carve-out keeps own feature branch"
assert_contains 'clean P3' "$CARVE" "req-002 AC-2: carve-out keeps clean P3"
assert_contains 'green CI' "$CARVE" "req-002 AC-2: carve-out keeps green CI"

echo ""
echo "=== req-002 AC-3: the skill points to the section ==="
assert_contains 'Coordinator PRs' "$SKILL_TEXT" "req-002 AC-3: skill names the section"
assert_contains 'driver is stopped' "$SKILL_TEXT" "req-002 AC-3: skill names the stopped driver"

echo ""
echo "=== req-003 AC-2: PR number commit comes before the squash ==="
POS_CREATE="$(printf '%s\n' "$ADVANCE" | grep -n 'gh pr create' | head -1 | cut -d: -f1)"
POS_NUM="$(printf '%s\n' "$ADVANCE" | grep -n '\*\*PR:\*\*' | head -1 | cut -d: -f1)"
POS_SQUASH="$(printf '%s\n' "$ADVANCE" | grep -n 'gh pr merge --squash' | head -1 | cut -d: -f1)"
if [ -n "$POS_NUM" ] && [ -n "$POS_SQUASH" ] && [ -n "$POS_CREATE" ] && [ "$POS_CREATE" -lt "$POS_NUM" ] && [ "$POS_NUM" -lt "$POS_SQUASH" ]; then
  R=ordered
else
  R="create=$POS_CREATE num=$POS_NUM squash=$POS_SQUASH"
fi
assert_equals "ordered" "$R" "req-003 AC-2: PR field set after create and before squash"
assert_contains 'Never commit after the squash' "$ADVANCE" "req-003 AC-2: no commit after the squash"

print_summary
