#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-003: I-B Activate.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

echo "=== req-003 (a): preflight checks and refusal ==="
assert_rule rm-activate-checks 'remote named `origin`' '`gh` access' 'initiative/{id}-*' \
  'one active initiative per working tree' 'name the initiative that is already active'
assert_rule rm-activate-fail '`Blocked:`' 'before any branch or file changes'

echo ""
echo "=== req-003 (b): branch, state, push ==="
assert_rule rm-activate-steps 'initiative/{id}-{slug}' 'from `main`' 'plan/current-initiative/initiative.md' \
  '`status: active`' 'plan/roadmap/{id}-{slug}/' 'one commit' 'Push'

echo ""
echo "=== req-003 (c): driver offer ==="
assert_rule rm-activate-steps 'ravintio-zero/scripts/initiative-run.mjs' 'background task'
assert_rule rm-activate-no-edit 'must not edit the working tree'

print_summary
