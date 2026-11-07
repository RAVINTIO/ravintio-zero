# Design - 0000377-driver-stops-and-headroom

## Feature
- Problem: The driver resumes a step that ends on `Question:`, skips the `Setup:` stop after the last step, and the orchestrator skill has 118 bytes of headroom.
- Adoption mode: standard-iterative
- Feature ID: 0000377-driver-stops-and-headroom
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I move Context Hygiene out of the orchestrator `SKILL.md`, so that later steps can add rules under the 9000 byte cap.
  - US-002: As the human on the loop, I see the driver stop at once on an unresolved `Question:` line, so that no step guesses an answer only I can give.
  - US-003: As the human on the loop, I see a `Setup:` stop before `I-E Delivery: Pending:`, so that delivery runs on current installed skills.
- Acceptance criteria confirmed: 6
- Constraints: Cap tests keep 9000 bytes. Context Hygiene moves before the `Question:` edit.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth. The driver still reads repo text as data and prints it cut to 500 characters. No data classification beyond public repo text.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM scripts, Bash and PowerShell tests, GitHub Actions
- Components: `ravintio-zero` pack (skills, scripts, standards, tests)
- Data ownership: none
- Deployment: pack copied by `setup.sh`
- API versioning: not applicable

## Scope
- In: Context Hygiene move, Question stop in driver and watcher, continue prompt, Setup check after the last step, docs and tests
- Out: all other steps of initiative 0000360
- Deferred: nothing deferred

## Assumptions
- A `Question:` line in the build log is the stop signal - impact if wrong: the driver misses a question.

## Risks
- Moving the section breaks tests that read it. Likelihood medium, impact low. Update the cap tests and base fixture.
- The driver changes while it runs. Likelihood certain, impact low. The coordinator takes the `Restart:` stop.

## Dependencies
- Upstream: none
- Downstream: steps 2 to 21 gain skill headroom
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - context hygiene move | ravintio-implement | Content move with test updates |
| REQ-002 - question stop | ravintio-implement | Script change under TDD |
| REQ-003 - setup check after last step | ravintio-implement | Script change under TDD |

## Repo Instructions
custom-001 local git only, custom-002 prefer subagent decomposition, custom-004 ship push and raise PR, custom-006 standing setup refresh approval.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 07 Nov 2026 @ self-confirmed UTC
