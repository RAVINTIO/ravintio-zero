#!/usr/bin/env bash
# Tests for feature 0000464-merge-queue-test-gaps, req-003: `run` refuses a head or base name that
# starts with a dash before any git call uses it. The world is the one of the req-001 test. A fake
# `gh` answers `pr view` with the names the test sets.

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
    echo '[{"name":"unit-tests","bucket":"pass"}]'; exit 0 ;;
  merge)
    if [ -f "$D/pr-$k.fail-merge" ]; then
      rm -f "$D/pr-$k.fail-merge"
      echo "transient merge refusal" >&2; exit 1
    fi
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

## Notes

Closing text.
CHART
    git add -A && git commit -q -m "base" && git push -q origin initiative/x
    git checkout -q -b feat/s1 initiative/x
    echo "step 1" > step-1.txt
    git add -A && git commit -q -m "feat: step 1" && git push -q origin feat/s1
    git checkout -q initiative/x
    git branch -q -D feat/s1
    git worktree add -q --detach "$QUEUE" initiative/x
  ) >/dev/null 2>&1
  write_gh_shim "$W/gh-bin"
  GH_BIN="$W/gh-bin"
  echo "0000401: First thing" > "$FAKE_GH_DIR/pr-11.title"
  echo "feat/s1" > "$FAKE_GH_DIR/pr-11.head"
  echo "initiative/x" > "$FAKE_GH_DIR/pr-11.base"
}

run_mq() {
  OUT="$(GH_BIN="$GH_BIN" FAKE_GH_DIR="$FAKE_GH_DIR" FAKE_REMOTE="$REMOTE" node "$TOOL" "$@" 2>&1)"
  CODE=$?
}

remote_has_tag() { git --git-dir="$REMOTE" rev-parse -q --verify "refs/tags/$1^{commit}" 2>/dev/null; }
remote_count() { git --git-dir="$REMOTE" rev-list --count "$1"; }

# A wrapper that logs each call, so a test can see which commands ran.
write_git_logger() {
  cat > "$1" <<'LOGGER'
#!/usr/bin/env bash
echo "$*" >> "$GIT_CALL_LOG"
exec git "$@"
LOGGER
  chmod +x "$1"
}
write_git_logger "$WORK/git-logger"
export GIT_BIN="$WORK/git-logger"

# ---------------------------------------------------------------- AC-1: a dash head is refused
make_world dashhead
export GIT_CALL_LOG="$W/git.log"; : > "$GIT_CALL_LOG"
echo "-fhead" > "$FAKE_GH_DIR/pr-11.head"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "1" "$CODE" "AC-1: a head that starts with a dash stops the run ($OUT)"
assert_contains "merge-queue:" "$OUT" "AC-1: the stop is a merge-queue error"
assert_contains "headRefName" "$OUT" "AC-1: the error names the head field"
assert_contains "-fhead" "$OUT" "AC-1: the error names the value"
assert_not_contains "fetch" "$(cat "$GIT_CALL_LOG")" "AC-1: no git fetch ran"

# ---------------------------------------------------------------- AC-2: a dash base is refused
make_world dashbase
export GIT_CALL_LOG="$W/git.log"; : > "$GIT_CALL_LOG"
echo "--base" > "$FAKE_GH_DIR/pr-11.base"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "1" "$CODE" "AC-2: a base that starts with a dash stops the run ($OUT)"
assert_contains "merge-queue:" "$OUT" "AC-2: the stop is a merge-queue error"
assert_contains "baseRefName" "$OUT" "AC-2: the error names the base field"
assert_contains "--base" "$OUT" "AC-2: the error names the value"
assert_not_contains "fetch" "$(cat "$GIT_CALL_LOG")" "AC-2: no git fetch ran"

# ---------------------------------------------------------------- AC-3: ordinary names pass
make_world plain
export GIT_CALL_LOG="$W/git.log"; : > "$GIT_CALL_LOG"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "AC-3: ordinary names merge ($OUT)"
assert_not_contains "RefName" "$OUT" "AC-3: the dash check adds no error"

print_summary
