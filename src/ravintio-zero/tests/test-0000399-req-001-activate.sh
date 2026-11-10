#!/usr/bin/env bash
# Tests for feature 0000399 REQ-001: initiative-activate.mjs.
# AC-1: the run order and the printed commands. AC-2: a failed check blocks.
# AC-3: a dry run changes nothing. Also: a rerun resumes at the PR step.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPT="${INITIATIVE_ACTIVATE:-$SCRIPT_DIR/../scripts/initiative-activate.mjs}"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.test
export GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.test
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

ID="0000500-demo"
BRANCH="initiative/$ID"

# Fake gh: records calls, fakes auth status, pr create, pr list, pr checks, pr merge.
FAKE_BIN="$TMP_ROOT/bin"
mkdir -p "$FAKE_BIN"
cat > "$FAKE_BIN/gh" <<'GH'
#!/usr/bin/env bash
echo "$*" >> "$GH_LOG"
case "$1 $2" in
  "auth status") [ -n "${FAKE_GH_NO_AUTH:-}" ] && exit 1; exit 0 ;;
  "pr create")
    [ -n "${FAKE_GH_FAIL_CREATE:-}" ] && { echo "boom" >&2; exit 1; }
    touch "$GH_LOG.pr"; echo "https://example.test/o/r/pull/7"; exit 0 ;;
  "pr list") [ -f "$GH_LOG.pr" ] && echo 7; exit 0 ;;
  "pr checks") [ -n "${FAKE_GH_CHECKS_FAIL:-}" ] && exit 1; exit 0 ;;
  "pr merge") exit 0 ;;
esac
exit 0
GH
chmod +x "$FAKE_BIN/gh"

# new_repo : prints a dir holding a bare origin.git and a work repo with one charted draft.
new_repo() {
  local d; d="$(mktemp -d "$TMP_ROOT/r.XXXXXX")"
  git init -q --bare -b main "$d/origin.git"
  git init -q -b main "$d/work"
  mkdir -p "$d/work/plan/roadmap/$ID"
  cat > "$d/work/plan/roadmap/$ID/initiative.md" <<'MD'
---
title: "Initiative: 0000500 - demo"
status: "charted"  # proposed | charted | active | delivered | blocked
---
# Initiative: 0000500 - demo

**Branch:** initiative/0000500-demo
**Status:** charted
MD
  (cd "$d/work" && git add -A && git commit -q -m init && git remote add origin "$d/origin.git" && git push -q origin main)
  echo "$d"
}

# activate <dir> [args...] : runs in the work repo. Output in <dir>/out, exit code in <dir>/code.
# Extra env goes in $ENVX, for example ENVX="FAKE_GH_CHECKS_FAIL=1".
activate() {
  local d="$1"; shift
  (cd "$d/work" && env GH_LOG="$d/gh.log" PATH="$FAKE_BIN:$PATH" ${ENVX:-} node "$SCRIPT" "$@" > "$d/out" 2>&1)
  echo $? > "$d/code"
}
code() { cat "$1/code"; }

remote_has() { git -C "$1/origin.git" rev-parse --verify -q "refs/heads/$2" >/dev/null && echo y || echo n; }
log_line() { grep -n -m1 -- "$2" "$1/gh.log" | cut -d: -f1; }

echo ""
echo "=== AC-1: activation runs in order ==="
d="$(new_repo)"
main_sha="$(git -C "$d/work" rev-parse main)"
activate "$d" --yes
assert_equals "0" "$(code "$d")" "AC-1: exits 0"
assert_equals "y" "$(remote_has "$d" "$BRANCH")" "AC-1: initiative branch on origin"
assert_equals "$main_sha" "$(git -C "$d/origin.git" rev-parse "$BRANCH")" "AC-1: initiative branch pushed unchanged"
assert_equals "y" "$(remote_has "$d" "feat/$ID-activate")" "AC-1: feature branch on origin"
a="$(log_line "$d" "auth status")"; c="$(log_line "$d" "pr create")"
k="$(log_line "$d" "pr checks")"; m="$(log_line "$d" "pr merge")"
if [ -n "$a" ] && [ -n "$c" ] && [ -n "$k" ] && [ -n "$m" ] && [ "$a" -lt "$c" ] && [ "$c" -lt "$k" ] && [ "$k" -lt "$m" ]; then
  assert_equals "y" "y" "AC-1: gh runs auth, create, checks, merge in order"
else
  assert_equals "y" "n" "AC-1: gh runs auth, create, checks, merge in order"
