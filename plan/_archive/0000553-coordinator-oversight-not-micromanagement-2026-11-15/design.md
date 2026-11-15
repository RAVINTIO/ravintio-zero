# Design - 0000553-coordinator-oversight-not-micromanagement

## Feature
- Problem: The initiative skill tells the coordinator to relay every `I-C Run: activity:` line at once. The coordinator's context grows with each step tool call.
- Adoption mode: standard-iterative (source in `src/` beside `plan/_archive/`)
- Feature ID: 0000553-coordinator-oversight-not-micromanagement
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the coordinator, I relay watcher lines only at phase events, blocks, and stops, so that my context stays small.
  - US-002: As the coordinator, I read step test output only after a stop, so that I skip checks the step already runs.
- Acceptance criteria confirmed: 3
- Constraints: pack edits go in `src/ravintio-zero/` and mirror to `ravintio-zero/` and `.claude/`.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: none. The change edits skill text. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: markdown skill text, bash test suites, GitHub Actions CI, build target ci-only
- Components: `ravintio-zero` (component pack that holds the initiative skill and tests)
- Data ownership: `skills/ravintio-initiative/SKILL.md` belongs to `ravintio-zero`
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- .claude/
- docs/
- plan/

## Scope
- In: Reports section of the initiative skill. A rule to read step test output only after a stop. A new test. An update to the 0000240 pin.
- Out: the OpenTelemetry baseline. Changes to `initiative-watch.mjs`.
- Deferred: nothing deferred.

## Assumptions
- Stops print their own `Blocked:` and `Stopping:` lines, so dropping activity relay loses no stop signal - impact if wrong: the coordinator misses a stop.

## Risks
- Another suite pins the removed relay text. Likelihood low, impact low. The plan scan greps the tests.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - relay-at-events | ravintio-implement | Skill text change with a test |
| REQ-002 - test-output-after-stop | ravintio-implement | Skill text change with a test |

## Repo Instructions
Read from `ravintio-overrides/instructions/`: the pack's subagent decomposition override.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 15 Nov 2026 @ 01:19 p.m. local
