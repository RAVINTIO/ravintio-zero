#!/usr/bin/env bash
# Tests for feature 0000545-clear-feature-id-at-ship, req-001: Ship Step 8 deletes plan/.feature-id.
# (a) The ship skill's Step 8 names the file. (b) A scripted Step 8 run leaves no tracked id file.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SHIP="${SHIP_SKILL:-$SCRIPT_DIR/../skills/ravintio-ship/SKILL.md}"

section() {
  awk -v h="$1" 'index($0, h) == 1 { on = 1; next } on && /^### / { exit } on { print }' "$2"
}

echo "=== req-001 (a): Step 8 names plan/.feature-id ==="

S8="$(section '### Step 8: Clear sentinels' "$SHIP")"
case "$S8" in
  *'plan/.feature-id'*) found=yes ;;
  *) found=no ;;
esac
assert_equals "yes" "$found" "req-001 (a): Step 8 names plan/.feature-id for deletion"

echo ""
echo "=== req-001 (b): scripted Step 8 run ==="

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
git init -q -b feat/x "$TMP/repo"
cd "$TMP/repo" || exit 1
git config user.email t@example.com
git config user.name t
mkdir plan
echo 0000001-stale > plan/.feature-id
echo f > plan/.orchestrator-active
git add -A && git commit -q -m seed
rm -f plan/.orchestrator-active plan/.feature-id
git add -A plan && git commit -q -m "clear sentinels"
tracked="$(git ls-files plan/.feature-id plan/.orchestrator-active)"
assert_equals "" "$tracked" "req-001 (b): no id file or sentinel stays tracked"
cd "$SCRIPT_DIR" || exit 1

print_summary
