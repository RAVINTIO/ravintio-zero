---
title: "Feature Brief - sharded CI suites"
summary: "CI runs the test suites in parallel shards and drops the Windows pwsh run, so a step PR waits about 5 minutes for CI instead of about 16."
status: "approved"
version: "0.1.0"
---
# Feature Brief - sharded CI suites

**Feature ID:** 0000409-ci-shards

Source: a human request during I-C Run of initiative 0000360, on 2026-11-09: "We need to speed up the CI".

## Business Goal

Every merge-queue run waits for CI on the step PR. The slowest job, `windows-powershell (powershell)`, takes about 16 minutes. `windows-powershell (pwsh)` takes 13 and `bash-suites` takes 9. Each job runs its suites one after another, and CI runs the `.ps1` suites three times. CI now splits the suites into parallel shards and runs the `.ps1` suites under pwsh on Linux only.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Sharded suites | As the coordinator of an initiative, I see CI on a step PR finish in about 5 minutes, so that the queue merges steps sooner. | must-have | 1 |

## Wanted outcome

- `run-tests.sh` and `run-tests.ps1` accept `RAVINTIO_SHARD=i/n` and run only shard i of n.
- CI runs 4 bash shards and 4 Windows PowerShell 5.1 shards in parallel.
- The required checks `bash-suites` and `windows-powershell (powershell)` still report, and pass only when every shard passes.
- CI no longer runs the Windows pwsh job.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the test runners and their tests |

The repo's own workflow `.github/workflows/ravintio.yml` changes. The consumer copy `ravintio-zero/hooks/ravintio.yml` has no test jobs, so it does not change.

### Data Ownership

No data store.

### Integration Points

GitHub Actions and the `Protect Main Branch` ruleset, which requires checks by name.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash and PowerShell runners, YAML workflow |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- `RAVINTIO_SHARD` in both runners.
- Shard jobs and summary jobs in `.github/workflows/ravintio.yml`.
- Removing the Windows pwsh matrix entry.
- Updating the CI-shape tests and `tests/README.md`.
- An ADR that supersedes ADR-0126.

### Out of Scope
- Running only the suites a change affects. That runs fewer tests, so it weakens a check and needs its own approval.
- Making any single suite faster.

### Deferred
- Removing `windows-powershell (pwsh)` from the ruleset's required checks. The coordinator does this after the PR merges, as the human approved.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| CI wall clock on a step PR | 7 minutes or less for the slowest required check | `gh run view` on this PR |
| Coverage | Every suite runs in exactly one shard per job | The new runner test |

## Constraints and Assumptions

### Constraints
- No suite is skipped. The union of the shards is the full suite list.
- No new library or service.

### Assumptions
- GitHub reports a summary job under its `name:`, so the ruleset still matches. Impact if wrong: the main ruleset blocks the initiative PR until the human edits it.

## Scenario Paths

**Happy path:** a PR opens. Seven shard jobs run in parallel. Both summary jobs pass.

**Alternative path:** `RAVINTIO_SHARD` is unset. The runners run every suite, as before.

**Error / sad path:** one shard fails. Its summary job fails, so the required check fails. A malformed `RAVINTIO_SHARD` makes the runner exit 2 with a message.

**Cross-session continuity:** not applicable.

## Acceptance Criteria

- [ ] With `RAVINTIO_SHARD=i/n`, each runner runs a disjoint subset, and the n subsets cover every suite.
- [ ] The workflow runs 4 bash shards and 4 Windows PowerShell 5.1 shards, behind summary jobs named `bash-suites` and `windows-powershell (powershell)`.
- [ ] CI on this PR finishes its slowest required check in 7 minutes or less.
