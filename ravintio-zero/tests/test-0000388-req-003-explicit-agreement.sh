#!/usr/bin/env bash
# Test: 0000388 req-003 explicit-agreement
# The recommend-then-confirm rule treats "Ok" as ambiguous, asks for "Yes, I agree",
# asks for one permission per question, and asks again when a reply names none.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

echo "=== AC-1: agreement wording ==="
assert_rule agree-ambiguous "Ok" "ambiguous" "Yes, I agree"
assert_rule agree-name-option "more than one" "name the option" "Yes, I agree to option 2"
assert_rule agree-explicit "Yes, I agree" "approve" "exact option label"

echo "=== AC-2: one permission per question ==="
assert_rule agree-one-permission "one permission" "each question"
assert_rule agree-numbered "number each" "name the numbers"
assert_rule agree-ask-again "no numbered permission" "ask again" "Never assume"

echo "=== Pointers ==="
for s in initiative plan validate-and-accept ship implement; do
  f="$_ASSERT_PACK_ROOT/skills/ravintio-$s/SKILL.md"
  if grep -q "agree-explicit" "$f"; then _pass_line "ravintio-$s points to the rule"; ((PASS++)) || true
  else _fail_line "ravintio-$s lacks a pointer"; ((FAIL++)) || true; fi
done

print_summary
