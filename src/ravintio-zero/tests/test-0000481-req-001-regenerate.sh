#!/usr/bin/env bash
# Tests for feature 0000481-regenerate-after-every-merge, req-001: regenerateSharedFiles.
# Each world is a repo with a clean base merge in place. The test calls the module on the merged tree.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

MODULE="${SF_MODULE:-$SCRIPT_DIR/../scripts/shared-files.mjs}"
INDEXER="$(dirname "$MODULE")/backlog-index.mjs"
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

# make_world NAME BASE_COUNTER: leaves a clean merge of main into feat. Only the base changes the
# counter and its index stays as it was, so the merge is clean and the index is stale.
make_world() {
  R="$WORK/$1"
  mkdir -p "$R/plan/backlog" "$R/docs/adr"
  git init -q -b main "$R"
  (
    cd "$R" || exit 1
    echo 0000010 > plan/backlog/.next-id
    echo 0301 > docs/adr/.next-id
    write_entry . 0000001-a
    node "$INDEXER" --root . >/dev/null
    git add -A && git commit -q -m base
    git checkout -q -b feat
    write_entry . 0000002-step
    node "$INDEXER" --root . >/dev/null
    git add -A && git commit -q -m ours
    git checkout -q main
    write_entry . 0000003-base
    echo "$2" > plan/backlog/.next-id
    git add -A && git commit -q -m theirs
    git checkout -q feat
    git merge -q -m merged main >/dev/null 2>&1
  )
}

regenerate() {
  OUT="$(cd "$R" && node --input-type=module -e "
import { regenerateSharedFiles } from '$MODULE';
try { console.log(JSON.stringify(regenerateSharedFiles({ root: process.cwd(), subject: '0000481: Regenerate shared files' }))); }
catch (e) { console.log('ERROR: ' + e.message); process.exit(1); }
" 2>&1)"
  CODE=$?
}

commits() { git -C "$R" rev-list --count HEAD; }

# ---------------------------------------------------------------- AC-1: the merge is clean and the index is stale
make_world stale 0000010
(cd "$R" && node "$INDEXER" --root "$R" --check >/dev/null 2>&1)
assert_equals "1" "$?" "setup: the clean merge leaves the index stale"
BEFORE="$(commits)"
regenerate
assert_equals "0" "$CODE" "AC-1: the module succeeds ($OUT)"
assert_contains "plan/backlog/index.md" "$OUT" "AC-1: the module reports the index"
(cd "$R" && node "$INDEXER" --root "$R" --check >/dev/null 2>&1)
assert_equals "0" "$?" "AC-1: the index matches a fresh run"
assert_equals "$((BEFORE + 1))" "$(commits)" "AC-1: the module adds one commit"
assert_equals "0000481: Regenerate shared files" "$(git -C "$R" log -1 --format=%s)" "AC-1: the commit uses the given subject"
assert_equals "" "$(git -C "$R" status --porcelain)" "AC-1: the tree is clean after the commit"

# ---------------------------------------------------------------- AC-2: a second run changes nothing
BEFORE="$(commits)"
regenerate
assert_equals "[]" "$OUT" "AC-2: a current tree reports no change"
assert_equals "$BEFORE" "$(commits)" "AC-2: a current tree adds no commit"

# ---------------------------------------------------------------- AC-3: a counter below the higher parent value
make_world counter 0000015
(
  cd "$R" || exit 1
  echo 0000011 > plan/backlog/.next-id
  git commit -q -a --amend --no-edit
)
regenerate
assert_equals "0000015" "$(cat "$R/plan/backlog/.next-id")" "AC-3: the counter rises to the higher parent value"
assert_contains "plan/backlog/.next-id" "$OUT" "AC-3: the module reports the counter"
assert_equals "0301" "$(cat "$R/docs/adr/.next-id")" "AC-3: a current counter stays as it is"

print_summary
