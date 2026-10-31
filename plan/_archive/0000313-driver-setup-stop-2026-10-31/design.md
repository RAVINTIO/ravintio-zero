# Design - 0000313-driver-setup-stop

## Feature
- Problem: A merged initiative step that changes installed pack files leaves later steps on stale `.claude/` copies, and the driver cannot pause for a setup rerun.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000313-driver-setup-stop
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As an initiative owner, I want the driver to stop after a merged step that changes installed pack files, so that the next step runs on copies that match the pack.
  - US-002: As an initiative owner, I want the initiative skill to treat the `Setup:` line as a planned stop and rerun setup, so that I don't rerun it by hand.
  - US-003: As a pack maintainer, I want the stop documented, so that the driver, the skill, and the standards agree.
- Acceptance criteria confirmed: 5
- Constraints: driver has no dependencies beyond Node. Driver never edits the working tree. Keep the `Restart:` stop.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Setup runs only for the exact command a `Confirmation:` row names. The change widens no guard.
- Data privacy: no regulated data
- Observability: stop line on stdout, with the step log path appended as for other stops
- Cost boundary: not constrained

## Engineering Layer
- Stack: JavaScript (Node ESM), Bash tests, GitHub Actions CI, build target local
- Components: `ravintio-zero` - driver script, initiative skill, roadmap standards
- Data ownership: none
- Deployment: pack files copied by setup
- API versioning: not applicable

## Scope
- In: watch `ravintio-zero/skills/`, `ravintio-zero/hooks/`, `ravintio-zero/setup.sh`, `ravintio-zero/setup/` and print `I-D Advance: Setup:` with exit 1. One combined line when `Restart:` also applies. Initiative skill `Setup:` handling. Roadmap standards text. Tests.
- Out: changing hooks or `setup.sh`. Running setup from the driver.
- Deferred: hook resolution from a subfolder (step 4). Nothing else is blocked.

## Assumptions
- Step 1 runs on the old driver and ends with `Restart:` - impact if wrong: the combined line appears one step early, which is harmless.

## Risks
- The initiative skill is both a `Restart:` file and a `Setup:` file. Likelihood high, impact low: the combined line covers it.
- A long file list overflows the line limit. Likelihood medium, impact low: cap the list.

## Dependencies
- Upstream: none
- Downstream: steps 2 to 10 rely on the stop.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - driver setup stop | ravintio-implement | Script change with a test |
| REQ-002 - combined stop line | ravintio-implement | Same script and test |
| REQ-003 - initiative skill and standards text | ravintio-implement | Text change with a test |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 31 Oct 2026 @ 07:06 PM UTC
