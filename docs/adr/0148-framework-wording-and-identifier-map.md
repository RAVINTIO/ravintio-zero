---
title: "ADR 004: Framework wording and identifier map"
summary: "No tracked file outside history names or describes Planifest Zero as a framework. Prose says Planifest Zero, the pack, or the pipeline. Identifiers follow one map. A new allowlist test enforces the rule. No migration is needed."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000042-autonomous-mode-and-prefixes"
---
# ADR-0148 - Framework wording and identifier map

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

Planifest Zero is the cut-down pack that 0000030 split from Planifest Framework. Planifest Framework is a separate product in the repo `planifest/planifest-framework`. REQ-007 fixes the product name. Many files still call Planifest Zero a framework, and a reader can confuse the two products.

A search on 2026-10-23 found 618 lines with "framework" in 150 tracked files outside the archive, the changelog, and `plan/current/`. About 50 lines are prose. About 350 lines are identifiers. About 220 lines are generic uses.

The human rejected a prose-only fix. They want the identifiers to change too. REQ-008 to REQ-010 leaves the new names to this ADR, and P2 must not start renames until it is accepted.

## Decision

### The rule

No tracked file outside history describes or names Planifest Zero as a framework. This covers prose and identifiers.

- Prose uses "Planifest Zero", "the pack", or "the pipeline", whichever reads best.
- Generic uses stay. These are the `test-frameworks.md` standards, "meta-framework", "test framework", web and API frameworks in the stack evaluation and `prefer-avoid.md` standards, and `stack.framework`.
- References to the separate product Planifest Framework stay, including `planifest/planifest-framework`.
- Files under `plan/_archive/` and `plan/changelog/` stay untouched.

### Naming convention

Code identifiers derive from the component id `planifest-zero`, so they use `zero`. File names, headings, and anchors use "pack", to match the prose. Every rename and every reference to it change in the same commit.

### Identifier name map

Each row comes from reading the code where the identifier lives. Every variable below holds the path to the `planifest-zero/` folder, so one name fits all of them.

| Old name | New name | Files |
|----------|----------|-------|
| `FRAMEWORK` (bare shell variable) | `ZERO_DIR` | 66 files. 52 are in `planifest-zero/tests/` and 14 are in `planifest-zero/tests/regression/`. Run `grep -lw FRAMEWORK` for the exact list. |
| `FRAMEWORK_DIR` | `ZERO_DIR` | `tests/test-0000027-req-003-005-007-008-governance-docs.sh`, `tests/test-0000028-req-004-install-refresh-registration.sh` |
| `FRAMEWORK_SRC` | `ZERO_DIR` | `tests/test-0000028-req-002-shared-module-extraction.sh` |
| `frameworkDir` | `zeroDir` | `scripts/self-description-check.mjs` |
| `FrameworkDir` (`$global:FrameworkDir`) | `ZeroDir` | `tests/helpers/setup-workspace.ps1`, `tests/test-0000040-req-002-003-ps1-shape-check.ps1`, `tests/test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` |
| `frameworkPath` | `zeroDir` | `hooks/enforcement/auto-trigger-orchestrator.mjs` |
| `extractFrameworkTable` | `extractPackTable` | `scripts/self-description-check.mjs` |
| `framework-update-policy.md` | `pack-update-policy.md` | `standards/framework-update-policy.md` (`git mv`), `skills/planifest-orchestrator/SKILL.md` (two lines), `tests/test-0000027-req-003-005-007-008-governance-docs.sh` |
| Anchor `#updating-the-framework`, heading "Updating the Framework" | `#updating-the-pack`, heading "Updating the pack" | `pipeline-reference.md` and `project-operations.md` (headings), `project-operations.md` and `getting-started.md` (links and the table label) |
| Heading `## The framework` | `## The pack` | `README.md`, `scripts/self-description-check.mjs` (comment, search, two messages), `tests/test-0000019-req-005-self-description-check.sh` (three fixtures) |
| `test-0000005-framework-governance.sh` | `test-0000005-pack-governance.sh` | `tests/` and `tests/regression/` copies, `tests/regression/regression-manifest.json` (`name`, `filePath`), header comment |
| `test-0000010-framework-quality-improvements.sh` | `test-0000010-pack-quality-improvements.sh` | `tests/`, header comment and run line |
| `test-0000037-req-004-remove-old-framework.sh` | `test-0000037-req-004-remove-old-folder.sh` | `tests/`. The test checks that the old `planifest-framework/` folder is gone. |
| Comment label `framework-pipeline-fixes` | `pipeline-fixes` | `tests/test-0000023-req-001-continuous-run-p1-p3.sh`, `tests/test-0000023-req-002-marker-commit-lifecycle.sh` |
| Comment label `0000005-framework-governance` | `0000005-pack-governance` | The header comment of both `test-0000005` files |

Four points about the map:

- **One variable name.** `ZERO_DIR` replaces three shell names, so a reader meets one name for the folder in every test. The ps1 and JS names follow the same stem in each language's case style.
- **Heading and parser.** The `## The pack` heading and `self-description-check.mjs` change in one commit. Otherwise the check fails with "table not found".
- **Manifest history ids.** The `sourceFeature` values in `regression-manifest.json`, such as `0000005-framework-governance` and `0000009-framework-rail-tightening`, record archived feature ids. They stay and the test allowlists them.
- **Decisions index.** `docs/decisions-index.md` records the 0000030 feature `framework-cut-down` and the old Planifest Framework folder. Those lines stay and the test allowlists them.

### The `stack.framework` field

