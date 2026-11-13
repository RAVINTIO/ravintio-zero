#!/usr/bin/env bash
# Tests for feature 0000507-hook-check-after-setup, REQ-003: the driver runs hook-check.mjs
# after the approved setup command exits 0.
#
# AC-1: a passing check carries on and step 2 starts.
# AC-2: a failing check prints a Blocked: line that names the hook, exits 1, and stops step 2.
# AC-3: a failing setup command does not run the check.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/bin"
cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
# Stub claude. STUB_CHANGE lists the paths that step 1 changes before it merges.
RM=plan/current-initiative/initiative.md
pos="$(sed -nE 's/^(position: *)//p' "$RM")"
printf '%s\n' "$pos" >> "$STUB_ENV"
if [ "$pos" = 2 ]; then
  mkdir -p plan/_archive
  mv plan/current-initiative plan/_archive/0000050-demo-initiative-2026-10-28
else
  for f in $STUB_CHANGE; do printf 'changed by step %s\n' "$pos" >> "$f"; done
  sed -i.bak -E "s/^(position: *).*/\\1$((pos + 1))/" "$RM" && rm -f "$RM.bak"
fi
git add -A >/dev/null 2>&1; git commit -qm "step $pos" >/dev/null 2>&1
exit 0
STUB
chmod +x "$WORK/bin/claude"

# make_fixture <name> <decisions row or ''> [steps]: a git work tree on branch initiative/0000050-demo.
make_fixture() {
  local d="$WORK/$1" steps="${3:-2}"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current" "$d/ravintio-zero/scripts" "$d/ravintio-zero/skills"
  {
    cat <<'EOF2'
---
title: "Initiative: demo"
summary: "Steps."
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
    [ "$steps" = 2 ] && printf '| 2 | 0000052-b | 0000012 | minor | | pending |\n'
    printf '\n## Decisions\n\n| Step | Fork | Pre-approved answer | Bump effect |\n|---|---|---|---|\n'
    [ -n "$2" ] && printf '%s\n' "$2"
    printf '| 1 | Another fork | Do the other thing | none |\n'
  } > "$d/plan/current-initiative/initiative.md"
  : > "$d/plan/current/build-log.md"
  cat > "$d/ravintio-zero/setup.sh" <<'EOF2'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_SETUP"
[ "${STUB_SETUP_FAIL:-}" = 1 ] && exit 1
exit 0
EOF2
  cat > "$d/ravintio-zero/scripts/hook-check.mjs" <<'EOF2'
#!/usr/bin/env node
import { appendFileSync } from 'node:fs';
appendFileSync(process.env.STUB_HOOK, process.argv.slice(2).join(' ') + '\n');
if (process.env.STUB_HOOK_FAIL === '1') {
  console.log('fail: PreToolUse Write guard-run.mjs gate-write.mjs (exit 1 boom)');
  process.exit(1);
}
console.log('hook-check: 1 passed, 0 failed');
EOF2
  printf 'original\n' > "$d/ravintio-zero/skills/s.md"
  printf 'original\n' > "$d/ravintio-zero/scripts/initiative-run.mjs"
  git -C "$d" init -q -b initiative/0000050-demo
  git -C "$d" config user.email t@example.com
  git -C "$d" config user.name t
  printf 'env.log\nsetup.log\nhook.log\n' > "$d/.gitignore"
  git -C "$d" add -A
  git -C "$d" commit -qm init
  printf '%s' "$d"
}

ROW='| 1-21 | Confirmation: setup rerun at each `Setup:` stop | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`. | none |'
BADROW='| 1-21 | Confirmation: setup rerun at each `Setup:` stop | Run the exact command `rm -rf x`. | none |'

# run_driver <root> <changed paths>: sets OUT and CODE.
run_driver() {
  OUT="$(cd "$1" && PATH="$WORK/bin:$PATH" STUB_ENV="$1/env.log" STUB_SETUP="$1/setup.log" STUB_HOOK="$1/hook.log" STUB_HOOK_FAIL="${HOOK_FAIL:-0}" STUB_CHANGE="$2" node "$DRIVER" --root "$1" 2>&1)"
  CODE=$?
}
setup_runs() { [ -f "$1/setup.log" ] && wc -l < "$1/setup.log" | tr -d ' ' || echo 0; }

echo ""
echo "=== REQ-003 AC-1: a passing check carries on ==="
R="$(make_fixture pass "$ROW")"
run_driver "$R" "ravintio-zero/skills/s.md"
assert_equals "0" "$CODE" "driver finishes"
assert_equals "1" "$(wc -l < "$R/hook.log" | tr -d ' ')" "the check ran once"
assert_contains "--root $R" "$(cat "$R/hook.log")" "the check got the project root"
assert_contains "I-D Advance: Setup: step 1 ran the approved setup command" "$OUT" "the ran line prints"
assert_equals "2" "$(wc -l < "$R/env.log" | tr -d ' ')" "step 2 started"

echo ""
echo "=== REQ-003 AC-2: a failing check stops with a Blocked line ==="
R="$(make_fixture hookfail "$ROW")"
HOOK_FAIL=1 run_driver "$R" "ravintio-zero/skills/s.md"
assert_equals "1" "$CODE" "driver exits 1"
assert_contains "I-D Advance: Blocked: hook check failed after setup: fail: PreToolUse Write guard-run.mjs gate-write.mjs" "$OUT" "the Blocked line names the hook"
assert_equals "1" "$(wc -l < "$R/env.log" | tr -d ' ')" "step 2 did not start"
assert_not_contains "ran the approved setup command" "$OUT" "no ran line prints"

echo ""
echo "=== REQ-003 AC-3: a failing setup command skips the check ==="
R="$(make_fixture setupfail "$ROW")"
OUT="$(cd "$R" && PATH="$WORK/bin:$PATH" STUB_ENV="$R/env.log" STUB_SETUP="$R/setup.log" STUB_SETUP_FAIL=1 STUB_HOOK="$R/hook.log" STUB_HOOK_FAIL=0 STUB_CHANGE=ravintio-zero/skills/s.md node "$DRIVER" --root "$R" 2>&1)"
CODE=$?
assert_equals "1" "$CODE" "driver exits 1"
assert_equals "0" "$([ -f "$R/hook.log" ] && wc -l < "$R/hook.log" | tr -d ' ' || echo 0)" "the check did not run"
assert_contains "The approved setup command failed." "$OUT" "the existing stop line prints"

echo ""
echo "=== REQ-003: a pack with no hook-check.mjs carries on ==="
R="$(make_fixture nocheck "$ROW")"
git -C "$R" rm -q ravintio-zero/scripts/hook-check.mjs && git -C "$R" commit -qm "no check"
run_driver "$R" "ravintio-zero/skills/s.md"
assert_equals "0" "$CODE" "driver finishes"
assert_contains "hook-check.mjs is missing" "$OUT" "the skip line prints"
assert_equals "2" "$(wc -l < "$R/env.log" | tr -d ' ')" "step 2 started"

print_summary
