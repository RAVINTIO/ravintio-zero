---
title: "ADR 0348: Build log marker script"
summary: "A script reads the clock and appends a RED, GREEN, or Done line to the build log, so no session types a marker time."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0348 - Build log marker script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000575-build-log-marker-helper
**Component:** ravintio-zero
**File:** `docs/adr/0348-build-log-marker-script.md`
**Date:** 2026-11-16T00:32:25Z

## Context

Step 51 of an earlier initiative wrote its RED and GREEN times by hand after the runs. The times were approximate. The rule says every time comes from a clock read.

## Decision

A new script, `ravintio-zero/scripts/build-log-mark.mjs`, takes a marker kind and a unit. It reads the clock, builds the line, and appends it to `plan/current/build-log.md`. The implement skill names the script for each `RED:`, `GREEN:`, and `Done:` line. The script is Node only and adds no dependency.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the rule in prose | No new code | The agent still types a time | It is the gap the backlog entry reports |
| A hook that rewrites times | Catches every line | Edits a record behind the agent | Hidden writes and a wider guard |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new script, one test, and a text change in the implement skill and two standards. |

## Consequences

**Positive:**
- Each marker time comes from a clock read.
- One command replaces a hand-typed line.

**Negative:**
- A session that skips the script still types a time. The skill text is the only guard.
