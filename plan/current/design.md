# Design - 0000474-coordinator-shell-guidance

## Feature
- Problem: Shell snags cost the coordinator time from 2026-11-08 to 2026-11-10, and the advice never reached a standard.
- Adoption mode: standard-iterative
- Feature ID: 0000474-coordinator-shell-guidance
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the coordinator, I read one section on shell use, so that zsh and guard snags stop costing time.
  - US-002: As the coordinator, I run scripts for repeated tasks, so that I never improvise a compound command.
- Acceptance criteria confirmed: 4
- Constraints: no change that lets `merge-guard` or `block-forced-add` allow variables, compound commands, or quoting
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: git calls take argument arrays, file text is data, guards stay as they are
- Data privacy: no regulated data
- Observability: scripts print one line per action
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts, bash tests, GitHub Actions CI
- Components: `ravintio-zero` pack source in `src/ravintio-zero/` and its installed copy in `ravintio-zero/`
- Data ownership: the pack owns the initiative skill, the roadmap standards, and the coordinator scripts
- Deployment: not applicable
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/scripts/
- ravintio-zero/scripts/
- src/ravintio-zero/tests/
- ravintio-zero/tests/
- src/ravintio-zero/standards/
- ravintio-zero/standards/
- src/ravintio-zero/skills/ravintio-initiative/
- ravintio-zero/skills/ravintio-initiative/
- .claude/skills/ravintio-initiative/
- src/ravintio-zero/docs/
- ravintio-zero/docs/
- src/ravintio-zero/component.yml
- ravintio-zero/component.yml
- docs/
- plan/current/
- plan/backlog/
- plan/changelog/
- plan/current-initiative/
- product.yml

## Scope
- In: coordinator shell section in the roadmap standards, skill pointer, drain, overlap, and bulk-edit scripts, tests, docs
- Out: any change to `merge-guard` or `block-forced-add`
- Deferred: none

## Assumptions
- `coordinator-pr-check.mjs` covers the overlap check - impact if wrong: the change adds a new script

## Risks
- The initiative skill passes its size cap. Likelihood: medium. Impact: low. Mitigation: put the text in the roadmap standards and add a short pointer to the skill.

## Dependencies
- Upstream: `initiative-queue.mjs`, `coordinator-pr-check.mjs`
- Downstream: step 47
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - coordinator shell section | ravintio-implement | Standards text and a skill pointer |
| REQ-002 - coordinator task scripts | ravintio-implement | Small scripts with tests |

## Repo Instructions
Git permissions, commit granularity, subagent decomposition, ship push and PR, and standing setup approval from `ravintio-overrides/instructions/`.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 11 Nov 2026 @ 06:57 AM GMT
