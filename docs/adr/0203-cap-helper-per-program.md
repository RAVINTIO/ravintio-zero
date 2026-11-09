---
title: "ADR 002: A cap helper in each program"
summary: "Each program holds its own small cap function, because the hook installs as a single file."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000198-cap-echoed-plan-text"
---
# ADR-0203 - A cap helper in each program

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000198-cap-echoed-plan-text
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

`ratchet-check.mjs` installs under `.claude/hooks/enforcement/`. It imports only `read-stdin.mjs`, which installs beside it. `consistency-check.mjs` runs from `ravintio-zero/scripts/`. A shared module would need a new install path for the hook and a change to setup, which the brief puts out of scope.

## Decision

Each program holds a short `cap(line)` function. It cuts a line to 200 code points and appends ` …[truncated]` if it cut. The ratchet reuses its existing `TRUNCATE_MARKER` constant. The two copies match and a test checks both against the same line.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A shared module in `hooks/enforcement/` | One copy | The script would import from a hook folder, and setup needs a wiring change | Setup wiring is out of scope |
| Cap by UTF-16 units with `slice` | Shorter code | Can split a surrogate pair | The cut would print a broken character |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two copies of a four-line function |

## Consequences

**Positive:**
- No setup change and no new install path.

**Negative:**
- A future change to the cap value needs two edits.

**Risks:**
- The copies drift. A test asserts the same output for the same line in both programs.

## Related ADRs

- ADR-0202

## Supersedes

None.

## Superseded By

None.
