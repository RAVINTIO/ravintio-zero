# Design - 0000379-parallel-steps-on-worktrees

## Feature
- Problem: The driver runs one step at a time in one working tree, so a long initiative takes as long as all its steps added together. Independent steps should run at once, each in its own worktree, and merge through the queue.
- Adoption mode: standard-iterative (signal: `plan/_archive/` beside source)
- Feature ID: 0000379-parallel-steps-on-worktrees
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a coordinator, I give each step a lane and an `After` list and set `**Concurrency:**`, so that the driver knows what may run together.
  - US-002: As a coordinator, I run up to `**Concurrency:**` steps at once in worktrees, so that independent steps overlap.
  - US-003: As a coordinator, I want each ready step PR merged by the merge queue, so that versions follow merge order.
  - US-004: As a coordinator, I want a `Blocked:`, `Question:`, `Restart:`, or `Setup:` line from any step to stop new starts and name every step's state.
  - US-005: As a coordinator, I see every running step in the watcher and in progress reports.
  - US-006: As a human, I keep working on a `feat/` branch in the main tree, while the driver may use worktrees.
- Acceptance criteria confirmed: 6
- Constraints: no orchestrator skill text. Squash title `{7-digit feature-id}: {Title} (#{n})`. A chart without `**Concurrency:**` runs as before.
- Integrations: `git`, `gh`, and `claude` CLIs.

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no authentication of its own. Scripts pass `git`, `gh`, and `claude` argument arrays, never a shell string. A worktree path stays inside `plan/.initiative-worktrees/`. The queue never force-pushes and never merges into `main`. Data classification: no regulated data.
- Data privacy: no regulated data
- Observability: the driver prints one line per stage, each with a step number. Each step keeps its own log.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM scripts with no packages, Bash test suites, GitHub Actions CI, build target local
- Components:
  - `ravintio-zero`: pack of scripts, standards, skills, templates, and tests.
- Data ownership: the chart, the worktree folder, and the control folder belong to `ravintio-zero`.
- Deployment: none. The pack installs through `setup.sh`.
- API versioning: not applicable
- Component paths: `ravintio-zero/`

## Scope
- In: chart columns and fields, scheduler in `initiative-run.mjs`, queue hand-off, stop rules, watcher and skill reports, worktree rule scope, standards text.
- Out: automatic lane inference, `merge-guard` changes, per-step model settings.
- Deferred: none.

## Assumptions
- Setup output that git ignores (`.claude/`, `CLAUDE.md`, `AGENTS.md`) is copied into each worktree - impact if wrong: a step session starts without hooks or skills.
- `git worktree` is part of git - impact if wrong: the driver stops with a named error.

## Risks
- Two steps edit one file despite lanes - likelihood medium, impact medium. The queue merges the initiative branch into the PR branch and stops on a conflict.
- A stale worktree blocks a rerun - likelihood medium, impact low. The driver reuses a worktree for a `running` row and removes it when the step merges.

## Dependencies
- Upstream: step 2 merge queue (merged).
- Downstream: steps 4 to 21 run on the concurrent driver.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| all | ravintio-implement | Scripts with tests and docs through the TDD loop |

## Repo Instructions
- custom-001: Git permissions and commit cadence. Its worktree sentence is scoped to human sessions by this step.
- custom-002: Prefer subagent decomposition for long tasks.
- custom-004: In ship, push and raise the PR, never merge into `main`.
- custom-006: Standing approval for `ravintio-zero/setup.sh claude-code --strict-orchestrator`.

## Decisions applied (initiative chart)
- `**Concurrency:** 3`.
- The repo `CLAUDE.md` worktree rule is scoped to human sessions in `ravintio-zero/templates/standard-boot.md`. Setup regenerates this repo's `CLAUDE.md`.
- The merge queue sets versions from step 3.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 07 Nov 2026 @ 05:02 p.m. UTC
