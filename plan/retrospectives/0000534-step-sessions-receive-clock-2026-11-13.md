---
title: "Retrospective: 2026-11-13 - Step sessions receive the clock"
summary: "A blameless review of the clock run. The run files one change."
status: "closed"
---
# Retrospective: 2026-11-13 - Step sessions receive the clock

**Mode:** run
**Subject:** 0000534-step-sessions-receive-clock
**Date:** 2026-11-13

## Summary

The driver now records hook events in each step log, and a script checks a log for clock output. A short `claude -p` proof session showed that a headless session receives the clock hook output. The backlog entry's wrong time most likely came from the machine zone. The run had one rework and one postmortem.

## What helped

- A proof run before any code showed that the hook works headless. It kept the step to a log flag and a check, with no change to the hook (build log P0 block).
- The earlier driver step 0000511 gave a model for every artifact, so P0 and P1 took six minutes (build log P0 and P1 blocks).

## What slowed the work

- The new test failed in the clean clone because it found the repo root at the source depth (`plan/postmortems/2026-11-13-installed-copy-repo-root.md`).
- Two clean-clone runs took about 40 minutes of the 68 (build log P2 and P3 blocks).
- A `pgrep -f` wait matched its own shell and never ended. It ran to the time limit. Backlog entry 0000532 already covers this case.

## Keep

- Prove a suspected gap with a small real run before the design. The run cost one short session (build log P0 block).

## Change

- A shared repo root helper in the test helpers stops this class of failure. It lives in `src/ravintio-zero/tests/helpers/assert.sh`, and a test run from both folders verifies it.

## Actions

- Backlog entry 0000539: tests share a repo root helper.
