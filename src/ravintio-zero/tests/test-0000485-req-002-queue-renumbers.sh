#!/usr/bin/env bash
# Tests for feature 0000485-adr-number-collision, req-002: the queue renumbers colliding ids.
# The world has a bare remote, a clone with a queue worktree, an initiative branch with a chart, and two step
# branches that each add ADR 0301 and a backlog entry under one id. A fake `gh` performs real git merges on the remote.

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
    head="$(cat "$D/pr-$k.head")"
    if [ -f "$D/pr-$k.red-after-version" ] \
      && git --git-dir "$FAKE_REMOTE" log "refs/heads/$head" --format=%s | grep -q 'set version'; then
      echo '[{"name":"unit-tests","bucket":"fail"}]'; exit 1
    fi
    echo '[{"name":"unit-tests","bucket":"pass"}]'; exit 0 ;;
  merge)
    head="$(cat "$D/pr-$k.head")"; base="$(cat "$D/pr-$k.base")"
    t="$(mktemp -d)"
    git clone -q --branch "$base" "$FAKE_REMOTE" "$t/c" || exit 1
    cd "$t/c" || exit 1
    git rev-list "origin/$head" > "$D/pr-$k.history"
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

# make_world NAME [ADR_B]: sets W, CLONE, REMOTE, QUEUE, GH_BIN, FAKE_GH_DIR. Both steps add an ADR and a backlog entry.
make_world() {
  ADR2="${2:-0301}"
  W="$WORK/$1"; REMOTE="$W/remote.git"; CLONE="$W/clone"; QUEUE="$W/queue"; FAKE_GH_DIR="$W/gh"
  mkdir -p "$FAKE_GH_DIR"
  git init -q --bare -b main "$REMOTE"
  git clone -q "$REMOTE" "$CLONE" 2>/dev/null
  (
    cd "$CLONE" || exit 1
    git checkout -q -b initiative/x
    mkdir -p docs/adr ravintio-zero plan/current-initiative plan/backlog
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
    echo 0000010 > plan/backlog/.next-id; echo 0301 > docs/adr/.next-id
    printf '# Decisions\n\nLast updated: base\n\n| ADR | Title |\n|-----|-------|\n' > docs/decisions-index.md
    echo base > plan/backlog/index.md
    git add -A && git commit -q -m "base" && git push -q origin initiative/x
    for n in 1 2; do
      git checkout -q -b "feat/s$n" initiative/x
      adr=0301; [ "$n" = 2 ] && adr="$ADR2"
      printf -- '---\ntitle: "ADR %s: Step %s"\n---\n# ADR-%s - Step %s\n' "${adr#0}" "$n" "$adr" "$n" > "docs/adr/$adr-step-$n.md"
      echo "| [ADR-$adr](adr/$adr-step-$n.md) | Step $n |" >> docs/decisions-index.md
      mkdir -p "plan/backlog/0000010-step-$n"
      printf -- '---\ntitle: "Backlog Entry: 0000010 - Step %s"\nsummary: "An entry."\nstatus: "open"\npriority: "high"\ntheme: "queue"\n---\n# Backlog Entry: 0000010 - Step %s\n\n**Date filed:** 2026-11-10\n' "$n" "$n" > "plan/backlog/0000010-step-$n/entry.md"
      echo "ADR-$adr is step $n" > "step-$n.txt"
      echo "$(printf '%04d' $((10#$adr + 1)))" > docs/adr/.next-id
      echo 0000011 > plan/backlog/.next-id
      git add -A && git commit -q -m "feat: step $n" && git push -q origin "feat/s$n"
    done
    git checkout -q initiative/x
    git branch -q -D feat/s1 feat/s2
    git worktree add -q --detach "$QUEUE" initiative/x
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

remote_show() { git --git-dir="$REMOTE" show "initiative/x:$1" 2>/dev/null; }
remote_has() { git --git-dir="$REMOTE" cat-file -e "initiative/x:$1" 2>/dev/null && echo yes; }

# ---------------------------------------------------------------- AC-2 and AC-3: two steps reserve ADR 0301
make_world same 0301
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "step 1 merges first ($OUT)"
assert_not_contains "renumbered:" "$OUT" "step 1 has no collision, so nothing is renumbered"
run_mq run --step 2 --pr 12 --root "$QUEUE"
assert_equals "0" "$CODE" "REQ-002 AC-3: step 2 merges although both reserved ADR 0301 ($OUT)"
assert_contains "resolved: docs/decisions-index.md" "$OUT" "REQ-002 AC-3: the shared-file conflict is resolved first"
assert_contains "renumbered: adr 0301 -> 0302" "$OUT" "REQ-002 AC-3: the queue prints the ADR renumber"
assert_contains "renumbered: backlog 0000010 -> 0000011" "$OUT" "REQ-002 AC-3: the queue prints the backlog renumber"
assert_equals "yes" "$(remote_has docs/adr/0301-step-1.md)" "step 1 keeps ADR 0301"
assert_equals "yes" "$(remote_has docs/adr/0302-step-2.md)" "step 2 holds ADR 0302 on the base"
assert_contains "# ADR-0302 - Step 2" "$(remote_show docs/adr/0302-step-2.md)" "the renamed ADR holds its new heading"
assert_contains "[ADR-0302](adr/0302-step-2.md)" "$(remote_show docs/decisions-index.md)" "the index row holds 0302"
assert_contains "[ADR-0301](adr/0301-step-1.md)" "$(remote_show docs/decisions-index.md)" "the step 1 index row stays"
assert_contains "ADR-0302 is step 2" "$(remote_show step-2.txt)" "a file the PR changed cites the new number"
assert_equals "0303" "$(remote_show docs/adr/.next-id)" "the counter moves past both"
assert_equals "yes" "$(remote_has plan/backlog/0000011-step-2/entry.md)" "step 2's entry holds the next free id"
assert_equals "0000012" "$(remote_show plan/backlog/.next-id)" "the backlog counter moves past both"

# ---------------------------------------------------------------- AC-2: no collision, no commit
make_world apart 0302
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "step 1 merges ($OUT)"
run_mq run --step 2 --pr 12 --root "$QUEUE"
assert_equals "0" "$CODE" "step 2 merges ($OUT)"
assert_not_contains "renumbered: adr" "$OUT" "REQ-002 AC-2: two different ADR numbers print no ADR renumber"
assert_equals "yes" "$(remote_has docs/adr/0302-step-2.md)" "REQ-002 AC-2: the ADR keeps 0302"

print_summary
