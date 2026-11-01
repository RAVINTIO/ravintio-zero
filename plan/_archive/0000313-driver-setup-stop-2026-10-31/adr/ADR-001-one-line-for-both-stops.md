---
title: "ADR 001: One stop line for both stops"
summary: "A step that triggers Restart and Setup gets one line, and the Restart-only line stays unchanged."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - One stop line for both stops

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000313-driver-setup-stop
**Component:** ravintio-zero
**Date:** 2026-10-31

## Context

The initiative skill is in `WATCHED` and also under `ravintio-zero/skills/`. A skill change triggers both stops. The driver exits once, so it can print only one stop line. Entry 0000311 asks for one line that names both.

## Decision

The driver builds two lists after a merged step: files that match `WATCHED` (restart) and files under the setup paths (setup). If both lists hold files, it prints `I-D Advance: Restart: Setup: step {n} changed {files}. Rerun setup, then start a new driver so step {next} runs the new code.` The list is the restart files first, then the setup-only files, with no repeats. If only one list holds files, the line keeps its own form. A list longer than 5 names shows 5, then `and {k} more`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Print two lines | Each line keeps its form | The skill must parse two lines, and tests expect one stop line | Adds parsing |
| Setup stop wins over Restart | One token | Hides that the skill text is old | Loses the restart cue |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The driver, the initiative skill, and the standards change |

## Consequences

**Positive:**
- The skill and the human see every reason in one line.
- Existing `Restart:` tests keep their substrings.

**Negative:**
- The line has a third form to document.

**Risks:**
- A future watched file under a setup path always yields the combined form.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
