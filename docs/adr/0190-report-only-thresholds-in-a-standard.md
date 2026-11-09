---
title: "ADR 003: Thresholds live in a pack standard, and the gate only reports"
summary: "A Markdown thresholds table in the governance standard sets each limit, and a breach never stops ship."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000173-workflow-governance-gates"
---
# ADR-0190 - Thresholds live in a pack standard, and the gate only reports

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000173-workflow-governance-gates
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The wanted outcome puts the thresholds in the pack and says the gate does not block. A reader of the standard should see the limits beside the metric definitions.

## Decision

`ravintio-zero/standards/workflow-governance-standards.md` holds a `## Thresholds` table with `Key` and `Threshold` columns. The script reads that table. A value above its threshold is a breach. The script exits 0 with or without a breach. Ship adds the section to the build report and the PR body, and writes `not measured` if the script fails.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A JSON thresholds file | Trivial parsing | Splits the limits from their definitions | One file keeps one source |
| A blocking gate | Forces attention | The wanted outcome rules it out | Out of scope |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new standard, and ship Steps 5 and 9 |

## Consequences

**Positive:**
- A maintainer changes a limit in one table.

**Negative:**
- A consumer who edits the pack standard loses the edit on the next pack update.

**Risks:**
- A malformed table stops the report. Ship writes `not measured` and carries on.

## Related ADRs

- ADR-0189

## Supersedes

- None

## Superseded By

- None
