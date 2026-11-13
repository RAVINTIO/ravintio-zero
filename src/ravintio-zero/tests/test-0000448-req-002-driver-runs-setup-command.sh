#!/usr/bin/env bash
# Tests for feature 0000448-driver-runs-approved-setup-command, req-002: at a Setup: hit the
# driver runs the approved command from the chart and carries on.
#
# AC-1: a valid row runs the command once and step 2 starts (serial and concurrent).
# AC-2: no row, a different form, or a failing command stops with the Setup: line.
# AC-3: a Restart: hit still stops after the command ran.

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
  printf 'original\n' > "$d/ravintio-zero/skills/s.md"
  printf 'original\n' > "$d/ravintio-zero/scripts/initiative-run.mjs"
  git -C "$d" init -q -b initiative/0000050-demo
  git -C "$d" config user.email t@example.com
  git -C "$d" config user.name t
  printf 'env.log\nsetup.log\n' > "$d/.gitignore"
  git -C "$d" add -A
  git -C "$d" commit -qm init
  printf '%s' "$d"
}

ROW='| 1-21 | Confirmation: setup rerun at each `Setup:` stop | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`. | none |'
BADROW='| 1-21 | Confirmation: setup rerun at each `Setup:` stop | Run the exact command `rm -rf x`. | none |'

# run_driver <root> <changed paths>: sets OUT and CODE.
run_driver() {
  OUT="$(cd "$1" && PATH="$WORK/bin:$PATH" STUB_ENV="$1/env.log" STUB_SETUP="$1/setup.log" STUB_CHANGE="$2" node "$DRIVER" --root "$1" 2>&1)"
  CODE=$?
}
setup_runs() { [ -f "$1/setup.log" ] && wc -l < "$1/setup.log" | tr -d ' ' || echo 0; }

echo ""
echo "=== req-002 AC-1: a valid row runs the command and step 2 starts ==="
R="$(make_fixture ac1 "$ROW")"
run_driver "$R" "ravintio-zero/skills/s.md"
assert_equals "0" "$CODE" "req-002 AC-1: driver finishes"
assert_equals "1" "$(setup_runs "$R")" "req-002 AC-1: the command ran once"
assert_equals "claude-code --strict-orchestrator" "$(cat "$R/setup.log")" "req-002 AC-1: the command got its args"
assert_contains "I-D Advance: Setup: step 1 ran the approved setup command" "$OUT" "req-002 AC-1: the ran line"
assert_not_contains "Rerun setup" "$OUT" "req-002 AC-1: no stop line"
assert_equals "2" "$(wc -l < "$R/env.log" | tr -d ' ')" "req-002 AC-1: step 2 started"

echo ""
echo "=== req-002 AC-2: no row stops ==="
R="$(make_fixture norow "")"
run_driver "$R" "ravintio-zero/skills/s.md"
assert_equals "1" "$CODE" "req-002 AC-2: driver exits 1"
assert_equals "0" "$(setup_runs "$R")" "req-002 AC-2: the command did not run"
assert_contains "I-D Advance: Setup: step 1 changed ravintio-zero/skills/s.md. Rerun setup, then start a new driver." "$OUT" "req-002 AC-2: the Setup line"
assert_equals "1" "$(wc -l < "$R/env.log" | tr -d ' ')" "req-002 AC-2: step 2 did not start"

echo ""
echo "=== req-002 AC-2: a different form stops ==="
R="$(make_fixture badrow "$BADROW")"
run_driver "$R" "ravintio-zero/skills/s.md"
assert_equals "1" "$CODE" "req-002 AC-2: driver exits 1"
assert_contains "Rerun setup, then start a new driver." "$OUT" "req-002 AC-2: the Setup line"
assert_equals "0" "$(setup_runs "$R")" "req-002 AC-2: nothing ran"

