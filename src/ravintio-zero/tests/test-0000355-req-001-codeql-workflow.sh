#!/usr/bin/env bash
# Tests for feature 0000355-codeql-and-branch-cleanup, REQ-001.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
WF="$ROOT/.github/workflows/codeql.yml"

echo ""
echo "=== REQ-001: the CodeQL workflow ==="
if [ ! -f "$WF" ]; then
  _fail_line "REQ-001: .github/workflows/codeql.yml exists"
  ((FAIL++)) || true
  print_summary
  exit 1
fi
if ! command -v ruby >/dev/null 2>&1; then
  echo "ruby missing: YAML checks skipped"
  print_summary
  exit 0
fi
out="$(ruby -ryaml -e '
  d = YAML.load_file(ARGV[0])
  on = d["on"] || d[true] || {}
  pr = on["pull_request"] || {}
  r = []
  r << "branches" unless pr["branches"].is_a?(Array) && pr["branches"].include?("main") && pr["branches"].include?("initiative/**")
  langs = d["jobs"].values.flat_map { |j| (j.dig("strategy", "matrix", "language") || []) }
  r << "js" unless langs.include?("javascript-typescript")
  r << "actions" unless langs.include?("actions")
  perms = ([d["permissions"]] + d["jobs"].values.map { |j| j["permissions"] }).compact
  r << "write" if perms.any? { |p| p["contents"] == "write" }
  r << "events" unless perms.any? { |p| p["security-events"] == "write" }
  puts r.join(",")
' "$WF" 2>&1)"
assert_equals "" "$out" "REQ-001 AC-1 to AC-3: branches, languages, and permissions"
print_summary
