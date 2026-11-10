---
title: "Requirement: REQ-001 - Archive after green CI"
summary: "An initiative step raises its PR and waits for CI before it archives, so it can still fix a failing check."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-001 - Archive after green CI

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000452-ci-wait-before-archive
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I archive my run after my PR checks pass, so that I can still push a CI fix.

## Functional Requirements
- In an initiative step, the ship skill raises the PR and waits for CI before Step 4 (archive) and Step 8 (clear sentinels).
- During the CI wait, `plan/current/` stays in place. A failing check gets an in-scope fix when the chart field `**Step CI fixes:**` says `allowed`.
- After green CI, the archive, the build report, and the sentinel deletions form the last push before `ready`.
- The roadmap standards describe the same order in I-D Advance.
- A normal run keeps the order in Steps 1 to 10.
- A normal run needs no change to `gate-write`.

## Acceptance Criteria
- [ ] AC-1: Archive follows CI
  - Given the ship skill and the I-D Advance stage
  - When a test reads the order of the initiative steps
  - Then `gh pr create` and the CI wait come before the archive and the sentinel clear
- [ ] AC-2: A failing check is fixable
  - Given a PR whose check fails while `plan/current/design.md` exists
  - When the chart says `allowed`
  - Then `gate-write` allows a code edit and the text tells the step to push an in-scope fix
- [ ] AC-3: Normal run unchanged
  - Given a run outside an initiative
  - When a test reads Steps 1 to 10
  - Then the headings and their order stay the same

## Dependencies
- ADR-0298
