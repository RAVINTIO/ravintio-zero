---
title: "ADR 0345: Ship deletes the feature id file"
summary: "Ship Step 8 deletes plan/.feature-id and the merge queue resolves it as a shared file, so no squash carries a stale id."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0345 - Ship deletes the feature id file

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000545-clear-feature-id-at-ship
**Component:** ravintio-zero
**File:** `docs/adr/0345-ship-deletes-the-feature-id-file.md`
**Date:** 2026-11-14

## Context

Ship Step 8 deletes four sentinels and leaves `plan/.feature-id`. Each squash carries the last step's id onto the initiative branch. The next step then starts with a stale id, and its base merge conflicts when another step wrote a different id. Backlog entry 0000514 offered two fixes.

## Decision

Ship Step 8 deletes `plan/.feature-id` with the other sentinels. `shared-files.mjs` also lists the file, so a base merge that conflicts on it resolves with no stop. If the PR branch deleted the file, it stays deleted. If the PR branch holds it, the PR branch text wins. The step PR also deletes the tracked file from the initiative branch.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Delete only in Step 8 | One change | A conflict still stops the queue if a step ships late | The chart row asks for both |
| Resolve only in `shared-files.mjs` | One change | The stale file stays on the branch | The chart row asks for both |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Ship skill text and the shared-files script change. |

## Consequences

**Positive:**
- No squash carries a stale id.
- A base merge never stops on the file.

**Negative:**
- Resume detection reports no id file between ship and the next P0.

**Risks:**
- A test pins the Step 8 text and needs an update.

## Related ADRs

- ADR-0302 - extends

## Supersedes

- None.

## Superseded By

- None.
