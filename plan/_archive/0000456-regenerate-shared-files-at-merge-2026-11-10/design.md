# Design - 0000456-regenerate-shared-files-at-merge

## Feature
- Problem: Shared files conflict on every step merge and the queue stops on each one.
- Adoption mode: standard-iterative (signal: plan/_archive beside src/)
- Feature ID: 0000456-regenerate-shared-files-at-merge
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the coordinator, I want the queue to resolve conflicts on shared files, so that a step PR does not stop on them.
  - US-002: As the coordinator, I want the overlap check to name open step PRs on the same files, so that I land admin safely.
- Acceptance criteria confirmed: 5
- Constraints: no history rewrite, edit src then sync
- Integrations: gh CLI, git

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Git and gh calls take argument arrays. Entry text is data. Resolver paths come from a fixed allowlist.
- Data privacy: no regulated data
- Observability: the queue prints one line per resolved file
- Cost boundary: not constrained

## Engineering Layer
- Stack: JavaScript, Node, Bash tests, GitHub Actions CI, build target local
- Components: ravintio-zero (pack scripts, docs, tests)
- Data ownership: ravintio-zero owns the repo files it edits
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: shared-files.mjs resolver, queue hook-in, overlap check, docs, tests
- Out: generator for architecture-overview prose, any other conflict
- Deferred: nothing deferred

## Assumptions
- Conflicts on the listed files are mechanical - impact if wrong: a wrong resolution merges silently, so the resolver stops on any hunk it cannot read

## Risks
- A union of table rows duplicates a row (likelihood low, impact low). The resolver drops exact duplicate lines.
- A real prose edit conflicts in architecture-overview.md (likelihood medium, impact medium). The resolver stops and names the file.

## Dependencies
- Upstream: merge-queue.mjs, backlog-index.mjs
- Downstream: initiative driver, coordinator
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| All | ravintio-implement | Scripts with tests and docs |

## Repo Instructions
Git permissions, commit granularly, subagent decomposition, ship push and raise the PR, standing setup refresh approval. See `ravintio-overrides/instructions/`.

## Confirmation
Human confirmed this design before proceeding: yes // draft-accepted (initiative) // 10 Nov 2026 @ 04:31 p.m. GMT
