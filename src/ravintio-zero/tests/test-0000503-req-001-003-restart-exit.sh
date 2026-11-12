#!/usr/bin/env bash
# Tests for feature 0000503-planned-restart-exit-code, REQ-001 to REQ-003: the driver exits 75 after
# a Restart: stop line, keeps exit 1 for a failure, and the docs name the code.
#
# AC-1: the serial driver exits 75 after a Restart: line, and after a Restart: Setup: line.
# AC-2: the concurrent driver exits 75 after a Restart: line.
# AC-3: a bare Setup: stop, a Blocked: stop, and a failure after a restart hit exit 1.
# AC-4: a run with no stop exits 0.
# AC-5: the standards, the skill, the driver header, and the ADR name the code.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

# Serial stub. STUB_CHANGE lists the paths that step 1 changes before it merges.
mkdir -p "$WORK/serial-bin"
cat > "$WORK/serial-bin/claude" <<'STUB'
#!/usr/bin/env bash
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
chmod +x "$WORK/serial-bin/claude"

# make_serial <name>: a git work tree with a two-step chart and the watched and setup files.
make_serial() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current" "$d/ravintio-zero/scripts" "$d/ravintio-zero/skills/ravintio-initiative" "$d/ravintio-zero/skills/ravintio-ship"
  cat > "$d/plan/current-initiative/initiative.md" <<'EOF2'
---
title: "Initiative: demo"
summary: "Two steps."
status: active
---
# Initiative: demo

goal: demo
branch: initiative/0000050-demo
status: active
position: 1

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | 0000051-a | 0000011 | minor | | pending |
| 2 | 0000052-b | 0000012 | minor | | pending |
EOF2
  : > "$d/plan/current/build-log.md"
  for f in ravintio-zero/scripts/initiative-run.mjs ravintio-zero/scripts/initiative-watch.mjs ravintio-zero/skills/ravintio-initiative/SKILL.md ravintio-zero/skills/ravintio-ship/SKILL.md; do
    printf 'original\n' > "$d/$f"
  done
  git -C "$d" init -q -b initiative/0000050-demo
  git -C "$d" config user.email t@example.com
  git -C "$d" config user.name t
  printf 'env.log\n' > "$d/.gitignore"
  git -C "$d" add -A
  git -C "$d" commit -qm init
  printf '%s' "$d"
}

# run_serial <root> <changed paths>: sets OUT and CODE.
run_serial() {
  OUT="$(cd "$1" && PATH="$WORK/serial-bin:$PATH" STUB_ENV="$1/env.log" STUB_CHANGE="$2" node "$DRIVER" --root "$1" 2>&1)"
  CODE=$?
}

echo ""
echo "=== REQ-001 AC-1: the serial driver exits 75 after a Restart line ==="
R="$(make_serial restart)"
run_serial "$R" "ravintio-zero/scripts/initiative-run.mjs"
assert_equals "75" "$CODE" "REQ-001 AC-1: driver exits 75"
assert_contains "I-D Advance: Restart: step 1 changed ravintio-zero/scripts/initiative-run.mjs." "$OUT" "REQ-001 AC-1: the line keeps its text"

echo ""
echo "=== REQ-001 AC-3: the serial combined line exits 75 ==="
R="$(make_serial combined)"
run_serial "$R" "ravintio-zero/scripts/initiative-run.mjs ravintio-zero/skills/ravintio-ship/SKILL.md"
assert_equals "75" "$CODE" "REQ-001 AC-3: driver exits 75"
assert_contains "I-D Advance: Restart: Setup: step 1 changed" "$OUT" "REQ-001 AC-3: prints the combined line"

echo ""
echo "=== REQ-002 AC-1: the serial bare Setup line exits 1 ==="
R="$(make_serial setup)"
run_serial "$R" "ravintio-zero/skills/ravintio-ship/SKILL.md"
assert_equals "1" "$CODE" "REQ-002 AC-1: driver exits 1"
assert_contains "I-D Advance: Setup: step 1 changed" "$OUT" "REQ-002 AC-1: prints the Setup line"
assert_not_contains "Restart:" "$OUT" "REQ-002 AC-1: no Restart line"

echo ""
echo "=== REQ-002 AC-4: a run with no stop exits 0 ==="
R="$(make_serial clean)"
run_serial "$R" ""
assert_equals "0" "$CODE" "REQ-002 AC-4: driver exits 0"

