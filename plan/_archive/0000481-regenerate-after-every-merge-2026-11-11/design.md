# Design - 0000481-regenerate-after-every-merge

## Feature
- Problem: A clean base merge can leave `plan/backlog/index.md` stale, so CI fails and the queue stops.
- Adoption mode: standard-iterative
- Feature ID: 0000481-regenerate-after-every-merge
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the merge queue, I regenerate shared files after every base merge, so that CI does not fail on a stale file.
- Acceptance criteria confirmed: 4
- Constraints: no new allowlist entries, no change to conflict resolution
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: git calls take argument arrays, file text is data
- Data privacy: no regulated data
- Observability: the queue prints `regenerated: {path}` for each changed file
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts, bash tests, GitHub Actions CI
- Components: `ravintio-zero` pack source in `src/ravintio-zero/` and its installed copy in `ravintio-zero/`, scripts `shared-files.mjs` and `merge-queue.mjs`
- Data ownership: the pack owns the shared files named in the allowlist
- Deployment: not applicable
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/scripts/
- ravintio-zero/scripts/
- src/ravintio-zero/tests/
- ravintio-zero/tests/
- src/ravintio-zero/standards/
- ravintio-zero/standards/
- ravintio-zero/docs/
- docs/
- plan/current/
- plan/backlog/
- plan/changelog/
- plan/current-initiative/
- product.yml

## Scope
- In: `regenerateSharedFiles` in `shared-files.mjs`, its call in `merge-queue.mjs`, tests, docs, roadmap standards text
- Out: new shared files, conflict resolution changes
- Deferred: none

## Assumptions
- `backlog-index.mjs` is deterministic - impact if wrong: the queue commits a change on every run

## Risks
- The regeneration commit changes the head after the merge. Mitigation: the queue already pushes and waits on the merged head.

## Dependencies
- Upstream: `backlog-index.mjs`
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - regenerate | ravintio-implement | One script change with tests |

## Repo Instructions
Git permissions, commit granularity, subagent decomposition, ship push and PR, and standing setup approval from `ravintio-overrides/instructions/`.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 11 Nov 2026 @ 01:15 AM GMT
