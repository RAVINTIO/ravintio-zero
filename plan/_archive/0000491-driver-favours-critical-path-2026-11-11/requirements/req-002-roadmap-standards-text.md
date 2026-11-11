---
title: "Requirement: REQ-002 - The standards state the start order"
summary: "roadmap-standards.md says the driver starts the step with the longest chain behind it first."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - The standards state the start order

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000491-driver-favours-critical-path
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I want the standards to state the start order, so that I chart lanes knowing which step starts first.

## Functional Requirements
- Item 2 of `## Concurrent steps` in `roadmap-standards.md` says the driver starts startable steps longest chain first.
- The text defines the chain as the unmerged steps that wait behind a step through `After` lists or a shared lane. It says chart order breaks ties.

## Acceptance Criteria
- [ ] AC-1: the standards state the order
  - Given `roadmap-standards.md`
  - When a reader reads item 2 of `## Concurrent steps`
  - Then it names the longest chain first order and the chart order tie rule

## Dependencies
- REQ-001
