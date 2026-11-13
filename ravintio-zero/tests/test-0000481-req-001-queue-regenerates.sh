#!/usr/bin/env bash
# Tests for feature 0000481-regenerate-after-every-merge, req-001: the queue regenerates shared files after a clean base merge.
# The world has a bare remote, a clone with a queue worktree, and two step branches that edit no common file.
# A fake `gh` performs real git merges on the remote.

set -uo pipefail
export MQ_POLL_MS=20

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="${MQ_TOOL:-$SCRIPT_DIR/../scripts/merge-queue.mjs}"
INDEXER="$SCRIPT_DIR/../scripts/backlog-index.mjs"
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

write_entry() {
  mkdir -p "$1/plan/backlog/$2"
  cat > "$1/plan/backlog/$2/entry.md" <<EOT
---
title: "Backlog Entry: $2"
summary: "An entry."
status: "open"
priority: "high"
theme: "queue"
---
# Backlog Entry: $2

**Date filed:** 2026-11-10
EOT
}

# make_world NAME: sets W, CLONE, REMOTE, QUEUE, GH_BIN, FAKE_GH_DIR.
# Step 1 adds an entry and rebuilds the index. Step 2 adds an entry and leaves the index as it was.
make_world() {
  W="$WORK/$1"; REMOTE="$W/remote.git"; CLONE="$W/clone"; QUEUE="$W/queue"; FAKE_GH_DIR="$W/gh"
  mkdir -p "$FAKE_GH_DIR"
  git init -q --bare -b main "$REMOTE"
  git clone -q "$REMOTE" "$CLONE" 2>/dev/null
  (
    cd "$CLONE" || exit 1
    git checkout -q -b initiative/x
    mkdir -p docs ravintio-zero plan/current-initiative plan/backlog
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

## Notes

Closing text.
CHART
    echo 0000010 > plan/backlog/.next-id
    write_entry . 0000001-a
    node "$INDEXER" --root . >/dev/null
    git add -A && git commit -q -m "base" && git push -q origin initiative/x
    git checkout -q -b feat/s1 initiative/x
    write_entry . 0000011-step-one
    node "$INDEXER" --root . >/dev/null
    git add -A && git commit -q -m "feat: step 1" && git push -q origin feat/s1
    git checkout -q -b feat/s2 initiative/x
    git reset -q --hard initiative/x
    write_entry . 0000012-step-two
    git add -A && git commit -q -m "feat: step 2" && git push -q origin feat/s2
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

# The subjects of a PR branch at the time of the squash. The fake gh records the history.
pr_subjects() { xargs -I{} git --git-dir="$REMOTE" log -1 --format=%s {} < "$FAKE_GH_DIR/pr-$1.history"; }
remote_show() { git --git-dir="$REMOTE" show "initiative/x:$1" 2>/dev/null; }

# ---------------------------------------------------------------- AC-1: a clean merge leaves a stale index
make_world stale
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "step 1 merges first ($OUT)"
run_mq run --step 2 --pr 12 --root "$QUEUE"
assert_equals "0" "$CODE" "AC-1: step 2 merges after a clean base merge ($OUT)"
assert_contains "regenerated: plan/backlog/index.md" "$OUT" "AC-1: the queue prints a regenerated line"
assert_contains "0000012-step-two" "$(remote_show plan/backlog/index.md)" "AC-1: the base index lists the step 2 entry"
assert_contains "0000402: Regenerate shared files" "$(pr_subjects 12)" "AC-1: the PR branch holds the regeneration commit"

# ---------------------------------------------------------------- AC-2: a current index adds no commit
make_world current
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "step 1 merges ($OUT)"
assert_not_contains "regenerated:" "$OUT" "AC-2: a merge that leaves every file current prints no regenerated line"
assert_not_contains "Regenerate shared files" "$(pr_subjects 11)" "AC-2: no regeneration commit on the PR branch"

print_summary
