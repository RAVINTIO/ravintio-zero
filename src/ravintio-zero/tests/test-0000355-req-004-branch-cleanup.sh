#!/usr/bin/env bash
# Tests for feature 0000355-codeql-and-branch-cleanup, REQ-004.
# Both workflow copies hold a scoped cleanup-branch job, and every pull
# request job skips the closed event.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
WF_REPO="$ROOT/.github/workflows/ravintio.yml"
WF_TPL="$SCRIPT_DIR/../hooks/ravintio.yml"
HELPER="$SCRIPT_DIR/helpers/unguarded-jobs.sh"

if ! command -v ruby >/dev/null 2>&1; then
  echo "ruby missing: YAML checks skipped"
  print_summary
  exit 0
fi

for wf in "$WF_REPO" "$WF_TPL"; do
  n="$(basename "$(dirname "$wf")")/$(basename "$wf")"
  echo ""
  echo "=== REQ-004: $n ==="
  out="$(ruby -ryaml -e '
    d = YAML.load_file(ARGV[0])
    on = d["on"] || d[true] || {}
    r = []
    types = (on["pull_request"] || {})["types"] || []
    r << "closed-type" unless types.include?("closed")
    j = d["jobs"]["cleanup-branch"]
    if j.nil? then r << "missing" else
      c = j["if"].to_s
      r << "merged" unless c.include?("github.event.pull_request.merged == true")
      r << "fork" unless c.include?("github.event.pull_request.head.repo.full_name == github.repository")
      r << "closed" unless c.include?("github.event.action == \x27closed\x27")
      r << "write" unless j.dig("permissions", "contents") == "write"
      steps = j["steps"] || []
      run = steps.map { |s| s["run"].to_s }.join("\n")
      r << "inline" if run.include?("github.head_ref") || run.include?("${{")
      r << "env" unless steps.any? { |s| s.dig("env", "HEAD_REF").to_s.include?("github.event.pull_request.head.ref") }
      r << "main" unless run.include?("main") && run.include?("master")
      r << "pattern" unless run.include?("A-Za-z0-9._/-")
      r << "gone" unless run.include?("exit 0")
      r << "delete" unless run.include?("DELETE")
      r << "checkout" if steps.any? { |s| s["uses"].to_s.start_with?("actions/checkout") }
    end
    writers = d["jobs"].select { |k, v| v.dig("permissions", "contents") == "write" }.keys.sort
    r << "writers:#{writers.join("+")}" unless writers == ["cleanup-branch", "release-tag"]
    r << "toplevel" unless d.dig("permissions", "contents") == "read"
    puts r.join(",")
  ' "$wf" 2>&1)"
  assert_equals "" "$out" "$n: cleanup-branch job, scoped write, and safe delete"
  assert_equals "" "$(bash "$HELPER" "$wf")" "$n: every job carries the closed guard or the marker"
done
print_summary
