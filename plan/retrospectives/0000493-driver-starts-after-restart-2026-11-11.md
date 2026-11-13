---
title: "Retrospective: 2026-11-11 - Driver starts after restart"
summary: "A blameless review of step 48, which made the driver hand over new starts after a Restart."
status: "open"
---
# Retrospective: 2026-11-11 - Driver starts after restart

> Path: `plan/retrospectives/0000493-driver-starts-after-restart-2026-11-11.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000493-driver-starts-after-restart
**Date:** 2026-11-11

## Summary

The driver now hands new starts to a successor after a Restart-only merge. The run took 79 minutes and needed one rework.

## What helped

- The scheduler fixture made real-process handoff tests cheap to write (`src/ravintio-zero/tests/helpers/scheduler-fixture.sh`).
- A subagent wrote the text unit while the driver unit ran in the main context (build log, P2 notes).
- The clean-clone suite found the tree-path failure before the PR (`plan/postmortems/2026-11-11-tree-comparison-path.md`).

## What slowed the work

- The two-tree layout doubled each copy step and hid a test path bug (build log, `Rework: REQ-004`).
- The full suite took about 22 minutes while other steps ran (build log, P3 wall clock).
- The agent started the P3 suite twice, which cost one stopped run (build log, P3 notes).

## Keep

- Run the driver unit inline when all requirements share one script and one fixture (build log, P2 notes).
- Check the coordinator-visible output with a real successor process, not a mock (`test-0000493-req-001-003-handoff.sh`).

## Change

- Run each new suite from both pack trees before it counts as green (`plan/postmortems/2026-11-11-tree-comparison-path.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Give suites a helper that finds both trees, and state the rule in the testing standards | pack maintainers | `src/ravintio-zero/tests/helpers/`, `src/ravintio-zero/standards/testing-standards.md` | a suite that runs from both trees | backlog 0000528 (names this retrospective) |
