# Design - 0000470-plan-rereads-files-at-the-branch-point

## Feature
- Problem: parallel steps merge first and leave a plan resting on stale text. Backlog entry 0000435 records the case.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000470-plan-rereads-files-at-the-branch-point
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I reread each file my plan edits at the branch point. I note the commit, so the plan never rests on stale text.
- Acceptance criteria confirmed: 3
  - AC-1: The plan skill names the reread step and the commit note.
  - AC-2: The execution plan template holds a `## Branch-point reads` section.
  - AC-3: The step repeats the reread if the target branch moves before the plan gate.
- Constraints: no new library or service. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no guard changes
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown skill text and Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the plan skill and the template
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: a reread section in the plan skill, a template section, a test, an ADR, docs, a changelog entry, and the sync.
- Out: a reread script, a blocking hook, and P2 rereads.
- Deferred: none

## Assumptions
- The PR base is the target branch. Impact if wrong: the reread reads a branch the PR does not target.

## Risks
- Low likelihood, low impact: the skill-text total passes the 1720 cap. The section stays short.

## Dependencies
- Upstream: 0000383
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.83.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - branch-point reread | ravintio-implement | Skill text, a template section, and one suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: one unit, so it runs inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-10T19:56:35Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
