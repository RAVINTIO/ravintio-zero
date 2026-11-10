#!/usr/bin/env bash
# Tests for feature 0000460-narrow-brand-guard-self-entry, req-001: the brand
# guard skips its two allowlist files by exact path (ADR-0298).
#
# This source never writes the retired word as one token. It joins two halves.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GUARD="$ZERO_DIR/scripts/brand-guard.sh"
ALLOW="$SCRIPT_DIR/brand-guard-allowlist.txt"
CITEST="$SCRIPT_DIR/test-0000160-req-006-brand-guard.sh"
WORD="plani""fest"
TAB=$'\t'

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo ""
echo "=== REQ-001 AC-1: the guard skips the two allowlist paths and nothing else ==="
ROOT="$TMP/repo"
EMPTY_ALLOW="$TMP/empty-allowlist.txt"
printf '# no rows\n' > "$EMPTY_ALLOW"
SKIPPED=(
  "src/ravintio-zero/tests/brand-guard-allowlist.txt"
  "ravintio-zero/tests/brand-guard-allowlist.txt"
)
LOOKALIKES=(
  "src/ravintio-zero/tests/brand-guard-allowlist.txt.bak"
  "ravintio-zero/tests/brand-guard-allowlist.txt.bak"
  "other/ravintio-zero/tests/brand-guard-allowlist.txt"
  "docs/brand-guard-allowlist.txt"
  "x/src/ravintio-zero/tests/brand-guard-allowlist.txt"
  "src/ravintio-zero/tests/brand-guard-allowlist.txt2"
)
for p in "${SKIPPED[@]}" "${LOOKALIKES[@]}"; do
  mkdir -p "$ROOT/$(dirname "$p")"
  printf 'line one\nThe %s name\n' "$WORD" > "$ROOT/$p"
done
OUT="$(printf '%s\n' "${SKIPPED[@]}" "${LOOKALIKES[@]}" | bash "$GUARD" --root "$ROOT" --allowlist "$EMPTY_ALLOW")"
RC=$?
assert_equals "1" "$RC" "REQ-001 AC-1: the guard exits 1 on the look-alikes"
for p in "${SKIPPED[@]}"; do
  if printf '%s\n' "$OUT" | grep -qxF -- "$p:2"; then
    assert_equals "skipped" "reported" "REQ-001 AC-1: the guard skips $p"
  else
    assert_equals "skipped" "skipped" "REQ-001 AC-1: the guard skips $p"
  fi
done
for p in "${LOOKALIKES[@]}"; do
  assert_contains "$p:2" "$OUT" "REQ-001 AC-1: the guard reports $p"
done

echo ""
echo "=== REQ-001 AC-2: the shipped allowlist has no self-entry ==="
SELF=""
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in ''|'#'*|'!'*) continue ;; esac
  path_re="${line%%"$TAB"*}"
  # A row that passes every line of a file is a self-entry. Its line regex is a bare dot.
  [ "${line#*"$TAB"}" = "." ] || continue
  for p in "${SKIPPED[@]}"; do
    [[ "$p" =~ $path_re ]] && SELF="${SELF}${path_re} matches ${p}"$'\n'
  done
done < "$ALLOW"
assert_equals "" "$SELF" "REQ-001 AC-2: no row passes every line of an allowlist path"
bash "$CITEST" >/dev/null 2>&1
assert_equals "0" "$?" "REQ-001 AC-2: the CI brand test passes"

echo ""
echo "=== REQ-001 AC-3: the script and the CI test share one skip rule ==="
assert_contains "brand_guard_skips_path" "$(cat "$GUARD")" "REQ-001 AC-3: the script defines the rule"
assert_contains "brand_guard_skips_path" "$(cat "$CITEST")" "REQ-001 AC-3: the CI test calls the rule"
MAIN="$(sed -n '/^brand_guard_main()/,/^}/p' "$GUARD")"
assert_contains "brand_guard_skips_path" "$MAIN" "REQ-001 AC-3: the script main calls the rule"

print_summary
