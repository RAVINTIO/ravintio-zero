---
title: "Requirement: REQ-002 - BOM first-line readers"
summary: "Each script that reads a first line of a boot file handles a BOM, and a fixture suite fails when one does not."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - BOM first-line readers

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000462-tests-without-git-identity
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer of the pack, I see a suite fail locally when a script cannot read a boot file with a BOM. Then Windows PowerShell 5.1 files do not fail only in CI.

## Functional Requirements
- A new suite writes a `CLAUDE.md` that starts with the three bytes of a UTF-8 BOM, followed by the pack's own text.
- The suite runs `doctor` in `install-lifecycle.mjs` and `preserve_developer_boot_file` in `setup.sh` against that file.
- `setup.ps1` runs against the same fixture in a PowerShell suite when `pwsh` is present.
- A reader that fails the fixture gets a fix that strips the BOM before it compares the first line.

## Acceptance Criteria
- [ ] AC-1: readers accept a BOM
  - Given a workspace whose `CLAUDE.md` starts with a BOM and holds the pack's text
  - When `doctor` and `setup.sh` read it
  - Then `doctor` reports the file as the pack's
  - And setup copies nothing to `ravintio-overrides/instructions/`
- [ ] AC-2: the PowerShell reader accepts a BOM
  - Given the same workspace and `pwsh`
  - When `setup.ps1` reads it
  - Then setup copies nothing to `ravintio-overrides/instructions/`
- [ ] AC-3: the PR #136 defect fails
  - Given a scratch copy of `install-lifecycle.mjs` without its BOM strip
  - When `doctor` reads the fixture
  - Then `doctor` reports the file as not the pack's, and the shipped script reports it as the pack's

## Dependencies
- none
