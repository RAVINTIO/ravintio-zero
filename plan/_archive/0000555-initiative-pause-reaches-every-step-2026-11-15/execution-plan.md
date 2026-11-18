# Execution Plan - Initiative pause reaches every step

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000555-initiative-pause-reaches-every-step
**Version:** 0.129.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | plan | No capability skill applies. |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-pause-script-and-records.md](requirements/req-001-pause-script-and-records.md) | The script and the three pause records |
| [req-002-driver-pause-request.md](requirements/req-002-driver-pause-request.md) | The driver reads a pause request and resumes from the records |
| [req-003-resume-finding-and-rules.md](requirements/req-003-resume-finding-and-rules.md) | The resume finding, the standards rules, and the skill line |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Maintainability | The initiative skill stays short. | Fewer than 120 lines and a total under 1720 lines | `wc -l` in existing tests |
| NFR-002 | Security | The script follows no symlink and runs no text from a build log. | 0 symlink writes | REQ-001 AC-3 |

## API Summary

None. The step adds no endpoint.

## Data Model Summary

The script writes two markdown records. The step pause record follows `pause.template.md`. The initiative record holds the merged count, the remaining order, the open questions, and the resume steps.

## Component Interactions

The coordinator runs `initiative-pause.mjs request`. The driver reads `plan/.initiative-control/pause`, stops its sessions at a phase end, and runs `initiative-pause.mjs write`. Resume detection and the orchestrator read the records at the next start.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget | test-0000205-req-004, test-0000313-req-002, test-0000314-req-002, test-0000399-req-003-004, test-0000536-req-001-003 (each caps the skill below 120 lines, the skill has 117) | U-3 |
| Skill-text budget | test-0000314-req-002 (total cap 1720) | U-3 |
| Backlog entry id 0000538 | none found | U-3 |
| Reference file edit | test-0000151-req-011-orchestrator-references-split.sh, test-0000009-rail-tightening, test-0000042-req-003-run-mode-resume, test-0000043-req-009-roadmap-resume-and-prefixes, test-0000243-req-005-short-rule, test-0000358-req-001-question-status | U-3 |
| Output order | test-0000243-req-001-002-006-resume-detect.sh (full finding list, line 218), test-0000243-req-003-004-hook-injection.sh | U-3 |
| Output order | test-0000354-req-001-driver-resume.sh, test-0000250-req-002-driver-restart-stop.sh, test-0000511-req-001-003-stop-summary.sh read driver lines and the last line | U-2 |
| Fixture-pinned line | none found | U-1, U-2, U-3 |
| Size cap | test-0000151-req-011 caps the orchestrator SKILL.md, which the step does not edit | U-3 |
| Pack file edit | test-0000493-req-004-handoff-text.sh | U-1, U-2, U-3 |
| New test file | test-0000164-req-008 style tests apply to the three new suites | U-1, U-2, U-3 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| src/ravintio-zero/scripts/initiative-run.mjs | 575f231d | U-2 |
| src/ravintio-zero/scripts/resume-detect.mjs | a1d31cee | U-3 |
| src/ravintio-zero/standards/roadmap-standards.md | 575f231d | U-3 |
| src/ravintio-zero/skills/ravintio-initiative/SKILL.md | 575f231d | U-3 |
| src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-resume-detection.md | d813df28 | U-3 |
| src/ravintio-zero/templates/pause.template.md | c269f565 | U-1 |
| src/ravintio-zero/scripts/initiative-pause.mjs | new | U-1 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-1 | none | initiative-pause.mjs, test-0000555-req-001-pause-records.sh | 1 | none | none |
| U-3 | none | resume-detect.mjs, orchestrator-resume-detection.md, roadmap-standards.md, ravintio-initiative/SKILL.md, test-0000555-req-003-resume-finding.sh | 1 | none | none |
| U-2 | U-1 | initiative-run.mjs, test-0000555-req-002-driver-pause.sh | 2 | Calls the script that U-1 writes. | none |
| U-4 | U-2, U-3 | docs/, component.yml | 3 | Documents the finished change. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The full-list fixture of resume detection holds no initiative pause file. | The step updates the pin. |

## Open Questions

None.