`stack.framework` is generic. In `templates/component.template.yml` it holds `"fastify | express | hono | gin | flask"`. In `templates/component-guide.md` it is documented as "Web framework (or `none`)". `planifest-zero/component.yml` sets it to `"none"`, because the pack has no web layer. The field names a web framework in the user's stack, so it stays. The sibling lines for `stack.frontend` and `stack.testing` stay for the same reason.

The line in `planifest-zero/component.yml` that says "the framework's own behaviour" describes Planifest Zero. It becomes "the pack's own behaviour".

### The allowlist test

A new test in `planifest-zero/tests/` enforces the rule.

- It reads `git ls-files` and drops paths that start with `plan/_archive/`, `plan/changelog/`, `planifest-zero/migrations/_done/`, or `plan/current/`.
- It excludes `plan/current/` because `planifest-ship` moves those files into the archive, and they quote the old words to describe the rename.
- It excludes `migrations/_done/` because those files are past records.
- It searches the remaining files for "framework", case-insensitive.
- A matching line passes if it matches an allowlist entry. Any other line fails the test and the test prints the file and line number.
- The allowlist lives in the test file. Each entry carries a comment that names the generic use it covers.

The allowlist entries cover:

- Lines in the 21 `test-frameworks.md` standards, and links to them.
- The two stack evaluation standards and the web framework tables in the `prefer-avoid.md` files.
- "meta-framework", "test framework", "testing framework", and "language or framework in use".
- The three `stack.framework`, `stack.frontend`, and `stack.testing` lines in `component-guide.md` and the `framework:` line in `component.template.yml`.
- "Planifest Framework" and `planifest/planifest-framework`.
- The `sourceFeature` lines in `regression-manifest.json`.
- The 0000030 `framework-cut-down` lines in `docs/decisions-index.md`.
- The lines of the allowlist test itself, which must name the word to match it.

The test must fail when a scratch copy of `README.md` gains the line "Planifest Zero is a framework". A second case in the test proves it.

### Out of scope

The em dashes in the `setup.sh` echo strings are out of scope for this ADR. Where REQ-008 to REQ-010 edits a line in those strings, the edit changes the wording only.

### No migration

This repo is the only install of Planifest Zero, so no migration file is written. If another install exists, the renamed `planifest-zero/standards/pack-update-policy.md` and the test paths break it.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Change prose only | Small diff. No renamed files. No broken links. | Identifiers such as `FRAMEWORK_DIR` and `framework-update-policy.md` still name Planifest Zero as a framework. | The human wants the identifiers changed too. |
| Change every use of "framework" in every file | One rule with no allowlist. | It rewrites the `test-frameworks.md` standards, "meta-framework", and `stack.framework`. Those mean web or test frameworks, so the meaning changes. | It makes the stack guidance wrong. |
| Give each old shell name a new name, so three names survive | Each rename maps one to one. | Three names for the same folder remain. | One name for one concept is clearer. |
| Skip `plan/current/` and the archive only through a git path rule | No exclusion list in the test. | The test then flags `plan/current/` files that quote the old words. | The exclusion list is short and explicit. |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | About 150 files change. 4 test files and 1 standard are renamed. The README heading, one parser script, and the manifest change together. A new allowlist test joins the suite. |

## Consequences

**Positive:**
- A reader never meets "framework" as a name for Planifest Zero, so the two products stay distinct.
- The allowlist test stops the old wording from returning.
- One variable name, `ZERO_DIR`, replaces three in the tests.

**Negative:**
- The diff is large, and it touches 66 test files for one variable.
- Renamed tests and the renamed standard break links from history. Archived ADRs and changelog entries still cite the old paths.
- The allowlist needs upkeep. A new generic use of "framework" fails the test until someone adds an entry.

**Risks:**
- A missed reference to a renamed file breaks a test or a link. `run-tests.sh` and the link check run before acceptance.
- Another install breaks on the renamed identifiers. REQ-008 to REQ-010 records this as an assumption.
- The exclusion of `plan/current/` hides a stray old word until ship. The archive step moves those files, and they quote old words by design.

## Related ADRs

- 0000030 ADR-002 - related-to (renamed `planifest-framework/` to `planifest-zero/` and set the product id)
- ADR-0117 - related-to (archive attribution relies on the id `planifest-zero`, which does not change)

## Supersedes

- None

## Superseded By

- None

## Implementation notes (P2)

The build followed the map, with these additions:

- The standards hold 21 `test-frameworks.md` files, not 22.
- The allowlist also covers lines that are generic on reading:
  - the `stack-summary.md` table header
  - two lines in `code-quality-standards.md`
  - "framework internals" in `testing-standards.md`
  - "Framework-specific terms" in `domain-glossary-guide.md`
  - the stack table in `feature-brief.template.md`
  - `framework: "none"` in `planifest-zero/component.yml`
- The allowlist covers the old `planifest-framework/` folder name in any file, not only `docs/decisions-index.md`.
- Names outside the map follow its convention:
  - `## Pack Index (JIT Loading)`
  - "Pack dependency update"
  - "Pack Update Policy"
  - `# Planifest Zero - Mandatory Pipeline Rules` in `standard-boot.md`
- `docs/decisions-index.md` now titles 0000033's telemetry ADR "Telemetry is not a pack concern". The archived ADR keeps its original title.
- `README.md` names the separate product by its repo, `planifest/planifest-framework`, so the REQ-007 test's ban on the product name holds.
- `test-0000031-req-001` ignores lines that link to `planifest/<old name>`.
- No automated check confirms that the archive and changelog stay unchanged, because ship moves files into the archive. A manual `git diff` confirmed it at P2.
