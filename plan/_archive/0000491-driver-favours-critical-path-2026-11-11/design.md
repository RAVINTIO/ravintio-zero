# Design - 0000491-driver-favours-critical-path

## Feature
- Problem: the driver starts any step that can start, in chart order. A long chain of dependent steps can wait while short chains use the slots, so the initiative runs longer than its longest chain requires.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000491-driver-favours-critical-path
- Track: light
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the coordinator, I want the driver to start the longest chain first, so that the initiative ends when its longest chain allows.
- Acceptance criteria confirmed: 5
  - AC-1: When more steps can start than slots are free, the driver starts first the step with the longest chain of unmerged steps behind it.
  - AC-2: Steps with equal chains start in chart order.
  - AC-3: A step in a lane counts the later steps of its lane as part of its chain.
  - AC-4: A chart with no `After` or `Lane` data starts steps in chart order, as before.
  - AC-5: `roadmap-standards.md` states the order.
- Constraints: no new library or service. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: the ranking runs in well under 100 ms for a 60-step chart
- Availability target: not applicable
- Scalability target: not applicable
- Security: no guard changes. The ranking reads parsed chart numbers, runs no chart text, and builds no path from it.
- Data privacy: no regulated data
- Observability: the driver prints no new line. Existing step start lines show the order.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script, Markdown standards, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the chart parser, the driver, and the standards
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: chain length in `initiative-chart.mjs`, the order in `readySteps`, the text in `roadmap-standards.md`, tests, an ADR, docs, a changelog entry, and the sync.
- Out: concurrency limits, lane assignment, the merge queue order, the chart format, and step duration weights.
- Deferred: none

## Assumptions
- Every step takes about the same time. Impact if wrong: a long step in a short chain can still run late.
- A restarted driver reads the same chart and merged set. Impact if wrong: the order differs after a restart, which changes no result.

## Risks
- Low likelihood, low impact: a cycle in `After` lists. The ranking stops at a step it has already visited.
- Medium likelihood, low impact: a lane successor counts as a dependant, which lengthens chains in busy lanes. The order stays deterministic.

## Dependencies
- Upstream: 0000379 (scheduler and chart columns)
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.100.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - chain ranking in `readySteps` | ravintio-implement | One pure function and one suite |
| REQ-002 - roadmap standards text | ravintio-implement | One standards paragraph and a pin in the suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: two small units that share one function, so they run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T08:42:21Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
