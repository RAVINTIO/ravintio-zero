# Design - 0000580-log-non-tdd-units

## Feature
- Problem: A unit with no executable check has no valid `Done:` form, so the metrics report counts it as `unclassified`.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000580-log-non-tdd-units
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a pipeline agent, I log a unit with no executable check as class `docs`, so that its `Done:` line is valid.
  - US-002: As a pipeline agent, I append `RED:` and `GREEN:` lines with the class, so that the log shows the unit has no failing test.
  - US-003: As a reviewer, I run `build-log-check.mjs` on a log with a `docs` unit, so that it passes with both markers and fails without them.
  - US-004: As a reviewer, I read the metrics report, so that I see `docs` units in their own row.
- Acceptance criteria confirmed: 4
- Constraints: every unit still logs `RED:` and `GREEN:`. No check in `build-log-check.mjs` relaxes. The chart decision for 0000410 sets both.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The scripts read and write only the build log and refuse a symlinked log, as before. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts, bash tests, GitHub Actions CI, build target local
- Components: `ravintio-zero`, the component pack. It holds the standards, scripts, templates, and tests.
- Data ownership: `ravintio-zero` owns the build log line format.
- Deployment: none. The pack ships with the repo.
- API versioning: not applicable

## Design decisions
- D-1: Add class `docs` to `dispatch-unit-classes`. A `docs` unit changes living documents and has no executable check. Its tier row matches `content`.
- D-2: `build-log-mark.mjs` takes an optional `--class` for `RED` and `GREEN`. The line becomes `- RED: {unit} ({class}, {time})`. Without the flag the line keeps its old form.
- D-3: Check 7 of `build-log-check.mjs` requires both markers for a `Done:` line whose tier is `inline` or whose class is `docs`. No check relaxes.
- D-4: `workflow-metrics.mjs` accepts `docs` in `CLASSIFIED_DONE`. The report prints `docs` as its own row.
- D-5: A pin that names four classes changes to five in the same step (`Rework:` logged).

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- src/ravintio-zero/
- ravintio-zero/
- plan/
- docs/

## Scope
- In: the `docs` class in the standards, `--class` on the marker script, check 7, the metrics row, the build-log template comment, and tests.
- Out: any relaxation of a check, a new tier value, a rewrite of archived logs.
- Deferred: nothing deferred.

## Assumptions
- The `docs` tier row matches `content` - impact if wrong: a docs unit gets the wrong model tier.
- A `docs` `Done:` line with markers is rare - impact if wrong: none, the check only adds a rule for the new class.

## Risks
- A test pins the text "four classes". Likelihood medium, impact low. The step updates the pin.
- The pack trees drift. Likelihood low, impact medium. The step mirrors every edit and diffs the trees.

## Dependencies
- Upstream: 0000386 (class, tier, effort), 0000575 (`build-log-mark.mjs`)
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - docs class in standards | ravintio-implement | Prose edit with a prose-check test |
| REQ-002 - class on markers | ravintio-implement | Script change with a test |
| REQ-003 - check 7 accepts docs | ravintio-implement | Script change with a test |
| REQ-004 - metrics docs row | ravintio-implement | Script change with a test |

## Repo Instructions
- custom-001: local git only
- custom-002: prefer subagent decomposition
- custom-004: ship pushes and raises the PR
- custom-006: standing setup refresh approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 26 Nov 2026 @ 10:03 AM local
