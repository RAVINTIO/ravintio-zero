# Design - 0000381-setup-safety

## Feature
- Problem: Setup can delete files outside its skills directory, skips files in capability skill folders, overwrites a developer's `CLAUDE.md`, and leaves retired commands installed.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000381-setup-safety
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a developer, I re-run setup, so that it removes only skill folders inside my tool's skills directory.
  - US-002: As a developer, I keep a skill with `references/` in `ravintio-overrides/capability-skills/`, so that setup installs every file of it.
  - US-003: As a developer, I install the pack into a repo that has a `CLAUDE.md`, so that my content moves to `ravintio-overrides/instructions/`.
  - US-004: As a developer, I re-run setup, so that `.claude/commands/` holds only pack commands and my own.
- Acceptance criteria confirmed: 6, listed in `feature-brief.md`
- Constraints: no guard gains an allowed form. `setup.sh` and `setup.ps1` stay in parity.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the manifest is untrusted input. Setup resolves each line under the repo root, and removes a folder only if it sits directly inside `$PROJECT_ROOT/$TOOL_SKILLS_DIR` and is not a symlink. Data classification: none.
- Data privacy: no regulated data
- Observability: setup prints one line per skipped manifest entry, per preserved file, and per pruned command
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell, Node. Tests in Bash and PowerShell. CI on GitHub Actions. Build target ci-only.
- Components: `ravintio-zero` (pack source, setup scripts, migrations, tests)
- Data ownership: `ravintio-zero` owns `.ravintio-manifest` files and `ravintio-overrides/instructions/`
- Deployment: none
- API versioning: not applicable

## Scope
- In: confinement check and relative manifest, whole capability folder copy, first-install CLAUDE.md preservation, command manifest and prune, migration 0008, suite listing guard
- Out: uninstall and update commands (step 6)
- Deferred: nothing

## Assumptions
- Legacy manifests hold absolute paths - impact if wrong: a legacy entry is skipped and its folder stays until pruned by name.
- A `CLAUDE.md` that lacks the pack boot marker is the developer's - impact if wrong: a pack file moves to overrides once. Mitigation: setup compares with the template.

## Risks
- A confinement check rejects a valid legacy path (likelihood low, impact low): the folder is reinstalled over anyway.
- Preserved content duplicates itself on re-run (likelihood low, impact medium): preserve on first install only.

## Dependencies
- Upstream: step 4 (test helpers and rule anchors)
- Downstream: step 6 (install lifecycle) edits the same scripts
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| All | ravintio-implement | Shell and PowerShell edits with paired tests |

## Repo Instructions
Git permissions and commit granularity (`ravintio-overrides/instructions/`), and the subagent decomposition standing instruction.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 07 Nov 2026 @ 09:35 PM UTC
