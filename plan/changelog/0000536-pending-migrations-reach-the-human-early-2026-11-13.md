# Changelog (0000536-pending-migrations-reach-the-human-early, 13 Nov 2026)

**Feature:** Pending migrations reach the human early
**Version:** set by the merge queue at merge
**PR:** set at ship

## What changed

- The roadmap standards gain a `Chart-time migrations` section. Chart lists every pending migration and takes the human's answer as a `Migration:` row in `## Decisions`.
- The I-C Run rules gain `icrun-migration`. A step runs a migration that has a row and logs `Migration pending: {id}` for any other.
- The coordinator rules gain `coord-migration-raise`. Each report lists the logged migrations under `Decisions for the human`.
- Check 1 of the orchestrator resume detection reference gains a step-session bullet. The old line stays.
- `ravintio-migrator` takes a chart row's answer in place of the human's reply.
- The initiative skill names both rules.
- The suite `test-0000536-req-001-003` covers the text. ADR 0342 records the decision.

## Why

On 2026-11-12 at 02:26 step 55 stopped in P0 to ask about pending migration 0009. The run waited about 4.5 hours for an answer.

## Deviations

None.

## Validation results

- The new suite passes with 14 checks.
- The full suite result is in the verification report.

## Skipped phases

None.
