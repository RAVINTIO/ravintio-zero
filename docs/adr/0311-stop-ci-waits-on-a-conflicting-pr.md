---
title: "ADR 311: Stop CI waits on a conflicting PR"
summary: "The merge queue reads mergeability while it waits for checks and stops on a conflict or when no check appears. A step reads it before its CI poll."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000483-mergeability-before-ci-wait"
---
# ADR-0311 - Stop CI waits on a conflicting PR

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000483-mergeability-before-ci-wait
**Component:** ravintio-zero
**File:** `docs/adr/0311-stop-ci-waits-on-a-conflicting-pr.md`
**Date:** 2026-11-11

## Context

PR #166 for step 36 conflicted with the initiative branch after other steps merged. GitHub starts no pull request workflows for a conflicting PR, so no check registered. Step 36 waited about 69 minutes. The queue's `waitForChecks` ends only on a failed check or after 30 minutes, so it can wait the same way.

## Decision

While `gh pr checks` lists no check, `waitForChecks` reads `mergeable`. If it is `CONFLICTING`, the queue stops and names the conflict. If no check appears within `MQ_NOCHECKS_MS` (default 600000 ms), the queue stops and names the wait. A step reads `mergeable` before its CI poll. If it is `CONFLICTING`, the step merges the initiative branch, resolves shared files, and pushes.

Oldest shell: bash 3.2

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Merge the base inside the wait | The queue repairs the PR by itself | A merge inside a poll loop hides a second code path from the run steps | The run already merges the base first. A rerun does it again |
| Rely on the 30-minute timeout | No change | 30 minutes lost for each conflict | The entry exists because of that cost |
| Read `mergeable` before every poll | One rule | One extra call for every poll that has checks | Checks prove the PR does not conflict |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One script function, one section of the roadmap standards, one ship skill line |

## Consequences

**Positive:**
- A conflicting PR stops the queue within one poll.
- A wait with no checks ends with a named error after 10 minutes.

**Negative:**
- A runner that takes over 10 minutes to start a check stops the queue. A rerun resumes it.

**Risks:**
- A suite that stubs `gh pr view` without `mergeable` must keep passing. The read treats a missing value as not conflicting.

## Related ADRs

- ADR-0303 - related-to

## Supersedes

- none

## Superseded By

- none
