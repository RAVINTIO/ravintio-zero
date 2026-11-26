#!/usr/bin/env bash
# Tests for feature 0000317-block-forced-adds, req-001, req-003, req-004:
# the orchestrator rule, the tracked driver ignores, and the ignored-file check.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
ORCH="$(cat "$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md")"
SHIP="$(cat "$ZERO_DIR/skills/ravintio-ship/SKILL.md")"

echo "=== req-001 AC-1: the rule is in the orchestrator skill ==="
assert_rule rm-orch-driver-files "git add -f" "git add --force" "negation rule to \`.gitignore\`"

echo ""
echo "=== req-003 AC-1: the tracked .gitignore lists the driver paths ==="
TMP=$(mktemp -d -t ravintio_0000317_req003_XXXXXX)
trap 'rm -rf "$TMP"' EXIT
git init -q "$TMP"
cp "$ROOT/.gitignore" "$TMP/.gitignore"
: > "$TMP/.git/info/exclude"
for path in plan/.initiative-logs/step-1.log plan/.initiative-queue/x.md plan/.initiative-runner.lock; do
  (cd "$TMP" && git check-ignore -q "$path"); assert_equals "0" "$?" "req-003 AC-1: $path is ignored with an empty exclude file"
done

echo ""
echo "=== req-004 AC-1/2: the check command ==="
CLEAN=$(cd "$TMP" && git ls-files -ci --exclude-standard)
assert_equals "" "$CLEAN" "req-004 AC-2: a clean tree lists nothing"
mkdir -p "$TMP/plan/.initiative-logs" && echo x > "$TMP/plan/.initiative-logs/step-1.log"
(cd "$TMP" && git add -f plan/.initiative-logs/step-1.log)
FOUND=$(cd "$TMP" && git ls-files -ci --exclude-standard)
assert_equals "plan/.initiative-logs/step-1.log" "$FOUND" "req-004 AC-1: the check lists a forced-in ignored file"

echo ""
echo "=== req-004 AC-3: ship and both workflows carry the check ==="
assert_rule orc-ship-clear-markers "ls-files -ci --exclude-standard"
assert_contains "ls-files -ci --exclude-standard" "$(cat "$ZERO_DIR/hooks/ravintio.yml")" "req-004 AC-3: the pack workflow runs the check"
assert_contains "ls-files -ci --exclude-standard" "$(cat "$ROOT/.github/workflows/ravintio.yml")" "req-004 AC-3: the tracked workflow runs the check"
(cd "$ROOT" && git ls-files -ci --exclude-standard) > "$TMP/repo.txt"
assert_equals "" "$(cat "$TMP/repo.txt")" "req-004 AC-3: this repo has no committed ignored file"

print_summary
