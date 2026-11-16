# Design - 0000559-start-baseline-first

## Feature
- Problem: The baseline suite run starts as start action 15, after the design. It takes about 13 minutes, so P3 waits on it.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000559-start-baseline-first
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I start the baseline run before I write any P0 artifact, so that P3 finds the result ready.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Keep every rule anchor.
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
- Components: `ravintio-zero`, the component pack. It holds the orchestrator skill and the tests.
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
- In: reorder the start actions so the decision rows and the baseline follow the pre-flight. Renumber them and fix the cross-references. Add one suite and update the docs.
- Out: changes to `clean-clone-test.mjs`, `baseline-failures.mjs`, or the P3 comparison.
- Deferred: none

## Assumptions
- The clean-clone run reads committed files only - impact if wrong: an earlier artifact write would change the baseline.
- Step 2 (pre-flight) stays step 2 - impact if wrong: `roadmap-standards.md` cites it.

## Risks
- A missed cross-reference to a renumbered action. Likelihood medium, impact low. The new suite checks the known citations.
- The wait test reads four lines after the baseline anchor. Likelihood low, impact low. The edit keeps the layout.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - start order | ravintio-implement | Text edit with one suite |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 16 Nov 2026 @ 05:36 AM local
