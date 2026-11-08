# Design - 0000383-test-impact-scan

## Feature
- Problem: The plan phase's test impact scan misses tests that edits to reference files, new test files, the runner allowlist, fixture pins, and a developer's own tests break.
- Adoption mode: standard-iterative (signal: `plan/_archive/` beside `product.yml`)
- Feature ID: 0000383-test-impact-scan
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I get the frozen-line tests listed when a run edits a skill's `references/` file, so that P2 finds them before the full suite.
  - US-002: As a test author, I get the repo-wide style tests listed when a run adds a test file, so that I read them first.
  - US-003: As a test author, I get the runner allowlist listed when a run adds a non-suite file under `ravintio-zero/tests/`, so that the runner does not stop.
  - US-004: As a pack maintainer, I get fixture-pinned lines listed when a run edits an existing pack line, so that P2 runs the named suites first.
  - US-005: As a developer using Zero, I get my own test folders scanned, so that a changed string lists the repo test that asserts it.
- Acceptance criteria confirmed: 3
- Constraints: scan section at most 15 non-blank lines, skill text at most 1720 lines
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no regulated data. Data classification: public.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash and Node.js, Bash test suites, GitHub Actions CI, build target local
- Components: `ravintio-zero` - pack skills, standards, templates, and tests
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Scope
- In: four scan causes, repo test folders, P2 runs named suites first, test-writer, refactor, and validate skills name repo test folders, tests for each
- Out: new scripts, changes to `run-tests.sh`
- Deferred: nothing deferred

## Assumptions
- A developer repo declares test folders in the stack or uses common names - impact if wrong: the scan finds nothing and says `none found`.

## Risks
- The scan section outgrows its 15 line cap - likelihood medium, impact low. Raise the cap in the same step if needed and log a `Rework:` line.
- A skill edit breaks a pinned line - likelihood medium, impact low. The plan lists the pinning suites.

## Dependencies
- Upstream: step 4 (rule anchors and test helpers), merged
- Downstream: step 8 (plan checks) edits the same skill
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 to REQ-005 | ravintio-implement | Skill text and test edits |

## Repo Instructions
Local git only, prefer subagent decomposition, push and raise the PR at ship, standing setup refresh approval. Files in `ravintio-overrides/instructions/`.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 07 Nov 2026 @ 09:35 PM UTC
