---
title: "Retrospective: 2026-11-01 - squash before main"
summary: "A blameless review of a finished run or initiative, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-01 - squash before main

> Path: `plan/retrospectives/0000327-squash-before-main-2026-11-01.md`. Written by `ravintio-retrospective`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.

**Mode:** run
**Subject:** 0000327-squash-before-main
**Date:** 2026-11-01

## Summary

Step 10 shipped version 0.48.0 in 24 minutes. It adds a CI check for PRs into `main`, the squash and force-push rules in the ship skill, and the three allowed branch prefixes. Two self-corrections followed, both small.

## What helped

- Three parallel subagents built the script, the ship skill rules, and the standards text in one batch. P2 took 12 minutes (`plan/_archive/0000327-squash-before-main-2026-11-01/build-log.md`, P2 block).
- The chart rows pre-answered the forks. The force-push limit, the replacement-PR rule, and the `hotfix/` cut needed no stop (build log, P0 `Decision applied` lines).
- A read-only security subagent ran while the full suite ran. It found option injection in `--base` and `--head`, fixed in commit `harden the check after the security review`.

## What slowed the work

- The first full suite failed one test. `test-0000169-req-006-release-tag-ci-and-ship-flow.sh` kept a fixed list of job names, and the new job was not on it. The test impact scan has no cause for a new workflow job (`execution-plan.md`, `## Test impact`).
- The step 2 wording change broke `test-0000151-req-011-orchestrator-references-split.sh` against its frozen fixture. The scan lists the test, but not the fixture comparison it makes (build log, `Deviation:` line).

## Keep

- Run the security review as a read-only subagent beside the full suite. It costs no extra wall-clock time (build log, P3 block).
- Pre-answer likely forks in the chart. Step 10 had no `Blocked:` stop (build report, workflow governance table).

## Change

- Add a workflow-job cause to the test impact scan, and let the job-list test read a marker instead of fixed names (`plan/backlog/0000338-test-impact-scan-covers-workflow-shape/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Add a workflow-job cause to the test impact scan | ravintio-plan skill | `ravintio-zero/skills/ravintio-plan/SKILL.md` and `test-0000169-req-006` | A run that adds a job lists the workflow tests in its plan | `plan/backlog/0000338-test-impact-scan-covers-workflow-shape/entry.md` |
