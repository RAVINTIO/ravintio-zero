---
title: "ADR 308: Report CI duration in workflow metrics"
summary: "Ship records each CI run's duration as a build log marker, and workflow-metrics.mjs compares the longest run with a 420-second threshold."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000472-ci-duration-metric"
---
# ADR-0308 - Report CI duration in workflow metrics

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000472-ci-duration-metric
**Component:** ravintio-zero
**File:** `docs/adr/0308-report-ci-duration-in-workflow-metrics.md`
**Date:** 2026-11-10

## Context

Each merge in initiative 0000360 waited about 16 minutes for CI. Feature 0000409 cut it to 4m40s with shards. No metric shows CI growth, so it shows only when someone feels it.

## Decision

Ship appends `CI duration: {seconds}s (run {run-id}, {timestamp})` to the build log when the CI wait ends. `workflow-metrics.mjs` reports the longest value against the `ci-duration-seconds` threshold of 420 seconds. `testing-standards.md` names the same target. The gate reports and never blocks.

Oldest shell: bash 3.2

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| The script reads runs from GitHub | No marker to write | Needs the network and a token in a script that has none | Widens the script's inputs |
| A CI job that fails on a slow run | Fails closed | A slow runner fails an unrelated step | Out of scope. A report is enough to show growth |
| No threshold, a number only | Smaller change | Nothing says when the number is too high | The target is the point of the entry |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One script row, one threshold row, one target, and one ship skill line |

## Consequences

**Positive:**
- CI growth shows in each build report and PR body.
- The target sits in a standard that a later step can edit.

**Negative:**
- Ship spends one `gh run view` call per CI wait.

**Risks:**
- A suite that passes its own standards file needs the new key. P2 adds it.

## Related ADRs

- ADR-0303 - related-to

## Supersedes

- none

## Superseded By

- none
