#!/usr/bin/env bash
# Tests for feature 0000397-pack-source-in-src, req-005: guards cover both paths.
#
# Each guard that names ravintio-zero/ also covers src/ravintio-zero/, and no
# guard gains an allowed form. All hook runs happen in scratch folders.
#
# This source never writes the retired product word as one token.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
WORD="plani""fest"
UPWORD="$(printf '%s' "$WORD" | tr a-z A-Z)"
ALLOW="$ZERO_DIR/tests/brand-guard-allowlist.txt"
BASE_COMMIT="b419da39^"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo ""
echo "=== REQ-005 AC-1: em-dash-guard blocks the same write on both paths ==="
GUARD="$ZERO_DIR/hooks/enforcement/em-dash-guard.mjs"
PROJ="$TMP/em"
mkdir -p "$PROJ"
for prefix in ravintio-zero src/ravintio-zero; do
  for sub in skills templates standards; do
    payload="$(node -e 'process.stdout.write(JSON.stringify({tool_name:"Write",tool_input:{file_path:process.argv[1],content:"a — b"}}))' "$prefix/$sub/x.md")"
    (cd "$PROJ" && printf '%s' "$payload" | node "$GUARD" >/dev/null 2>&1)
    assert_equals "2" "$?" "REQ-005 AC-1: em-dash-guard blocks a write to $prefix/$sub/"
  done
  for sub in hooks tests; do
    payload="$(node -e 'process.stdout.write(JSON.stringify({tool_name:"Write",tool_input:{file_path:process.argv[1],content:"a — b"}}))' "$prefix/$sub/x.md")"
    (cd "$PROJ" && printf '%s' "$payload" | node "$GUARD" >/dev/null 2>&1)
    assert_equals "0" "$?" "REQ-005 AC-2: em-dash-guard still passes $prefix/$sub/ (no new scope change)"
  done
done

echo ""
echo "=== REQ-005 AC-1: brand-guard.sh flags the old name on both paths ==="
BG="$ZERO_DIR/scripts/brand-guard.sh"
for prefix in ravintio-zero src/ravintio-zero; do
  R="$TMP/bg-$(echo "$prefix" | tr / -)"
  mkdir -p "$R/$prefix/standards" "$R/$prefix/migrations/_done" "$R/$prefix/tests" "$R/$prefix/scripts"
  cp "$ALLOW" "$R/$prefix/tests/brand-guard-allowlist.txt"
  printf 'The %s name\n' "$WORD" > "$R/$prefix/standards/a.md"
  printf 'The %s name\n' "$WORD" > "$R/$prefix/migrations/_done/b.md"
  printf 'legacy %s_ROADMAP_MODEL\n' "$UPWORD" > "$R/$prefix/scripts/initiative-run.mjs"
  OUT="$(printf '%s\n' "$prefix/standards/a.md" "$prefix/migrations/_done/b.md" "$prefix/scripts/initiative-run.mjs" \
    | bash "$BG" --root "$R" 2>&1)"
  assert_contains "$prefix/standards/a.md:1" "$OUT" "REQ-005 AC-1: brand-guard flags a hit under $prefix/"
  assert_equals "1" "$(printf '%s\n' "$OUT" | grep -c .)" "REQ-005 AC-2: only the unlisted hit under $prefix/ is flagged"
  OUT2="$(printf '%s\n' "$prefix/standards/a.md" | bash "$BG" --root "$R" 2>&1)"
  assert_contains "a.md:1" "$OUT2" "REQ-005 AC-1: brand-guard finds its default allowlist under $prefix/tests/"
done

