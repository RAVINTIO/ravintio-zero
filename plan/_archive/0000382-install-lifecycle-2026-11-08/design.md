# Design - 0000382-install-lifecycle

## Feature
- Problem: A developer cannot update, check, or remove a Zero install with one command. Setup accepts uncommitted pack files, turns strict mode on for good, and gives a poor first run. No file lists the pack facts.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000382-install-lifecycle
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a developer, I update the pack and check the install with one command each.
  - US-002: As a developer, I want setup to install only committed pack files.
  - US-003: As a developer, I remove Zero's setup changes with one command and keep my own work.
  - US-004: As a teammate who clones, I get the guards after one documented step, and the flags decide strict mode.
  - US-005: As a new developer, I get unblocked from the docs and messages alone.
  - US-006: As a writer, I take every pack fact from one generated file.
- Acceptance criteria confirmed: 10, listed in `feature-brief.md`
- Constraints: no guard gains an allowed form. `setup.sh` and `setup.ps1` stay in parity.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: uninstall removes only paths in the manifest and the guards setup wired, and refuses during an active run. The update source is untrusted input: setup copies it only after the human names it, then commits it before it runs. Data classification: none.
- Data privacy: no regulated data
- Observability: each command prints one line per change it makes or reverses
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell, Node. Tests in Bash and PowerShell. CI on GitHub Actions. Build target ci-only.
- Components: `ravintio-zero`
- Data ownership: `ravintio-zero` owns the manifests, `plan/state/{tool}.md`, and `pack-facts.json`
- Deployment: none
- API versioning: not applicable

## Scope
- In: update, doctor, uninstall, clean-tree check, strict persistence, help and banner, block-message wording, docs, session-start check, pack facts file
- Out: network download of releases
- Deferred: nothing

## Assumptions
- A test workspace can commit its pack - impact if wrong: a suite fails and gets a helper call.
- The setup manifest lists every write - impact if wrong: uninstall leaves a file behind and prints it.

## Risks
- The clean-tree check breaks the roughly 90 suites that run setup in a workspace (likelihood high, impact medium): a shared helper commits the pack in each workspace.
- Uninstall removes a developer's entry (likelihood low, impact high): it removes only manifest paths and RAVINTIO-marked hook entries.

## Dependencies
- Upstream: step 5 (setup safety)
- Downstream: steps 14, 15, and 17 build on the setup scripts
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| All | ravintio-implement | Shell and PowerShell edits with paired tests |

## Repo Instructions
Git permissions and commit granularity, the subagent decomposition standing instruction, and the standing setup refresh approval (`ravintio-overrides/instructions/`).

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 08 Nov 2026 @ 02:33 a.m. UTC
