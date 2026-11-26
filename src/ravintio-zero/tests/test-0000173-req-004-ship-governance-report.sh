#!/usr/bin/env bash
# 0000173 req-004: governance-report-at-ship
# Ship runs the metrics script, adds its section to the build report and
# the PR body, and never stops on a breach.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"

echo ""
echo "=== 0000173 req-004 ship-governance-report ==="

check() {
  if [ "$2" = "0" ]; then _pass_line "$1"; PASS=$((PASS+1)); else _fail_line "$1"; FAIL=$((FAIL+1)); fi
}

# Step 5 holds the metrics rule. Step 9 holds the PR body rule.
assert_rule shp-governance-metrics 'workflow-metrics.mjs' 'build-report.md'
assert_rule shp-pr-title-body '## Workflow governance'
assert_rule shp-governance-metrics 'not measured' 'breach' 'does not stop ship'
assert_rule shp-pr-title-body 'not measured' 'breach' 'does not stop ship'

print_summary
