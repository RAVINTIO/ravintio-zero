# Design - 0000399-smoother-activation

## Feature
- Problem: The human found I-B Activate slow. Questions are off target and have no default. Adding a step needs hand edits in 10 chart tables. The suite reruns for 10 minutes. Migrations that do not apply show as pending. The start-up hook loads the wrong skill.
- Adoption mode: standard-iterative (assumed, only signal)
- Feature ID: 0000399-smoother-activation
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the human, I confirm once, so that the branch, activation PR, merge, and driver start run in order
  - US-002: As the human, I add a step with one command, so that no chart table needs a hand edit
  - US-003: As the human, I see my request restated as one plan with a default, so that I answer "Go?"
  - US-004: As the human, I ask at most one question per reply and none about what I already said, so that decisions are quick
  - US-005: As the human, I skip the full suite when only `plan/` files changed, so that activation does not wait 10 minutes
  - US-006: As a session, I see a pending line only for a migration that applies, so that findings stay quiet
  - US-007: As the human, I see the coordinator session load the initiative skill, so that it never loads the orchestrator
- Acceptance criteria confirmed: 4 (the brief's list)
- Constraints: no guard gains a new allowed form. Only existing `git` and `gh` commands run.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No guard widens. The activate script merges only a coordinator PR into `initiative/*`, as the repo instructions allow. Data classification: public repo content.
- Data privacy: no regulated data
- Observability: standard defaults. Scripts print `I-B Activate:` lines.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM with no packages, Bash tests, GitHub Actions unchanged
- Components: `ravintio-zero` (the pack). New scripts `initiative-activate.mjs`, `initiative-add-step.mjs`, `coordinator-pr-check.mjs`. Edits to the initiative skill, `resume-detect.mjs`, two enforcement hooks, `roadmap-standards.md`.
- Data ownership: `ravintio-zero` owns the chart file formats and the scripts that write them
- Deployment: pack files in `src/ravintio-zero/`, copied to `ravintio-zero/` by `sync-installed.mjs`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/
- .claude/skills/

## Scope
- In: items 1 to 7 of backlog entry 0000398
- Out: a faster suite, driver or merge queue changes, migration 0009 in step sessions
- Deferred: nothing deferred

## Assumptions
- The initiative skill starts the driver and watcher as host background tasks - impact if wrong: the script would have to detach them itself.
- A `charted` draft in `plan/roadmap/` marks the coordinator session - impact if wrong: a feature session on that branch loads the initiative skill.

## Risks
- A migration with no `Detect:` line must still report. Likelihood low, impact medium.
- Skill text caps fail after the edits. Likelihood medium, impact low.
- Activate half-finishes on a push failure. Likelihood medium, impact medium. The rerun resumes.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 to REQ-007 | ravintio-implement | Each is a TDD unit in the pack |

## Repo Instructions
Read from `ravintio-overrides/instructions/`.
- Local git only, except the allowed pushes and PRs.
- Prefer subagent decomposition.
- Ship pushes and raises the PR and never merges.
- Standing approval for `ravintio-zero/setup.sh claude-code --strict-orchestrator`.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 10 Nov 2026 @ 01:05 AM GMT
