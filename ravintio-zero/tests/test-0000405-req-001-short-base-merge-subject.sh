#!/usr/bin/env bash
# Tests for feature 0000405-queue-merge-subject, req-001: the queue's base merge uses a short subject.
# The world has a bare remote, a clone with a blocking commit-msg hook, an initiative branch that
# moved on after the step branch was cut, and a step branch whose long name makes git's default
# merge subject longer than 72 characters. A fake `gh` shim performs real git merges on the remote.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="$SCRIPT_DIR/../scripts/merge-queue.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

CHART_REL="plan/current-initiative/initiative.md"
BASE="initiative/0000360-backlog-sweep"
LONG_HEAD="feat/0000401-a-step-branch-name-long-enough-to-break-the-default-subject"

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
    else
      printf '{"title":"%s","headRefName":"%s","baseRefName":"%s"}\n' \
        "$(cat "$D/pr-$k.title")" "$(cat "$D/pr-$k.head")" "$(cat "$D/pr-$k.base")"
    fi ;;
  checks)
    exit 0 ;;
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
    git checkout -q -b "$LONG_HEAD"
    echo "step 1" > step-1.txt
    git add -A && git commit -q -m "feat: step 1" && git push -q origin "$LONG_HEAD"
    git checkout -q "$BASE"
    echo "later" > later.txt
    git add -A && git commit -q -m "later base work" && git push -q origin "$BASE"
    # A commit-msg hook like the pack's: reject a subject over 72 characters.
    cat > .git/hooks/commit-msg <<'HOOK'
#!/usr/bin/env bash
subject="$(head -n1 "$1")"
[ "${#subject}" -le 72 ] || { echo "subject is ${#subject} chars (max 72)" >&2; exit 1; }
HOOK
    chmod +x .git/hooks/commit-msg
  ) >/dev/null 2>&1
  write_gh_shim "$W/gh-bin"
  GH_BIN="$W/gh-bin"
  echo "0000401: First thing" > "$FAKE_GH_DIR/pr-11.title"
  echo "$LONG_HEAD" > "$FAKE_GH_DIR/pr-11.head"
  echo "$BASE" > "$FAKE_GH_DIR/pr-11.base"
}

run_mq() {
  OUT="$(GH_BIN="$GH_BIN" FAKE_GH_DIR="$FAKE_GH_DIR" FAKE_REMOTE="$REMOTE" node "$TOOL" "$@" 2>&1)"
  CODE=$?
}

make_world long
DEFAULT="Merge remote-tracking branch 'origin/$BASE' into $LONG_HEAD"
assert_equals "1" "$([ "${#DEFAULT}" -gt 72 ] && echo 1 || echo 0)" "REQ-001 AC-2: the default subject in this world is longer than 72 characters"

run_mq run --step 1 --pr 11 --root "$CLONE"
assert_equals "0" "$CODE" "REQ-001 AC-2: the queue exits 0 with a blocking commit-msg hook ($OUT)"
SUBJECT="$(git -C "$CLONE" log --merges -1 --format=%s "$LONG_HEAD" 2>/dev/null)"
assert_equals "0000401: Merge the initiative branch" "$SUBJECT" "REQ-001 AC-1: the base merge commit has the short subject"
assert_contains "pr merge 11 --squash --delete-branch" "$(cat "$FAKE_GH_DIR/calls.log")" "REQ-001 AC-2: the step PR merges"
assert_equals "" "$(grep -n -e '--no-verify' "$TOOL")" "REQ-001: the script never passes --no-verify"

print_summary
