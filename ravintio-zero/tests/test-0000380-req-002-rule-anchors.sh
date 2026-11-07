#!/usr/bin/env bash
# Test: 0000380 req-002 rule-anchors
# A rule carries <!-- rule: {id} --> and tests read it through rule_text and
# assert_rule. A move or a reword that keeps the key terms breaks nothing.
# Deleting an anchor fails the test and names the anchor.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

FAKE="$(mktemp -d "${TMPDIR:-/tmp}/rule380.XXXXXX")"
mkdir -p "$FAKE/skills/s" "$FAKE/standards" "$FAKE/templates"
export RULE_PACK_ROOT="$FAKE"

echo "=== AC-1: an anchor survives a move ==="
printf '# S\n\n<!-- rule: demo-a -->\nNever commit to main. This holds in every run mode.\n\nOther text.\n' > "$FAKE/skills/s/SKILL.md"
assert_rule demo-a "Never commit" "main"
printf '# Std\n\n<!-- rule: demo-a -->\nNever commit to main. This holds in every run mode.\n\nOther text.\n' > "$FAKE/standards/moved.md"
printf '# S\n\nOther text.\n' > "$FAKE/skills/s/SKILL.md"
assert_rule demo-a "Never commit" "main"

echo "=== AC-2: a reword that keeps the key terms passes ==="
printf '# Std\n\n<!-- rule: demo-a -->\nThe agent must never commit to main, in any run mode.\n\nOther text.\n' > "$FAKE/standards/moved.md"
assert_rule demo-a "never commit" "main"

echo "=== the text is the item after the anchor ==="
printf '# Std\n\n1. <!-- rule: item-1 --> **First.** Do the first thing.\n   - sub bullet one\n2. <!-- rule: item-2 --> **Second.** Do the second thing.\n\nTail after a blank line.\n' > "$FAKE/standards/moved.md"
t1="$(rule_text item-1)"
assert_contains "sub bullet one" "$t1" "an anchored list item keeps its sub bullets"
assert_not_contains "Second" "$t1" "the next anchor ends the item"
t2="$(rule_text item-2)"
assert_not_contains "Tail after" "$t2" "a blank line ends the item"

echo "=== AC-3: a missing anchor fails and names the anchor ==="
out="$(rule_text no-such-rule)"; rc=$?
assert_equals "1" "$rc" "rule_text exits 1 for a missing anchor"
assert_contains "RULE ANCHOR NOT FOUND: no-such-rule" "$out" "the marker names the anchor"
# Run assert_rule in a child so its FAIL line does not count against this suite.
child="$(bash -c 'source "$1"; export RULE_PACK_ROOT="$2"; assert_rule no-such-rule term; echo "FAIL=$FAIL"' _ "$SCRIPT_DIR/helpers/assert.sh" "$FAKE" 2>&1)"
assert_contains "no-such-rule" "$child" "the failure line names the anchor"
assert_contains "FAIL=1" "$child" "assert_rule counts one failure"
child="$(bash -c 'source "$1"; export RULE_PACK_ROOT="$2"; assert_rule item-1 absent-term; echo "FAIL=$FAIL"' _ "$SCRIPT_DIR/helpers/assert.sh" "$FAKE" 2>&1)"
assert_contains "FAIL=1" "$child" "a missing key term fails"
assert_contains "absent-term" "$child" "the failure line names the missing term"

echo "=== a duplicate anchor id fails ==="
printf '<!-- rule: item-1 -->\ndup\n' > "$FAKE/templates/dup.md"
out="$(rule_text item-1)"; rc=$?
assert_equals "2" "$rc" "rule_text exits 2 for a duplicate"
assert_contains "DUPLICATE RULE ANCHOR: item-1" "$out" "the marker names the id"
rm -rf "$FAKE"
unset RULE_PACK_ROOT

echo "=== the pack's anchors are unique and well formed ==="
PFX='^[[:space:]]*(([-*]|[0-9]+[.)])[[:space:]]+)?'
lines="$(grep -rhE --include='*.md' "${PFX}<!-- *rule:" "$ZERO_DIR/skills" "$ZERO_DIR/standards" "$ZERO_DIR/templates" 2>/dev/null)"
ids="$(printf '%s\n' "$lines" | grep -oE '<!-- rule: [^ ]+ -->' | sed -E 's/<!-- rule: ([^ ]+) -->/\1/')"
assert_equals "yes" "$([ -n "$ids" ] && echo yes || echo no)" "the pack holds at least one anchor"
bad="$(printf '%s\n' "$ids" | grep -vE '^[a-z0-9]+(-[a-z0-9]+)*$' || true)"
assert_equals "" "$bad" "every anchor id uses lowercase letters, digits, and hyphens"
dups="$(printf '%s\n' "$ids" | sort | uniq -d)"
assert_equals "" "$dups" "no anchor id appears twice"
loose="$(printf '%s\n' "$lines" | grep -vE "${PFX}<!-- rule: [a-z0-9]+(-[a-z0-9]+)* -->" || true)"
assert_equals "" "$loose" "no anchor line is malformed"
nonempty=0
for id in $ids; do
  txt="$(rule_text "$id")" || { _fail_line "anchor $id: $txt"; FAIL=$((FAIL + 1)); continue; }
  [ -n "$txt" ] && nonempty=$((nonempty + 1))
done
assert_equals "$(printf '%s\n' "$ids" | grep -c .)" "$nonempty" "every anchor is followed by rule text"

print_summary
