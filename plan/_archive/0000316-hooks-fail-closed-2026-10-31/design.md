# Design - 0000316-hooks-fail-closed

## Feature
- Problem: A `cd` moves the working directory, relative hook paths fail with exit 1, and Claude Code treats that as non-blocking, so the guards enforce nothing.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000316-hooks-fail-closed
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a developer, I run any `cd` in a Bash command, so that later commands and hooks still run from the project root.
  - US-002: As a developer, I start a session from a subfolder, so that every hook still finds its script.
  - US-003: As a maintainer, I want a guard whose script is missing or crashes to block and name the script, so that the guard never silently allows.
- Acceptance criteria confirmed: 5
- Constraints: code and docs land together. No change lets anything pass that a guard blocks today.
- Integrations: Claude Code `.claude/settings.json`, Codex `.codex/hooks.json`

## Architecture Layer
- Latency target: launcher adds under 200 ms per guard call
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The change makes guards stricter and widens none. Data classification: no regulated data.
- Data privacy: no regulated data.
- Observability: a failed guard prints one line to stderr that names the script.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ES modules, Bash and PowerShell, Markdown, GitHub Actions CI, build target local
- Components: `ravintio-zero` - setup scripts, enforcement hooks, tests
- Data ownership: none
- Deployment: pack files copied by setup
- API versioning: not applicable

## Scope
- In: `env` setting in both setup scripts, `${CLAUDE_PROJECT_DIR}` hook commands, absolute path in Codex commands, `guard-run.mjs` launcher for the four guards, a once-only report for advisory hooks, tests, docs.
- Out: changes to what any guard blocks, new guards, other tools.
- Deferred: nothing.

## Assumptions
- Claude Code substitutes `${CLAUDE_PROJECT_DIR}` in the command string and exports it - impact if wrong: the setup rerun check finds a hook that does not run, and the initiative stops.

## Risks
- The launcher turns a crash in a guard into a block, which stops work. Likelihood low, impact medium: the message names the script, and the guards have no known crash path today.
- The launcher script is itself missing, so the command exits 1 and the guard allows. Likelihood low, impact high: setup copies the launcher with the hooks, and the setup rerun check runs every hook. A residual gap remains and the build report records it.
- Windows quoting of `${CLAUDE_PROJECT_DIR}` differs. Likelihood medium, impact medium: `setup.ps1` writes the same command, and CI runs the PowerShell tests.

## Dependencies
- Upstream: steps 1 to 3 are merged.
- Downstream: step 5 adds a hook through the same wiring.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - setup writes the `env` setting | ravintio-implement | Setup change with a test |
| REQ-002 - hooks use the project root path | ravintio-implement | Setup change with a test |
| REQ-003 - launcher fails guards closed | ravintio-implement | New script with a test |
| REQ-004 - advisory hooks report a missing script once | ravintio-implement | Small script change with a test |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Version
0.41.2 -> 0.42.0 (step 4 Bump: minor)

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 31 Oct 2026 @ 09:27 p.m. UTC