fi
assert_contains "--base $BRANCH" "$(cat "$d/gh.log")" "AC-1: PR targets the initiative branch"
assert_contains "$ID: activate initiative" "$(cat "$d/gh.log")" "AC-1: PR title"
assert_contains "pr checks 7 --watch" "$(cat "$d/gh.log")" "AC-1: waits with pr checks --watch"
assert_contains "pr merge 7 --squash --delete-branch" "$(cat "$d/gh.log")" "AC-1: squash merge with branch delete"
assert_contains 'status: "active"' "$(git -C "$d/work" show "feat/$ID-activate:plan/current-initiative/initiative.md")" "AC-1: active initiative written"
assert_not_contains "plan/roadmap/$ID" "$(git -C "$d/work" ls-tree -r --name-only "feat/$ID-activate")" "AC-1: draft folder deleted"
assert_contains "node ravintio-zero/scripts/initiative-run.mjs" "$(cat "$d/out")" "AC-1: prints driver command"
assert_contains "node ravintio-zero/scripts/initiative-watch.mjs" "$(cat "$d/out")" "AC-1: prints watcher command"
assert_not_contains "--force" "$(cat "$d/gh.log")" "AC-1: no force flag to gh"

echo ""
echo "=== AC-2: a failed check blocks before any change ==="
d="$(new_repo)"; git -C "$d/work" remote remove origin
activate "$d" --yes
assert_equals "1" "$(code "$d")" "AC-2: no origin exits 1"
assert_contains "I-B Activate: Blocked: no remote named origin" "$(cat "$d/out")" "AC-2: names the missing remote"
assert_equals "" "$(git -C "$d/work" branch --list 'initiative/*' 'feat/*')" "AC-2: no branch cut"
assert_equals "n" "$(remote_has "$d" "$BRANCH")" "AC-2: nothing pushed"

d="$(new_repo)"
ENVX="FAKE_GH_NO_AUTH=1" activate "$d" --yes
assert_equals "1" "$(code "$d")" "AC-2: gh auth failure exits 1"
assert_contains "I-B Activate: Blocked:" "$(cat "$d/out")" "AC-2: gh auth failure is Blocked"
assert_equals "n" "$(remote_has "$d" "$BRANCH")" "AC-2: gh failure pushes nothing"

d="$(new_repo)"
mkdir -p "$d/work/plan/current-initiative"
printf -- '---\nstatus: "active"\n---\n# Initiative: 0000360 - other\n' > "$d/work/plan/current-initiative/initiative.md"
git -C "$d/work" add -A && git -C "$d/work" commit -q -m other
activate "$d" --yes
assert_equals "1" "$(code "$d")" "AC-2: another active initiative exits 1"
assert_contains "Blocked:" "$(cat "$d/out")" "AC-2: active initiative is Blocked"
assert_equals "n" "$(remote_has "$d" "$BRANCH")" "AC-2: active initiative pushes nothing"

echo ""
echo "=== AC-3: dry run changes nothing ==="
d="$(new_repo)"
head_sha="$(git -C "$d/work" rev-parse HEAD)"
activate "$d" --dry-run
assert_equals "0" "$(code "$d")" "AC-3: exits 0"
assert_contains "initiative/$ID" "$(cat "$d/out")" "AC-3: prints the plan"
assert_contains "pr merge" "$(cat "$d/out")" "AC-3: plan names the merge"
assert_equals "" "$(git -C "$d/work" branch --list 'initiative/*' 'feat/*')" "AC-3: no local branch"
assert_equals "n" "$(remote_has "$d" "$BRANCH")" "AC-3: no remote branch"
assert_equals "$head_sha" "$(git -C "$d/work" rev-parse HEAD)" "AC-3: HEAD unchanged"
assert_equals "" "$(git -C "$d/work" status --porcelain)" "AC-3: working tree clean"
assert_not_contains "pr create" "$(cat "$d/gh.log" 2>/dev/null)" "AC-3: no PR opened"
assert_not_contains "pr merge" "$(cat "$d/gh.log" 2>/dev/null)" "AC-3: no merge"

echo ""
echo "=== failed PR checks block and do not merge ==="
d="$(new_repo)"
ENVX="FAKE_GH_CHECKS_FAIL=1" activate "$d" --yes
assert_equals "1" "$(code "$d")" "failed checks exit 1"
assert_contains "I-B Activate: Blocked:" "$(cat "$d/out")" "failed checks print Blocked"
assert_not_contains "pr merge" "$(cat "$d/gh.log")" "failed checks never merge"

echo ""
echo "=== rerun after a stop resumes at the PR step ==="
d="$(new_repo)"
ENVX="FAKE_GH_FAIL_CREATE=1" activate "$d" --yes
assert_equals "1" "$(code "$d")" "stop: first run exits 1"
assert_equals "y" "$(remote_has "$d" "$BRANCH")" "stop: initiative branch already pushed"
: > "$d/gh.log"
activate "$d" --yes
assert_equals "0" "$(code "$d")" "resume: rerun exits 0"
assert_contains "resum" "$(cat "$d/out")" "resume: output says it resumes"
assert_contains "pr merge 7 --squash --delete-branch" "$(cat "$d/gh.log")" "resume: merges the PR"
assert_equals "1" "$(git -C "$d/work" log --format=%s "$BRANCH..feat/$ID-activate" | wc -l | tr -d ' ')" "resume: one activation commit"
assert_contains "node ravintio-zero/scripts/initiative-run.mjs" "$(cat "$d/out")" "resume: prints driver command"

print_summary
