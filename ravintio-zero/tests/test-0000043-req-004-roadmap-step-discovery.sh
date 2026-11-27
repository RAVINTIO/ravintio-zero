#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-004: I-C Run step discovery.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

# The orchestrator sections that point to I-C Run.
SL="$(orch_section '### Scope Lock Challenge')"
DC="$(orch_section '### Design Confirmation (the discovery gate)')"
DSA="$(orch_section '### Discovery Start Actions')"

echo "=== req-004 (a): branch, brief, run mode ==="
assert_rule rm-icrun-prefix '`I-C Run:`'
assert_rule icrun-branch "step's feature branch from the initiative branch" 'not from `main`'
assert_rule icrun-brief 'backlog entries' 'same commit'
assert_rule icrun-run-mode 'plan/.run-mode' '`autonomous`' 'without asking'
assert_contains 'I-C Run' "$DSA" "req-004 (a): Discovery Start Actions points to I-C Run"

echo ""
echo "=== req-004 (b): self-confirmation ==="
assert_rule icrun-self-confirm 'draft-accepted (initiative)'
assert_rule icrun-p0-stops 'too vague to draft'
assert_contains 'I-C Run' "$SL" "req-004 (b): Scope Lock Challenge points to I-C Run"
assert_contains 'I-C Run' "$DC" "req-004 (b): Design Confirmation points to I-C Run"

echo ""
echo "=== req-004 (c): per-step bump ==="
assert_rule icrun-bump '`Bump`' '`major`, `minor`, or `patch`' 'default `minor`' \
  "initiative branch's version comes from \`product.yml\`" '`docs/about.md` when `product.yml` is absent' \
  'downgrade block'
assert_contains 'I-C Run' "$(printf '%s\n' "$DSA" | grep 'Suggest a version bump')" "req-004 (c): version step points to I-C Run"

print_summary
