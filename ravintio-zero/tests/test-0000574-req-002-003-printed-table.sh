#!/usr/bin/env bash
# 0000574 req-002 and req-003: reshape-initiative.mjs prints the step table in replay order.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

RESHAPE="$ZERO_DIR/scripts/reshape-initiative.mjs"
TMP="$(mktemp -d -t ravintio_0000574_XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

BRANCH="initiative/0000900-demo"
NEW="$BRANCH-reshaped"

cat > "$TMP/chart.md" <<'CHART_EOF'
# Initiative: 0000900 - demo

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status |
|------|------------|-------|-----------------|------|---------|--------|
| 1 | 0000901-alpha | Alpha work | none | minor | 0.59.0 | merged |
| 2 | 0000902-beta | Beta work | none | minor | 0.58.0 | merged |
CHART_EOF

commit_file() { # repo file content subject
  printf '%s\n' "$3" > "$1/$2"
  git -C "$1" add -A
  git -C "$1" commit -q -m "$4"
}

new_repo() { # name
  local d="$TMP/$1"
  mkdir -p "$d"
  git -C "$d" init -q -b main
  git -C "$d" config user.email t@example.com
  git -C "$d" config user.name t
  commit_file "$d" seed.txt X "seed"
  git -C "$d" checkout -q -b "$BRANCH"
}

echo "=== REQ-002 AC-1 and AC-2: the table has four columns and one row for each step ==="
# Step 2 (Beta, 0.58.0) merges first, then step 1 (Alpha, 0.59.0).
new_repo a
commit_file "$TMP/a" beta.txt beta "0000902: Beta work (#11)"
git -C "$TMP/a" tag -a v0.58.0 -m "beta"
commit_file "$TMP/a" alpha.txt alpha "0000901: Alpha work (#12)"
git -C "$TMP/a" tag -a v0.59.0 -m "alpha"
git -C "$TMP/a" checkout -q main
OUT=$(node "$RESHAPE" --root "$TMP/a" --branch "$BRANCH" --base main --chart "$TMP/chart.md" 2>&1); RC=$?
assert_equals "0" "$RC" "REQ-002: exits 0"
assert_contains "| Step | Title | Version | Tag |" "$OUT" "REQ-002 AC-1: header row"
assert_contains "| 2 | 0000902: Beta work | 0.58.0 | v0.58.0 |" "$OUT" "REQ-002 AC-2: step 2 row"
assert_contains "| 1 | 0000901: Alpha work | 0.59.0 | v0.59.0 |" "$OUT" "REQ-002 AC-2: step 1 row"

echo "=== REQ-003 AC-1: the printed rows ascend by version ==="
ROWS="$(printf '%s\n' "$OUT" | grep -E '^\| [0-9]+ \|' | cut -d'|' -f2 | tr -d ' ' | tr '\n' ' ')"
assert_equals "2 1 " "$ROWS" "REQ-003 AC-1: step 2 comes before step 1"

echo "=== REQ-003 AC-2: the table matches the replay ==="
assert_equals "0000902: Beta work (#11)
0000901: Alpha work (#12)" "$(git -C "$TMP/a" log --first-parent --reverse --format=%s main.."$NEW")" "REQ-003 AC-2: the commits follow the row order"

echo "=== REQ-002 AC-3: a failed run prints no table ==="
new_repo b
commit_file "$TMP/b" beta.txt beta "0000902: Beta work (#11)"
git -C "$TMP/b" tag -a v0.58.0 -m "beta"
git -C "$TMP/b" checkout -q main
OUT=$(node "$RESHAPE" --root "$TMP/b" --branch "$BRANCH" --base main --chart "$TMP/chart.md" 2>&1); RC=$?
assert_equals "1" "$RC" "REQ-002 AC-3: exits 1 for a step with no tag"
assert_not_contains "| Step | Title | Version | Tag |" "$OUT" "REQ-002 AC-3: no table"

print_summary
