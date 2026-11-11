# Design - 0000499-reply-times-match-clock

## Feature
- Problem: agents estimate reply times, so step 27 printed times 10 to 13 minutes ahead of the clock. The Stop hook runs once per turn and never sees the drift.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000499-reply-times-match-clock
- Track: full
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As an agent, I get the current local time after every tool call, so that I never estimate a time.
  - US-002: As a maintainer, I find a rule that every timestamp comes from a fresh clock read.
  - US-003: As a maintainer, I see a warning when a reply time is over 2 minutes off the clock or the status is unknown.
  - US-004: As the human, I see the watcher's own time on each activity line.
- Acceptance criteria confirmed: 5
  - AC-1: The PostToolUse hook prints JSON whose additionalContext holds the current local hh:mm, and exits 0.
  - AC-2: setup.sh and setup.ps1 wire the hook once and a rerun adds no duplicate.
  - AC-3: The roadmap standards, the initiative skill, and the pipeline reference require a fresh clock read for every timestamp.
  - AC-4: The reply hook warns when the prefix time is over 2 minutes off the clock. It also warns on a status outside the allowed list.
  - AC-5: Each watcher activity line starts with the watcher's own hh:mm.
- Constraints: no new library or service. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: the clock hook adds no measurable delay (one local clock read)
- Availability target: not applicable
- Scalability target: not applicable
- Security: no guard changes. The new hook reads no input, runs nothing from it, and blocks nothing. The reply check reads reply text as data.
- Data privacy: no regulated data
- Observability: the reply warning names the check, and the miss log gains one line per miss
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts, Bash and PowerShell setup, Markdown standards, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the hooks, setup, skill text, standards, and watcher
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the PostToolUse clock hook and its setup wiring, clock rule text, the 2 minute margin, and the status check.
- Also in: stamped activity lines, tests, an ADR, docs, a changelog entry, and the sync.
- Out: any hook that blocks a turn or tool call, and stamping other lines.
- Deferred: none

## Assumptions
- Claude Code passes hookSpecificOutput.additionalContext from a PostToolUse hook to the model. Impact if wrong: the hook adds nothing and the rule text still applies.

## Risks
- Medium likelihood, low impact: the 2 minute margin warns on a reply that follows a long tool call. The warning does not block the turn.
- Low likelihood, medium impact: a settings merge in setup drops a user PostToolUse entry. The per-command filter keeps user commands.

## Dependencies
- Upstream: 0000200 (reply prefix hook), 0000468 (clock check), 0000240 (activity lines)
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.100.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - clock hook and setup wiring | ravintio-implement | One hook, two setup scripts, one suite |
| REQ-002 - clock rule text | ravintio-implement | Markdown edits and one pin suite |
| REQ-003 - tighter reply check | ravintio-implement | One hook edit and one suite |
| REQ-004 - stamped activity lines | ravintio-implement | One watcher edit and one suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: four small units that share the clock rule, so they run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T08:42:29Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
