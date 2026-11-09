#!/usr/bin/env bash
# Tests for feature 0000389-writing-standard, req-001 and req-002: the writing
# standard exists with two regions, follows itself, and agrees with
# formatting-standards.md and the em dash guard.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STD="$ZERO_DIR/standards/writing-standards.md"
FMT="$ZERO_DIR/standards/formatting-standards.md"
GUARD="$ZERO_DIR/hooks/enforcement/em-dash-guard.mjs"

echo ""
echo "=== req-001 AC-1: both regions hold text ==="
TEXT="$(cat "$STD")"
for r in style-rules summary; do
  body="$(node -e '
    const t=require("fs").readFileSync(process.argv[1],"utf8");
    const a=t.indexOf("<!-- BEGIN "+process.argv[2]+" -->"), b=t.indexOf("<!-- END "+process.argv[2]+" -->");
    process.stdout.write(a>=0&&b>a?t.slice(a,b).trim():"");' "$STD" "$r")"
  assert_contains "BEGIN $r" "$body" "req-001 AC-1: $r region is present"
  assert_equals "yes" "$([ ${#body} -gt 200 ] && echo yes || echo no)" "req-001 AC-1: $r region holds text"
done

echo ""
echo "=== req-001 AC-2: the standard follows itself ==="
EM="$(printf '\xe2\x80\x94')"
assert_not_contains "$EM" "$TEXT" "req-001 AC-2: no em dash"
SEMI="$(sed '/^```/,/^```/d' "$STD" | sed 's/`[^`]*`//g; s/"[^"]*"//g' | grep -c ';' || true)"
assert_equals "0" "$SEMI" "req-001 AC-2: no semicolon outside code spans and quotes"

echo ""
echo "=== req-002 AC-1: dates agree ==="
FMT_TEXT="$(cat "$FMT")"
assert_contains "2026-08-18" "$TEXT" "req-002 AC-1: writing standard names the ISO form"
assert_contains "August 18, 2026" "$TEXT" "req-002 AC-1: writing standard names the long form"
assert_contains "2026-08-18" "$FMT_TEXT" "req-002 AC-1: formatting standard names the ISO form"
assert_contains "August 18, 2026" "$FMT_TEXT" "req-002 AC-1: formatting standard names the long form"
assert_not_contains "use **DD MMM YYYY**" "$FMT_TEXT" "req-002 AC-1: formatting standard no longer requires DD MMM YYYY"
assert_contains "writing-standards.md" "$FMT_TEXT" "req-002 AC-1: formatting standard points to the writing standard"

echo ""
echo "=== req-002 AC-2: no semicolon suggestion ==="
GUARD_TEXT="$(cat "$GUARD")"
assert_not_contains "comma, colon, semicolon" "$GUARD_TEXT" "req-002 AC-2: guard message offers no semicolon"
assert_not_contains "colon, semicolon" "$FMT_TEXT" "req-002 AC-2: formatting standard offers no semicolon"

print_summary
