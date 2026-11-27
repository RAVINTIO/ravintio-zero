#!/usr/bin/env bash
# Tests for feature 0000579-convert-remaining-suites-to-rule-anchors, req-002:
# the ledger of converted suites and the reword probe.
#
# AC-1: each ledger line names a suite that exists, and each converted suite
#       reads its rule through assert_rule, rule_text, or orch_section.
# AC-2: a copy of the pack with a filler word in every anchored rule still
#       passes a sample of the converted suites.
# AC-3: a ledger entry for a suite that pins a whole sentence fails the guard.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
source "$SCRIPT_DIR/helpers/timeout.sh"

LEDGER="$SCRIPT_DIR/helpers/anchor-conversions.txt"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/anchor-guard.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

# ledger_problems <ledger> <suite folder> prints one line per problem.
ledger_problems() {
  local ledger="$1" dir="$2" line kind file reason
  while IFS= read -r line; do
    case "$line" in
      ''|'#'*) continue ;;
    esac
    kind="${line%%: *}"
    file="${line#*: }"
    case "$kind" in
      converted)
        if [ ! -f "$dir/$file" ]; then
          echo "missing suite: $file"
        elif ! grep -qE 'assert_rule|rule_text|orch_section' "$dir/$file"; then
          echo "no rule helper: $file"
        fi
        ;;
      structure)
        reason="${file#*: }"
        file="${file%%: *}"
        if [ "$reason" = "$file" ] || [ -z "$reason" ]; then
          echo "no reason: $file"
        elif [ ! -f "$dir/$file" ]; then
          echo "missing suite: $file"
        fi
        ;;
      *) echo "bad line: $line" ;;
    esac
  done < "$1"
}

echo ""
echo "=== AC-1: the ledger lists suites that exist and read rules through a helper ==="
assert_equals "yes" "$([ -s "$LEDGER" ] && echo yes || echo no)" "REQ-002 AC-1: the ledger exists and holds lines"
PROBLEMS="$(ledger_problems "$LEDGER" "$SCRIPT_DIR")"
assert_equals "" "$PROBLEMS" "REQ-002 AC-1: every ledger line names a suite that exists and uses a helper"
DUPES="$(grep -vE '^(#|$)' "$LEDGER" | sed -E 's/^[a-z]+: ([^ :]+).*/\1/' | sort | uniq -d)"
assert_equals "" "$DUPES" "REQ-002 AC-1: no suite appears twice in the ledger"

echo ""
echo "=== AC-3: a suite that pins a whole sentence fails the guard ==="
mkdir -p "$WORK/fake"
printf '#!/usr/bin/env bash\nassert_contains "A whole sentence." "$TEXT" "pin"\n' > "$WORK/fake/test-fake-pin.sh"
printf 'converted: test-fake-pin.sh\nstructure: test-fake-pin.sh\nconverted: test-gone.sh\n' > "$WORK/fake-ledger.txt"
FAKE="$(ledger_problems "$WORK/fake-ledger.txt" "$WORK/fake")"
assert_contains "no rule helper: test-fake-pin.sh" "$FAKE" "REQ-002 AC-3: a pin with no helper is named"
assert_contains "no reason: test-fake-pin.sh" "$FAKE" "REQ-002 AC-3: a structure line with no reason is named"
assert_contains "missing suite: test-gone.sh" "$FAKE" "REQ-002 AC-3: a missing suite is named"

echo ""
echo "=== AC-2: a reworded copy of the pack passes a sample of converted suites ==="
TREE="$(cd "$SCRIPT_DIR/.." && pwd)"
REL="ravintio-zero"
case "$TREE" in */src/ravintio-zero) REL="src/ravintio-zero" ;; esac
COPY="$WORK/copy/$REL"
mkdir -p "$WORK/copy/$(dirname "$REL")"
cp -R "$TREE" "$COPY"
cp "$(repo_root "$SCRIPT_DIR")/product.yml" "$WORK/copy/product.yml"
mkdir -p "$WORK/control/$(dirname "$REL")"
cp -R "$TREE" "$WORK/control/$REL"
cp "$WORK/copy/product.yml" "$WORK/control/product.yml"

# reword <file> inserts the word "indeed" before each sentence-ending full stop in
# every anchored rule. The rule runs from its anchor line to a blank line, a
# heading, or the next anchor. A key term that stays inside a sentence survives.
reword() {
  perl -ne '
    if (/^\s*(([-*]|\d+[.)])\s+)?<!-- rule: [a-z0-9-]+ -->/) { $in = 1 }
    elsif (/^\s*$/ || /^#/) { $in = 0 }
    s/(?<=[A-Za-z`\)])\.(?=\s|$)/ indeed./g if $in;
    print;
  ' "$1" > "$1.reworded" && mv "$1.reworded" "$1"
}
for f in "$COPY"/skills/*/SKILL.md "$COPY"/skills/*/references/*.md "$COPY"/standards/*.md "$COPY"/templates/*.md; do
  [ -f "$f" ] && reword "$f"
done
CHANGED="$(diff -rq "$TREE/skills" "$COPY/skills" 2>/dev/null | wc -l | tr -d ' ')"
assert_equals "yes" "$([ "$CHANGED" -gt 0 ] && echo yes || echo no)" "REQ-002 AC-2: the probe rewords at least one skill file"

SAMPLE="$(grep -E '^converted: ' "$LEDGER" | sed -E 's/^converted: //' | awk 'NR % 12 == 1' | head -12)"
PASSED=0; RAN=0
for s in $SAMPLE; do
  [ "$s" = "$(basename "$0")" ] && continue
  with_timeout 300 bash "$WORK/control/$REL/tests/$s" >/dev/null 2>&1
  [ $? -eq 0 ] || continue
  RAN=$((RAN + 1))
  with_timeout 300 bash "$COPY/tests/$s" > "$WORK/out.txt" 2>&1
  if [ $? -eq 0 ]; then
    PASSED=$((PASSED + 1))
  else
    echo "  reworded copy fails: $s"
    grep -E 'FAIL|lacks' "$WORK/out.txt" | head -5
  fi
done
assert_equals "yes" "$([ "$RAN" -ge 3 ] && echo yes || echo no)" "REQ-002 AC-2: at least three sampled suites pass in the unchanged copy ($RAN)"
assert_equals "$RAN" "$PASSED" "REQ-002 AC-2: every sampled suite that passes unchanged also passes reworded"

print_summary
