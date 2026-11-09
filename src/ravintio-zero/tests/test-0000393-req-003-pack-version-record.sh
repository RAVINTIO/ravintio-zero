#!/usr/bin/env bash
# Tests for feature 0000393 REQ-003: pack version has its own record.
# resume-detect.mjs compares component.yml with plan/state/pack-version.md.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPT="$SCRIPT_DIR/../scripts/resume-detect.mjs"
POLICY="$SCRIPT_DIR/../standards/pack-update-policy.md"
TEMPLATE="$SCRIPT_DIR/../templates/about.template.md"
REF="$SCRIPT_DIR/../skills/ravintio-orchestrator/references/orchestrator-resume-detection.md"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

DIFFERS="pack version differs from plan/state/pack-version.md"

# mk_ws: pack 0.37.0, product 0.4.0, no record
mk_ws() {
  local ws
  ws="$(mktemp -d "$TMP_ROOT/ws.XXXXXX")"
  mkdir -p "$ws/ravintio-zero" "$ws/docs" "$ws/plan/state"
  printf 'name: x\nversion: "0.37.0"\n' > "$ws/ravintio-zero/component.yml"
  printf -- '---\nversion: "0.4.0"\n---\n' > "$ws/docs/about.md"
  echo "$ws"
}

# record <ws> <version>
record() {
  printf '# Pack version\n\n```json\n{\n  "packVersion": "%s",\n  "confirmedAt": "2026-11-09T10:00:00Z"\n}\n```\n' "$2" \
    > "$1/plan/state/pack-version.md"
}

detect() { env -u RAVINTIO_INITIATIVE_STEP node "$SCRIPT" "$1" 2>/dev/null; }

echo "=== req-003 AC-1 matching record ==="
ws="$(mk_ws)"; record "$ws" "0.37.0"
assert_equals "no resume signals" "$(detect "$ws")" "matching record prints no finding"

echo "=== req-003 AC-2 older record ==="
ws="$(mk_ws)"; record "$ws" "0.36.0"
assert_equals "$DIFFERS" "$(detect "$ws")" "older record prints exactly one differs finding"

echo "=== req-003 absent record ==="
ws="$(mk_ws)"
assert_equals "no resume signals" "$(detect "$ws")" "no record prints no finding though about.md differs"

echo "=== req-003 unreadable ==="
ws="$(mk_ws)"; record "$ws" "latest"
assert_equals "pack version unreadable" "$(detect "$ws")" "unreadable record version"
ws="$(mk_ws)"; printf 'no json here\n' > "$ws/plan/state/pack-version.md"
assert_equals "pack version unreadable" "$(detect "$ws")" "record without json block"
ws="$(mk_ws)"; record "$ws" "0.37.0"; printf 'name: x\nversion: "oops"\n' > "$ws/ravintio-zero/component.yml"
assert_equals "pack version unreadable" "$(detect "$ws")" "unreadable pack version with record"

echo "=== req-003 about.md never read ==="
ws="$(mk_ws)"; record "$ws" "0.37.0"; rm "$ws/docs/about.md"
assert_equals "no resume signals" "$(detect "$ws")" "about.md absent, record matches"
ws="$(mk_ws)"; record "$ws" "0.37.0"; printf -- '---\nversion: "latest"\n---\n' > "$ws/docs/about.md"
assert_equals "no resume signals" "$(detect "$ws")" "about.md unreadable, record matches"

echo "=== req-003 AC-3 docs state the split ==="
assert_contains "holds the product version only" "$(cat "$POLICY")" "policy states the split"
assert_contains "plan/state/pack-version.md" "$(cat "$POLICY")" "policy names the record"
assert_contains "docs/about.md holds the product version only" "$(cat "$TEMPLATE")" "template states the split"
assert_contains "$DIFFERS" "$(cat "$REF")" "reference lists the new finding"
assert_not_contains "differs from docs/about.md" "$(cat "$REF")" "reference drops the old finding"

print_summary
