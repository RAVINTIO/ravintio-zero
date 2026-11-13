---
title: "Retrospective: 2026-11-11 - Check mergeability before a CI wait"
summary: "A blameless review of step 43 of initiative 0000360 and the changes it files."
status: "open"
---
# Retrospective: 2026-11-11 - Check mergeability before a CI wait

**Mode:** run
**Subject:** 0000483-mergeability-before-ci-wait
**Date:** 2026-11-11

## Summary

The merge queue now stops on a conflicting PR or when no check appears, and a step reads mergeability before its CI poll. The step's own PR conflicted at the first CI poll, so the new rule applied to its own run.

## What helped

- The step's `Title` and backlog entry named the exact failure, so P0 to P2 needed no clarification (`plan/_archive/0000483-mergeability-before-ci-wait-2026-11-11/build-log.md`, P0 block).
- The existing stub `gh` in `test-0000411-req-001-queue-waits.sh` gave a base for the new suite, and nine existing queue suites passed unchanged (`acceptance-evidence.md`).

## What slowed the work

- PR #176 conflicted with the initiative branch straight after `gh pr create`. No check registered until the step merged the base (`git log` entries `47f72a6c`, PR checks output at 2026-11-11).
- ADR 0310 collided with the ADR that step 28 merged first. The step renumbered to 0311 (commit "0000483: Renumber the ADR to 0311").
- `plan/.feature-id` held the previous step's id at the start and conflicted at the base merge (backlog entry 0000514).

## Keep

- Read `mergeable` before a CI wait. It found the conflict in seconds on this PR (`gh pr view 176` output before and after the base merge).

## Change

- Ship clears `plan/.feature-id` or the shared-files resolver covers it (`plan/backlog/0000514-clear-feature-id-at-ship/entry.md`).
- Parallel steps reserve distinct ADR numbers. Step 44 of the chart already covers it (`plan/_archive/0000360-backlog-sweep-initiative-2026-11-13/initiative.md`, step 44 row).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Clear `plan/.feature-id` at ship | ship skill | `src/ravintio-zero/skills/ravintio-ship/SKILL.md` | A test that no step branch carries the file after the closing push | `plan/backlog/0000514-clear-feature-id-at-ship/entry.md` |
| Distinct ADR numbers across parallel steps | step 44 | `docs/adr/.next-id` handling | Step 44 suite | Chart step 44 (0000485-adr-number-collision) |
