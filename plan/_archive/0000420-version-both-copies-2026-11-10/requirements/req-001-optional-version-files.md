---
title: "Requirement: REQ-001 - optional version files"
summary: "A list entry with a ? prefix is optional, the list names the pack source copy, and the queue stages present files only."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - optional version files

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000420-version-both-copies
**Source:** US-001
**Priority:** must-have

## User Story

As an initiative coordinator, I want each version bump to keep both pack copies in step. Then CI passes after the bump.

## Functional Requirements
- A list line that starts with `? ` names an optional file.
- `readVersions` and `setVersions` read and write an optional file that exists. They skip one that is missing.
- `resolveInRoot` checks every path, optional or not.
- A new export, `presentPaths(root, list)`, returns the listed paths that exist.
- `merge-queue.mjs` stages `presentPaths` with `git add`.
- The shipped list adds `? src/ravintio-zero/component.yml`.

## Acceptance Criteria
- [ ] AC-1: optional entries
  - Given a list with a required file and two optional files, one present and one missing
  - When `setVersions` runs
  - Then the required and present files hold the new version, and the run does not fail
- [ ] AC-2: required entries
  - Given a list whose required file is missing
  - When `readVersions` or `setVersions` runs
  - Then it fails with `file not found`
- [ ] AC-3: the shipped list
  - Given the shipped `version-files.txt`
  - When the test reads it
  - Then it names `? src/ravintio-zero/component.yml` and the three required files

## Dependencies
- none
