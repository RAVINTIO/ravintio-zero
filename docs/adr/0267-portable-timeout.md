---
title: "ADR 002: Portable timeout through perl alarm"
summary: "with_timeout uses perl alarm and falls back to a Bash watchdog."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000380-test-helpers-and-rule-anchors"
---
# ADR-0267 - Portable timeout through perl alarm

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000380-test-helpers-and-rule-anchors
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

macOS has no `timeout` command. A test that called it exited 127.

## Decision

`with_timeout` in `tests/helpers/timeout.sh` runs `perl -e 'alarm N; exec @ARGV'` when `perl` exists, and maps the SIGALRM status 142 to 124. Without `perl` it starts the command in the background, a watchdog subshell stops it after N seconds, and the helper returns 124.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `gtimeout` | Same flags as `timeout` | Needs coreutils | Absent on macOS by default |
| Node wrapper | Portable | Slower start | A perl call is cheaper |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new helper file and an entry in `KNOWN_NON_SUITES` |

## Consequences

**Positive:**
- One line caps a command on every runner.

**Negative:**
- Two code paths to keep.

**Risks:**
- The Bash path leaves an orphan if the watchdog dies. The suite checks the stop.

## Related ADRs

- ADR-0266 - related-to

## Supersedes

- None

## Superseded By

- None
