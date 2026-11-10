---
title: "Retrospective: 2026-11-10 - merge queue test gaps"
summary: "A blameless review of step 36, which tested two branches of the merge queue and refused ref names that start with a dash."
status: "open"
---
# Retrospective: 2026-11-10 - merge queue test gaps

**Mode:** run
**Subject:** 0000464-merge-queue-test-gaps
**Date:** 2026-11-10

## Summary

The merge queue now has tests for its rerun path and its post-set version check. It also refuses a head or base name that starts with a dash. The step ran inline in five phases with no self-correction cycle.

## What helped

- The fake `gh` refuses the first merge. A second run then reaches the rerun branch with no change to the code (`plan/_archive/0000464-merge-queue-test-gaps-2026-11-10/verification-report.md`, REQ-001).
- A stub `version-files.mjs` beside a copy of the queue reached the post-set check, which no real input reaches (`test-0000464-req-001-002-queue-branches.sh`).
- Breaking each branch in turn proved that the new fixtures fail when the code is wrong (build log, P3 block).

## What slowed the work

- PR #166 conflicted with the initiative branch, so GitHub started no CI. The step found out only after it polled for checks and found none (build log, P4 block).
- The foreground limit stopped the first full suite run before its summary, so the step ran it again (build log, P2 block).
- The merge guard matched report text that named a merge command, and the write hook rejected relative paths after `cd`. Each needed a second call.

## Keep

- Cover a branch that no real input reaches with a stub beside a copy of the script (`test-0000464-req-001-002-queue-branches.sh`).

## Change

- Check `mergeable` right after `gh pr create`, so a conflict shows before the CI poll (build log, P4 block).
- Start a full suite run in the background with the longest limit (build log, P2 block).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Check `mergeable` after `gh pr create` | ship skill | `roadmap-standards.md`, I-D Advance | A test that reads the step order | Not filed. The step 35 retrospective (`plan/retrospectives/0000462-tests-without-git-identity-2026-11-10.md`) records the same change |
| Run the full suite in the background | implement skill | `ravintio-implement` SKILL.md | A review of the Test scope section | Not filed. The note is an operator habit, and the skill already says to start the run in the background |
