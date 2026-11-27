#!/usr/bin/env bash
# Content-pinning tests for the doc/workflow-only requirements of feature
# 0000027 that survive the five-phase cut-down: req-003 (subagent
# backlog filing), req-005 (pack update policy), req-007 (skill-scope
# test), req-008 (minimal plan-phase artifact set). Asserts the required
# content exists in its current homes rather than executing prose.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo ""
echo "=== req-003: subagent out-of-scope discoveries file to plan/backlog/ ==="

DISPATCH_STANDARDS="$ZERO_DIR/standards/agent-dispatch-standards.md"
assert_rule orc-dispatch-backlog-filing "plan/backlog/{id}-{slug}/entry.md"
assert_rule orc-dispatch-backlog-id "pre-computes the next available backlog ID" "Subagent self-lookup"

for skill in ravintio-orchestrator ravintio-plan ravintio-implement ravintio-validate-and-accept; do
  skill_content=$(cat "$ZERO_DIR/skills/$skill/SKILL.md")
  assert_contains "backlog" "$skill_content" "req-003: $skill references backlog guidance"
done

echo ""
echo "=== req-005: explicit discovery flow for a ravintio-zero/ dependency update ==="

assert_rule resume-pack-update "Pack dependency update" "pack-update-policy.md" "provenance"

assert_equals "yes" "$([ -f "$ZERO_DIR/standards/pack-update-policy.md" ] && echo yes || echo no)" \
  "req-005: standards/pack-update-policy.md exists"

if [ -f "$ZERO_DIR/standards/pack-update-policy.md" ]; then
  policy_content=$(cat "$ZERO_DIR/standards/pack-update-policy.md")
  assert_contains "provenance" "$policy_content" \
    "req-005: Pack Update Policy requires provenance confirmation"
fi

echo ""
echo "=== req-007: skill-scope test guards the process that adds a skill ==="

assert_rule orc-skills-intake "skill-scope test" "governance or traceability the host tool cannot provide"

echo ""
echo "=== req-008: minimal plan-phase artifact set agrees between workflow and plan skill ==="

PIPELINE_WORKFLOW="$ZERO_DIR/workflows/feature-pipeline.md"
pipeline_content=$(cat "$PIPELINE_WORKFLOW")
assert_contains "one artifact set: the execution plan, functional" "$pipeline_content" \
  "req-008: feature-pipeline.md's always-produced list starts with execution plan + requirements"

plan_content=$(cat "$ZERO_DIR/skills/ravintio-plan/SKILL.md")
assert_rule orc-plan-conditional-set "produced only when its trigger holds"
assert_contains "The feature builds or modifies an API" "$plan_content" \
  "req-008: ravintio-plan states OpenAPI's trigger condition"
assert_contains "The feature introduces or modifies a deployed runtime service" "$plan_content" \
  "req-008: ravintio-plan states the operational model's trigger condition"

README_CONTENT=$(cat "$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)/README.md")
assert_contains "five plan-phase artifacts by default" "$README_CONTENT" \
  "req-008: README states the default artifact count"

print_summary
