# Design - 0000489-question-only-for-questions

## Feature
- Problem: step 31 ended its turn with a false `Question:` line while it waited for its suites. The driver stops on that line, so the line looks like a stop for the human.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000489-question-only-for-questions
- Track: light
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I use `Question:` only to ask the human something, so that the driver stops only for a real question.
  - US-002: As a maintainer, I see a warning on a `Question:` line with no question mark, so that a false question shows up.
- Acceptance criteria confirmed: 4
  - AC-1: The orchestrator `SKILL.md`, `pipeline-reference.md`, and `roadmap-standards.md` say that `Question:` asks the human something and that a step waiting on its own work keeps working.
  - AC-2: The Stop hook warns on a final reply whose `Question:` line holds no question mark.
  - AC-3: The hook stays silent on a `Question:` line with a question mark, and on any other status.
  - AC-4: The hook exits 0 in every case.
- Constraints: no new library or service. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no guard changes. The hook reads reply text as data, runs none of it, and builds no path from it. It blocks nothing.
- Data privacy: no regulated data
- Observability: the warning names the check, and the miss log gains one line
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script, Markdown standards, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the hook, the skill text, and the standards
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the orchestrator and standards text, the Question check in `check-reply-prefix.mjs`, tests, an ADR, docs, a changelog entry, and the sync.
- Out: driver changes and any hook that blocks a turn.
- Deferred: none

## Assumptions
- The status line is the first non-empty line of the reply. Impact if wrong: the check misses a `Question:` line deeper in the reply.

## Risks
- Medium likelihood, low impact: a real question that ends without a question mark draws a warning. The warning does not block the turn.
- Low likelihood, low impact: a false question that contains a question mark in its text passes the check.

## Dependencies
- Upstream: 0000200 (reply prefix hook), 0000377 (Question stop)
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.98.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - skill and standards text | ravintio-implement | Markdown edits and one pin suite |
| REQ-002 - Question check in the Stop hook | ravintio-implement | One hook and one suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: two small units that share the reply text, so they run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T07:13:00Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
