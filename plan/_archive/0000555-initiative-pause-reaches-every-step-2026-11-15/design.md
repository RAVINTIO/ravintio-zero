# Design - 0000555-initiative-pause-reaches-every-step

## Feature
- Problem: A pause of an initiative needs one pause file per running step and one for the initiative. The coordinator wrote them by hand.
- Adoption mode: standard-iterative (signal: source in `src/` beside an archive)
- Feature ID: 0000555-initiative-pause-reaches-every-step
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the human on the loop, I pause an initiative with one command. The initiative and each running step then get a pause record.
  - US-002: As the human on the loop, I restart the driver and each step resumes from its own record, so that no work repeats.
- Acceptance criteria confirmed: 4
- Constraints: Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`. The initiative skill stays under 120 lines. No guard widens.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Security: the script reads and writes under `plan/` only, refuses a symlinked control or worktree path, and treats build-log text as data. Data classification: public.
- Data privacy: no regulated data
- Observability: the driver prints `I-C Run: Paused:` lines
- Cost boundary: not constrained

## Engineering Layer
- Stack: bash tests, Node scripts, markdown standards, no new libraries. Build target: local.
- Components: `ravintio-zero`, the pack that holds the driver, the scripts, the standards, and the skills.
- Data ownership: `ravintio-zero` owns the pause scripts, the pause records it writes, and the driver control folder.
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/
- product.yml

## Scope
- In: the pause script, the driver pause request, the resume finding, the standards rules, one skill line, and tests.
- Out: the feature-level pause command, and a merge in progress.
- Deferred: nothing deferred.

## Assumptions
- A phase end is the next `Complete: P{n}` line in a step build log - impact if wrong: a session stops mid-phase. Resume detection then restores the last commit.
- `plan/current-initiative/pause.md` stays untracked in the root until resume - impact if wrong: the coordinator pause PR carries it.

## Risks
- The driver change triggers a Restart stop after merge. Likelihood certain, impact low. The coordinator starts a new driver.
- The skill reaches 120 lines and fails its length test. Likelihood medium, impact low. The edit joins text to an existing line.
- A pinned test names the resume-detect finding list. Likelihood medium, impact low. The step updates the pin.

## Dependencies
- Upstream: none
- Downstream: the coordinator session, the step sessions, and the resume detection hook read the pause records.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - pause script and records | ravintio-implement | One new script with one test |
| REQ-002 - driver pause request | ravintio-implement | One scheduler change with one test |
| REQ-003 - resume finding and docs | ravintio-implement | One finding, prose rules, and pins |

## Repo Instructions
- Git permissions: work on a `feat/` branch, push as you commit, never commit or merge to `main`.
- Commit granularly: commit after each artifact.
- Subagent decomposition: split independent units, or state why not.
- Ship: push and raise the PR, never merge into `main`. The merge queue merges a step PR.
- Setup refresh: run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 08:38 p.m. GMT
