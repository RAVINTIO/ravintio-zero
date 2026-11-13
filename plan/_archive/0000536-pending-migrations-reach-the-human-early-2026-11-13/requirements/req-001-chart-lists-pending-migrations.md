---
title: "Requirement: REQ-001 - Chart lists pending migrations"
summary: "I-A Chart lists every pending migration and takes the human's answer before any step starts."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Chart lists pending migrations

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000536-pending-migrations-reach-the-human-early
**Source:** US-001
**Priority:** must-have

## User Story

As the human, I answer every pending migration at I-A Chart, so that no step asks me later.

## Functional Requirements
- The roadmap standards hold a `Chart-time migrations` section.
- The section tells Chart to run resume detection and list each `pending migration` finding.
- The section tells Chart to take the human's answer for each one, `all` or `none`.
- The section tells Chart to write each answer as a `## Decisions` row whose Fork starts with `Migration:`.
- The initiative skill names the same rule in its I-A Chart section.

## Acceptance Criteria
- [ ] AC-1: Section exists
  - Given the roadmap standards
  - When a reader looks for the chart-time migration rule
  - Then a `Chart-time migrations` section describes the listing, the answer, and the `Migration:` row
- [ ] AC-2: Skill points to it
  - Given the initiative skill
  - When Chart runs
  - Then the skill tells the coordinator to list pending migrations before any step starts

## Dependencies
- None
