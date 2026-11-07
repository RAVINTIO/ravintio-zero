---
title: "Design - 0000357-guard-gaps-closed"
summary: "Confirmed design: a guard hook fails closed with no launcher, the forced-add guard covers more forms and Codex, and the prefix-misses log is ignored in every clone."
status: "confirmed"
---
# Design - 0000357-guard-gaps-closed

## Feature
- Problem: A missing `guard-run.mjs` makes `node` exit 1, which Claude Code treats as a non-blocking error, so every guard fails open at once. `block-forced-add.mjs` misses `git stage`, subshells, and flags in variables. Codex has no forced-add guard. A fresh clone does not ignore `plan/.prefix-misses.log`.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `docs/about.md`)
- Feature ID: 0000357-guard-gaps-closed
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a maintainer, I find that a guard hook blocks the call when `guard-run.mjs` is missing, so that no file removal turns every guard off.
  - US-002: As a maintainer, I find `git stage -f`, a subshell, and a flag in a variable blocked, so that an ignored file stays out of the index.
  - US-003: As a Codex user, I get the forced-add guard from setup, so that Codex sessions block the same forms.
  - US-004: As a developer, I find `plan/.prefix-misses.log` ignored in a fresh clone and in CI, so that the ignored-file check sees a forced add of it.
- Acceptance criteria confirmed: 4
- Constraints: a guard never passes a call it cannot run or parse. Each widening has a test case. Advisory hooks keep their non-blocking behaviour. Prose follows the writing standard.
- Integrations: Claude Code and Codex PreToolUse hooks

## Architecture Layer
- Latency target: deferred - recorded in scope (no runtime target)
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: this step tightens guards. The wrapper turns any status other than 0 and 2 into 2. The forced-add guard blocks any `git add` or `git stage` segment that holds a variable, command substitution, or backtick. Data classification: none.
- Data privacy: no regulated data
- Observability: the wrapper prints one stderr line that names the launcher and the exit status.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node (`.mjs`) hooks, Bash and PowerShell setup, Bash tests, Markdown standards. Build target: ci-only.
- Components: `ravintio-zero` (hooks, setup scripts, tests, `hook-enforcement.md`)
- Data ownership: none
- Deployment: files in the pack. The step triggers a `Setup:` stop afterwards because it changes hooks and the commands setup writes.
- API versioning: not applicable

## Scope
- In: the guard command wrapper in `setup.sh` and `setup.ps1` for Claude Code and Codex, the wider forced-add guard, the Codex forced-add group, the ignore rule in `ravintio-zero/.gitignore` and `.gitignore`, tests, and `hook-enforcement.md`.
- Out: advisory hook commands, `merge-guard.mjs`, and a `.gitignore` that a consumer repo already holds.
- Deferred: nothing deferred.

## Assumptions
- Claude Code runs hook commands through a POSIX shell - impact if wrong: the `||` wrapper fails to parse and the guards need a Node wrapper.
- The Codex PreToolUse model takes a second Bash group like the first - impact if wrong: file a backlog entry and carry on.

## Risks
- The wrapper changes the command text that filters and tests match. Likelihood medium, impact low. Mitigation: the wrapper keeps the existing prefix, and the suites run before ship.
- The `$` rule blocks a harmless `git add "$f"`. Likelihood medium, impact low. Mitigation: the message says to name the path, and the chart row asks for it.
- A hook command that works on one shell fails on another. Likelihood low, impact high. Mitigation: a test runs the wired command text with `sh`.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none (initiative.md `## Dependencies`, steps 1-8: none)

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - fail closed with no launcher | ravintio-implement | Setup change in two scripts with a shell test |
| REQ-002 - wider forced-add guard | ravintio-implement | Hook change with a case per form |
| REQ-003 - forced-add guard in Codex | ravintio-implement | Setup change in two scripts |
| REQ-004 - prefix-misses log ignored | ravintio-implement | Two ignore files and a test |

## Repo Instructions
- custom-001 local git only, custom-002 prefer subagent decomposition, custom-004 ship push and raise PR, custom-006 standing setup refresh approval. Files live in `ravintio-overrides/instructions/`.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 06 Nov 2026 @ 08:26 AM UTC
