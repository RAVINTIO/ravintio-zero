---
title: "Feature Brief - Pack source in src"
summary: "Move the pack source to src/ravintio-zero/ with its history and keep ravintio-zero/ as the installed copy."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Pack source in src

**Feature ID:** 0000397-pack-source-in-src

## Business Goal

In this repo, `ravintio-zero/` is both the pack source and the installed pack that hooks, the driver, and skills run. A change to the source changes the running pack at once. The pack source moves to `src/ravintio-zero/` so this repo develops the pack the way a consumer repo uses it. Backlog entry 0000396 is the source.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Move the source | As a maintainer, I find the pack source at `src/ravintio-zero/` with `git log --follow` history, so that blame and history survive the move. | must-have | 1 |
| Installed copy | As a maintainer, I run the pack from `ravintio-zero/`, a plain copy of the source, so that a source change does not change the running pack. | must-have | 1 |
| Retarget source tooling | As a maintainer, I run the tests, CI, and source-side scripts against `src/ravintio-zero/`, so that they check the source. | must-have | 1 |
| Refresh route | As a maintainer, I follow a written route to refresh the installed copy from the source, so that the copies diverge only on purpose. | must-have | 1 |
| Guards cover both paths | As a maintainer, I rely on every guard that covers `ravintio-zero/` also covering `src/ravintio-zero/`, with no new allowed form. | must-have | 1 |
| Component docs | As a maintainer, I find a `component.yml` and docs for the source under the `src/` rules. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The pack source now lives at `src/ravintio-zero/`. The installed copy stays at `ravintio-zero/`. |

### Data Ownership

The component owns its own files. No other component exists.

## Stack

Shell, PowerShell, Node ES modules, and GitHub Actions. No new dependency.

## Scope Boundaries

### In Scope
- A pure `git mv ravintio-zero src/ravintio-zero` commit, then a plain copy back to `ravintio-zero/`.
- Tests, CI, scripts, and guards that point at the source.
- Docs for the refresh route and the layout.

### Out of Scope
- Changing a file format, a hook rule, or a consumer path. Consumer installs keep `ravintio-zero/`.
- A symlink between the two copies.
- The step 21 activation work.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| History | `git log --follow src/ravintio-zero/setup.sh` reaches commits before the move | Local command |
| Parity | `ravintio-zero/` matches `src/ravintio-zero/` byte for byte at the end | Local diff |

## Constraints and Assumptions

### Constraints
- The `git mv` commit holds no content edit.
- No guard gains a new allowed form.

### Assumptions
- Tests locate the pack by a path relative to their own file or by the repo root. Impact if wrong: the plan lists every path that needs a change.

## Scenario Paths

**Happy path:** The move commit, the copy commit, and the retargeted tooling land. The suite and CI pass against `src/ravintio-zero/`.

> The suite runs from the source and the installed copy matches it.

**First-run path:** A fresh clone holds both copies. Hooks run from `ravintio-zero/` and tests run from `src/ravintio-zero/`.

> The clone needs no bootstrap step.

**Error / sad path:** A guard misses `src/ravintio-zero/`. A test proves each guard blocks the same actions on both paths.

> A drift between the copies fails a parity check.

**Cross-session continuity:** The move is two commits on the step branch, so an interrupted session resumes from git state.

> A half-done move shows as one commit or none.

## Acceptance Criteria

- [ ] `git log --follow src/ravintio-zero/setup.sh` reaches commits from before the move.
- [ ] `ravintio-zero/` matches `src/ravintio-zero/` byte for byte at the step's end.
- [ ] The full suite and CI pass against `src/ravintio-zero/`.
- [ ] Consumer installs keep their paths.
- [ ] Every guard that covers `ravintio-zero/` also covers `src/ravintio-zero/`.
- [ ] The docs describe the refresh route.
