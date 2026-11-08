---
title: "Requirement: req-006 - Pack facts file"
summary: "A script generates one facts file from the pack, and CI fails when it is stale."
status: "active"
version: "0.1.0"
---
# Requirement: req-006 - Pack facts file

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Source:** US-006
**Priority:** must-have

## User Story

As a writer, I take every pack fact from one generated file.

## Functional Requirements

- `ravintio-zero/scripts/pack-facts.mjs` writes `ravintio-zero/pack-facts.json` and has a `--check` mode that exits non-zero when the file differs from a fresh run.
- The file lists the setup flags and their effects, what setup creates or changes, each hook with its event, matcher, and block, each skill with its description, and the phases and stages.
- CI runs the check.

## Acceptance Criteria

- [ ] AC-1: Flags listed
  - Given the facts file
  - When a test compares it to `setup.sh` and `setup.ps1`
  - Then every accepted flag appears
- [ ] AC-2: Hooks listed
  - Given the facts file
  - When a test compares it to the hooks setup wires
  - Then every hook appears
- [ ] AC-3: Stale file fails
  - Given an edited facts file
  - When `--check` runs
  - Then it exits non-zero

## Dependencies

- req-001, req-002, req-003, req-004, req-005 (the file records their flags)
