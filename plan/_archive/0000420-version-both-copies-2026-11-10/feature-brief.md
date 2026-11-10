---
title: "Feature Brief - the version bump writes both pack copies"
summary: "The version-files list marks the pack source copy of component.yml as optional, so the merge queue keeps src/ravintio-zero/ and ravintio-zero/ at one version."
status: "approved"
version: "0.1.0"
---
# Feature Brief - the version bump writes both pack copies

**Feature ID:** 0000420-version-both-copies

Source: the coordinator found this during I-C Run of initiative 0000360, on 2026-11-10, after the queue stopped on step 20. The human's standing approval covers CI fixes that keep the initiative moving.

## Business Goal

Step 20 (0000397) made `src/ravintio-zero/` the pack source and `ravintio-zero/` its installed copy, and CI checks that the two match. The version-files list names only `ravintio-zero/component.yml`. So the queue's version bump left the source copy behind, and `validate-branch` failed with `differs: component.yml`. Step 21 would fail the same way. The list now names the source copy too, as an optional entry, because a consumer repo has no `src/`.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Optional version files | As the coordinator of an initiative, I see the queue's version bump keep both pack copies at one version, so that CI passes after the bump. | must-have | 1 |

## Wanted outcome

- A list line that starts with `? ` names an optional file. `readVersions` and `setVersions` skip it when it does not exist.
- The shipped list names `? src/ravintio-zero/component.yml`.
- The queue stages only the listed files that exist.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds `version-files.mjs`, `merge-queue.mjs`, and their tests |

### Data Ownership

No data store.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js scripts, bash tests already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- The `? ` prefix in `version-files.mjs`.
- `? src/ravintio-zero/component.yml` in the shipped list.
- The queue's `git add` names only files that exist.
- Tests for the optional entry and the updated list.

### Out of Scope
- Any change to `sync-installed.mjs` or the pack layout.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Consumer safety | A repo with no `src/` sets and checks versions as before | The new test |

## Constraints and Assumptions

### Constraints
- A required entry that is missing still fails, as before.
- No new library or service.

### Assumptions
- Only the pack repo has `src/ravintio-zero/`. Impact if wrong: a consumer with that folder also gets the version written there, which is harmless.

## Scenario Paths

**Happy path:** in the pack repo, the queue sets the version in all four files, and `sync-installed --check` passes.

**Alternative path:** in a consumer repo, the optional file is missing, so the queue sets the three required files.

**Error / sad path:** a required file is missing. The queue stops, as before.

**Cross-session continuity:** not applicable.

## Acceptance Criteria

- [ ] An optional entry that exists gets the version. The scripts skip one that is missing.
- [ ] A missing required entry still fails.
- [ ] After a queue bump in the pack repo, both `component.yml` copies hold the new version.
