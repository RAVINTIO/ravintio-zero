---
title: "Requirement: REQ-002 - The cleanup archives the logs and control folders"
summary: "The script moves the driver logs and control files to the repo git folder."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - The cleanup archives the logs and control folders

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I run one script after the initiative PR merges, so that the driver state of the delivered initiative leaves `plan/`.

## Functional Requirements
- The script moves `plan/.initiative-logs/` and `plan/.initiative-control/` to `.git/ravintio-archive/{id}-{slug}/`.
- If the target folder exists, the script adds a numeric suffix and never overwrites it.
- A missing source folder prints `I-E Delivery: Kept: {folder} is absent` and exits 0.
- The script refuses a symlink at any path it touches and prints `I-E Delivery: Blocked: refused a symlinked path`.
- A rerun after a partial move moves only what remains.

## Acceptance Criteria
- [ ] AC-1: Both folders move
  - Given a root with the two folders and no lock
  - When the script runs with an id
  - Then both folders sit under `.git/ravintio-archive/{id}-{slug}/` and leave `plan/`
- [ ] AC-2: An existing target is kept
  - Given an archive folder with the same name
  - When the script runs
  - Then the new folders land in a suffixed folder and the old one is unchanged
- [ ] AC-3: A symlink is refused
  - Given `plan/.initiative-logs` is a symlink
  - When the script runs
  - Then it exits 1 and moves nothing

## Dependencies
- REQ-001.
