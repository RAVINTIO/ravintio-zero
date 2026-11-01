# Execution Plan - Squash before main

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Version:** 0.48.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| none | plan | No capability skills are active |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-check-script.md](requirements/req-001-check-script.md) | A script fails a PR into main that breaks the branch or commit rule |
| [req-002-ci-job.md](requirements/req-002-ci-job.md) | CI runs the check on every PR into main |
| [req-003-ship-skill-rules.md](requirements/req-003-ship-skill-rules.md) | The ship skill squashes, limits force-push, and waits for CI |
| [req-004-allowed-branch-prefixes.md](requirements/req-004-allowed-branch-prefixes.md) | Standards and ruleset doc name the three prefixes |
| [req-005-hotfix-cut.md](requirements/req-005-hotfix-cut.md) | A run outside an initiative cuts a hotfix branch |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Determinism | The same refs give the same exit code | 0 differing exit codes across 2 runs | The suite runs the script twice |
| NFR-002 | Security | The job adds no token scope and passes the head ref through `env` | 1 `contents: write` in each workflow, 0 inline `github.head_ref` in a `run` line | The suite reads both workflows |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

```mermaid
flowchart LR
    A[PR into main] --> B[CI job squash-before-main]
    B -->|head ref, base, head| C[check-pr-into-main.mjs]
    C -->|exit 0, 1, 2| B
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget: the run edits the ship `SKILL.md` | `test-0000031-req-003-five-phases.sh:31`, `test-0000206-req-002-step-application.sh:31`, and `test-0000314-req-002-driver-files-stay.sh:35` cap total skill text at 1720 lines. Now 1568. | U-003 |
| Skill count | none found | none |
| Size cap | `test-0000247-req-001-stage-by-path.sh:35` caps the orchestrator `SKILL.md`. The run edits a reference file only. | U-004 |
| Backlog entry id: 0000326 | none found | none |
| Ship skill text | `test-0000151-req-002-ship-sentinels-before-pr.sh`, `test-0000043-req-010-merge-carve-out-governance.sh`, `test-0000169-req-003-attribution-check-in-ship-and-ci.sh`, `test-0000169-req-006-release-tag-ci-and-ship-flow.sh` | U-003 |
| Roadmap standards and ruleset doc | `test-0000043-req-010-merge-carve-out-governance.sh`, `test-0000319-req-005-ruleset-doc.sh` | U-004 |
| Pickup text | `test-0000151-req-011-orchestrator-references-split.sh`, `test-0000321-req-004-pickup-text.sh` | U-004 |
| Workflow files | `test-0000031-req-002-single-route.sh`, `test-0000036-req-005-windows-ci-job.sh`, `test-0000319-req-002-ci-jobs.sh`, `test-0000321-req-003-ci-index-check.sh` | U-002 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | check-pr-into-main.mjs, test-0000327-req-001 | 1 | none |
| U-003 | none | ravintio-ship SKILL.md, test-0000327-req-003 | 1 | none |
| U-004 | none | roadmap-standards.md, main-ruleset.md, orchestrator-p0-start-actions.md, test-0000327-req-004-005 | 1 | none |
| U-002 | U-001 | .github/workflows/ravintio.yml, ravintio-zero/hooks/ravintio.yml, test-0000327-req-002 | 2 | The job names the script flags from U-001 |
| U-005 | U-001, U-002, U-003, U-004 | docs, component.yml, product.yml, about.md, changelog | 3 | Shared docs and the version need the code first |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | A full checkout makes `origin/{head ref}` readable in CI | The script exits 2 and the job fails closed |

## Open Questions

None.
