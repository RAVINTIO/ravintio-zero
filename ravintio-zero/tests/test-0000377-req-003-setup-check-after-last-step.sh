#!/usr/bin/env bash
# Tests for feature 0000377-driver-stops-and-headroom, req-003: the driver runs the setup change
# check after the last step, before it prints I-E Delivery: Pending:.
#
# AC-7: the last step changes a setup file, so the driver prints the Setup line and exits 1.
# AC-8: the last step changes only a test, so the driver prints Pending and exits 0.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/bin"
cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
# Stub claude. The only step changes the paths in STUB_CHANGE, then moves the position past the end.
RM=plan/current-initiative/initiative.md
pos="$(sed -nE 's/^(position: *)//p' "$RM")"
for f in $STUB_CHANGE; do printf 'changed by step %s\n' "$pos" >> "$f"; done
sed -i.bak -E "s/^(position: *).*/\\1$((pos + 1))/" "$RM" && rm -f "$RM.bak"
git add -A >/dev/null 2>&1; git commit -qm "step $pos" >/dev/null 2>&1
exit 0
STUB
chmod +x "$WORK/bin/claude"

make_fixture() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current" "$d/ravintio-zero/skills/ravintio-ship" "$d/ravintio-zero/tests"
  cat > "$d/plan/current-initiative/initiative.md" <<'EOF2'
---
title: "Initiative: demo"
summary: "One step."
status: active
---
# Initiative: demo

goal: demo
branch: initiative/0000050-demo
status: active
position: 1

## Steps

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | 0000051-a | 0000011 | minor | | pending |
EOF2
  : > "$d/plan/current/build-log.md"
  printf 'original\n' > "$d/ravintio-zero/skills/ravintio-ship/SKILL.md"
  printf 'original\n' > "$d/ravintio-zero/tests/t.sh"
  git -C "$d" init -q -b initiative/0000050-demo
  git -C "$d" config user.email t@example.com
  git -C "$d" config user.name t
  git -C "$d" add -A
  git -C "$d" commit -qm init
  printf '%s' "$d"
}

run_driver() {
  OUT="$(cd "$1" && PATH="$WORK/bin:$PATH" STUB_CHANGE="$2" node "$DRIVER" --root "$1" 2>&1)"
  CODE=$?
}

echo ""
echo "=== req-003 AC-7: a setup change in the last step stops before Pending ==="
R="$(make_fixture ac7)"
run_driver "$R" "ravintio-zero/skills/ravintio-ship/SKILL.md"
assert_equals "1" "$CODE" "req-003 AC-7: driver exits 1"
assert_contains "I-D Advance: Setup: step 1 changed ravintio-zero/skills/ravintio-ship/SKILL.md. Rerun setup, then start a new driver." "$OUT" "req-003 AC-7: the Setup line names the file"
assert_not_contains "I-E Delivery: Pending:" "$OUT" "req-003 AC-7: no Pending line"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "req-003 AC-7: the lock is released"

echo ""
echo "=== req-003 AC-8: a test-only change in the last step prints Pending ==="
R="$(make_fixture ac8)"
run_driver "$R" "ravintio-zero/tests/t.sh"
assert_equals "0" "$CODE" "req-003 AC-8: driver exits 0"
assert_contains "I-E Delivery: Pending: all 1 steps merged" "$OUT" "req-003 AC-8: prints Pending"
assert_not_contains "Setup:" "$OUT" "req-003 AC-8: no Setup line"

print_summary
