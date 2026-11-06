---
title: "Requirement: REQ-003 - Setup record stays put"
summary: "Setup record stays put."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Setup record stays put

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0
**Source:** US-003
**Priority:** must-have

## User Story

As a coordinator, I want setup to leave `plan/state/{tool}.md` unchanged when only `writtenAt` would change, so that a `Setup:` stop needs no PR.

## Functional Requirements
- `setup.sh` and `setup.ps1` compare `tool` and `flags` with the existing record. If both match, they leave the file unchanged and print `= plan/state/{tool}.md (unchanged)`.
- If the record is missing or differs, setup writes it with a fresh `writtenAt`.
- The ignored marker `.ravintio-setup-flags` keeps its timestamp.

## Acceptance Criteria
- [ ] AC-1: rerun is clean
  - Given a repo where setup has run once and the record is committed
  - When setup runs a second time
  - Then `git status` is clean
- [ ] AC-2: flags change
  - Given an existing record
  - When setup runs with a different flag set
  - Then the record changes
- [ ] AC-3: PowerShell parity
  - Given `setup.ps1`
  - When a test reads it
  - Then it holds the same compare and message
