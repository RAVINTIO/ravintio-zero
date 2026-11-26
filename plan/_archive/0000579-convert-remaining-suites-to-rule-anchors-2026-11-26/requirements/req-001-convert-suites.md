---
title: "Requirement: REQ-001 - Convert prose-pinning suites"
summary: "Each suite that pins a rule's prose reads it through a rule anchor and key terms."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Convert prose-pinning suites

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000579-convert-remaining-suites-to-rule-anchors
**Version:** 0.149.0
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I reword a rule that keeps its anchor and key terms, so that no suite breaks.

## Functional Requirements
- Each rule that a prose-pinning suite checks in a skill, standard, or template carries a `<!-- rule: {id} -->` anchor. Ids are unique and use lowercase letters, digits, and hyphens.
- Each such suite reads the rule through `assert_rule`, `rule_text`, or `orch_section`, and checks key terms, not whole sentences.
- A suite keeps every check it had. Each key term set holds the terms the old pin held.
- A structure check stays as it is.
- The copies in `tests/regression/` stay as they are.
- A rule's meaning does not change.

## Acceptance Criteria
- [ ] AC-1: a converted suite reads its rule by anchor
  - Given a suite on the ledger
  - When a reader opens it
  - Then it calls `assert_rule`, `rule_text`, or `orch_section` and cuts no section with `sed` or `awk`
- [ ] AC-2: a converted suite passes from both pack trees
  - Given the two pack trees
  - When the suite runs from `src/ravintio-zero/tests/` and from `ravintio-zero/tests/`
  - Then it exits 0 in each
- [ ] AC-3: anchors stay unique and well formed
  - Given the pack
  - When `test-0000380-req-002-rule-anchors.sh` runs
  - Then it passes

## Dependencies
- None
