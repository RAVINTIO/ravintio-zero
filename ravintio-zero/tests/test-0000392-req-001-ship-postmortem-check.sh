#!/usr/bin/env bash
# Tests for feature 0000392-ship-postmortems, req-001: ship fails when a stop
# or a rework has no postmortem.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

CHECK="$SCRIPT_DIR/../scripts/build-log-check.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cd "$WORK" || exit 1
mkdir -p plan/postmortems

DAY="2026-10-28"
block() {
  printf '### P%s: %s\n\n| Field | Value |\n|-------|-------|\n| Start | `%s` |\n| End | `%s` |\n| Wall clock | `%s` |\n\n' "$1" "$2" "$3" "$4" "$5"
  printf '%s\n\nComplete: P%s (%s)\n\n' "$6" "$1" "$4"
}
# log FILE EXTRA_LINES: five blocks, EXTRA_LINES go in the P2 block.
log() {
  {
    printf '# Build Log\n\n## Phase Log\n\n'
    block 0 Discovery "${DAY}T12:00:00Z" "${DAY}T12:03:00Z" 3 ""
    block 1 Plan "${DAY}T12:03:00Z" "${DAY}T12:10:00Z" 7 ""
    block 2 Implement "${DAY}T12:10:00Z" "${DAY}T12:30:00Z" 20 "$2"
    block 3 "Validate and Accept" "${DAY}T12:30:00Z" "${DAY}T12:40:00Z" 10 ""
    block 4 Ship "${DAY}T12:40:00Z" "${DAY}T12:45:00Z" 5 ""
    printf '## Summary\n\n| Metric | Value |\n|--------|-------|\n| Total wall clock | `45` |\n'
  } > "$1"
}
run_check() { OUT=$(node "$CHECK" "$1" 2>&1); CODE=$?; }

cat > plan/postmortems/good.md <<'REC'
# Postmortem

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Fix it | done | me | src | test | PR #1 |
| preventive | Add a check | filed | me | src | test | backlog entry 0000001 |
| detective | none, because CI catches it | none | | | | |
REC
cat > plan/postmortems/bad.md <<'REC'
# Postmortem

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Fix it | done | me | src | test | PR #1 |
REC

STOP='Blocked: schema change (2026-10-28T12:15:00Z)
Resolved: schema change (2026-10-28T12:20:00Z, approved)'

echo ""
echo "=== req-001 AC-1: a Resolved line with no postmortem fails ==="
log none.md "$STOP"
run_check none.md
assert_equals "1" "$CODE" "req-001 AC-1: exit 1 with no Postmortem line"
assert_contains "need a \"Postmortem:\" line" "$OUT" "req-001 AC-1: the finding names the missing line"

echo ""
echo "=== req-001 AC-2: a Rework line with no postmortem fails ==="
log rework.md "Rework: REQ-002: the test pinned old wording (2026-10-28T12:25:00Z)"
run_check rework.md
assert_equals "1" "$CODE" "req-001 AC-2: exit 1 with no Postmortem line"
assert_contains "REQ-002" "$OUT" "req-001 AC-2: the finding names REQ-002"
log wrongreq.md "Rework: REQ-002: x (2026-10-28T12:25:00Z)
Postmortem: plan/postmortems/good.md REQ-001 (2026-10-28T12:26:00Z)"
run_check wrongreq.md
assert_equals "1" "$CODE" "req-001 AC-2: a record that names another requirement does not cover REQ-002"

echo ""
echo "=== req-001 AC-3: covered stops and reworks pass ==="
log ok.md "$STOP
Rework: REQ-002: x (2026-10-28T12:25:00Z)
Rework: REQ-003: y (2026-10-28T12:26:00Z)
Postmortem: plan/postmortems/good.md (2026-10-28T12:27:00Z)
Postmortem: plan/postmortems/good.md REQ-002, REQ-003 (2026-10-28T12:28:00Z)"
run_check ok.md
assert_equals "0" "$CODE" "req-001 AC-3: exit 0 when every stop and rework has a record"
log norework.md ""
run_check norework.md
assert_equals "0" "$CODE" "req-001 AC-3: a log with no stop and no rework needs no record"

echo ""
echo "=== req-001: a missing or invalid record fails ==="
log missing.md "$STOP
Postmortem: plan/postmortems/absent.md (2026-10-28T12:27:00Z)"
run_check missing.md
assert_equals "1" "$CODE" "req-001: exit 1 for a record that does not exist"
assert_contains "absent.md does not exist" "$OUT" "req-001: the finding names the path"
log invalid.md "$STOP
Postmortem: plan/postmortems/bad.md (2026-10-28T12:27:00Z)"
run_check invalid.md
assert_equals "1" "$CODE" "req-001: exit 1 for a record that lacks a CAPA row"
assert_contains "no preventive row" "$OUT" "req-001: the finding comes from the CAPA check"

print_summary
