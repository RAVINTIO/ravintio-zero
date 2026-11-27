---
title: "Discovery - 0000580-log-non-tdd-units"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000580-log-non-tdd-units

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds source |
| Git pre-flight | `feat/0000580-log-non-tdd-units`, cut by the driver from the initiative branch. No human confirmation in an initiative step. |
| Skills inbox | empty (no `ravintio-zero/skills-inbox/` folder) |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.150.0`
- Prior features (`plan/_archive/`): latest are 0000578-plan-lists-pass-signals, 0000579-convert-remaining-suites-to-rule-anchors, 0000583-step-temp-cleanup-after-merge (all 2026-11-26)
- Constraining ADRs (unless superseded): 0000386 unit class, tier, and effort. 0000575 ADR-0348 build-log-mark script.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. It owns every file in `src/ravintio-zero/` and its mirror `ravintio-zero/`.

## Step findings

- Backlog entry: 0000410, "Log a non-TDD unit with a class". Problem: a living-docs unit has no test, so it cannot log tier `inline`. The metrics report counts older `Done:` lines as `unclassified`.
- Chart decision (guard cut-back): every unit still logs `RED:` and `GREEN:`. The step records the class next to the markers and relaxes no check.
- Chart decision (docs unit): log a `RED:` and a `GREEN:` line at the real time. Each says the unit has no executable check and names 0000410. The `GREEN:` line names the check that passed.
- Files read: `ravintio-zero/scripts/build-log-check.mjs` (check 7), `ravintio-zero/scripts/build-log-mark.mjs`, `ravintio-zero/scripts/workflow-metrics.mjs` (`CLASSIFIED_DONE`), `ravintio-zero/standards/agent-dispatch-standards.md` (`dispatch-unit-classes`, `dispatch-done-line`), `ravintio-zero/tests/test-0000386-req-002-unit-class-tier-effort.sh`.
- Queue: no item names step 36.
- Baseline: the clean-clone full suite started at 2026-11-26T10:01:50Z. P3 compares against its result.
