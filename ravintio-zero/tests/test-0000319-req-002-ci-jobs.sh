#!/usr/bin/env bash
# Tests for feature 0000319-initiative-history-checks, req-002 and req-004 AC-3.
#
# Both workflow copies hold the initiative-history and main-merge-check jobs.

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
    on = d["on"] || d[true] || {}
    r = []
    r << "push" unless on.dig("push", "branches") == ["main", "master", "initiative/**"]
    jobs = d["jobs"]
    rt = jobs["release-tag"] || {}
    rif = rt["if"].to_s
    r << "rt-push" unless rif.include?("github.event_name == \x27push\x27")
    r << "rt-ref" unless rif.include?("refs/heads/main") && rif.include?("refs/heads/master")
    ih = jobs["initiative-history"]
    if ih.nil? then r << "ih-missing" else
      c = ih["if"].to_s
      r << "ih-pr" unless c.include?("pull_request") && c.include?("base_ref == \x27main\x27") && c.include?("startsWith(github.head_ref, \x27initiative/\x27)")
      r << "ih-run" unless ih["steps"].to_s.include?("check-initiative-history.mjs")
      r << "ih-perm" unless ih.dig("permissions", "contents") == "read"
    end
    mm = jobs["main-merge-check"]
    if mm.nil? then r << "mm-missing" else
      c = mm["if"].to_s
      r << "mm-push" unless c.include?("github.event_name == \x27push\x27") && c.include?("refs/heads/main")
      r << "mm-run" unless mm["steps"].to_s.include?("check-main-merge.mjs")
      r << "mm-perm" unless mm.dig("permissions", "contents") == "read"
    end
    r << "nxt-perm" if d.dig("permissions", "contents") != "read"
    puts r.join(",")
  ' "$1" 2>&1
}

echo "=== req-002 and req-004 AC-3: workflow jobs ==="
for wf in "$WF_REPO" "$WF_TPL"; do
  n="$(basename "$(dirname "$wf")")/$(basename "$wf")"
  assert_equals "" "$(check "$wf")" "$n holds the push trigger, release-tag guard, and both jobs"
done

echo ""
echo "=== NFR-001: no job gains a token scope ==="
for wf in "$WF_REPO" "$WF_TPL"; do
  n="$(basename "$(dirname "$wf")")/$(basename "$wf")"
  W="$(grep -c 'contents: write' "$wf")"
  assert_equals "1" "$W" "$n has one write scope (release-tag)"
done

print_summary
