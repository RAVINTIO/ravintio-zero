#!/usr/bin/env bash
# Prints the name of each job in a workflow file that has neither the marker
# comment "# ravintio:job-guard-exempt" on the line above its key nor the
# pull request guard as its whole "if" condition (0000355 REQ-003).
# Usage: unguarded-jobs.sh <workflow-file>
# Needs ruby. Prints nothing when every job passes.
set -uo pipefail
wf="$1"
exempt="$(awk '
  /^[[:space:]]*# ravintio:job-guard-exempt[[:space:]]*$/ { m = 1; next }
  /^  [A-Za-z0-9_-]+:[[:space:]]*$/ { if (m) { k = $1; sub(/:$/, "", k); print k } m = 0; next }
  { m = 0 }
' "$wf")"
EXEMPT="$exempt" ruby -ryaml -e '
  d = YAML.load_file(ARGV[0])
  ex = ENV["EXEMPT"].split("\n")
  guard = "github.event_name == \x27pull_request\x27 && github.event.action != \x27closed\x27"
  (d["jobs"] || {}).each do |k, j|
    next if ex.include?(k)
    puts k unless j["if"] == guard
  end
' "$wf"
