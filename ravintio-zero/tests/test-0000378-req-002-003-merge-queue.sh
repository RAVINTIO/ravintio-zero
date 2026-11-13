#!/usr/bin/env bash
# Tests for feature 0000378-merge-time-versioning, req-002 (title check) and req-003 (merge queue).
# Each world is a temp bare remote, a clone, an initiative branch with a chart, two step branches,
# and a fake `gh` shim that performs real git merges on the bare remote.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="$SCRIPT_DIR/../scripts/merge-queue.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

CHART_REL="plan/current-initiative/initiative.md"

write_gh_shim() {
  cat > "$1" <<'SHIM'
#!/usr/bin/env bash
D="$FAKE_GH_DIR"
echo "$*" >> "$D/calls.log"
[ "$1" = "pr" ] || exit 2
sub="$2"; k="$3"
case "$sub" in
  view)
    if [[ "$*" == *mergeCommit* ]]; then
      printf '{"mergeCommit":{"oid":"%s"}}\n' "$(cat "$D/pr-$k.merge")"
    else
      printf '{"title":"%s","headRefName":"%s","baseRefName":"%s"}\n' \
        "$(cat "$D/pr-$k.title")" "$(cat "$D/pr-$k.head")" "$(cat "$D/pr-$k.base")"
    fi ;;
  checks)
    [ -f "$D/pr-$k.red" ] && exit 1
    exit 0 ;;
  merge)
    head="$(cat "$D/pr-$k.head")"; base="$(cat "$D/pr-$k.base")"
    t="$(mktemp -d)"
    git clone -q --branch "$base" "$FAKE_REMOTE" "$t/c" || exit 1
    cd "$t/c" || exit 1
    git merge --squash "origin/$head" >/dev/null || exit 1
    git commit -q -m "$(cat "$D/pr-$k.title")" || exit 1
    git rev-parse HEAD > "$D/pr-$k.merge"
    git push -q origin "$base" || exit 1
    git push -q origin --delete "$head" || exit 1
    rm -rf "$t" ;;
  *) exit 2 ;;
esac
SHIM
  chmod +x "$1"
}

# make_world NAME: sets W, CLONE, REMOTE, GH_BIN, FAKE_GH_DIR
make_world() {
  W="$WORK/$1"; REMOTE="$W/remote.git"; CLONE="$W/clone"; FAKE_GH_DIR="$W/gh"
  mkdir -p "$FAKE_GH_DIR"
  git init -q --bare -b main "$REMOTE"
  git clone -q "$REMOTE" "$CLONE" 2>/dev/null
  (
    cd "$CLONE" || exit 1
    git checkout -q -b initiative/x
    mkdir -p docs ravintio-zero plan/current-initiative
    printf -- '---\nversion: "0.57.0"\n---\n# About\n\n| Version | `0.57.0` |\n' > docs/about.md
    printf 'id: demo\nversion: "0.57.0"\n' > product.yml
    printf 'id: demo\nversion: "0.57.0"\n' > ravintio-zero/component.yml
    cat > "$CHART_REL" <<'CHART'
# Initiative: demo

**Status:** active
**Position:** 1

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status |
|------|------------|-------|-----------------|------|---------|--------|
| 1 | 0000401-first-thing | First thing | 0000001 | minor | | pending |
| 2 | 0000402-second-thing | Second thing | 0000002 | minor | | pending |
| 3 | 0000403-third-thing | Third thing | 0000003 | patch | | pending |

## Notes

Closing text.
CHART
    git add -A && git commit -q -m "base" && git push -q origin initiative/x
    for n in 1 2; do
      git checkout -q -b "feat/s$n" initiative/x
      echo "step $n" > "step-$n.txt"
      git add -A && git commit -q -m "feat: step $n" && git push -q origin "feat/s$n"
    done
    git checkout -q initiative/x
  ) >/dev/null 2>&1
  write_gh_shim "$W/gh-bin"
  GH_BIN="$W/gh-bin"
  new_pr 11 "0000401: First thing" feat/s1
  new_pr 12 "0000402: Second thing" feat/s2
}

