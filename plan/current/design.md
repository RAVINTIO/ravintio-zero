# Design - 0000352-coordinator-admin-in-step-prs

## Feature
- Problem: Coordinator PRs land between initiative steps, so the branch history holds more than one squash per step. Id reservation can also commit directly on the initiative branch, and coordinator squashes leave their branches on `origin`.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `docs/about.md`)
- Feature ID: 0000352-coordinator-admin-in-step-prs
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a coordinator, I queue admin work that aligns with a running step and name that step, so that the step commits it in its own PR.
  - US-002: As a step session, I commit the queued items that name my step before P4 raises the PR, so that the squash carries them.
  - US-003: As a coordinator, I land admin that fits no step through a `chore/` PR as it happens, so that later steps run on current admin.
  - US-004: As a coordinator, I run `reserve-id.mjs --commit` and it refuses on `initiative/*` and names the `feat/` route, so that no direct commit lands.
  - US-005: As a maintainer, I read `--delete-branch` in every coordinator squash instruction, so that no merged coordinator branch stays on `origin`.
- Acceptance criteria confirmed: 6
- Constraints: widens no guard. The initiative skill stays under 120 lines. A step never moves, renames, or deletes `plan/.initiative-queue/`. Prose follows the writing standard.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope (no runtime target)
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The script reads the branch name through `execFileSync` with an argument array, never a shell string. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults. The refusal prints one line to stderr, as every other failure in the script does.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM scripts, Markdown, Bash tests, GitHub Actions. Build target: ci-only.
- Components: `ravintio-zero` (skills, standards, scripts)
- Data ownership: none
- Deployment: files in the pack. Setup copies skills, so `Restart:` and `Setup:` stops follow the step.
- API versioning: not applicable

## Scope
- In: `--commit` refusal on `initiative/*`. Queue rule, step commit rule, and `chore/` route in the standards, the initiative skill, and the ship skill. `--delete-branch` in every coordinator squash instruction. The `feat/` route in the skills that call `--commit`. Tests.
- Out: reshape script (step 3). `chore/*` force-push rule (step 3). Driver and watcher (step 4). Any guard change.
- Deferred: rule 3 of entry 0000345 goes to step 3.

## Assumptions
- A queue item names its step in a `step:` line - impact if wrong: a step skips an item it should commit. The format is new, so no old item needs conversion.
- The refusal applies to `--commit` only - impact if wrong: a plain reservation on the initiative branch leaves an uncommitted counter change. That change is not a commit, so history stays clean, and the coordinator carries it into its `feat/` PR.

## Risks
- A step session commits an item that names another step. Likelihood low, impact low. The rule says to commit only items that name the step, and the PR diff shows any slip.
- The refusal breaks a caller that runs `--commit` on `initiative/*`. Likelihood medium, impact low. The three skills that call it change in the same step, and the message names the route.

## Dependencies
- Upstream: `plan/.initiative-queue/` owned by the driver and watcher
- Downstream: step 3 reshape reads the same step history
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Refusal in `reserve-id.mjs` and its tests | ravintio-implement | TDD loop for a script with a scratch repo |
| Standards and skill text | ravintio-implement | Docs land with tests that read the text |

## Repo Instructions
- custom-001: fetch, pull, push, and open PRs without asking. Work on a feat/ branch. Merging into main is human-only.
- custom-002: decompose long work into parallel subagents, or state why not.
- custom-004: ship pushes and raises the PR, never merges into main.
- custom-006: run `ravintio-zero/setup.sh claude-code --strict-orchestrator` without asking at a setup refresh.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 06 Nov 2026 @ 12:32 AM UTC
