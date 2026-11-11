#!/usr/bin/env bash
# Tests for feature 0000495-driver-clears-dead-lock, REQ-001 to REQ-003: the driver takes a lock
# whose process no longer runs, and keeps refusing every lock it cannot prove dead.
#
# A stub claude on PATH stands in for the model. It finishes the one-step initiative.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
STANDARDS="$SCRIPT_DIR/../standards/roadmap-standards.md"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/bin"
cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_LOG"
printf 'I-C Run: step 1 done\n' >> plan/current/build-log.md
mkdir -p plan/_archive
mv plan/current-initiative "plan/_archive/0000050-demo-initiative-2026-10-23"
STUB
chmod +x "$WORK/bin/claude"

# make_fixture <name>: prints the fixture root of a one-step active initiative.
make_fixture() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current"
  cat > "$d/plan/current-initiative/initiative.md" <<EOF2
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

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | 0000051-a | 0000011 | minor | | pending |
EOF2
  : > "$d/plan/current/build-log.md"
  printf '%s' "$d"
}

# run_driver <root>: sets OUT and CODE.
run_driver() {
  OUT="$(cd "$1" && PATH="$WORK/bin:$PATH" STUB_LOG="$1/stub.log" node "$DRIVER" --root "$1" 2>&1)"
  CODE=$?
}

yes_no() { [ -e "$1" ] && echo yes || echo no; }

# dead_pid: prints the pid of a process that has exited.
dead_pid() {
  bash -c 'echo $$'
}

echo ""
echo "=== REQ-001 AC-1, AC-2: a dead pid in the lock is taken ==="
R="$(make_fixture dead)"
DEAD="$(dead_pid)"
printf '%s\n' "$DEAD" > "$R/plan/.initiative-runner.lock"
run_driver "$R"
assert_equals "0" "$CODE" "REQ-001 AC-1: the driver runs to delivery"
assert_contains "lock named process $DEAD, which no longer runs" "$OUT" "REQ-001 AC-1: prints a line that names the pid"
assert_equals "1" "$(wc -l < "$R/stub.log" | tr -d ' ')" "REQ-001 AC-1: the step ran"
assert_equals "no" "$(yes_no "$R/plan/.initiative-runner.lock")" "REQ-001 AC-2: the lock is gone at exit"

echo ""
echo "=== REQ-002 AC-1: a running pid in the lock is refused ==="
R="$(make_fixture live)"
printf '%s\n' "$$" > "$R/plan/.initiative-runner.lock"
run_driver "$R"
[ "$CODE" -ne 0 ] && r=yes || r=no
assert_equals "yes" "$r" "REQ-002 AC-1: non-zero exit"
assert_contains "another driver may be running" "$OUT" "REQ-002 AC-1: prints the existing refusal"
assert_equals "no" "$(yes_no "$R/stub.log")" "REQ-002 AC-1: no step ran"
assert_equals "$$" "$(cat "$R/plan/.initiative-runner.lock")" "REQ-002 AC-1: the lock is unchanged"

echo ""
echo "=== REQ-002 AC-2: text that is not a pid is refused ==="
for body in "other-driver" "12abc" "0" "" "123 456"; do
  R="$(make_fixture "text-$(printf '%s' "$body" | tr -c 'A-Za-z0-9' '_')-x")"
  printf '%s\n' "$body" > "$R/plan/.initiative-runner.lock"
  run_driver "$R"
  [ "$CODE" -ne 0 ] && r=yes || r=no
  assert_equals "yes" "$r" "REQ-002 AC-2: non-zero exit for '$body'"
  assert_contains "another driver may be running" "$OUT" "REQ-002 AC-2: existing refusal for '$body'"
  assert_equals "no" "$(yes_no "$R/stub.log")" "REQ-002 AC-2: no step ran for '$body'"
  assert_equals "$body" "$(cat "$R/plan/.initiative-runner.lock")" "REQ-002 AC-2: the lock is unchanged for '$body'"
done

echo ""
echo "=== REQ-002 AC-2: a symlink lock is refused ==="
R="$(make_fixture link)"
DEAD="$(dead_pid)"
printf '%s\n' "$DEAD" > "$R/target.txt"
ln -s "$R/target.txt" "$R/plan/.initiative-runner.lock"
run_driver "$R"
[ "$CODE" -ne 0 ] && r=yes || r=no
assert_equals "yes" "$r" "REQ-002 AC-2: non-zero exit for a symlink"
assert_contains "another driver may be running" "$OUT" "REQ-002 AC-2: existing refusal for a symlink"
assert_equals "no" "$(yes_no "$R/stub.log")" "REQ-002 AC-2: no step ran for a symlink"
assert_equals "yes" "$([ -L "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "REQ-002 AC-2: the symlink remains"

echo ""
echo "=== REQ-003 AC-1: the driver header and the standards state the rule ==="
assert_contains "no longer runs" "$(sed -n 1,60p "$DRIVER")" "REQ-003 AC-1: the driver header states the rule"
assert_contains "no longer runs" "$(cat "$STANDARDS")" "REQ-003 AC-1: roadmap-standards.md states the rule"

print_summary
