# Changelog (0000573-require-unit-reports, 14 Nov 2026)

**Feature:** Require unit reports
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The dispatch standard gains the rule `dispatch-unit-report`. A unit report holds the RED line, the GREEN line, the commit hash, and any deviation.
- The orchestrator rejects a report that lacks a field and resumes the unit once.
- The suite `test-0000573-req-001` reads the rule and checks that both copies of the standard match. ADR 0344 records the decision.

## Why

One unit ended with the report "placeholder". The orchestrator could not log its RED result and reran the suite.

## Deviations

None.

## Validation results

- The new suite passes with 3 checks.
- The full suite result is in the verification report.

## Skipped phases

None.
