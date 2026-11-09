#!/usr/bin/env bash
# Tests for feature 0000411-queue-waits, req-001: the merge queue waits for GitHub before it merges.
# The world has a bare remote, a clone, an initiative branch that moved on after the step branch was
# cut, and a fake `gh` that answers slowly. It reports the old head for its first two answers and
# UNKNOWN mergeability for two more. Its first merge fails with "not mergeable", and a merge before
# any MERGEABLE answer fails hard.

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
      n="$(bump views)"
      real="$(git --git-dir "$FAKE_REMOTE" rev-parse "refs/heads/$(cat "$D/pr-$k.head")")"
      if [ "$n" -le 2 ]; then head="0000000000000000000000000000000000000000"; else head="$real"; fi
      if [ -f "$D/never-mergeable" ] || [ "$n" -le 4 ]; then
        printf '{"headRefOid":"%s","mergeable":"UNKNOWN","mergeStateStatus":"UNKNOWN"}\n' "$head"
      else
        touch "$D/saw-mergeable"
        echo "answer MERGEABLE" >> "$D/calls.log"
        printf '{"headRefOid":"%s","mergeable":"MERGEABLE","mergeStateStatus":"CLEAN"}\n' "$head"
      fi
    else
      printf '{"title":"%s","headRefName":"%s","baseRefName":"%s"}\n' \
        "$(cat "$D/pr-$k.title")" "$(cat "$D/pr-$k.head")" "$(cat "$D/pr-$k.base")"
    fi ;;
  checks)
    echo '[{"name":"ci","bucket":"pass"}]' ;;
  merge)
    [ -f "$D/saw-mergeable" ] || { echo "early merge before MERGEABLE" >&2; exit 3; }
    n="$(bump merges)"
    if [ "$n" -eq 1 ]; then echo "GraphQL: Pull Request is not mergeable (mergePullRequest)" >&2; exit 1; fi
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

# make_world NAME: sets W, CLONE, REMOTE, GH_BIN, FAKE_GH_DIR
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
    echo "later" > later.txt
    git add -A && git commit -q -m "later base work" && git push -q origin "$BASE"
  ) >/dev/null 2>&1
  write_gh_shim "$W/gh-bin"
  GH_BIN="$W/gh-bin"
  echo "0000401: First thing" > "$FAKE_GH_DIR/pr-11.title"
  echo "$HEAD_BR" > "$FAKE_GH_DIR/pr-11.head"
  echo "$BASE" > "$FAKE_GH_DIR/pr-11.base"
}

run_mq() {
  OUT="$(GH_BIN="$GH_BIN" FAKE_GH_DIR="$FAKE_GH_DIR" FAKE_REMOTE="$REMOTE" \
    MQ_POLL_MS=10 MQ_TIMEOUT_MS="${WAIT_MS:-20000}" node "$TOOL" "$@" 2>&1)"
  CODE=$?
}

# AC-1 and AC-2: a slow GitHub.
make_world slow
run_mq run --step 1 --pr 11 --root "$CLONE"
CALLS="$(cat "$FAKE_GH_DIR/calls.log")"
assert_equals "0" "$CODE" "REQ-001 AC-1: the queue waits and merges ($OUT)"
assert_contains "merged PR #11" "$OUT" "REQ-001 AC-1: the queue reports the merge"
assert_equals "2" "$(printf '%s\n' "$CALLS" | grep -c '^pr merge 11' || true)" "REQ-001 AC-2: a not-mergeable failure gets one retry"
first_merge="$(printf '%s\n' "$CALLS" | grep -n '^pr merge 11' | head -1 | cut -d: -f1)"
first_ok="$(printf '%s\n' "$CALLS" | grep -n '^answer MERGEABLE' | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$first_ok" ] && [ -n "$first_merge" ] && [ "$first_ok" -lt "$first_merge" ] && echo yes || echo no)" \
  "REQ-001 AC-2: no merge call comes before a MERGEABLE answer"
assert_equals "yes" "$([ "$(printf '%s\n' "$CALLS" | grep -c 'headRefOid' || true)" -ge 5 ] && echo yes || echo no)" \
  "REQ-001 AC-1: the queue polled past the stale head and UNKNOWN answers"
assert_equals "yes" "$([ "$(printf '%s\n' "$CALLS" | grep -c '^pr checks 11' || true)" -ge 2 ] && echo yes || echo no)" \
  "REQ-001: the queue waits for CI after the base merge push and after the version push"

# NFR-001: a wait past its limit stops with a named error.
make_world stuck
touch "$FAKE_GH_DIR/never-mergeable"
WAIT_MS=300 run_mq run --step 1 --pr 11 --root "$CLONE"
assert_equals "yes" "$([ "$CODE" -ne 0 ] && echo yes || echo no)" "NFR-001: a PR that never turns mergeable stops the queue"
assert_contains "timed out waiting for PR #11" "$OUT" "NFR-001: the stop names the PR and the wait"
assert_equals "0" "$(grep -c '^pr merge' "$FAKE_GH_DIR/calls.log" || true)" "NFR-001: the queue never merges a PR that is not mergeable"

print_summary
