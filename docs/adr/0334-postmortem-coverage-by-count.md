---
title: "ADR 001: Postmortem coverage by line"
summary: "Ship matches stops and reworks to Postmortem lines, and a record check runs on each named file."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000392-ship-postmortems"
---
# ADR-0334 - Postmortem coverage by line

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000392-ship-postmortems
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

A trigger line in a reference file never produced a postmortem, and ship did not check for one. Rework lines carry a requirement id. Stops do not.

## Decision

`build-log-check.mjs` needs one `Postmortem:` line per `Resolved:` line and one line that names each reworked `REQ-nnn`. A `Postmortem:` line that names a `REQ-nnn` covers that requirement only. `postmortem-check.mjs` validates the CAPA rows of each named record, and `build-log-check.mjs` calls it.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| One postmortem per Rework line | Simple count | Twelve records for one step | Too heavy, and one cause often spans several lines |
| Match by record content | Exact pairing | Parses free text | Brittle |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One check function in an existing script, and one new script. |

## Consequences

**Positive:**
- Ship fails on a log that lacks a record.

**Negative:**
- A run with many reworks needs one record that names every requirement.

**Risks:**
- A record that names a requirement without covering it passes the count. Review catches that.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
