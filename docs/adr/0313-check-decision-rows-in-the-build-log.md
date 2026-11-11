---
title: "ADR 313: Check the Decisions rows in the build log"
summary: "A module lists the Decisions rows for a step, and build-log-check fails a log that has no line for an applicable row."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000487-steps-apply-decision-rows"
---
# ADR-0313 - Check the Decisions rows in the build log

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000487-steps-apply-decision-rows
**Component:** ravintio-zero
**File:** `docs/adr/0313-check-decision-rows-in-the-build-log.md`
**Date:** 2026-11-11

## Context

The chart's `## Decisions` table holds answers the human approved in advance. Rule `icrun-decision-row` tells a step to apply a matching row, but no code reads the table. Step 40 ignored the row for steps 25 to 41 and spent about 30 minutes on a baseline run that the row had removed. Rows name steps as a number or a range, so a reader must expand them.

## Decision

Add `decision-rows.mjs`. It parses the table, expands ranges, and lists the rows for a step. P0 runs it and logs one line for each row. Check 9 of `build-log-check.mjs` finds the step from the Feature ID in the log and the chart's Steps table. It fails when an applicable row has no `Decision applied` or `Decision not applicable` line. The check skips when no chart or no matching row exists.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add the rows to the step start prompt | The driver does the lookup | The driver changes and restarts, and the prompt can grow long | A skill text and a check cover the same ground with no driver change |
| Only tell the step to read the table | No code | Step 40 shows the text alone fails | Nothing would catch a skipped row |
| Check that the step followed each answer | Catches a wrong application | Answers are free text that code cannot judge | The check requires a log line, and the retrospective reads the rest |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Gains `decision-rows.mjs`, check 9, and a P0 start action |

## Consequences

**Positive:**
- A step meets every pre-approved answer at P0.
- A skipped row stops the step at ship, with the fork named.

**Negative:**
- A step can log a line without applying the row. The check cannot tell.
- Each applicable row costs one build log line.

**Risks:**
- A fork text with a colon breaks a loose match. The check compares the trimmed text after a fixed prefix.

## Related ADRs

- ADR-0302 - related

## Supersedes

None.

## Superseded By

None.
