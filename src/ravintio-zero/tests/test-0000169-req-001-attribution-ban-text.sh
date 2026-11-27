#!/usr/bin/env bash
# 0000169 req-001: attribution-ban-text
# The boot template, commit standards, and ship skill ban AI attribution in
# PR descriptions and name the three host lines.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

BOOT="$ZERO_DIR/templates/standard-boot.md"

echo ""
echo "=== 0000169 req-001 attribution-ban-text ==="

# The boot template renders into every CLAUDE.md, so it carries no rule anchor.
for phrase in 'Generated with [Claude Code]' 'Co-Authored-By' 'Claude-Session:'; do
  if grep -qF -- "$phrase" "$BOOT"; then echo "  PASS: templates/standard-boot.md names $phrase"
  else echo "  FAIL: templates/standard-boot.md lacks $phrase"; FAIL=$((FAIL+1)); fi
done
if grep -i 'PR description\|PR bod' "$BOOT" | grep -qi 'attribut'; then
  echo "  PASS: templates/standard-boot.md bans attribution in PR descriptions"
else
  echo "  FAIL: templates/standard-boot.md does not ban attribution in PR descriptions"; FAIL=$((FAIL+1))
fi

# Commit standards, section 3
assert_rule shp-commit-attribution-lines 'Generated with [Claude Code]' 'Co-Authored-By' 'Claude-Session:'
assert_rule shp-commit-no-attribution 'PR descriptions' 'attribute'

# Ship skill
assert_rule shp-pr-title-body 'Generated with [Claude Code]' 'Co-Authored-By' 'Claude-Session:' 'PR bodies' 'attribution'

# Section 3 no longer limits the ban to commit messages
if rule_text shp-commit-no-attribution | head -1 | grep -q '^Commit messages MUST NOT'; then
  echo "  FAIL: commit-standards section 3 limits the ban to commit messages"; FAIL=$((FAIL+1))
else
  echo "  PASS: commit-standards section 3 is not limited to commit messages"
fi

print_summary
