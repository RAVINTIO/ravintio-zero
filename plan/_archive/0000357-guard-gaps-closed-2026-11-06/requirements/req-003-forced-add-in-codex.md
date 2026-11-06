---
title: "Requirement: REQ-003 - forced-add guard in Codex"
summary: "Setup copies block-forced-add.mjs into the Codex hooks folder and wires a second PreToolUse group for Bash."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - forced-add guard in Codex

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Source:** US-003
**Priority:** should-have

## User Story

As a Codex user, I get the forced-add guard from setup, so that Codex sessions block the same forms.

## Functional Requirements
- `setup.sh` and `setup.ps1` copy `block-forced-add.mjs` into the Codex hooks folder with the other Codex hook files.
- Both scripts write a second Bash group to the Codex hooks file. It runs `guard-run.mjs guard block-forced-add.mjs` by absolute path, with ` || exit 2`.
- A rerun leaves one group for each guard and keeps any group the user added.
- The setup report lists `block-forced-add` under the active Codex hooks and takes it off the fallback list.
- `hook-enforcement.md` states that Codex runs both guards.

## Acceptance Criteria
- [ ] AC-1: Codex gets the group
  - Given a Codex install
  - When setup runs
  - Then the hooks file holds one group for `merge-guard.mjs` and one for `block-forced-add.mjs`
- [ ] AC-2: rerun adds no duplicate
  - Given a Codex hooks file that setup already wrote
  - When setup runs again
  - Then each guard has exactly one group
- [ ] AC-3: the report and the standard agree
  - Given the setup output and `hook-enforcement.md`
  - When a test reads both
  - Then both name `block-forced-add` as an active Codex hook

## Dependencies
- REQ-001 sets the command form the Codex groups use.
- REQ-002 sets the guard behaviour that Codex runs.
