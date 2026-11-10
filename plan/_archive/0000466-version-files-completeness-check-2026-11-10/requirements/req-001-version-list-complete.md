---
title: "Requirement: REQ-001 - version list completeness"
summary: "The suite fails when version-files.txt omits a file that carries the product version."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - version list completeness

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000466-version-files-completeness-check
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I run the suite, so that it fails when the version list omits a file that carries the product version.

## Functional Requirements
- One test finds every tracked file that carries the pack version. A file qualifies if it is `docs/about.md`, `product.yml`, or a `component.yml`. A file outside `plan/` and `tests/fixtures/` also qualifies if its own `version:` line equals the product version.
- The test compares that set with `version-files.txt`. It counts an optional entry as listed.
- The test runs each check against a fixture repo, so a failing case needs no change to the real list.

## Acceptance Criteria
- [ ] AC-1: the real repo passes
  - Given the repo at its current commit
  - When the test scans tracked files against `version-files.txt`
  - Then the list names every version-carrying file and the check passes
- [ ] AC-2: an omission fails with its path
  - Given a fixture repo with a `component.yml` that the list does not name
  - When the check runs
  - Then it exits 1 and prints the path of that file
- [ ] AC-3: a missing required entry fails with its path
  - Given a fixture list with a required entry whose file does not exist
  - When the check runs
  - Then it exits 1 and prints the path of that entry

## Dependencies
- none
