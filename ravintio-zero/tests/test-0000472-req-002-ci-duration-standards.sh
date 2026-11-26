#!/usr/bin/env bash
# Feature 0000472 req-002: the standards define the CI duration marker and target, and ship writes the marker.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GOV=$(cat "$ZERO_DIR/standards/workflow-governance-standards.md")

echo "=== AC-1: governance standard ==="
assert_rule shp-gov-ci-marker "CI duration: {seconds}s (run {run-id}, {ISO-8601 timestamp})"
# The threshold row sits in a table, so it has no rule anchor.
assert_contains "| ci-duration-seconds | 420 |" "$GOV" "AC-1: threshold row is 420"

echo "=== AC-2: CI target ==="
assert_rule shp-ci-duration-target "CI duration target" "420 seconds"

echo "=== AC-3: ship marker ==="
assert_rule shp-ci-duration-marker "gh run view" "CI duration:"

print_summary
