#!/usr/bin/env bash
# Tests for feature 0000534-step-sessions-receive-clock.
#
# req-001: the driver starts every step session with --include-hook-events.
# req-002: step-clock-check.mjs fails a step log with tool calls and no clock output.
# req-003: the standards and the ADR state the flag, the check, and the proof.
#
# A stub claude on PATH records its arguments. No test starts a real claude session.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
CHECK="$SCRIPT_DIR/../scripts/step-clock-check.mjs"
STANDARDS="$SCRIPT_DIR/../standards/roadmap-standards.md"
REPO="$SCRIPT_DIR/../../.."
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo ""
echo "=== req-001: the driver passes --include-hook-events ==="
mkdir -p "$WORK/bin" "$WORK/r/plan/current-initiative" "$WORK/r/plan/current"
cat > "$WORK/bin/claude" <<'STUB'
#!/usr/bin/env bash
# Stub claude. A first call ends its turn early. A call with --resume finishes the initiative.
printf '%s\n' "$*" >> "$STUB_LOG"
case " $* " in
  *" --resume "*)
    mkdir -p plan/_archive
    mv plan/current-initiative "plan/_archive/0000050-demo-initiative-2026-10-23"
    ;;
  *) printf '{"type":"system","subtype":"init","session_id":"sess-abc12345"}\n' ;;
esac
STUB
chmod +x "$WORK/bin/claude"
cat > "$WORK/r/plan/current-initiative/initiative.md" <<'EOF2'
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
: > "$WORK/r/plan/current/build-log.md"
(cd "$WORK/r" && PATH="$WORK/bin:$PATH" STUB_LOG="$WORK/r/stub.log" node "$DRIVER" --root "$WORK/r" >/dev/null 2>&1)
FIRST="$(sed -n 1p "$WORK/r/stub.log")"
SECOND="$(sed -n 2p "$WORK/r/stub.log")"
assert_contains "--verbose --include-hook-events --permission-mode auto" "$FIRST" "req-001 AC-1: a first run carries the flag"
assert_contains "--resume sess-abc12345" "$SECOND" "req-001 AC-2: the second call is a resume"
assert_contains "--verbose --include-hook-events --permission-mode auto" "$SECOND" "req-001 AC-2: a resumed run carries the flag"

echo ""
echo "=== req-002: step-clock-check.mjs ==="
CLOCK='{"type":"system","subtype":"hook_response","hook_name":"PostToolUse:Bash","hook_event":"PostToolUse","output":"{\"hookSpecificOutput\":{\"additionalContext\":\"Local time: 20:12\"}}\n","exit_code":0}'
TOOL='{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Bash","input":{"command":"date"}}]}}'
TEXT='{"type":"assistant","message":{"content":[{"type":"text","text":"SECRET-MARKER-5512"}]}}'
SESSION_START='{"type":"system","subtype":"hook_response","hook_event":"SessionStart","output":"Local time: 20:12","exit_code":0}'

printf '%s\n%s\n' "$TOOL" "$CLOCK" > "$WORK/pass.log"
OUT="$(node "$CHECK" "$WORK/pass.log" 2>&1)"; CODE=$?
assert_equals "0" "$CODE" "req-002 AC-1: a log with clock output exits 0"

printf '%s\n%s\n' "$TOOL" "$TOOL" > "$WORK/fail.log"
OUT="$(node "$CHECK" "$WORK/fail.log" 2>&1)"; CODE=$?
assert_equals "1" "$CODE" "req-002 AC-2: a log with no clock output exits 1"
assert_contains "no clock output" "$OUT" "req-002 AC-2: the line says no clock output"
assert_contains "2 tool calls" "$OUT" "req-002 AC-2: the line counts the tool calls"

printf '%s\n%s\n' "$TOOL" "$SESSION_START" > "$WORK/start.log"
node "$CHECK" "$WORK/start.log" >/dev/null 2>&1; CODE=$?
assert_equals "1" "$CODE" "req-002 AC-2: a SessionStart response does not count as clock output"

printf '%s\n' "$TEXT" > "$WORK/none.log"
OUT="$(node "$CHECK" "$WORK/none.log" 2>&1)"; CODE=$?
assert_equals "0" "$CODE" "req-002 AC-3: a log with no tool calls exits 0"
assert_contains "nothing to check" "$OUT" "req-002 AC-3: the line says nothing to check"
assert_not_contains "SECRET-MARKER-5512" "$OUT" "req-002 NFR-001: the check prints no log text"

printf 'not json\n%s\n%s\n' "$TOOL" "$CLOCK" > "$WORK/junk.log"
node "$CHECK" "$WORK/junk.log" >/dev/null 2>&1; CODE=$?
assert_equals "0" "$CODE" "req-002: a line that is not JSON is skipped"

node "$CHECK" "$WORK/missing.log" >/dev/null 2>&1; CODE=$?
assert_equals "2" "$CODE" "req-002: a missing log exits 2"
node "$CHECK" >/dev/null 2>&1; CODE=$?
assert_equals "2" "$CODE" "req-002: no argument exits 2"

BEFORE="$(ls "$WORK" | wc -l | tr -d ' ')"
node "$CHECK" "$WORK/pass.log" >/dev/null 2>&1
AFTER="$(ls "$WORK" | wc -l | tr -d ' ')"
assert_equals "$BEFORE" "$AFTER" "req-002 NFR-001: the check writes no file"

echo ""
echo "=== req-003: the docs state the flag and the check ==="
assert_contains "--include-hook-events" "$(cat "$STANDARDS")" "req-003 AC-1: roadmap-standards names the flag"
assert_contains "step-clock-check.mjs" "$(cat "$STANDARDS")" "req-003 AC-1: roadmap-standards names the check"
assert_contains "--include-hook-events" "$(sed -n 1,120p "$DRIVER")" "req-003 AC-1: the driver header names the flag"
assert_contains "0342" "$(cat "$REPO/docs/decisions-index.md")" "req-003 AC-2: the index lists ADR-0342"

print_summary
