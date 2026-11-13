#!/usr/bin/env bash
# Tests for feature 0000392-ship-postmortems, req-004: the PR title form, and
# the rules that name the postmortem for each stop and rework.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SHIP="$(cat "$ZERO_DIR/skills/ravintio-ship/SKILL.md")"
POST="$(cat "$ZERO_DIR/skills/ravintio-postmortem/SKILL.md")"
QUEUE="$ZERO_DIR/scripts/merge-queue.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo ""
echo "=== req-004 AC-1: ship names the title form and the check ==="
assert_contains "first 7 digits of the feature id" "$SHIP" "req-004 AC-1: the seven-digit form"
assert_contains "merge-queue.mjs title" "$SHIP" "req-004 AC-1: ship runs the title check"

echo ""
echo "=== req-004 AC-2: the title form passes the check ==="
cat > "$WORK/chart.md" <<'CHART'
## Steps

| Step | Feature id | Title | Bump | Version | Status |
|------|------------|-------|------|---------|--------|
| 16 | 0000392-ship-postmortems | Ship postmortems | minor | | pending |
CHART
OUT=$(node "$QUEUE" title --step 16 --title "0000392: Ship postmortems" --chart "$WORK/chart.md" 2>&1); RC=$?
assert_equals "0" "$RC" "req-004 AC-2: the seven-digit title passes"
assert_contains "title ok" "$OUT" "req-004 AC-2: the command prints title ok"
node "$QUEUE" title --step 16 --title "0000392-ship-postmortems: Ship postmortems" --chart "$WORK/chart.md" >/dev/null 2>&1; RC=$?
assert_equals "1" "$RC" "req-004 AC-2: the full feature id form fails"

echo ""
echo "=== req-001: the rules name the postmortem ==="
assert_rule stops-postmortem "Postmortem:"
assert_rule stops-postmortem-rework "Rework:" "REQ-"
assert_rule stops-postmortem-ship-check "build-log-check.mjs" "postmortem-check.mjs"
assert_rule resume-resolved-outside "Resolved:" "outside this session"
assert_contains "postmortem-check.mjs" "$POST" "req-002: the postmortem skill runs the record check"
assert_contains "none, because" "$POST" "req-002: the skill shows the none-because form"
assert_contains "commit or the PR" "$POST" "req-002: the skill records done work with its commit or PR"
assert_contains "Postmortem:" "$SHIP" "req-001: ship names the Postmortem line"

print_summary
