---
title: "ADR 307: Steps read their queue items"
summary: "The driver names the queue items that name a step, and a helper checks that each has a commit or report before the PR."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000444-step-reads-its-queue-items"
---
# ADR-0307 - Steps read their queue items

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000444-step-reads-its-queue-items
**Component:** ravintio-zero
**File:** `docs/adr/0307-steps-read-their-queue-items.md`
**Date:** 2026-11-10

## Context

Steps 13, 17, and 18 of initiative 0000360 missed queue items that named them. The start prompt names no item and nothing compares the queue with the step diff.

## Decision

A new script, `initiative-queue.mjs`, lists the items whose `**Step:**` line names a step and checks each one. The driver imports its `namedItems` function and adds one sentence with the folder names to the start and continue prompts. The check runs before `gh pr create`. It passes an item when the destination is in the diff against the initiative branch, or when the build log holds `Queue item {name}: {reason}`. The driver prints folder names only, and only names that match `^[A-Za-z0-9._-]{1,80}$`.

Oldest shell: bash 3.2

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Put the item text in the prompt | The session sees the full instruction | Item text steers the session and bypasses review | A prompt injection path |
| A hook that blocks the PR | Fails closed | A new guard that a step cannot clear alone | Out of scope, and the report route needs no human |
| Skill text only | No code | The three misses were text the step did not read | Does not change the start prompt |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One script, two prompt edits in the driver, two text edits |

## Consequences

**Positive:**
- The start prompt shows each named item.
- A missed item stops the PR instead of a later rework.

**Negative:**
- A step whose item needs no commit must log a report line.
- The driver loads the new code only after a restart.

**Risks:**
- A destination with `{id}` may match a wrong path. The check matches seven digits only.

## Related ADRs

- ADR-0304 - related-to

## Supersedes

- none

## Superseded By

- none
