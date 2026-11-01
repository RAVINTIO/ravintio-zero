---
title: "ADR 001: Skip the step log folder in the guard"
summary: "The phase guard skips plan/.initiative-logs and keeps scanning everything else."
status: "active"
version: "0.41.1"
---
# ADR-001 - Skip the step log folder in the guard

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000314-step-logs-stay-in-place
**Component:** ravintio-zero
**Date:** 2026-10-31

## Context

The phase guard in `test-0000042-req-006` scans `plan` and skips only history paths. A step session writes its own test output, with planted stale cites, to `plan/.initiative-logs/`. The guard reads it and fails. Entry 0000264 offers two fixes: skip the folder, or scan tracked files only. The chart picked the first.

## Decision

Add `plan/.initiative-logs` to the `EXCLUDE` list. The guard keeps scanning tracked and untracked files elsewhere.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Scan tracked files only | Ignores all local state | Hides a new untracked skill file | The chart rejected it |
| Move the folder during the run | No test change | Breaks the watcher and the driver | The cause of entry 0000265 |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One test file changes |

## Consequences

**Positive:**
- Step sessions run the suite with no workaround.

**Negative:**
- A stale cite in a step log goes unseen, which is harmless because the log is not shipped.

**Risks:**
- Another suite may read the folder. P2 checks the full run.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
