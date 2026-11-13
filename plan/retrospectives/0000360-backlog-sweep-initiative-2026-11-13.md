---
title: "Retrospective: 2026-11-13 - Backlog sweep initiative"
summary: "A blameless review of initiative 0000360, which shipped 61 steps from v0.57.0 to v0.114.0, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-13 - Backlog sweep initiative

> Path: `plan/retrospectives/0000360-backlog-sweep-initiative-2026-11-13.md`. Written by `ravintio-retrospective` at I-E Delivery.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Mode:** initiative
**Subject:** 0000360-backlog-sweep
**Date:** 2026-11-13

## Summary

Initiative 0000360 shipped 61 steps between 2026-11-07 and 2026-11-13, from v0.57.0 to v0.114.0. The chart held 21 steps at activation. The other 40 steps fixed gaps that the run itself exposed.

The step 22 record, `plan/retrospectives/0000360-backlog-sweep-retrospective.md`, reviewed evidence rows 1 to 27. This record covers the whole initiative and adds rows 28 to 41 of `plan/_archive/0000360-backlog-sweep-initiative-2026-11-13/coordinator-evidence.md`.

## What helped

- Concurrent steps in worktrees shipped 61 features in about five and a half days. Steps merged in ready order, not chart order (`## Steps` table, `Version` column).
- The run fixed its own tooling as it went. Steps 23 to 59 closed most of the 19 findings of the step 22 record. One example is step 28, where the driver runs the approved setup command itself (evidence row 18, v0.92.0).
- Planned restarts replaced manual stops. Step 53 gave the planned restart its own exit code, 75. Later driver changes handed over without the human (v0.109.0, step 56 `Restart:` on 2026-11-13).
- The security review in step 61 caught finding S-001 before merge. The human chose the fix, and it shipped in the same PR (#200, evidence row 39).
- The merge queue worked by hand while the driver had stopped. The coordinator merged #195 and #200 through `merge-queue.mjs` with versions and tags intact (evidence rows 32 and 38).

## What slowed the work

- Shared files caused most conflicts. Every merge changed an index or a counter, so other open PRs conflicted. Steps 32, 42, and 54 regenerate those files, but `plan/.feature-id` still stopped the queue on step 61 (evidence rows 12, 30, and 38).
- Parallel steps reserved the same ids. Two open entries still share id 0000476. Steps 60 and 61 took the same ADR number and backlog id (evidence row 38, entry 0000542).
- Step sessions kept running slow or stalled waits. A `pgrep -f` loop matched its own shell in steps 56 and 60 (entry 0000532, evidence row 37). Step 40 ran its suites serially against a decision row (evidence row 31).
- Reply times drifted from the clock in steps 14, 15, 19, 60, and 61. Steps 38 and 51 changed the replies, and step 60 gave the clock to step sessions (evidence rows 24 and 36).
- The run paused for about 11 hours between step 55 (2026-11-12 15:07 UTC) and step 56 (2026-11-13 02:38 UTC). The pause reached the coordinator but not every step (entry 0000538).
- The coordinator asked the human questions that had one possible answer. One example is whether to start I-E Delivery (evidence row 41, entry 0000541).

## Initiative questions

1. **Charted versus shipped.** The chart held 21 steps and shipped 61. The initiative added 40 steps with `initiative-add-step.mjs`, each from a postmortem, a retrospective, or a human request. 58 steps shipped as minor bumps. Steps 22, 23, and 34 shipped as patches. Versions run from v0.57.0 to v0.114.0, with no gaps, in merge order. Merge order differs from chart order, as the concurrency design intends.
2. **Friction that repeated.** These kinds of friction repeated:
   - shared-file conflicts after each merge (rows 12, 30, and 38)
   - id collisions between parallel steps (row 38 and entry 0000542)
   - slow or stalled suite waits (row 31, row 37, and entry 0000532)
   - clock drift in replies (rows 24 and 36)
   - edits to one pack tree only, after step 20 moved the source to `src/ravintio-zero/` (row 40, entry 0000528)
3. **Stops and step times.** The 41 evidence rows list each stop with its evidence and fix. On 2026-11-13, four stops occurred:
   - step 55 waited on a stopped driver, and the coordinator merged it by hand (row 32)
   - step 57's summary broke five suites until the step fixed it (row 34)
   - the queue stopped on `plan/.feature-id` for step 61, and the coordinator resolved it by hand (row 38)
   - step 61 held for the S-001 decision (row 39)

   Merge times per step appear in the `## Steps` merge table of the archived chart. Gaps between merges range from about 15 minutes to about 11 hours. The longest gap is the pause before step 56. The record has no start time per step session, so this record gives no exact step durations.
4. **Tooling gaps.** These gaps stay open:
   - the queue does not resolve `plan/.feature-id` (entry 0000514)
   - no check flags a duplicate backlog id (entry 0000542)
   - test impact misses some suites (entries 0000523, 0000526, 0000533, and 0000540)
   - a pause does not reach every running step (entry 0000538)
   - a step session can miss an unfinished step (entry 0000531)

## Keep

- Concurrent steps in worktrees, with merge-time versions and the merge queue (steps 1 to 3, v0.57.0 to v0.59.0).
- Adding a step when the run finds a gap, with its entry filed through `initiative-add-step.mjs` (40 steps added).
- A security review on every step, with the decision left to the human (S-001 in #200).

## Change

- Resolve `plan/.feature-id` and every other tracked per-step file at merge (entry 0000514).
- Fail CI on a duplicate backlog id (entry 0000542).
- Start a defined stage without asking the human (entry 0000541).
- Wait on an end marker, never on `pgrep -f` (entry 0000532).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Clear or resolve `plan/.feature-id` at ship and in the queue | ship skill and merge queue | `skills/ravintio-ship/SKILL.md`, `scripts/shared-files.mjs` | test that no step branch carries the file | 0000514 (existing) |
| Report a duplicate backlog id and renumber 0000476 | backlog index | `scripts/backlog-index.mjs` | test with two folders sharing an id | 0000542, from this retrospective |
| Start a defined stage without a question | initiative skill and roadmap standards | `skills/ravintio-initiative/SKILL.md`, `standards/roadmap-standards.md` | standards test | 0000541 |
| Wait on an end marker | implement and validate skills | `skills/ravintio-implement/`, `skills/ravintio-validate-and-accept/` | test on the skill text | 0000532 (existing) |
| Pause reaches every running step | driver | `scripts/initiative-run.mjs` | driver test | 0000538 (existing) |
