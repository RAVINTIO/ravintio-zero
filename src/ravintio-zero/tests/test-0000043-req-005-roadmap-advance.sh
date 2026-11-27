#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-005: roadmap advance.
#
# The ship skill has a "Initiative steps" section for I-D Advance. It applies
# when plan/current-initiative/initiative.md has status active. A normal run keeps
# the tag-before-PR order and the no-merge rule.
#
# Prose checks read the anchored rules (see standards/testing-standards.md section 8).
# Order checks read the I-D Advance section through orch_section.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"
REF="$ZERO_DIR/pipeline-reference.md"

# The section from a heading to the next heading of the same or higher level.
section() { awk -v h="$1" '$0 == h {on=1; next} on && /^##? / {exit} on {print}' "$2"; }

ADV="$(orch_section '### I-D Advance')"

echo ""
echo "=== req-005 (a): initiative-step PR command and initiative.md update ==="
assert_rule rm-ship-stages-scope 'plan/current-initiative/initiative.md' '`status: active`'
assert_rule rm-advance-intro 'I-D Advance:'
assert_rule rm-advance-pr-command '--base initiative/{id}-{slug}'
assert_rule rm-advance-initiative-file '`merged`' 'Version' '`position`' 'same PR'

echo ""
echo "=== req-005 (b): green CI, then the merge queue merges and tags (0000379) ==="
assert_rule rm-advance-poll 'gh pr checks' 'pending'
assert_rule rm-advance-queue-merge 'gh pr merge --squash' 'tags the merge commit `v{version}`'
assert_rule rm-advance-ci-failed 'Blocked:'
assert_rule rm-advance-queue-run 'merge-queue.mjs run --step {step} --pr {k}'
assert_rule rm-advance-ready '$RAVINTIO_INITIATIVE_CONTROL/ready'
assert_rule rm-advance-ready-line 'I-D Advance: Ready: PR #{n}'
order="$(printf '%s\n' "$ADV" | grep -nE 'gh pr checks|merge-queue.mjs run|gh pr merge --squash|tags the merge commit' | cut -d: -f1 | tr '\n' ' ')"
sorted="$(printf '%s\n' $order | sort -n | tr '\n' ' ')"
assert_equals "$sorted" "$order" "req-005 (b): checks, queue run, merge, and tag appear in order"

echo ""
echo "=== req-005 (c): normal run creates no tag and keeps no merge ==="
assert_rule rm-ship-no-tag 'Create no tag.' 'tags the squash commit'
assert_rule shp-hard-limit-merge 'Merging into `main` stays human-only in every run mode'
assert_rule rm-ship-stages-scope 'Outside an initiative'
s7="$(grep -n '^### Step 7' "$SHIP" | cut -d: -f1)"
s8="$(grep -n '^### Step 9' "$SHIP" | cut -d: -f1)"
rs="$(grep -n '^## Initiative steps' "$SHIP" | cut -d: -f1)"
assert_equals "yes" "$([ -n "$s7" ] && [ -n "$s8" ] && [ "$s7" -lt "$s8" ] && echo yes || echo no)" "req-005 (c): Step 7 precedes Step 9 PR"
assert_equals "yes" "$([ -n "$rs" ] && [ -n "$s8" ] && [ "$rs" -gt "$s8" ] && echo yes || echo no)" "req-005 (c): initiative section sits after the normal steps"

echo ""
echo "=== req-005 (d): CI wait polls, then watches ==="
assert_rule rm-advance-poll 'lists at least one check' '2 minutes'
assert_rule rm-advance-no-ci 'no CI ran on PR #{n}'
assert_rule rm-ship-ci-trigger "pull requests to \`initiative/**\`"
assert_rule rm-advance-watch 'gh pr checks {n} --watch --fail-fast' 'longest Bash timeout' 'background task'
assert_rule rm-advance-ci-failed 'Blocked: CI failed on PR #{n}'
assert_equals "0" "$(printf '%s\n' "$ADV" | grep -c 'CI is {red|pending}')" "req-005 (d): pending is no longer a stop"

echo ""
echo "=== req-005 (e): Step 8 runs in the closing push (0000452) ==="
assert_rule rm-ship-stages-step 'Step 8' 'stale feature id'
assert_rule rm-advance-archive-after-ci 'Step 8' '.run-mode' 'closing push'
step9="$(printf '%s\n' "$ADV" | grep -n 'Step 8' | head -1 | cut -d: -f1)"
ready="$(printf '%s\n' "$ADV" | grep -n 'Write `ready` only' | head -1 | cut -d: -f1)"
pr="$(printf '%s\n' "$ADV" | grep -n 'gh pr create' | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$step9" ] && [ -n "$pr" ] && [ "$pr" -lt "$step9" ] && [ "$step9" -lt "$ready" ] && echo yes || echo no)" "req-005 (e): Step 8 comes after gh pr create and before ready in I-D Advance"

echo ""
echo "=== req-005 (f): hand-off after the queue merges ==="
assert_rule rm-advance-handoff 'git pull --ff-only origin initiative/{id}-{slug}' 'git branch -D' 'If the local feature branch still exists'
assert_rule rm-advance-queue-merge 'gh pr merge --squash --delete-branch {n}'
assert_rule rm-advance-complete-line 'I-D Advance: Complete:' 'step {next} of {n} next'
assert_rule rm-advance-position 'one past the last step number'
assert_rule rm-advance-last-step 'driver then prints `I-E Delivery: Pending:`'
push_ln="$(printf '%s\n' "$ADV" | grep -n 'merge-queue.mjs run' | head -1 | cut -d: -f1)"
pull_ln="$(printf '%s\n' "$ADV" | grep -n 'git pull --ff-only' | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$push_ln" ] && [ -n "$pull_ln" ] && [ "$push_ln" -lt "$pull_ln" ] && echo yes || echo no)" "req-005 (f): pull follows the queue run"

echo ""
echo "=== req-005: pipeline reference records both tag orders ==="
SHIPREF="$(section '## Ship Phase' "$REF")"
assert_contains 'initiative' "$SHIPREF" "req-005: pipeline reference Ship Phase mentions initiative steps"
assert_contains 'squash' "$SHIPREF" "req-005: pipeline reference notes the squash-then-tag order"

print_summary
