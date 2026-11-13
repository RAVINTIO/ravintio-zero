#!/usr/bin/env bash
# Tests for feature 0000355-codeql-and-branch-cleanup, REQ-003.
# AC-1: a marked job with no guard passes the shape check, with no test edit.
# AC-2: an unmarked job with no guard fails it.
# AC-3: the plan skill's test impact scan names the workflow cause.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
HELPER="$SCRIPT_DIR/helpers/unguarded-jobs.sh"
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"

if ! command -v ruby >/dev/null 2>&1; then
  echo "ruby missing: YAML checks skipped"
  print_summary
  exit 0
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cat > "$TMP/marked.yml" <<'YML'
jobs:
  guarded:
    if: github.event_name == 'pull_request' && github.event.action != 'closed'
    runs-on: ubuntu-latest
  # a note about the job
  # ravintio:job-guard-exempt
  extra:
    runs-on: ubuntu-latest
YML
cat > "$TMP/unmarked.yml" <<'YML'
jobs:
  guarded:
    if: github.event_name == 'pull_request' && github.event.action != 'closed'
    runs-on: ubuntu-latest
  # ravintio:job-guard-exempt

  extra:
    runs-on: ubuntu-latest
  other:
    runs-on: ubuntu-latest
YML

echo ""
echo "=== REQ-003 AC-1: a marked job passes ==="
assert_equals "" "$(bash "$HELPER" "$TMP/marked.yml")" "REQ-003 AC-1: marked job needs no guard"

echo ""
echo "=== REQ-003 AC-2: an unmarked job fails ==="
assert_equals "extra
other" "$(bash "$HELPER" "$TMP/unmarked.yml")" "REQ-003 AC-2: a blank line breaks the marker, and an unmarked job is listed"

echo ""
echo "=== REQ-003 AC-3: the plan scan names the workflow cause ==="
SCAN=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN")
assert_contains "Workflow job or step" "$SCAN" "REQ-003 AC-3: the scan names the workflow cause"
assert_contains "ravintio.yml" "$SCAN" "REQ-003 AC-3: the scan greps for ravintio.yml"

echo ""
echo "=== REQ-003: the shape test holds no fixed job list ==="
SHAPE="$SCRIPT_DIR/test-0000169-req-006-release-tag-ci-and-ship-flow.sh"
assert_not_contains 'k == "squash-before-main"' "$(cat "$SHAPE")" "REQ-003: the fixed name list is gone"

print_summary
