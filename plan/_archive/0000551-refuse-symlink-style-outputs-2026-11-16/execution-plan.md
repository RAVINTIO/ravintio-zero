# Execution Plan - Refuse a symlink at the writing style output paths

> Every requirement traces to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000551-refuse-symlink-style-outputs
**Version:** 0.137.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-refuse-linked-style-file.md](requirements/req-001-refuse-linked-style-file.md) | Refuse a link at the style file path or its folder |
| [req-002-refuse-linked-agents-block.md](requirements/req-002-refuse-linked-agents-block.md) | Refuse a link at `AGENTS.md` for the writing block |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | Setup writes nothing through a link at a style output path | 0 bytes change in the link target | Test compares the target checksum |
| NFR-002 | Compatibility | Setup exits 0 when it refuses a link | exit status 0 | Test checks the status |

## API Summary

None. The feature adds no API.

## Data Model Summary

None. The feature adds no data.

## Component Interactions

```mermaid
flowchart LR
    A[setup.sh and setup.ps1] -->|link check| B[style file and AGENTS.md]
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U2, U3 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U1 |
| Output order | `test-0000382-req-005-clear-first-run.sh` reads one banner line of `setup.sh`. The refusal line sits in a function, so none found for the output. | U2 |
| Fixture-pinned line | none found | U2, U3 |
| Reference file edit | none found | U2, U3 |
| Skill-text budget | none found | U2, U3 |
| Backlog entry id | `0000408` matches no test | U2 |
| Sibling copies | `src/ravintio-zero/tests/` holds a copy of each `test-0000389-*` suite. The run edits none of them. | U1 |
| Regression copies | none found under `ravintio-zero/tests/regression/` | U1 |

## Branch-point reads

Base branch: `initiative/0000544-priority-backlog`.

| File | Commit read | Unit |
|------|-------------|------|
| src/ravintio-zero/setup.sh | b7036830 | U2 |
| ravintio-zero/setup.sh | b7036830 | U2 |
| src/ravintio-zero/setup.ps1 | b7036830 | U3 |
| ravintio-zero/setup.ps1 | b7036830 | U3 |
| ravintio-zero/tests/test-0000551-req-001-002-setup-sh.sh | new | U1 |
| src/ravintio-zero/tests/test-0000551-req-001-002-setup-sh.sh | new | U1 |
| ravintio-zero/tests/test-0000551-req-001-002-setup-ps1.ps1 | new | U1 |
| src/ravintio-zero/tests/test-0000551-req-001-002-setup-ps1.ps1 | new | U1 |
| docs/architecture-overview.md | 7bfb978a | U4 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | ravintio-zero/tests/test-0000551-req-001-002-setup-sh.sh, src/ravintio-zero/tests/test-0000551-req-001-002-setup-sh.sh, ravintio-zero/tests/test-0000551-req-001-002-setup-ps1.ps1, src/ravintio-zero/tests/test-0000551-req-001-002-setup-ps1.ps1 | 1 | Red tests come first | none |
| U2 | U1 | src/ravintio-zero/setup.sh, ravintio-zero/setup.sh | 2 | none | none |
| U3 | U1 | src/ravintio-zero/setup.ps1, ravintio-zero/setup.ps1 | 2 | none | none |
| U4 | U2, U3 | docs/architecture-overview.md | 3 | Reads the final behaviour | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | A broken link counts as a link. | Setup skips a write that could succeed. |

## Open Questions

None.
