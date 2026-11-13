---
title: "Feature Brief - Steps apply the chart's Decisions rows"
summary: "P0 lists the Decisions rows that name the step, the step logs each one it applies, and the build log check fails a log that misses one."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Steps apply the chart's Decisions rows

**Feature ID:** 0000487-steps-apply-decision-rows

Source: backlog entry 0000488-steps-apply-decision-rows, filed after the step 22 retrospective.

## Business Goal

The chart's `## Decisions` table holds answers the human approved in advance. Step 40 ignored the row for steps 25 to 41 on faster local runs. It ran a full baseline and a full suite one after the other, which cost about 30 minutes. No code reads the table, so a step that skips a row meets no check. A script now lists the rows for a step, P0 reads them, and the build log check fails a log that misses one.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Row lookup | As a step session, I list every Decisions row that names my step, including a range such as `25-41`, so that I miss no pre-approved answer. | must-have | 1 |
| Row log | As a maintainer, I see one build log line for each applicable row, so that I know the step applied it. | must-have | 1 |
| Row check | As a maintainer, I want the build log check to fail a step that logs no line for an applicable row, so that a skipped row stops at ship. | must-have | 1 |

## Wanted outcome

- `decision-rows.mjs list --step {n}` prints each row that names the step, with ranges expanded, and skips rows whose Fork is `none`.
- P0 runs the list after the baseline decision and logs `Decision applied (initiative chart): {fork}` for each row, or `Decision not applicable (initiative chart): {fork}: {reason}` when the row does not fit the step.
- If no row names the step, P0 logs `Decisions: none name step {n}`.
- `build-log-check.mjs` finds the step from the log's Feature ID and the chart's Steps table. It fails when an applicable row has no `Decision applied` or `Decision not applicable` line.
- The check does nothing when no chart exists or no chart row matches the Feature ID.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the module, the check, the skill text, the standards, and the tests |

### Data Ownership

No data store.

### Integration Points

`build-log-check.mjs` imports the module. The P0 start actions and `roadmap-standards.md` call it.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js script, Markdown standards, Bash suites already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A module `decision-rows.mjs` with a parser, a range expander, and a `list` command.
- A new check in `build-log-check.mjs`.
- A new P0 start action and updates to `icrun-decision-row` in `roadmap-standards.md`.
- Tests, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

### Out of Scope
- Judging whether a step applied a row correctly. The check requires a log line only.
- Chart-time changes to the table format.
- Changes to the driver.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Non-initiative runs | The check adds no finding and reads no chart | the check test |
| Safety | Chart text is data. The module runs no chart text and builds no path from it. | the module test |

## Constraints and Assumptions

### Constraints
- No new library or service.
- The change widens no guard. It adds a check.
- Node.js built-ins only.
- `SKILL.md` for the orchestrator has 48 bytes left under its cap, so the skill text goes in a reference file.

### Assumptions
- The build log's Feature ID matches the chart's `Feature id` column. Impact if wrong: the check skips and a skipped row goes unseen.
- A row's Fork text is unique within its step. Impact if wrong: one log line covers two rows.

## Scenario Paths

**Happy path:** the chart holds a row `25-41`. Step 40 lists it, logs `Decision applied (initiative chart): Local suite runs`, and the check passes.

**Alternative path:** no row names the step, P0 logs `Decisions: none name step 45`, and the check passes.

**Error / sad path:** a step logs nothing for its row. The check names the fork and exits 1 at ship.

**Cross-session continuity:** the lookup reads the committed chart, so a resumed session gets the same list.

## Acceptance Criteria

- [ ] `decision-rows.mjs list --step 40` prints the `25-41` row and prints no row for step 45.
- [ ] A build log with an applicable row and no log line fails `build-log-check.mjs`, and the finding names the fork.
- [ ] A build log with a `Decision applied` or `Decision not applicable` line for each row passes.
- [ ] A run with no chart passes with no new finding.
- [ ] P0 start actions and `roadmap-standards.md` describe the lookup, the log line, and the check.
