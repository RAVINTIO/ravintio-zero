---
title: "Retrospective: 2026-11-18 - delivery PR step order"
summary: "A blameless review of step 30, which printed the delivery step table in version order."
status: "open"
---
# Retrospective: 2026-11-18 - delivery PR step order

**Mode:** run
**Subject:** 0000574-delivery-pr-lists-steps-in-version-order
**Date:** 2026-11-18

## Summary

Step 30 added rule 6 text and a printed step table in version order, with two new suites. The build was small and clean. The run paused for two days between P3 and P4.

## What helped

- Two RED suites before the edit showed 8 FAIL lines, then 0 after (`build-log.md`, P2 note).
- A clean-clone run separated 3 inherited failures from new ones (`acceptance-evidence.md`).

## What slowed the work

- The P3 reports sat uncommitted. The build log had no P2 close and no P3 block, so the resume rebuilt them (`git status` at resume, `build-log.md` P2 block).
- A guard blocked `git add` with a shell variable, which cost one retry at archive.

## Keep

- The baseline-failures check, which kept inherited suites from stopping the step (`baseline-failures.md`).

## Change

- Commit each P3 report as it lands and log the P3 block before the session ends (`plan/backlog/0000595-commit-p3-reports-before-session-end/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Report untracked P3 reports in resume detection and commit them as they land | pack maintainers | `ravintio-zero/scripts/resume-detect.mjs`, validate skill | a resume test | `plan/backlog/0000595-commit-p3-reports-before-session-end/entry.md` |
