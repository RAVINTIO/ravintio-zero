# Design - 0000452-ci-wait-before-archive

## Feature
- Problem: Ship archives `plan/current/` before it raises the PR. After that `gate-write` rejects code edits, so a step cannot fix its own failing CI. A step can also write `ready` without watching CI.
- Adoption mode: standard-iterative (assumed, only signal)
- Feature ID: 0000452-ci-wait-before-archive
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I archive my run after my PR checks pass, so that I can still push a CI fix
  - US-002: As the merge queue, I receive `ready` only for a PR head whose checks all passed, so that I never merge an unchecked PR
- Acceptance criteria confirmed: 4 (the brief's list)
- Constraints: no guard gains a new allowed form. `gate-write` and `merge-guard` stay unchanged. A normal run outside an initiative keeps its order.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No guard widens. Data classification: public repo content.
- Data privacy: no regulated data
- Observability: standard defaults. The build log records the CI waits.
- Cost boundary: not constrained. The closing archive push triggers one more CI run.

## Engineering Layer
- Stack: Markdown skill and standards text, Bash tests
- Components: `ravintio-zero` (the pack). Edits to the `ravintio-ship` skill and `roadmap-standards.md`, and to two tests that pin the old order.
- Data ownership: `ravintio-zero` owns the ship sequence text
- Deployment: pack source in `src/ravintio-zero/`, copied to `ravintio-zero/` by `sync-installed.mjs`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: reorder the initiative-step ship sequence, add the green-checks rule for `ready`, add tests
- Out: a reopen route, any `gate-write` change, driver and queue changes, a normal run outside an initiative
- Deferred: nothing deferred

## Assumptions
- The squash carries the net branch diff - impact if wrong: sentinels committed early reach the initiative branch.
- A plan-only archive push needs no code edit - impact if wrong: a failing check on the archive head stops the step with `Blocked:`.

## Risks
- The closing push adds one CI run per step. Likelihood high, impact low.
- Wording pins in other tests break on the new order. Likelihood medium, impact low.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 and REQ-002 | ravintio-implement | Each is a TDD unit on pack text |

## Repo Instructions
Read from `ravintio-overrides/instructions/`.
- Local git only, except the allowed pushes and PRs.
- Prefer subagent decomposition.
- Ship pushes and raises the PR and never merges.
- Standing approval for `ravintio-zero/setup.sh claude-code --strict-orchestrator`.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 10 Nov 2026 @ 01:35 PM GMT
