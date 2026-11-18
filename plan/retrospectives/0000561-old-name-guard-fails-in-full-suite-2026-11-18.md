---
title: "Retrospective: 2026-11-18 - Old-name guard fails in the full suite"
summary: "A blameless review of a finished run or initiative, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-18 - Old-name guard fails in the full suite

**Mode:** run
**Subject:** 0000561-old-name-guard-fails-in-full-suite
**Date:** 2026-11-18

## Summary

Step 17 removed a random failure from the old-name guard. The guard now matches its allowlist in Bash. The run had no rework and no stop.

## What helped

- The failure logs of earlier steps showed a different hit path and line each time. That pattern pointed at a random cause, not a changed tree (`/tmp` logs of steps 4, 30, 47, and 51, read at P2).
- A shim `grep` that exits at once gave a deterministic RED for the cause (build log, `RED: U1`).

## What slowed the work

- The baseline run and the full run each took about 20 minutes (build log, P2 wall clock of 44 minutes).
- Two commit-time prose checks rejected a passive phrase and two long sentences. The agent saw them only at commit (`plan/_archive/0000561-old-name-guard-fails-in-full-suite-2026-11-18/build-report.md`).
- The flake does not reproduce on demand, so REQ-001 AC-1 rests on the cause test and a clean run (`verification-report.md`).

## Keep

- Read earlier failure logs for a pattern before choosing between the chart's fix options (`design.md`, Deviation line).

## Change

- Other suites may hold the same pipe pattern. A search finds 58 suites that set `pipefail` and hold a `| grep -q` line (backlog entry 0000597).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Flag `| grep -q` under `pipefail` in a style test and fix the real hits | the pack maintainers | `ravintio-zero/tests/` | the new style test | `plan/backlog/0000597-pipe-to-grep-q-under-pipefail/entry.md`, from this retrospective |
