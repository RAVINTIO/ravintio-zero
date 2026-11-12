#!/usr/bin/env bash
# Tests for feature 0000507-hook-check-after-setup, REQ-001 and REQ-002: hook-check.mjs.
#
# REQ-001 AC-1: every hook runs once with CLAUDE_PROJECT_DIR set.
# REQ-001 AC-2: each hook gets the sample for its own event and matcher.
# REQ-001 AC-3: invalid settings.json exits 2 with one stderr line.
# REQ-002 AC-1: exit 2 from a guard passes.
# REQ-002 AC-2: a missing hook script fails and exits 1.
# REQ-002 AC-3: exit 1 from a hook fails.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

CHECK="$SCRIPT_DIR/../scripts/hook-check.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# make_project <name> <settings-json>: a project with hook stubs. Prints the root.
make_project() {
  local root="$WORK/$1"
  mkdir -p "$root/.claude" "$root/hooks"
  printf '%s' "$2" > "$root/.claude/settings.json"
  cat > "$root/hooks/ok.sh" <<'STUB'
#!/usr/bin/env bash
cat > "$CLAUDE_PROJECT_DIR/seen-$1.json"
printf '%s\n' "$CLAUDE_PROJECT_DIR" > "$CLAUDE_PROJECT_DIR/dir-$1.txt"
pwd > "$CLAUDE_PROJECT_DIR/cwd-$1.txt"
exit 0
STUB
  cat > "$root/hooks/block.sh" <<'STUB'
#!/usr/bin/env bash
cat > /dev/null
echo "blocked on purpose" >&2
exit 2
STUB
  cat > "$root/hooks/bad.sh" <<'STUB'
#!/usr/bin/env bash
cat > /dev/null
exit 1
STUB
  printf '%s' "$root"
}

# hook_entry <event> <matcher> <command>
entry() {
  printf '{"matcher":"%s","hooks":[{"type":"command","command":"%s"}]}' "$2" "$3"
}

echo ""
echo "=== REQ-001 AC-1 and AC-2: every hook runs with the env var and its own sample ==="
SET1="{\"hooks\":{\"PreToolUse\":[$(entry x Write 'bash \"${CLAUDE_PROJECT_DIR}/hooks/ok.sh\" write'),$(entry x Bash 'bash \"${CLAUDE_PROJECT_DIR}/hooks/ok.sh\" bash')],\"Stop\":[$(entry x '.*' 'bash \"${CLAUDE_PROJECT_DIR}/hooks/ok.sh\" stop')]}}"
R1="$(make_project p1 "$SET1")"
OUT1="$(node "$CHECK" --root "$R1" 2>&1)"; CODE1=$?
assert_equals "0" "$CODE1" "all hooks pass exits 0"
assert_contains "pass" "$OUT1" "output names a pass"
assert_equals "1" "$([ -f "$R1/seen-write.json" ] && echo 1 || echo 0)" "write hook ran"
assert_equals "1" "$([ -f "$R1/seen-bash.json" ] && echo 1 || echo 0)" "bash hook ran"
assert_equals "1" "$([ -f "$R1/seen-stop.json" ] && echo 1 || echo 0)" "stop hook ran"
assert_equals "$R1" "$(cat "$R1/dir-write.txt")" "env var is the project root"
assert_contains '"tool_name":"Write"' "$(tr -d ' \n' < "$R1/seen-write.json")" "write sample names tool Write"
assert_contains '"tool_name":"Bash"' "$(tr -d ' \n' < "$R1/seen-bash.json")" "bash sample names tool Bash"
assert_contains '"hook_event_name":"Stop"' "$(tr -d ' \n' < "$R1/seen-stop.json")" "stop sample names event Stop"
assert_not_contains "$R1" "$(cat "$R1/cwd-write.txt" | sed "s#^/private##")" "hook does not run in the project root"

echo ""
echo "=== REQ-002 AC-1: exit 2 passes ==="
SET2="{\"hooks\":{\"PreToolUse\":[$(entry x Write 'bash \"${CLAUDE_PROJECT_DIR}/hooks/block.sh\"')]}}"
R2="$(make_project p2 "$SET2")"
OUT2="$(node "$CHECK" --root "$R2" 2>&1)"; CODE2=$?
assert_equals "0" "$CODE2" "a deliberate block exits 0"
assert_contains "pass" "$OUT2" "output reports a pass"

echo ""
echo "=== REQ-002 AC-2: a missing script fails ==="
SET3="{\"hooks\":{\"PreToolUse\":[$(entry x Write 'node \"${CLAUDE_PROJECT_DIR}/hooks/missing.mjs\"')]}}"
R3="$(make_project p3 "$SET3")"
OUT3="$(node "$CHECK" --root "$R3" 2>&1)"; CODE3=$?
assert_equals "1" "$CODE3" "a missing script exits 1"
assert_contains "fail" "$OUT3" "output names the failing hook"
assert_contains "missing.mjs" "$OUT3" "output names the script"

echo ""
echo "=== REQ-002 AC-3: exit 1 fails ==="
SET4="{\"hooks\":{\"Stop\":[$(entry x '.*' 'bash \"${CLAUDE_PROJECT_DIR}/hooks/bad.sh\"')]}}"
R4="$(make_project p4 "$SET4")"
OUT4="$(node "$CHECK" --root "$R4" 2>&1)"; CODE4=$?
assert_equals "1" "$CODE4" "exit 1 from a hook exits 1"
assert_contains "exit 1" "$OUT4" "output reports exit code 1"

echo ""
echo "=== REQ-001: a matcher with no sample fails ==="
SET5="{\"hooks\":{\"PreToolUse\":[$(entry x Unknown 'bash \"${CLAUDE_PROJECT_DIR}/hooks/ok.sh\" u')]}}"
R5="$(make_project p5 "$SET5")"
OUT5="$(node "$CHECK" --root "$R5" 2>&1)"; CODE5=$?
assert_equals "1" "$CODE5" "no sample exits 1"
assert_contains "no sample" "$OUT5" "output says no sample"

echo ""
echo "=== REQ-001 AC-3: invalid settings exits 2 ==="
R6="$(make_project p6 'not json')"
ERR6="$(node "$CHECK" --root "$R6" 2>&1 >/dev/null)"; CODE6=$?
assert_equals "2" "$CODE6" "invalid JSON exits 2"
assert_contains "settings.json" "$ERR6" "stderr names the file"
assert_equals "1" "$(printf '%s\n' "$ERR6" | wc -l | tr -d ' ')" "stderr is one line"

echo ""
echo "=== REQ-001: a missing settings file exits 2 ==="
mkdir -p "$WORK/p7"
node "$CHECK" --root "$WORK/p7" >/dev/null 2>&1; CODE7=$?
assert_equals "2" "$CODE7" "missing file exits 2"

echo ""
echo "=== R-001: the installed hook set passes and the repo stays unchanged ==="
REPO="$(cd "$SCRIPT_DIR/../../.." && pwd)"
if [ -f "$REPO/.claude/settings.json" ] && git -C "$REPO" rev-parse --git-dir >/dev/null 2>&1; then
  BEFORE="$(git -C "$REPO" status --porcelain)"
  node "$CHECK" --root "$REPO" >/dev/null 2>&1; CODE8=$?
  AFTER="$(git -C "$REPO" status --porcelain)"
  assert_equals "0" "$CODE8" "the installed hooks pass"
  assert_equals "$BEFORE" "$AFTER" "the check leaves the repo unchanged"
fi

print_summary
