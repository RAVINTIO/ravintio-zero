# Design - 0000359-safe-parallel-commits

## Feature
- Problem: A step session can change the shared tree under running subagents, and a plain `git commit` in a parallel batch can take another unit's staged files.
- Adoption mode: standard-iterative
- Feature ID: 0000359-safe-parallel-commits
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a maintainer, I find the orchestrator and implement skills ban `git stash`, `git checkout -- {path}`, `git reset`, and `git clean` while a subagent runs, so that no step changes the tree under a running unit.
  - US-002: As a maintainer, I find the implement skill names a scratch clone as the way to test a clean tree mid-phase, so that a unit needing one has a safe route.
  - US-003: As a maintainer, I find the dispatch standard tells each unit to run `git commit -m "{message}" -- {paths}` and bans `git commit --amend` in a batch, so that a unit's commit holds only its own paths.
- Acceptance criteria confirmed: 3
- Constraints: chart Decisions rows for step 8 apply. No schema or dependency change.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth change and no guard change. The rules are text. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown, Bash. Tests in Bash. CI GitHub Actions. Build target ci-only.
- Components: ravintio-zero pack (skills, standards, tests)
- Data ownership: none
- Deployment: setup copies pack files into consumer repos. A `Setup:` stop follows this step.
- API versioning: not applicable

## Scope
- In: orchestrator rule on tree-wide git under subagents with a build log note. Scratch clone in the implement skill. `-- {paths}` commit form and amend ban in the dispatch standard. Tests.
- Out: a blocking hook. Other subagent git rules.
- Deferred: nothing deferred.

## Assumptions
- A text rule meets the entries - impact if wrong: a later step adds a hook.

## Risks
- Existing suites pin the current text of the dispatch standard: likelihood medium, impact low. Mitigation: update them in the same step.
- The rule contradicts the existing Fast batches wording on stage by path: likelihood low, impact low. Mitigation: extend the same bullet.

## Dependencies
- Upstream: step 7 merged (0.55.0)
- Downstream: I-E Delivery
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - no-tree-git-under-subagents | ravintio-implement | Skill text under a test |
| REQ-002 - own-path-commits | ravintio-implement | Standard text under a test |

## Repo Instructions
custom-001 local git only, custom-002 prefer subagent decomposition, custom-004 ship push and raise PR, custom-006 standing setup refresh approval.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 07 Nov 2026 @ 06:06 UTC
