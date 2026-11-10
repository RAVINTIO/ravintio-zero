# Execution Plan - plan rereads files at the branch point

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000470-plan-rereads-files-at-the-branch-point
**Version:** 0.83.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-branch-point-reread.md](requirements/req-001-branch-point-reread.md) | Branch-point reread in the plan skill and the execution plan template |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Maintainability | The skill-text total stays within its cap | 1720 lines or fewer | `test-0000384-skill-text.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The plan skill reads the execution plan template. `sync-installed.mjs` copies `src/ravintio-zero/` to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget (edit to `ravintio-plan/SKILL.md`) | `test-0000384-skill-text.sh` | U-001 |
| Edit to the plan skill | `test-0000383-req-001-005-test-impact-causes.sh`, `test-0000246-req-001-test-impact-scan.sh`, `test-0000170-req-001-story-map-pass.sh`, `test-0000151-req-014-chart-clarity-and-dependency-stop.sh` | U-001 |
| Edit to the execution plan template | `test-0000201-req-001-concurrency-section.sh`, `test-0000005-pack-governance.sh` | U-001 |
| New test file | `test-0000164-req-008` style tests | U-001 |
| Backlog entry id | 0000435 | U-001 |
| Skill count (no skill added) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Non-suite file | none found | none |
| Workflow job or step edit (none) | none found | none |
| Reference file edit (none) | none found | none |
| Fixture-pinned line | none found | none |

## Branch-point reads

The plan reread these files at the tip of `origin/initiative/0000360-backlog-sweep` on 2026-11-10 (tip `79e47ef9`).

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/skills/ravintio-plan/SKILL.md` | c952df2c | U-001 |
| `src/ravintio-zero/templates/execution-plan.template.md` | c952df2c | U-001 |
| `src/ravintio-zero/tests/test-0000470-req-001-branch-point-reread.sh` | new | U-001 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | `src/ravintio-zero/skills/ravintio-plan/SKILL.md`, `src/ravintio-zero/templates/execution-plan.template.md`, `src/ravintio-zero/tests/test-0000470-req-001-branch-point-reread.sh` | 1 | One requirement across a skill, a template, and one suite | none |
| U-002 | U-001 | `docs/architecture-overview.md`, `docs/adr/0305-reread-files-at-the-branch-point.md` | 2 | Living docs unit. It records what U-001 built | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The PR base is the target branch | The reread reads a branch the PR does not target |

## Open Questions

None.
