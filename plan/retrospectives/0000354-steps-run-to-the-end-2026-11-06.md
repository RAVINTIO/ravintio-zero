---
title: "Retrospective: 2026-11-06 - steps run to the end"
summary: "A blameless review of step 4 of initiative 0000349. It files one change."
status: "open"
---
# Retrospective: 2026-11-06 - steps run to the end

**Mode:** run
**Subject:** 0000354-steps-run-to-the-end
**Date:** 2026-11-06

## Summary

The step shipped the driver resume, the early-end rule, the stable setup record, the watcher wait, the shared driver-arguments helper, and the `Step CI fixes` field. The full suite passes with 271 feature suites and 19 regression suites. One P2 fix listed the new helper in the test runner.

## What helped

- A stub `claude` with modes gave one test file for the resume, the cap, the bad id, and the failure cases (`ravintio-zero/tests/test-0000354-req-001-driver-resume.sh`, 23 assertions).
- The helper came first, so the resume tests used it from the start (`ravintio-zero/tests/helpers/driver-args.sh`).
- The chart's `## Decisions` rows settled every fork, so the step stopped for nothing (`plan/_archive/0000354-steps-run-to-the-end-2026-11-06/build-log.md`, six `Decision applied` lines).

## What slowed the work

- The full suite stopped on `Undiscovered file: helpers/driver-args.sh`, and the rerun cost about 10 minutes (`Rework: REQ-004` in the build log).
- The suite prints nothing until it ends, so the step waited on a quiet log. Step 7 of this initiative ships the failing suite list.

## Keep

- Settle forks in the chart `## Decisions` table before the step runs.

## Change

- Add the runner allowlist to the plan skill's test impact scan (`plan/backlog/0000363-test-impact-scan-runner-allowlist/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Name the runner allowlist in the test impact scan | plan skill | `ravintio-zero/skills/ravintio-plan/SKILL.md` | A test that reads the scan text | backlog entry 0000363, naming this retrospective |
