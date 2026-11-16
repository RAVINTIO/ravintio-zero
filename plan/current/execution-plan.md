# Execution Plan - Record each phase start time when the phase begins

> Every requirement traces to a user story.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000576-phase-start-time-at-phase-start
**Version:** 0.143.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| none | plan | none |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-start-time-check.md](requirements/req-001-start-time-check.md) | Check 10 fails a phase block whose Start follows its first artifact commit |
| [req-002-reference-wiring.md](requirements/req-002-reference-wiring.md) | The Phase Invocation reference names the check |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | The check runs read-only git commands with no shell | 0 shell calls, 0 writes | Review of the code |
| NFR-002 | Compatibility | The check adds no dependency | 0 new packages | Review of imports |

## API Summary

None. The feature adds no API.

## Data Model Summary

None. The feature adds no stored data.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id | none found: no suite names 0000402 outside the queue suites that use it as an example id | U1 |
| Reference file edit | test-0000151-req-011-orchestrator-references-split.sh, test-0000358-req-002-clock-in-skills.sh, test-0000458-req-001-refuse-step-merge.sh | U2 |
| Pack file edit | test-0000493-req-004-handoff-text.sh | U1, U2 |
| New test file | test-0000164-req-008-no-process-substitution-loops.sh | U1, U2 |
| Output order | none found: a clean run prints the same line as before | U1 |
| Build log fixtures | test-0000248-req-002-build-log-wall-clock-check.sh, test-0000358-req-002-003-build-log-checks.sh, test-0000392-req-001-ship-postmortem-check.sh, test-0000487-req-002-check-decisions.sh | U1 |
| Regression copies | none found: no regression copy of these tests | U1, U2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| src/ravintio-zero/scripts/build-log-check.mjs | 1e1e0421 | U1 |
| src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-phase-invocation.md | b3f9e10f | U2 |
| src/ravintio-zero/component.yml | a69ae4ea | U3 |
| docs/decisions-index.md | d41a9463 | U3 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/scripts/build-log-check.mjs, ravintio-zero/scripts/build-log-check.mjs, ravintio-zero/tests/test-0000576-req-001-start-time-check.sh | 1 | none | none |
| U2 | none | src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-phase-invocation.md, ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-phase-invocation.md, ravintio-zero/tests/test-0000576-req-002-reference-wiring.sh | 1 | none | none |
| U3 | U1, U2 | docs/decisions-index.md, docs/adr/0351-check-phase-start-against-first-commit.md, src/ravintio-zero/component.yml | 2 | Reads the final script and text | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Each phase writes its artifacts under the listed paths | The check skips that phase and passes |

## Open Questions

None.
