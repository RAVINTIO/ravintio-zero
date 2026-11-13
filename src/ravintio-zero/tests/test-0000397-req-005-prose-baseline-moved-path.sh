#!/usr/bin/env bash
# Tests for feature 0000397-pack-source-in-src, REQ-005: the prose baseline ratchet follows the moved pack path.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/scripts" "$TMP/hooks/enforcement" "$TMP/plan/state"
cp "$ZERO_DIR/scripts/prose-check.mjs" "$TMP/scripts/"
cp "$ZERO_DIR/hooks/enforcement/prose-rules.mjs" "$TMP/hooks/enforcement/"
cd "$TMP" || exit 1
git init -q
git config user.email t@example.com
git config user.name Tester
BASE=plan/state/prose-baseline.json
printf '{"version":1,"files":{"ravintio-zero/migrations/_done/a.md":{"passive":2}}}\n' > "$BASE"
git add "$BASE"
git commit -q -m seed --no-verify

check() { node scripts/prose-check.mjs diff --base HEAD >/dev/null 2>&1; echo $?; }

echo ""
echo "=== REQ-005 AC-2: a moved path keeps its old ceiling ==="
printf '{"version":1,"files":{"ravintio-zero/migrations/_done/a.md":{"passive":2},"src/ravintio-zero/migrations/_done/a.md":{"passive":2}}}\n' > "$BASE"
assert_equals "0" "$(check)" "REQ-005: the src path may carry the old path count"

printf '{"version":1,"files":{"ravintio-zero/migrations/_done/a.md":{"passive":2},"src/ravintio-zero/migrations/_done/a.md":{"passive":3}}}\n' > "$BASE"
assert_equals "1" "$(check)" "REQ-005: the src path may not exceed the old path count"

printf '{"version":1,"files":{"ravintio-zero/migrations/_done/a.md":{"passive":2},"src/ravintio-zero/new.md":{"passive":1}}}\n' > "$BASE"
assert_equals "1" "$(check)" "REQ-005: a src path with no old path gets no allowance"

printf '{"version":1,"files":{"ravintio-zero/migrations/_done/a.md":{"passive":2},"docs/src/ravintio-zero/x.md":{"passive":1}}}\n' > "$BASE"
assert_equals "1" "$(check)" "REQ-005: only a leading src/ prefix counts"

print_summary
