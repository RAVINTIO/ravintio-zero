#!/usr/bin/env bash
# Tests for feature 0000555-initiative-pause-reaches-every-step, req-003: resume detection reads the
# initiative pause record first, and the standards and the skill state the pause rules.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SCRIPT="$ZERO_DIR/scripts/resume-detect.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

ws="$WORK/ws"
mkdir -p "$ws/plan/current-initiative" "$ws/plan/current" "$ws/ravintio-zero"
printf '**Status:** active\n**Position:** 3\n' > "$ws/plan/current-initiative/initiative.md"
touch "$ws/plan/current/pause.md"

echo ""
echo "=== req-003 AC-1: the finding ==="
OUT="$(env -u RAVINTIO_INITIATIVE_STEP node "$SCRIPT" "$ws" 2>/dev/null)"
assert_not_contains "initiative pause record present" "$OUT" "AC-1: no finding without the file"
printf 'x\n' > "$ws/plan/current-initiative/pause.md"
OUT="$(env -u RAVINTIO_INITIATIVE_STEP node "$SCRIPT" "$ws" 2>/dev/null)"
assert_contains "initiative pause record present" "$OUT" "AC-1: the finding prints"
INIT_LINE="$(printf '%s\n' "$OUT" | grep -nxF 'initiative pause record present' | cut -d: -f1)"
STEP_LINE="$(printf '%s\n' "$OUT" | grep -nxF 'pause record present' | cut -d: -f1)"
assert_equals "yes" "$([ -n "$INIT_LINE" ] && [ -n "$STEP_LINE" ] && [ "$INIT_LINE" -lt "$STEP_LINE" ] && echo yes || echo no)" "AC-1: it comes before the step pause record"

echo ""
echo "=== req-003 AC-2: the rules ==="
STD="$(cat "$ZERO_DIR/standards/roadmap-standards.md")"
SKILL="$(cat "$ZERO_DIR/skills/ravintio-initiative/SKILL.md")"
REF="$(cat "$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-resume-detection.md")"
assert_contains "rule: icpause-request" "$STD" "AC-2: the standards hold rule icpause-request"
assert_contains "rule: icpause-records" "$STD" "AC-2: the standards hold rule icpause-records"
assert_contains "rule: icpause-resume" "$STD" "AC-2: the standards hold rule icpause-resume"
assert_contains "initiative-pause.mjs request" "$STD" "AC-2: the standards name the request command"
assert_contains "initiative-pause.mjs request" "$SKILL" "AC-2: the skill names the request command"
assert_contains "plan/current-initiative/pause.md" "$SKILL" "AC-2: the skill names the initiative record"
assert_contains "initiative pause record present" "$REF" "AC-2: the reference maps the finding"
assert_equals "yes" "$([ "$(wc -l < "$ZERO_DIR/skills/ravintio-initiative/SKILL.md" | tr -d ' ')" -lt 120 ] && echo yes || echo no)" "AC-2: the skill stays under 120 lines"

print_summary
