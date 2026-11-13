#!/usr/bin/env bash
# Test: 0000386 req-002 unit-class-tier-effort
# The dispatch standards hold one table from unit class and score to tier and effort.
# The Done line records them, and resume-detect.mjs still pairs Done with In progress.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STD="$ZERO_DIR/standards/agent-dispatch-standards.md"
RESUME="$ZERO_DIR/scripts/resume-detect.mjs"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

echo "=== AC-1: classes, signals, and the table ==="
assert_rule dispatch-unit-classes "content" "code" "test" "config"
assert_rule dispatch-unit-signals "three or more files" "hook or standard" "Rework:" "open question" "one point"

table="$(awk '/^### Tier and effort table/{on=1; next} on && /^#{1,3} /{exit} on && /^\|/{print}' "$STD")"
expected="content|cheaper, low|cheaper, medium|primary, high|primary, high
config|cheaper, low|cheaper, medium|primary, high|primary, high
test|cheaper, medium|cheaper, high|primary, high|primary, high
code|primary, medium|primary, high|primary, high|primary, high"
valid=0
for cls in content config test code; do
  row="$(printf '%s\n' "$table" | awk -F'|' -v c="$cls" '{g=$2; gsub(/^ +| +$/,"",g); if (g==c) {out=g; for(i=3;i<=6;i++){v=$i; gsub(/^ +| +$/,"",v); out=out "|" v}; print out}}')"
  want="$(printf '%s\n' "$expected" | grep "^$cls|")"
  assert_equals "$want" "$row" "table row for class $cls holds the agreed values"
  cells="$(printf '%s\n' "$row" | tr '|' '\n' | tail -n +2)"
  while IFS= read -r cell; do
    case "$cell" in
      "cheaper, low"|"cheaper, medium"|"cheaper, high"|"primary, low"|"primary, medium"|"primary, high") valid=$((valid + 1)) ;;
    esac
  done <<< "$cells"
done
assert_equals "16" "$valid" "16 of 16 class and score pairs hold a valid tier and effort"

echo "=== AC-1: tier replaces recommended_model ==="
assert_rule dispatch-unit-tier-replaces "replaces" "recommended_model" "model" "effort" "Claude Code" "primary tier" "two cheaper-tier failures"

echo "=== AC-2: the Done line carries the fields ==="
assert_rule dispatch-done-line '- Done: {unit} ({class}, {tier}, {effort}, {ISO-8601 timestamp})' "inline" "none"
assert_contains '{class}, {tier}, {effort}' "$(cat "$ZERO_DIR/templates/build-log.template.md")" "the build-log template shows the class, tier, and effort"

echo "=== AC-3: resume detection still pairs Done with In progress ==="
mk_ws() {
  local ws
  ws="$(mktemp -d "$TMP_ROOT/ws.XXXXXX")"
  mkdir -p "$ws/ravintio-zero/migrations/_done" "$ws/docs" "$ws/plan/current"
  printf '%s\n' "$@" > "$ws/plan/current/build-log.md"
  echo "$ws"
}
run() { env -u RAVINTIO_INITIATIVE_STEP node "$RESUME" "$1" 2>/dev/null; }
ws="$(mk_ws '- In progress: REQ-001 implementer (2026-11-09T10:00:00Z)' '- Done: REQ-001 implementer (code, primary, high, 2026-11-09T10:05:00Z)')"
assert_not_contains "unit in progress" "$(run "$ws")" "a classified Done line closes its In progress line"
ws="$(mk_ws '- In progress: REQ-002 inline (2026-11-09T10:00:00Z)')"
assert_contains "unit in progress: REQ-002 inline" "$(run "$ws")" "an open inline unit reads as a readable name"

print_summary
