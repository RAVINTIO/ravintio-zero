---
title: "ADR-001: gate-write takes Bash calls"
summary: "Extend gate-write to read shell writes instead of adding a ninth hook."
---
# ADR-001: gate-write takes Bash calls

**Status:** accepted
**Component:** ravintio-zero

## Context

Step sessions write files with heredocs, `tee`, and `sed -i`. The `gate-write` hook runs on Write and Edit only, so those writes skip the design gate (0000271).

## Decision

Extend `gate-write.mjs` to read a Bash `tool_input.command`, find the write targets, and apply the existing path checks. Wire it on the Bash matcher in both setup scripts, after the other Bash guards. A target with a shell expansion passes, because the value is unknown. This leaves no new form blocked or allowed for Write and Edit.

## Alternatives

- A new hook module. It adds a module to the parity, retirement, and Codex lists and duplicates the path checks.

## Consequences

- Positive: one rule set covers both tools. No new module name.
- Negative: every Bash call now starts one more guard process. A write built from a variable, or by a script, still passes. CI and the plan wording checks remain the backstop.
