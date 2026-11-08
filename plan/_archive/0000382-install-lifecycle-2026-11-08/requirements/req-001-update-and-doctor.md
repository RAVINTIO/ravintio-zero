---
title: "Requirement: req-001 - Update and doctor"
summary: "One command updates the pack and one command checks the install."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - Update and doctor

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Source:** US-001
**Priority:** must-have

## User Story

As a developer, I update the pack and check the install with one command each.

## Functional Requirements

- `setup.sh claude-code --doctor` reports whether setup ran and `CLAUDE.md` is the pack's, whether every hook is executable and wired, whether the skills match the pack, whether the installed flags match `plan/state/{tool}.md`, and whether files from an older pack remain. It exits non-zero on any failure and names each one.
- `setup.sh claude-code --update {source}` copies the pack from a local folder, commits the pack files, and reruns setup with the flags in `plan/state/{tool}.md`.
- Setup creates `plan/current/`.
- `setup.sh` and `setup.ps1` behave the same.

## Acceptance Criteria

- [ ] AC-1: Doctor fails on a copied pack
  - Given a repo where the pack is copied and setup never ran
  - When the developer runs doctor
  - Then it exits non-zero and says setup has not run
- [ ] AC-2: Doctor names a bad hook
  - Given an installed repo with one non-executable hook
  - When the developer runs doctor
  - Then it exits non-zero and names that hook
- [ ] AC-3: Update keeps the flags
  - Given a record with `--strict-orchestrator` and a newer pack folder
  - When the developer runs update
  - Then the pack files are committed, setup reruns with that flag, and `plan/current/` exists

## Dependencies

- req-002
