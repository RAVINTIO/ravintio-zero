# Execution Plan - Ready file helper

> Every requirement traces to a user story.

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000442-ready-file-helper
**Version:** 0.81.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-ready-helper.md](requirements/req-001-ready-helper.md) | A helper writes and checks the ready file |
| [req-002-driver-recovery.md](requirements/req-002-driver-recovery.md) | The driver recovers a bad ready file |
| [req-003-docs.md](requirements/req-003-docs.md) | The docs name the helper |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | The helper and the driver refuse a symlink at the control paths | 0 writes through a symlink | Tests with a symlinked folder and file |
| NFR-002 | Security | The driver passes the branch as one argument | 0 shell uses of the branch | Stub `gh` test with shell characters |

## API Summary

No API changes.

## Data Model Summary

No data changes.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id 0000424 | none found | U-003 |
| Edited `SKILL.md` (ship) | `test-0000327-req-003-ship-skill-rules.sh`, `test-0000352-req-003-005-skill-rules.sh` | U-003 |
| Edited pack lines (ready file) | `test-0000452-req-002-ready-needs-green.sh`, `test-0000043-req-005-roadmap-advance.sh`, `helpers/scheduler-fixture.sh` | U-003 |
| New test file | repo-wide style tests such as `test-0000164-req-008` | U-001 |
| New script | `test-0000399-req-002-add-step.sh` lists scripts, no pin on the count | U-001 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | src/ravintio-zero/scripts/initiative-ready.mjs, src/ravintio-zero/tests/test-0000442-req-001-ready-helper.sh | 1 | The test drives the script | none |
| U-002 | U-001 | src/ravintio-zero/scripts/initiative-run.mjs, src/ravintio-zero/tests/test-0000442-req-002-driver-recovery.sh | 2 | The driver shares the pattern with the helper | none |
| U-003 | U-002 | src/ravintio-zero/skills/ravintio-ship/SKILL.md, src/ravintio-zero/standards/roadmap-standards.md, src/ravintio-zero/component.yml, ravintio-zero/, docs/ | 3 | Documents what U-001 and U-002 built | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | `gh` is on the driver PATH and holds a sign-in. | Recovery fails and the driver stops as it does today. |
| A-002 | The driver cuts the step branch as `feat/{feature-id}`. | The lookup finds no PR and the driver stops as it does today. |

## Open Questions

None.
