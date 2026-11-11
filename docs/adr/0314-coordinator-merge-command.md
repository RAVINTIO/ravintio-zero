---
title: "ADR 0314: A coordinator merge command"
summary: "One script merges the initiative branch into a coordinator branch, resolves shared files, regenerates them, and refuses other conflicts."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0314 - A coordinator merge command

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000505-coordinator-branch-regenerate
**Component:** ravintio-zero
**File:** `docs/adr/0314-coordinator-merge-command.md`
**Date:** 2026-11-11

## Context

The merge queue resolves and regenerates shared files after its base merge (ADR-0302, ADR-0313). A coordinator branch has no such command. On 2026-11-11 a merge of the initiative branch into a coordinator branch conflicted in `plan/backlog/index.md`.

## Decision

Add `ravintio-zero/scripts/coordinator-merge.mjs`. It merges a base ref, resolves allowlisted conflicts with `resolveSharedConflicts`, and calls `regenerateSharedFiles`. It aborts and exits 1 on any other conflict. It never pushes. The merge queue stays unchanged.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Reuse `merge-queue.mjs` | No new file | The queue is tied to a PR, a chart row, and a version | The coordinator has none of those |
| A manual runbook | No code | The coordinator repeats error-prone steps | It is the gap |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New script `coordinator-merge.mjs`. A rule in `roadmap-standards.md`. |

## Consequences

**Positive:**
- A coordinator merge never leaves a stale index or counter.

**Negative:**
- One more script to maintain.

**Risks:**
- A dirty tree could mix into the merge. The command checks for one first.

## Related ADRs

- ADR-0302 - extends
- ADR-0313 - extends

## Supersedes

None.

## Superseded By

None.
