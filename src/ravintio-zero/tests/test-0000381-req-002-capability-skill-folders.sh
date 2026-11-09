#!/usr/bin/env bash
# Tests for feature 0000381-setup-safety, req-002: setup copies every file of a
# capability skill folder, and still skips a folder with no SKILL.md.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

WS=$(mktemp -d "$TMP/ws_XXXXXX")
cp -r "$ZERO_DIR" "$WS/ravintio-zero"
git init "$WS" >/dev/null 2>&1
commit_workspace_pack "$WS"
CAP="$WS/ravintio-overrides/capability-skills"
mkdir -p "$CAP/my-skill/references" "$CAP/my-skill/scripts" "$CAP/no-skill-md/references"
printf -- '---\nname: my-skill\ndescription: A test skill.\n---\n# My skill\n' >"$CAP/my-skill/SKILL.md"
echo ref >"$CAP/my-skill/references/guide.md"
echo run >"$CAP/my-skill/scripts/run.sh"
echo orphan >"$CAP/no-skill-md/references/orphan.md"
commit_workspace_pack "$WS"
(cd "$WS" && GIT_CEILING_DIRECTORIES="$(dirname "$WS")" bash ravintio-zero/setup.sh claude-code >"$WS/setup.out" 2>"$WS/setup.err")

SK="$WS/.claude/skills"
echo ""
echo "=== req-002 AC-1: references and scripts install ==="
[ -f "$SK/my-skill/SKILL.md" ] && r=yes || r=no
assert_equals yes "$r" "AC-1: SKILL.md installs"
[ -f "$SK/my-skill/references/guide.md" ] && r=yes || r=no
assert_equals yes "$r" "AC-1: references/guide.md installs"
[ -f "$SK/my-skill/scripts/run.sh" ] && r=yes || r=no
assert_equals yes "$r" "AC-1: scripts/run.sh installs"

echo ""
echo "=== req-002 AC-2: a folder with no SKILL.md warns and installs nothing ==="
[ -e "$SK/no-skill-md" ] && r=present || r=absent
assert_equals absent "$r" "AC-2: the folder with no SKILL.md is not installed"
assert_contains "no-skill-md" "$(cat "$WS/setup.out")" "AC-2: setup warns and names the folder"

print_summary
