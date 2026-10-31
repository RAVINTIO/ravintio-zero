# Design - 0000317-block-forced-adds

## Feature
- Problem: A forced `git add` committed ignored driver files in initiative 0000238, and nothing in the pack forbids or detects it.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000317-block-forced-adds
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I want the orchestrator skill to forbid `git add -f`, so that a step never forces an ignored file into a commit.
  - US-002: As a maintainer, I want a hook that blocks a forced add, so that the rule holds when a step forgets it.
  - US-003: As a developer with a fresh clone, I want the driver paths in the tracked `.gitignore`, so that git and CI treat them as ignored.
  - US-004: As a maintainer, I want ship and CI to fail when a committed file matches an ignore rule, so that a forced add never reaches `main`.
- Acceptance criteria confirmed: 6
- Constraints: code and docs land together. The new hook lets nothing pass that a hook blocks today.
- Integrations: Claude Code `.claude/settings.json`, GitHub Actions

## Architecture Layer
- Latency target: the guard adds under 200 ms per Bash call
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The change adds a guard and widens none. Data classification: no regulated data.
- Data privacy: no regulated data.
- Observability: a blocked call prints one line to stderr and stdout that names the rule.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ES modules, Bash and PowerShell, Markdown, GitHub Actions CI, build target local
- Components: `ravintio-zero` - setup scripts, enforcement hooks, CI template, tests
- Data ownership: none
- Deployment: pack files copied by setup
- API versioning: not applicable

## Scope
- In: orchestrator skill rule, forced-add guard and its setup wiring in both scripts, `.gitignore` driver entries, ignored-file check in ship and in both CI workflows, tests, docs.
- Out: changes to existing guards, a Codex hook, other staging routes.
- Deferred: nothing.

## Assumptions
- A tracked file that matches an ignore rule on purpose gets a negation rule in `.gitignore`, and the CI check stays - impact if wrong: the check fails and the step stops.

## Risks
- The tripwire misses a forced-add form. Likelihood medium, impact medium: the guard blocks every `git` command that names `add` with any `-f`-bearing flag, and the CI check is the second layer.
- The guard blocks a legitimate command that only mentions `git add -f` in text. Likelihood medium, impact low: the message tells the writer to use the Write tool, as `merge-guard` does.
- Windows quoting differs in the `setup.ps1` wiring. Likelihood medium, impact medium: `setup.ps1` reuses the shared hook entry builder, and CI runs the PowerShell tests.

## Dependencies
- Upstream: step 4 is merged. It supplies `guard-run.mjs` and the `${CLAUDE_PROJECT_DIR}` wiring.
- Downstream: step 6 changes the coordinator rules. Step 7 adds a CI check to the same workflow files.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - orchestrator rule against forced adds | ravintio-implement | Skill text with a test |
| REQ-002 - forced-add guard and wiring | ravintio-implement | New hook with a test |
| REQ-003 - tracked ignores for driver paths | ravintio-implement | Config change with a test |
| REQ-004 - ignored-file check in ship and CI | ravintio-implement | Workflow and skill change with a test |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Version
0.42.0 -> 0.43.0 (step 5 Bump: minor)

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 31 Oct 2026 @ 10:40 p.m. UTC
