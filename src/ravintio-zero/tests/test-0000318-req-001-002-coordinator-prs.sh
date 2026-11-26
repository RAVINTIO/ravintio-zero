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

ADVANCE="$(orch_section "### I-D Advance")"

echo "=== req-001 AC-1: the rule is stated ==="
assert_rule rm-coord-no-direct 'Nothing commits directly on `initiative/*`'

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
assert_rule rm-coord-title '{id}-{slug}: {summary} (#{n})'
assert_rule rm-coord-local-suite 'local suite'
assert_rule rm-coord-ci 'green' 'gh pr merge --squash'
assert_rule rm-coord-timing 'driver has stopped' 'plan/.initiative-queue/'

echo ""
echo "=== req-002 AC-2: the carve-out names coordinator PRs ==="
assert_rule carveout-clean-p3 'coordinator PR' 'clean P3' 'green CI'
assert_rule carveout-own-branch 'own feature branch'

echo ""
echo "=== req-002 AC-3: the skill points to the section ==="
assert_rule orc-init-squash-delete 'Coordinator PRs' 'driver has stopped'

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
assert_rule rm-advance-pr-number 'Never commit after the squash'

print_summary
