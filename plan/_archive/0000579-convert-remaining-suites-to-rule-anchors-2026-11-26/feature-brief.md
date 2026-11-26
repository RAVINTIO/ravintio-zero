---
title: "Feature Brief - Convert remaining suites to rule anchors"
summary: "Suites that pin skill, standard, and template prose read it through rule anchors."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Convert remaining suites to rule anchors

**Feature ID:** 0000579-convert-remaining-suites-to-rule-anchors

## Business Goal

About 200 suites assert whole sentences or cut sections from skills, standards, and templates. A reword breaks them, and each break costs a step a rework unit. The step anchors each pinned rule and moves its suite onto `assert_rule` with key terms. A reword that keeps the anchor and key terms then breaks no suite.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Convert prose-pinning suites | As a pack maintainer, I reword a rule that keeps its anchor and key terms, so that no suite breaks. | must-have | 1 |
| Conversion ledger and reword probe | As a pack maintainer, I run one suite that lists the converted suites and rewords their rules, so that a suite that regresses to a whole-sentence pin fails. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the skills, standards, templates, and suites |

### Data Ownership

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | bash and markdown |
| Testing | bash suites with `helpers/assert.sh` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Anchors on each rule that a suite pins in the ship, plan, implement, validate, initiative, and other skills, and in the standards and templates.
- Moving those suites onto `assert_rule` or `rule_text` with key terms.
- A ledger of converted suites, a guard suite, and a reword probe.

### Out of Scope
- The copies in `tests/regression/`, which the ratchet process owns.
- Suites that check structure: file lists, line caps, sync results, headings, frontmatter, and the wording allowlist.
- Changing any rule's meaning.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Suite time | The full suite takes no more time than the baseline plus 5 percent | Clean-clone run |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Run suites from both trees.
- Combined skill text stays at or under its caps.

### Assumptions
- Roughly half the 206 scanned suites pin prose. The rest check structure.

## Scenario Paths

**Happy path:** A suite that pinned a sentence reads the rule by anchor and passes. A reword that keeps the key terms passes the probe.

> Each converted suite calls `assert_rule`, and the probe passes.

**First-run path:** A skill with no anchors gets them before its suites move.

> Anchors land in the same unit as the suite conversion, so no suite reads a missing anchor.

**Error / sad path:** A key term is too narrow or too broad.

> The guard suite fails on a suite that no longer calls a helper. The probe fails on a key term that spans a reworded phrase.

**Cross-session continuity:** The ledger and the build log record converted suites, so a resumed step skips them.

> Work lands in commits per batch.

## Acceptance Criteria

- [ ] Every suite on the ledger reads its rule text through `assert_rule`, `rule_text`, or `orch_section`.
- [ ] Every ledger suite passes from both pack trees.
- [ ] The probe rewords the anchored rules in a copy of the pack, and the sampled ledger suites still pass.