echo ""
echo "=== REQ-001 AC-2: the concurrent driver exits 75 after a Restart line ==="
R="$(make_repo noff 2 '1||' '2||1')"
mkdir -p "$R/ravintio-zero/scripts"
printf '// local\n' > "$R/ravintio-zero/scripts/initiative-run.mjs"
QUEUE_RESTART_STEP=1 run_sched "$R"
assert_equals "75" "$CODE" "REQ-001 AC-2: driver exits 75"
assert_contains "I-D Advance: Restart: step 1 changed ravintio-zero/scripts/initiative-run.mjs. Start a new driver so the next step runs the new code." "$OUT" "REQ-001 AC-2: prints the Restart stop"

echo ""
echo "=== REQ-001 AC-3: the concurrent combined line exits 75 ==="
R="$(make_repo both 2 '1||' '2||1')"
QUEUE_RESTART_STEP=1 QUEUE_SETUP_STEP=1 run_sched "$R"
assert_equals "75" "$CODE" "REQ-001 AC-3: driver exits 75"
assert_contains "I-D Advance: Restart: Setup: step 1 changed" "$OUT" "REQ-001 AC-3: prints the combined stop"

echo ""
echo "=== REQ-002 AC-1: the concurrent bare Setup line exits 1 ==="
R="$(make_repo cset 2 '1||' '2||1')"
QUEUE_SETUP_STEP=1 run_sched "$R"
assert_equals "1" "$CODE" "REQ-002 AC-1: driver exits 1"
assert_contains "I-D Advance: Setup: step 1 changed" "$OUT" "REQ-002 AC-1: prints the Setup stop"

echo ""
echo "=== REQ-002 AC-2: a blocked step exits 1 ==="
R="$(make_repo blocked 2 '1||' '2||1')"
STUB_MODE_1=block run_sched "$R"
assert_equals "1" "$CODE" "REQ-002 AC-2: driver exits 1"
assert_contains "Blocked: step 1 cannot go on" "$OUT" "REQ-002 AC-2: prints the block"

echo ""
echo "=== REQ-002 AC-3: a failure after a restart hit exits 1 ==="
R="$(make_repo late 2 '1||' '2||')"
mkdir -p "$R/ravintio-zero/scripts"
printf '// local\n' > "$R/ravintio-zero/scripts/initiative-run.mjs"
QUEUE_RESTART_STEP=1 STUB_MODE_2=blockstop run_sched "$R"
assert_equals "1" "$CODE" "REQ-002 AC-3: driver exits 1"
assert_contains "I-D Advance: Restart: step 1 changed" "$OUT" "REQ-002 AC-3: the restart line printed first"

echo ""
echo "=== REQ-002 AC-4: the concurrent driver exits 0 when every step merges ==="
R="$(make_repo done 2 '1||' '2||1')"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-002 AC-4: driver exits 0"

echo ""
echo "=== REQ-003 AC-1 to AC-3: the docs name the code ==="
PACK="$SCRIPT_DIR/.."
STD="$PACK/standards/roadmap-standards.md"
SKILL="$PACK/skills/ravintio-initiative/SKILL.md"
REPO="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
RESTART_SECTION="$(awk '/^#### Restart stop/{f=1;next} /^#### /{f=0} f' "$STD")"
assert_contains "exits 75" "$RESTART_SECTION" "REQ-003 AC-1: the standards name exit 75 in the Restart stop section"
STOPS="$(awk '/^## Stops/{f=1;next} /^## /{f=0} f' "$SKILL")"
assert_contains "75" "$STOPS" "REQ-003 AC-2: the skill names exit 75 in Stops"
assert_contains "exits 75" "$(sed -n '1,160p' "$DRIVER")" "REQ-003 AC-2: the driver header names exit 75"
ADR="$(ls "$REPO"/docs/adr/*planned-restart-exits-75.md 2>/dev/null | head -1)"
if [ -n "$ADR" ]; then
  assert_contains "0000503-planned-restart-exit-code" "$(cat "$ADR")" "REQ-003 AC-3: the ADR names the feature"
else
  assert_equals "an ADR" "none" "REQ-003 AC-3: the ADR exists"
fi

print_summary
