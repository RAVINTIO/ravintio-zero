---
title: "Requirement: REQ-001 - Path move cause"
summary: "The scan lists the greps for suites that depend on folder depth or path-keyed state when a run moves a folder."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Path move cause

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000565-layout-move-test-impact
**Version:** 0.123.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I see a `Path move` cause, so that I grep the tests for depth-based root lookups and list path-keyed state files.

## Functional Requirements
- The reference file holds a `Path move` cause.
- The cause fires when the run renames or moves a folder.
- The cause names two greps: `$ZERO_DIR/..` and `SCRIPT_DIR/../..`.
- The cause lists each state file that keys data by path, such as `plan/state/prose-baseline.json`.

## Acceptance Criteria
- [ ] AC-1: cause named
  - Given the reference file
  - When a reader looks for the cause
  - Then it reads `Path move`
- [ ] AC-2: greps and state files listed
  - Given the cause
  - When a run moves a folder
  - Then the cause names `$ZERO_DIR/..` and `SCRIPT_DIR/../..`
  - And it names path-keyed state files such as `plan/state/prose-baseline.json`
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When a reader compares the reference file
  - Then the files are identical

## Dependencies
- None
