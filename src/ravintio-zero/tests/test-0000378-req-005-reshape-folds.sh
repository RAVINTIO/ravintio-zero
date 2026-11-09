#!/usr/bin/env bash
# 0000378 req-005: on a replay conflict the reshape folds earlier admin commits into the next step,
# keeps a fold only when the result is clean, and never drops a hunk.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

RESHAPE="${RESHAPE:-$ZERO_DIR/scripts/reshape-initiative.mjs}"
TMP="$(mktemp -d -t ravintio_0000378_005_XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

BRANCH="initiative/0000900-demo"
NEW="$BRANCH-reshaped"

CHART="$TMP/chart.md"
cat > "$CHART" <<'CHART_EOF'
# Initiative: 0000900 - demo

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status |
|------|------------|-------|-----------------|------|---------|--------|
| 1 | 0000901-alpha | Alpha work | none | minor | 1.1.0 | merged |
| 2 | 0000902-beta | Beta work | none | minor | 1.2.0 | merged |
CHART_EOF

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
  commit_file "$d" shared.txt X "seed"
  git -C "$d" checkout -q -b "$BRANCH"
}

echo "=== REQ-005 AC-1: a fold clears the conflict ==="
# The activation commit creates act.txt. Step 1 edits it. Nothing assigns the activation commit.
new_repo a
commit_file "$TMP/a" act.txt act "0000900: activate initiative (#10)"
ACT=$(git -C "$TMP/a" rev-parse --short=7 HEAD)
commit_file "$TMP/a" act.txt act-edited "0000901: Alpha work (#11)"
git -C "$TMP/a" tag -a v1.1.0 -m "step 1"
commit_file "$TMP/a" beta.txt beta "0000902: Beta work (#12)"
git -C "$TMP/a" tag -a v1.2.0 -m "step 2"
commit_file "$TMP/a" note.txt note "0000900: queue note (#13)"
git -C "$TMP/a" checkout -q main
OUT=$(node "$RESHAPE" --root "$TMP/a" --branch "$BRANCH" --base main --chart "$CHART" 2>&1); RC=$?
assert_equals "0" "$RC" "REQ-005 AC-1: exits 0 with no --assign"
assert_contains "fold: $ACT 0000900: activate initiative (#10) into step 1" "$OUT" "REQ-005 AC-1: output names the fold"
assert_equals "0000901: Alpha work (#11)
0000902: Beta work (#12)
0000900: Initiative admin (#13)" "$(git -C "$TMP/a" log --first-parent --reverse --format=%s main.."$NEW")" "REQ-005 AC-1: one titled commit per step, then the chore commit"
assert_equals "$(git -C "$TMP/a" rev-parse "$BRANCH^{tree}")" "$(git -C "$TMP/a" rev-parse "$NEW^{tree}")" "REQ-005 AC-3: the new head tree equals the old head tree"
assert_equals "" "$(git -C "$TMP/a" branch --list "$BRANCH-fold-trial")" "REQ-005 AC-1: no scratch branch remains"

echo "=== REQ-005: a clean history prints no fold ==="
new_repo c
commit_file "$TMP/c" alpha.txt alpha "0000901: Alpha work (#11)"
git -C "$TMP/c" tag -a v1.1.0 -m "step 1"
commit_file "$TMP/c" beta.txt beta "0000902: Beta work (#12)"
git -C "$TMP/c" tag -a v1.2.0 -m "step 2"
git -C "$TMP/c" checkout -q main
OUT=$(node "$RESHAPE" --root "$TMP/c" --branch "$BRANCH" --base main --chart "$CHART" 2>&1); RC=$?
assert_equals "0" "$RC" "REQ-005: exits 0 for a clean history"
assert_not_contains "fold:" "$OUT" "REQ-005: no fold line for a clean history"
assert_equals "$(git -C "$TMP/c" rev-parse "$BRANCH^{tree}")" "$(git -C "$TMP/c" rev-parse "$NEW^{tree}")" "REQ-005 AC-3: the tree equals the old head tree"

echo "=== REQ-005 AC-2: no fold clears the conflict ==="
# Step 1 edits shared.txt from X to P. Step 2 edits it from P to Z. A later admin commit edits it from Z to Q.
# The human assigns that later commit to step 1, where it cannot replay. No earlier admin commit exists to fold.
new_repo b
commit_file "$TMP/b" shared.txt P "0000901: Alpha work (#11)"
git -C "$TMP/b" tag -a v1.1.0 -m "step 1"
commit_file "$TMP/b" shared.txt Z "0000902: Beta work (#12)"
git -C "$TMP/b" tag -a v1.2.0 -m "step 2"
commit_file "$TMP/b" shared.txt Q "0000900: late edit (#13)"
LATE=$(git -C "$TMP/b" rev-parse --short=7 HEAD)
git -C "$TMP/b" checkout -q main
OUT=$(node "$RESHAPE" --root "$TMP/b" --branch "$BRANCH" --base main --chart "$CHART" --assign "$LATE=1" 2>&1); RC=$?
assert_equals "1" "$RC" "REQ-005 AC-2: exits 1"
assert_contains "replay conflict on $LATE 0000900: late edit (#13)" "$OUT" "REQ-005 AC-2: names the conflicting commit"
assert_not_contains "fold:" "$OUT" "REQ-005 AC-2: no fold line"
assert_equals "" "$(git -C "$TMP/b" branch --list "$NEW" "$BRANCH-fold-trial")" "REQ-005 AC-2: no branch is written"

print_summary
