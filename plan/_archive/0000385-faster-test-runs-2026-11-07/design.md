---
title: "Design - 0000385-faster-test-runs"
summary: "Affected-test cycles, baseline failures, and a clean-clone suite run."
---
# Design - 0000385-faster-test-runs

## Feature
- Problem: P2 reruns the full suite after every requirement, runs cannot tell inherited failures from new ones, and P3 runs in a working tree that differs from CI.
- Adoption mode: standard-iterative
- Feature ID: 0000385-faster-test-runs
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a developer, I want each TDD cycle to run only the tests the unit can affect, so that P2 spends less time on suite runs.
  - US-002: As a developer, I want P0 to record base-commit failures, so that P3 stops only on failures my run caused.
  - US-003: As a developer, I want P3 to run the suite in a clean clone of `HEAD`, so that its result matches CI.
- Acceptance criteria confirmed: 6
- Constraints: Bash 3.2, no `timeout` on macOS, orchestrator `SKILL.md` byte cap
- Integrations: none

## Architecture Layer
- Latency target: the clean clone adds under 30 seconds on this repo
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no data. The clone script runs only the caller's command in a temporary folder it creates and removes.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, Node.js, GitHub Actions, build target local
- Components: `ravintio-zero` - skills, standards, scripts, and tests
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Component Paths
- `ravintio-zero/`

## Scope
- In: affected-test rule in implement and refactor skills, `Tests run:` line, `baseline-failures.mjs`, `clean-clone-test.mjs`, P0 and P3 steps, build report section, docs
- Out: `run-tests.sh` selection changes, PowerShell ports, orchestrator `SKILL.md` anchors
- Deferred: automatic changed-file to test mapping for other stacks

## Assumptions
- `git clone` of a local path works on every runner - impact if wrong: the script exits non-zero with the git error.
- A suite that prints `Failed suites:` lists each failed file on its own line - impact if wrong: the baseline parser records nothing and P3 stops on every failure.

## Risks
- An agent picks too few tests in a cycle (medium likelihood, medium impact). Mitigation: the single full suite run before P2 completes and again at P3.
- The baseline hides a real regression with the same test name (low, medium). Mitigation: the comparison matches the suite name, and the build report lists every inherited failure.

## Dependencies
- Upstream: none
- Downstream: step 10 edits the same implement skill
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - affected tests per cycle | ravintio-implement | Skill text edits with a suite |
| REQ-002 - baseline failures | ravintio-implement | Node script with a suite |
| REQ-003 - clean clone at P3 | ravintio-implement | Node script with a suite |

## Repo Instructions
Local git only, prefer subagent decomposition, push and raise the PR at ship, standing setup refresh approval (`ravintio-overrides/instructions/`).

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 07 Nov 2026 @ 10:00 PM UTC
