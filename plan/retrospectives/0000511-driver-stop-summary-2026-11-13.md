---
title: "Retrospective: 2026-11-13 - Driver prints a stop summary"
summary: "A blameless review of the stop summary run, and the change it files."
status: "closed"
---
# Retrospective: 2026-11-13 - Driver prints a stop summary

> Path: `plan/retrospectives/0000511-driver-stop-summary-2026-11-13.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000511-driver-stop-summary
**Date:** 2026-11-13

## Summary

The run shipped the summary block in `initiative-run.mjs`, one suite, and ADR 0341. One rework moved the block before the final line. The first session ended after it filed a queue item, so a second session ran all five phases.

## What helped

- The archive of step 56 gave a model for every artifact and for the test, so P0 and P1 took about 4 minutes. (`plan/_archive/0000509-clear-merged-ready-files-2026-11-13/`)
- The baseline check named the five failing suites as `new:` at once. (build log, P2 `Rework:` line)
- Waiting on a `done` marker in the output file, not on `pgrep -f`, ended each wait when the suite ended. (build log, P2 wall clock)

## What slowed the work

- The first design broke five suites that read the last driver line, and the full run found them 25 minutes in. A second full run cost 25 more. (`plan/postmortems/2026-11-13-summary-broke-last-line-suites.md`)
- The first session ended before it created the build log, so the second session rebuilt the state from `git log` and `gh pr list`. (build log, P0 notes)

## Keep

- Wait on a `done` marker in the output file for a long suite. (build log, P2 wall clock)

## Change

- The plan skill's test impact step searches the tests folder for suites that read printed lines. (backlog entry 0000533)

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Test impact lists suites that read printed lines | pack maintainers | `ravintio-zero/skills/ravintio-plan/SKILL.md` | A plan for a printed-line change lists the suites that read it | backlog entry 0000533, from this retrospective |
