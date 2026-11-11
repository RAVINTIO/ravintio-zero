---
title: "Retrospective: 2026-11-11 - Reply times match the clock"
summary: "A blameless review of step 51, which added a clock hook and tightened the reply time check."
status: "open"
---
# Retrospective: 2026-11-11 - Reply times match the clock

> Path: `plan/retrospectives/0000499-reply-times-match-clock-2026-11-11.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000499-reply-times-match-clock
**Date:** 2026-11-11

## Summary

The step added a `PostToolUse` clock hook, a 2 minute reply margin, a status check, and a watcher test override. It shipped with one rework and two filed backlog entries.

## What helped

- The four units were small, so each had a test that failed first and a quick pass (build log P2 block).
- Sharded local runs found the pinning suites early (build log `Tests run: full suite` line).
- Running the PowerShell suites locally under `pwsh` caught the PowerShell pins before CI (build log P2 block).

## What slowed the work

- Six suites pinned the old hook counts and margin. The plan named three (`plan/postmortems/2026-11-11-hook-change-missed-pinning-suites.md`).
- The baseline and clean-clone runs each took about 30 minutes while other steps shared the machine (build log P3 block).
- A queue item arrived mid-run and asked for a clock-rule Rework line, which needed a second postmortem (`plan/postmortems/2026-11-11-typed-marker-times.md`).
- The longest CI run was 452 seconds against a 420 second threshold (`build-report.md`, workflow governance).

## Keep

- Pin updates land in the same step as the behaviour change, with a Rework line (build log P2 block).
- A small override variable, `RAVINTIO_REPLY_CLOCK`, makes time checks testable (`src/ravintio-zero/tests/test-0000499-req-001-clock-hook.sh`).

## Change

- Add a hook change cause to the Test impact scan (backlog 0000523).
- Write build log markers with a script that reads the clock (backlog 0000524).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Add a hook change cause to the Test impact scan | pack maintainer | `.claude/skills/ravintio-plan/SKILL.md` | a plan run that adds a hook | 0000523 |
| Add a marker script that reads the clock | pack maintainer | `ravintio-zero/scripts/` | a P2 run that uses it | 0000524 |
