---
title: "Retrospective: 2026-11-10 - CI duration metric"
summary: "A blameless review of the CI duration metric run, and the change it files."
status: "open"
---
# Retrospective: 2026-11-10 - CI duration metric

**Mode:** run
**Subject:** 0000472-ci-duration-metric
**Date:** 2026-11-10

## Summary

The run added a CI duration marker, a threshold row, and a CI target. The initiative branch moved twice during P3 and P4, and the second move forced an ADR renumber.

## What helped

- The step-39 archive gave a template for every artifact, so P0 to P1 took about three minutes (`plan/_archive/0000470-plan-rereads-files-at-the-branch-point-2026-11-10/`).
- Running the new script on this run's own archived log verified the metric on real data (`CI duration: 302s`, run 42917291732).

## What slowed the work

- The initiative branch moved twice. CI failed once on a stale backlog index, and the ADR number collided with 0307 (PR 172 run 42916362974, `docs/adr/0307-steps-read-their-queue-items.md`).
- The full suite in a clean clone takes about 35 minutes. The baseline run and the P3 run each took that long (build log P3 note).
- `gate-write` blocked edits that used a `cd` and a relative path, so three commands ran twice.

## Keep

- Ship writes the marker from `gh run view` data. The script then needs no network call (ADR 0308).

## Change

- Check for an ADR number collision on the initiative branch before the PR, and offer a renumber helper (backlog entry 0000480).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| ADR collision check and renumber helper | ship skill | `src/ravintio-zero/skills/ravintio-ship/SKILL.md` | A suite that plants a colliding ADR | `plan/backlog/0000480-adr-number-collisions-between-parallel-steps/entry.md`, from the 0000472 retrospective |
