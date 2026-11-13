#!/usr/bin/env bash
# Tests for feature 0000394-github-security-and-ci-lint, req-005: the settings
# script lists the admin-only settings and checks them through gh api (ADR-003).
# A stub gh on the PATH returns fixture JSON, so no network call runs.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPT="$SCRIPT_DIR/../scripts/github-settings.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin" "$TMP/fix"

cat > "$TMP/bin/gh" <<'STUB'
#!/usr/bin/env bash
case "$*" in
  *private-vulnerability-reporting*) cat "$FIX/pvr.json" ;;
  *topics*) cat "$FIX/topics.json" ;;
  *rules/branches*) cat "$FIX/rules.json" ;;
  "repo view"*) echo "RAVINTIO/ravintio-zero" ;;
  *) cat "$FIX/repo.json" ;;
esac
STUB
chmod +x "$TMP/bin/gh"

write_fixtures() {
  local sec="$1" pvr="$2"
  cat > "$TMP/fix/repo.json" <<JSON
{"security_and_analysis":{"secret_scanning":{"status":"$sec"},"secret_scanning_push_protection":{"status":"$sec"},"dependabot_security_updates":{"status":"$sec"}}}
JSON
  echo "{\"enabled\": $pvr}" > "$TMP/fix/pvr.json"
  echo '{"names":["github-actions","ai-pipeline"]}' > "$TMP/fix/topics.json"
  echo '[{"type":"required_status_checks","parameters":{"required_status_checks":[{"context":"workflow-lint"}]}}]' > "$TMP/fix/rules.json"
}

run_script() {
  FIX="$TMP/fix" PATH="$TMP/bin:$PATH" node "$SCRIPT" "$@" 2>&1
}

echo ""
echo "=== req-005 AC-1: list names every item ==="
OUT="$(run_script list)"
for item in secret-scanning push-protection dependabot-security-updates private-vulnerability-reporting topics workflow-lint-required; do
  assert_contains "$item" "$OUT" "req-005 AC-1: the checklist names $item"
done

echo ""
echo "=== req-005 AC-2: check reports every setting on ==="
write_fixtures enabled true
OUT="$(run_script check)"; RC=$?
assert_equals "0" "$RC" "req-005 AC-2: check exits 0 when every item is on"
assert_contains "on  topics" "$OUT" "req-005 AC-2: check prints the state of each item"

echo ""
echo "=== req-005 AC-2: check names an item that is off ==="
write_fixtures enabled false
OUT="$(run_script check)"; RC=$?
assert_equals "1" "$RC" "req-005 AC-2: check exits 1 when one item is off"
assert_contains "off private-vulnerability-reporting" "$OUT" "req-005 AC-2: check names the item that is off"

echo ""
echo "=== req-005: check reports unknown when gh fails ==="
write_fixtures enabled true
rm "$TMP/fix/pvr.json"
OUT="$(run_script check)"; RC=$?
assert_equals "1" "$RC" "req-005: a failed read exits 1"
assert_contains "unknown private-vulnerability-reporting" "$OUT" "req-005: a failed read prints unknown"

print_summary
