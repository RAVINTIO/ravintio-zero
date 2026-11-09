#!/usr/bin/env bash
# Test: 0000380 req-001 section-helper
# orch_section returns a named section from SKILL.md, the orchestrator references,
# and the roadmap standards, so moving a section between them fails no test.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== AC-1: a section is found in a reference file ==="
sec="$(orch_section '## Phase Invocation')"; rc=$?
assert_equals "0" "$rc" "the helper exits 0 for a heading it finds"
assert_contains "Context size at gates" "$sec" "the Phase Invocation section holds its context size rule"
assert_not_contains "## Exception Stops" "$(printf '%s\n' "$sec" | sed -n '2,$p')" "the section stops before the next same-level heading"

echo "=== AC-1: a section is found in SKILL.md ==="
sec="$(orch_section '## Subagent Dispatch')"; rc=$?
assert_equals "0" "$rc" "the helper exits 0 for a heading in SKILL.md"
assert_contains "agent-dispatch-standards.md" "$sec" "the SKILL.md section text comes back"

echo "=== AC-1: a section is found in the roadmap standards ==="
sec="$(orch_section '### I-A Chart')"
assert_contains "clarity check" "$sec" "a roadmap standards section comes back"

echo "=== AC-1: a move between files changes no result ==="
FAKE="$(mktemp -d "${TMPDIR:-/tmp}/sec380.XXXXXX")"
mkdir -p "$FAKE/skills/ravintio-orchestrator/references" "$FAKE/standards"
printf '# Skill\n\n## Moved Section\n\nbody text\n\n## Next\n\nother\n' > "$FAKE/skills/ravintio-orchestrator/SKILL.md"
before="$(ORCH_PACK_ROOT="$FAKE" orch_section '## Moved Section')"
printf '# Skill\n\n## Next\n\nother\n' > "$FAKE/skills/ravintio-orchestrator/SKILL.md"
printf '# Ref\n\n## Moved Section\n\nbody text\n\n## Next\n\nother\n' > "$FAKE/skills/ravintio-orchestrator/references/orchestrator-moved.md"
after="$(ORCH_PACK_ROOT="$FAKE" orch_section '## Moved Section')"
assert_equals "$before" "$after" "the section text is the same after a move to a reference file"
assert_contains "body text" "$after" "the moved section keeps its body"

echo "=== a heading inside a fenced block does not end the section ==="
printf '# Ref\n\n## Fenced\n\n```\n## not a heading\n```\n\ntail line\n\n## After\n' > "$FAKE/skills/ravintio-orchestrator/references/orchestrator-moved.md"
sec="$(ORCH_PACK_ROOT="$FAKE" orch_section '## Fenced')"
assert_contains "tail line" "$sec" "text after a fenced pseudo-heading stays in the section"
assert_not_contains "## After" "$sec" "the next real heading ends the section"

echo "=== AC-2: a heading in no file fails ==="
sec="$(ORCH_PACK_ROOT="$FAKE" orch_section '## No Such Heading')"; rc=$?
assert_equals "1" "$rc" "the helper exits 1 for a missing heading"
assert_contains "SECTION NOT FOUND: ## No Such Heading" "$sec" "the marker names the heading"
rm -rf "$FAKE"

print_summary
