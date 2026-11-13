---
title: "Retrospective: 2026-11-10 - tests catch runner-only failures"
summary: "A blameless review of step 35, which made the local runners fail on a missing git identity and pinned the BOM readers."
status: "open"
---
# Retrospective: 2026-11-10 - tests catch runner-only failures

**Mode:** run
**Subject:** 0000462-tests-without-git-identity
**Date:** 2026-11-10

## Summary

Both runners now give each suite a git config that refuses to guess an identity, and a new suite pins the BOM readers. The BOM suite found a third defect in `setup.sh`, which the step fixed. The step ran inline in five phases with no self-correction cycle.

## What helped

- The scratch-copy revert of both PR #136 fixes turned the wanted outcome into a check (`plan/_archive/0000462-tests-without-git-identity-2026-11-10/verification-report.md`, AC-4).
- A BOM fixture for every first-line reader found a real defect before CI did (`test-0000462-req-002-bom-first-line-readers.sh`).
- The full run under the isolation passed 389 of 389, so no existing suite needed an identity fix (build log, P2 block).

## What slowed the work

- The PR conflicted with the initiative branch, so GitHub started no CI. The step found out only after it polled for checks and found none (build log, P4 block).
- Two other steps had reserved ADR 0301 and 0302, so the merge needed a hand renumber (`plan/backlog/0000479-adr-number-collision/entry.md`).
- A gate hook blocks a command that writes the sentinel and the plan files together, and a command whose text names `git add` with a variable. Each needed a second call.
- The clean-clone run and the in-tree run each took about 20 minutes, so P3 waited.

## Keep

- Pin a local-versus-CI difference with a test that reverts the fix in a scratch copy (`test-0000462-req-001-git-identity-isolation.sh`, AC-3).

## Change

- Detect a PR that conflicts with the initiative branch before the CI poll, and merge the branch in first (build log, P4 block).
- Renumber a colliding ADR in the merge queue (`plan/backlog/0000479-adr-number-collision/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Renumber a colliding ADR in the queue | merge queue | `merge-queue.mjs` | A queue test with two ADRs of one number | `plan/backlog/0000479-adr-number-collision/entry.md` |
| Check `mergeable` before the CI poll | ship skill | `roadmap-standards.md`, I-D Advance | A test that reads the step order | Not filed. The ship step already holds this check in item 4.1, and the fix is an edit to it |