new_pr() {
  echo "$2" > "$FAKE_GH_DIR/pr-$1.title"
  echo "$3" > "$FAKE_GH_DIR/pr-$1.head"
  echo "initiative/x" > "$FAKE_GH_DIR/pr-$1.base"
}

run_mq() {
  OUT="$(GH_BIN="$GH_BIN" FAKE_GH_DIR="$FAKE_GH_DIR" FAKE_REMOTE="$REMOTE" node "$TOOL" "$@" 2>&1)"
  CODE=$?
}

remote_has_tag() { git --git-dir="$REMOTE" rev-parse -q --verify "refs/tags/$1^{commit}" 2>/dev/null; }
remote_show() { git --git-dir="$REMOTE" show "initiative/x:$1" 2>/dev/null; }
base_commits() { git --git-dir="$REMOTE" rev-list --count initiative/x; }

# ---------------------------------------------------------------- REQ-002 title subcommand
make_world t
CH="$CLONE/$CHART_REL"
run_mq title --step 2 --title "0000402: Second thing" --chart "$CH"
assert_equals "0" "$CODE" "REQ-002 AC-1: matching title exits 0"

run_mq title --step 2 --title "0000402-second-thing: Second thing" --chart "$CH"
assert_equals "1" "$CODE" "REQ-002 AC-2: slug in the title exits 1"
assert_contains "0000402: Second thing" "$OUT" "REQ-002 AC-2: the expected title is printed"

run_mq title --step 2 --title "0000402: second thing" --chart "$CH"
assert_equals "1" "$CODE" "REQ-002: a case difference exits 1"

run_mq title --step 9 --title "x" --chart "$CH"
assert_equals "1" "$CODE" "REQ-002: an unknown step exits 1"

run_mq title --step 2 --title ".*" --chart "$CH"
assert_equals "1" "$CODE" "REQ-002: regex characters in the title are plain text"

# ---------------------------------------------------------------- REQ-003 versions subcommand
run_mq versions --root "$CLONE"
assert_equals "0" "$CODE" "REQ-003: versions passes on matching files"
printf 'id: demo\nversion: "0.50.0"\n' > "$CLONE/product.yml"
run_mq versions --root "$CLONE"
assert_equals "1" "$CODE" "REQ-003: versions exits 1 on a difference"

# ---------------------------------------------------------------- REQ-003 AC-1 reverse order
make_world ac1
run_mq run --step 2 --pr 12 --root "$CLONE"
assert_equals "0" "$CODE" "REQ-003 AC-1: step 2 run exits 0 ($OUT)"
run_mq run --step 1 --pr 11 --root "$CLONE"
assert_equals "0" "$CODE" "REQ-003 AC-1: step 1 run exits 0 ($OUT)"

T2="$(remote_has_tag v0.58.0)"; T1="$(remote_has_tag v0.59.0)"
assert_equals "$(cat "$FAKE_GH_DIR/pr-12.merge")" "$T2" "REQ-003 AC-1: v0.58.0 points at the step 2 merge commit"
assert_equals "$(cat "$FAKE_GH_DIR/pr-11.merge")" "$T1" "REQ-003 AC-1: v0.59.0 points at the step 1 merge commit"
assert_contains 'version: "0.59.0"' "$(remote_show product.yml)" "REQ-003 AC-1: product.yml holds 0.59.0 on the base"
assert_contains '`0.59.0`' "$(remote_show docs/about.md)" "REQ-003 AC-1: about.md holds 0.59.0 on the base"
assert_contains 'version: "0.59.0"' "$(remote_show ravintio-zero/component.yml)" "REQ-003 AC-1: component.yml holds 0.59.0 on the base"
assert_contains "$(cat "$FAKE_GH_DIR/pr-12.merge")" "$(git --git-dir="$REMOTE" rev-list initiative/x | tr '\n' ' ')" "REQ-003 AC-1: the step 2 merge commit is on the base"
assert_contains "$(cat "$FAKE_GH_DIR/pr-11.merge")" "$OUT" "REQ-003: the merge commit sha is printed"

