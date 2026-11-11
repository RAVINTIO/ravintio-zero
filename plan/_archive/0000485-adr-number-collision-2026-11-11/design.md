# Design - 0000485-adr-number-collision

## Feature
- Problem: parallel steps reserve one ADR number or one backlog id from their own branch counters. The merge queue never renumbers the later file. Backlog entry 0000479 records the case.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000485-adr-number-collision
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I merge parallel steps that reserved one ADR number, so that each ADR keeps a unique number with no hand edit.
  - US-002: As a maintainer, I merge parallel steps that filed entries under one id, so that each entry keeps a unique id.
- Acceptance criteria confirmed: 5
  - AC-1: Two ADRs with one number merge, and the PR's ADR gets a free number with its file, heading, index row, references, and counter updated.
  - AC-2: Two backlog entries with one id merge, and the PR's entry gets a free id with the index rebuilt.
  - AC-3: A merge with no collision adds no commit and prints no `renumbered:` line.
  - AC-4: The queue runs the module after a clean base merge and after a shared-file conflict resolution.
  - AC-5: `roadmap-standards.md` describes the renumber.
- Constraints: no new library or service. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no guard changes. The module treats file text as data and passes git arguments as arrays.
- Data privacy: no regulated data
- Observability: the queue prints one `renumbered:` line for each change
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script, Markdown standards, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the queue, the module, and the standards
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the module, the queue call, the output line, the standards text, tests, an ADR, docs, a changelog entry, and the sync.
- Out: collisions between unmerged branches, feature and initiative ids, and `reserve-id.mjs`.
- Deferred: none

## Assumptions
- A PR's references to its own colliding number sit in files the PR changed. Impact if wrong: a stale reference stays.
- A PR cannot cite a base ADR added after it branched. Impact if wrong: the module renumbers a reference it should keep.

## Risks
- Medium likelihood, low impact: a reference to the old number sits in a file the PR did not change. The module reports only the files it rewrote, and the retrospective step checks the rest.
- Low likelihood, medium impact: a rename breaks a link in a file the PR left alone. The module rewrites links only in files the PR changed.

## Dependencies
- Upstream: 0000456 (shared files), 0000378 (merge queue)
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.91.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - ADR renumber | ravintio-implement | One module function and one suite |
| REQ-002 - backlog id renumber and queue call | ravintio-implement | Same module, the queue call, and one suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: two small units that share one module, so they run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T01:48:06Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
