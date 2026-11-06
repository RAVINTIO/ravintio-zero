#!/usr/bin/env bash
# 0000353 req-001 to req-004: reshape-initiative.mjs rebuilds an initiative branch as N + 1 titled
# commits on a new branch, moves step tags without a force push, and stops on failure.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

RESHAPE="$ZERO_DIR/scripts/reshape-initiative.mjs"
TMP="$(mktemp -d -t ravintio_0000353_XXXXXX)"
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
| 3 | 0000903-gamma | Gamma work | none | minor | 1.3.0 | merged |
CHART_EOF

commit_file() { # repo file content subject
  printf '%s\n' "$3" > "$1/$2"
  git -C "$1" add -A
  git -C "$1" commit -q -m "$4"
}

# make_repo <name> [conflict]: a scratch repo with an activation commit, three tagged step
# squashes, and one coordinator commit between steps 1 and 2.
make_repo() {
  local d="$TMP/$1"
  mkdir -p "$d"
  git -C "$d" init -q -b main
  git -C "$d" config user.email t@example.com
  git -C "$d" config user.name t
  commit_file "$d" shared.txt X "seed"
  git -C "$d" checkout -q -b "$BRANCH"
  commit_file "$d" act.txt act "0000900: activate initiative (#10)"
  commit_file "$d" alpha.txt alpha "0000901: Alpha (#11)"
  git -C "$d" tag -a v1.1.0 -m "step 1"
  if [ "${2:-}" = "conflict" ]; then
    commit_file "$d" shared.txt Y "0000900: coordinator edit (#12)"
    commit_file "$d" beta.txt beta "0000902: Beta (#13)"
    printf 'Z\n' > "$d/shared.txt"
    git -C "$d" add -A && git -C "$d" commit -q --amend -m "0000902: Beta (#13)"
  else
    commit_file "$d" note.txt note "0000900: queue note (#12)"
    commit_file "$d" beta.txt beta "0000902: Beta (#13)"
  fi
  git -C "$d" tag -a v1.2.0 -m "step 2"
  commit_file "$d" gamma.txt gamma "0000903: Gamma (#14)"
  git -C "$d" tag -a v1.3.0 -m "step 3"
}

run() { # repo args...
  local d="$1"; shift
  node "$RESHAPE" --root "$d" --branch "$BRANCH" --base main --chart "$CHART" "$@" 2>&1
}

