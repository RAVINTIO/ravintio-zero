#!/usr/bin/env bash
# Tests for feature 0000384, req-006: human-only settings check.
# Covers ravintio-zero/scripts/human-settings-check.mjs with a stub gh.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK="$ZERO_DIR/scripts/human-settings-check.mjs"

SCRATCH=$(mktemp -d -t ravintio_0000384_r006_XXXXXX)
trap 'rm -rf "$SCRATCH"' EXIT

# Stub gh: records each call and prints $STUB_GH_OUT.
cat > "$SCRATCH/gh" << 'STUB'
#!/usr/bin/env bash
echo "$*" >> "$STUB_GH_CALLS"
printf '%s' "$STUB_GH_OUT"
STUB
chmod +x "$SCRATCH/gh"

export RAVINTIO_GH_BIN="$SCRATCH/gh"
export STUB_GH_CALLS="$SCRATCH/calls.log"

write_chart() {
  # $1 = file, $2 = answer cell (empty for no row)
  {
    echo "# Chart"
    echo ""
    echo "## Decisions"
    echo ""
    echo "| Step | Fork | Pre-approved answer | Bump effect |"
    echo "|------|------|---------------------|-------------|"
    echo "| 1 | Confirmation: something | Do it | none |"
    if [ -n "$2" ]; then
      echo "| 2 | Human setting: secret scanning | $2 | none |"
    fi
    echo ""
    echo "## Next"
  } > "$1"
}

echo ""
echo "=== req-006 AC-1: a mismatch blocks ==="
: > "$STUB_GH_CALLS"
write_chart "$SCRATCH/a.md" 'GET repos/acme/widget/vulnerability-alerts enabled=true'
export STUB_GH_OUT='{"enabled": false}'
output=$(node "$CHECK" "$SCRATCH/a.md" 2>&1)
code=$?
assert_equals "1" "$code" "mismatch: exits 1"
assert_contains "P1 Plan: Blocked: human-only setting secret scanning reads false, wanted true." "$output" "mismatch: prints the Blocked line"
assert_contains "api -X GET repos/acme/widget/vulnerability-alerts" "$(cat "$STUB_GH_CALLS")" "mismatch: calls gh api -X GET"

echo ""
echo "=== req-006: a match passes ==="
export STUB_GH_OUT='{"enabled": true}'
output=$(node "$CHECK" "$SCRATCH/a.md" 2>&1)
code=$?
assert_exit_zero "$code" "match: exits 0"
assert_not_contains "Blocked" "$output" "match: prints no Blocked line"

echo ""
echo "=== req-006 AC-2: a disallowed endpoint is refused ==="
for ep in 'repos/acme/widget/actions/secrets' 'user' 'repos/acme/widget/rulesets/../../x' 'repos/acme/widget/branches/main/protection;id'; do
  : > "$STUB_GH_CALLS"
  write_chart "$SCRATCH/b.md" "GET $ep name=x"
  export STUB_GH_OUT='{"name":"x"}'
  output=$(node "$CHECK" "$SCRATCH/b.md" 2>&1)
  code=$?
  assert_equals "1" "$code" "refused ($ep): exits 1"
  assert_equals "0" "$(wc -l < "$STUB_GH_CALLS" | tr -d ' ')" "refused ($ep): gh called zero times"
done

echo ""
echo "=== req-006 AC-3: no rows prints none ==="
: > "$STUB_GH_CALLS"
write_chart "$SCRATCH/c.md" ""
output=$(node "$CHECK" "$SCRATCH/c.md" 2>&1)
code=$?
assert_exit_zero "$code" "no rows: exits 0"
assert_equals "none" "$output" "no rows: prints none"
assert_equals "0" "$(wc -l < "$STUB_GH_CALLS" | tr -d ' ')" "no rows: gh called zero times"

print_summary
