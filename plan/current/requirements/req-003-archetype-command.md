---
title: "Requirement: REQ-003 - Archetype command"
summary: "The archetype command lists the catalogue and copies a pick into the overrides."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-003 - Archetype command

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Source:** US-003
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a pack user, I run `setup.sh archetype use {kind}/{name}`, so that the archetype lands in my overrides and I see what it replaced.

## Functional Requirements
- `archetype list` prints each archetype with its kind and summary.
- `archetype use {kind}/{name}` copies the archetype `files/` folder into `ravintio-overrides/`.
- The command prints each pack file the copy replaces.
- The command records the pick in `ravintio-overrides/archetypes.json` and creates that file on the first pick.
- `setup.sh` and `setup.ps1` only dispatch to `ravintio-zero/scripts/archetype.mjs`.
- A rerun of the same pick changes no file.

## Acceptance Criteria
- [ ] AC-1: Copy and report
  - Given no override for a file that the archetype carries
  - When the user runs `archetype use alternative/us-writing`
  - Then the command copies the files, prints each replaced pack file, and records the pick
- [ ] AC-2: Rerun changes nothing
  - Given the same pick already installed
  - When the user runs the same command again
  - Then no file changes
- [ ] AC-3: Dispatch parity
  - Given `setup.sh` and `setup.ps1`
  - When the user runs `archetype list` through either script
  - Then both print the same output

## Dependencies
- REQ-004 supplies the checks that run first.
- ADR-0293 records the command design.
