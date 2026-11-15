---
title: "Feature Brief - Initiative pause reaches every step"
summary: "One initiative pause writes the pause record for the initiative and for each running step."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Initiative pause reaches every step

**Feature ID:** 0000555-initiative-pause-reaches-every-step

## Business Goal

When the human paused initiative 0000360 on 2026-11-12, the coordinator wrote each pause file by hand. The orchestrator pause command covers one feature. The human ruled that a pause applies to each step and to the initiative. A pause command for the driver makes that repeatable.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Pause records | As the human on the loop, I pause an initiative once, so that the initiative and each running step get a pause record. | must-have | 1 |
| Driver pause | As the human on the loop, I see the driver start no step, wait for each session to reach a phase end, and release the lock. | must-have | 1 |
| Pause-aware resume | As the human on the loop, I restart the driver and each step resumes from its own pause record. | must-have | 1 |

## Scope Boundaries

### In Scope
- A script `initiative-pause.mjs` that writes `plan/current/pause.md` in each running step worktree and `plan/current-initiative/pause.md` in the root.
- A pause request that the driver reads, with the stop of new starts, the wait for a phase end, and the lock release.
- A resume detection finding for the initiative pause record, read before each step's record.
- The pause rules in `roadmap-standards.md` and one line in the initiative skill.
- A test that pauses a run with two running steps and checks all three pause files.

### Out of Scope
- Any change to the orchestrator pause command for a feature outside an initiative.
- Pausing the merge queue mid-merge. A merge in progress finishes first.

### Deferred
- Nothing deferred.

## Acceptance Criteria

- [ ] `initiative-pause.mjs write` writes a pause file for each running step. It also writes the initiative pause file. That file holds the merged count, the remaining order, the open questions, and the resume steps.
- [ ] Once the pause request exists, the driver starts no step. It lets each running session reach a phase end, writes the files, releases the lock, and exits 0.
- [ ] Resume detection prints `initiative pause record present` before it reads the step records.
- [ ] A test pauses a run with two running steps and checks all three pause files.
