---
title: "Retrospective: 2026-11-09 - Pack prose to the standard"
summary: "A blameless review of the prose rewrite run and the change it files."
status: "open"
---
# Retrospective: 2026-11-09 - Pack prose to the standard

> Path: `plan/retrospectives/0000395-pack-prose-to-the-standard-2026-11-09.md`. Written by `ravintio-retrospective`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Mode:** run
**Subject:** 0000395-pack-prose-to-the-standard
**Date:** 2026-11-09

## Summary

The run rewrote the prose of about 370 files and emptied the baseline outside six applied migrations. Seven tests and two fixtures needed new wording.

## What helped

- Disjoint slice lists let 14 agents work in two parallel batches with no file conflicts (`plan/_archive/0000395-pack-prose-to-the-standard-2026-11-09/execution-plan.md`, Concurrency plan).
- The zero baseline file made each agent's finish line a single command (`plan/_archive/0000395-pack-prose-to-the-standard-2026-11-09/build-log.md`, U1 to U14 Done lines).
- The clean clone run found the failing suites without a host state effect (`plan/_archive/0000395-pack-prose-to-the-standard-2026-11-09/baseline-failures.md`).

## What slowed the work

- Pinned wording surfaced one batch late. The orchestrator files needed a second pass (`plan/_archive/0000395-pack-prose-to-the-standard-2026-11-09/build-log.md`, "Done: U11 part 2").
- A guard blocked a heredoc that named a git command, so the commit helper split into two scripts (`plan/_archive/0000395-pack-prose-to-the-standard-2026-11-09/build-log.md`, P2 block).
- One agent edited the applied migrations, which a test pins to `main`. The run restored them (`plan/_archive/0000395-pack-prose-to-the-standard-2026-11-09/build-log.md`, "Done: U13").

## Keep

- One slice list per unit, with a zero baseline check as the finish line (`plan/_archive/0000395-pack-prose-to-the-standard-2026-11-09/execution-plan.md`).

## Change

- Add a prose rewrite cause to the plan skill's test impact scan, so pins appear in the plan and not at P3 (`plan/postmortems/2026-11-09-prose-rewrite-wording-pins.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Scan tests for wording pins before a prose rewrite | pack maintainer | `ravintio-zero/skills/ravintio-plan/SKILL.md` | a plan test | 0000418, which names this retrospective |
