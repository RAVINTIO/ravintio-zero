#!/usr/bin/env bash
# Tests for feature 0000250-initiative-mid-run-changes, req-002: the driver stops for a
# restart after a merged step that changed the driver, the watcher, or the initiative skill.
#
# AC-1: a driver change stops the driver, names the file, and starts no further step.
# AC-2: a watcher or skill change stops the driver and names the file.
# AC-3: a step that changes none of the three files gives no restart.

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

# make_fixture <name>: a git work tree on branch initiative/0000050-demo with the three
# watched files and one other file committed. Prints the root.
make_fixture() {
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

# run_driver <root> <changed paths>: sets OUT and CODE.
run_driver() {
  OUT="$(cd "$1" && PATH="$WORK/bin:$PATH" STUB_ENV="$1/env.log" STUB_CHANGE="$2" node "$DRIVER" --root "$1" 2>&1)"
  CODE=$?
}

echo ""
echo "=== req-002 AC-1: a driver change stops the driver ==="
R="$(make_fixture ac1)"
run_driver "$R" "ravintio-zero/scripts/initiative-run.mjs"
assert_equals "1" "$CODE" "req-002 AC-1: driver exits 1"
assert_contains "I-D Advance: Restart: step 1 changed ravintio-zero/scripts/initiative-run.mjs." "$OUT" "req-002 AC-1: the line names the file"
assert_contains "Start a new driver so step 2 runs the new code." "$OUT" "req-002 AC-1: the line names the next step"
assert_contains "Log: plan/.initiative-logs/step-1.log" "$OUT" "req-002 AC-1: the line ends with the log path"
assert_equals "1" "$(wc -l < "$R/env.log" | tr -d ' ')" "req-002 AC-1: step 2 did not start"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "req-002 AC-1: the lock is released"

echo ""
echo "=== req-002 AC-1: a new driver runs the next step ==="
run_driver "$R" ""
assert_equals "0" "$CODE" "req-002 AC-1: the restarted driver finishes"
assert_equals "2" "$(wc -l < "$R/env.log" | tr -d ' ')" "req-002 AC-1: step 2 ran under the new driver"

echo ""
echo "=== req-002 AC-2: a watcher or skill change stops the driver ==="
R="$(make_fixture ac2-watch)"
run_driver "$R" "ravintio-zero/scripts/initiative-watch.mjs"
assert_equals "1" "$CODE" "req-002 AC-2: driver exits 1 for a watcher change"
assert_contains "changed ravintio-zero/scripts/initiative-watch.mjs." "$OUT" "req-002 AC-2: the line names the watcher"
R="$(make_fixture ac2-skill)"
run_driver "$R" "ravintio-zero/skills/ravintio-initiative/SKILL.md"
assert_equals "1" "$CODE" "req-002 AC-2: driver exits 1 for a skill change"
assert_contains "changed ravintio-zero/skills/ravintio-initiative/SKILL.md." "$OUT" "req-002 AC-2: the line names the skill"
R="$(make_fixture ac2-two)"
run_driver "$R" "ravintio-zero/scripts/initiative-run.mjs ravintio-zero/skills/ravintio-initiative/SKILL.md"
assert_contains "changed ravintio-zero/scripts/initiative-run.mjs, ravintio-zero/skills/ravintio-initiative/SKILL.md." "$OUT" "req-002 AC-2: the line lists both files"

echo ""
echo "=== req-002 AC-3: no change gives no restart ==="
R="$(make_fixture ac3)"
mkdir -p "$R/ravintio-zero/tests"
printf 'original\n' > "$R/ravintio-zero/tests/t.sh"
git -C "$R" add -A
git -C "$R" commit -qm "add test file"
run_driver "$R" "ravintio-zero/tests/t.sh"
assert_equals "0" "$CODE" "req-002 AC-3: driver finishes"
assert_not_contains "Restart:" "$OUT" "req-002 AC-3: no restart line"
assert_equals "2" "$(wc -l < "$R/env.log" | tr -d ' ')" "req-002 AC-3: both steps ran"
R="$(make_fixture ac3-none)"
run_driver "$R" ""
assert_not_contains "Restart:" "$OUT" "req-002 AC-3: a step with no file change gives no restart"

echo ""
echo "=== req-002: a final step gives no restart ==="
R="$(make_fixture final)"
sed -i.bak -E 's/^(position: *).*/\12/' "$R/plan/current-initiative/initiative.md" && rm -f "$R/plan/current-initiative/initiative.md.bak"
git -C "$R" commit -qam "position 2"
run_driver "$R" "ravintio-zero/scripts/initiative-run.mjs"
assert_equals "0" "$CODE" "req-002: delivery exits 0"
assert_not_contains "Restart:" "$OUT" "req-002: a delivered initiative never restarts"

echo ""
echo "=== req-002: outside a git work tree the check is skipped ==="
R="$(make_fixture nogit)"
rm -rf "$R/.git"
run_driver "$R" "ravintio-zero/scripts/initiative-run.mjs"
assert_equals "0" "$CODE" "req-002: the driver finishes with no git"
assert_not_contains "Restart:" "$OUT" "req-002: no restart line with no git"

print_summary
