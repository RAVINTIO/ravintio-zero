#!/usr/bin/env bash
# Tests for feature 0000313-driver-setup-stop, req-001: the driver stops for a setup rerun
# after a merged step that changed installed pack files.
#
# AC-1: a skill change stops the driver with a Setup line, releases the lock, starts no step 2.
# AC-2: a test-only change gives no stop.
# AC-3: a driver change plus a hooks change gives one Restart: Setup: line naming both.

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

# make_fixture <name>: a git work tree on branch initiative/0000050-demo. Prints the root.
make_fixture() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current"
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
  local f
  for f in ravintio-zero/scripts/initiative-run.mjs ravintio-zero/skills/ravintio-ship/SKILL.md ravintio-zero/hooks/x.sh ravintio-zero/setup.sh ravintio-zero/setup/a.sh ravintio-zero/tests/t.sh \
    ravintio-zero/skills/s1.md ravintio-zero/skills/s2.md ravintio-zero/skills/s3.md ravintio-zero/skills/s4.md ravintio-zero/skills/s5.md ravintio-zero/skills/s6.md ravintio-zero/skills/s7.md; do
    mkdir -p "$d/$(dirname "$f")"
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
echo "=== req-001 AC-1: a skill change stops the driver ==="
R="$(make_fixture ac1)"
run_driver "$R" "ravintio-zero/skills/ravintio-ship/SKILL.md"
assert_equals "1" "$CODE" "req-001 AC-1: driver exits 1"
assert_contains "I-D Advance: Setup: step 1 changed ravintio-zero/skills/ravintio-ship/SKILL.md. Rerun setup, then start a new driver." "$OUT" "req-001 AC-1: the Setup line names the file"
assert_not_contains "Restart:" "$OUT" "req-001 AC-1: no Restart label"
assert_equals "1" "$(wc -l < "$R/env.log" | tr -d ' ')" "req-001 AC-1: step 2 did not start"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "req-001 AC-1: the lock is released"

echo ""
echo "=== req-001: each setup path triggers a stop ==="
for p in ravintio-zero/hooks/x.sh ravintio-zero/setup.sh ravintio-zero/setup/a.sh; do
  R="$(make_fixture "path-$(printf '%s' "$p" | tr '/.' '__')")"
  run_driver "$R" "$p"
  assert_equals "1" "$CODE" "req-001: $p exits 1"
  assert_contains "I-D Advance: Setup: step 1 changed $p. Rerun setup" "$OUT" "req-001: $p gives a Setup line"
done

echo ""
echo "=== req-001 AC-2: a test-only change gives no stop ==="
R="$(make_fixture ac2)"
run_driver "$R" "ravintio-zero/tests/t.sh"
assert_equals "0" "$CODE" "req-001 AC-2: driver finishes"
assert_not_contains "Setup:" "$OUT" "req-001 AC-2: no Setup line"
assert_equals "2" "$(wc -l < "$R/env.log" | tr -d ' ')" "req-001 AC-2: both steps ran"

echo ""
echo "=== req-001 AC-3: both stops give one line ==="
R="$(make_fixture ac3)"
run_driver "$R" "ravintio-zero/scripts/initiative-run.mjs ravintio-zero/hooks/x.sh"
assert_equals "1" "$CODE" "req-001 AC-3: driver exits 1"
assert_contains "I-D Advance: Restart: Setup: step 1 changed ravintio-zero/scripts/initiative-run.mjs, ravintio-zero/hooks/x.sh. Rerun setup, then start a new driver so step 2 runs the new code." "$OUT" "req-001 AC-3: one line names both files"
assert_equals "1" "$(printf '%s\n' "$OUT" | grep -c 'I-D Advance: Restart: Setup:')" "req-001 AC-3: exactly one such line"

echo ""
echo "=== req-001: the skill file in both lists is named once ==="
R="$(make_fixture dup2)"
run_driver "$R" "ravintio-zero/scripts/initiative-run.mjs ravintio-zero/skills/ravintio-ship/SKILL.md"
assert_contains "I-D Advance: Restart: Setup: step 1 changed ravintio-zero/scripts/initiative-run.mjs, ravintio-zero/skills/ravintio-ship/SKILL.md. Rerun" "$OUT" "req-001: restart files first, then setup files"

echo ""
echo "=== req-001: the list caps at 5 names ==="
R="$(make_fixture cap)"
run_driver "$R" "ravintio-zero/skills/s1.md ravintio-zero/skills/s2.md ravintio-zero/skills/s3.md ravintio-zero/skills/s4.md ravintio-zero/skills/s5.md ravintio-zero/skills/s6.md ravintio-zero/skills/s7.md"
assert_contains "ravintio-zero/skills/s5.md and 2 more." "$OUT" "req-001: 5 names then and 2 more"
assert_not_contains "s6.md" "$OUT" "req-001: the sixth name is cut"

echo ""
echo "=== req-001: outside a git work tree the check is skipped ==="
R="$(make_fixture nogit)"
rm -rf "$R/.git"
run_driver "$R" "ravintio-zero/skills/ravintio-ship/SKILL.md"
assert_equals "0" "$CODE" "req-001: the driver finishes with no git"
assert_not_contains "Setup:" "$OUT" "req-001: no Setup line with no git"

print_summary
