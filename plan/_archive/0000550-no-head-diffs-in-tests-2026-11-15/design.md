# Design - 0000550-no-head-diffs-in-tests

## Feature
- Problem: A test that diffs against `HEAD` passes with no change once someone commits. No standard or check names the pattern.
- Adoption mode: standard-iterative (only signal: source in `src/` beside an archive)
- Feature ID: 0000550-no-head-diffs-in-tests
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)
- Track: light
- Version: 0.124.0 plus a minor bump, 0.125.0 planned. The merge queue sets the released version.

## Product Layer
- User stories:
  - US-001: As a test author, I read a rule that bans diffing against `HEAD`, so that my test keeps its meaning after a commit.
  - US-002: As a maintainer, I run a suite that fails any suite diffing against `HEAD`, so that a vacuous test cannot merge.
- Acceptance criteria confirmed: 4
- Constraints: Pack edits go in `src/ravintio-zero/` and mirror to `ravintio-zero/`.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: the check greps about 480 files and finishes in under 5 seconds
- Security: no auth, no data, no credentials
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: bash suites, Node scripts, markdown standards. Build target: local.
- Components: `ravintio-zero` (pack standards and tests)
- Data ownership: no data
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- plan/
- docs/

## Scope
- In: a rule in `testing-standards.md`. A suite that greps suites for `git diff` against `HEAD`. A planted failing case.
- Out: suites that pass `--base HEAD` to a script, which is not a git diff of the repo under test.
- Deferred: nothing deferred.

## Assumptions
- The four existing `--base HEAD` uses pass an argument to `prose-check.mjs`. If they are git diffs, the new check fails on them and needs an allowlist.

## Risks
- A grep pattern misses a form such as `git diff @` - likelihood medium, impact low. The pattern covers `HEAD`, `HEAD~n`, `HEAD^`, `@`, and `ORIG_HEAD`.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - testing rule | ravintio-implement | Standards edit with a test |
| REQ-002 - style check | ravintio-implement | New suite with a planted case |

## Repo Instructions
See `ravintio-overrides/instructions/`: git permissions, subagent decomposition, ship push and PR, and standing setup approval.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 06:31 PM local
