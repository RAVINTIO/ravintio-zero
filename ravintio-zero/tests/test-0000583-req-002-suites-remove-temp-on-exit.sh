#!/usr/bin/env bash
# Tests for feature 0000583-step-temp-cleanup-after-merge, REQ-002: five suites and the git-isolation
# helper remove their temp folders on a normal exit and on a stop signal.
#
# Each case runs a suite with TMPDIR set to a scratch folder, then lists the ravintio entries the
# suite left there.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRATCH="$(mktemp -d -t ravintio_0000583_req002_XXXXXX)"
trap 'rm -rf "$SCRATCH"' EXIT
trap 'exit 143' TERM
trap 'exit 130' INT HUP

SUITES=(
  test-0000169-req-004-setup-attribution-setting.sh
  test-0000245-req-002-targeted-overrides.sh
  test-0000151-req-005-setup-write-error-line.sh
  test-0000171-req-004-no-skill-bundling.sh
  test-0000029-req-001-003-boot-file-regeneration.sh
)

# Prints the ravintio entries in a folder, one per line.
leftovers() { ls -A "$1" 2>/dev/null | grep -E '^ravintio[_-]' || true; }

echo ""
echo "=== REQ-002 AC-1: a normal exit leaves nothing ==="
for s in "${SUITES[@]}"; do
  D="$SCRATCH/normal-${s%%-req*}-$RANDOM"
  mkdir -p "$D"
  TMPDIR="$D" bash "$SCRIPT_DIR/$s" >/dev/null 2>&1
  assert_equals "" "$(leftovers "$D")" "REQ-002 AC-1: $s leaves no ravintio entry"
done

echo ""
echo "=== REQ-002 AC-2: a TERM signal leaves nothing ==="
for s in "${SUITES[@]}"; do
  D="$SCRATCH/term-${s%%-req*}-$RANDOM"
  mkdir -p "$D"
  TMPDIR="$D" bash "$SCRIPT_DIR/$s" >/dev/null 2>&1 &
  PID=$!
  for _ in $(seq 100); do [ -n "$(leftovers "$D")" ] && break; sleep 0.1; done
  kill -TERM "$PID" 2>/dev/null
  wait "$PID" 2>/dev/null
  assert_equals "" "$(leftovers "$D")" "REQ-002 AC-2: $s leaves no ravintio entry after TERM"
done

echo ""
echo "=== REQ-002 AC-3: the git-isolation helper removes its config on a TERM signal ==="
D="$SCRATCH/helper"
mkdir -p "$D"
TMPDIR="$D" bash -c '
  source "$1/helpers/git-isolation.sh"
  isolate_git_env
  exit_on_signal
  trap remove_git_isolation EXIT
  touch "$2/ready"
  sleep 30 & wait
' _ "$SCRIPT_DIR" "$D" >/dev/null 2>&1 &
PID=$!
for _ in $(seq 100); do [ -e "$D/ready" ] && break; sleep 0.1; done
assert_contains "ravintio-gitconfig" "$(leftovers "$D")" "REQ-002 AC-3: the config file exists while the shell runs"
kill -TERM "$PID" 2>/dev/null
wait "$PID" 2>/dev/null
sleep 0.3
assert_equals "" "$(leftovers "$D")" "REQ-002 AC-3: no ravintio-gitconfig entry after TERM"

print_summary
