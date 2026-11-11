#!/usr/bin/env bash
# Tests for feature 0000481-regenerate-after-every-merge, req-002: one base merge renumbers an id and regenerates.
# The world is the one in test-0000485-req-002. Step 2 collides with step 1 on ADR 0301 and on backlog id 0000010.
# The renumber runs first. The regeneration after it must see the renumbered backlog folders.

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

# The fake gh deletes the PR branch on merge and saves its history, newest first, in pr-N.history.
pr_subjects() { while read -r sha; do git --git-dir="$REMOTE" log -1 --format=%s "$sha"; done < "$FAKE_GH_DIR/pr-$(($1 + 10)).history"; }

make_world both 0301
run_mq run --step 1 --pr 11 --root "$QUEUE"
assert_equals "0" "$CODE" "step 1 merges first ($OUT)"
run_mq run --step 2 --pr 12 --root "$QUEUE"
assert_equals "0" "$CODE" "step 2 merges after a base merge that collides ($OUT)"
assert_contains "renumbered: backlog 0000010 -> 0000011" "$OUT" "the queue renumbers the backlog id"
assert_contains "renumbered: adr 0301 -> 0302" "$OUT" "the queue renumbers the ADR"
IDX="$(remote_show plan/backlog/index.md)"
assert_contains "0000010" "$IDX" "the index lists step 1 under 0000010"
assert_contains "0000011" "$IDX" "the index lists step 2 under its renumbered id"
assert_not_contains "0000010-step-2" "$IDX" "the index holds no stale folder name for step 2"
assert_equals "yes" "$(remote_has plan/backlog/0000011-step-2/entry.md)" "the renumbered folder reaches the base"
assert_equals "0000012" "$(remote_show plan/backlog/.next-id)" "the counter sits past both ids"
SUBJ="$(pr_subjects 2)"  # PR 12
assert_contains "Renumber colliding ids" "$SUBJ" "the PR branch holds the renumber commit"
# The regeneration may find nothing to change. If it commits, it commits after the renumber (newest first in the log).
REN_LINE="$(printf '%s\n' "$SUBJ" | grep -n 'Renumber colliding ids' | head -1 | cut -d: -f1)"
REG_LINE="$(printf '%s\n' "$SUBJ" | grep -n 'Regenerate shared files' | head -1 | cut -d: -f1)"
if [ -n "$REG_LINE" ]; then
  assert_equals "yes" "$([ "$REG_LINE" -lt "$REN_LINE" ] && echo yes)" "the regeneration commit follows the renumber commit"
fi

print_summary
