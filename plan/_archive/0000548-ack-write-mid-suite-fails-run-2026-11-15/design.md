# Design - 0000548-ack-write-mid-suite-fails-run

## Feature
- Problem: a step session runs the full suite in the background and gets a strict-mode ack prompt mid-run. The ack write changes a tracked file. Then `run-tests.sh` fails with "Tree changed during the run".
- Adoption mode: standard-iterative
- Feature ID: 0000548-ack-write-mid-suite-fails-run
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I run the full suite in the background, so that no ack prompt changes a tracked file mid-run
- Acceptance criteria confirmed: 3
- Constraints: the tree check stays strict. It never exempts `plan/.orchestrator-ack` (chart decision). Version bump minor. Track: light.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the hook still demands an ack outside a suite run. The quiet window needs a step session, a marker, and a live pid. A dead pid or a crash leaves the strict banner on. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: bash and PowerShell runners, Node.js hook (ESM), bash test suites
- Components: `ravintio-zero` (component-pack): hook `check-orchestrator-presence.mjs`, runners `run-tests.sh` and `run-tests.ps1`
- Data ownership: `ravintio-zero` owns the new git-ignored marker `plan/.suite-running`
- Deployment: pack files copy to `ravintio-zero/` and `.claude/hooks/` through setup
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/
- .gitignore

## Scope
- In: a marker from both runners, a quiet hook while the marker names a live pid, a test, docs, and an ADR
- Out: any tree-check exemption for the ack file, the coordinator banner, advisory mode
- Deferred: nothing deferred

## Assumptions
- The runner and the hook share one repo root. Impact if wrong: the prompt still arrives mid-run and the run fails as before
- The ack prompt arrives only in the claude process, which sets `RAVINTIO_INITIATIVE_STEP=1` - impact if wrong: a non-step session still sees the banner

## Risks
- A stale marker with a recycled pid keeps the hook quiet. Likelihood low, impact low. The marker needs a step session, and P0 wrote an ack
- A crashed runner leaves the marker - likelihood low, impact low, because the hook checks the pid

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - marker and quiet hook | ravintio-implement | One TDD unit across the hook and both runners |

## Repo Instructions
Four files in `ravintio-overrides/instructions/`. They cover local git only, subagent decomposition, ship pushing the PR, and the setup refresh approval.

## Confirmation
Human confirmed this design before proceeding: no // Date and Time confirmed: n/a. [source: draft-accepted (initiative)]
