#!/usr/bin/env bash
# 0000581 req-001 to req-004: initiative-cleanup.mjs archives the driver state after delivery.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
source "$SCRIPT_DIR/helpers/git-isolation.sh"

CLEAN="$ZERO_DIR/scripts/initiative-cleanup.mjs"
STATUS="$ZERO_DIR/scripts/initiative-status.mjs"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/ravintio_cleanup.XXXXXX")"
isolate_git_env
exit_on_signal
trap 'remove_git_isolation; rm -rf "$WORK"' EXIT

G() { git -c user.name=t -c user.email=t@example.com "$@"; }

# make_root <name>: a git repo with driver state from a delivered initiative.
make_root() {
  local d="$WORK/$1"
  mkdir -p "$d" && G -C "$d" init -q -b main && G -C "$d" commit -q --allow-empty -m init
  mkdir -p "$d/plan/.initiative-control/step-1" "$d/plan/.initiative-control/step-2" "$d/plan/.initiative-logs"
  : > "$d/plan/.initiative-control/step-1/ready"
  : > "$d/plan/.initiative-control/step-2/running"
  echo log > "$d/plan/.initiative-logs/step-1.log"
  echo "$d"
}

run() { local root="$1"; shift; OUT="$(node "$CLEAN" --root "$root" "$@" 2>&1)"; CODE=$?; }

echo "=== req-001 AC-1: the lock blocks the cleanup ==="
R="$(make_root lock)"
: > "$R/plan/.initiative-runner.lock"
run "$R" --id 0000001-demo
assert_equals "1" "$CODE" "AC-1: exits 1"
assert_contains "I-E Delivery: Blocked: a driver holds plan/.initiative-runner.lock" "$OUT" "AC-1: Blocked line"
assert_equals "yes" "$([ -d "$R/plan/.initiative-control" ] && [ -d "$R/plan/.initiative-logs" ] && echo yes || echo no)" "AC-1: nothing moved"

echo "=== req-001 AC-2: a bad id blocks the cleanup ==="
R="$(make_root badid)"
run "$R"
assert_equals "1" "$CODE" "AC-2: no id exits 1"
assert_contains "I-E Delivery: Blocked:" "$OUT" "AC-2: no id Blocked line"
run "$R" --id '../escape'
assert_equals "1" "$CODE" "AC-2: dotted id exits 1"
assert_equals "yes" "$([ -d "$R/plan/.initiative-control" ] && echo yes || echo no)" "AC-2: nothing moved"

echo "=== req-002 AC-1: both folders move ==="
R="$(make_root move)"
run "$R" --id 0000001-demo
assert_equals "0" "$CODE" "AC-1: exits 0"
A="$R/.git/ravintio-archive/0000001-demo"
assert_equals "yes" "$([ -f "$A/.initiative-control/step-1/ready" ] && [ -f "$A/.initiative-logs/step-1.log" ] && echo yes || echo no)" "AC-1: archive holds both"
assert_equals "no" "$([ -e "$R/plan/.initiative-control" ] || [ -e "$R/plan/.initiative-logs" ] && echo yes || echo no)" "AC-1: plan holds neither"

echo "=== req-002 AC-2: an existing target stays ==="
R="$(make_root suffix)"
mkdir -p "$R/.git/ravintio-archive/0000001-demo" && echo old > "$R/.git/ravintio-archive/0000001-demo/keep"
run "$R" --id 0000001-demo
assert_equals "0" "$CODE" "AC-2: exits 0"
assert_equals "old" "$(cat "$R/.git/ravintio-archive/0000001-demo/keep")" "AC-2: old archive unchanged"
assert_equals "yes" "$([ -f "$R/.git/ravintio-archive/0000001-demo-2/.initiative-logs/step-1.log" ] && echo yes || echo no)" "AC-2: suffixed folder holds the logs"

echo "=== req-002 AC-3: the script refuses a symlink ==="
R="$(make_root link)"
mkdir -p "$WORK/elsewhere" && rm -rf "$R/plan/.initiative-logs" && ln -s "$WORK/elsewhere" "$R/plan/.initiative-logs"
run "$R" --id 0000001-demo
assert_equals "1" "$CODE" "AC-3: exits 1"
assert_contains "I-E Delivery: Blocked: refused a symlinked path" "$OUT" "AC-3: Blocked line"
assert_equals "yes" "$([ -d "$R/plan/.initiative-control" ] && echo yes || echo no)" "AC-3: control stays"

echo "=== req-002: a missing folder prints Kept ==="
R="$WORK/bare"; mkdir -p "$R/plan" && G -C "$R" init -q -b main && G -C "$R" commit -q --allow-empty -m init
run "$R" --id 0000001-demo
assert_equals "0" "$CODE" "missing: exits 0"
assert_contains "I-E Delivery: Kept: plan/.initiative-logs is absent" "$OUT" "missing: Kept line"

echo "=== req-003 AC-1 and AC-2: worktrees go and the queue stays ==="
R="$(make_root wt)"
mkdir -p "$R/plan/.initiative-worktrees" "$R/plan/.initiative-queue/item-a" "$R/plan/.initiative-queue/item-b"
G -C "$R" worktree add -q -b feat/a "$R/plan/.initiative-worktrees/step-1"
G -C "$R" worktree add -q -b feat/b "$R/plan/.initiative-worktrees/step-2"
run "$R" --id 0000001-demo
assert_equals "0" "$CODE" "AC-1: exits 0"
assert_equals "no" "$([ -e "$R/plan/.initiative-worktrees/step-1" ] || [ -e "$R/plan/.initiative-worktrees/step-2" ] && echo yes || echo no)" "AC-1: worktrees gone"
assert_equals "1" "$(G -C "$R" worktree list | wc -l | tr -d ' ')" "AC-1: git lists only the main tree"
assert_equals "yes" "$([ -d "$R/plan/.initiative-queue/item-a" ] && [ -d "$R/plan/.initiative-queue/item-b" ] && echo yes || echo no)" "AC-2: queue items stay"
assert_contains "I-E Delivery: Kept: queue item item-a" "$OUT" "AC-2: names item-a"
assert_contains "I-E Delivery: Kept: queue item item-b" "$OUT" "AC-2: names item-b"

echo "=== req-003 AC-3: a failed removal does not stop the run ==="
R="$(make_root unknown)"
mkdir -p "$R/plan/.initiative-worktrees/step-9"
run "$R" --id 0000001-demo
assert_equals "0" "$CODE" "AC-3: exits 0"
assert_contains "I-E Delivery: Kept: plan/.initiative-worktrees/step-9" "$OUT" "AC-3: Kept line"
assert_equals "yes" "$([ -d "$R/.git/ravintio-archive/0000001-demo/.initiative-control" ] && echo yes || echo no)" "AC-3: archive still made"

echo "=== req-004 AC-1: the status reads zero after the cleanup ==="
R="$(make_root status)"
mkdir -p "$R/plan/current-initiative"
run "$R" --id 0000001-demo
printf -- '---\nstatus: active\nposition: 1\n---\n# Initiative\n\n## Steps\n\n| Step | Feature id | Title | Bump | Version | Status |\n|---|---|---|---|---|---|\n| 1 | 0000002-a | A | minor | 1.1.0 | pending |\n| 2 | 0000003-b | B | minor | 1.2.0 | pending |\n' > "$R/plan/current-initiative/initiative.md"
SOUT="$(node "$STATUS" --root "$R" 2>&1)"
assert_contains "merged 0, ready 0, running 0, pending 2 of 2" "$SOUT" "AC-1: counts read zero"

print_summary
