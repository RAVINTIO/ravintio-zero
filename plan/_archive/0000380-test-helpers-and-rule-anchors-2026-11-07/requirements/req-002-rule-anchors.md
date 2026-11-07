---
title: "Requirement: req-002 - Rule anchors"
summary: "Rules carry anchors and a helper reads a rule by anchor."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - Rule anchors

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000380-test-helpers-and-rule-anchors
**Source:** US-002
**Priority:** must-have

## User Story

As a pack maintainer, I read a rule by its anchor, so that rewording the rule keeps its tests green.

## Functional Requirements

- A rule anchor is `<!-- rule: {id} -->` on its own line before the rule. The id uses lowercase letters, digits, and hyphens.
- `rule_text <id>` returns the rule's text from any file under `skills/`, `standards/`, or `templates/`.
- `assert_rule <id> <term>...` passes when the anchor exists once and holds every term. It fails and names the anchor otherwise.
- A suite checks that every anchor id is unique and well formed.
- The orchestrator references and roadmap standards carry anchors on the rules the converted suites pin.

## Acceptance Criteria

- [ ] AC-1: Anchor survives a move
  - Given an anchored rule in one file
  - When the rule and its anchor move to another file
  - Then `assert_rule` still passes
- [ ] AC-2: Reword keeps terms
  - Given a rule reworded to keep its key terms
  - When `assert_rule` runs
  - Then it passes
- [ ] AC-3: Missing anchor fails by name
  - Given a rule whose anchor is deleted
  - When `assert_rule` runs
  - Then it fails and the failure line names the anchor id

## Dependencies

- req-001
