---
title: "ADR 001: scan the suite for undefined asserts"
summary: "`print_summary` scans the running suite for undefined `assert_*` calls because macOS Bash 3.2 has no not-found handler."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000239-test-suite-reliability"
---
# ADR-0222 - scan the suite for undefined asserts

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000239-test-suite-reliability
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

macOS ships Bash 3.2, which has no `command_not_found_handle`. Bash 4 and later run that handler in a forked child, so the parent never sees a counter there. The plan first chose a handler with a temp file. Implementation found the Bash 3.2 gap and replaced it.

## Decision

`print_summary` reads the outermost script, finds each line that starts with an `assert_*` word, and checks `declare -F` for that name. Each missing name prints a `FAIL` line and adds one to `FAIL`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `command_not_found_handle` | Catches dynamic calls | Absent in Bash 3.2, forked child in Bash 4 | Does not work on macOS |
| `set -u` or `set -e` | No helper change | Suites set their own options | Not uniform |
| Lint every suite | Catches it early | A separate tool | New dependency |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Every Bash suite gets the guard |

## Consequences

**Positive:**
- An undefined assert fails every suite.

**Negative:**
- The scan skips a call inside `$(...)` or after `&&` on the same line.

**Risks:**
- The scan treats a mention of `assert_x` at the start of a heredoc line as a call.

## Related ADRs

- None.

## Supersedes

- None.

## Superseded By

- None.
