---
title: "ADR 0344: Suite marker silences the strict hook for a step session"
summary: "The runners write plan/.suite-running and the strict hook stays quiet for a step session while it names a live pid."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0344 - Suite marker silences the strict hook for a step session

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000548-ack-write-mid-suite-fails-run
**Component:** ravintio-zero
**File:** `docs/adr/0344-suite-marker-silences-strict-hook.md`
**Date:** 2026-11-14T15:11:38Z

## Context

The strict hook asks a step session to write its session id to `plan/.orchestrator-ack`. A step that runs the full suite in the background gets that prompt mid-run. The write changes a tracked file, and `run-tests.sh` fails with "Tree changed during the run". The chart forbids an exemption for the ack in the tree check.

## Decision

Both runners write `plan/.suite-running` with their pid before the first tree snapshot and remove it on exit. The file is git-ignored. In strict mode, the hook prints nothing for a step session (`RAVINTIO_INITIATIVE_STEP=1`) while the marker holds the pid of a live process. Any other case keeps the strict banner.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Exempt the ack in the tree check | Small change | Hides a real change to a guard file | The chart forbids it |
| Write the ack before the suite starts | No hook change | Session ids can change mid-run, so the prompt still arrives | Does not remove the cause |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Hook, both runners, `.gitignore`, docs |

## Consequences

**Positive:**
- A suite that passes no longer fails on the ack write.
- The tree check stays strict.

**Negative:**
- The hook gains a second quiet condition to maintain.

**Risks:**
- A recycled pid keeps the hook quiet outside a run. The window needs a step session and an earlier ack.

## Related ADRs

- ADR-0320 - related-to

## Supersedes

- none

## Superseded By

- none
