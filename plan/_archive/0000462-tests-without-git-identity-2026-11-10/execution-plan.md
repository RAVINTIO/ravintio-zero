# Execution Plan - Tests catch runner-only failures

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000462-tests-without-git-identity
**Version:** 0.80.1
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-git-identity-isolation.md](requirements/req-001-git-identity-isolation.md) | Runners hide the git config, and a commit with no identity fails |
| [req-002-bom-first-line-readers.md](requirements/req-002-bom-first-line-readers.md) | First-line readers accept a BOM, and a fixture suite pins it |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Local fidelity | With the PR #136 fixes reverted, the local suite fails on both defects | 2 of 2 defects fail locally | AC-3 of REQ-001 and AC-3 of REQ-002 |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

`run-tests.sh` sources `helpers/git-isolation.sh` and runs each suite with the isolated environment. `run-tests.ps1` sets the same variables. The source lives in `src/ravintio-zero/`, and `sync-installed.mjs` copies it to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U-001, U-002 |
| Non-suite file (`helpers/git-isolation.sh`) | `run-tests.sh` `KNOWN_NON_SUITES` list and `run-tests.ps1` | U-001 |
| Edit to `run-tests.sh` and `run-tests.ps1` | every suite, because the runners run them | U-001 |
| Backlog entry id | 0000414 | U-001 |
| Edit to `setup.sh` or `setup.ps1` (only if a reader fails) | setup suites | U-002 |
| Skill count (no skill added) | none found | none |
| Skill-text budget (no `SKILL.md` edit) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Workflow job or step edit (none) | none found | none |
| Reference file edit (none) | none found | none |
| Fixture-pinned line | none found | none |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Shared resources | Sequential reason |
|------|-----------|--------|-------|------------------|-------------------|
| U-001 | none | `src/ravintio-zero/tests/helpers/git-isolation.sh`, `src/ravintio-zero/tests/run-tests.sh`, `src/ravintio-zero/tests/run-tests.ps1`, `src/ravintio-zero/tests/test-0000462-req-001-git-identity-isolation.sh`, and each suite that needs an identity | 1 | none | - |
| U-002 | none | `src/ravintio-zero/tests/test-0000462-req-002-bom-first-line-readers.sh`, `src/ravintio-zero/tests/test-0000462-req-002-bom-first-line-readers.ps1`, and a reader that fails (`src/ravintio-zero/setup.sh`, `src/ravintio-zero/setup.ps1`, `src/ravintio-zero/scripts/install-lifecycle.mjs`) | 1 | none | - |
| U-003 | U-001, U-002 | `src/ravintio-zero/tests/README.md`, `docs/architecture-overview.md`, `docs/adr/0303-git-isolation-in-test-runners.md` | 2 | none | Living docs unit. It records what U-001 and U-002 built |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Git honours `GIT_CONFIG_GLOBAL`, `GIT_CONFIG_NOSYSTEM`, and `user.useConfigOnly` | The isolation does not reproduce the CI failure |

## Open Questions

None.
