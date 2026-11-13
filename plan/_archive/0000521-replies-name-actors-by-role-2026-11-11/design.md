# Design - 0000521-replies-name-actors-by-role

## Feature
- Problem: replies use "I" for the agent and "you" for the human. A coordinator report names a step session, the coordinator, the driver, and the human, so the pronouns leave the reader to guess the actor.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000521-replies-name-actors-by-role
- Track: light
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the human, I read replies that name each actor by role, so that I know who acts in every sentence.
  - US-002: As the human, I see an advisory note when a run reply uses "I" or "you", so that the habit stops.
  - US-003: As the human, I read the heading `Decisions for the human` in a coordinator report, so that the report follows the same rule.
- Acceptance criteria confirmed: 5
  - AC-1: The reply conventions in the boot templates, the orchestrator skill, and the roadmap standards name actors by role.
  - AC-2: The reply hook flags "I" and "you" in a reply that opens with a run prefix, and ignores other replies.
  - AC-3: The initiative skill heading reads `Decisions for the human`.
  - AC-4: The orchestrator skill stays under 9000 bytes.
  - AC-5: The installed copies match the source.
- Constraints: no new library or service. The hook stays advisory.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no guard changes. The hook reads the reply text and prints a note.
- Data privacy: no regulated data
- Observability: none
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown, Node.js ES modules, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the conventions, the hook, and the tests
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the reply conventions text, the reply hook rule, the initiative skill heading, pin suites, an ADR, docs, a changelog entry, and the sync.
- Out: a blocking hook, and prose rules for documents or commit messages.
- Deferred: none

## Assumptions
- A run reply opens with `hh:mm` and a run prefix. Impact if wrong: the hook skips a reply it should check.

## Risks
- Medium likelihood, low impact: the hook flags a quoted "I" or "you". The hook skips code and quotes, and it stays advisory.
- Medium likelihood, low impact: the orchestrator skill goes over 9000 bytes. The step trims text to stay under.
- Low likelihood, low impact: a test pins the old heading. The step updates the pin.

## Dependencies
- Upstream: ADR-0285 and ADR-0288 (reply writing check and shared prose rules)
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.102.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - actor names in the conventions | ravintio-implement | Markdown edits and one pin suite |
| REQ-002 - reply hook rule | ravintio-implement | One hook edit and one suite |
| REQ-003 - initiative report heading | ravintio-implement | Markdown edit and a test update |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: three small units that touch shared files. They run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T18:06:21Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
