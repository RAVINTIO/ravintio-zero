---
title: "Retrospective: 2026-11-12 - Check every hook after setup"
summary: "A blameless review of the hook check run, and the change it files."
status: "closed"
---
# Retrospective: 2026-11-12 - Check every hook after setup

> Path: `plan/retrospectives/0000507-hook-check-after-setup-2026-11-12.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000507-hook-check-after-setup
**Date:** 2026-11-12

## Summary

The run shipped `hook-check.mjs`, its driver wiring, and two suites. P3 execution verification found one defect, and the run fixed it before the PR.

## What helped

- Execution verification on a copy with a deleted guard script found the missing-guard pass. Tests alone had passed. (`plan/_archive/0000507-hook-check-after-setup-2026-11-12/verification-report.md`)
- Existing driver fixtures let the wiring test reuse the 0000448 setup, so the new suite needed little new code. (`src/ravintio-zero/tests/test-0000507-req-003-driver-hook-check.sh`)
- A scratch clone of the base commit gave a baseline that the working tree could not give. (`baseline-failures.md` in the archive)

## What slowed the work

- P0 stood idle from 07:25Z to 13:36Z while a design question waited. (build log, P0 wall clock 379 minutes)
- The first baseline run died with the session that started it, and a second pair of runs hit the 10-minute background limit. (build log, P2 notes)
- The clean-clone suite prints nothing in quiet mode, so a long run gives no progress. (build log, P3)

## Keep

- Run P3 execution verification against a deliberately broken copy, not only against the healthy repo. (verification report, "Finding from execution")

## Change

- The plan skill does not ask the planner to list each way a checked component produces its pass signal. (postmortem `plan/postmortems/2026-11-12-missing-guard-passed-hook-check.md`)

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Plan skill lists each pass path of a checked component | pack maintainers | `src/ravintio-zero/skills/ravintio-plan/SKILL.md` | A skill test for the new step | backlog entry 0000529, from this retrospective |
