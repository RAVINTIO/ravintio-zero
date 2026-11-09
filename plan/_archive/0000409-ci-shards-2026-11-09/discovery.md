---
title: "Discovery - 0000409-ci-shards"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000409-ci-shards

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000409-ci-shards`, cut from `initiative/0000360-backlog-sweep` at `308ffaf9`. Main is not the base: the PR targets the initiative branch. |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.69.0`
- Prior features (`plan/_archive/`): `0000036-test-runner-coverage` added the Windows job. `0000037` added `bash-suites`. `0000151` req-015 made the Windows hosts a matrix. `0000385-faster-test-runs` sped up local runs.
- Constraining ADRs (unless superseded): ADR-0126, CI runs the PowerShell suites on Windows under both hosts. This run supersedes it.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`, owns the runners and tests.

## Problem findings

- CI run 42591372542 on PR #135, 2026-11-09: `windows-powershell (powershell)` 16 minutes, `windows-powershell (pwsh)` 13 minutes, `bash-suites` 9 minutes.
- Each runner runs its suites serially. `bash-suites` also runs the 26 `.ps1` suites under pwsh on Linux, so CI runs them three times.
- The slowest Windows cases are full `setup.ps1` installs of 30 to 47 seconds each.
- The `Protect Main Branch` ruleset requires `bash-suites`, `windows-powershell (powershell)`, `windows-powershell (pwsh)`, `validate-branch`, and `self-description-check` by name.
- Tests that read the job shape: `test-0000036-req-005-windows-ci-job.sh`, `test-0000037-req-006-bash-suites-ci-job.sh`, and `test-0000151-req-015-faster-powershell-ci.sh`.
- Repo instructions: `custom-001`, `custom-002`, `custom-004`, and `custom-006` in `ravintio-overrides/instructions/`.
- Backlog pickup: none. This hotfix takes no entries.

## Coaching record

The human chose these in the coordinator session on 2026-11-09:
1. "Shard and drop pwsh", over sharding alone or waiting for the next initiative.
2. "I edit the ruleset": the coordinator removes `windows-powershell (pwsh)` from the required checks after the PR merges.
3. "CI hotfix first": the driver stays stopped until this PR merges.
