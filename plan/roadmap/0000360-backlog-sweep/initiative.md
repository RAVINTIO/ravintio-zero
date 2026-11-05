---
title: "Initiative: 0000360 - backlog sweep"
summary: "Clears the open backlog left after initiative 0000349, in themed steps."
status: "proposed"  # proposed | charted | active | delivered | blocked
---
# Initiative: 0000360 - backlog sweep

**Goal:** Close every open backlog entry that initiative 0000349 leaves, grouped into themed steps.
**Branch:** initiative/0000360-backlog-sweep
**Status:** proposed
**Position:** 1

This draft holds the step grouping only. Its I-A Chart reserves the step feature ids, checks each entry for clarity, and builds the decision, criteria, schema, dependency, and P1 skip tables. Chart should start after initiative 0000349 delivers, so it reads the N + 1 rules and the `Title` column that 0000349 adds.

## Guard check notes

- Entry 0000291 lets strict mode be turned off. That would widen the guards strict mode wires, so chart needs a separate approval for it, or cuts it back.
- Entry 0000271 makes `gate-write` check shell writes. That tightens a guard.

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status |
|------|------------|-------|-----------------|------|---------|--------|
| 1 | | Setup keeps what developers own | 0000290, 0000299, 0000289, 0000293 | minor | | pending |
| 2 | | Install, update, and uninstall | 0000283, 0000292, 0000291, 0000298 | minor | | pending |
| 3 | | Codex setup checks | 0000220, 0000221 | minor | | pending |
| 4 | | Writing standard | 0000300, 0000305 | minor | | pending |
| 5 | | Prose checks | 0000301, 0000304, 0000303 | minor | | pending |
| 6 | | Pack prose to the standard | 0000302 | minor | | pending |
| 7 | | Test helpers | 0000261, 0000308, 0000337 | minor | | pending |
| 8 | | Faster and cleaner test runs | 0000294, 0000297, 0000295, 0000296 | minor | | pending |
| 9 | | Skill evaluation | 0000174, 0000254 | minor | | pending |
| 10 | | Light discovery | 0000281, 0000284, 0000330, 0000348 | minor | | pending |
| 11 | | Plan checks | 0000263, 0000333, 0000347, 0000280, 0000255 | minor | | pending |
| 12 | | Dependency approvals | 0000328, 0000329 | minor | | pending |
| 13 | | Replies and questions | 0000257, 0000258, 0000259, 0000306 | minor | | pending |
| 14 | | Session integrity | 0000262, 0000271, 0000272, 0000260 | minor | | pending |
| 15 | | Ship records | 0000285, 0000286 | minor | | pending |
| 16 | | GitHub security and CI lint | 0000323, 0000324, 0000325 | minor | | pending |
