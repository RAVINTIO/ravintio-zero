---
title: "Requirement: REQ-002 - Installed copy and parity"
summary: "Keep ravintio-zero/ as a plain copy that matches the source."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Installed copy and parity

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000397-pack-source-in-src
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I run the pack from `ravintio-zero/`, a plain copy, so that a source change does not change the running pack.

## Functional Requirements
- A second commit copies `src/ravintio-zero/` to `ravintio-zero/` as plain files.
- No symlink joins the folders.
- `sync-installed.mjs --check` reports any file that differs.

## Acceptance Criteria
- [ ] AC-1: Byte parity
  - Given the final tree
  - When you run `node src/ravintio-zero/scripts/sync-installed.mjs --check`
  - Then it exits 0
- [ ] AC-2: Check reports drift
  - Given one file in `ravintio-zero/` differs from the source
  - When you run the same command
  - Then it exits 1 and names the file

## Dependencies
- REQ-001.
