---
title: "Requirement: REQ-002 - Ledger and reword probe"
summary: "A guard suite checks the ledger and rewords the anchored rules."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Ledger and reword probe

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000579-convert-remaining-suites-to-rule-anchors
**Version:** 0.149.0
**Source:** US-002
**Priority:** must-have

## User Story

As a pack maintainer, I run one guard suite that rewords the converted rules, so that a suite with a whole-sentence pin fails.

## Functional Requirements
- `tests/helpers/anchor-conversions.txt` lists each converted suite as `converted: {file}` and each structure check as `structure: {file}: {reason}`.
- A new suite reads the ledger. It fails in three cases. A listed file is missing, a converted suite calls none of `assert_rule`, `rule_text`, or `orch_section`, or a structure line has no reason.
- The suite copies the pack to a temporary folder. It inserts a filler word after the first word of each anchored rule line. It then reruns a sample of converted suites from that copy.
- The sample suites pass in the reworded copy.
- The suite runs from both pack trees.

## Acceptance Criteria
- [ ] AC-1: the ledger lists every suite the step judged
  - Given the ledger
  - When the guard suite reads it
  - Then each listed file exists, each converted suite calls a helper, and each structure line holds a reason
- [ ] AC-2: the probe rewords the anchored rules
  - Given a temporary copy of the pack
  - When the probe inserts a filler word into each anchored line and reruns the sample
  - Then every sampled suite passes
- [ ] AC-3: the guard fails on a regressed suite
  - Given a fake ledger entry for a suite that pins a whole sentence
  - When the guard reads it
  - Then it fails and names the suite

## Dependencies
- REQ-001
