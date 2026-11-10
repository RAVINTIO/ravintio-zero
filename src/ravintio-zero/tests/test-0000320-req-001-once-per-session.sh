#!/usr/bin/env bash
# Tests for feature 0000320 REQ-001: the load instruction fires once per session.
# AC-1: the first prompt gets the instruction and the hook records the session id.
# AC-2: a second prompt in the same session gets nothing.
# AC-3: a new session gets the instruction again.
# Also: no session_id keeps today's behaviour, the exclude line is added once,
# the advisory banner follows the same rule, and strict mode is unchanged.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
AUTO_TRIGGER="$ZERO_DIR/hooks/enforcement/auto-trigger-orchestrator.mjs"
PRESENCE="$ZERO_DIR/hooks/enforcement/check-orchestrator-presence.mjs"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

new_ws() {
  local ws
  ws="$(mktemp -d "$TMP_ROOT/ws.XXXXXX")"
  mkdir -p "$ws/ravintio-zero" "$ws/plan/current" "$ws/.git/info"
  echo "$ws"
}

# run_hook <hook> <workspace> <session id or "-" for none> -> prints stdout, sets RC file
run_hook() {
  local hook="$1" ws="$2" sid="$3" payload out
  if [ "$sid" = "-" ]; then
    payload="$(printf '{"cwd":"%s"}' "$ws")"
  else
    payload="$(printf '{"cwd":"%s","session_id":"%s"}' "$ws" "$sid")"
  fi
  out="$(printf '%s' "$payload" | env -u RAVINTIO_INITIATIVE_STEP node "$hook" 2>/dev/null)"
  echo $? > "$TMP_ROOT/rc"
  printf '%s' "$out"
}

RECORD="plan/.orchestrator-loaded"

echo ""
echo "=== AC-1: first prompt gets the instruction ==="
ws="$(new_ws)"
out="$(run_hook "$AUTO_TRIGGER" "$ws" A)"
assert_contains "Load the ravintio-orchestrator skill now" "$out" "AC-1: instruction emitted"
assert_equals "A" "$(cat "$ws/$RECORD" 2>/dev/null | tr -d '\n')" "AC-1: session A recorded"
assert_equals "0" "$(cat "$TMP_ROOT/rc")" "AC-1: exit 0"

echo "=== AC-2: second prompt gets none ==="
out="$(run_hook "$AUTO_TRIGGER" "$ws" A)"
assert_equals "" "$out" "AC-2: same session is silent"
assert_equals "A" "$(cat "$ws/$RECORD" | tr -d '\n')" "AC-2: record unchanged"
assert_equals "0" "$(cat "$TMP_ROOT/rc")" "AC-2: exit 0"

echo "=== AC-3: new session gets the instruction again ==="
out="$(run_hook "$AUTO_TRIGGER" "$ws" B)"
assert_contains "Load the ravintio-orchestrator skill now" "$out" "AC-3: instruction emitted for B"
assert_equals "B" "$(cat "$ws/$RECORD" | tr -d '\n')" "AC-3: session B recorded"

echo "=== Initiative instruction follows the same rule ==="
ws="$(new_ws)"
mkdir -p "$ws/plan/current-initiative"
printf -- '---\nstatus: active\n---\n# I\n' > "$ws/plan/current-initiative/initiative.md"
out="$(run_hook "$AUTO_TRIGGER" "$ws" A)"
assert_contains "ravintio-initiative" "$out" "initiative: first prompt emits"
assert_equals "A" "$(cat "$ws/$RECORD" 2>/dev/null | tr -d '\n')" "initiative: session recorded"
out="$(run_hook "$AUTO_TRIGGER" "$ws" A)"
assert_equals "" "$out" "initiative: second prompt silent"

echo "=== No session_id keeps today's behaviour ==="
ws="$(new_ws)"
out="$(run_hook "$AUTO_TRIGGER" "$ws" -)"
assert_contains "Load the ravintio-orchestrator skill now" "$out" "no id: first prompt emits"
out="$(run_hook "$AUTO_TRIGGER" "$ws" -)"
assert_contains "Load the ravintio-orchestrator skill now" "$out" "no id: second prompt emits"
assert_equals "no" "$([ -e "$ws/$RECORD" ] && echo yes || echo no)" "no id: no record written"
assert_equals "0" "$(cat "$TMP_ROOT/rc")" "no id: exit 0"

echo "=== The exclude line is added once ==="
ws="$(new_ws)"
printf 'existing\n' > "$ws/.git/info/exclude"
run_hook "$AUTO_TRIGGER" "$ws" A >/dev/null
run_hook "$AUTO_TRIGGER" "$ws" B >/dev/null
run_hook "$AUTO_TRIGGER" "$ws" C >/dev/null
assert_equals "1" "$(grep -cFx "$RECORD" "$ws/.git/info/exclude")" "exclude: line present once"
assert_contains "existing" "$(cat "$ws/.git/info/exclude")" "exclude: existing lines kept"

echo "=== Advisory banner follows the same rule ==="
ws="$(new_ws)"
echo "feat-1" > "$ws/plan/.orchestrator-active"
out="$(run_hook "$PRESENCE" "$ws" A)"
assert_contains "RAVINTIO PIPELINE ACTIVE" "$out" "advisory: first prompt emits"
assert_equals "A" "$(cat "$ws/$RECORD" 2>/dev/null | tr -d '\n')" "advisory: session recorded"
out="$(run_hook "$PRESENCE" "$ws" A)"
assert_equals "" "$out" "advisory: second prompt silent"
out="$(run_hook "$PRESENCE" "$ws" B)"
assert_contains "RAVINTIO PIPELINE ACTIVE" "$out" "advisory: new session emits"
out="$(run_hook "$PRESENCE" "$ws" -)"
assert_contains "RAVINTIO PIPELINE ACTIVE" "$out" "advisory: no id emits"
out="$(run_hook "$PRESENCE" "$ws" -)"
assert_contains "RAVINTIO PIPELINE ACTIVE" "$out" "advisory: no id emits every time"
assert_equals "0" "$(cat "$TMP_ROOT/rc")" "advisory: exit 0"

echo "=== Strict mode keeps its ack rule ==="
ws="$(new_ws)"
echo "feat-1" > "$ws/plan/.orchestrator-active"
touch "$ws/plan/.orchestrator-strict"
echo "A" > "$ws/$RECORD"
out="$(run_hook "$PRESENCE" "$ws" A)"
assert_contains "STRICT MODE" "$out" "strict: record does not silence the banner"
out="$(run_hook "$PRESENCE" "$ws" A)"
assert_contains "STRICT MODE" "$out" "strict: banner repeats until acked"
echo "A" > "$ws/plan/.orchestrator-ack"
out="$(run_hook "$PRESENCE" "$ws" A)"
assert_equals "" "$out" "strict: ack silences"
assert_equals "0" "$(cat "$TMP_ROOT/rc")" "strict: exit 0"

print_summary
