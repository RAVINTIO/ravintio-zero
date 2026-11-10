#!/usr/bin/env bash
# Test: 0000399 req-007 coordinator start-up
# AC-1: a non-step session with a charted draft gets the initiative skill from both hooks.
# AC-2: a non-step session with an active initiative gets the initiative skill from both hooks.
# AC-3: a step session keeps the orchestrator, as does a draft with another status.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# HOOKS_DIR lets a check run the same suite against an older copy of the hooks.
HOOKS_DIR="${HOOKS_DIR:-$ZERO_DIR/hooks/enforcement}"
AUTO_TRIGGER="$HOOKS_DIR/auto-trigger-orchestrator.mjs"
PRESENCE="$HOOKS_DIR/check-orchestrator-presence.mjs"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

new_ws() {
  local ws
  ws="$(mktemp -d "$TMP_ROOT/ws.XXXXXX")"
  mkdir -p "$ws/ravintio-zero" "$ws/plan/current"
  echo "$ws"
}

make_draft() {
  mkdir -p "$1/plan/roadmap/0000500-demo"
  printf -- '---\ntitle: "x"\nstatus: "%s"\n---\n# I\n' "$2" > "$1/plan/roadmap/0000500-demo/initiative.md"
}

make_active() {
  mkdir -p "$1/plan/current-initiative"
  printf -- '---\ntitle: "x"\nstatus: "active"\n---\n# I\n' > "$1/plan/current-initiative/initiative.md"
}

# run_hook <hook> <workspace> [ENV=value ...] -> prints stdout
run_hook() {
  local hook="$1" ws="$2"
  shift 2
  rm -f "$ws/plan/.orchestrator-loaded"
  printf '{"cwd":"%s","session_id":"sess-1"}' "$ws" | env -u RAVINTIO_INITIATIVE_STEP "$@" node "$hook" 2>/dev/null
}

# Presence acts only while a pipeline is active, so give it a sentinel and strict mode.
presence_ws() {
  echo "feat-1" > "$1/plan/.orchestrator-active"
  touch "$1/plan/.orchestrator-strict"
}

echo ""
echo "=== AC-1: charted draft ==="
ws="$(new_ws)"; make_draft "$ws" charted
out="$(run_hook "$AUTO_TRIGGER" "$ws")"
assert_contains "Load the ravintio-initiative skill now" "$out" "AC-1: auto-trigger names the initiative skill"
assert_equals "0" "$(printf '%s' "$out" | grep -c 'ravintio-orchestrator skill')" "AC-1: auto-trigger does not name the orchestrator"
ws="$(new_ws)"; make_draft "$ws" charted; presence_ws "$ws"
out="$(run_hook "$PRESENCE" "$ws")"
assert_contains "Load the ravintio-initiative skill now" "$out" "AC-1: presence names the initiative skill"

echo "=== AC-2: active initiative ==="
ws="$(new_ws)"; make_active "$ws"
out="$(run_hook "$AUTO_TRIGGER" "$ws")"
assert_contains "Load the ravintio-initiative skill now" "$out" "AC-2: auto-trigger names the initiative skill"
ws="$(new_ws)"; make_active "$ws"; presence_ws "$ws"
out="$(run_hook "$PRESENCE" "$ws")"
assert_contains "Load the ravintio-initiative skill now" "$out" "AC-2: presence names the initiative skill"

echo "=== AC-3: step session and other draft statuses ==="
ws="$(new_ws)"; make_draft "$ws" charted
out="$(run_hook "$AUTO_TRIGGER" "$ws" RAVINTIO_INITIATIVE_STEP=1)"
assert_contains "Load the ravintio-orchestrator skill now" "$out" "AC-3: step session gets the orchestrator from auto-trigger"
assert_equals "0" "$(printf '%s' "$out" | grep -c 'ravintio-initiative skill')" "AC-3: step session does not get the initiative skill from auto-trigger"
ws="$(new_ws)"; make_draft "$ws" charted; presence_ws "$ws"
out="$(run_hook "$PRESENCE" "$ws" RAVINTIO_INITIATIVE_STEP=1)"
assert_contains "Load the ravintio-orchestrator skill now" "$out" "AC-3: step session gets the orchestrator from presence"
assert_equals "0" "$(printf '%s' "$out" | grep -c 'ravintio-initiative skill')" "AC-3: step session does not get the initiative skill from presence"
ws="$(new_ws)"; make_draft "$ws" proposed
out="$(run_hook "$AUTO_TRIGGER" "$ws")"
assert_contains "Load the ravintio-orchestrator skill now" "$out" "AC-3: a proposed draft keeps the orchestrator in auto-trigger"
ws="$(new_ws)"; make_draft "$ws" proposed; presence_ws "$ws"
out="$(run_hook "$PRESENCE" "$ws")"
assert_contains "Load the ravintio-orchestrator skill now" "$out" "AC-3: a proposed draft keeps the orchestrator in presence"

print_summary
