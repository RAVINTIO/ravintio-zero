# Design - 0000468-reply-time-matches-the-clock

## Feature
- Problem: the reply check accepts any `hh:mm`, so a wrong time passes. Steps 14, 15, and 19 typed times up to an hour off.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000468-reply-time-matches-the-clock
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a human on the loop, I see a warning when a reply time differs from the clock by more than the margin. Then a wrong time does not pass.
  - US-002: As a human on the loop, I find the instruction to read `date +%H:%M` before each reply wherever the reply form appears. Then steps read the clock.
- Acceptance criteria confirmed: 4
  - AC-1: A time within 5 minutes of the clock passes, including across midnight.
  - AC-2: A time more than 5 minutes off draws the warning and one log line.
  - AC-3: A time with no prefix is still a miss.
  - AC-4: Every place that states the reply form tells the step to read `date +%H:%M`.
- Constraints: no new library or service. The hook exits 0 on every path.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: the change widens no guard. The hook warns and never blocks.
- Data privacy: no regulated data
- Observability: the existing `plan/.prefix-misses.log`
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node hook, bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the hook, the standards, the skills, and the templates
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- .claude/
- docs/
- plan/

## Scope
- In: the clock check in `check-reply-prefix.mjs` and the read-the-clock rule text.
- In: fixed clocks in two suites, a new suite, an ADR, docs, a changelog entry, and the sync.
- Out: blocking a turn, and changes to `check-design.mjs`.
- Deferred: none

## Assumptions
- The hook shares the session's clock. Impact if wrong: a warning on a correct time.
- The hook runs right after the final reply. Impact if wrong: the 5-minute margin absorbs the delay.

## Risks
- Low likelihood, low impact: a long Stop delay pushes a correct time past the margin. The warning never blocks a turn.

## Dependencies
- Upstream: 0000388, 0000200
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.83.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - clock check | ravintio-implement | One hook change with one suite |
| REQ-002 - read-the-clock rule | ravintio-implement | Rule text in several files with one suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: split independent units into subagents.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-10T19:08:35Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
