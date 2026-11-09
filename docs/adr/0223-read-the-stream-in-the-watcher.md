---
title: "ADR 001: Read the stream in the watcher"
summary: "The watcher turns the step log into activity lines. The driver only switches the output format."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000240-stream-step-session-activity"
---
# ADR-0223 - Read the stream in the watcher

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000240-stream-step-session-activity
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

Step logs stay empty until a step ends. The chart Decisions row for step 2 picks `--output-format stream-json --verbose` and puts the summary reader in `initiative-watch.mjs`. The stack is Node ESM with no dependencies, per the design.

## Decision

The driver passes the stream flags and keeps writing stdout to the log. The watcher reads the log of the current `position` by byte offset, parses complete lines as JSON, and prints one `I-C Run: activity:` line per event. It polls every 10 seconds and starts at the end of the log.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| New reader script | Isolated | A second monitor for the human to start | Chart chose one monitor |
| Driver prints summaries | No extra file read | The driver would print step content | Breaks the driver privacy rule |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Driver args, watcher reader, skill text, standards text |

## Consequences

**Positive:**
- One monitor carries every line.
- The driver stays free of step content.

**Negative:**
- The watcher reads a log the driver writes, so the two scripts share a file format.
- Step 3 edits the same watcher file.

**Risks:**
- A shape change in stream-json hides events. See R-001.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
