# Execution Plan - steps read their queue items

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000444-step-reads-its-queue-items
**Version:** 0.87.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-queue-helper.md](requirements/req-001-queue-helper.md) | `initiative-queue.mjs` lists named items and checks them |
| [req-002-driver-prompt.md](requirements/req-002-driver-prompt.md) | Driver start and continue prompts name the items |
| [req-003-ship-check.md](requirements/req-003-ship-check.md) | Standards and pickup text call the helper |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | The driver prints no item content | 0 content bytes in the prompt | A suite with a hostile item name and body |
| NFR-002 | Maintainability | The skill-text total stays within its cap | 1720 lines or fewer | `test-0000384-skill-text.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data. The coordinator owns the queue items.

## Component Interactions

The driver imports `namedItems` from `initiative-queue.mjs` and adds the folder names to the prompt. The step runs `list` and `check` from the same file. `sync-installed.mjs` copies `src/ravintio-zero/` to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id (0000425) | none found | none |
| Edit to `initiative-run.mjs` | `test-0000240-req-001-driver-stream-args.sh`, `test-0000354-req-001-driver-resume.sh`, `test-0000205-req-001-driver-fixes.sh`, `test-0000389-req-006-briefs.sh`, `test-0000151-req-006-roadmap-step-model-and-turn-cap.sh` | U-001 |
| Edit to `roadmap-standards.md` (rule `icrun-queue`) | `test-0000352-req-002-004-standards-rules.sh`, `test-0000318-req-001-002-coordinator-prs.sh`, `test-0000205-req-004-initiative-skill.sh`, `test-0000468-req-002-read-the-clock-rule.sh`, `test-0000452-req-001-archive-after-ci.sh` | U-002 |
| Reference file edit (`orchestrator-p0-start-actions.md`) | `test-0000321-req-004-pickup-text.sh`, `test-0000151-req-011-orchestrator-references-split.sh`, `test-0000352-req-003-005-skill-rules.sh` | U-002 |
| New test file | `test-0000164-req-008` style tests | U-001 |
| Skill-text budget (no `SKILL.md` edit) | none found | none |
| Skill count, size cap, workflow edit, non-suite file | none found | none |
| Fixture-pinned line | none found | none |

## Branch-point reads

The plan read these files at the tip of `origin/initiative/0000360-backlog-sweep` (`f7573cde`) on 2026-11-10.

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/scripts/initiative-run.mjs` | 99c72a24 | U-001 |
| `src/ravintio-zero/scripts/initiative-queue.mjs` | new | U-001 |
| `src/ravintio-zero/tests/test-0000444-req-001-003-queue-items.sh` | new | U-001 |
| `src/ravintio-zero/standards/roadmap-standards.md` | ae9dfaee | U-002 |
| `src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md` | c952df2c | U-002 |
| `docs/architecture-overview.md` | b75d165f | U-003 |
| `docs/adr/0307-steps-read-their-queue-items.md` | new | U-003 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | `src/ravintio-zero/scripts/initiative-queue.mjs`, `src/ravintio-zero/scripts/initiative-run.mjs`, `src/ravintio-zero/tests/test-0000444-req-001-003-queue-items.sh` | 1 | The driver imports the helper, so one unit writes both | none |
| U-002 | U-001 | `src/ravintio-zero/standards/roadmap-standards.md`, `src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md` | 2 | The text names the helper that U-001 builds | none |
| U-003 | U-002 | `docs/architecture-overview.md`, `docs/adr/0307-steps-read-their-queue-items.md` | 3 | Living docs unit. It records what U-001 and U-002 built | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Every item holds a step line and a destination line | The helper skips the item and warns |

## Open Questions

None.
