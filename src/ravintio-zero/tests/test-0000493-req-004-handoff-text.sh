#!/usr/bin/env bash
# Tests for feature 0000493-driver-starts-after-restart, req-004 (handoff text in the standards and skill).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

PACK="$SCRIPT_DIR/.."
REPO="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
STANDARDS="$PACK/standards/roadmap-standards.md"
SKILL="$PACK/skills/ravintio-initiative/SKILL.md"

# AC-1: the standards name the handoff.
TEXT="$(cat "$STANDARDS")"
assert_contains "handoff" "$TEXT" "REQ-004 AC-1: the standards name the handoff"
assert_contains "--handoff {pid}" "$TEXT" "REQ-004 AC-1: the standards name the --handoff flag"
assert_contains "A new driver took over new starts." "$TEXT" "REQ-004 AC-1: the standards give the handoff line"
assert_contains "\`stopped\`" "$TEXT" "REQ-004 AC-1: the standards name the stopped file"
CTRL="$(grep -F 'plan/.initiative-control/step-{n}/` |' "$STANDARDS")"
assert_contains "stopped" "$CTRL" "REQ-004 AC-1: the control folder row lists stopped"

# AC-2: the skill Restart paragraph names the handoff and the watcher-only rule.
PARA="$(grep -F 'A `Restart:` line is not a failure' "$SKILL")"
assert_contains "A new driver took over new starts." "$PARA" "REQ-004 AC-2: the skill names the handoff line"
assert_contains "watcher only" "$PARA" "REQ-004 AC-2: the skill starts a watcher only on the handoff line"
LINES="$(wc -l < "$SKILL" | tr -d ' ')"
if [ "$LINES" -lt 120 ]; then
  assert_equals "ok" "ok" "REQ-004 AC-2: the skill stays under 120 lines"
else
  assert_equals "under 120" "$LINES" "REQ-004 AC-2: the skill stays under 120 lines"
fi

# AC-3: the two trees hold identical copies.
for rel in standards/roadmap-standards.md skills/ravintio-initiative/SKILL.md; do
  if cmp -s "$REPO/src/ravintio-zero/$rel" "$REPO/ravintio-zero/$rel"; then
    assert_equals "same" "same" "REQ-004 AC-3: $rel matches in both trees"
  else
    assert_equals "same" "different" "REQ-004 AC-3: $rel matches in both trees"
  fi
done

print_summary
