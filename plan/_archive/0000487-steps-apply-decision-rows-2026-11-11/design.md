# Design - 0000487-steps-apply-decision-rows

## Feature
- Problem: the chart's `## Decisions` rows are pre-approved answers, but no code reads them. Step 40 ignored the row for steps 25 to 41 and lost about 30 minutes.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000487-steps-apply-decision-rows
- Track: light
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I list every Decisions row that names my step, including a range, so that I miss no pre-approved answer.
  - US-002: As a maintainer, I see one build log line for each applicable row, so that I know the step applied it.
  - US-003: As a maintainer, I want ship to fail a log that misses a row, so that a skipped row stops.
- Acceptance criteria confirmed: 5
  - AC-1: `decision-rows.mjs list --step 40` prints the `25-41` row and prints no row for step 45.
  - AC-2: A build log with an applicable row and no log line fails `build-log-check.mjs`, and the finding names the fork.
  - AC-3: A build log with a `Decision applied` or `Decision not applicable` line for each row passes.
  - AC-4: A run with no chart passes with no new finding.
  - AC-5: P0 start actions and `roadmap-standards.md` describe the lookup, the log line, and the check.
- Constraints: no new library or service. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no guard changes. The module treats chart text as data, runs none of it, and builds no path from it.
- Data privacy: no regulated data
- Observability: the check names each missing fork
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script, Markdown standards, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the module, the check, and the standards
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the module, the new check, the P0 start action, the standards text, tests, an ADR, docs, a changelog entry, and the sync.
- Out: judging whether a step applied a row well, chart table format changes, and driver changes.
- Deferred: none

## Assumptions
- The build log Feature ID equals the chart `Feature id` column. Impact if wrong: the check skips.
- A Fork text is unique within its step. Impact if wrong: one log line covers two rows.

## Risks
- Medium likelihood, low impact: a fork text with a colon or a pipe breaks the line match. The match compares the text after the fixed prefix and trims it.
- Low likelihood, medium impact: the check fails old logs in the archive. It runs only at ship on the current log.

## Dependencies
- Upstream: 0000378 (merge queue), 0000385 (baseline record)
- Downstream: 0000490 (step 46)
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.94.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - row lookup | ravintio-implement | One module and one suite |
| REQ-002 - build log check | ravintio-implement | Imports the module, one suite |
| REQ-003 - P0 text and standards | ravintio-implement | Markdown edits and one pin suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: three small units that share one module, so they run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T02:57:54Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