echo ""
echo "=== REQ-005 AC-1: pre-push runs the brand guard from either path ==="
for prefix in ravintio-zero src/ravintio-zero; do
  R="$TMP/pp-$(echo "$prefix" | tr / -)"
  mkdir -p "$R/$prefix/hooks" "$R/$prefix/scripts" "$R/$prefix/tests" "$R/docs"
  git -C "$R" init -q -b main
  git -C "$R" config user.email t@example.com
  git -C "$R" config user.name t
  cp "$ZERO_DIR/hooks/pre-push" "$R/$prefix/hooks/pre-push"
  cp "$ZERO_DIR/scripts/brand-guard.sh" "$R/$prefix/scripts/brand-guard.sh"
  cp "$ALLOW" "$R/$prefix/tests/brand-guard-allowlist.txt"
  printf 'id: "ravintio-zero"\n' > "$R/product.yml"
  echo base > "$R/README.md"
  git -C "$R" add -A && git -C "$R" commit -q -m base
  git -C "$R" update-ref refs/remotes/origin/main HEAD
  git -C "$R" checkout -q -b feat/x
  printf 'l1\nThe %s name\n' "$WORD" > "$R/docs/note.md"
  git -C "$R" add -A && git -C "$R" commit -q -m add
  OUT="$(cd "$R" && bash "$prefix/hooks/pre-push" 2>&1)"; RC=$?
  assert_equals "1" "$RC" "REQ-005 AC-1: pre-push rejects the old name with the guard under $prefix/"
  assert_contains "docs/note.md:2" "$OUT" "REQ-005 AC-1: pre-push names the hit with the guard under $prefix/"
done

echo ""
echo "=== REQ-005 AC-1: the driver watches both paths ==="
DRIVER="$(cat "$ZERO_DIR/scripts/initiative-run.mjs")"
for p in scripts/initiative-run.mjs scripts/initiative-watch.mjs skills/ravintio-initiative/SKILL.md skills/ hooks/ setup.sh setup/; do
  assert_contains "'ravintio-zero/$p'" "$DRIVER" "REQ-005 AC-1: driver watch list holds ravintio-zero/$p"
  assert_contains "'src/ravintio-zero/$p'" "$DRIVER" "REQ-005 AC-1: driver watch list holds src/ravintio-zero/$p"
done

echo ""
echo "=== REQ-005 AC-1: prose-check scopes and the commit hooks cover both paths ==="
PC="$(cat "$ZERO_DIR/scripts/prose-check.mjs")"
assert_contains '"ravintio-zero/tests/"' "$PC" "REQ-005 AC-1: prose-check skips ravintio-zero/tests/"
assert_contains '"src/ravintio-zero/tests/"' "$PC" "REQ-005 AC-1: prose-check skips src/ravintio-zero/tests/"
assert_contains '"src/"' "$PC" "REQ-005 AC-1: prose-check scans src/"
for h in pre-commit commit-msg; do
  C="$(cat "$ZERO_DIR/hooks/$h")"
  assert_contains '/ravintio-zero/scripts/prose-check.mjs' "$C" "REQ-005 AC-1: $h finds prose-check at ravintio-zero/"
  assert_contains '/src/ravintio-zero/scripts/prose-check.mjs' "$C" "REQ-005 AC-1: $h finds prose-check at src/ravintio-zero/"
done

echo ""
echo "=== REQ-005 AC-2: the allowlist gains only src/ mirrors of existing entries ==="
# The base self-entry row for the allowlist file left in 0000460 (ADR-0298), so BEFORE drops it.
if git -C "$REPO_ROOT" cat-file -e "$BASE_COMMIT:ravintio-zero/tests/brand-guard-allowlist.txt" 2>/dev/null; then
  BEFORE="$(git -C "$REPO_ROOT" show "$BASE_COMMIT:ravintio-zero/tests/brand-guard-allowlist.txt" | grep -v '^#' | grep -v '^$' | grep -v '^\^ravintio-zero/tests/brand-guard-allowlist')"
  AFTER="$(grep -v '^#' "$ALLOW" | grep -v '^$' | grep -v '^!src/ravintio-zero/' | sed 's#(src/)?ravintio-zero#ravintio-zero#g')"
  assert_equals "$BEFORE" "$AFTER" "REQ-005 AC-2: removing the src/ mirrors leaves the original entries unchanged"
  MIRRORS="$(grep -c '^!src/ravintio-zero/' "$ALLOW")"
  ORIG="$(printf '%s\n' "$BEFORE" | grep -c '^!ravintio-zero/')"
  assert_equals "$ORIG" "$MIRRORS" "REQ-005 AC-2: each excluded ravintio-zero/ prefix has one src/ mirror"
  assert_equals "0" "$(grep -v '^#' "$ALLOW" | grep -v '^!' | grep -c '^src/')" "REQ-005 AC-2: no entry names a src/ path outside the (src/)? form"
else
  echo "  SKIP: base commit $BASE_COMMIT not in this clone"
fi

print_summary
