# Design - 0000351-step-titles-and-history-shape

## Feature
- Problem: Initiative step commits carry free-text titles and the history check ignores branch shape, so a reader can't match a commit to its feature and stray coordinator commits pass.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `docs/about.md`)
- Feature ID: 0000351-step-titles-and-history-shape
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a maintainer, I read `{feature-id}: {Feature title} (#{n})` on each step commit, so that I match a commit to its feature at a glance.
  - US-002: As a coordinator, I chart a `Title` column, so that P0, ship, and the check read one title.
  - US-003: As a reviewer, I run `check-initiative-history.mjs` and it fails any commit that is not a charted step in order or the one chore commit, so that stray commits fail CI.
  - US-004: As a coordinator, I write a one-commit PR subject in the titled form, so that the squash keeps the title.
  - US-005: As a step author, I update the active `initiative.md` when my step changes a chart format, so that no later step stops on the old format.
- Acceptance criteria confirmed: 7
- Constraints: widens no guard. The check tightens. Prose follows the writing standard.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope (no runtime target)
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Script reads local git and the chart through `execFileSync` with an argument array, never a shell string. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults. The check prints failing commits to stderr.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM scripts, Markdown, Bash tests, GitHub Actions. Build target: ci-only.
- Components: `ravintio-zero` (skills, standards, templates, scripts)
- Data ownership: none
- Deployment: files in the pack. Setup copies skills, so a `Setup:` stop follows the step.
- API versioning: not applicable

## Scope
- In: ship PR title from the `Title` column. `Title` column in the initiative template and P0 brief title. History check reads `Title` and enforces the N + 1 shape. Title rules in `roadmap-standards.md` and `commit-standards.md`, including the one-commit PR subject. Entry 0000268 rule in the plan skill and standards.
- Out: coordinator queueing, `--delete-branch`, `reserve-id.mjs` (step 2). The reshape script (step 3). Rechecking delivered history.
- Deferred: rules 1, 2, 3, and 5 of entry 0000345 go to steps 2 and 3.

## Assumptions
- The active chart holds the `Title` column - impact if wrong: the check fails on the chart. The chart was verified to hold it.
- Squash titles on the initiative branch before this step use the old form - impact if wrong: none. The check reads only commits between the PR base and head.

## Risks
- The shape check fails the activation commits (#109, #110) on this branch before the reshape. Likelihood high, impact low. The chore commit allowance and step 3's reshape cover it. The check stays out of per-step CI until step 3.
- A title with regex-special characters breaks the match. Likelihood low, impact medium. The check compares strings exactly and builds no regex from the title.

## Dependencies
- Upstream: `plan/current-initiative/initiative.md` format
- Downstream: step 3 reshape script reads the same `Title` column
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Check script and tests | ravintio-implement | TDD loop for a script with fixtures |
| Standards, template, skill text | ravintio-implement | Docs land with tests that read the text |

## Repo Instructions
- custom-001: fetch, pull, push, and open PRs without asking. Work on a feat/ branch. Merging into main is human-only.
- custom-002: decompose long work into parallel subagents, or state why not.
- custom-004: ship pushes and raises the PR, never merges into main.
- custom-006: run `ravintio-zero/setup.sh claude-code --strict-orchestrator` without asking at a setup refresh.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 05 Nov 2026 @ 11:55 PM UTC
