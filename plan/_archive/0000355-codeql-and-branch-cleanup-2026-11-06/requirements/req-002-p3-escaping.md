---
title: "Requirement: REQ-002 - P3 incomplete escaping"
summary: "The P3 security checklist names incomplete escaping."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - P3 incomplete escaping

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Source:** US-002
**Priority:** must-have

## User Story

As a reviewer, I see incomplete escaping named in the P3 security checklist, so that a missed backslash is a finding.

## Functional Requirements
- The injection points item in `ravintio-validate-and-accept/SKILL.md` names incomplete escaping or sanitising.
- The item gives the example of a backslash missed before an escaped pipe, quote, or delimiter.

## Acceptance Criteria
- [ ] AC-1: checklist names the flaw
  - Given the validate skill
  - When a test reads the injection points item
  - Then it contains "incomplete escaping"
- [ ] AC-2: example present
  - Given the same item
  - When a test reads it
  - Then it names a backslash before an escaped delimiter

## Dependencies
- None.
