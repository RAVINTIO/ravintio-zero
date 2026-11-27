#!/usr/bin/env bash
# Test: 0000151 req-010 webfetch-via-subagent
# The dispatch standard routes a WebFetch of a full reference page through a
# sonnet or haiku subagent that returns only the extract.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT_DIR="$(cd "$ZERO_DIR/.." && pwd)"
STD="$ZERO_DIR/standards/agent-dispatch-standards.md"

echo "=== (a) WebFetch rule ==="
assert_rule oa-webfetch-subagent 'WebFetch' 'subagent' 'sonnet' 'haiku'
assert_rule oa-webfetch-extract 'extract' 'passes `model`'

echo "=== (b) installed copies ==="
DIFFS=0
for f in "$ROOT_DIR"/.claude/skills/*/references/agent-dispatch-standards.md; do
  [ -e "$f" ] || continue
  cmp -s "$f" "$STD" || DIFFS=$((DIFFS + 1))
done
assert_equals "0" "$DIFFS" "installed copies match the source"

print_summary
