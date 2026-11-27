---
title: "Retrospective: 2026-11-16 - Safe suite wait"
summary: "A blameless review of step 13, which named the safe suite wait and banned pgrep -f."
status: "open"
---
# Retrospective: 2026-11-16 - Safe suite wait

**Mode:** run
**Subject:** 0000557-self-matching-pgrep-wait
**Date:** 2026-11-16

## Summary

The step added the wait rule to two skill files and one test. It shipped with 0 rework loops. The suite waits took most of the 57 minutes.

## What helped

- The Test impact scan named the frozen-line tests, so a sub-bullet kept them green (`plan/_archive/0000557-self-matching-pgrep-wait-2026-11-16/execution-plan.md`).
- The baseline run started in the background before the P0 artifacts, so P3 had it at once (build log, P0 block).
- Waiting on an end marker worked with no process match.

## What slowed the work

- The P2 and P3 suite runs took 31 and 23 minutes (build log, P2 and P3 wall clocks).
- A Monitor expired after 10 minutes and needed re-arms, also when persistent (build log, P2 and P3 blocks).
- The prose check rejected four build-log and docs lines of 26 words or more, which cost four commit retries (commits `a2257a71`, `3adcdc94`, `ef6039bd`, `fbdcf147`).
- `build-log-check.mjs` rejected unit marker lines that did not repeat the unit name exactly, which cost one rewrite (build log, P4 check).

## Keep

- Add a sub-bullet below a frozen base line instead of rewording it (`plan/_archive/0000557-self-matching-pgrep-wait-2026-11-16/risk-register.md`, R-002).

## Change

- Name the Monitor expiry and the re-arm step, or a wait that does not expire (`plan/backlog/0000591-monitor-wait-expires-after-10-minutes/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Name a wait that outlives 10 minutes | pack maintainers | P0 start actions and the validate skill | a standards test | backlog 0000591, from this retrospective |
