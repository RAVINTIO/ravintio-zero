---
title: "Requirement: REQ-002 - coordinator PR bar and carve-out"
summary: "The standards define the coordinator PR and the carve-out names it."
status: "active"
version: "0.44.0"
---
# Requirement: REQ-002 - coordinator PR bar and carve-out

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000318-titled-coordinator-prs
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I want the merge carve-out to name coordinator PRs and the bar they meet, so that the agent may land them without widening `merge-guard`.

## Functional Requirements

- The standards hold a `## Coordinator PRs` section. It sets the title form `{id}-{slug}: {summary} (#{n})`, a passing local suite, green CI, and the agent squash.
- The coordinator raises a coordinator PR only while the driver is stopped. While a step runs, it queues work.
- The `## Merge carve-out` section names coordinator PRs and keeps its existing conditions.
- The initiative skill points to the section.

## Acceptance Criteria

- [ ] AC-1: the section exists
  - Given the roadmap standards
  - When a test reads `## Coordinator PRs`
  - Then it names the title form, the local suite, green CI, and the squash
- [ ] AC-2: the carve-out names coordinator PRs
  - Given the `## Merge carve-out` section
  - When a test searches it
  - Then it names coordinator PRs, `own feature branch`, `clean P3`, and `green CI`
- [ ] AC-3: the skill points to the section
  - Given the initiative skill
  - When a test searches it
  - Then it names coordinator PRs and the stopped driver

## Dependencies

REQ-001
