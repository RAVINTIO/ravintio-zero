---
title: "ADR 001: The stack stays as declared"
summary: "This feature adds no language, runtime, package, or test framework. It adds one Node helper, roadmap-labels.mjs, and edits existing hooks, scripts, skills, and workflows."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000151-hardening-efficiency-and-ci"
---
# ADR-0156 - The stack stays as declared

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Component:** planifest-zero
**Date:** 2026-10-24

## Context

`design.md` declares the stack: Bash, PowerShell 5.1 and 7, Node ESM, Markdown, and GitHub Actions CI. The build target is local. The approved dependency list is `none`.

This feature hardens park, ship, three hooks, setup, and the roadmap driver. It also splits an orchestrator skill and reshapes the PowerShell CI job. Every change fits the existing languages and tools.

## Decision

Add no language, runtime, package, or test framework.

- **New file.** `planifest-zero/scripts/roadmap-labels.mjs` is one Node ESM file with no imports. It holds the label encoder so a test can call it without the driver.
- **Edited files.** Hooks, `roadmap-run.mjs`, `setup.sh`, `setup.ps1`, skills, standards, templates, and the CI workflow change in place.
- **Tests.** New Bash tests in `planifest-zero/tests/`. Driver tests keep the stub `claude` pattern.

See `plan/current/design.md` for the full stack.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add a test runner for the PowerShell suites | Per-case timing and parallelism come built in | A new dependency in a pack that copies into consumer repos | A two-entry CI matrix and timing output cover the need with no install step |
| Add a Markdown linter to check the references split | Automates the line check | A new package and config to maintain | A small Bash line-preservation check does the same job |
| Inline the label encoder in the driver | No new file | A test can only reach it by running the whole driver | A separate module keeps the encoder testable on its own |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Gains one Node module. No runtime, package, or framework changes |

## Consequences

**Positive:**
- Consumer repos need no new install step.
- The encoder has direct unit tests.

**Negative:**
- Small amounts of parsing code may repeat across hooks, because the hooks share no helper library.
- A stub `claude` only approximates a real child session.

**Risks:**
- Node version drift could break the ESM files. The existing hooks share this risk and CI covers it.

## Related ADRs

- ADR-0160 - related-to (the driver imports the new module)
- ADR-0161 - related-to (the split adds Markdown files only)

## Supersedes

- None

## Superseded By

- None
