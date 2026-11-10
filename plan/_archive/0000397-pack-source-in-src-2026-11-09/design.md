---
title: "Design - 0000397-pack-source-in-src"
summary: "Confirmed design for moving the pack source to src/ravintio-zero/."
---
# Design - 0000397-pack-source-in-src

## Feature
- Problem: the pack source and the installed pack share one folder, so a source change changes the running pack.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000397-pack-source-in-src
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I find the pack source at `src/ravintio-zero/` with `git log --follow` history, so that blame survives the move.
  - US-002: As a maintainer, I run the pack from `ravintio-zero/`, a plain copy, so that a source change does not change the running pack.
  - US-003: As a maintainer, I run tests, CI, and source scripts against `src/ravintio-zero/`, so that they check the source.
  - US-004: As a maintainer, I follow a written refresh route, so that the copies diverge only on purpose.
  - US-005: As a maintainer, I rely on guards that cover both paths, with no new allowed form.
- Acceptance criteria confirmed: 6
- Constraints: the move commit holds no content edit. Consumer installs keep `ravintio-zero/`.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no guard gains a new allowed form. A test proves each guard blocks the same actions on both paths.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: shell, PowerShell, Node ES modules, GitHub Actions. Build target: ci-only.
- Components: `ravintio-zero` (component-pack). Source at `src/ravintio-zero/`, installed copy at `ravintio-zero/`.
- Data ownership: the component owns its own files.
- Deployment: consumers install from the source through `setup.sh` and `setup.ps1`, and keep the `ravintio-zero/` path.
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- src/ravintio-zero/
- ravintio-zero/
- .claude/
- .github/
- docs/
- plan/
- product.yml
- README.md
- CONTRIBUTING.md
- SECURITY.md
- .gitattributes
- refresh-ravintio-zero-dir.ps1

## Scope
- In: the two-commit move, retargeted tests, CI, scripts and guards, refresh route docs, component docs.
- Out: file format changes, a symlink, step 21 work, changes to consumer paths.
- Deferred: none

## Assumptions
- Tests find the pack by a path relative to their own file or by the repo root. If wrong, the plan lists more paths to change.
- The installed copy can lag the source. If wrong, hooks run stale rules until a refresh.

## Risks
- A guard misses `src/ravintio-zero/` (likelihood medium, impact high).
- The move commit gains an edit and loses `--follow` history (likelihood low, impact high).
- A Windows test breaks on the new depth (likelihood medium, impact medium).

## Dependencies
- Upstream: step 19, merged.
- Downstream: step 21 edits the source in `src/ravintio-zero/`.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - move and copy | ravintio-implement | Git moves with a parity check |
| REQ-002 - retarget tooling | ravintio-implement | Tests drive each path change |
| REQ-003 - guards | ravintio-implement | One test per guard |
| REQ-004 - docs and refresh route | ravintio-implement | Docs land with the code |

## Repo Instructions
- Git: work on a `feat/` branch, push, and raise PRs. Never commit to `main` or merge into it.
- Split long tasks across subagents.
- Ship pushes and raises the PR.
- Standing approval for `ravintio-zero/setup.sh claude-code --strict-orchestrator`.

## Decisions applied
- Decision applied (initiative chart): how the pack source moves, consumers keep `ravintio-zero/`, copies diverge by design, guards extend to both paths.

## Scope lock
- In scope: the six features in the brief [source: draft-accepted (initiative)]
- Out of scope: file format changes and a symlink [source: draft-accepted (initiative)]

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 09 Nov 2026 @ 09:45 PM UTC
