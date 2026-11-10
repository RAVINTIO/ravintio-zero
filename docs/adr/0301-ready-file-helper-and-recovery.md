---
title: "ADR 301: A helper writes the ready file and the driver recovers a bad one"
summary: "A script writes and checks the ready file. The driver recovers the PR number from the step branch when the file is empty or invalid."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000442-ready-file-helper"
---
# ADR-0301 - A helper writes the ready file and the driver recovers a bad one

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000442-ready-file-helper
**Component:** ravintio-zero
**File:** `docs/adr/0301-ready-file-helper-and-recovery.md`
**Date:** 2026-11-10

## Context

A step wrote the `ready` file by hand. Step 9 wrote a timestamp and step 20 left the file empty. The driver stops on any value that is not a PR number, so each slip stopped the initiative.

## Decision

Add `initiative-ready.mjs`. It checks the PR number against the driver pattern and writes `ready` through a temporary file and a rename. A `--check` flag reports whether the file is valid.

The driver also recovers. If `ready` is empty or invalid, it asks `gh pr list --head feat/{feature-id} --state open` for the PR. It rewrites the file only when exactly one PR matches. Otherwise it stops as before.

Oldest shell: not applicable. Both parts are Node ESM.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Helper only | Smallest change | A step that ignores the helper still stops the driver | The backlog entry asks for recovery |
| Recovery only | No new script | Steps keep writing bad files | The slip stays easy to repeat |
| Skip the check and trust the step | No code | Repeats the stops of steps 9 and 20 | Does not fix the cause |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New script, driver change, text in the ship skill and the roadmap standards |

## Consequences

**Positive:**
- A step writes a valid file with one command.
- A bad file no longer stops the initiative when one PR exists.

**Negative:**
- The driver now calls `gh` while it reads the control folder.

**Risks:**
- Recovery could pick a wrong PR. The exact head and the single-match rule limit this.

## Related ADRs

- ADR-0298 - related-to

## Supersedes

- None.

## Superseded By

- None.
