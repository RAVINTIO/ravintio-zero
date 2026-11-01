#!/usr/bin/env bash
# Tests for feature 0000327-squash-before-main, req-003: the ship skill
# squashes before main, limits force-push, and waits for CI.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"

section() {
  awk -v h="$1" '
    $0 == h { on = 1; lvl = index(h, " "); next }
    on && /^#+ / { if (index($0, " ") <= lvl) exit }
    on { print }' "$2"
}
has() { printf '%s\n' "$2" | grep -qF -- "$1" && echo yes || echo no; }

SEC="$(section '## PRs into main' "$SHIP")"

echo ""
echo "=== req-003 AC-1: force-push limit ==="
assert_equals "yes" "$([ -n "$SEC" ] && echo yes || echo no)" "AC-1: section '## PRs into main' exists"
leases="$(printf '%s\n' "$SEC" | grep -F -- '--force-with-lease')"
bad="$(printf '%s\n' "$leases" | grep -vF 'chore/*')"
assert_equals "yes" "$([ -n "$leases" ] && echo yes || echo no)" "AC-1: --force-with-lease appears"
assert_equals "" "$bad" "AC-1: every --force-with-lease line names chore/*"
assert_equals "yes" "$(has 'replacement PR' "$SEC")" "AC-1: names the replacement PR"
assert_equals "yes" "$(printf '%s\n' "$SEC" | grep -F 'replacement PR' | grep -qF 'hotfix/*' && echo yes || echo no)" "AC-1: replacement PR is for hotfix/*"
nf="$(printf '%s\n' "$SEC" | grep -F 'never force-push')"
for b in 'main' 'initiative/*' 'feat/*' 'hotfix/*'; do
  assert_equals "yes" "$(has "$b" "$nf")" "AC-1: never force-push names $b"
done

echo ""
echo "=== req-003 AC-2: squash and wait ==="
assert_equals "yes" "$(has 'one commit on `origin/main`' "$SEC")" "AC-2: one commit on origin/main"
assert_equals "yes" "$(has 'commit-standards.md' "$SEC")" "AC-2: title follows commit-standards.md"
assert_equals "yes" "$(has 'PR number' "$SEC")" "AC-2: title names the PR number"
assert_equals "yes" "$(has 'squashed' "$SEC")" "AC-2: body lists the squashed titles"
assert_equals "yes" "$(has 'green CI' "$SEC")" "AC-2: waits for green CI"
assert_equals "yes" "$(has 'before you ask' "$SEC")" "AC-2: CI wait comes before the merge request"
HL="$(grep -E '^5\. ' "$SHIP")"
assert_equals "yes" "$(has '## PRs into main' "$HL")" "AC-2: Hard Limit 5 points to the section"

echo ""
echo "=== req-003 AC-3: size ==="
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "AC-3: skill text $TOTAL <= 1720"

print_summary
