#!/usr/bin/env bash
# Feature 0000472 req-002: the standards define the CI duration marker and target, and ship writes the marker.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GOV=$(cat "$ZERO_DIR/standards/workflow-governance-standards.md")
TESTING=$(cat "$ZERO_DIR/standards/testing-standards.md")
SHIP=$(cat "$ZERO_DIR/skills/ravintio-ship/SKILL.md")

echo "=== AC-1: governance standard ==="
assert_contains "CI duration: {seconds}s (run {run-id}, {ISO-8601 timestamp})" "$GOV" "AC-1: marker is defined"
assert_contains "| ci-duration-seconds | 420 |" "$GOV" "AC-1: threshold row is 420"

echo "=== AC-2: CI target ==="
assert_contains "CI duration target" "$TESTING" "AC-2: testing standard names the target"
assert_contains "420 seconds" "$TESTING" "AC-2: target is 420 seconds"

echo "=== AC-3: ship marker ==="
assert_contains "gh run view" "$SHIP" "AC-3: ship reads the run with gh run view"
assert_contains "CI duration:" "$SHIP" "AC-3: ship writes the marker"

print_summary
