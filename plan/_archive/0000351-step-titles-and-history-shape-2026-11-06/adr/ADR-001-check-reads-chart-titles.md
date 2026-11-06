---
title: "ADR 001: the history check reads titles from the chart"
summary: "The history script takes expected step titles from the initiative chart and finds the archived chart by initiative id."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - The history check reads titles from the chart

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Component:** ravintio-zero
**Date:** 2026-11-05

## Context

The check matched a title pattern only. It couldn't tell a step commit from a coordinator commit, and it couldn't compare a title to its feature. I-E Delivery archives the chart before it runs the check, and CI runs the check on a PR into `main`.

## Decision

The script reads the `## Steps` table from the chart. It takes the chart from `--chart`, else `plan/current-initiative/initiative.md`, else the first archived chart under `plan/_archive/` whose folder starts with the 7-digit id in the `--head` branch name. It compares each commit subject to the expected string and builds no regular expression from a title.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the pattern check and add a count | No chart dependency | Can't match title to feature | Doesn't meet the human's request of 2026-11-01 |
| Read titles from step PRs through `gh` | Real PR data | Needs network and auth in CI | Adds a dependency on GitHub state |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Script, template, ship skill, and standards change. |

## Consequences

**Positive:**
- A reader and CI match each commit to its feature.
- Stray coordinator commits fail the check.

**Negative:**
- The check fails on a branch before the step 3 reshape if coordinator commits exist.

**Risks:**
- A missing archived chart blocks delivery. The script names the paths it tried.

## Related ADRs

- 0000319 ADR-001 - extends

## Supersedes

- None.

## Superseded By

- None.
