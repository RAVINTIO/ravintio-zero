---
title: "ADR 0286: Prose baseline ratchet"
summary: "A per-file count of breaches by rule, kept in git, may fall and never rise."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0286 - Prose baseline ratchet

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000390-prose-checks
**Component:** ravintio-zero
**File:** `docs/adr/0286-prose-baseline-ratchet.md`
**Date:** 2026-11-09T15:01:20Z

## Context

Existing pack prose holds many breaches. A linter that fails on all of them blocks every commit. The chart decision for step 14 says the linter blocks new breaches only, against a per-file baseline.

## Decision

Store counts in `plan/state/prose-baseline.json` as `{"version": 1, "files": {"path": {"rule-id": count}}}`. `check` fails a file when a rule count is above its baseline, and lists every breach of that rule in the file. `update` lowers counts and never raises one. `diff --base <ref>` fails when the working baseline holds a higher count than the baseline at `<ref>`. A `<ref>` with no baseline file passes, so the first commit of the file works.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Store each breach with its line | Names the new breach exactly | Every edit above a breach shifts the line and breaks the entry | Churn on every doc edit |
| Hash each breach sentence | Survives line shifts | A fixed typo elsewhere in the sentence breaks the hash, and the file grows large | Counts are simpler and stable |
| Fail all breaches | No baseline | Blocks every commit until step 19 ends | Contradicts the chart decision |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Owns the baseline file and the three commands |

## Consequences

**Positive:**
- Old breaches pass, new ones fail, and the count falls as people edit.

**Negative:**
- `check` lists all breaches of a rule in an over-baseline file, so the reader must find the new one.
- A file move changes its key. Step 20 must rename the keys.

**Risks:**
- A hand edit that raises a count passes `check`. The `diff` command in pre-commit and CI catches it.

## Related ADRs

- ADR-0285 - depends-on
- ADR-0287 - related-to

## Supersedes

- None.

## Superseded By

- None.
