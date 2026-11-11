#!/usr/bin/env bash
# Test: 0000519 req-001 Ship removes plan/current with git rm
# Ship Step 4 removes plan/current/ with git rm -r -q plan/current after the copy,
# and the ship skill names no plain rm -r of plan/current/.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"
STEP4=$(sed -n '/^### Step 4: Archive/,/^### Step 5/p' "$SHIP")

echo ""
echo "=== req-001 AC-1: Step 4 names the git command ==="
assert_contains 'git rm -r -q plan/current' "$STEP4" "req-001 AC-1: Step 4 runs git rm -r -q plan/current"
assert_contains 'Copy all of `plan/current/` to the archive path, then' "$STEP4" "req-001 AC-1: the copy comes first"

echo ""
echo "=== req-001 AC-2: no plain rm -r of plan/current ==="
PLAIN=$(sed 's/git rm -r/GITRM/g' "$SHIP" | grep -E 'rm -r[a-z]* .*plan/current' || true)
assert_equals "" "$PLAIN" "req-001 AC-2: the ship skill names no plain rm -r of plan/current"

echo ""
echo "=== req-001 AC-3: the installed copy matches ==="
ROOT="$(cd "$ZERO_DIR/../.." && pwd)"
node "$ZERO_DIR/scripts/sync-installed.mjs" --check --root "$ROOT" >/dev/null 2>&1
assert_equals "0" "$?" "req-001 AC-3: ravintio-zero/ matches src/ravintio-zero/"

print_summary
