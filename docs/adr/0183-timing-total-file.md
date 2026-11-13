---
title: "ADR 003: Suites report setup time through a file the runner names"
summary: "Invoke-Setup appends each setup.ps1 time to RAVINTIO_TIMING_FILE, and run-tests.ps1 prints the total."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000171-faster-setup-ps1-tests"
---
# ADR-0183 - Suites report setup time through a file the runner names

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

`run-tests.ps1` starts each suite in a child process. In quiet mode it captures suite output and prints it only on failure. The per-case `[timing]` lines go to the host, and 0000151 req-015 keeps them out of test data. The runner has no way to total them today.

## Decision

`run-tests.ps1` creates an empty timing file in the temp folder and sets `RAVINTIO_TIMING_FILE` to its path. `Invoke-Setup` appends one whole number of milliseconds per run. After the last suite, the runner prints `[timing] setup.ps1 total: {ms} ms over {n} cases` and deletes the file.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Parse `[timing]` lines from suite output | No new variable | Non-quiet mode streams output and never captures it | Works in one mode only |
| A CI step that greps the job log | No runner change | Local runs get no total | The total must show in every run |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `run-tests.ps1` and `helpers/setup-workspace.ps1` change. No pack runtime change. |

## Consequences

**Positive:**
- Each Windows job log holds one total line to read.

**Negative:**
- One more environment variable joins the test harness.

**Risks:**
- A stopped run leaves the file in the temp folder. It holds numbers only.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
