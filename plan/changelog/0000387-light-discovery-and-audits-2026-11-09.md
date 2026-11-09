# Changelog (0000387-light-discovery-and-audits, 09 Nov 2026)

**Feature:** Light discovery and audits
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- A light P0 track for fixes and small changes. The orchestrator offers it, `discovery.md` records `Track: light` or `Track: full`, and a light run that grows switches to full and logs the switch (0000281).
- Coaching records group into one commit per topic. A requirement, an ADR, and `design.md` still commit at once (0000284).
- P0 coaching checks that at least one instance of the tested content exists before it confirms a criterion, and offers a reworded criterion if none does (0000348).
- `ravintio-plan` re-runs the dependency audit before the plan gate for advisory or version requirements and logs `Audit: re-run at P1 ({result})` (0000328).
- P0 coaching asks whether a major bump is pre-approved for an advisory fix and records the answer in `Approved dependencies` (0000329).

## Why

Small work spent most of its time in P0, coaching decisions flooded the branch with commits, and two late-found problems stopped runs in P1 and P2.

## Deviations

- The boot template had no commit section, so U2 added one. Its size cap rose from 3,600 to 3,800 bytes.
- The 0000377 size cap on the orchestrator skill rose from 8,700 to 9,000 bytes for the new Pack Index row and pointer.
- `run-tests.sh` lists the two new fixture files.

## Validation results

- Full Bash suite: 337 feature suites and 19 regression suites passed.
- PowerShell suites were not run here. The Windows CI job runs them.

## Skipped phases

None
