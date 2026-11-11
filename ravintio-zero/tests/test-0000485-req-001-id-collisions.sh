#!/usr/bin/env bash
# Tests for feature 0000485-adr-number-collision, req-001 and req-002: the id-collisions module.
# Each world is a repo where the PR branch (feat) and the base (main) added ADRs and backlog entries
# under one id. The test merges main into feat, then runs renumberCollisions on the merge.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

MODULE="${IC_MODULE:-$SCRIPT_DIR/../scripts/id-collisions.mjs}"
SHARED="$(dirname "$MODULE")/shared-files.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

write_adr() {
  # write_adr REPO NUMBER SLUG
  cat > "$1/docs/adr/$2-$3.md" <<EOT
---
title: "ADR ${2#0}: Title $3"
status: "proposed"
---
# ADR-$2 - Title $3

**File:** \`docs/adr/$2-$3.md\`
EOT
}

write_entry() {
  mkdir -p "$1/plan/backlog/$2"
  cat > "$1/plan/backlog/$2/entry.md" <<EOT
---
title: "Backlog Entry: ${2%%-*} - $2"
summary: "An entry."
status: "open"
priority: "high"
theme: "queue"
---
# Backlog Entry: ${2%%-*} - $2

**Date filed:** 2026-11-10
EOT
}

index_row() { echo "| [ADR-$1](adr/$1-$2.md) | Title $2 | proposed | s | f |" >> "$3/docs/decisions-index.md"; }

# make_world NAME [FEAT_ADR] [BASE_ADR] [FEAT_ID] [BASE_ID]: sets R with the merge of main into feat done.
make_world() {
  R="$WORK/$1"
  local fa="${2:-0301}" ba="${3:-0301}" fi="${4:-0000010}" bi="${5:-0000010}"
  mkdir -p "$R/docs/adr" "$R/plan/backlog"
  git init -q -b main "$R"
  (
    cd "$R" || exit 1
    echo 0301 > docs/adr/.next-id
    echo 0000010 > plan/backlog/.next-id
    printf '# Decisions\n\nLast updated: base\n\n| ADR | Title | Status | Summary | Feature |\n|-----|-------|--------|---------|---------|\n' > docs/decisions-index.md
    echo base > plan/backlog/index.md
    git add -A && git commit -q -m base
    git checkout -q -b feat
    write_adr "$R" "$fa" feat-a; index_row "$fa" feat-a "$R"
    printf 'See ADR-%s for the reason.\nLink: docs/adr/%s-feat-a.md\nVersion 0.%s.0 stays.\n' "$fa" "$fa" "${fa#0}" > note.md
    write_entry "$R" "$fi-feat-e"
    echo "$(printf '%04d' $((10#$fa + 1)))" > docs/adr/.next-id
    echo "$(printf '%07d' $((10#$fi + 1)))" > plan/backlog/.next-id
    git add -A && git commit -q -m feat
    git checkout -q main
    write_adr "$R" "$ba" base-b; index_row "$ba" base-b "$R"
    write_entry "$R" "$bi-base-e"
    echo "$(printf '%04d' $((10#$ba + 1)))" > docs/adr/.next-id
    echo "$(printf '%07d' $((10#$bi + 1)))" > plan/backlog/.next-id
    git add -A && git commit -q -m main
    git checkout -q feat
    if ! git merge -q -m merge main >/dev/null 2>&1; then
      node --input-type=module -e "import { resolveSharedConflicts } from '$SHARED'; resolveSharedConflicts({ root: process.cwd() });" >/dev/null 2>&1
      git commit -q -m merge
    fi
  )
}

run_module() {
  OUT="$(cd "$R" && node --input-type=module -e "import { renumberCollisions } from '$MODULE'; console.log(JSON.stringify(renumberCollisions({ root: process.cwd() })));" 2>&1)"
  CODE=$?
}

# ---------------------------------------------------------------- REQ-001 AC-1, AC-2: a colliding ADR
make_world adr
run_module
assert_equals "0" "$CODE" "the module runs ($OUT)"
assert_contains '"kind":"adr"' "$OUT" "REQ-001 AC-1: the module reports an adr change"
assert_equals "yes" "$([ -f "$R/docs/adr/0301-base-b.md" ] && echo yes)" "REQ-001 AC-1: the base ADR keeps 0301"
assert_equals "yes" "$([ -f "$R/docs/adr/0302-feat-a.md" ] && echo yes)" "REQ-001 AC-1: the PR ADR becomes 0302"
assert_equals "" "$([ -f "$R/docs/adr/0301-feat-a.md" ] && echo yes)" "REQ-001 AC-1: the old file name is gone"
assert_contains "# ADR-0302 - Title feat-a" "$(cat "$R/docs/adr/0302-feat-a.md")" "REQ-001 AC-1: the heading holds 0302"
assert_contains 'title: "ADR 302: Title feat-a"' "$(cat "$R/docs/adr/0302-feat-a.md")" "REQ-001 AC-1: the title holds 302"
assert_contains 'docs/adr/0302-feat-a.md' "$(cat "$R/docs/adr/0302-feat-a.md")" "REQ-001 AC-1: the File line holds 0302"
assert_contains "[ADR-0302](adr/0302-feat-a.md)" "$(cat "$R/docs/decisions-index.md")" "REQ-001 AC-1: the index row holds 0302"
assert_contains "[ADR-0301](adr/0301-base-b.md)" "$(cat "$R/docs/decisions-index.md")" "REQ-001 AC-1: the base index row stays"
assert_contains "See ADR-0302 for" "$(cat "$R/note.md")" "REQ-001 AC-2: a changed file cites the new number"
assert_contains "docs/adr/0302-feat-a.md" "$(cat "$R/note.md")" "REQ-001 AC-2: a changed file links the new file"
assert_contains "Version 0.301.0 stays" "$(cat "$R/note.md")" "REQ-001 AC-2: an unrelated number stays"
assert_equals "0303" "$(cat "$R/docs/adr/.next-id")" "REQ-001 AC-2: the counter holds 0303"

# ---------------------------------------------------------------- REQ-002 AC-1: a colliding backlog entry
assert_contains '"kind":"backlog"' "$OUT" "REQ-002 AC-1: the module reports a backlog change"
assert_equals "yes" "$([ -f "$R/plan/backlog/0000010-base-e/entry.md" ] && echo yes)" "REQ-002 AC-1: the base entry keeps its id"
assert_equals "yes" "$([ -f "$R/plan/backlog/0000011-feat-e/entry.md" ] && echo yes)" "REQ-002 AC-1: the PR entry takes the next free id"
assert_contains "# Backlog Entry: 0000011 -" "$(cat "$R/plan/backlog/0000011-feat-e/entry.md")" "REQ-002 AC-1: the entry heading holds the new id"
assert_equals "0000012" "$(cat "$R/plan/backlog/.next-id")" "REQ-002 AC-1: the counter moves past the new id"
assert_contains "0000011-feat-e" "$(cat "$R/plan/backlog/index.md")" "REQ-002 AC-1: the index lists the renumbered entry"
assert_contains "0000010" "$(cat "$R/plan/backlog/index.md")" "REQ-002 AC-1: the index lists the base entry"
assert_equals "" "$(git -C "$R" status --porcelain --untracked-files=no | grep -v '^[AMDR]' )" "the changes are staged"

# ---------------------------------------------------------------- AC-3: no collision changes nothing
make_world clean 0301 0302 0000010 0000011
HEAD_BEFORE="$(git -C "$R" rev-parse HEAD)"
run_module
assert_equals "[]" "$OUT" "REQ-001 AC-3: no collision returns an empty list"
assert_equals "" "$(git -C "$R" status --porcelain)" "REQ-001 AC-3: the tree stays as it was"
assert_equals "$HEAD_BEFORE" "$(git -C "$R" rev-parse HEAD)" "REQ-001 AC-3: no new commit"

# ---------------------------------------------------------------- the counter, not the folder, can be the higher number
make_world high 0301 0301 0000010 0000010
echo 0309 > "$R/docs/adr/.next-id"; git -C "$R" commit -q --amend --no-edit -a
run_module
assert_equals "yes" "$([ -f "$R/docs/adr/0309-feat-a.md" ] && echo yes)" "the new number follows a higher counter"
assert_equals "0310" "$(cat "$R/docs/adr/.next-id")" "the counter moves past the higher number"

print_summary
