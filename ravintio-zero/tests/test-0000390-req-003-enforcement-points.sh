#!/usr/bin/env bash
# Tests for feature 0000390-prose-checks, REQ-003: the linter runs at commit time and in CI.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/ravintio-zero/scripts" "$TMP/ravintio-zero/hooks/enforcement" "$TMP/docs"
cp "$ZERO_DIR/scripts/prose-check.mjs" "$TMP/ravintio-zero/scripts/"
cp "$ZERO_DIR/hooks/enforcement/prose-rules.mjs" "$TMP/ravintio-zero/hooks/enforcement/"
cp "$ZERO_DIR/hooks/commit-msg" "$ZERO_DIR/hooks/pre-commit" "$TMP/ravintio-zero/hooks/"
COMMIT_MSG_HOOK="$TMP/ravintio-zero/hooks/commit-msg"
PRE_COMMIT_HOOK="$TMP/ravintio-zero/hooks/pre-commit"

cd "$TMP" || exit 1
git init -q
git config user.email t@example.com
git config user.name Tester
printf 'One clean line.\n' > docs/a.md
git add docs/a.md ravintio-zero
git commit -q -m "seed" --no-verify
node ravintio-zero/scripts/prose-check.mjs update --init >/dev/null
git add plan/state/prose-baseline.json
git commit -q -m "baseline" --no-verify

msg() { printf '%s\n' "$1" > msg.txt; bash "$COMMIT_MSG_HOOK" msg.txt 2>&1; }
pre() { bash "$PRE_COMMIT_HOOK" 2>&1; }

echo ""
echo "=== AC-1: commit-msg blocks a long sentence ==="
LONG="one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty twentyone twentytwo twentythree twentyfour twentyfive twentysix."
OUT="$(msg "feat: add a thing

$LONG")"; RC=$?
assert_equals "1" "$RC" "a 26-word body sentence exits 1"
assert_contains "Commit blocked" "$OUT" "the hook prints the block banner"
OUT="$(msg "feat: add a thing

Add the hook and its test.")"; RC=$?
assert_equals "0" "$RC" "a clean message exits 0"
OUT="$(msg "0000390: Merge the initiative branch")"; RC=$?
assert_equals "0" "$RC" "a merge subject with an id exits 0"
OUT="$(msg "Merge branch 'x'")"; RC=$?
assert_equals "0" "$RC" "a plain merge subject exits 0"

echo ""
echo "=== AC-1: commit-msg skips when the script is missing ==="
mv ravintio-zero/scripts/prose-check.mjs pc.bak
OUT="$(msg "feat: add a thing

$LONG")"; RC=$?
assert_equals "0" "$RC" "a missing script does not block"
assert_contains "prose check skipped" "$OUT" "the hook prints one skip note"
mv pc.bak ravintio-zero/scripts/prose-check.mjs

echo ""
echo "=== AC-2: pre-commit blocks a staged breach ==="
printf 'One clean line.\nA new; breach here.\n' > docs/a.md
git add docs/a.md
OUT="$(pre)"; RC=$?
assert_equals "1" "$RC" "a staged breach exits 1"
assert_contains "docs/a.md:2" "$OUT" "the output names the file and line"
git reset -q
printf 'One clean line.\n' > docs/a.md
printf 'Another clean line.\n' > docs/b.md
git add docs/a.md docs/b.md
OUT="$(pre)"; RC=$?
assert_equals "0" "$RC" "clean staged docs exit 0"

echo ""
echo "=== AC-2: pre-commit blocks a raised baseline ==="
git reset -q
printf '{"version": 1, "files": {"docs/a.md": {"semicolon": 3}}}\n' > plan/state/prose-baseline.json
git add plan/state/prose-baseline.json
OUT="$(pre)"; RC=$?
assert_equals "1" "$RC" "a raised baseline exits 1"

echo ""
echo "=== AC-3: both workflows run check and diff ==="
for wf in "$REPO_DIR/.github/workflows/ravintio.yml" "$ZERO_DIR/hooks/ravintio.yml"; do
  n="$(basename "$(dirname "$wf")")/$(basename "$wf")"
  TXT="$(cat "$wf")"
  assert_contains "prose-check.mjs check" "$TXT" "$n holds a check step"
  assert_contains "prose-check.mjs diff --base" "$TXT" "$n holds a diff step"
done

print_summary
