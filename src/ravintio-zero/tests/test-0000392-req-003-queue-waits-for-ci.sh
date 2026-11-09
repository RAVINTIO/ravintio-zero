#!/usr/bin/env bash
# Tests for feature 0000392, req-003: the queue waits for CI on the version commit.
# Each world is a temp bare remote, a clone, and a fake `gh` that performs real git work.

set -uo pipefail
export MQ_POLL_MS=20

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="$SCRIPT_DIR/../scripts/merge-queue.mjs"
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
      # 0000411: the queue waits for GitHub to show the pushed head and a mergeable PR.
      printf '{"headRefOid":"%s","mergeable":"MERGEABLE","mergeStateStatus":"CLEAN"}\n' \
        "$(git --git-dir "$FAKE_REMOTE" rev-parse "refs/heads/$(cat "$D/pr-$k.head")" 2>/dev/null)"
    else
      printf '{"title":"%s","headRefName":"%s","baseRefName":"%s"}\n' \
        "$(cat "$D/pr-$k.title")" "$(cat "$D/pr-$k.head")" "$(cat "$D/pr-$k.base")"
    fi ;;
  checks)
    if [ -f "$D/pr-$k.red" ]; then
      echo '[{"name":"unit-tests","bucket":"fail"}]'; exit 1
    fi
    if [ -f "$D/pr-$k.pending" ] && [ "$(cat "$D/pr-$k.pending")" -gt 0 ]; then
      echo $(( $(cat "$D/pr-$k.pending") - 1 )) > "$D/pr-$k.pending"
      echo '[{"name":"unit-tests","bucket":"pending"}]'; exit 8
    fi
    echo '[{"name":"unit-tests","bucket":"pass"}]'; exit 0 ;;
  merge)
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
    git checkout -q -b initiative/x
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
| 2 | 0000402-second-thing | Second thing | 0000002 | minor | | pending |

## Notes

Closing text.
CHART
    git add -A && git commit -q -m "base" && git push -q origin initiative/x
    for n in 1 2; do
      git checkout -q -b "feat/s$n" initiative/x
      echo "step $n" > "step-$n.txt"
      git add -A && git commit -q -m "feat: step $n" && git push -q origin "feat/s$n"
    done
    git checkout -q initiative/x
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

# wrap_gh_fail_at N: the Nth `pr checks` call reports a failed unit-tests check.
wrap_gh_fail_at() {
  local real="$GH_BIN"
  GH_BIN="$W/gh-wrap"
  cat > "$GH_BIN" <<WRAP
#!/usr/bin/env bash
if [ "\$1 \$2" = "pr checks" ]; then
  n=\$(( \$(cat "$W/count" 2>/dev/null || echo 0) + 1 ))
  echo "\$n" > "$W/count"
  if [ "\$n" -eq "$1" ]; then
    echo "\$*" >> "\$FAKE_GH_DIR/calls.log"
    echo '[{"name":"unit-tests","bucket":"fail"}]'; exit 1
  fi
fi
exec "$real" "\$@"
WRAP
  chmod +x "$GH_BIN"
}

echo ""
echo "=== REQ-003 AC-1: pending checks after the push delay the squash ==="
make_world ac1
echo 3 > "$FAKE_GH_DIR/pr-12.pending"
run_mq run --step 2 --pr 12 --root "$CLONE"
assert_equals "0" "$CODE" "AC-1: run exits 0 after pending checks ($OUT)"
CALLS="$(cat "$FAKE_GH_DIR/calls.log")"
assert_contains "pr merge 12 --squash --delete-branch" "$CALLS" "AC-1: the PR is squashed"
CHECKS="$(grep -c 'pr checks' "$FAKE_GH_DIR/calls.log")"
[ "$CHECKS" -ge 3 ]; assert_equals "0" "$?" "AC-1: at least 3 pr checks calls ($CHECKS)"
assert_contains "pr checks 12 --json name,bucket" "$CALLS" "AC-1: checks are polled as JSON"

echo ""
echo "=== REQ-003 AC-2: a check that fails after the push stops the queue ==="
make_world ac2
wrap_gh_fail_at 2
run_mq run --step 2 --pr 12 --root "$CLONE"
assert_equals "1" "$CODE" "AC-2: a failed check after the push exits 1"
assert_contains "CI failed on PR #12: unit-tests" "$OUT" "AC-2: the failing check is named"
assert_not_contains "pr merge" "$(cat "$FAKE_GH_DIR/calls.log")" "AC-2: gh was not asked to squash"
assert_equals "" "$(git --git-dir="$REMOTE" tag -l)" "AC-2: no tag after a failed check"

print_summary
