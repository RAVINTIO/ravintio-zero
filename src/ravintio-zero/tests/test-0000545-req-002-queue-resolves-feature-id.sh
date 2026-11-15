#!/usr/bin/env bash
# Tests for feature 0000545-clear-feature-id-at-ship, req-002: the queue resolves plan/.feature-id.
# World A: the PR branch (ours) deleted the file and the base (theirs) changed it.
# World B: both sides changed the file.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

MODULE="${SF_MODULE:-$SCRIPT_DIR/../scripts/shared-files.mjs}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

# make_world NAME MODE: leaves the merge of base into feat in progress, conflicted on plan/.feature-id.
make_world() {
  R="$WORK/$1"
  mkdir -p "$R/plan"
  git init -q -b main "$R"
  (
    cd "$R" || exit 1
    echo 0000001-base > plan/.feature-id
    git add -A && git commit -q -m base
    git checkout -q -b feat
    if [ "$2" = delete ]; then git rm -q plan/.feature-id; else echo 0000002-ours > plan/.feature-id; fi
    git add -A && git commit -q -m ours
    git checkout -q main
    echo 0000003-theirs > plan/.feature-id
    git add -A && git commit -q -m theirs
    git checkout -q feat
    git merge -q main >/dev/null 2>&1
  )
}

resolve() {
  node --input-type=module -e "
    import { resolveSharedConflicts } from '$MODULE';
    console.log(JSON.stringify(resolveSharedConflicts({ root: '$R' })));
  " 2>&1
}

echo "=== req-002 AC-1: a deleted file stays deleted ==="
make_world a delete
out="$(resolve)"
case "$out" in *'plan/.feature-id'*) listed=yes ;; *) listed=no ;; esac
assert_equals "yes" "$listed" "req-002 AC-1: the call lists plan/.feature-id as resolved"
if [ -e "$R/plan/.feature-id" ]; then present=yes; else present=no; fi
assert_equals "no" "$present" "req-002 AC-1: the file is absent"

echo ""
echo "=== req-002 AC-2: a held file keeps the PR text ==="
make_world b keep
resolve >/dev/null
assert_equals "0000002-ours" "$(cat "$R/plan/.feature-id" 2>/dev/null)" "req-002 AC-2: the file holds the PR branch text"

print_summary
