---
title: "Retrospective: 2026-11-07 - Clean step stops and logs"
summary: "A blameless review of step 7 of initiative 0000349, and the change it files."
status: "open"
---
# Retrospective: 2026-11-07 - Clean step stops and logs

**Mode:** run
**Subject:** 0000358-clean-step-stops-and-logs
**Date:** 2026-11-07

## Summary

The step added the `Question` status, tied build log times to the clock, made the check fail an open phase, and made the runners list failed suites. The suite passes with 284 feature and 19 regression suites. Evidence: `plan/_archive/0000358-clean-step-stops-and-logs-2026-11-07/build-report.md`.

## What helped

- Each new test failed first and passed after the change, so the two new `build-log-check.mjs` checks had fixtures from the start (`build-log.md`, P2 notes).
- Running `pwsh` against a scratch folder confirmed the PowerShell runner list by execution (`verification-report.md`).
- The plan's test impact scan named the status and runner suites (`execution-plan.md`, `## Test impact`).

## What slowed the work

- `test-0000151-req-011` pinned three orchestrator lines through a base fixture, and the scan did not name them. Each miss cost a full suite run of about 5 minutes (`build-log.md`, P2 `Rework:` lines).
- The forced-add guard blocked a heredoc that named `git add`, so the test file moved to the Write tool. Entry 0000365 already covers it (`build-log.md`, P2 notes).
- The plan listed `CLAUDE.md` as an edit target, but git ignores it (`build-log.md`, P2 `Deviation:` lines).

## Keep

- Verify a changed runner by execution in a scratch folder, in both shells (`verification-report.md`).

## Change

- Add fixture-pinned lines to the test impact scan, and run the named suites before the full suite (`build-log.md`, P2 `Rework:` lines).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Scan fixtures for lines the run edits, and run named suites first | Pack maintainers | `ravintio-zero/skills/ravintio-plan/SKILL.md` | A test that the plan skill names the fixture cause | `plan/backlog/0000369-test-impact-scan-covers-fixture-pins/entry.md` |
