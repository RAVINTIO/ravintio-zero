# Design - 0000505-coordinator-branch-regenerate

## Feature
- Problem: Coordinator branches have no command that resolves generated files after a merge of the initiative branch.
- Adoption mode: standard-iterative
- Feature ID: 0000505-coordinator-branch-regenerate
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the coordinator, I run one command to merge the initiative branch into my branch. It regenerates the shared files, so no stale index or counter remains.
- Acceptance criteria confirmed: 4
- Constraints: no new allowlist entries, no change to the merge queue
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: git calls take argument arrays, file text is data, no push
- Data privacy: no regulated data
- Observability: the command prints `resolved:` and `regenerated:` lines, as the queue does
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts, bash tests, GitHub Actions CI
- Components: `ravintio-zero` pack source in `src/ravintio-zero/` and its installed copy in `ravintio-zero/`, new script `coordinator-merge.mjs`, existing `shared-files.mjs`
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
- src/ravintio-zero/docs/
- ravintio-zero/docs/
- docs/
- plan/current/
- plan/backlog/
- plan/changelog/
- plan/current-initiative/
- product.yml

## Scope
- In: `coordinator-merge.mjs`, tests, docs, roadmap standards text
- Out: new shared files, merge queue changes
- Deferred: none

## Assumptions
- `shared-files.mjs` exports cover the resolve and regenerate steps - impact if wrong: the command needs new helpers

## Risks
- A merge conflict on a file outside the allowlist. Likelihood: medium. Impact: low. Mitigation: the command aborts the merge and exits 1, leaving the branch as it was.

## Dependencies
- Upstream: `shared-files.mjs`, `backlog-index.mjs`
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - coordinator merge command | ravintio-implement | One new script with tests |

## Repo Instructions
Git permissions, commit granularity, subagent decomposition, ship push and PR, and standing setup approval from `ravintio-overrides/instructions/`.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 11 Nov 2026 @ 04:10 AM GMT
