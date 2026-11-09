---
title: "ADR 004: Brand guard test"
summary: "A guard test fails when the old brand word appears outside history and a path-and-line allowlist. It follows the ADR-0148 allowlist model and covers the legacy aliases and the migration files."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000160-ravintio-rebrand"
---
# ADR-0167 - Brand guard test

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Component:** ravintio-zero
**Date:** 2026-10-24

## Context

ADR-0148 enforced its wording rule with an allowlist test. The test read `git ls-files`, dropped history paths, and failed on any line that matched no allowlist entry. That model worked for the word "framework".

The rename removes "planifest" from about 295 files. Without a guard, the word returns through copied text and old habits. Some uses must stay: the legacy aliases, the migration files, and the history records.

## Decision

Add a guard test in `ravintio-zero/tests/`, modelled on the ADR-0148 test.

### Scan

- The test reads `git ls-files`.
- It drops paths that start with `plan/_archive/`, `plan/changelog/`, `ravintio-zero/migrations/_done/`, or `plan/current/`.
- It excludes `plan/current/` because the ship phase moves those files into the archive, and they quote the old words.
- It searches the remaining files for "planifest", case-insensitive.
- It also checks file names for the word, and it fails on any match outside the dropped paths.

### Allowlist

The allowlist holds path and line entries. A match passes only when both the path and the line text match an entry. A path-only entry would let a new line hide in an allowed file.

Each entry carries a comment that names the reason. The entries cover:

- The `PLANIFEST_ROADMAP_MODEL` and `PLANIFEST_ROADMAP_MAX_TURNS` fallbacks, with removal at 2.0.0.
- The `planifest-em-dash-allow` sentinel fallback, with removal at 2.0.0.
- Migration 0004 and its two helpers, which name the old paths on purpose.
- Setup lines that detect and report old folders and markers.
- The ratified wording in `docs/decisions-index.md` for earlier features.
- Links to repos and pages that keep the old name, if any remain after the org rename.

### Failure output

A failing line prints the file and line number. The test exits non-zero on the first run that finds any unlisted match. A stale entry that matches no line also fails the test, so the allowlist cannot grow unnoticed.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Path-only allowlist | Shorter list | A new old-word line hides inside an allowed file | Weak guard |
| No guard test | No upkeep | The word returns unnoticed | The human asked for a failing test |
| A CI grep step | No test file | Skips the three-shell test runners and local runs | Tests run locally and in CI |
| Fail only on file names | Easy to write | Misses prose and code lines | The rename covers lines too |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Adds one test and its allowlist. Future edits near allowed lines must update the list |

## Consequences

**Positive:**
- The old brand word cannot return outside history without a visible change to the allowlist.
- The allowlist records every legacy use and its removal version.

**Negative:**
- Edits to allowed lines can break the test and need an allowlist update.
- A line-level allowlist takes more upkeep than a path-level one.

**Risks:**
- Line text changes in a harmless edit and the test fails. The failure message names the file and line, so the fix is quick.

## Related ADRs

- ADR-0148 - extends: reuses its allowlist test approach
- ADR-0164 - depends-on: the guard enforces the rename map
- ADR-0165 - depends-on: the allowlist holds the legacy aliases

## Supersedes

- ADR-0148, for the brand word only. The "framework" wording rule and its test stand.

## Superseded By

- None
