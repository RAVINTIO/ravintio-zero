# Design - 0000393-session-integrity-and-guards

## Feature
- Problem: Two guards pass forms they should block, resume detection compares the pack with the product version, and the filing skill never runs the wording check.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/` present)
- Feature ID: 0000393-session-integrity-and-guards
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I want a Bash write to a gated path checked like a Write call, so that a heredoc cannot skip the design gate.
  - US-002: As a maintainer, I want the forced-add guard to read git option values and brace groups, so that no form forces an ignored file in.
  - US-003: As a consumer, I want resume detection to compare the pack with a `plan/state/` record, so that the product version never raises a pack finding.
  - US-004: As a maintainer, I want the filing skill to run the wording check, so that a bad entry fails when filed.
- Acceptance criteria confirmed: 6
- Constraints: no guard gains an allowed form. Bash and PowerShell setups wire the same hooks.
- Integrations: none

## Architecture Layer
- Latency target: the Bash check adds under 100 ms
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Guards fail closed where they do today. Data classification: none, repo files only.
- Data privacy: no regulated data
- Observability: standard defaults. Hooks print a block message on stderr and stdout.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ESM and Bash / no database / GitHub Actions / Build target: local
- Components: ravintio-zero (hooks, scripts, skills, standards, tests)
- Data ownership: ravintio-zero owns `plan/state/pack-version.md`
- Deployment: files installed by `setup.sh` and `setup.ps1`
- API versioning: not applicable

## Component Paths
- ravintio-zero/
- plan/
- docs/

## Scope
- In: Bash shell-write check for gate-write rules. Forced-add guard fixes. Pack version record and resume-detect change. Wording check in the filing skill.
- Out: any widening of a guard.
- Deferred: nothing deferred.

## Assumptions
- Claude Code passes `tool_input.command` to Bash PreToolUse hooks - impact if wrong: the shell check never runs.

## Risks
- A shell-write parser misses a form (likelihood medium, impact medium). It is no worse than today, because no check exists now.
- A new Bash hook blocks a legitimate command (likelihood low, impact medium). It blocks only redirects to gated paths with no design.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 gate-write shell writes | ravintio-implement | Hook code with TDD |
| REQ-002 forced-add options and braces | ravintio-implement | Hook code with TDD |
| REQ-003 pack version record | ravintio-implement | Script and docs change with TDD |
| REQ-004 filing wording check | ravintio-implement | Script and skill change with TDD |

## Repo Instructions
custom-001-local-git-only, custom-002-prefer-subagent-decomposition, custom-004-ship-push-and-raise-pr, custom-006-standing-setup-refresh-approval (see `ravintio-overrides/instructions/`).

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 09 Nov 2026 @ 01:24 a.m. GMT
