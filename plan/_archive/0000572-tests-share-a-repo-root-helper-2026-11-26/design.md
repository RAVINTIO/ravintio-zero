# Design - 0000572-tests-share-a-repo-root-helper

## Feature
- Problem: Each test works out the repo root from its own path. A suite that passes from `src/ravintio-zero/tests/` fails from `ravintio-zero/tests/` when its depth is wrong.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000572-tests-share-a-repo-root-helper
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a test author, I call `repo_root` and get the repo top from either tree.
  - US-002: As a test author, I call `pack_tree_src` and `pack_tree_installed` and never build a `../..` path.
  - US-003: As a test author, I read the both-trees rule in the testing standards.
- Acceptance criteria confirmed: 5
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. The helper adds no output when a suite sources `assert.sh`.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no new input. Shell functions and text only. No data.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: markdown and bash. Tests in bash. CI on GitHub Actions. Build target ci-only.
- Components: `ravintio-zero`, the component pack. It holds the test helpers and the testing standards.
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
- In: three helper functions in `assert.sh`, one standards paragraph, two suites that adopt the helper, one new suite, docs and manifest updates.
- Out: moving every existing suite. A PowerShell twin. Removing the two-tree layout.
- Deferred: none.

## Assumptions
- `product.yml` sits at the repo root and nowhere between a suite and the root. Impact if wrong: the helper returns a wrong folder, and the new suite fails.

## Risks
- A suite pins `assert.sh` or `testing-standards.md` text (likelihood: medium, impact: low). The step updates each pin and logs a `Rework:` line.
- A shared assertion file breaks every suite if it has a syntax error (likelihood: low, impact: high). The full suite runs before ship.

## Dependencies
- Upstream: none.
- Downstream: none.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Repo-root helpers | ravintio-implement | Three functions and one suite |
| REQ-002 - Standard and adoption | ravintio-implement | One paragraph and two suite edits |

## Repo Instructions
- custom-001-local-git-only
- custom-002-prefer-subagent-decomposition
- custom-004-ship-push-and-raise-pr
- custom-006-standing-setup-refresh-approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 26 Nov 2026 @ 7:07 a.m.
