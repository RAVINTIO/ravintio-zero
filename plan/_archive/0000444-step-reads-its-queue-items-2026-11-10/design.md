# Design - 0000444-step-reads-its-queue-items

## Feature
- Problem: steps missed queue items that named them. Backlog entry 0000425 records steps 13, 17, and 18.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000444-step-reads-its-queue-items
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I list the queue items that name my step, so that I never miss one.
  - US-002: As the driver, I name each queue item in the step start prompt, so that the session sees them first.
  - US-003: As a step session, I fail ship when a named item has no commit or report, so that a miss never reaches the PR.
- Acceptance criteria confirmed: 3
  - AC-1: The start prompt for a step with a named item lists its folder name.
  - AC-2: `initiative-queue.mjs check` exits 1 and names an item that has no commit and no report.
  - AC-3: A step with no named item sees an unchanged prompt and a passing check.
- Constraints: no new library or service. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth. The helper reads item text as data, builds no shell command from it, and refuses a symlinked item or folder.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ES modules, Markdown skill text, and Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the helper, the driver, and the skill text. The coordinator owns the queue items.
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: `initiative-queue.mjs` with `list` and `check`, driver prompts, orchestrator and ship skill text, a suite, an ADR, docs, and a changelog entry.
- Out: changes to how the coordinator writes items, and any move, rename, or delete of an item.
- Deferred: none

## Assumptions
- Every item holds `**Step:** {n}` and `**Destination:** {path}` in `item.md`. Impact if wrong: the helper skips that item and prints a warning.

## Risks
- Low likelihood, medium impact: the check fails a step whose item names a destination that the step legitimately reports instead. The report route covers it.
- Low likelihood, low impact: the orchestrator skill passes its byte cap. The text stays in the references.

## Dependencies
- Upstream: 0000442
- Downstream: 0000446
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.87.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - queue helper | ravintio-implement | One script and one suite |
| REQ-002 - driver prompt | ravintio-implement | A small driver edit and a suite |
| REQ-003 - skill text and ship check | ravintio-implement | Text edits that call the helper |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: split independent units into subagents.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-10T21:45:44Z. Track: light, accepted by the chart.
