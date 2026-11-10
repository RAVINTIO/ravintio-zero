#!/usr/bin/env bash
# Tests for feature 0000456-regenerate-shared-files-at-merge, req-001: the shared-file resolver.
# Each world is a repo where the PR branch (ours) and the base (theirs) both changed the shared files.
# The test merges the base, then calls resolveSharedConflicts on the merge in progress.

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
  cat > "$1/plan/backlog/$2/entry.md" <<EOF
---
title: "Backlog Entry: $2"
summary: "An entry."
status: "open"
priority: "high"
theme: "queue"
---
# Backlog Entry: $2

**Date filed:** 2026-11-10
EOF
}

write_table() {
  # write_table FILE UPDATED ROW...
  local f="$1" updated="$2"; shift 2
  {
    echo "# Index"
    echo
    echo "Last updated: $updated"
    echo
    echo "| ADR | Title |"
    echo "|-----|-------|"
    echo "| 0001 | first |"
    for r in "$@"; do echo "| $r |"; done
  } > "$f"
}

# make_world NAME: sets R (repo). Leaves the merge of base into feat in progress, conflicted.
make_world() {
  R="$WORK/$1"
  mkdir -p "$R/plan/backlog" "$R/docs/adr"
  git init -q -b main "$R"
  (
    cd "$R" || exit 1
    echo 0000010 > plan/backlog/.next-id
    echo 0301 > docs/adr/.next-id
    echo "base" > plan/backlog/index.md
    write_table docs/decisions-index.md base
    write_table docs/architecture-overview.md base
    echo base > other.txt
    write_entry . 0000001-a
    git add -A && git commit -q -m base
    git checkout -q -b feat
    echo 0000012 > plan/backlog/.next-id
    echo 0305 > docs/adr/.next-id
    echo "ours" > plan/backlog/index.md
    write_table docs/decisions-index.md step "0302 | step row"
    write_table docs/architecture-overview.md step
    echo ours > other.txt
    write_entry . 0000002-step
    git add -A && git commit -q -m ours
    git checkout -q main
    echo 0000015 > plan/backlog/.next-id
    echo 0303 > docs/adr/.next-id
    echo "theirs" > plan/backlog/index.md
    write_table docs/decisions-index.md base2 "0303 | base row"
    write_table docs/architecture-overview.md base2
    echo theirs > other.txt
    write_entry . 0000003-base
    git add -A && git commit -q -m theirs
    git checkout -q feat
    git merge -q main >/dev/null 2>&1
  )
}

resolve() {
  OUT="$(cd "$R" && node --input-type=module -e "
import { resolveSharedConflicts } from '$MODULE';
try { console.log(JSON.stringify(resolveSharedConflicts({ root: process.cwd() }))); }
catch (e) { console.log('ERROR: ' + e.message); process.exit(1); }
" 2>&1)"
  CODE=$?
}

unmerged() { git -C "$R" ls-files -u | cut -f2 | sort -u | tr '\n' ' '; }

# ---------------------------------------------------------------- AC-3: a file outside the allowlist
make_world other
resolve
assert_equals "1" "$CODE" "AC-3: a conflict in another file makes the resolver throw"
assert_contains "other.txt" "$OUT" "AC-3: the error names the file"

# ---------------------------------------------------------------- AC-1, AC-2: the allowlisted files
make_world shared
git -C "$R" checkout -q --theirs other.txt 2>/dev/null
git -C "$R" add other.txt
resolve
assert_equals "0" "$CODE" "the resolver succeeds when only allowlisted files conflict ($OUT)"
assert_equals "" "$(unmerged)" "every conflicted file is staged as resolved"
assert_equals "0000015" "$(cat "$R/plan/backlog/.next-id")" "AC-1: the backlog counter takes the higher number"
assert_equals "0305" "$(cat "$R/docs/adr/.next-id")" "AC-1: the ADR counter takes the higher number"
(cd "$R" && node "$INDEXER" --root "$R" --check >/dev/null 2>&1)
assert_equals "0" "$?" "AC-2: the backlog index matches a fresh run"
DECISIONS="$(cat "$R/docs/decisions-index.md")"
assert_contains "Last updated: step" "$DECISIONS" "AC-2: the decisions index keeps the step Last updated line"
assert_contains "| 0302 | step row |" "$DECISIONS" "AC-2: the decisions index keeps the step row"
assert_contains "| 0303 | base row |" "$DECISIONS" "AC-2: the decisions index keeps the base row"
assert_not_contains "<<<<<<<" "$DECISIONS" "AC-2: no conflict marker stays in the decisions index"
assert_contains "Last updated: step" "$(cat "$R/docs/architecture-overview.md")" "AC-2: the overview keeps the step Last updated line"
assert_contains "plan/backlog/.next-id" "$OUT" "the resolver reports each file it resolved"

# ---------------------------------------------------------------- a row both sides changed stops the resolver
make_world rowclash
(
  cd "$R" || exit 1
  git merge --abort 2>/dev/null
  git reset -q --hard
  git checkout -q main && sed -i.bak 's/| 0001 | first |/| 0001 | main edit |/' docs/decisions-index.md && rm -f docs/decisions-index.md.bak
  git commit -q -am "main edit"
  git checkout -q feat && sed -i.bak 's/| 0001 | first |/| 0001 | feat edit |/' docs/decisions-index.md && rm -f docs/decisions-index.md.bak
  git commit -q -am "feat edit"
  git merge -q main >/dev/null 2>&1
  git checkout -q --theirs other.txt plan/backlog/.next-id docs/adr/.next-id plan/backlog/index.md docs/architecture-overview.md 2>/dev/null
  git add other.txt plan docs/adr docs/architecture-overview.md
)
resolve
assert_equals "1" "$CODE" "a row that both sides changed makes the resolver throw"
assert_contains "decisions-index.md" "$OUT" "the error names the decisions index"

print_summary
