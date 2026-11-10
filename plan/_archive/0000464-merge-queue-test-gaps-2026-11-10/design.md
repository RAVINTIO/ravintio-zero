# Design - 0000464-merge-queue-test-gaps

## Feature
- Problem: two branches of `merge-queue.mjs` `run` have no test, and branch names from `gh` reach `git` unchecked.
- Adoption mode: standard-iterative
- Feature ID: 0000464-merge-queue-test-gaps
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I run the queue twice on one PR, so that I know the second run adds no commit and still merges.
  - US-002: As a maintainer, I stub a version file that stays different, so that I know `run` exits 1 before the merge.
  - US-003: As a maintainer, I want a branch name that starts with a dash refused, so that it never reaches `git` as an option.
- Acceptance criteria confirmed: 3
- Constraints: the queue flow and its output stay as they are.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: `run` refuses a leading-dash ref name from `gh` before any `git` call. No new credentials.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node script, bash tests
- Components: `ravintio-zero` holds the script and its tests.
- Data ownership: the queue owns the chart merge rows. No data changes.
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: a rerun fixture, a version-mismatch fixture, and a leading-dash check on head and base names.
- Out: any other change to the queue flow.
- Deferred: none

## Assumptions
- Git refuses a ref name that starts with a dash - impact if wrong: the dash check is the only guard.
- The fake `gh` of test 0000456 extends to both fixtures - impact if wrong: the step writes a new shim.

## Risks
- The dash check changes an error path - likelihood low, impact low.

## Dependencies
- Upstream: steps 31 and 35, both merged.
- Downstream: step 37.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - rerun | ravintio-test-writer | Test first, then the code |
| REQ-002 - version mismatch | ravintio-test-writer | Test first, then the code |
| REQ-003 - dash guard | ravintio-implementer | Small code change after its test |

## Repo Instructions
Git permissions: work on the feat branch and push as you commit. Never commit or merge to main. Ship pushes and raises the PR. A step may squash its PR into the initiative branch after clean P3 and green CI.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 10 Nov 2026 @ 07:08 p.m. GMT
