# Execution Plan - Clean up step temp files after each merge

> Every requirement traces to a user story in the brief.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Version:** 0.146.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| none | none | none |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-driver-removes-merged-step-temp.md](requirements/req-001-driver-removes-merged-step-temp.md) | The driver removes a merged step's temp paths and extra worktrees. |
| [req-002-suites-remove-temp-folders-on-exit.md](requirements/req-002-suites-remove-temp-folders-on-exit.md) | Five suites and the git-isolation helper remove temp folders on every exit. |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Safety | Cleanup never matches another step | `step2` keeps `step20` and `step1` | test for REQ-001 AC-2 |
| NFR-002 | Reliability | A failed removal never stops the run | 0 stops on a failed removal | test for REQ-001 AC-3 |
| NFR-003 | Security | The removal never follows a symlink | 0 targets outside the temp folder removed | test for REQ-001 |

## API Summary

No API change.

## Data Model Summary

No data model change.

## Component Interactions

```mermaid
flowchart LR
    Q[merge queue] -->|merged| D[driver cleanStepTemp]
    D -->|git worktree remove, prune| G[git]
    D -->|rmSync| T[temp folder]
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id 0000584 | none found | U-001 |
| Pack file edit | test-0000493-req-004-handoff-text.sh | U-001 |
| Pack file edit | test-0000493-req-004-handoff-text.sh | U-002 |
| Reference file edit: roadmap-standards.md rule | test-0000501-req-001-004-sweep.sh, test-0000509-req-001-003-clear-ready.sh, test-0000511-req-001-003-stop-summary.sh | U-003 |
| Output order | none found | U-001 |
| New test file | test-0000164-req-008-no-process-substitution-loops.sh, run-tests.sh, run-tests.ps1 | U-001 |
| New test file | test-0000164-req-008-no-process-substitution-loops.sh, run-tests.sh, run-tests.ps1 | U-002 |
| Pack content | test-0000042-req-010-pack-wording-allowlist.sh | U-003 |
| Fixture-pinned line | none found | U-003 |
| Helper edit: git-isolation.sh | test-0000462-req-001-git-identity-isolation.sh | U-002 |
| Regression copy of a pinned test | none found | U-002 |

## Branch-point reads

Base: `origin/initiative/0000544-priority-backlog`.

| File | Commit read | Unit |
|------|-------------|------|
| src/ravintio-zero/scripts/initiative-run.mjs | a256a338 | U-001 |
| src/ravintio-zero/tests/test-0000583-req-001-driver-removes-step-temp.sh | new | U-001 |
| src/ravintio-zero/tests/test-0000169-req-004-setup-attribution-setting.sh | c269f565 | U-002 |
| src/ravintio-zero/tests/test-0000245-req-002-targeted-overrides.sh | c269f565 | U-002 |
| src/ravintio-zero/tests/test-0000151-req-005-setup-write-error-line.sh | c269f565 | U-002 |
| src/ravintio-zero/tests/test-0000171-req-004-no-skill-bundling.sh | 462e7100 | U-002 |
| src/ravintio-zero/tests/test-0000029-req-001-003-boot-file-regeneration.sh | c269f565 | U-002 |
| src/ravintio-zero/tests/helpers/git-isolation.sh | f2abdc14 | U-002 |
| src/ravintio-zero/tests/test-0000583-req-002-suites-remove-temp-on-exit.sh | new | U-002 |
| src/ravintio-zero/standards/roadmap-standards.md | 1cb863ae | U-003 |
| src/ravintio-zero/component.yml | 3020593c | U-003 |
| docs/architecture-overview.md | local | U-003 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | src/ravintio-zero/scripts/initiative-run.mjs, tests/test-0000583-req-001 | 1 | none | none |
| U-002 | none | five suites, helpers/git-isolation.sh, tests/test-0000583-req-002 | 1 | none | none |
| U-003 | U-001, U-002 | roadmap-standards.md, component.yml, docs/architecture-overview.md | 2 | The docs name what U-001 and U-002 built | none |

Each unit edits `src/ravintio-zero/` and mirrors the change to `ravintio-zero/`.

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Step temp paths start with `step{n}` in the temp folder | The driver leaves a differently named path behind |

## Open Questions

| ID | Question | Blocking |
|----|----------|----------|
| none | none | none |
