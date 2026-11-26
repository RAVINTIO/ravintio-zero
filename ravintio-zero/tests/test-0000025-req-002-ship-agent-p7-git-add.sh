#!/usr/bin/env bash
# Tests for feature 0000025, req-002: the ship phase's archive commit stages
# everything explicitly, so it never silently depends on git's
# rename-detection heuristic and never leaves untracked artifacts behind.
# The rule now lives in ravintio-ship/SKILL.md's archive step.
#
# ravintio-ship/SKILL.md is a prose skill file, not executable code, so
# these are content-assertion tests against the SKILL.md text.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SHIP_SKILL="$ZERO_DIR/skills/ravintio-ship/SKILL.md"


echo ""
echo "=== req-002: the archive step stages everything explicitly ==="

assert_equals "yes" "$(grep -q '^### Step 4: Archive' "$SHIP_SKILL" && echo yes || echo no)" \
  "req-002: ravintio-ship documents an archive step"
assert_rule shp-archive-git-add 'git add` everything' "the archive" "the deletions" "the link updates"

echo ""
echo "=== req-002: untracked artifacts are never left behind ==="

assert_rule shp-archive-git-add "Untracked artifacts" "must not be left behind" "git status --porcelain"

echo ""
echo "=== req-002: archive mechanics are copy-then-delete ==="

assert_rule shp-archive-copy 'Copy all of `plan/current/` to the archive path, then' "Never use an atomic move"

print_summary
