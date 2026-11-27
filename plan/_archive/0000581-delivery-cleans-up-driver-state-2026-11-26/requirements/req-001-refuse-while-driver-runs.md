---
title: "Requirement: REQ-001 - The cleanup refuses while a driver runs"
summary: "The cleanup script changes nothing while plan/.initiative-runner.lock exists."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - The cleanup refuses while a driver runs

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I run one script after the initiative PR merges, so that the driver state of the delivered initiative leaves `plan/`.

## Functional Requirements
- `initiative-cleanup.mjs --id {id}-{slug} [--root <dir>]` checks `plan/.initiative-runner.lock` first.
- If the lock exists, the script prints `I-E Delivery: Blocked: a driver holds plan/.initiative-runner.lock` and exits 1.
- A missing or invalid `--id` prints `I-E Delivery: Blocked:` with the reason and exits 1.

## Acceptance Criteria
- [ ] AC-1: The lock blocks the cleanup
  - Given a root with `plan/.initiative-runner.lock` and both driver folders
  - When the script runs
  - Then it exits 1, prints the `Blocked:` line, and moves nothing
- [ ] AC-2: A bad id blocks the cleanup
  - Given a root with no lock
  - When the script runs with no `--id` or with an id that holds `..`
  - Then it exits 1 and moves nothing

## Dependencies
- None.
