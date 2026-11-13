# Design - 0000387-light-discovery-and-audits

## Feature
- Problem: P0 takes most of a consumer run's time for small work, coaching decisions flood the branch with commits, and discovery and plan miss a criterion with no content and a late advisory.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and source present)
- Feature ID: 0000387-light-discovery-and-audits
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer of a consumer repo, I want a light P0 track for fixes and small changes, so that a small change reaches a confirmed design in minutes.
  - US-002: As a maintainer, I want coaching records grouped by topic into one commit, so that P0 history shows a few topic commits.
  - US-003: As a maintainer, I want discovery to check that tested content exists before it confirms a criterion, so that no criterion tests nothing.
  - US-004: As a maintainer, I want the plan phase to re-run the dependency audit, so that a late advisory stops at the plan gate.
  - US-005: As a maintainer, I want coaching to ask whether a major bump is pre-approved for an advisory fix, so that P2 does not stop on it.
- Acceptance criteria confirmed: 6
- Constraints: the orchestrator `SKILL.md` stays at or under 9,000 bytes. The boot template stays at or under 3,600 bytes. No hook or guard changes.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No guard gains an allowed form. Data classification: none, repo files only.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown skills and references, Node.js ESM, Bash tests / no database / GitHub Actions / Build target: local
- Components: ravintio-zero (skills, references, templates, tests)
- Data ownership: ravintio-zero owns `discovery.md` and `build-log.md` formats
- Deployment: files installed by `setup.sh` and `setup.ps1`
- API versioning: not applicable

## Component Paths
- ravintio-zero/
- plan/
- docs/

## Scope
- In: light track reference and offer, track marker in the discovery template, commit grouping rule, content check in P0 coaching, major-bump coaching question, plan-phase audit re-run with an `Audit:` build-log line.
- Out: any hook, guard, or script change.
- Deferred: nothing deferred.

## Assumptions
- The pack source layout stays at `ravintio-zero/` during this step - impact if wrong: edits land in a stale path.
- `check-design` and `gate-write` read `design.md` headings only - impact if wrong: a light design fails the gate.

## Risks
- The orchestrator `SKILL.md` has 301 bytes of headroom (likelihood high, impact low). New rules go in references with a short Pack Index row.
- Wording-pinned tests break on edited rules (likelihood medium, impact low). Update the pin in the same step.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 light track | ravintio-implement | Reference, template, and tests with TDD |
| REQ-002 grouped commits | ravintio-implement | Skill and boot text with TDD |
| REQ-003 criterion content check | ravintio-implement | Reference text with TDD |
| REQ-004 audit refresh at plan | ravintio-implement | Skill text with TDD |
| REQ-005 major-bump coaching | ravintio-implement | Reference text with TDD |

## Repo Instructions
custom-001-local-git-only, custom-002-prefer-subagent-decomposition, custom-004-ship-push-and-raise-pr, custom-006-standing-setup-refresh-approval (see `ravintio-overrides/instructions/`).

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 09 Nov 2026 @ 06:49 GMT
