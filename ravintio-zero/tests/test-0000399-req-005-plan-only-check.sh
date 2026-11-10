#!/usr/bin/env bash
# Tests for feature 0000399 REQ-005: coordinator-pr-check.mjs.
# AC-1: only plan/ files changed gives plan-only, runs the plan checks, exits non-zero if one fails.
# AC-2: any changed file outside plan/ gives full-suite, runs no check, exits 0.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPT="${COORDINATOR_PR_CHECK:-$SCRIPT_DIR/../scripts/coordinator-pr-check.mjs}"
INDEX="$SCRIPT_DIR/../scripts/backlog-index.mjs"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t

# commit_all <repo> <message> : stages every file in the temp repo and commits
commit_all() {
  (cd "$1" && git add . && git commit -q -m "$2")
}

# new_repo : prints a repo with one base commit and a fresh backlog index
new_repo() {
  local r
  r="$(mktemp -d "$TMP_ROOT/repo.XXXXXX")"
  git -C "$r" init -q
  mkdir -p "$r/plan/backlog" "$r/src"
  echo base > "$r/src/a.txt"
  node "$INDEX" --root "$r" >/dev/null 2>&1
  commit_all "$r" base
  echo "$r"
}

# run <repo> : sets OUT, ERR, RC
run() {
  local r="$1" base
  base="$(git -C "$r" rev-list --max-parents=0 HEAD)"
  OUT="$(node "$SCRIPT" "$base" --root "$r" 2>"$TMP_ROOT/err")"
  RC=$?
  ERR="$(cat "$TMP_ROOT/err")"
}

assert_nonzero() {
  if [ "$1" -ne 0 ]; then assert_equals "y" "y" "$2"; else assert_equals "y" "n" "$2"; fi
}

VALID_CHART='# Chart

**Concurrency:** 2

## Steps

| Step | Feature id | Title | Bump | Version | Status | After |
|------|-----------|-------|------|---------|--------|-------|
| 1 | 0000001 | One | minor | 1.0.0 | pending | none |
'
BAD_CHART="${VALID_CHART/pending/bogus}"

echo ""
echo "=== plan-only change ==="
r="$(new_repo)"
mkdir -p "$r/plan/current-initiative"
printf '%s' "$VALID_CHART" > "$r/plan/current-initiative/initiative.md"
commit_all "$r" change
run "$r"
assert_equals "plan-only" "$OUT" "plan-only change prints plan-only"
assert_equals "0" "$RC" "plan-only change exits 0"

echo ""
echo "=== uncommitted plan file ==="
r="$(new_repo)"
echo x > "$r/plan/note.md"
run "$r"
assert_equals "plan-only" "$OUT" "untracked plan file still prints plan-only"

echo ""
echo "=== no change ==="
r="$(new_repo)"
run "$r"
assert_equals "plan-only" "$OUT" "no change prints plan-only"

echo ""
echo "=== stale backlog index fails the check ==="
r="$(new_repo)"
mkdir -p "$r/plan/backlog/0000001-x"
printf -- '---\ntitle: x\n---\n' > "$r/plan/backlog/0000001-x/entry.md"
commit_all "$r" change
run "$r"
assert_not_contains "plan-only" "$OUT" "stale index does not print plan-only"
assert_nonzero "$RC" "stale index exits non-zero"

echo ""
echo "=== bad chart fails the check ==="
r="$(new_repo)"
mkdir -p "$r/plan/current-initiative"
printf '%s' "$BAD_CHART" > "$r/plan/current-initiative/initiative.md"
commit_all "$r" change
run "$r"
assert_not_contains "plan-only" "$OUT" "bad chart does not print plan-only"
assert_nonzero "$RC" "bad chart exits non-zero"

echo ""
echo "=== file outside plan/ ==="
r="$(new_repo)"
echo y >> "$r/src/a.txt"
mkdir -p "$r/plan/current-initiative"
printf '%s' "$BAD_CHART" > "$r/plan/current-initiative/initiative.md"
commit_all "$r" change
run "$r"
assert_equals "full-suite" "$OUT" "mixed change prints full-suite"
assert_equals "0" "$RC" "mixed change exits 0"
assert_equals "" "$ERR" "mixed change runs no check (bad chart not parsed)"

echo ""
echo "=== lookalike path outside plan/ ==="
r="$(new_repo)"
mkdir -p "$r/plans"
echo x > "$r/plans/a.md"
commit_all "$r" change
run "$r"
assert_equals "full-suite" "$OUT" "plans/ is not plan/"

print_summary
