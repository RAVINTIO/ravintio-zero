---
title: "Backlog Entry: 0000532 - Step sessions wait on a suite without matching their own shell"
summary: "A `pgrep -f` wait loop matches its own shell, so it never sees the suite end."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000532 - Step sessions wait on a suite without matching their own shell

**Source feature:** 0000509-clear-merged-ready-files
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-13
**Date filed:** 2026-11-13

---

## Problem

Step 56 waited for its baseline suite with loops such as `while pgrep -f clean-clone-test; do sleep 20; done`. The pattern also matches the shell that runs the loop. The loop never sees the suite end, so it runs until the Bash timeout of 10 minutes.

Step 56 wrote three such loops between 01:40 and 01:50 on 2026-11-13. Each one wasted up to 10 minutes. Step 56 stopped the last of them by hand at 02:01.

Evidence: `plan/.initiative-logs/step-56.log`, between 01:40 and 02:01 on 2026-11-13. At 01:50, process 45773 had run one such loop for 9 minutes 52 seconds.

Step 60 hit the same wait on 2026-11-13. Its retrospective, `plan/retrospectives/0000534-step-sessions-receive-clock-2026-11-13.md` line 25, records that the wait ran to the time limit.

## Suggested Action

The skills that run the suite tell a step session to wait on an end marker in the output file, such as a `done` line. Step 56 used that form for its full suite run, and it ended on time. A wait on a process uses the process id that the run returned, not `pgrep -f` on a name.

## Wanted outcome

The P0 start actions and `ravintio-validate-and-accept` say to wait on the end marker or the returned process id. A test checks that no skill or standard tells a session to wait with `pgrep -f`.

The human approved this outcome at the chart of initiative 0000544 on 2026-11-14.

## Why Deferred

Found by the coordinator while step 56 ran in initiative 0000360. The human asked to queue it as a backlog entry for step 57 to file.