echo "=== req-001 AC-1: shape ==="
make_repo a
HEAD_BEFORE=$(git -C "$TMP/a" rev-parse HEAD)
OLD_TREE=$(git -C "$TMP/a" rev-parse "$BRANCH^{tree}")
OUT=$(run "$TMP/a" --tags); RC=$?
assert_equals "0" "$RC" "AC-1: exits 0"
assert_equals "4" "$(git -C "$TMP/a" rev-list --first-parent --count main.."$NEW")" "AC-1: four commits on the new branch"
assert_equals "0000901: Alpha work (#11)
0000902: Beta work (#13)
0000903: Gamma work (#14)
0000900: Initiative admin (#12)" "$(git -C "$TMP/a" log --first-parent --reverse --format=%s main.."$NEW")" "AC-1: titled step commits, then the chore commit"
assert_equals "$OLD_TREE" "$(git -C "$TMP/a" rev-parse "$NEW^{tree}")" "AC-1: the new head tree equals the old head tree"
assert_equals "$HEAD_BEFORE" "$(git -C "$TMP/a" rev-parse HEAD)" "AC-1: the caller's HEAD stays"
assert_equals "" "$(git -C "$TMP/a" status --porcelain)" "AC-1: the caller's tree stays clean"
assert_equals "$HEAD_BEFORE" "$(git -C "$TMP/a" rev-parse "$BRANCH")" "AC-1: the old branch stays"

echo "=== req-002 AC-1: tags move ==="
for n in 1 2 3; do
  assert_equals "$(git -C "$TMP/a" rev-parse "$NEW~$((4 - n))")" "$(git -C "$TMP/a" rev-parse "v1.$n.0^{commit}")" "AC-1: v1.$n.0 points at new step $n"
  assert_equals "step $n" "$(git -C "$TMP/a" tag -l --format='%(contents:subject)' "v1.$n.0")" "AC-1: v1.$n.0 keeps its message"
done

echo "=== req-004 AC-1: the history check ran ==="
assert_contains "check-initiative-history" "$OUT" "AC-1: the check output appears"

echo "=== req-001 AC-2: aligned admin folds in ==="
make_repo b
NOTE=$(git -C "$TMP/b" log --format=%h --grep="queue note" -1)
OUT=$(run "$TMP/b" --assign "$NOTE=3"); RC=$?
assert_equals "0" "$RC" "AC-2: exits 0"
assert_equals "4" "$(git -C "$TMP/b" rev-list --first-parent --count main.."$NEW")" "AC-2: no extra commit"
assert_contains "note.txt" "$(git -C "$TMP/b" ls-tree -r --name-only "$NEW~1")" "AC-2: step 3 holds the assigned change"
assert_not_contains "note.txt" "$(git -C "$TMP/b" ls-tree -r --name-only "$NEW~2")" "AC-2: step 2 lacks it"
assert_equals "$(git -C "$TMP/b" rev-parse v1.3.0^{commit})" "$(git -C "$TMP/b" rev-parse "$BRANCH~0")" "AC-2: without --tags the old tags stay"

echo "=== req-001 AC-3: no extra chore commit ==="
make_repo c
ACT=$(git -C "$TMP/c" log --format=%h --grep="activate initiative" -1)
NOTE=$(git -C "$TMP/c" log --format=%h --grep="queue note" -1)
OUT=$(run "$TMP/c" --assign "$ACT=1" --assign "$NOTE=3"); RC=$?
assert_equals "0" "$RC" "AC-3: exits 0"
assert_equals "3" "$(git -C "$TMP/c" rev-list --first-parent --count main.."$NEW")" "AC-3: only the step commits"
assert_equals "$(git -C "$TMP/c" rev-parse "$BRANCH^{tree}")" "$(git -C "$TMP/c" rev-parse "$NEW^{tree}")" "AC-3: the final tree is unchanged"

echo "=== req-003 AC-1: a conflict stops ==="
make_repo d conflict
OUT=$(run "$TMP/d" --tags); RC=$?
assert_equals "1" "$RC" "AC-1: exits 1"
assert_contains "0000902" "$OUT" "AC-1: names the commit"
assert_equals "" "$(git -C "$TMP/d" branch --list "$NEW")" "AC-1: no new branch"
assert_equals "$(git -C "$TMP/d" rev-parse "$BRANCH~0")" "$(git -C "$TMP/d" rev-parse v1.3.0^{commit})" "AC-1: no tag moved"

echo "=== req-003 AC-2: a missing tag stops ==="
make_repo e
git -C "$TMP/e" tag -d v1.2.0 >/dev/null
OUT=$(run "$TMP/e"); RC=$?
assert_equals "1" "$RC" "AC-2: exits 1"
assert_contains "step 2" "$OUT" "AC-2: names the step"
assert_equals "" "$(git -C "$TMP/e" branch --list "$NEW")" "AC-2: no new branch"

echo "=== req-003 AC-3: an existing branch stops ==="
make_repo f
git -C "$TMP/f" branch "$NEW" main
OUT=$(run "$TMP/f"); RC=$?
assert_equals "1" "$RC" "AC-3: exits 1"
assert_equals "$(git -C "$TMP/f" rev-parse main)" "$(git -C "$TMP/f" rev-parse "$NEW")" "AC-3: the branch is as it was"

echo "=== req-003 AC-4: a bad name stops ==="
OUT=$(node "$RESHAPE" --root "$TMP/a" --branch "--upload-pack=x" --base main --chart "$CHART" 2>&1); RC=$?
assert_equals "1" "$RC" "AC-4: a branch that starts with a dash exits 1"
OUT=$(node "$RESHAPE" --root "$TMP/a" --branch "$BRANCH" --base main --chart "$CHART" --assign "zz;ls=1" 2>&1); RC=$?
assert_equals "1" "$RC" "AC-4: a bad hash exits 1"

echo "=== req-002 AC-2: no force ==="
SRC="$(cat "$RESHAPE")"
assert_not_contains "--force" "$SRC" "AC-2: no --force"
assert_not_contains "'-f'" "$SRC" "AC-2: no -f"
assert_not_contains "+refs" "$SRC" "AC-2: no + refspec"
assert_not_contains "'+" "$SRC" "AC-2: no quoted + refspec"
assert_not_contains "execSync" "$SRC" "AC-2: no shell string"

echo "=== req-002 AC-3: push without force ==="
make_repo g
git init -q --bare "$TMP/origin.git"
git -C "$TMP/g" remote add origin "$TMP/origin.git"
git -C "$TMP/g" push -q origin "$BRANCH" --tags 2>&1
OLD_STEP1=$(git -C "$TMP/g" rev-parse v1.1.0^{commit})
OUT=$(run "$TMP/g" --push); RC=$?
assert_equals "0" "$RC" "AC-3: exits 0"
NEW_TIP=$(git -C "$TMP/g" rev-parse "$NEW")
assert_equals "$NEW_TIP" "$(git -C "$TMP/origin.git" rev-parse "$NEW")" "AC-3: origin holds the new branch"
NEW_STEP1=$(git -C "$TMP/g" rev-parse "$NEW~3")
assert_equals "$NEW_STEP1" "$(git -C "$TMP/origin.git" rev-parse 'v1.1.0^{commit}')" "AC-3: origin tag points at the new step commit"
assert_not_contains "$OLD_STEP1" "$(git -C "$TMP/origin.git" for-each-ref --format='%(*objectname)' refs/tags)" "AC-3: no origin tag points at the old step commit"

print_summary
