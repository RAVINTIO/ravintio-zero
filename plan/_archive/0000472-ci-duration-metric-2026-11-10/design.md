# Design - 0000472-ci-duration-metric

## Feature
- Problem: CI took about 16 minutes per merge, and nothing shows CI growth. Backlog entry 0000436 records the case.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000472-ci-duration-metric
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I see the longest CI run of a feature in the governance report, so that CI growth shows before it hurts.
- Acceptance criteria confirmed: 5
  - AC-1: `workflow-metrics.mjs` prints a CI duration row with the longest value and a result.
  - AC-2: A value above the threshold prints `breach` and the exit code stays 0.
  - AC-3: `workflow-governance-standards.md` holds the marker and the `ci-duration-seconds` threshold.
  - AC-4: `testing-standards.md` names the CI target.
  - AC-5: The validate skill writes the marker.
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
- Stack: Node.js script, Markdown standards and skill text, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the script, the standards, and the skill
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the marker, the metric, a threshold row, a CI target, a skill line, a test, an ADR, docs, a changelog entry, and the sync.
- Out: a failing CI check, GitHub reads in the script, and a cross-feature history.
- Deferred: none

## Assumptions
- The validate skill can read the duration of a CI run. Impact if wrong: the marker records `unknown` and the metric skips it.
- The target is 420 seconds. Impact if wrong: one table cell changes.

## Risks
- Low likelihood, medium impact: existing suites that pass a custom standards file lack the new key. The script treats a missing `ci-duration-seconds` key as an error like the others, so P2 updates those fixtures.
- Low likelihood, low impact: the skill-text total passes its cap. The line stays short.

## Dependencies
- Upstream: 0000173, 0000409
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.87.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - CI duration row in the script | ravintio-implement | One script change and one suite |
| REQ-002 - marker and target in the standards and the ship skill | ravintio-implement | Two standards, one skill line, and one suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: one unit, so it runs inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-10T21:45:09Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
