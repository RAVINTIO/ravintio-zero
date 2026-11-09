# Design - 0000391-standards-archetypes

## Feature
- Problem: A team cannot change a standard or a template without editing the pack, and setup refuses that edit.
- Adoption mode: standard-iterative
- Feature ID: 0000391-standards-archetypes
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a pack user, I put a standard or template in `ravintio-overrides/`, so that the pipeline reads my copy before the pack copy.
  - US-002: As a maintainer, I list the rules that a hook enforces, so that an override never relaxes one.
  - US-003: As a pack user, I run `setup.sh archetype use {kind}/{name}`, so that the archetype lands in my overrides and I see what it replaced.
  - US-004: As a pack user, I pick several archetypes, so that the command reports a clash and no archetype lowers another's threshold.
  - US-005: As a team lead, I pick US writing, restricted stack, language standards, or strict testing, so that the pipeline follows my rules.
  - US-006: As a team lead, I add a constraint, so that P3 fails when a gate breaks.
  - US-007: As a pack user, I pick a writing archetype, so that the output style and `AGENTS.md` section follow it.
- Acceptance criteria confirmed: 7
- Constraints: orchestrator `SKILL.md` has 77 bytes of headroom. Setup scripts stay in parity. No hook gains an allowed form.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The resolver and the use command refuse a path outside the repo and a symlink. Data classification: public repo files.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js with no packages, bash, PowerShell, GitHub Actions, build target local
- Components:
  - `ravintio-zero`: resolver (`scripts/resolve-override.mjs`), archetype command (`scripts/archetype.mjs`), gate check (`scripts/archetype-gates.mjs`), catalogue (`archetypes/`), protected-rule list (`archetypes/protected.json`), standard (`standards/archetype-standards.md`)
- Data ownership: `ravintio-zero/archetypes/` belongs to ravintio-zero. `ravintio-overrides/` belongs to the consumer repo.
- Deployment: none. Setup copies the pack.
- API versioning: not applicable

## Component Paths
- ravintio-zero/
- ravintio-overrides/
- docs/
- plan/

## Scope
- In: resolver, protected-rule list, catalogue with four archetypes, `archetype list` and `archetype use`, clash and threshold checks, P3 gate check, writing outputs from the pick, docs, tests
- Out: installing Pact, Stryker, PIT, or Playwright MCP. Any hook change that allows a new form. Rewriting existing standards.
- Deferred: an archetype uninstall command. Nothing blocks on it.

## Assumptions
- The prose check tests no spelling - impact if wrong: the US archetype fails its own check.
- Overrides sit in `ravintio-overrides/standards/` and `ravintio-overrides/templates/` - impact if wrong: the resolver reads the wrong folder.

## Risks
- An override relaxes a hook-enforced rule. Likelihood medium, impact high. The protected-rule list and a test cover it. The chart decision for step 15 says to stop if the resolver cannot ignore such an override.
- Setup scripts drift between bash and PowerShell. Likelihood medium, impact medium. Both dispatch to one Node script, and a parity test checks it.

## Dependencies
- Upstream: step 13 writing standard, step 14 prose checks, step 6 install lifecycle
- Downstream: step 19 pack prose rewrite
- Approved dependencies: Pact, Stryker or PIT, Playwright MCP (library). The strict-testing archetype names them for consumer repos. The pack installs none.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - resolver | ravintio-implement | Script and tests |
| REQ-002 - protected rules | ravintio-implement | Data file and tests |
| REQ-003 - archetype command | ravintio-implement | Script, setup dispatch, tests |
| REQ-004 - clash and threshold | ravintio-implement | Script and tests |
| REQ-005 - four archetypes | ravintio-implement | Content and tests |
| REQ-006 - gate check | ravintio-implement | Script and tests |
| REQ-007 - writing outputs | ravintio-implement | Script change and tests |

## Repo Instructions
- custom-001-local-git-only
- custom-002-prefer-subagent-decomposition
- custom-004-ship-push-and-raise-pr
- custom-006-standing-setup-refresh-approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 09 Nov 2026 @ 06:45 PM local
