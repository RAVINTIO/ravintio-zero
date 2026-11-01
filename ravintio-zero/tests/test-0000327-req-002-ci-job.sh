#!/usr/bin/env bash
# Tests for feature 0000327-squash-before-main, req-002 and NFR-002.
#
# Both workflow copies hold the squash-before-main job.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
WF_REPO="$ROOT/.github/workflows/ravintio.yml"
WF_TPL="$ROOT/ravintio-zero/hooks/ravintio.yml"

if ! command -v ruby >/dev/null 2>&1; then
  echo "ruby missing: YAML checks skipped"
  print_summary
  exit 0
fi

check() {
  ruby -ryaml -e '
    d = YAML.load_file(ARGV[0])
    j = d["jobs"]["squash-before-main"]
    r = []
    if j.nil? then r << "missing" else
      c = j["if"].to_s
      r << "if" unless c.include?("github.event_name == \x27pull_request\x27") && c.include?("github.base_ref == \x27main\x27")
      r << "perm" unless j.dig("permissions", "contents") == "read"
      steps = j["steps"] || []
      co = steps.find { |s| s["uses"].to_s.start_with?("actions/checkout@") }
      r << "depth" unless co && co.dig("with", "fetch-depth") == 0
      r << "creds" unless co && co.dig("with", "persist-credentials") == false
      run = steps.find { |s| s["run"].to_s.include?("check-pr-into-main.mjs") }
      r << "run" if run.nil?
      if run
        r << "env" unless run.dig("env", "HEAD_REF").to_s.include?("github.head_ref")
        r << "inline" if run["run"].to_s.include?("github.head_ref")
      end
    end
    puts r.join(",")
  ' "$1" 2>&1
}

echo "=== req-002 AC-1 and AC-2: the squash-before-main job ==="
for wf in "$WF_REPO" "$WF_TPL"; do
  n="$(basename "$(dirname "$wf")")/$(basename "$wf")"
  assert_equals "" "$(check "$wf")" "$n holds the job with its condition, checkout, permission, and env"
  W="$(grep -c 'contents: write' "$wf")"
  assert_equals "1" "$W" "$n still has one write scope (release-tag)"
done

print_summary
