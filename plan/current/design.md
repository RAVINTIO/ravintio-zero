# Design - 0000546-queue-failure-leaves-dirty-files

## Feature
- Problem: A queue run can fail after it writes the version files and before the commit lands. The worktree stays dirty and the next run stops.
- Adoption mode: standard-iterative
- Feature ID: 0000546-queue-failure-leaves-dirty-files
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the driver, I run the queue after a failed run, so that the queue worktree holds no files the failed run wrote.
- Acceptance criteria confirmed: 2
- Constraints: Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`. Reset only the paths the failed run wrote, and only in the queue worktree.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: none, a local script change. The reset takes fixed paths from the chart and `version-files.txt`. Data classification: public.
- Data privacy: no regulated data
- Observability: the queue prints one line that names the restored paths
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script, bash tests, no new libraries. Build target: local.
- Components: `ravintio-zero`, the pack that holds `merge-queue.mjs`.
- Data ownership: `ravintio-zero` owns `merge-queue.mjs` and its tests.
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/scripts/
- ravintio-zero/scripts/
- src/ravintio-zero/docs/
- ravintio-zero/tests/
- docs/
- plan/
- src/ravintio-zero/component.yml
- ravintio-zero/component.yml
- product.yml

## Scope
- In: restore the chart and the version files to HEAD when `run` fails before the commit lands. A test uses a rejected commit.
- Out: any reset of other paths, and a change to the start-of-run clean-tree check.
- Deferred: nothing deferred.

## Assumptions
- The files the queue writes are the chart and the paths in `version-files.txt` - impact if wrong: the reset leaves a written file dirty.
- The queue worktree holds no other tracked change when `run` starts. The clean-tree check enforces this. Impact if wrong: the reset discards the change.

## Risks
- A test pins text the step edits. Likelihood low, impact low. The step updates the pin and logs a `Rework:` line.
- The reset runs when the push fails after a good commit and discards a commit. Likelihood low, impact medium. The reset covers only the failure window before the commit lands, and it never runs `git reset` on commits.

## Dependencies
- Upstream: none
- Downstream: the driver runs the queue.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - restore written files | ravintio-implement | One script change with one test |

## Repo Instructions
- Git permissions: work on a `feat/` branch, push as you commit, never commit or merge to `main`.
- Commit granularly: commit after each artifact.
- Subagent decomposition: split independent units, or state why not.
- Ship: push and raise the PR, never merge into `main`. The merge queue merges a step PR.
- Setup refresh: run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 07:18 PM GMT
