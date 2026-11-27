# Design - 0000552-duplicate-backlog-ids

## Feature
- Problem: No check reports two backlog entry folders that share an id, so a duplicate stays in the backlog until a human sees it.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000552-duplicate-backlog-ids
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a coordinator, I want `backlog-index.mjs --check` to exit 1 when two entry folders share an id, so that CI fails on the next duplicate.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. The generate mode must keep writing the index, because the merge queue runs it before `renumberCollisions`.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no new input. The script reads folder names only and prints ids.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node and bash. Tests in bash. CI on GitHub Actions. Build target ci-only.
- Components: `ravintio-zero`, the component pack. It holds the index script and its tests.
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- src/ravintio-zero/
- ravintio-zero/
- plan/
- docs/

## Scope
- In: a duplicate-id check in `--check` mode, one new suite, docs and manifest updates.
- Out: a check in generate or `--review` mode. Renumbering.
- Deferred: none.

## Assumptions
- The merge queue runs `resolveSharedConflicts` (generate mode) before `renumberCollisions`. Impact if wrong: a failing generate mode would not block the renumber, so the check could widen.

## Risks
- A failing generate mode would stop the merge queue before it renumbers (likelihood: high if built in, impact: high). The design avoids it by checking only in `--check`.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Duplicate id check | ravintio-implement | One script edit and one suite |

## Repo Instructions
- custom-001-local-git-only
- custom-002-prefer-subagent-decomposition
- custom-004-ship-push-and-raise-pr
- custom-006-standing-setup-refresh-approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 16 Nov 2026 @ 4:03 a.m. GMT
