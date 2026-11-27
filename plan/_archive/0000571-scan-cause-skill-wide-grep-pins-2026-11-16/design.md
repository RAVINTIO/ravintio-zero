# Design - 0000571-scan-cause-skill-wide-grep-pins

## Feature
- Problem: The test impact scan never says to look for suites that loop over every `SKILL.md`. A plan that adds a term to a skill misses the pin, and the full suite finds it late.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000571-scan-cause-skill-wide-grep-pins
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I list the suites that grep every skill. I do this when I add a term to a `SKILL.md`. No skill-wide pin then fails the full suite late.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. The scan holds 21 lines at most.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no new input. Text and tests only. No data.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: markdown and bash. Tests in bash. CI on GitHub Actions. Build target ci-only.
- Components: `ravintio-zero`, the component pack. It holds the plan skill and the tests.
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- src/ravintio-zero/
- ravintio-zero/
- plan/
- docs/

## Scope
- In: one sentence in the `Skill-text budget` cause of the plan reference file, one new suite, docs and manifest updates.
- Out: a script that finds skill-wide pins. A new cause line.
- Deferred: none.

## Assumptions
- The sentence extends the existing cause line, so the scan stays at 21 lines. Impact if wrong: five suites need a higher cap.

## Risks
- A suite pins the reference text or the wording allowlist (likelihood: low, impact: low). The step updates each pin and logs a `Rework:` line.

## Dependencies
- Upstream: step 26 (merged) added the sibling-copy sentence and holds the scan at 21 lines.
- Downstream: none.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Skill-wide grep pin | ravintio-implement | One sentence edit and one suite |

## Repo Instructions
- custom-001-local-git-only
- custom-002-prefer-subagent-decomposition
- custom-004-ship-push-and-raise-pr
- custom-006-standing-setup-refresh-approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 16 Nov 2026 @ 12:31 a.m.
