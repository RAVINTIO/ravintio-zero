---
title: "Requirement: REQ-002 - CI duration marker and target in the standards"
summary: "The governance standard defines the marker and threshold, the testing standard names the target, and the ship skill writes the marker."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - CI duration marker and target in the standards

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000472-ci-duration-metric
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I see the longest CI run of a feature in the governance report, so that CI growth shows before it hurts.

## Functional Requirements
- `workflow-governance-standards.md` lists the metric, its `ci-duration-seconds` key, its writer, the marker `CI duration: {seconds}s (run {run-id}, {ISO-8601 timestamp})`, and a Thresholds row of 420.
- `testing-standards.md` holds a CI duration target of 420 seconds and says that the governance report shows the longest run.
- `ravintio-ship/SKILL.md` tells ship to read the run's duration with `gh run view` when the CI wait ends and to append the marker to the build log. It tells ship to skip the marker when `gh` returns no run.

## Acceptance Criteria
- [ ] AC-1: governance standard
  - Given the governance standard
  - When the test reads it
  - Then it names the marker, the `ci-duration-seconds` key, and the threshold 420
- [ ] AC-2: CI target
  - Given the testing standard
  - When the test reads it
  - Then it names the CI duration target of 420 seconds
- [ ] AC-3: ship marker
  - Given the ship skill
  - When the test reads it
  - Then it names `gh run view` and the `CI duration:` marker

## Dependencies
- REQ-001
