---
title: "Requirement: REQ-001 - Version file list and check"
summary: "One list of version files that the bump and the check both read."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Version file list and check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I list the version files once, so that the bump and the check read the same list.

## Functional Requirements

- `ravintio-zero/version-files.txt` lists one repo-relative path per line: `docs/about.md`, `product.yml`, and `ravintio-zero/component.yml`.
- `version-files.mjs check` reads every listed file and exits 1 with the differing paths if the versions are not identical.
- `version-files.mjs set {version}` writes the version into every listed file and exits 1 for a value that is not `MAJOR.MINOR.PATCH`.
- Both commands refuse a listed path that resolves outside the repo root.

## Acceptance Criteria

- [ ] AC-1: check passes on matching files
  - Given three version files that hold `0.58.0`
  - When `version-files.mjs check` runs
  - Then it exits 0
- [ ] AC-2: check names a differing file
  - Given `component.yml` holds `0.57.0` and the other two hold `0.58.0`
  - When `version-files.mjs check` runs
  - Then it exits 1 and names `ravintio-zero/component.yml`
- [ ] AC-3: set updates every file
  - Given three version files that hold `0.57.0`
  - When `version-files.mjs set 0.58.0` runs
  - Then every file holds `0.58.0`, and a path outside the root exits 1

## Dependencies

- None