echo ""
echo "=== req-002 AC-2: a failing command stops ==="
R="$(make_fixture fail "$ROW")"
OUT="$(cd "$R" && PATH="$WORK/bin:$PATH" STUB_ENV="$R/env.log" STUB_SETUP="$R/setup.log" STUB_SETUP_FAIL=1 STUB_CHANGE=ravintio-zero/skills/s.md node "$DRIVER" --root "$R" 2>&1)"
CODE=$?
assert_equals "1" "$CODE" "req-002 AC-2: driver exits 1"
assert_contains "I-D Advance: Setup: step 1 changed ravintio-zero/skills/s.md. The approved setup command failed. Rerun setup, then start a new driver." "$OUT" "req-002 AC-2: the line names the failure"
assert_equals "1" "$(wc -l < "$R/env.log" | tr -d ' ')" "req-002 AC-2: step 2 did not start"

echo ""
echo "=== req-002 AC-3: a restart file still stops ==="
R="$(make_fixture restart "$ROW")"
run_driver "$R" "ravintio-zero/scripts/initiative-run.mjs ravintio-zero/skills/s.md"
assert_equals "75" "$CODE" "req-002 AC-3: driver exits 75"
assert_equals "1" "$(setup_runs "$R")" "req-002 AC-3: the command ran"
assert_contains "I-D Advance: Restart: step 1 changed ravintio-zero/scripts/initiative-run.mjs. Start a new driver so step 2 runs the new code." "$OUT" "req-002 AC-3: the Restart line"
assert_not_contains "Rerun setup" "$OUT" "req-002 AC-3: no setup rerun text"

echo ""
echo "=== req-002: the check after the last step runs the command ==="
R="$(make_fixture last "$ROW" 1)"
run_driver "$R" "ravintio-zero/skills/s.md"
assert_equals "0" "$CODE" "req-002: driver finishes"
assert_equals "1" "$(setup_runs "$R")" "req-002: the command ran once"
assert_contains "I-E Delivery: Pending:" "$OUT" "req-002: the Pending line prints"

echo ""
echo "=== req-002 AC-1: the concurrent path runs the command ==="
SERIAL_WORK="$WORK"
WORK="$(mktemp -d)"
trap 'rm -rf "$SERIAL_WORK" "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"
cr="$(make_repo conc 2 '1||' '2||1')"
cat >> "$cr/plan/current-initiative/initiative.md" <<EOF2

## Decisions

| Step | Fork | Pre-approved answer | Bump effect |
|---|---|---|---|
$ROW
EOF2
mkdir -p "$cr/ravintio-zero"
cat > "$cr/ravintio-zero/setup.sh" <<'EOF2'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_DIR/setup.log"
exit 0
EOF2
git -C "$cr" add -A
git -C "$cr" commit -q -m "chart decisions and setup"
git -C "$cr" push -q origin "$BRANCH_NAME"
QUEUE_SETUP_STEP=1 run_sched "$cr"
S="$(dirname "$cr")/stub"
assert_equals "0" "$CODE" "req-002 AC-1: concurrent driver finishes"
assert_equals "claude-code --strict-orchestrator" "$(cat "$S/setup.log" 2>/dev/null)" "req-002 AC-1: the command ran once with its args"
assert_contains "I-D Advance: Setup: step 1 ran the approved setup command" "$OUT" "req-002 AC-1: the ran line"
assert_contains "I-D Advance: Complete: step 2 merged" "$OUT" "req-002 AC-1: step 2 merged"

echo ""
echo "=== req-002 AC-2: the concurrent path stops with no row ==="
cr="$(make_repo concnorow 2 '1||' '2||1')"
QUEUE_SETUP_STEP=1 run_sched "$cr"
assert_equals "1" "$CODE" "req-002 AC-2: concurrent driver exits 1"
assert_contains "I-D Advance: Setup: step 1 changed ravintio-zero/skills/s.md. Rerun setup, then start a new driver." "$OUT" "req-002 AC-2: the Setup line"

print_summary
