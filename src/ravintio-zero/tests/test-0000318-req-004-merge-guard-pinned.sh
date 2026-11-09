#!/usr/bin/env bash
# Tests for feature 0000318-titled-coordinator-prs, req-004: merge-guard is pinned.
#
# The test records what merge-guard.mjs allows and blocks today. A stub gh on
# PATH stands in for the real one. MERGE_GUARD overrides the hook path so a
# reviewer can prove the test fails against a widened copy.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
GUARD="${MERGE_GUARD:-$ZERO_DIR/hooks/enforcement/merge-guard.mjs}"
BASE_REF="origin/initiative/0000312-guards-history-and-test-noise"
INIT_BASE="initiative/0000312-guards-history-and-test-noise"

TMP=$(mktemp -d -t ravintio_0000318_req004_XXXXXX)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin"
# Stub gh: prints $STUB_BASE for "pr view".
cat > "$TMP/bin/gh" <<'STUB'
#!/usr/bin/env bash
echo "$@" >> "$STUB_LOG"
if [ "$1 $2" = "pr view" ]; then printf '{"baseRefName":"%s"}\n' "$STUB_BASE"; fi
STUB
chmod +x "$TMP/bin/gh"
export STUB_LOG="$TMP/gh.log"

run_guard() {
  local input="$1"; shift
  OUT=$(printf '%s' "$input" | env PATH="$TMP/bin:$PATH" "$@" node "$GUARD" 2>&1)
  CODE=$?
}
payload() { node -e 'console.log(JSON.stringify({tool_name:"Bash",tool_input:{command:process.argv[1]}}))' "$1"; }
# check <label> <expected exit> <command> <base>
check() {
  local label="$1" want="$2" cmd="$3" base="$4"
  run_guard "$(payload "$cmd")" STUB_BASE="$base"
  assert_equals "$want" "$CODE" "req-004: $label exits $want"
  if [ "$want" = 2 ]; then assert_contains "[RAVINTIO]" "$OUT" "req-004: $label prints a [RAVINTIO] message"; fi
}

echo ""
echo "=== req-004 AC-1: a coordinator squash passes ==="
check "coordinator squash into the initiative branch" 0 "gh pr merge 12 --squash --delete-branch" "$INIT_BASE"

echo ""
echo "=== req-004 AC-2: the blocked forms stay blocked ==="
check "squash into main" 2 "gh pr merge 12 --squash --delete-branch" "main"
check "--merge" 2 "gh pr merge 12 --merge" "$INIT_BASE"
check "--rebase" 2 "gh pr merge 12 --rebase" "$INIT_BASE"
check "--admin" 2 "gh pr merge 12 --squash --admin" "$INIT_BASE"
check "command substitution" 2 'gh pr merge $(echo 12) --squash' "$INIT_BASE"
check "variable selector" 2 'gh pr merge $PR --squash' "$INIT_BASE"
check "base initiativex" 2 "gh pr merge 12 --squash" "initiativex"

echo ""
echo "=== req-004 AC-3: the hook is unchanged ==="
if [ -n "${MERGE_GUARD:-}" ]; then
  echo "SKIP: MERGE_GUARD override set, AC-3 does not apply"
elif ! git -C "$ZERO_DIR" rev-parse --verify --quiet "$BASE_REF^{commit}" >/dev/null 2>&1; then
  echo "SKIP: $BASE_REF is not available (shallow clone or no remote), AC-3 skipped"
else
  DIFF=$(git -C "$ZERO_DIR" diff "$BASE_REF" -- hooks/enforcement/merge-guard.mjs 2>&1)
  assert_equals "" "$DIFF" "req-004: merge-guard.mjs has no diff against $BASE_REF"
fi

print_summary
