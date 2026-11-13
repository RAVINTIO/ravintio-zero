#!/usr/bin/env bash
# Tests for feature 0000464-merge-queue-test-gaps, req-001 and req-002: the two branches of
# merge-queue.mjs `run` that no earlier test reaches.
#   req-001: a rerun on a PR branch that already holds the version edits adds no commit and merges.
#   req-002: a version file that reads back different after the set stops the run before the merge.
# The world has a bare remote, a clone with a queue worktree, an initiative branch with a chart, and
# one step branch. A fake `gh` performs real git merges on the remote.

set -uo pipefail
export MQ_POLL_MS=20

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="${MQ_TOOL:-$SCRIPT_DIR/../scripts/merge-queue.mjs}"
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
      printf '{"headRefOid":"%s","mergeable":"MERGEABLE","mergeStateStatus":"CLEAN"}\n' \
        "$(git --git-dir "$FAKE_REMOTE" rev-parse "refs/heads/$(cat "$D/pr-$k.head")" 2>/dev/null)"
    else
      printf '{"title":"%s","headRefName":"%s","baseRefName":"%s"}\n' \
        "$(cat "$D/pr-$k.title")" "$(cat "$D/pr-$k.head")" "$(cat "$D/pr-$k.base")"
    fi ;;
  checks)
    echo '[{"name":"unit-tests","bucket":"pass"}]'; exit 0 ;;
  merge)
    if [ -f "$D/pr-$k.fail-merge" ]; then
      rm -f "$D/pr-$k.fail-merge"
      echo "transient merge refusal" >&2; exit 1
    fi
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

# make_world NAME: sets W, CLONE, REMOTE, QUEUE, GH_BIN, FAKE_GH_DIR
make_world() {
  W="$WORK/$1"; REMOTE="$W/remote.git"; CLONE="$W/clone"; QUEUE="$W/queue"; FAKE_GH_DIR="$W/gh"
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

## Notes

Closing text.
CHART
    git add -A && git commit -q -m "base" && git push -q origin initiative/x
    git checkout -q -b feat/s1 initiative/x
    echo "step 1" > step-1.txt
    git add -A && git commit -q -m "feat: step 1" && git push -q origin feat/s1
    git checkout -q initiative/x
    git branch -q -D feat/s1
    git worktree add -q --detach "$QUEUE" initiative/x
  ) >/dev/null 2>&1
  write_gh_shim "$W/gh-bin"
  GH_BIN="$W/gh-bin"
  echo "0000401: First thing" > "$FAKE_GH_DIR/pr-11.title"
  echo "feat/s1" > "$FAKE_GH_DIR/pr-11.head"
  echo "initiative/x" > "$FAKE_GH_DIR/pr-11.base"
}

run_mq() {
  OUT="$(GH_BIN="$GH_BIN" FAKE_GH_DIR="$FAKE_GH_DIR" FAKE_REMOTE="$REMOTE" node "$TOOL" "$@" 2>&1)"
  CODE=$?
}

remote_has_tag() { git --git-dir="$REMOTE" rev-parse -q --verify "refs/tags/$1^{commit}" 2>/dev/null; }
remote_count() { git --git-dir="$REMOTE" rev-list --count "$1"; }

# ---------------------------------------------------------------- REQ-001: a rerun adds no commit and merges
make_world rerun
touch "$FAKE_GH_DIR/pr-11.fail-merge"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "1" "$CODE" "REQ-001: the first run stops when the merge fails ($OUT)"
assert_contains "gh pr merge failed" "$OUT" "REQ-001: the first run names the merge failure"
COUNT_AFTER_FIRST="$(remote_count refs/heads/feat/s1)"
HEAD_AFTER_FIRST="$(git --git-dir="$REMOTE" rev-parse refs/heads/feat/s1)"
assert_contains "set version 0.58.0 for step 1" \
  "$(git --git-dir="$REMOTE" log --format=%s refs/heads/feat/s1)" "REQ-001: the first run pushed the set-version commit"
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "REQ-001 AC-2: the second run merges ($OUT)"
assert_contains "merged PR #11 as v0.58.0" "$OUT" "REQ-001 AC-2: the second run prints the merge line"
assert_equals "$COUNT_AFTER_FIRST" "$(git --git-dir="$REMOTE" rev-list --count "$HEAD_AFTER_FIRST")" \
  "REQ-001 AC-1: the second run added no commit to the PR branch (history of the first-run head)"
assert_equals "1" "$(git --git-dir="$REMOTE" log --format=%s "$HEAD_AFTER_FIRST" | grep -c 'set version')" \
  "REQ-001 AC-1: the PR branch holds one set-version commit"
test -n "$(remote_has_tag v0.58.0)" && PASS_TAG=yes || PASS_TAG=no
assert_equals "yes" "$PASS_TAG" "REQ-001 AC-2: the base branch holds the version tag"

# ---------------------------------------------------------------- REQ-002: a mismatch after the set stops before the merge
make_world mismatch
# A copy of the queue beside a version-files.mjs that leaves product.yml different after the set.
mkdir -p "$WORK/stub/scripts"
STUB="$(cd "$WORK/stub/scripts" && pwd -P)"
cp "$SCRIPT_DIR/../scripts/merge-queue.mjs" "$SCRIPT_DIR/../scripts/shared-files.mjs" "$SCRIPT_DIR/../scripts/id-collisions.mjs" "$STUB/"
REAL_URL="file://$(cd "$SCRIPT_DIR/../scripts" && pwd)/version-files.mjs"
cat > "$STUB/version-files.mjs" <<STUBJS
import { join } from "node:path";
import { writeFileSync } from "node:fs";
import * as real from "$REAL_URL";
export const { presentPaths, readEntries, readVersions } = real;
export function setVersions(version, opts) {
  const paths = real.setVersions(version, opts);
  writeFileSync(join(opts.root, "product.yml"), 'id: demo\nversion: "9.9.9"\n');
  return paths;
}
STUBJS
OLD_TOOL="$TOOL"; TOOL="$STUB/merge-queue.mjs"
run_mq run --step 1 --pr 11 --root "$QUEUE" --list "$SCRIPT_DIR/../version-files.txt"
TOOL="$OLD_TOOL"
assert_equals "1" "$CODE" "REQ-002 AC-1: run exits 1 ($OUT)"
assert_contains "version mismatch" "$OUT" "REQ-002 AC-1: the error says version mismatch"
assert_contains "product.yml" "$OUT" "REQ-002 AC-1: the error names the different file"
assert_contains "9.9.9" "$OUT" "REQ-002 AC-1: the error names the different version"
assert_not_contains "pr merge" "$(cat "$FAKE_GH_DIR/calls.log")" "REQ-002 AC-2: gh never merged the PR"
test -z "$(remote_has_tag v0.58.0)" && NO_TAG=yes || NO_TAG=no
assert_equals "yes" "$NO_TAG" "REQ-002 AC-2: the base branch holds no new tag"
assert_equals "" "$(git -C "$QUEUE" symbolic-ref -q --short HEAD)" "REQ-002: the queue worktree has no branch after the stop"

print_summary
