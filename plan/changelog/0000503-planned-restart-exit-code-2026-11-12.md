# Changelog (0000503-planned-restart-exit-code, 12 Nov 2026)

**Feature:** Planned restart exits with its own code
**Version:** set by the merge queue at merge
**PR:** pending, updated at Step 9

## What changed

- The driver exits 75 after a stop line that starts `I-D Advance: Restart:`. That includes the combined `Restart: Setup:` line.
- Every other stop exits 1. A failure that stops the run after a restart hit also exits 1.
- `roadmap-standards.md` and the initiative skill name exit 75 as a planned stop.
- ADR-0327 records the decision.
- Five older suites now expect exit 75 for a restart line.

## Why

The host reported the background task as failed after a planned restart. A distinct code lets the host and the coordinator tell the two apart.

## Deviations

None.

## Validation results

- The new suite passes 23 of 23 in both pack trees.
- The full suite passes apart from three inherited failures.
- Security review found no critical, high, or medium findings.

## Skipped phases

None
