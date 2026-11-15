# Design - 0000554-coordinator-starts-defined-stages

## Feature
- Problem: The coordinator asks "Go?" before a stage the pipeline already defines as next, such as I-E Delivery after the last merge.
- Adoption mode: standard-iterative (signal: source in `src/` beside an archive)
- Feature ID: 0000554-coordinator-starts-defined-stages
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the human on the loop, I read a status when the coordinator starts a defined stage. I then answer no question whose answer is always yes.
  - US-002: As the human on the loop, I read `action for the human: none, the coordinator runs I-E Delivery` after a clean end, so that the summary does not name delivery as my action.
- Acceptance criteria confirmed: 4
- Constraints: Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`. The initiative skill stays under 120 lines.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: none, prose and one output string. Data classification: public. No guard widens.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: bash tests, Node script, markdown standards, no new libraries. Build target: local.
- Components: `ravintio-zero`, the pack that holds the standards, the initiative skill, and the driver.
- Data ownership: `ravintio-zero` owns `roadmap-standards.md`, the initiative skill, and `initiative-run.mjs`.
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/
- product.yml

## Scope
- In: rule `coord-defined-stage`, the skill line, the clean-end action text, the pin update, and a test of the rule.
- Out: the human-only actions, and the `Restart:`, `Setup:`, and other stop actions.
- Deferred: nothing deferred.

## Assumptions
- Only `test-0000511-req-001-003-stop-summary.sh` pins the old action text - impact if wrong: another suite fails and the step updates its pin.

## Risks
- The skill reaches 120 lines and fails its length test. Likelihood medium, impact low. The edit joins text to existing lines.
- The driver change triggers a Restart stop after merge. Likelihood certain, impact low. The coordinator starts a new driver.

## Dependencies
- Upstream: none
- Downstream: the coordinator session reads the standards and the skill. The driver prints the action line.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - defined-stage rule and skill line | ravintio-implement | Two prose edits with one test |
| REQ-002 - clean-end action text | ravintio-implement | One string, one comment, and one pin |

## Repo Instructions
- Git permissions: work on a `feat/` branch, push as you commit, never commit or merge to `main`.
- Commit granularly: commit after each artifact.
- Subagent decomposition: split independent units, or state why not.
- Ship: push and raise the PR, never merge into `main`. The merge queue merges a step PR.
- Setup refresh: run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 07:12 p.m. GMT
