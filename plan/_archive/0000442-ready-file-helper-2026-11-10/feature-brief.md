---
title: "Feature Brief - ready file helper"
summary: "A helper writes and checks the ready file, and the driver recovers the PR number from the step branch when the file is bad."
status: "approved"
version: "0.1.0"
---
# Feature Brief - ready file helper

**Feature ID:** 0000442-ready-file-helper

Source: backlog entry 0000424, from the initiative 0000360 retrospective (evidence rows 9 and 10).

## Business Goal

A step writes the `ready` file by hand. Step 9 wrote a timestamp and step 20 left the file empty. The driver stops on any value that is not a PR number. A helper writes a valid file, and the driver recovers a bad one, so a formatting slip no longer stops the initiative.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Ready file helper | As a step session, I run one command that checks the PR number and writes the ready file, so that the driver never meets an invalid file. | must-have | 1 |
| Driver recovery | As the driver, I recover the PR number from the step branch when the ready file is bad, so that a slip costs no stop. | must-have | 1 |

## Wanted outcome

- `initiative-ready.mjs --pr {n}` checks the number and writes `ready` in `$RAVINTIO_INITIATIVE_CONTROL`.
- `initiative-ready.mjs --check` reports whether the file holds a valid PR number.
- If `ready` is empty or invalid, the driver looks up the one open PR for `feat/{feature-id}` and rewrites the file. If it finds none or more than one, it stops as it does today.
- The ship skill and the roadmap standards name the helper.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the helper, the driver, the standard, and their tests |

### Data Ownership

No data store. The driver owns `plan/.initiative-control/step-{n}/`. The helper writes only the `ready` file in it.

### Integration Points

The helper reads `RAVINTIO_INITIATIVE_CONTROL`. The driver calls `gh pr list` for recovery.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node ESM scripts and bash tests already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- `initiative-ready.mjs` with `--pr` and `--check`.
- A recovery path in the driver for an empty or invalid `ready` file.
- Ship skill and roadmap standards text, tests, an ADR, and a changelog entry.

### Out of Scope
- The merge queue and the `running` file.
- Any change to how the driver reads a valid `ready` file.
