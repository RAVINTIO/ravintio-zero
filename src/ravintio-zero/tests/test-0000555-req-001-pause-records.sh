#!/usr/bin/env bash
# Tests for feature 0000555-initiative-pause-reaches-every-step, req-001: the pause script writes
# the step records and the initiative record for a run with two running steps.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

PAUSE="$SCRIPT_DIR/../scripts/initiative-pause.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

make_root() {
  local r="$WORK/$1"
  mkdir -p "$r/plan/current-initiative" "$r/plan/.initiative-control/step-2" "$r/plan/.initiative-control/step-3" \
    "$r/plan/.initiative-worktrees/step-2/plan/current" "$r/plan/.initiative-worktrees/step-3/plan/current"
  cat > "$r/plan/current-initiative/initiative.md" <<'EOF2'
---
title: "Initiative: demo"
status: "active"
---
# Initiative: demo

**Branch:** initiative/0000050-demo
**Position:** 2
**Concurrency:** 2

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status | Lane | After |
|------|------------|-------|-----------------|------|---------|--------|------|-------|
| 1 | 0000051-a | A | 0000011 | minor | 0.1.0 | merged | one | |
| 2 | 0000052-b | B | 0000012 | minor | | pending | two | |
| 3 | 0000053-c | C | 0000013 | minor | | pending | three | |
| 4 | 0000054-d | D | 0000014 | minor | | pending | four | |
EOF2
  printf '4242\n' > "$r/plan/.initiative-control/step-2/running"
  printf '4243\n' > "$r/plan/.initiative-control/step-3/running"
  printf '### P2: Implement\n\n- In progress: U-1 (2026-11-15T10:00:00Z)\n' > "$r/plan/.initiative-worktrees/step-2/plan/current/build-log.md"
  printf '### P1: Plan\n\n- Blocked: needs a decision\n' > "$r/plan/.initiative-worktrees/step-3/plan/current/build-log.md"
  printf '%s' "$r"
}

echo ""
echo "=== req-001 AC-1: each running step gets a record ==="
R="$(make_root two)"
OUT="$(node "$PAUSE" write --root "$R" 2>&1)"; CODE=$?
assert_equals "0" "$CODE" "AC-1: write exits 0"
S2="$R/plan/.initiative-worktrees/step-2/plan/current/pause.md"
S3="$R/plan/.initiative-worktrees/step-3/plan/current/pause.md"
assert_equals "yes" "$([ -f "$S2" ] && echo yes || echo no)" "AC-1: step 2 holds a pause record"
assert_equals "yes" "$([ -f "$S3" ] && echo yes || echo no)" "AC-1: step 3 holds a pause record"
assert_contains 'phase: "P2"' "$(cat "$S2")" "AC-1: step 2 record names phase P2"
assert_contains 'phase: "P1"' "$(cat "$S3")" "AC-1: step 3 record names phase P1"
assert_contains "In progress: U-1" "$(cat "$S2")" "AC-1: step 2 record holds the last build log line"

echo ""
echo "=== req-001 AC-2: the initiative record ==="
I="$R/plan/current-initiative/pause.md"
assert_equals "yes" "$([ -f "$I" ] && echo yes || echo no)" "AC-2: the initiative record exists"
assert_contains "**Merged:** 1 of 4" "$(cat "$I")" "AC-2: the merged count"
assert_contains "**Remaining order:** 2, 3, 4" "$(cat "$I")" "AC-2: the remaining order"
assert_contains "Open questions" "$(cat "$I")" "AC-2: the open questions heading"
assert_contains "Blocked: needs a decision" "$(cat "$I")" "AC-2: the open block from step 3"
assert_contains "Resume steps" "$(cat "$I")" "AC-2: the resume steps heading"

echo ""
echo "=== req-001 AC-3: refusals ==="
OUT="$(node "$PAUSE" write --root "$R" 2>&1)"; CODE=$?
assert_equals "1" "$CODE" "AC-3: a second write exits 1"
assert_contains "pause.md" "$OUT" "AC-3: names the record that exists"
R="$(make_root link)"
mv "$R/plan/.initiative-worktrees/step-2" "$WORK/elsewhere"
ln -s "$WORK/elsewhere" "$R/plan/.initiative-worktrees/step-2"
OUT="$(node "$PAUSE" write --root "$R" 2>&1)"; CODE=$?
assert_equals "1" "$CODE" "AC-3: a symlinked worktree exits 1"
assert_equals "no" "$([ -e "$WORK/elsewhere/plan/current/pause.md" ] && echo yes || echo no)" "AC-3: nothing written through the link"

echo ""
echo "=== req-001: request writes the pause request ==="
R="$(make_root req)"
node "$PAUSE" request --root "$R" >/dev/null 2>&1; CODE=$?
assert_equals "0" "$CODE" "request exits 0"
assert_equals "yes" "$([ -f "$R/plan/.initiative-control/pause" ] && echo yes || echo no)" "request writes plan/.initiative-control/pause"

print_summary
