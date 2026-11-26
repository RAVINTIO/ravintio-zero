#!/usr/bin/env bash
# Tests for feature 0000248-ship-merge-and-wall-clocks, req-001: the ship skill
# gives a plain merge line with a literal PR number and merge-guard allows it.
# AC-3 (merge-guard unchanged) is a branch property that P3 checks with git diff.

set -uo pipefail
# A step session sets RAVINTIO_INITIATIVE_QUEUE=1, which makes merge-guard refuse every merge (0000458).
unset RAVINTIO_INITIATIVE_QUEUE

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"
STANDARDS="$ZERO_DIR/standards/roadmap-standards.md"
GUARD="$ZERO_DIR/hooks/enforcement/merge-guard.mjs"

TMP=$(mktemp -d -t ravintio_0000248_req001_XXXXXX)
trap 'rm -rf "$TMP"' EXIT

echo ""
echo "=== req-001 AC-1: the ship skill holds the line and the rule ==="
assert_rule rm-ship-initiative-merge-line "gh pr merge --squash --delete-branch {n}"
assert_rule rm-ship-initiative-plain-merge "literal PR number" "gh pr create" "no command substitution, variables, or pipes"
assert_rule rm-advance-queue-merge "gh pr merge --squash --delete-branch {n}"
assert_rule rm-advance-ready "literal PR number"

echo ""
echo "=== req-001 AC-2: merge-guard allows the line ==="
mkdir -p "$TMP/bin"
cat > "$TMP/bin/gh" <<'STUB'
#!/usr/bin/env bash
if [ "$1 $2" = "pr view" ]; then printf '{"baseRefName":"%s"}\n' "$STUB_BASE"; fi
STUB
chmod +x "$TMP/bin/gh"
PAYLOAD=$(node -e 'console.log(JSON.stringify({tool_name:"Bash",tool_input:{command:process.argv[1]}}))' "gh pr merge --squash --delete-branch 52")
printf '%s' "$PAYLOAD" | env PATH="$TMP/bin:$PATH" STUB_BASE=initiative/x node "$GUARD" > /dev/null 2>&1
assert_equals "0" "$?" "req-001 AC-2: the guard exits 0 for an initiative/* base"
printf '%s' "$PAYLOAD" | env PATH="$TMP/bin:$PATH" STUB_BASE=main node "$GUARD" > /dev/null 2>&1
assert_equals "2" "$?" "req-001 AC-2: the guard still blocks a main base"

print_summary
