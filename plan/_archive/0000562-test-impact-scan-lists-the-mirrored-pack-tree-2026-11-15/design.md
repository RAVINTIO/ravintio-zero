# Design - 0000562-test-impact-scan-lists-the-mirrored-pack-tree

## Feature
- Problem: The Test impact scan has no cause for the mirrored pack tree. A pack file edit misses `src/ravintio-zero/` until the full suite fails.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000562-test-impact-scan-lists-the-mirrored-pack-tree
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I read the Test impact scan causes from a reference file, so that the plan skill stays small.
  - US-002: As a plan author, I see a `Pack file edit` cause that lists `test-0000493-req-004-handoff-text.sh`, so that I plan the mirrored edit in the same unit.
  - US-003: As a P0 author, I list `src/ravintio-zero/` in `## Component Paths` when the run edits a pack file, so that gate-write allows the mirrored edit.
- Acceptance criteria confirmed: 4
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/` with `scripts/sync-installed.mjs`. Version 0.114.0 plus a minor bump.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no new input. Text and tests only. No data.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: markdown and bash. Tests in bash. CI on GitHub Actions. Build target ci-only.
- Components: `ravintio-zero`, the component pack. It holds the plan skill, the orchestrator skill, and the tests.
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- src/ravintio-zero/
- ravintio-zero/
- plan/
- docs/

## Scope
- In: reference file for the scan causes, a `Pack file edit` cause, a P0 rule for `## Component Paths`, updated pins, one new suite, docs and manifest updates.
- Out: causes that steps 19 to 27 add. Hook and script changes.
- Deferred: nothing deferred.

## Assumptions
- `sync-installed.mjs` copies a new reference file to `ravintio-zero/` - impact if wrong: the parity check fails and the step adds the file to the sync list.

## Risks
- A suite pins text that moves (likelihood: high, impact: low). The step updates the pin and logs a `Rework:` line.

## Dependencies
- Upstream: none
- Downstream: steps 19 to 27 add causes to the new reference file.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - move causes | ravintio-implement | Text move with pin updates |
| REQ-002 - pack file edit cause | ravintio-implement | One cause and one suite |
| REQ-003 - component paths rule | ravintio-implement | One P0 rule line |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 14 Nov 2026 @ 03:11 PM
