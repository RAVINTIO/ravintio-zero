# Design - 0000507-hook-check-after-setup

## Feature
- Problem: After setup, no command checks that every hook in `.claude/settings.json` loads and runs.
- Adoption mode: standard-iterative
- Feature ID: 0000507-hook-check-after-setup
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the coordinator, I run one command after setup, so that I know every installed hook loads and runs.
  - US-002: As the driver, I run the check after setup and stop on a failure, so that a broken hook never reaches a step.
- Acceptance criteria confirmed: 3 (location, sample inputs, driver wiring)
- Constraints: A guard's deliberate block (exit 2) counts as a pass. The check sets `CLAUDE_PROJECT_DIR` itself.
- Integrations: the initiative driver

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: The check runs only commands already listed in `.claude/settings.json`. It adds no credentials and writes no files outside a temporary directory.
- Data privacy: no regulated data
- Observability: standard defaults. The script prints one line per hook and exits non-zero on a failure.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script (`.mjs`), shell test harness in the existing tests folder
- Components: `ravintio-zero` pack. It gains `scripts/hook-check.mjs`, its test, and a driver call after setup.
- Data ownership: `ravintio-zero` owns the script and its test. The driver script stays in `ravintio-zero` and calls the check.
- Deployment: ships with the pack through setup and `sync-installed.mjs`
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/current/
- plan/backlog/

## Scope
- In:
  - `scripts/hook-check.mjs` at `ravintio-zero/scripts/hook-check.mjs`, with a test beside the other script tests.
  - One fixed sample input per hook event and matcher. Exit 2 from a guard counts as a pass.
  - Driver wiring: the driver runs the check after setup and stops with a `Blocked:` line on a failure.
  - Docs and `component.yml` updates for the new script.
- Out: changing any hook's behaviour. Checking hooks outside `.claude/settings.json`.
- Deferred: none

## Assumptions
- Every hook command in `.claude/settings.json` accepts JSON on stdin - impact if wrong: the check reports a false failure for that hook.
- The pack source lives in `src/ravintio-zero/` and the refresh route copies it - impact if wrong: the installed copy lacks the check.

## Risks
- A sample input triggers a side effect in a hook (low likelihood, medium impact). Mitigation: run in a temporary project directory.
- A guard changes its block code (low likelihood, medium impact). Mitigation: the test pins exit 0 and exit 2 as passes.

## Dependencies
- Upstream: migration 0009 (done), step 53
- Downstream: the driver run after setup
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - hook-check script | ravintio-implement | Script and test land together through the TDD loop |
| REQ-002 - driver wiring | ravintio-implement | Small change with a test |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 12 Nov 2026 @ 01:36 PM local
