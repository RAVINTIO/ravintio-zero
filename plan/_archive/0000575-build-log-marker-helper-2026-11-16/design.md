# Design - 0000575-build-log-marker-helper

## Feature
- Problem: A step session types RED, GREEN, and Done times by hand, so they are approximate.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000575-build-log-marker-helper
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I append a marker line with one command, so that its time comes from a clock read.
  - US-002: As the implement skill, I name the script for each RED, GREEN, and Done line, so that sessions use it.
- Acceptance criteria confirmed: 4
- Constraints: Node only, no new dependency. Every time comes from a clock read.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the script writes only `plan/current/build-log.md` and refuses a symlink at that path
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node script, bash test
- Components: `ravintio-zero` pack, with the new script `build-log-mark.mjs`
- Data ownership: the build log belongs to the orchestrator and the script appends to it
- Deployment: pack files in `src/ravintio-zero/`, mirrored to `ravintio-zero/`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- plan/

## Scope
- In: `build-log-mark.mjs`, its test, and the implement skill and standards text that name it
- Out: other marker kinds, changes to `build-log-check.mjs`
- Deferred: none

## Assumptions
- Marker forms stay as `workflow-governance-standards.md` and `agent-dispatch-standards.md` state them - impact if wrong: the script writes lines the checks reject.

## Risks
- A suite pins the implement skill text (likelihood medium, impact low). P1 runs the test impact scan.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - marker script | ravintio-implement | Script with a test |
| REQ-002 - skill wiring | ravintio-implement | Text change with a pin test |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 16 Nov 2026 @ 00:32 AM local
