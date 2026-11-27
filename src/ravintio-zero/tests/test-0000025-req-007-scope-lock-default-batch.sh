#!/usr/bin/env bash
# Scope Lock Challenge: drafted inline by the orchestrator, batch presented,
# confirmed only by the human's explicit per-item accept, edit, or reject.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ORCH="$(orch_combined "$(cd "$SCRIPT_DIR/.." && pwd)/skills/ravintio-orchestrator")"
assert_rule orc-scope-lock-paths "Happy path" "First-run" "Error path" "ross-session"
assert_rule orc-scope-lock-draft "Draft inline" "Do not dispatch a subagent"
assert_rule orc-scope-lock-confirm "accept, edit, or reject" "ilence is never approval"
assert_rule orc-scope-lock-record "build log"

print_summary
