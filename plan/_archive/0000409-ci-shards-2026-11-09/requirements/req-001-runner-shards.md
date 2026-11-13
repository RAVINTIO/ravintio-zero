---
title: "Requirement: REQ-001 - runner shards"
summary: "run-tests.sh and run-tests.ps1 run shard i of n when RAVINTIO_SHARD is set."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - runner shards

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000409-ci-shards
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator of an initiative, I want CI on a step PR to finish in about 5 minutes, so that the queue merges steps sooner.

## Functional Requirements
- Both runners read `RAVINTIO_SHARD` in the form `i/n`, with 1 <= i <= n.
- A runner lists every suite, feature then regression, in its usual order. Suite k (from 0) runs when `k mod n` equals `i - 1`.
- With the variable unset or empty, the runner runs every suite, as before.
- A malformed value prints `RAVINTIO_SHARD must be i/n with 1 <= i <= n` and exits 2.
- The stray-file, tree, and skills checks run in every shard.

## Acceptance Criteria
- [ ] AC-1: shards are disjoint and complete
  - Given a tests folder with five passing suites
  - When `run-tests.sh` runs with `RAVINTIO_SHARD` set to `1/2` and then `2/2`
  - Then each suite runs in exactly one of the two runs
- [ ] AC-2: unset runs everything
  - Given the same folder
  - When `run-tests.sh` runs with no `RAVINTIO_SHARD`
  - Then all five suites run
- [ ] AC-3: a malformed value stops the run
  - Given `RAVINTIO_SHARD` set to `3/2`, `0/2`, or `x`
  - When either runner starts
  - Then it exits 2 and runs no suite

## Dependencies
- none
