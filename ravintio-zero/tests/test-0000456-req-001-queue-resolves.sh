#!/usr/bin/env bash
# Tests for feature 0000456-regenerate-shared-files-at-merge, req-001: the queue resolves shared-file conflicts.
# The world has a bare remote, a clone with a queue worktree, an initiative branch with a chart, and two step
# branches that edit the same shared file. A fake `gh` performs real git merges on the remote.

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
  CLASH2="${2:-ours}"
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
    mkdir -p plan/backlog; echo 0000010 > plan/backlog/.next-id; echo base > clash.txt
    git add -A && git commit -q -m "base" && git push -q origin initiative/x
    for n in 1 2; do
      git checkout -q -b "feat/s$n" initiative/x
      echo "step $n" > "step-$n.txt"
      if [ "$n" = 1 ]; then echo 0000012 > plan/backlog/.next-id; echo ours > clash.txt; fi
      if [ "$n" = 2 ]; then echo 0000015 > plan/backlog/.next-id; echo "$CLASH2" > clash.txt; fi
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

# ---------------------------------------------------------------- AC-1: a counter conflict resolves
make_world counter ours
run_mq run --step 2 --pr 12 --root "$QUEUE"
assert_equals "0" "$CODE" "step 2 merges first ($OUT)"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "AC-1: step 1 merges although the counter conflicts ($OUT)"
assert_contains "resolved: plan/backlog/.next-id" "$OUT" "AC-1: the queue prints a resolved line"
assert_equals "0000015" "$(remote_show plan/backlog/.next-id)" "AC-1: the base holds the higher counter"
assert_equals "" "$(queue_branch)" "AC-1: the queue worktree has no branch after the merge"

# ---------------------------------------------------------------- AC-3: another conflict still stops
make_world other different
run_mq run --step 2 --pr 12 --root "$QUEUE"
assert_equals "0" "$CODE" "step 2 merges first ($OUT)"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "1" "$CODE" "AC-3: a conflict in clash.txt stops the queue"
assert_contains "merge-queue:" "$OUT" "AC-3: the stop is a merge-queue error"
assert_contains "clash.txt" "$OUT" "AC-3: the error names the file"
assert_equals "" "$(git -C "$QUEUE" ls-files -u)" "AC-3: the merge is aborted"
assert_equals "" "$(queue_branch)" "AC-3: the queue worktree has no branch after the stop"

print_summary
