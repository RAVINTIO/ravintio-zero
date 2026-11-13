#!/usr/bin/env bash
# Tests for feature 0000491-driver-favours-critical-path, req-001 and req-002 (chain ranking).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="$SCRIPT_DIR/../scripts/initiative-chart.mjs"
STANDARDS="$SCRIPT_DIR/../standards/roadmap-standards.md"

# Run a node snippet against the module. $1 is JS using `c`.
run_js() {
  node --input-type=module -e "
import * as c from '$TOOL';
const mk = (step, status, lane, after = []) => ({ step, status, lane, after });
const show = (steps, states = new Map()) => console.log(JSON.stringify(c.readySteps(steps, states).map(s => s.step)));
$1" 2>&1
}

# AC-1: the longest chain starts first.
OUT="$(run_js 'show([mk(1,"pending","a"), mk(2,"pending","b"), mk(3,"pending","c"), mk(4,"pending","d",[3]), mk(5,"pending","e",[4])])')"
assert_equals "[3,1,2]" "$OUT" "REQ-001 AC-1: the step with the longest chain behind it comes first"

# AC-2: equal chains keep chart order.
OUT="$(run_js 'show([mk(1,"pending","a"), mk(2,"pending","b"), mk(3,"pending","c")])')"
assert_equals "[1,2,3]" "$OUT" "REQ-001 AC-2: equal chains keep chart order"
OUT="$(run_js 'show([mk(1,"pending","a"), mk(2,"pending","b"), mk(3,"pending","c",[1]), mk(4,"pending","d",[2])])')"
assert_equals "[1,2]" "$OUT" "REQ-001 AC-2: chains of equal length keep chart order"

# AC-3: later steps of a lane count as part of the chain.
OUT="$(run_js 'show([mk(1,"pending","a"), mk(2,"pending","b"), mk(3,"pending","b"), mk(4,"pending","b")])')"
assert_equals "[2,1]" "$OUT" "REQ-001 AC-3: a lane with later steps outranks a lone step"
OUT="$(run_js 'show([mk(1,"merged","a"), mk(2,"pending","a"), mk(3,"pending","b"), mk(4,"pending","b",[2])])')"
assert_equals "[2,3]" "$OUT" "REQ-001 AC-3: merged steps add nothing to a chain"

# The lane still yields only its earliest step, and a held lane yields none.
OUT="$(run_js 'show([mk(1,"pending","a"), mk(2,"pending","a"), mk(3,"pending","b")], new Map([[1,"running"]]))')"
assert_equals "[3]" "$OUT" "REQ-001: a running step holds its lane"

# Error path: a cycle ends the count and the function still returns steps.
OUT="$(run_js 'show([mk(1,"pending","a",[2]), mk(2,"pending","b",[1]), mk(3,"pending","c")])')"
assert_equals "[3]" "$OUT" "REQ-001: a cycle in After lists does not loop and blocks only its own steps"

# NFR-001: 60 steps rank in under 100 ms.
OUT="$(run_js 'const steps = Array.from({length: 60}, (_, i) => mk(i + 1, "pending", "l" + (i % 5), i > 4 ? [i - 4] : [])); const t = Date.now(); c.readySteps(steps); console.log(Date.now() - t < 100 ? "fast" : "slow")')"
assert_equals "fast" "$OUT" "NFR-001: ranking 60 steps takes under 100 ms"

# REQ-002: the standards state the order.
TEXT="$(cat "$STANDARDS")"
assert_contains "longest chain" "$TEXT" "REQ-002 AC-1: the standards name the longest chain first order"
assert_contains "Chart order breaks ties" "$TEXT" "REQ-002 AC-1: the standards state the tie rule"

print_summary
