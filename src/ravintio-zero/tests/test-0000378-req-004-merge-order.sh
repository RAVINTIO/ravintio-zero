#!/usr/bin/env bash
# 0000378 req-004: the history check and the reshape order chart steps by the Version column (merge order).
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

RESHAPE="$ZERO_DIR/scripts/reshape-initiative.mjs"
CHECK="$ZERO_DIR/scripts/check-initiative-history.mjs"
TMP="$(mktemp -d -t ravintio_0000378_XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

BRANCH="initiative/0000900-demo"
NEW="$BRANCH-reshaped"

write_chart() { # path version-of-step-1 version-of-step-2
  cat > "$1" <<CHART_EOF
# Initiative: 0000900 - demo

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status |
|------|------------|-------|-----------------|------|---------|--------|
| 1 | 0000901-alpha | Alpha work | none | minor | $2 | merged |
| 2 | 0000902-beta | Beta work | none | minor | $3 | merged |
CHART_EOF
}

commit_file() { # repo file content subject
  printf '%s\n' "$3" > "$1/$2"
  git -C "$1" add -A
  git -C "$1" commit -q -m "$4"
}

new_repo() { # name
  local d="$TMP/$1"
  mkdir -p "$d"
  git -C "$d" init -q -b main
  git -C "$d" config user.email t@example.com
  git -C "$d" config user.name t
  commit_file "$d" seed.txt X "seed"
  git -C "$d" checkout -q -b "$BRANCH"
}

echo "=== REQ-004 AC-1: history check accepts merge order ==="
# Step 2 (Beta, 0.58.0) merges first, then step 1 (Alpha, 0.59.0).
new_repo a
commit_file "$TMP/a" beta.txt beta "0000902: Beta work (#11)"
git -C "$TMP/a" tag -a v0.58.0 -m "beta"
commit_file "$TMP/a" alpha.txt alpha "0000901: Alpha work (#12)"
git -C "$TMP/a" tag -a v0.59.0 -m "alpha"
commit_file "$TMP/a" admin.txt admin "0000900: Initiative admin (#13)"
git -C "$TMP/a" checkout -q main
write_chart "$TMP/chart-a.md" 0.59.0 0.58.0
OUT=$(node "$CHECK" --root "$TMP/a" --base main --head "$BRANCH" --chart "$TMP/chart-a.md" 2>&1); RC=$?
assert_equals "0" "$RC" "REQ-004 AC-1: exits 0 for steps merged 2 then 1"
assert_contains "2 step(s) matched" "$OUT" "REQ-004 AC-1: both steps matched"

echo "=== REQ-004 AC-2: reshape follows merge order ==="
OLD_TREE=$(git -C "$TMP/a" rev-parse "$BRANCH^{tree}")
OUT=$(node "$RESHAPE" --root "$TMP/a" --branch "$BRANCH" --base main --chart "$TMP/chart-a.md" 2>&1); RC=$?
assert_equals "0" "$RC" "REQ-004 AC-2: exits 0"
assert_equals "0000902: Beta work (#11)
0000901: Alpha work (#12)
0000900: Initiative admin (#13)" "$(git -C "$TMP/a" log --first-parent --reverse --format=%s main.."$NEW")" "REQ-004 AC-2: step 2 then step 1, then the chore commit"
assert_equals "$OLD_TREE" "$(git -C "$TMP/a" rev-parse "$NEW^{tree}")" "REQ-004 AC-2: the new head tree equals the old head tree"

echo "=== REQ-004: blank Versions keep chart order ==="
new_repo b
commit_file "$TMP/b" alpha.txt alpha "0000901: Alpha work (#11)"
commit_file "$TMP/b" beta.txt beta "0000902: Beta work (#12)"
git -C "$TMP/b" checkout -q main
write_chart "$TMP/chart-b.md" "" ""
OUT=$(node "$CHECK" --root "$TMP/b" --base main --head "$BRANCH" --chart "$TMP/chart-b.md" 2>&1); RC=$?
assert_equals "0" "$RC" "REQ-004: blank Versions in chart order exit 0"
OUT=$(node "$CHECK" --root "$TMP/a" --base main --head "$BRANCH" --chart "$TMP/chart-b.md" 2>&1); RC=$?
assert_equals "1" "$RC" "REQ-004: blank Versions do not reorder merge-order history"

print_summary
