#!/usr/bin/env bash
# Tests for feature 0000493-driver-starts-after-restart, req-004 (handoff text in the standards and skill).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

PACK="$SCRIPT_DIR/.."
REPO="$(repo_root)"
STANDARDS="$PACK/standards/roadmap-standards.md"
SKILL="$PACK/skills/ravintio-initiative/SKILL.md"

# AC-1: the standards name the handoff.
assert_rule rm-handoff-bullets "handoff" "--handoff {pid}" "A new driver took over new starts." "\`stopped\`"
assert_rule rm-driver-paths-table "plan/.initiative-control/step-{n}/" "stopped"

# AC-2: the skill Restart paragraph names the handoff and the watcher-only rule.
assert_rule rm-ini-restart-stop "A \`Restart:\` line is not a failure" "A new driver took over new starts." "watcher only"
LINES="$(wc -l < "$SKILL" | tr -d ' ')"
if [ "$LINES" -lt 120 ]; then
  assert_equals "ok" "ok" "REQ-004 AC-2: the skill stays under 120 lines"
else
  assert_equals "under 120" "$LINES" "REQ-004 AC-2: the skill stays under 120 lines"
fi

# AC-3: the two trees hold identical copies.
for rel in standards/roadmap-standards.md skills/ravintio-initiative/SKILL.md; do
  # Rework 0000401: anchors are comments, so drop anchor-only lines, then the inline anchors, before the compare.
  if cmp -s <(sed -E '/^[[:space:]]*<!-- rule: [a-z0-9-]+ -->[[:space:]]*$/d' "$REPO/src/ravintio-zero/$rel" | strip_rule_anchors) <(sed -E '/^[[:space:]]*<!-- rule: [a-z0-9-]+ -->[[:space:]]*$/d' "$REPO/ravintio-zero/$rel" | strip_rule_anchors); then
    assert_equals "same" "same" "REQ-004 AC-3: $rel matches in both trees"
  else
    assert_equals "same" "different" "REQ-004 AC-3: $rel matches in both trees"
  fi
done

print_summary
