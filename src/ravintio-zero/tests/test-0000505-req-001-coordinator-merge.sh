#!/usr/bin/env bash
# Tests for feature 0000505-coordinator-branch-regenerate, req-001: coordinator-merge.mjs.
# Each world is a repo with a coordinator branch `feat` and a base branch `main`.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPT="${CM_SCRIPT:-$SCRIPT_DIR/../scripts/coordinator-merge.mjs}"
INDEXER="$(dirname "$SCRIPT")/backlog-index.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

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

# make_world NAME MODE: leaves `feat` checked out, ready for the merge of `main`.
#   clean     only main changes the counter and adds an entry, so the merge is clean and the index is stale
#   conflict  both sides add an entry and change the counter, so the index and the counter conflict
#   other     both sides edit README.md, which the command does not resolve
make_world() {
  R="$WORK/$1"
  mkdir -p "$R/plan/backlog" "$R/docs/adr"
  git init -q -b main "$R"
  (
    cd "$R" || exit 1
    echo 0000010 > plan/backlog/.next-id
    echo 0301 > docs/adr/.next-id
    echo base > README.md
    write_entry . 0000001-a
    node "$INDEXER" --root . >/dev/null
    git add -A && git commit -q -m base
    git checkout -q -b feat
    if [ "$2" != clean ]; then
      write_entry . 0000002-step
      echo 0000011 > plan/backlog/.next-id
      if [ "$2" = other ]; then echo ours > README.md; fi
      node "$INDEXER" --root . >/dev/null
      git add -A && git commit -q -m ours
    fi
    git checkout -q main
    write_entry . 0000003-base
    echo 0000012 > plan/backlog/.next-id
    if [ "$2" = other ]; then echo theirs > README.md; fi
    if [ "$2" = conflict ]; then node "$INDEXER" --root . >/dev/null; fi
    git add -A && git commit -q -m theirs
    git checkout -q feat
  )
}

run_cmd() {
  OUT="$(cd "$R" && node "$SCRIPT" "$@" 2>&1)"
  CODE=$?
}

commits() { git -C "$R" rev-list --count HEAD; }

# ---------------------------------------------------------------- AC-1: a clean merge leaves a stale index
make_world clean clean
run_cmd --base main --id 0000360-backlog-sweep
assert_equals "0" "$CODE" "AC-1: the command succeeds ($OUT)"
assert_contains "regenerated: plan/backlog/index.md" "$OUT" "AC-1: the command reports the index"
(cd "$R" && node "$INDEXER" --root "$R" --check >/dev/null 2>&1)
assert_equals "0" "$?" "AC-1: the index matches a fresh run"
assert_equals "0000360-backlog-sweep: Regenerate shared files" "$(git -C "$R" log -1 --format=%s)" "AC-1: the regeneration commit uses the initiative id"
assert_equals "0000360-backlog-sweep: Merge the initiative branch" "$(git -C "$R" log -2 --format=%s | tail -1)" "AC-1: the merge commit uses the initiative id"
assert_equals "" "$(git -C "$R" status --porcelain)" "AC-1: the tree is clean"
BEFORE="$(commits)"
run_cmd --base main --id 0000360-backlog-sweep
assert_equals "0" "$CODE" "AC-1: a second run succeeds ($OUT)"
assert_equals "$BEFORE" "$(commits)" "AC-1: a second run adds no commit"

# ---------------------------------------------------------------- AC-2: a conflict on shared files
make_world conflict conflict
run_cmd --base main --id 0000360-backlog-sweep
assert_equals "0" "$CODE" "AC-2: the command succeeds ($OUT)"
assert_contains "resolved: plan/backlog/index.md" "$OUT" "AC-2: the command resolves the index"
assert_contains "resolved: plan/backlog/.next-id" "$OUT" "AC-2: the command resolves the counter"
assert_equals "0000012" "$(cat "$R/plan/backlog/.next-id")" "AC-2: the counter takes the higher value"
(cd "$R" && node "$INDEXER" --root "$R" --check >/dev/null 2>&1)
assert_equals "0" "$?" "AC-2: the index matches a fresh run"
assert_equals "" "$(git -C "$R" status --porcelain)" "AC-2: the tree is clean"
assert_equals "3" "$(git -C "$R" rev-list --parents -1 HEAD | wc -w | tr -d ' ')" "AC-2: the head is a merge commit"

# ---------------------------------------------------------------- AC-3: a conflict outside the allowlist
make_world other other
BEFORE="$(git -C "$R" rev-parse HEAD)"
run_cmd --base main --id 0000360-backlog-sweep
assert_equals "1" "$CODE" "AC-3: the command exits 1 ($OUT)"
assert_contains "README.md" "$OUT" "AC-3: the command names the file"
assert_equals "$BEFORE" "$(git -C "$R" rev-parse HEAD)" "AC-3: the branch head is unchanged"
assert_equals "" "$(git -C "$R" status --porcelain)" "AC-3: the merge is aborted and the tree is clean"

# ---------------------------------------------------------------- a dirty tree and a missing id
make_world dirty clean
echo change >> "$R/README.md"
BEFORE="$(git -C "$R" rev-parse HEAD)"
run_cmd --base main --id 0000360-backlog-sweep
assert_equals "1" "$CODE" "dirty tree: the command exits 1 ($OUT)"
assert_equals "$BEFORE" "$(git -C "$R" rev-parse HEAD)" "dirty tree: no merge starts"
git -C "$R" checkout -q -- README.md
run_cmd --base main
assert_equals "1" "$CODE" "no id: the command exits 1 when the base names no initiative ($OUT)"
run_cmd --base origin/initiative/0000360-backlog-sweep
assert_equals "1" "$CODE" "unknown ref: the command exits 1 ($OUT)"
assert_not_contains "Regenerate" "$(git -C "$R" log --format=%s -1)" "unknown ref: no commit is added"

print_summary
