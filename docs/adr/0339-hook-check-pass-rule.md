---
title: "ADR 0339: Hook check pass rule and driver wiring"
summary: "The hook check counts exit 0 and exit 2 as a pass, uses one fixed sample per event and matcher, and runs from the driver after setup."
status: "proposed"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000507-hook-check-after-setup"
---
# ADR-0339 - Hook check pass rule and driver wiring

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000507-hook-check-after-setup
**Component:** ravintio-zero
**File:** `docs/adr/0339-hook-check-pass-rule.md`
**Date:** 2026-11-12T13:42:20Z

## Context

After setup, no command checks that every hook in `.claude/settings.json` loads and runs. The first ad hoc check on 2026-11-11 failed for every hook because it did not set `CLAUDE_PROJECT_DIR`. A guard blocks with exit 2 on purpose, so a plain "exit 0 is a pass" rule would fail every working guard.

## Decision

- `hook-check.mjs` sets `CLAUDE_PROJECT_DIR` and feeds each hook one fixed sample for its event and matcher.
- Exit 0 and exit 2 pass. Any other exit code, a spawn error, or a time-out fails.
- A hook with no sample for its event and matcher fails the check.
- The driver runs the check after the approved setup command exits 0. A failure stops the driver with a `Blocked:` line.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Check that each script file exists | No process runs | Misses a crash on load | The failure of 2026-11-11 was a load failure |
| Treat only exit 0 as a pass | One rule | Fails every working guard | Guards block by design |
| Run the check from setup.sh | One place | Setup then fails on a hook the human may fix next | The driver needs the stop line, not setup |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Gains `scripts/hook-check.mjs` and a driver call |

## Consequences

**Positive:**
- A broken hook stops the driver before the next step.
- The coordinator gets one command and one verdict per hook.

**Negative:**
- A new hook event or matcher needs a sample, or the check fails.

**Risks:**
- A sample could trigger a side effect. The script runs each hook in a temporary working directory.

## Related ADRs

- ADR-0338 - related-to

## Supersedes

- None.

## Superseded By

- None.
