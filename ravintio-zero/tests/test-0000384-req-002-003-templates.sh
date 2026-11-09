#!/usr/bin/env bash
# Tests for feature 0000384-plan-checks, req-002 and req-003 (template parts):
# the design template holds Component Paths, the dispatch template states the
# 72-character subject limit, and the ADR template carries the new fields.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TEMPLATE="$ROOT/templates/design.template.md"
GATE="$ROOT/hooks/enforcement/gate-write.mjs"
STD="$ROOT/standards/agent-dispatch-standards.md"
ADR="$ROOT/templates/adr.template.md"

echo ""
echo "=== req-002 AC-1: Component Paths sits above Scope ==="
PATHS_LINE=$(grep -n '^## Component Paths$' "$TEMPLATE" | head -1 | cut -d: -f1)
SCOPE_LINE=$(grep -n '^## Scope$' "$TEMPLATE" | head -1 | cut -d: -f1)
if [ -n "$PATHS_LINE" ] && [ -n "$SCOPE_LINE" ] && [ "$PATHS_LINE" -lt "$SCOPE_LINE" ]; then
  assert_equals "ok" "ok" "req-002 AC-1: Component Paths before Scope"
else
  assert_equals "before" "paths=${PATHS_LINE:-none} scope=${SCOPE_LINE:-none}" "req-002 AC-1: Component Paths before Scope"
fi

echo ""
echo "=== req-002 AC-2: a listed path passes the gate ==="
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/plan/current"
touch "$TMP/plan/.orchestrator-active"
sed 's#^- {folder the plan writes}/#- ravintio-zero/tests/#' "$TEMPLATE" > "$TMP/plan/current/design.md"

run_gate() {
  printf '{"cwd":"%s","tool_input":{"file_path":"%s"}}' "$TMP" "$1" | node "$GATE" >/dev/null 2>&1
  echo $?
}
assert_equals "0" "$(run_gate ravintio-zero/tests/x.sh)" "req-002 AC-2: listed path exits 0"
assert_equals "2" "$(run_gate elsewhere/y.sh)" "req-002 AC-2: unlisted path exits 2"

echo ""
echo "=== req-003 AC-1: the dispatch template states the limit ==="
DISPATCH=$(awk '/^## Agent Dispatch Template/{f=1;next} /^## /{f=0} f' "$STD")
assert_contains "72" "$DISPATCH" "req-003 AC-1: 72-character limit in the dispatch template"

echo ""
echo "=== req-005: the ADR template carries the new fields ==="
ADR_TEXT=$(cat "$ADR")
assert_contains "component:" "$ADR_TEXT" "req-005: component front matter field"
assert_contains "docs/adr/{NNNN}-{slug}.md" "$ADR_TEXT" "req-005: file location"
assert_contains "reserve-id.mjs --file docs/adr/.next-id" "$ADR_TEXT" "req-005: reserve command"
assert_contains "Superseded by {number}" "$ADR_TEXT" "req-005: superseded wording"

print_summary
