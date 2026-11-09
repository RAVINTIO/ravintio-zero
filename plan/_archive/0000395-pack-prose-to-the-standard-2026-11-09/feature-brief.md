---
title: "Feature Brief - Pack prose to the standard"
summary: "Bring the pack's own Markdown up to its writing standard and empty the prose baseline."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Pack prose to the standard

**Feature ID:** 0000395-pack-prose-to-the-standard

## Business Goal

The pack's prose breaks its own writing standard in about 2,300 places. Agents copy the pack's style, so the breaches spread into consumer repos. Step 19 rewrites the prose so the pack follows its own rules and the linter baseline reaches zero for the pack's Markdown.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Rewrite the pack's Markdown | As a pack maintainer, I run the linter and see no breach, so that consumer repos copy a clean style | must-have | 1 |
| Empty the baseline | As a pack maintainer, I lower the baseline with each fix, so that new breaches cannot hide | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The pack's skills, standards, templates, scripts, and docs |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/state/prose-baseline.json` | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown and Node.js 20 |
| Testing | Shell and Node test scripts in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Rewrite prose in Markdown under `ravintio-zero/` (skills, standards, templates, migrations, docs, and the root files) and under `docs/`, including the ADRs.
- Lower `plan/state/prose-baseline.json` with each fix.
- Update tests that pin rewritten wording.

### Out of Scope
- Code, SQL, and data values.
- `plan/_archive/`, `ravintio-zero/tests/`, `CLAUDE.md`, and `AGENTS.md`, which the linter skips.
- Changes to the linter rules.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Meaning | Each rewrite keeps the meaning and structure | Review of the diff and the full test suite |
| Linter | Zero breaches in the pack and `docs/` scope | `node ravintio-zero/scripts/prose-check.mjs check` |

## Constraints and Assumptions

### Constraints
- Rule anchors, headings that tests or scripts parse, and table cells stay intact.
- Another step must not need the files that this step rewrites at the same time.

### Assumptions
- Every remaining baseline entry sits in a file this step can edit.

## Scenario Paths

**Happy path:** The agents rewrite each file, the baseline drops to empty, and the full suite passes.

> Linter and suite both pass.

**First-run path:** Not applicable.

> none

**Error / sad path:** A rewrite breaks a test that pins wording. The step updates the pin and logs a `Rework:` line.

> as stated

**Cross-session continuity:** Each file commits with its baseline change, so an interrupted run resumes from the baseline.

> as stated

## Acceptance Criteria

- [ ] `node ravintio-zero/scripts/prose-check.mjs check` exits 0.
- [ ] The baseline holds no entry for the pack's skills, standards, templates, or `docs/`.
- [ ] The full test suite passes.
