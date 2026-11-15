# Design - 0000549-baseline-record-checks

## Feature
- Problem: `baseline-failures.mjs record` accepts runner output that ends early and records no failures. `check` treats a missing baseline file as an empty baseline. Both make P3 flag inherited failures as new.
- Adoption mode: standard-iterative (source in `src/` beside `plan/_archive/`)
- Feature ID: 0000549-baseline-record-checks
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step agent, I run `record` on runner output, so that output with no `Feature suites:` line exits 2 and writes no file.
  - US-002: As a step agent, I run `check`, so that a missing baseline file exits 1 with `no baseline recorded`.
- Acceptance criteria confirmed: 3
- Constraints: pack edits go in `src/ravintio-zero/` and mirror to `ravintio-zero/`.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: none. The script reads a local file and writes one file. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ESM script, bash test suites, GitHub Actions CI, build target ci-only
- Components: `ravintio-zero` (component pack that holds the script and tests)
- Data ownership: `plan/current/baseline-failures.md` belongs to `ravintio-zero`
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: `record` refuses input with no `Feature suites:` line. `check` refuses a missing baseline file. Tests for both. Update the 0000385 pin for the missing file.
- Out: making `clean-clone-test.mjs` or P0 run `record`. Changing how `check` reads runner output.
- Deferred: nothing deferred.

## Assumptions
- Every finished `run-tests.sh` run prints a `Feature suites:` line - impact if wrong: `record` would refuse good output.

## Risks
- A runner output format change drops the `Feature suites:` line. Likelihood low, impact medium. The test fixtures pin the line.

## Dependencies
- Upstream: none
- Downstream: P3 and ship read `baseline-failures.md`
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - record-needs-totals | ravintio-implement | Script change with a test |
| REQ-002 - check-needs-baseline | ravintio-implement | Script change with a test |

## Repo Instructions
Read from `ravintio-overrides/instructions/` if present: none beyond the pack's subagent decomposition override.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 14 Nov 2026 @ 03:24 PM local
