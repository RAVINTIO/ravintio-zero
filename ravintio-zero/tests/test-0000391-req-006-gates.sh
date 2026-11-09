#!/usr/bin/env bash
# Tests for feature 0000391-standards-archetypes, REQ-006: the P3 gate check.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GATES="$ZERO_DIR/scripts/archetype-gates.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

gates() { node "$GATES" --root "$TMP" 2>&1; }

reset_repo() {
  rm -rf "$TMP"/* "$TMP"/.[!.]* 2>/dev/null
  mkdir -p "$TMP/ravintio-overrides" "$TMP/plan/current" "$TMP/src/api/docs" "$TMP/reports"
}

install_manifest() { # kind name json
  mkdir -p "$TMP/ravintio-overrides/archetypes/$1/$2"
  printf '%s\n' "$3" > "$TMP/ravintio-overrides/archetypes/$1/$2/archetype.json"
}

reset_repo

echo ""
echo "=== req-006: no archetypes installed ==="
OUT="$(gates)"; RC=$?
assert_equals "0" "$RC" "req-006 no archetypes.json exits 0"
assert_contains "no gates" "$OUT" "req-006 the output says there are no gates"
printf '[]\n' > "$TMP/ravintio-overrides/archetypes.json"
OUT="$(gates)"; RC=$?
assert_equals "0" "$RC" "req-006 an empty list exits 0"
assert_contains "no gates" "$OUT" "req-006 an empty list says no gates"

echo ""
echo "=== req-006 AC-1: file-per-component ==="
printf '["constraint/strict-testing"]\n' > "$TMP/ravintio-overrides/archetypes.json"
install_manifest constraint strict-testing '{"name":"strict-testing","kind":"constraint","gates":[{"id":"pact-contract","type":"file-per-component","path":"src/{id}/docs/pact/*.json"}]}'
printf 'id: api\napiSpec: docs/openapi.yml\n' > "$TMP/src/api/component.yml"
OUT="$(gates)"; RC=$?
assert_equals "1" "$RC" "req-006 a component API with no contract exits 1"
assert_contains "FAIL pact-contract" "$OUT" "req-006 the failure names the gate"
assert_contains "api" "$OUT" "req-006 the failure names the component"
mkdir -p "$TMP/src/api/docs/pact"
printf '{}\n' > "$TMP/src/api/docs/pact/consumer.json"
OUT="$(gates)"; RC=$?
assert_equals "0" "$RC" "req-006 the contract file makes the gate pass"
mkdir -p "$TMP/src/web"
printf 'id: web\n' > "$TMP/src/web/component.yml"
OUT="$(gates)"; RC=$?
assert_equals "0" "$RC" "req-006 a component with no API needs no contract"

echo ""
echo "=== req-006 AC-2: min-value ==="
reset_repo
printf '["constraint/strict-testing"]\n' > "$TMP/ravintio-overrides/archetypes.json"
install_manifest constraint strict-testing '{"name":"strict-testing","kind":"constraint","gates":[{"id":"mutation-score","type":"min-value","report":"reports/mutation.json","key":"metrics.mutationScore","min":80}]}'
printf '{"metrics":{"mutationScore":62.5}}\n' > "$TMP/reports/mutation.json"
OUT="$(gates)"; RC=$?
assert_equals "1" "$RC" "req-006 a low score exits 1"
assert_contains "62.5" "$OUT" "req-006 the output prints the score"
assert_contains "80" "$OUT" "req-006 the output prints the minimum"
printf '{"metrics":{"mutationScore":91}}\n' > "$TMP/reports/mutation.json"
OUT="$(gates)"; RC=$?
assert_equals "0" "$RC" "req-006 a score at or above the minimum passes"
rm "$TMP/reports/mutation.json"
OUT="$(gates)"; RC=$?
assert_equals "1" "$RC" "req-006 a missing report exits 1"
assert_contains "reports/mutation.json" "$OUT" "req-006 the output names the missing report"

echo ""
echo "=== req-006 AC-3: allowlist ==="
reset_repo
printf '{"installed":["constraint/restricted-stack"]}\n' > "$TMP/ravintio-overrides/archetypes.json"
install_manifest constraint restricted-stack '{"name":"restricted-stack","kind":"constraint","gates":[{"id":"stack-allowlist","type":"allowlist","allow":["Node.js","bash"]}]}'
printf '# Design\n\n## Engineering Layer\n- Stack: Node.js, bash, Cobol\n' > "$TMP/plan/current/design.md"
OUT="$(gates)"; RC=$?
assert_equals "1" "$RC" "req-006 an entry off the allowlist exits 1"
assert_contains "Cobol" "$OUT" "req-006 the output names the entry"
printf '# Design\n\n- Stack: Node.js, bash\n' > "$TMP/plan/current/design.md"
OUT="$(gates)"; RC=$?
assert_equals "0" "$RC" "req-006 a stack inside the list passes"
assert_contains "PASS stack-allowlist" "$OUT" "req-006 a passing gate prints a line"

print_summary
