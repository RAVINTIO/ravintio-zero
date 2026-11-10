---
title: "Requirement: REQ-001 - refuse a step merge"
summary: "merge-guard blocks a tripped merge command when RAVINTIO_INITIATIVE_QUEUE is 1, and the carve-out text names the queue as the only step merge path."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - refuse a step merge

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000458-refuse-step-merge-outside-queue
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I want `merge-guard` to refuse a PR merge from a step session. Then the merge queue is the only path that merges a step PR.

## Functional Requirements
- `merge-guard.mjs` reads `RAVINTIO_INITIATIVE_QUEUE`. When it equals `1` and the command trips the raw-text wire, the guard exits 2 before it parses the command or runs `gh`.
- The block message states that the merge queue merges step PRs.
- A value other than `1`, an empty value, or no variable leaves today's rules unchanged.
- The carve-out text in `roadmap-standards.md`, the ship skill, `orchestrator-phase-invocation.md`, `hook-enforcement.md`, and `docs/architecture-overview.md` says that a step session under the concurrent driver never merges.

## Acceptance Criteria
- [ ] AC-1: refusal under the driver
  - Given `RAVINTIO_INITIATIVE_QUEUE=1` and a plain squash merge into `initiative/*`
  - When the guard reads the command
  - Then it exits 2 and the message names the merge queue
  - And it does not call `gh`
- [ ] AC-2: no change without the variable
  - Given no variable, `0`, or an empty value
  - When the guard reads the same command
  - Then it exits 0, and the pinned 0000318 test still passes
- [ ] AC-3: the queue still merges
  - Given the variable set in the parent process
  - When `merge-queue.mjs run` merges a PR with a stub `gh`
  - Then the merge call runs and the run succeeds
- [ ] AC-4: text
  - Given the five documents above
  - When the test reads them
  - Then each names the merge queue as the only step merge path

## Dependencies
- none
