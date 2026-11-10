#!/usr/bin/env bash
# Tests for feature 0000454-queue-failure-recovery, req-001 to req-003: the merge queue recovers after a failed run.
# The world has a bare remote, a clone with a queue worktree, an initiative branch with a chart, and two step
# branches. A fake `gh` fails the PR checks once the PR head holds a set-version commit. It records the PR branch
# history at merge time, because the merge deletes the branch.

set -uo pipefail
export MQ_POLL_MS=20

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="${MQ_TOOL:-$SCRIPT_DIR/../scripts/merge-queue.mjs}"
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
    elif [[ "$*" == *headRefOid* ]]; then
      printf '{"headRefOid":"%s","mergeable":"MERGEABLE","mergeStateStatus":"CLEAN"}\n' \
        "$(git --git-dir "$FAKE_REMOTE" rev-parse "refs/heads/$(cat "$D/pr-$k.head")" 2>/dev/null)"
    else
      printf '{"title":"%s","headRefName":"%s","baseRefName":"%s"}\n' \
        "$(cat "$D/pr-$k.title")" "$(cat "$D/pr-$k.head")" "$(cat "$D/pr-$k.base")"
    fi ;;
  checks)
    head="$(cat "$D/pr-$k.head")"
    if [ -f "$D/pr-$k.red-after-version" ] \
      && git --git-dir "$FAKE_REMOTE" log "refs/heads/$head" --format=%s | grep -q 'set version'; then
      echo '[{"name":"unit-tests","bucket":"fail"}]'; exit 1
    fi
    echo '[{"name":"unit-tests","bucket":"pass"}]'; exit 0 ;;
  merge)
    head="$(cat "$D/pr-$k.head")"; base="$(cat "$D/pr-$k.base")"
    t="$(mktemp -d)"
    git clone -q --branch "$base" "$FAKE_REMOTE" "$t/c" || exit 1
    cd "$t/c" || exit 1
    git rev-list "origin/$head" > "$D/pr-$k.history"
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

# make_world NAME: sets W, CLONE, REMOTE, QUEUE, GH_BIN, FAKE_GH_DIR
make_world() {
  W="$WORK/$1"; REMOTE="$W/remote.git"; CLONE="$W/clone"; QUEUE="$W/queue"; FAKE_GH_DIR="$W/gh"
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
    git branch -q -D feat/s1 feat/s2
    git worktree add -q --detach "$QUEUE" initiative/x
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
remote_count() { git --git-dir="$REMOTE" rev-list --count "$1"; }

# On a branch means HEAD names a ref. A detached HEAD makes symbolic-ref fail.
queue_branch() { git -C "$QUEUE" symbolic-ref -q --short HEAD; }

# ---------------------------------------------------------------- REQ-001 and REQ-003 AC-1: base moved
make_world moved
touch "$FAKE_GH_DIR/pr-11.red-after-version"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "1" "$CODE" "REQ-003 AC-1: the first run fails on the red check ($OUT)"
assert_contains "CI failed on PR #11" "$OUT" "REQ-003 AC-1: the stop names the red check"
assert_contains "set version 0.58.0 for step 1" "$(git --git-dir="$REMOTE" log feat/s1 --format=%s)" "REQ-003 AC-1: the failed run left a set-version commit"

# REQ-002 AC-1 and REQ-003 AC-2: the failed run frees the branch
assert_equals "" "$(queue_branch)" "REQ-002 AC-1: the queue worktree has no branch after a failed run"
git -C "$CLONE" worktree add -q "$W/step-1" feat/s1 >/dev/null 2>&1
assert_equals "0" "$?" "REQ-003 AC-2: another worktree checks out the step branch"
git -C "$CLONE" worktree remove --force "$W/step-1" >/dev/null 2>&1

# Step 2 merges first, so the base version moves to 0.58.0.
run_mq run --step 2 --pr 12 --root "$QUEUE"
assert_equals "0" "$CODE" "REQ-003 AC-1: step 2 merges ($OUT)"
assert_equals "" "$(queue_branch)" "REQ-002 AC-2: the queue worktree has no branch after a merge"

# The rerun of step 1 must revert the stale commit, merge the base, and set 0.59.0.
rm -f "$FAKE_GH_DIR/pr-11.red-after-version"
OLD_HEAD="$(git --git-dir="$REMOTE" rev-parse feat/s1)"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "REQ-001 AC-1: the rerun merges with no conflict ($OUT)"
assert_equals "$(cat "$FAKE_GH_DIR/pr-11.merge")" "$(remote_has_tag v0.59.0)" "REQ-001 AC-1: the rerun tags v0.59.0"
assert_contains 'version: "0.59.0"' "$(remote_show product.yml)" "REQ-001 AC-1: product.yml holds 0.59.0 on the base"
assert_contains "| 1 | 0000401-first-thing | First thing | 0000001 | minor | 0.59.0 | merged |" "$(remote_show "$CHART_REL")" "REQ-001 AC-1: the chart row holds 0.59.0"
assert_contains "revert set version 0.58.0 for step 1" "$(xargs -n1 git --git-dir="$REMOTE" log -1 --format=%s < "$FAKE_GH_DIR/pr-11.history")" "REQ-001 AC-1: the rerun reverted the stale commit"
assert_contains "$OLD_HEAD" "$(cat "$FAKE_GH_DIR/pr-11.history")" "REQ-001 AC-3: the old head stays in the PR branch history"
assert_equals "" "$(queue_branch)" "REQ-002 AC-2: the queue worktree has no branch after the rerun"

# ---------------------------------------------------------------- REQ-001 AC-2 and REQ-003 AC-3: base unchanged
make_world same
touch "$FAKE_GH_DIR/pr-11.red-after-version"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "1" "$CODE" "REQ-003 AC-3: the first run fails on the red check"
BEFORE="$(remote_count feat/s1)"
rm -f "$FAKE_GH_DIR/pr-11.red-after-version"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "REQ-001 AC-2: the rerun merges ($OUT)"
assert_equals "$BEFORE" "$(wc -l < "$FAKE_GH_DIR/pr-11.history" | tr -d ' ')" "REQ-001 AC-2: the rerun added no commit to the PR branch"
assert_equals "$(cat "$FAKE_GH_DIR/pr-11.merge")" "$(remote_has_tag v0.58.0)" "REQ-001 AC-2: the rerun tags v0.58.0"

print_summary
