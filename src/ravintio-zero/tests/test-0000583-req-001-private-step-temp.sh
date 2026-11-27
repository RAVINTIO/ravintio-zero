#!/usr/bin/env bash
# Tests for feature 0000583-step-temp-cleanup-after-merge, REQ-001: the driver gives each step
# session a private temp folder inside its worktree. It passes no sandbox settings.
#
# Each case builds a real git repo with a bare origin, a stub claude, and a stub merge queue (see
# helpers/scheduler-fixture.sh). The stub claude records its environment and arguments.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d -t ravintio_0000583_req001_XXXXXX)"
trap 'chmod -R u+w "$WORK" 2>/dev/null; rm -rf "$WORK"' EXIT
trap 'exit 143' TERM
trap 'exit 130' INT HUP
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

yes_no() { if [ -e "$1" ] || [ -L "$1" ]; then echo yes; else echo no; fi; }

echo ""
echo "=== REQ-001 AC-1, AC-2: the session gets a private TMPDIR and no sandbox settings ==="
R="$(make_repo private 1 '1||' '2||1')"
run_sched "$R"
WT="$R/plan/.initiative-worktrees/step-2"
norm() { printf '%s' "${1#/private}"; }
CWD_SEEN="$(stub_env "$R" 2 cwd)"
assert_equals "0" "$CODE" "REQ-001 AC-1: driver exits 0"
assert_equals "$(norm "$(cd "$R" && pwd -P)")/plan/.initiative-worktrees/step-2" "$(norm "$CWD_SEEN")" "REQ-001 AC-1: the session runs in the step worktree"
assert_equals "$(norm "$CWD_SEEN")/.t" "$(norm "$(stub_env "$R" 2 TMPDIR)")" "REQ-001 AC-1: TMPDIR is {worktree}/.t"
assert_equals "$(norm "$CWD_SEEN")/.t" "$(norm "$(stub_env "$R" 2 CEILING)")" "REQ-001 AC-1: GIT_CEILING_DIRECTORIES is {worktree}/.t"
SETTINGS="$(stub_env "$R" 2 SETTINGS)"
assert_equals "" "$SETTINGS" "REQ-001 AC-2: the driver passes no --settings, so the session runs without the sandbox"

echo ""
echo "=== REQ-001 AC-3: a merged step leaves no worktree and no .t folder ==="
assert_equals "merged" "$(origin_status "$R" 2)" "REQ-001 AC-3: step 2 merged"
assert_equals "no" "$(yes_no "$WT/.t")" "REQ-001 AC-3: the .t folder is gone"
assert_equals "no" "$(yes_no "$WT")" "REQ-001 AC-3: the worktree is gone"
assert_not_contains "step-2" "$(git -C "$R" worktree list)" "REQ-001 AC-3: git no longer lists the worktree"

echo ""
echo "=== REQ-001 AC-4: .gitignore lists .t/ ==="
REPO_TOP="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
if [ -n "$REPO_TOP" ] && [ -f "$REPO_TOP/.gitignore" ]; then
  assert_contains ".t/" "$(cat "$REPO_TOP/.gitignore")" "REQ-001 AC-4: .gitignore lists .t/"
fi

echo ""
echo "=== REQ-001 AC-5: a path with no room for a socket name stops the driver ==="
LONG="long$(printf 'x%.0s' $(seq 90))"
R="$(make_repo "$LONG" 1 '1||' '2||1')"
RAVINTIO_TEMP_PATH_LIMIT=104 run_sched "$R"
[ "$CODE" != "0" ] && echo "PASS: REQ-001 AC-5: driver stops" || assert_equals "nonzero" "$CODE" "REQ-001 AC-5: driver stops"
assert_contains "too long for a Unix socket" "$OUT$(cat "$(dirname "$R")/err.txt")" "REQ-001 AC-5: the message names the cause"
assert_equals "pending" "$(origin_status "$R" 1)" "REQ-001 AC-5: step 1 did not run"

print_summary
