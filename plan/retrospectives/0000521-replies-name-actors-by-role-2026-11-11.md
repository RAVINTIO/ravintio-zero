---
title: "Retrospective: 2026-11-11 - Replies name actors by role"
summary: "A blameless review of the actor names run. The run files two changes."
status: "closed"
---
# Retrospective: 2026-11-11 - Replies name actors by role

**Mode:** run
**Subject:** 0000521-replies-name-actors-by-role
**Date:** 2026-11-11

## Summary

Replies now name each actor by role. The advisory reply hook flags "I" and "you" in a run reply. The coordinator report heading reads `Decisions for the human`. The run needed no rework and no postmortem.

## What helped

- The backlog entry named the files to change and the heading to rename, so P0 needed no questions (build log P0 block).
- The new hook suite reused the payload helper of the existing 0000390 suite, so the hook change took one pass (`src/ravintio-zero/tests/test-0000521-req-002-actor-pronoun-hook.sh`).

## What slowed the work

- Two suites failed on the first text edit. One freezes the base lines of the orchestrator skill. The other caps the boot templates at 3800 bytes (build log P2 notes). The test impact table named neither.
- `baseline-failures.mjs record` accepted the output of an unfinished run and recorded no failures (`plan/_archive/0000521-replies-name-actors-by-role-2026-11-11/build-log.md`, P2 block).
- The clean-clone run took about 30 minutes, which is most of P3 (build log P3 block).

## Keep

- Add a new line to a size-capped skill and trim a non-base line, so the frozen-line suite stays green (build log P2 notes).

## Change

- The record command rejects unfinished runner output. The change lives in `ravintio-zero/scripts/baseline-failures.mjs` and a test with a partial output file verifies it.
- The test impact scan names the frozen-line suite and the boot template cap. The change lives in `ravintio-plan/SKILL.md` and `test-0000383-req-001-005-test-impact-causes.sh` verifies it.

## Actions

- Backlog entry 0000525: baseline record needs a finished run.
- Backlog entry 0000526: test impact scan names frozen-line suites.
