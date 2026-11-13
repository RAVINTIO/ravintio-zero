# Design - 0000519-ship-removal-needs-human-approval

## Feature
- Problem: ship Step 4 tells the agent to delete the contents of `plan/current/`. The Claude Code safety check refused it, and step 57 stopped for about two hours. P2 also tells the agent to write docs while the full suite runs, and the runner fails on a changed tree.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000519-ship-removal-needs-human-approval
- Track: light
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I remove `plan/current/` with `git rm -r -q plan/current`, so that the safety check accepts the removal and the step does not stop.
  - US-002: As an implementing agent, I write docs outside the full suite run, so that the runner sees no changed tree.
- Acceptance criteria confirmed: 4
  - AC-1: Ship Step 4 runs `git rm -r -q plan/current` from the repo root, with a literal path, no `cd`, and no glob.
  - AC-2: The ship skill names no `rm -r` of `plan/current/`.
  - AC-3: The P2 text tells the agent to write docs before the full suite starts or after it ends.
  - AC-4: The installed copies match the source.
- Constraints: no new library or service. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no guard changes. The command removes tracked files in the repo only, and the archive copy exists before it runs.
- Data privacy: no regulated data
- Observability: none
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown skills, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` and `.claude/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the skills and the tests
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the ship Step 4 text and the P2 docs timing text. Also a pin suite, an ADR, docs, a changelog entry, and the sync.
- Out: guard or hook changes and driver changes.
- Deferred: none

## Assumptions
- The safety check accepts `git rm -r -q plan/current`. Impact if wrong: the step stops again at Step 4.

## Risks
- Low likelihood, medium impact: `git rm` fails on an untracked file left in `plan/current/`. Step 4 stages everything first, so none remains.
- Medium likelihood, low impact: a test pins the old wording and fails. The step updates the pin.

## Dependencies
- Upstream: 0000025 (archive staging), ADR-0010 (copy then delete)
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.100.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - ship removal command | ravintio-implement | Markdown edit and one pin suite |
| REQ-002 - P2 docs timing | ravintio-implement | Markdown edit and one pin suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: two small units in separate skill files. They run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T08:42:30Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
