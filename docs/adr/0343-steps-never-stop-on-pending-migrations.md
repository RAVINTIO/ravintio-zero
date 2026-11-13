---
title: "ADR 0343: Steps never stop on pending migrations"
summary: "Chart collects the human's answer for each pending migration, and a step session records one it has no row for and carries on."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0343 - Steps never stop on pending migrations

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000536-pending-migrations-reach-the-human-early
**Component:** ravintio-zero
**File:** `docs/adr/0343-steps-never-stop-on-pending-migrations.md`
**Date:** 2026-11-13

## Context

On 2026-11-12 at 02:26 step 55 stopped in P0 to ask about pending migration 0009. The driver exited and the run waited about 4.5 hours. Steps 43 and 45 had already reported the migration on 2026-11-11, and nobody raised it with the human.

## Decision

I-A Chart runs resume detection and lists every pending migration. The human sees each finding and approves findings one by one. The answer lists the approved findings, or holds `none`. It never holds `all`, so no finding runs without review. Chart writes each answer as a `## Decisions` row whose Fork starts with `Migration:`.

A step session runs `ravintio-migrator` for a migration that has a row, and applies only the findings the row lists. For any other pending migration, the step writes `Migration pending: {id}` in its build log and carries on. The coordinator raises each such line in its next report.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the step stop | The human decides at once. | The driver waits for hours with no human present. | It caused the 4.5 hour stall. |
| Run every migration with no question | No wait. | The migrator would apply changes the human never saw. | Hard Limit 3 of the migrator needs a human answer. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Initiative skill, roadmap standards, orchestrator resume-detection reference, and migrator skill change. |

## Consequences

**Positive:**
- No step waits on a migration question.
- The human sees every pending migration at chart time.

**Negative:**
- A migration that appears mid-run stays pending until the coordinator raises it.

**Risks:**
- A later step reads files in the old format before the migration runs.

## Related ADRs

- ADR-0310 - related-to: the `Confirmation:` row pattern.

## Supersedes

- None

## Superseded By

- None
