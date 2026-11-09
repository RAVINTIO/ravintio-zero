#!/usr/bin/env bash
# Tests for feature 0000321-backlog-triage, req-003 AC-1.
#
# Both workflow copies run the backlog index check in a job that checks out
# the repo. The sibling node steps rely on the Node that ubuntu-latest ships,
# so the job needs no setup-node step.

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
    cmd = "node ravintio-zero/scripts/backlog-index.mjs --check"
    hits = d["jobs"].select { |_, j| (j["steps"] || []).any? { |s| s["run"].to_s.strip == cmd } }
    if hits.size != 1
      puts "step-count-#{hits.size}"
    else
      steps = hits.values.first["steps"]
      names = steps.select { |s| s["run"].to_s.strip == cmd }.map { |s| s["name"] }
      r = []
      r << "name" unless names == ["Check the backlog index"]
      r << "checkout" unless steps.any? { |s| s["uses"].to_s.start_with?("actions/checkout@") }
      puts r.join(",")
    end
  ' "$1" 2>&1
}

echo "=== req-003 AC-1: both workflows run the index check ==="
for wf in "$WF_REPO" "$WF_TPL"; do
  n="$(basename "$(dirname "$wf")")/$(basename "$wf")"
  assert_equals "" "$(check "$wf")" "$n runs the check once, named, in a job that checks out the repo"
done

print_summary
