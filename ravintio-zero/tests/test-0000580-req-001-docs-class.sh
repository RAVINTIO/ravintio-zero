#!/usr/bin/env bash
# Test: 0000580 req-001 docs-class
# The dispatch standards name class docs, its tier row, and its marker rule.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STD="$ZERO_DIR/standards/agent-dispatch-standards.md"
TEMPLATE="$ZERO_DIR/templates/build-log.template.md"

echo "=== AC-1: the class list names docs ==="
assert_rule dispatch-unit-classes "docs" "five classes" "no executable check"

echo "=== AC-1: the tier table holds a docs row that matches content ==="
table="$(awk '/^### Tier and effort table/{on=1; next} on && /^#{1,3} /{exit} on && /^\|/{print}' "$STD")"
row() { printf '%s\n' "$table" | awk -F'|' -v c="$1" '{g=$2; gsub(/^ +| +$/,"",g); if (g==c) {out=g; for(i=3;i<=6;i++){v=$i; gsub(/^ +| +$/,"",v); out=out "|" v}; print out}}'; }
docs_row="$(row docs | cut -d'|' -f2-)"
content_row="$(row content | cut -d'|' -f2-)"
assert_equals "$content_row" "$docs_row" "AC-1: the docs row matches the content row"
assert_contains "cheaper, low" "$docs_row" "AC-1: the docs row exists"

echo "=== AC-2: the marker rule ==="
assert_rule dispatch-docs-markers "docs" "RED:" "GREEN:" "build-log-mark.mjs" "--class" "0000410"

echo "=== The build log template shows the class on a marker ==="
assert_contains "RED: {unit} ({class}," "$(cat "$TEMPLATE")" "template shows a RED line with a class"

print_summary
