#!/usr/bin/env bash
# 0000170 req-002: gherkin-criteria
# The requirement template and plan skill write each acceptance criterion as a
# checkbox line with Given, When, and Then steps.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TPL="$ZERO_DIR/templates/requirement.template.md"
SKILL="$ZERO_DIR/skills/ravintio-plan/SKILL.md"

echo ""
echo "=== 0000170 req-002 gherkin-criteria ==="

check() {
  if [ "$2" = "0" ]; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi
}

# AC-1: template criteria use AC-{n} with Given, When, Then bullets
assert_rule piv-template-ac-lines '- [ ] AC-{n}:' '  - Given ' '  - When ' '  - Then '

# AC-2: skill requirements rules state the format and the limit
assert_rule piv-plan-ac-format 'AC-{n}' 'And' 'But' 'checkbox lines' 'not steps'

# AC-3: required headings stay and the 0000010 structure test passes
ok=1
grep -qxF '## Functional Requirements' "$TPL" && grep -qxF '## Acceptance Criteria' "$TPL" && ok=0
for t in "$SCRIPT_DIR"/test-0000010-*.sh; do
  [ -f "$t" ] || continue
  (cd "$ZERO_DIR/.." && bash "$t" >/dev/null 2>&1) || ok=1
done
check "req-002 AC-3: headings stay and 0000010 tests pass" "$ok"

print_summary
