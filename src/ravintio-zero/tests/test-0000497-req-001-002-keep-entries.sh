#!/usr/bin/env bash
# Tests for feature 0000497-keep-worktree-entries, REQ-001 to REQ-003: the driver keeps a step
# worktree that holds untracked backlog entries, removes a clean one, and keeps one it cannot list.
#
# Each case builds a real git repo with a bare origin, a stub claude, and a stub merge queue (see
# helpers/scheduler-fixture.sh).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
STANDARDS="$SCRIPT_DIR/../standards/roadmap-standards.md"
SHIP="$SCRIPT_DIR/../skills/ravintio-ship/SKILL.md"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

yes_no() { [ -e "$1" ] && echo yes || echo no; }

echo ""
echo "=== REQ-001 AC-1, AC-2: an untracked entry keeps the worktree ==="
R="$(make_repo entry 1 '1||')"
S="$(dirname "$R")/stub"
STUB_MODE_1=entry run_sched "$R"
assert_equals "1" "$CODE" "REQ-001 AC-1: driver exits 1"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-001 AC-1: the worktree remains"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-worktrees/step-1/plan/backlog/0000900-lost-entry/entry.md")" "REQ-001 AC-1: the entry remains"
assert_equals "no" "$(yes_no "$S/queue.log")" "REQ-001 AC-1: the queue never ran"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-control/step-1/ready")" "REQ-001 AC-1: the ready file stays"
assert_contains "I-D Advance: Blocked: queue stopped on step 1" "$OUT" "REQ-001 AC-2: prints the queue stop"
assert_contains "plan/backlog/0000900-lost-entry/entry.md" "$OUT" "REQ-001 AC-2: names the file"

echo ""
echo "=== REQ-002 AC-1: a worktree with no untracked entry is removed ==="
R="$(make_repo clean 1 '1||')"
S="$(dirname "$R")/stub"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-002 AC-1: driver exits 0"
assert_equals "no" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-002 AC-1: the worktree is gone"
assert_equals "merged" "$(origin_status "$R" 1)" "REQ-002 AC-1: step 1 merged"

echo ""
echo "=== REQ-002 AC-2: an untracked file outside plan/backlog/ does not stop the queue ==="
R="$(make_repo notes 1 '1||')"
S="$(dirname "$R")/stub"
STUB_MODE_1=notes run_sched "$R"
assert_equals "0" "$CODE" "REQ-002 AC-2: driver exits 0"
assert_equals "no" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-002 AC-2: the worktree is gone"
assert_equals "merged" "$(origin_status "$R" 1)" "REQ-002 AC-2: step 1 merged"

echo ""
echo "=== REQ-002 AC-3: a listing that fails keeps the worktree ==="
R="$(make_repo broken 1 '1||')"
S="$(dirname "$R")/stub"
STUB_MODE_1=breakgit run_sched "$R"
assert_equals "1" "$CODE" "REQ-002 AC-3: driver exits 1"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-002 AC-3: the worktree remains"
assert_equals "no" "$(yes_no "$S/queue.log")" "REQ-002 AC-3: the queue never ran"
assert_contains "I-D Advance: Blocked: queue stopped on step 1" "$OUT" "REQ-002 AC-3: prints the queue stop"
assert_contains "could not list untracked backlog entries" "$OUT" "REQ-002 AC-3: says the listing failed"

echo ""
echo "=== REQ-003 AC-1, AC-2: the ship skill, the driver header, and the standards state the rule ==="
assert_contains "git status --porcelain plan/backlog" "$(cat "$SHIP")" "REQ-003 AC-1: ship lists untracked entries"
assert_contains "untracked backlog entries" "$(sed -n 1,160p "$DRIVER")" "REQ-003 AC-2: the driver header states the rule"
assert_contains "untracked backlog entries" "$(cat "$STANDARDS")" "REQ-003 AC-2: roadmap-standards.md states the rule"

print_summary