# AC-3
CHART_OUT="$(remote_show "$CHART_REL")"
assert_contains "| 2 | 0000402-second-thing | Second thing | 0000002 | minor | 0.58.0 | merged |" "$CHART_OUT" "REQ-003 AC-3: step 2 row holds version and merged"
assert_contains "| 1 | 0000401-first-thing | First thing | 0000001 | minor | 0.59.0 | merged |" "$CHART_OUT" "REQ-003 AC-3: step 1 row holds version and merged"
assert_contains "| 3 | 0000403-third-thing | Third thing | 0000003 | patch | | pending |" "$CHART_OUT" "REQ-003 AC-3: step 3 row is untouched"
assert_contains "**Position:** 1" "$CHART_OUT" "REQ-003 AC-3: Position is left alone"
assert_contains "## Merges" "$CHART_OUT" "REQ-003 AC-3: a Merges table exists"
assert_equals "1" "$(echo "$CHART_OUT" | grep -c '^| 2 | #12 ')" "REQ-003 AC-3: one Merges row for step 2"
assert_equals "1" "$(echo "$CHART_OUT" | grep -c '^| 1 | #11 ')" "REQ-003 AC-3: one Merges row for step 1"
assert_contains "tag v0.58.0" "$CHART_OUT" "REQ-003 AC-3: the Merge commit cell names the tag"
assert_contains "Closing text." "$CHART_OUT" "REQ-003: text after the Steps table survives"
assert_equals "2" "$(echo "$CHART_OUT" | grep -c '[0-9]T[0-9:]*Z')" "REQ-003 AC-3: Merged at holds a UTC time per row"

# ---------------------------------------------------------------- REQ-003 AC-2 failures
make_world ac2a
new_pr 12 "0000402-second-thing: Second thing" feat/s2
BEFORE="$(base_commits)"
run_mq run --step 2 --pr 12 --root "$CLONE"
assert_equals "1" "$CODE" "REQ-003 AC-2: a slug in the PR title exits 1"
assert_contains "0000402: Second thing" "$OUT" "REQ-003 AC-2: the expected title is printed"
assert_equals "$BEFORE" "$(base_commits)" "REQ-003 AC-2: nothing merged on a title mismatch"
assert_equals "" "$(git --git-dir="$REMOTE" tag -l)" "REQ-003 AC-2: no tag on a title mismatch"
assert_not_contains "pr merge" "$(cat "$FAKE_GH_DIR/calls.log")" "REQ-003 AC-2: gh was not asked to merge"

make_world ac2b
chmod 444 "$CLONE/product.yml"
BEFORE="$(base_commits)"
run_mq run --step 2 --pr 12 --root "$CLONE"
assert_equals "1" "$CODE" "REQ-003 AC-2: a version file that cannot take the version exits 1"
assert_equals "$BEFORE" "$(base_commits)" "REQ-003 AC-2: nothing merged when a version file differs"
assert_equals "" "$(git --git-dir="$REMOTE" tag -l)" "REQ-003 AC-2: no tag when a version file differs"
chmod 644 "$CLONE/product.yml"

make_world ac2c
touch "$FAKE_GH_DIR/pr-12.red"
BEFORE="$(base_commits)"
run_mq run --step 2 --pr 12 --root "$CLONE"
assert_equals "1" "$CODE" "REQ-003: a red check exits 1"
assert_equals "$BEFORE" "$(base_commits)" "REQ-003: nothing merged on a red check"

make_world ac2d
echo dirty >> "$CLONE/product.yml"
run_mq run --step 2 --pr 12 --root "$CLONE"
assert_equals "1" "$CODE" "REQ-003: a dirty tree exits 1"

# ---------------------------------------------------------------- REQ-003 gh arguments and no force
make_world args
run_mq run --step 2 --pr 12 --root "$CLONE"
assert_equals "0" "$CODE" "REQ-003: run exits 0 ($OUT)"
assert_contains "pr merge 12 --squash --delete-branch" "$(cat "$FAKE_GH_DIR/calls.log")" "REQ-003: the PR number is one argument to gh pr merge"
assert_contains "pr checks 12 --watch --fail-fast" "$(cat "$FAKE_GH_DIR/calls.log")" "REQ-003: CI is watched with fail-fast"
assert_equals "" "$(grep -n -e '--force' -e '"-f"' "$TOOL" | grep -v '^[0-9]*: *//\|^[0-9]*: *\*')" "REQ-003: the script holds no force push"

print_summary
