---
title: "Retrospective: 2026-11-06 - CodeQL and branch cleanup"
summary: "A blameless review of step 5 of initiative 0000349. It files one change."
status: "open"
---
# Retrospective: 2026-11-06 - CodeQL and branch cleanup

**Mode:** run
**Subject:** 0000355-codeql-and-branch-cleanup
**Date:** 2026-11-06

## Summary

The step shipped the CodeQL workflow, the branch cleanup job, the workflow job marker, the escaping check in P3, and the entry 0000323 update. The full suite passes with 276 feature suites and 19 regression suites. The step stopped once at the end of P3 for a repo setting.

## What helped

- The cleanup `run` block ran against a fake `gh` in eight cases, so the job was checked without GitHub (`acceptance-evidence.md`, Execution line).
- The chart `## Decisions` rows settled the CodeQL and cleanup forks before the step started (`build-log.md`, P0 decision lines).

## What slowed the work

- The step found CodeQL default setup still on only at P3, after it had written all its code (`Blocked:` line in the archived `build-log.md`).
- Two workflow tests expected one write scope and failed once the cleanup job added a second (`Rework: REQ-004` in the build log).
- Phase timestamps in the build log are coarse, so the recorded wall clocks did not match them until ship corrected them (backlog entry 0000335).

## Keep

- Put the human-only setting in the chart row, so the stop names the exact action.

## Change

- Check a human-only setting at P1, before P2 starts (`plan/backlog/0000364-human-settings-checked-before-p3/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Check human-only settings at P1 | plan skill | `ravintio-zero/skills/ravintio-plan/SKILL.md` | A test that reads the check text | backlog entry 0000364, naming this retrospective |
