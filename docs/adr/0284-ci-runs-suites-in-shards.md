---
title: "ADR 284: CI runs the suites in shards"
summary: "CI runs 4 bash shards and 3 Windows PowerShell 5.1 shards behind summary jobs with the required names, and no longer runs pwsh on Windows."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000409-ci-shards"
---
# ADR-0284 - CI runs the suites in shards

**Status:** accepted
**Component:** ravintio-zero
**Supersedes:** ADR-0126

## Context

Each CI test job ran its suites one after another. On PR #135, `windows-powershell (powershell)` took 16 minutes, `windows-powershell (pwsh)` 13, and `bash-suites` 9. The `.ps1` suites ran three times: twice on Windows and once under pwsh on Linux. Every merge-queue run waits for this CI, so a 21-step initiative spent hours waiting. ADR-0126 set the Windows job to run under both hosts.

## Decision

Both runners read `RAVINTIO_SHARD=i/n` and run suite k when `k mod n` equals `i - 1`. CI runs `bash-suites-shard` as a matrix of 4 shards and `windows-powershell-shard` under Windows PowerShell 5.1 as a matrix of 3. Two summary jobs, `bash-suites` and `windows-powershell (powershell)`, need their shard job and fail unless it succeeded, so the ruleset's required names still report. CI no longer runs pwsh on Windows. pwsh still runs every `.ps1` suite on Linux inside `bash-suites-shard`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Shard and keep Windows pwsh | No ruleset change | More runner minutes for little extra coverage | The human chose to drop it |
| Run only the suites a change affects | Biggest saving | Runs fewer tests per PR, so it weakens a check | Needs its own approval |
| Parallel suites inside one job | One job per host | Suites share temp folders and git config, so they can collide | Separate runners isolate each shard |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Both runners read one variable |
| repo workflow | Shard and summary jobs replace the two test jobs |

## Consequences

**Positive:**
- The slowest required check drops from about 16 minutes to about 6.
- The shard count is one matrix value.

**Negative:**
- A fault that shows only under pwsh on Windows goes unseen.
- The ruleset on `main` must drop `windows-powershell (pwsh)` from its required checks.
