#!/usr/bin/env bash
# Tests for feature 0000381-setup-safety, req-004: setup prunes retired pack
# commands, keeps a developer's own commands, and migration 0008 does the same.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

new_workspace() {
  local ws
  ws=$(mktemp -d "$TMP/ws_XXXXXX")
  cp -r "$ZERO_DIR" "$ws/ravintio-zero"
  git init "$ws" >/dev/null 2>&1
  commit_workspace_pack "$ws"
  mkdir -p "$ws/.claude/commands"
  for n in fast-path change-pipeline retrofit; do
    printf -- '---\nname: %s\ndescription: Retired.\n---\n# %s\n' "$n" "$n" >"$ws/.claude/commands/$n.md"
  done
  printf -- '---\nname: my-own\ndescription: Mine.\n---\n# Mine\n' >"$ws/.claude/commands/my-own.md"
  printf -- '---\nname: fast-path\ndescription: A developer command in another folder.\n---\n' >"$ws/other-fast-path.md"
  printf '%s\n' "$ws"
}

run_setup() {
  (cd "$1" && GIT_CEILING_DIRECTORIES="$(dirname "$1")" bash ravintio-zero/setup.sh claude-code \
    >"$1/setup.out" 2>"$1/setup.err")
}

exists() { [ -e "$1" ] && echo present || echo gone; }

echo ""
echo "=== req-004 AC-1 and AC-2: setup prunes retired commands, keeps the developer's ==="
WS="$(new_workspace)"
run_setup "$WS"
C="$WS/.claude/commands"
for n in fast-path change-pipeline retrofit; do
  assert_equals gone "$(exists "$C/$n.md")" "AC-1: $n.md is removed"
done
assert_equals present "$(exists "$C/feature-pipeline.md")" "the shipped command installs"
assert_equals present "$(exists "$C/my-own.md")" "AC-2: the developer command survives"
run_setup "$WS"
assert_equals present "$(exists "$C/my-own.md")" "AC-2: the developer command survives a re-run"
assert_contains "feature-pipeline.md" "$(cat "$C/.ravintio-manifest")" "setup lists the shipped command in the command manifest"

echo ""
echo "=== req-004: a listed command the pack stopped shipping is removed ==="
echo "old-shipped.md" >>"$C/.ravintio-manifest"
echo "# old" >"$C/old-shipped.md"
run_setup "$WS"
assert_equals gone "$(exists "$C/old-shipped.md")" "a manifest-listed command the pack no longer ships is removed"
assert_equals present "$(exists "$C/my-own.md")" "an unlisted developer command stays"

echo ""
echo "=== req-004: a retired name without the pack name line stays ==="
WS3="$(new_workspace)"
printf '# Mine\nNo front matter.\n' >"$WS3/.claude/commands/retrofit.md"
run_setup "$WS3"
assert_equals present "$(exists "$WS3/.claude/commands/retrofit.md")" "a file with no name line is the developer's and stays"

echo ""
echo "=== req-004 AC-3: migration 0008 removes the retired commands ==="
WS2="$(new_workspace)"
(cd "$WS2" && bash ravintio-zero/migrations/migrate-retired-commands.sh >"$WS2/mig.out" 2>&1)
for n in fast-path change-pipeline retrofit; do
  assert_equals gone "$(exists "$WS2/.claude/commands/$n.md")" "AC-3: $n.md is removed by the helper"
done
assert_equals present "$(exists "$WS2/.claude/commands/my-own.md")" "AC-3: the helper keeps the developer command"
(cd "$WS2" && bash ravintio-zero/migrations/migrate-retired-commands.sh >"$WS2/mig2.out" 2>&1)
assert_equals 0 "$?" "AC-3: a second run exits 0"
assert_equals present "$(exists "$WS2/.claude/commands/my-own.md")" "AC-3: a second run changes nothing"
[ -f "$ZERO_DIR/migrations/0008-retired-commands.md" ] && r=yes || r=no
assert_equals yes "$r" "migration 0008 document exists"

print_summary
