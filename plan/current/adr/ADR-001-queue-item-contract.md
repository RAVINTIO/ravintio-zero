---
title: "ADR 001: queue items name their step in item.md"
summary: "A queue item is a folder whose item.md names the step and the destination, and the step commits it."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - Queue items name their step in item.md

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Component:** ravintio-zero
**Date:** 2026-11-06

## Context

The coordinator holds new backlog entries in `plan/.initiative-queue/` while a step runs, then lands them through a coordinator PR. Each PR sits between two step squashes. The human wants N + 1 commits, so aligned admin must ride in a step PR. The queue is git-ignored and a step session never moves or deletes it.

## Decision

A queue item is a folder. Its `item.md` holds `**Step:** {n}` and `**Destination:** {repo path}`, and the other files in the folder are the content. A step reads the queue at P0 and before P4, writes the content of each item that names its number to the destination, and commits that path by explicit path. If the destination or content holds `{id}`, the step reserves the id, because the coordinator never edits the working tree while the driver runs. The coordinator clears the items after the step merges. Admin that fits no step lands through a `chore/` PR.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Name the step in the folder name | No extra file | Breaks the `{id}-{slug}` layout that the backlog index reads | Changes an existing contract |
| Let the coordinator edit the step's branch | No queue | The coordinator never edits the working tree while the driver runs | Breaks the hard limit of the initiative skill |
| Keep coordinator PRs between steps | No change | History holds more than N + 1 commits | Against the human's rule of 2026-11-01 |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Standards and the initiative and ship skills change. |

## Consequences

**Positive:**
- The initiative branch gets no coordinator squash between steps.
- Aligned admin ships with the step that caused it, so conflicts on the id counter go away.

**Negative:**
- The step carries admin that is not part of its feature. The PR diff shows it.
- The queue is ignored by git, so a lost queue loses the items. The coordinator can queue them again.

**Risks:**
- A step commits an item that names another step. The rule and the diff catch it.

## Related ADRs

- 0000318 ADR-001 - extends

## Supersedes

- None.

## Superseded By

- None.
