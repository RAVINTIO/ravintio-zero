#!/usr/bin/env bash
# Tests for feature 0000483-mergeability-before-ci-wait, req-001: the merge queue stops on a
# conflicting PR or when no check appears. The world matches test-0000411: a bare remote, a clone,
# and a fake `gh`. The fake reports mergeability from a file and lists no checks on request.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="${MQ_TOOL:-$SCRIPT_DIR/../scripts/merge-queue.mjs}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

CHART_REL="plan/current-initiative/initiative.md"
BASE="initiative/0000360-backlog-sweep"
HEAD_BR="feat/0000401-first-thing"

write_gh_shim() {
  cat > "$1" <<'SHIM'
#!/usr/bin/env bash
D="$FAKE_GH_DIR"
echo "$*" >> "$D/calls.log"
[ "$1" = "pr" ] || exit 2
sub="$2"; k="$3"
bump() { local n; n="$(cat "$D/$1" 2>/dev/null || echo 0)"; n=$((n + 1)); echo "$n" > "$D/$1"; echo "$n"; }
case "$sub" in
  view)
    if [[ "$*" == *mergeCommit* ]]; then
      printf '{"mergeCommit":{"oid":"%s"}}\n' "$(cat "$D/pr-$k.merge")"
    elif [[ "$*" == *headRefOid* ]]; then
      real="$(git --git-dir "$FAKE_REMOTE" rev-parse "refs/heads/$(cat "$D/pr-$k.head")")"
      printf '{"headRefOid":"%s","mergeable":"%s","mergeStateStatus":"CLEAN"}\n' "$real" "$(cat "$D/mergeable")"
    else
      printf '{"title":"%s","headRefName":"%s","baseRefName":"%s"}\n' \
        "$(cat "$D/pr-$k.title")" "$(cat "$D/pr-$k.head")" "$(cat "$D/pr-$k.base")"
    fi ;;
  checks)
    if [ -f "$D/no-checks" ]; then echo '[]'; exit 8; fi
    n="$(bump polls)"
    if [ "$n" -le 2 ]; then echo '[{"name":"ci","bucket":"pending"}]'; else echo '[{"name":"ci","bucket":"pass"}]'; fi ;;
  merge)
    bump merges >/dev/null
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

# make_world NAME MERGEABLE: sets W, CLONE, REMOTE, GH_BIN, FAKE_GH_DIR
make_world() {
  W="$WORK/$1"; REMOTE="$W/remote.git"; CLONE="$W/clone"; FAKE_GH_DIR="$W/gh"
  mkdir -p "$FAKE_GH_DIR"
  git init -q --bare -b main "$REMOTE"
  git clone -q "$REMOTE" "$CLONE" 2>/dev/null
  (
    cd "$CLONE" || exit 1
    git checkout -q -b "$BASE"
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
CHART
    git add -A && git commit -q -m "base" && git push -q origin "$BASE"
    git checkout -q -b "$HEAD_BR"
    echo "step 1" > step-1.txt
    git add -A && git commit -q -m "feat: step 1" && git push -q origin "$HEAD_BR"
    git checkout -q "$BASE"
  ) >/dev/null 2>&1
  write_gh_shim "$W/gh-bin"
  GH_BIN="$W/gh-bin"
  echo "0000401: First thing" > "$FAKE_GH_DIR/pr-11.title"
  echo "$HEAD_BR" > "$FAKE_GH_DIR/pr-11.head"
  echo "$BASE" > "$FAKE_GH_DIR/pr-11.base"
  echo "$2" > "$FAKE_GH_DIR/mergeable"
}

run_mq() {
  OUT="$(GH_BIN="$GH_BIN" FAKE_GH_DIR="$FAKE_GH_DIR" FAKE_REMOTE="$REMOTE" \
    MQ_POLL_MS=10 MQ_TIMEOUT_MS=20000 node "$TOOL" "$@" 2>&1)"
  CODE=$?
}

echo "=== REQ-001 AC-1: a conflicting PR with no checks stops the queue ==="
make_world conflict CONFLICTING
touch "$FAKE_GH_DIR/no-checks"
MQ_NOCHECKS_MS=60000 run_mq run --step 1 --pr 11 --root "$CLONE"
assert_equals "yes" "$([ "$CODE" -ne 0 ] && echo yes || echo no)" "AC-1: the queue exits non-zero ($OUT)"
assert_contains "PR #11 conflicts with its base branch" "$OUT" "AC-1: the error names the conflict"
assert_equals "0" "$(grep -c '^pr merge' "$FAKE_GH_DIR/calls.log" || true)" "AC-1: the queue never merges"

echo "=== REQ-001 AC-2: no check appears in time ==="
make_world nochecks MERGEABLE
touch "$FAKE_GH_DIR/no-checks"
MQ_NOCHECKS_MS=300 run_mq run --step 1 --pr 11 --root "$CLONE"
assert_equals "yes" "$([ "$CODE" -ne 0 ] && echo yes || echo no)" "AC-2: the queue exits non-zero ($OUT)"
assert_contains "no CI checks appeared on PR #11" "$OUT" "AC-2: the error names the wait"

echo "=== REQ-001 AC-3: a mergeable PR whose checks pass still completes ==="
make_world normal MERGEABLE
MQ_NOCHECKS_MS=60000 run_mq run --step 1 --pr 11 --root "$CLONE"
assert_equals "0" "$CODE" "AC-3: the queue exits 0 ($OUT)"
assert_contains "PR #11" "$OUT" "AC-3: the queue reports the PR"

print_summary
