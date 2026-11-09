#!/usr/bin/env bash
# 0000164 req-007: gate-write-doc-correction (ADR-002)
# The three docs describe the full gate-write scope, not "src/ only".
# 0000315 req-004: the test reads the files that hold the rules and not the generated CLAUDE.md.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

FILES=(
  "ravintio-zero/standards/hook-enforcement.md"
  "ravintio-zero/pipeline-reference.md"
  "ravintio-zero/project-operations.md"
)

# check_doc LABEL PATH: prints PASS and FAIL lines and returns the failure count.
check_doc() {
  local f="$1" p="$2" fails=0 gate phrase
  gate="$(grep -i 'gate-write' "$p")"
  # The wrong wording is gone from lines that describe gate-write
  if printf '%s\n' "$gate" | grep -q 'Blocks writes to `src/`'; then
    echo "  FAIL: REQ-007 $f still says gate-write blocks writes to src/"; fails=$((fails+1))
  else
    echo "  PASS: REQ-007 $f has no 'Blocks writes to src/' wording"
  fi
  if grep -q 'ravintio-zero/`) unless\|`docs/`, `ravintio-zero/`)' "$p"; then
    echo "  FAIL: REQ-007 $f lists ravintio-zero/ as always permitted"; fails=$((fails+1))
  else
    echo "  PASS: REQ-007 $f does not list ravintio-zero/ as always permitted"
  fi
  # The right wording is present
  for phrase in "every in-project path" ".orchestrator-active" "outside the project"; do
    if printf '%s\n' "$gate" | grep -q -- "$phrase" || grep -A8 'How gate-write interacts' "$p" | grep -q -- "$phrase"; then
      echo "  PASS: REQ-007 $f states '$phrase'"
    else
      echo "  FAIL: REQ-007 $f lacks '$phrase'"; fails=$((fails+1))
    fi
  done
  return "$fails"
}

for f in "${FILES[@]}"; do
  check_doc "$f" "$ROOT/$f"
  FAIL=$((${FAIL:-0}+$?))
done

# A copy of the rule file without the three phrases must fail the same check (0000315 AC-2).
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
sed -e 's/every in-project path/every path/g' -e 's/\.orchestrator-active/the sentinel/g' -e 's/outside the project/elsewhere/g' \
  "$ROOT/ravintio-zero/standards/hook-enforcement.md" > "$TMP/hook-enforcement.md"
NEG="$(check_doc "stripped copy" "$TMP/hook-enforcement.md" 2>&1)"; NEGCODE=$?
assert_equals "yes" "$([ "$NEGCODE" -ne 0 ] && echo yes || echo no)" "REQ-007 a copy without the rule phrases fails the check"
assert_contains "lacks 'every in-project path'" "$NEG" "REQ-007 the failure names the missing phrase"

[ "${FAIL:-0}" -eq 0 ] && { echo "REQ-007 passed"; exit 0; } || { echo "REQ-007 FAILED (${FAIL})"; exit 1; }
