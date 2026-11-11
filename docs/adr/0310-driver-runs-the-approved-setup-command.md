---
title: "ADR 310: Driver runs the approved setup command"
summary: "The driver runs the setup command from the Confirmation row at a Setup stop, with a strict command form and no shell."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000448-driver-runs-approved-setup-command"
---
# ADR-0310 - Driver runs the approved setup command

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000448-driver-runs-approved-setup-command
**Component:** ravintio-zero
**File:** `docs/adr/0310-driver-runs-the-approved-setup-command.md`
**Date:** 2026-11-11

## Context

Four steps in initiative 0000360 changed hooks, skills, or setup. Each stopped the driver with `Setup:` for the same approved command, and each stop needed a coordinator restart. Setup rewrites hook wiring, so a human decides the command at Chart. The driver cannot read a `Confirmation:` row.

## Decision

The driver reads the setup `Confirmation:` row from the chart with `setup-command.mjs`. The helper accepts one form: the pack `setup.sh` path followed by plain words and `--flag` words. At a `Setup:` hit the driver runs that command with `bash` and an argument array, then continues. A missing row, a different form, a stale main tree, or a non-zero exit keeps the stop. A `Restart:` hit still stops after the command has run.

Oldest shell: bash 3.2

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the stop and have the coordinator run it | No new execution path in the driver | Every setup stop needs a restart | The entry asks to remove the restart |
| Run any command that the row names | Fewer rules in the helper | A bad row runs any program | Widens what the driver can execute |
| Hard-code the command in the driver | No chart parsing | The human cannot change the approved command | The chart row is the approval record |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new script, one driver change, and text in the standards and the initiative skill |

## Consequences

**Positive:**
- A setup stop no longer needs a coordinator restart.
- The chart row stays the one record of the approved command.

**Negative:**
- The driver now executes a command that a chart file names.

**Risks:**
- A stale main tree installs old files. The driver checks the ref first and stops if it cannot match it.

## Related ADRs

- ADR-0309 - related-to

## Supersedes

- none

## Superseded By

- none
