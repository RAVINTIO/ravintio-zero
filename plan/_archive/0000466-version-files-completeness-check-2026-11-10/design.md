# Design - 0000466-version-files-completeness-check

## Feature
- Problem: no check ties `ravintio-zero/version-files.txt` to the files that carry the product version, so a layout move can leave the list stale.
- Adoption mode: standard-iterative
- Feature ID: 0000466-version-files-completeness-check
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I run the suite, so that it fails when the version list omits a file that carries the product version.
- Acceptance criteria confirmed: 3
- Constraints: `version-files.mjs`, the queue, and the list format stay as they are.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the test reads tracked files only. No new credentials.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: bash test with a Node helper call, same as tests 0000378 and 0000420
- Components: `ravintio-zero` holds the test.
- Data ownership: no data changes.
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: one test in `ravintio-zero/tests/` that scans tracked files for a pack version and compares them with the list.
- Out: any change to `version-files.mjs`, the queue, or the list itself, unless the test finds a real omission.
- Deferred: none

## Assumptions
- A file carries the pack version if it is `docs/about.md`, `product.yml`, or a pack `component.yml`. Impact if wrong: the scan misses a file shape.
- Git is available in the test environment - impact if wrong: the test cannot list tracked files.

## Risks
- A scan that is too broad flags files with unrelated `version:` lines - likelihood medium, impact low. The scan keys on file name and the product version.

## Dependencies
- Upstream: step 36, merged.
- Downstream: none.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - completeness test | ravintio-test-writer | The deliverable is a test |

## Repo Instructions
Git permissions: work on the feat branch and push as you commit. Never commit or merge to main. Ship pushes and raises the PR. A step may squash its PR into the initiative branch after clean P3 and green CI. Prefer subagent decomposition when units are independent. Commit each artifact at once.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 10 Nov 2026 @ 09:48 p.m. GMT
