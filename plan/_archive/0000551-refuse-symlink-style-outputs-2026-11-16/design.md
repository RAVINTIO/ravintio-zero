# Design - 0000551-refuse-symlink-style-outputs

## Feature
- Problem: Setup writes the writing style output and the `AGENTS.md` writing block through a symlink.
- Adoption mode: standard-iterative (signal: source in `src/` beside an archive)
- Feature ID: 0000551-refuse-symlink-style-outputs
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a repo owner, I run setup with a symlink at a style output path, so that setup skips the write. Setup prints a fixed line and exits 0.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Version plan 0.137.0 (minor).
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: refuse a link at a write path so a planted link cannot redirect setup output
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: bash and PowerShell, shell tests, local build target
- Components: ravintio-zero (setup.sh, setup.ps1, tests)
- Data ownership: ravintio-zero owns the style file and the writing block
- Deployment: none
- API versioning: not applicable
- Fixed lines:
  - `  ! Refused: .claude/output-styles/ravintio-writing.md is a link, writing style not installed`
  - `  ! Refused: AGENTS.md is a link, writing section not installed`
- Rules: a link at the style file or its `output-styles` folder refuses the style file write and the `outputStyle` setting. A link at `AGENTS.md` refuses the writing block. A broken link counts as a link. Exit status stays 0.

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- plan/

## Scope
- In: link checks in both setup scripts, fixed lines, one test per shell, doc updates.
- Out: the `AGENTS.md` boot file write by `write_boot_file`.
- Deferred: refuse a link at the boot file write. Nothing waits on it.

## Assumptions
- A broken link counts as a link - impact if wrong: setup skips a write that could have succeeded.

## Risks
- A new refusal line changes setup output that other tests read. Likelihood low, impact low. The plan scan lists them.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - refuse linked style file | ravintio-implement | Script change with a test |
| REQ-002 - refuse linked AGENTS.md block | ravintio-implement | Script change with a test |

## Repo Instructions
Four override files in `ravintio-overrides/instructions/`: local git only, prefer subagent decomposition, ship pushes and raises the PR, standing setup refresh approval.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 16 Nov 2026 @ 02:50 a.m. GMT
