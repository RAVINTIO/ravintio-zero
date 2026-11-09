---
title: "Scope - sharded CI suites"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - sharded CI suites

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000409-ci-shards
**Version:** 0.69.0

## In Scope

- `RAVINTIO_SHARD` in `run-tests.sh` and `run-tests.ps1`.
- Shard jobs and summary jobs in `.github/workflows/ravintio.yml`.
- Removing the Windows pwsh matrix entry.
- Updating the three CI-shape tests and `ravintio-zero/tests/README.md`.
- ADR-0284, which supersedes ADR-0126.
- A changelog entry. No version bump, because this PR is not a chart step.

## Out of Scope

- Running only the suites a change affects. It runs fewer tests, so it needs its own approval.
- Making any single suite faster.
- The consumer workflow `ravintio-zero/hooks/ravintio.yml`, which has no test jobs.

## Deferred

- Removing `windows-powershell (pwsh)` from the ruleset's required checks. The coordinator does it after this PR merges. Until then, the initiative PR into `main` waits on that check.
