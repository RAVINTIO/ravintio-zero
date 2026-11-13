---
title: "Backlog Entry: 0000413 - the driver reads blocks from the session reply"
summary: "The driver stops on a Blocked or Question line in the step session's final reply, not only in the build log."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000413 - the driver reads blocks from the session reply

**Source feature:** 0000382-install-lifecycle
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-08

---

## Problem

`openBlock` and `archivedBlock` in `ravintio-zero/scripts/initiative-run.mjs` read only the build log. When a step cannot write the build log, its `I-D Advance: Blocked:` reply goes unseen. The driver then resumes the session twice. `CONTINUE_PROMPT` tells it to read `plan/current/build-log.md`, which no longer exists. Step 6 of initiative 0000360 gave the same block three times in 25 seconds.

The regex in `blockIn` also misses a `Blocked:` line with a phase prefix, such as `I-D Advance: Blocked:`. It accepts a prefix only for `Question:`.

See `plan/postmortems/2026-11-08-archived-step-cannot-fix-ci.md`.

## Suggested Action

Read the `result` text from the session's stream-json output and apply `blockIn` to it. Accept a short prefix before `Blocked:` as for `Question:`. If `plan/current/build-log.md` is missing, the continue prompt names the archived log or none.

## Wanted outcome

- A stub session that ends with `I-D Advance: Blocked: ...` and writes no build log stops the driver with no resume.
- A build-log line `I-D Advance: Blocked: ...` counts as a block.

## Why Deferred

The human asked for it as a postmortem action during I-C Run of initiative 0000360.
