# Design - 0000576-phase-start-time-at-phase-start

## Feature
- Problem: A run can write a phase block at phase end, so `Start` and `End` differ by seconds and the report shows `not recorded`.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000576-phase-start-time-at-phase-start
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the ship phase, I fail a phase block whose `Start` follows its first artifact commit, so that a late block write fails ship.
  - US-002: As the orchestrator, I name the check in the Phase Invocation reference, so that sessions know to write the block first.
- Acceptance criteria confirmed: 4
- Constraints: Node only, no new dependency. Check 10 compares commit times with a one-minute margin, as check 6 does.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the check reads the log and runs read-only `git` commands with no shell
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node script, bash test
- Components: `ravintio-zero` pack, with a new check 10 in `build-log-check.mjs`
- Data ownership: the build log belongs to the orchestrator and the check only reads it
- Deployment: pack files in `src/ravintio-zero/`, mirrored to `ravintio-zero/`
- API versioning: not applicable
- Method: the first artifact commit of a phase is the oldest commit after the commit that added the build log. It touches that phase's artifact paths, listed in `build-log-check.mjs`. P2 uses any path outside `plan/`.

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- plan/

## Scope
- In: check 10 in `build-log-check.mjs`, its test, and the Phase Invocation reference line
- Out: checks 1 to 9, a phase-block writer script
- Deferred: none

## Assumptions
- Each phase writes its artifacts under the paths the check lists - impact if wrong: the check skips that phase and passes.

## Risks
- A suite pins the Phase Invocation reference or the check count (likelihood medium, impact low). P1 runs the test impact scan.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - start-time check | ravintio-implement | Script with a test |
| REQ-002 - reference wiring | ravintio-implement | Text change with a pin test |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 16 Nov 2026 @ 07:05 AM local
