# Design - 0000353-reshape-at-delivery

## Feature
- Problem: An initiative branch carries coordinator and admin commits between its step squashes. The delivered history needs one titled squash per step, then one chore commit, with no force push of a branch or a tag. The ship skill also still allows `--force-with-lease` for `chore/*`.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `docs/about.md`)
- Feature ID: 0000353-reshape-at-delivery
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a coordinator, I run one script at I-E Delivery and get a new branch with one titled commit per step, then one chore commit.
  - US-002: As a coordinator, I move each step tag to its new commit without a force push.
  - US-003: As a coordinator, I get a stop that names the commit when a replay conflicts.
  - US-004: As a coordinator, I read the reshape, the tag move, and the cleanup in the delivery rules and the initiative skill.
  - US-005: As a maintainer, I read one route for a multi-commit `chore/*` PR, the replacement branch, and no `--force-with-lease`.
- Acceptance criteria confirmed: 7
- Constraints: widens no guard. The script runs no force push. The initiative skill stays under 120 lines. Prose follows the writing standard.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope (no runtime target)
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The script passes every ref, path, and message to git as an argument array through `execFileSync`, never a shell string. Branch and tag names come from the chart and the caller, so the script checks each against a name pattern first. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults. Each failure prints one line to stderr. A run prints the new branch, each new commit, and each tag move to stdout.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM scripts, Markdown, Bash tests, GitHub Actions. Build target: ci-only.
- Components: `ravintio-zero` (skills, standards, scripts)
- Data ownership: none
- Deployment: files in the pack. Setup copies skills, so `Restart:` and `Setup:` stops follow the step.
- API versioning: not applicable

## Scope
- In: `reshape-initiative.mjs`, the I-E Delivery rules, the initiative skill, the ship skill `## PRs into main` change, and tests.
- Out: driver and watcher (step 4). Any guard change. Deleting the old branch from the script.
- Deferred: none

## Assumptions
- Each merged step has a tag `v{Version}` at its squash commit - impact if wrong: the script cannot find the step commit. It exits 1 and names the step.
- The old step squash subject ends with ` (#{n})` - impact if wrong: the new title lacks a number. The script exits 1 and names the commit.

## Risks
- A replay conflicts on a file that both an assigned admin commit and a step change. Likelihood medium, impact low. The script exits 1 and names the commit. The coordinator stops for the human.
- The new step trees lack unassigned admin, so a step tag points at a tree that the step never tested. Likelihood certain, impact low. The final tree is identical and CI runs on it. The entry records this trade-off.

## Dependencies
- Upstream: `check-initiative-history.mjs` and the chart `Steps` table
- Downstream: step 4 resumes steps and does not touch the reshape
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Reshape script and its tests | ravintio-implement | TDD loop for a script with a scratch repo |
| Delivery rules, initiative skill, ship skill text | ravintio-implement | Docs land with tests that read the text |

## Repo Instructions
- custom-001: fetch, pull, push, and open PRs without asking. Work on a feat/ branch. Merging into main is human-only.
- custom-002: decompose long work into parallel subagents, or state why not.
- custom-004: ship pushes and raises the PR, never merges into main.
- custom-006: run `ravintio-zero/setup.sh claude-code --strict-orchestrator` without asking at a setup refresh.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 06 Nov 2026 @ 01:29 AM UTC
