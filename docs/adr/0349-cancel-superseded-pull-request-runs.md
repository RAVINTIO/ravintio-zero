---
title: "ADR 0349: Cancel superseded pull request runs"
summary: "The workflow cancels an older run on a newer push to the same pull request and keeps every suite on every push."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0349 - Cancel superseded pull request runs

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000558-plan-only-push-short-ci
**Component:** ravintio-zero
**File:** `docs/adr/0349-cancel-superseded-pull-request-runs.md`
**Date:** 2026-11-16T04:04:36Z

## Context

A step pushes more than once to one pull request, and each push starts a full run. The backlog entry asked for a short path on a plan-only push. The chart row for step 14 cuts that back, because a short path would pass a form the full run blocks today.

## Decision

Add a top-level `concurrency` block to `.github/workflows/ravintio.yml`. The group holds the workflow name, the pull request number or the ref, and a flag for the `closed` action. `cancel-in-progress` is true for a `pull_request` event and false for any other event. No job gains a path filter.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Skip the shards on a plan-only push | Fewer jobs | Passes a form the full run blocks | The chart row forbids it |
| Cancel on every event | One rule | Cancels the release tag job | A merge needs its tag |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The repo workflow gains one block. |

## Consequences

**Positive:**
- An older run stops using runners once a newer push lands.

**Negative:**
- A cancelled run shows as cancelled in the pull request history.
- The chart criterion "fewer suites" holds only as fewer runs.
