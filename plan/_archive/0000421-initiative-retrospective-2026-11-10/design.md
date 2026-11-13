# Design - 0000421-initiative-retrospective

## Feature
- Problem: The human cannot see which causes of the 27 stops and mistakes in initiative 0000360 remain unfixed.
- Adoption mode: standard-iterative (signal: `plan/_archive/` beside source)
- Feature ID: 0000421-initiative-retrospective
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a human on the loop, I read one record of every stop, so that I know each cause and what remains open.
  - US-002: As a coordinator, I get one backlog entry per unaddressed finding, so that I can chart the fixes as steps 23 onward.
- Acceptance criteria confirmed: 4
- Constraints: Blameless wording. No fixes in this step. Never move step logs.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Data classification: internal repo text. Scan the record for credentials before commit.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: markdown records, Node scripts already in the pack (`reserve-id.mjs`, `backlog-index.mjs`), no new code
- Components: pack documentation only
- Data ownership: retrospective records belong to `plan/retrospectives/`. Backlog entries belong to `plan/backlog/`.
- Deployment: none
- API versioning: not applicable

## Component Paths
- plan/retrospectives/
- plan/backlog/
- plan/current/

## Scope
- In: retrospective record, backlog entries, backlog index
- Out: any fix
- Deferred: each fix, as steps 23 onward

## Assumptions
- The step logs in the main root stay readable - impact if wrong: a row gets the verdict "unaddressed, evidence unreadable".

## Risks
- A verdict of "addressed" without evidence - likelihood medium, impact high. Mitigation: each such verdict cites a PR or feature id that the step checked.
- A finding that widens a guard slips through unmarked - likelihood low, impact high. Mitigation: a guard review pass in P3.

## Dependencies
- Upstream: `coordinator-evidence.md`, postmortems, archived build logs
- Downstream: the coordinator charts steps 23 onward
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - record | ravintio-retrospective | Writes the blameless record |

## Repo Instructions
custom-001 (git permissions, granular commits), custom-002 (prefer subagent decomposition), custom-004 (push and raise the PR, never merge to main), custom-006 (standing setup refresh approval).

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 10 Nov 2026 @ 02:40 AM UTC
