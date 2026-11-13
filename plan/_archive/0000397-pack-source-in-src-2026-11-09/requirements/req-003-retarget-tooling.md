---
title: "Requirement: REQ-003 - Retarget tests and CI"
summary: "Point tests, CI, and source scripts at the source folder."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Retarget tests and CI

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000397-pack-source-in-src
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I run tests, CI, and source scripts against `src/ravintio-zero/`, so that they check the source.

## Functional Requirements
- Each test finds the repo root with `git rev-parse --show-toplevel` and the pack with its own location.
- The same test file passes from either folder, because the two copies match byte for byte.
- CI jobs call scripts under `src/ravintio-zero/`.

## Acceptance Criteria
- [ ] AC-1: Suite passes from the source
  - Given the final tree
  - When you run `bash src/ravintio-zero/tests/run-tests.sh`
  - Then it exits 0
- [ ] AC-2: CI uses the source
  - Given `.github/workflows/ravintio.yml`
  - When you search it for `node ravintio-zero/scripts`
  - Then no pack check calls the installed copy

## Dependencies
- REQ-001, REQ-002.
