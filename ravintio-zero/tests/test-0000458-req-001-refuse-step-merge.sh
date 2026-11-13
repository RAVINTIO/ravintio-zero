#!/usr/bin/env bash
# Tests for feature 0000458-refuse-step-merge-outside-queue, req-001: merge-guard
# refuses a merge command from a step session (RAVINTIO_INITIATIVE_QUEUE=1).
#
# A stub gh on PATH stands in for the real one. The merge queue runs as a driver
# process, so it keeps merging with the variable set in its parent environment.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
GUARD="${MERGE_GUARD:-$ZERO_DIR/hooks/enforcement/merge-guard.mjs}"

TMP=$(mktemp -d -t ravintio_0000458_req001_XXXXXX)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin"
cat > "$TMP/bin/gh" <<'STUB'
#!/usr/bin/env bash
echo "$@" >> "$STUB_LOG"
if [ "$1 $2" = "pr view" ]; then printf '{"baseRefName":"%s"}\n' "$STUB_BASE"; fi
STUB
chmod +x "$TMP/bin/gh"
export STUB_LOG="$TMP/gh.log"

# run_guard <command> [ENV=VAL ...]: sets OUT and CODE. The caller's own
# RAVINTIO_INITIATIVE_QUEUE is cleared first so the case controls it.
run_guard() {
  local cmd="$1"; shift
  local input
  input=$(node -e 'console.log(JSON.stringify({tool_name:"Bash",tool_input:{command:process.argv[1]}}))' "$cmd")
  OUT=$(printf '%s' "$input" | env -u RAVINTIO_INITIATIVE_QUEUE PATH="$TMP/bin:$PATH" STUB_BASE=initiative/x "$@" node "$GUARD" 2>&1)
  CODE=$?
}

MERGE="gh pr merge 12 --squash --delete-branch"

echo "=== AC-1: refusal under the driver ==="
: > "$STUB_LOG"
run_guard "$MERGE" RAVINTIO_INITIATIVE_QUEUE=1
assert_equals "2" "$CODE" "AC-1: a plain squash into initiative/x exits 2 under the driver"
assert_contains "merge queue" "$OUT" "AC-1: the message names the merge queue"
assert_contains "[RAVINTIO] merge-guard" "$OUT" "AC-1: the message names the guard"
assert_equals "0" "$(wc -c < "$STUB_LOG" | tr -d ' ')" "AC-1: the guard does not call gh"
run_guard "echo hi; $MERGE" RAVINTIO_INITIATIVE_QUEUE=1
assert_equals "2" "$CODE" "AC-1: a chained merge exits 2 under the driver"
run_guard "gh api -X PUT repos/o/r/pulls/12/merge" RAVINTIO_INITIATIVE_QUEUE=1
assert_equals "2" "$CODE" "AC-1: an API merge path exits 2 under the driver"

echo ""
echo "=== AC-2: no change without the variable ==="
run_guard "$MERGE"
assert_equals "0" "$CODE" "AC-2: no variable keeps the squash into initiative/x"
run_guard "$MERGE" RAVINTIO_INITIATIVE_QUEUE=0
assert_equals "0" "$CODE" "AC-2: a value of 0 keeps the squash"
run_guard "$MERGE" RAVINTIO_INITIATIVE_QUEUE=
assert_equals "0" "$CODE" "AC-2: an empty value keeps the squash"
run_guard "gh pr merge 12 --squash" STUB_BASE=main
assert_equals "2" "$CODE" "AC-2: a squash into main still exits 2"
run_guard "git status" RAVINTIO_INITIATIVE_QUEUE=1
assert_equals "0" "$CODE" "AC-2: a command that is not a merge passes under the driver"
run_guard "node ravintio-zero/scripts/merge-queue.mjs run --step 33 --pr 12" RAVINTIO_INITIATIVE_QUEUE=1
assert_equals "0" "$CODE" "AC-2: running the queue script passes under the driver"

echo ""
echo "=== AC-3: the queue still merges with the variable set ==="
Q_OUT=$(RAVINTIO_INITIATIVE_QUEUE=1 RAVINTIO_TEST_QUIET=1 bash "$SCRIPT_DIR/test-0000454-req-001-queue-failure-recovery.sh" 2>&1)
Q_CODE=$?
assert_equals "0" "$Q_CODE" "AC-3: the queue suite passes with RAVINTIO_INITIATIVE_QUEUE=1 ($Q_OUT)"
assert_equals "0" "$(grep -c RAVINTIO_INITIATIVE_QUEUE "$ZERO_DIR/scripts/merge-queue.mjs" || true)" "AC-3: merge-queue.mjs does not read the variable"

echo ""
echo "=== AC-4: the text names the queue as the only step merge path ==="
assert_rule carveout-step-queue-only "RAVINTIO_INITIATIVE_QUEUE" "merge queue"
for f in \
  "$ZERO_DIR/skills/ravintio-ship/SKILL.md" \
  "$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-phase-invocation.md" \
  "$ZERO_DIR/standards/hook-enforcement.md" \
  "$REPO_ROOT/docs/architecture-overview.md"; do
  assert_contains "RAVINTIO_INITIATIVE_QUEUE" "$(cat "$f")" "AC-4: $(basename "$f") names the variable"
done

print_summary
