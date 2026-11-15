---
title: "Scope - A failed queue run can leave written files in the queue worktree"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - A failed queue run can leave written files in the queue worktree

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000546-queue-failure-leaves-dirty-files
**Version:** 0.126.0

## In Scope

- A restore of the chart and the version files to HEAD when `run` fails before the set-version commit lands.
- A `restored:` line that names the paths.
- One test with a commit that a hook rejects.

## Out of Scope

- A reset of any path the queue did not write.
- A change to the clean-tree check at the start of `run`.
- A restore after the commit lands and the push fails. The commit stays, and the rerun logic of 0000454 handles it.

## Deferred

Nothing deferred.
