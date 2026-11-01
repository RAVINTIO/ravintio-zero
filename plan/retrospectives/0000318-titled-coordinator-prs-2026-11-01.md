---
title: "Retrospective: 2026-11-01 - titled coordinator PRs"
summary: "A blameless review of step 6 of initiative 0000312, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-01 - titled coordinator PRs

> Path: `plan/retrospectives/0000318-titled-coordinator-prs-2026-11-01.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000318-titled-coordinator-prs
**Date:** 2026-11-01

## Summary

The step made every coordinator change reach an initiative branch as a titled PR, and it pinned `merge-guard` with a test. The run took about 26 minutes. One self-correction was needed.

## What helped

- Three parallel units finished P2 in 12 minutes (`build-log.md` P2 block).
- The pin test for `merge-guard` showed the hook already allowed a coordinator squash, so no guard widened (`test-0000318-req-004-merge-guard-pinned.sh`).
- The forced-add hook from step 5 blocked a forced add inside a compound command before it ran (`block-forced-add.mjs`).

## What slowed the work

- The first full suite failed two suites that assert old wording (`test-0000043-req-003`, `test-0000189-req-007`). The plan's Test impact scan did not list them (`execution-plan.md`).
- The `commit-msg` hook rejected three subagent subjects over 72 characters (commits `9105589`, `ec10feb`, `d45d3ec`).
- The plan had no unit for the living docs, so ship wrote them (`docs/decisions-index.md`).
- Typed phase times failed the build-log check for three phases (`build-log-check.mjs` output).

## Keep

- Run the full suite once before P3 and fix all failures from one log (2 failures, one fix commit `e9c0946`).
- Write reports after the suite finishes, so no edit breaks its tree check (`build-log.md` P3 notes).

## Change

- Give subagents the commit subject limit and a living docs unit (`agent-dispatch-standards.md`, `execution-plan.md`).
- Make `reserve-id.mjs --commit` safe on an initiative branch (`ravintio-initiative/SKILL.md:92`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Subject limit and living docs unit in dispatch and plan guidance | Pack maintainers | `ravintio-zero/standards/agent-dispatch-standards.md`, `ravintio-zero/skills/ravintio-plan/SKILL.md` | A test on the dispatch template | Entry 0000333, from this retrospective |
| `reserve-id.mjs --commit` on an initiative branch | Pack maintainers | `ravintio-zero/scripts/reserve-id.mjs` | A test that runs it on `initiative/*` | Entry 0000332, from this retrospective |
