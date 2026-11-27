# Design - 0000579-convert-remaining-suites-to-rule-anchors

## Feature
- Problem: About 200 suites assert whole sentences or cut sections from skills, standards, and templates. A reword of a rule breaks them. Rule anchors and `assert_rule` fix this. Step 4 applied them to the orchestrator only.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000579-convert-remaining-suites-to-rule-anchors
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I reword a rule that keeps its anchor and key terms, so that no suite breaks.
  - US-002: As a pack maintainer, I run one guard suite that rewords the converted rules, so that a suite with a whole-sentence pin fails.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Skill text stays within its caps. No rule changes meaning.
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
- Components: `ravintio-zero`, the component pack. It holds the skills, standards, templates, and suites.
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
- In: anchors on pinned rules in skills, standards, and templates. Conversion of each prose-pinning suite to `assert_rule` or `rule_text`. A ledger file `tests/helpers/anchor-conversions.txt`. A guard suite with a reword probe. Docs and manifest updates.
- Out: the 21 copies in `tests/regression/`. Suites that check structure (file lists, line caps, sync results, heading lists, frontmatter, the wording allowlist). Any change of a rule's meaning.
- Deferred: nothing deferred.

## Assumptions
- Half of the 206 scanned suites pin prose. Impact if wrong: the step converts more or fewer suites, and the ledger records each decision.
- Anchors add no sentences, so the prose check and the skill line caps stay unchanged. Impact if wrong: the step trims text.

## Risks
- Suites for the same skill file convert in parallel and race on edits to one markdown file (likelihood: medium, impact: low). Each batch owns one target family and uses a distinct anchor id prefix. The step runs the full suite before P3.
- A key term spans a phrase that a reword changes (likelihood: medium, impact: low). The reword probe samples converted suites to find these.
- Another suite pins a line that an anchor edit changes (likelihood: low, impact: low). The step updates each pin and logs a `Rework:` line.

## Dependencies
- Upstream: steps 1 to 34 (merged). Step 4 added the helpers.
- Downstream: step 36 (0000410) runs after this step.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - convert suites | ravintio-implement | One batch per target family, run in parallel |
| REQ-002 - ledger and guard | ravintio-implement | One suite and one ledger file |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 26 Nov 2026 @ 08:19 AM CET
