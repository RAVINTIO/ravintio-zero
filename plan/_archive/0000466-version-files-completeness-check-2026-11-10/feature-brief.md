---
title: "Feature Brief - Version files completeness check"
summary: "A test that fails when ravintio-zero/version-files.txt omits a file that carries the product version."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Version files completeness check

**Feature ID:** 0000466-version-files-completeness-check

## Business Goal

The layout move in 0000397 left `version-files.txt` stale. The queue bumped one copy of `component.yml` only, and CI failed at `sync-installed.mjs --check`. No check ties the list to the real version-carrying files, so the next move can repeat the failure. Pulled in from backlog entry 0000433.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Completeness test | As a pack maintainer, I run the suite, so that it fails when the version list omits a file that carries the product version. | must-have | 1 |

## Scope Boundaries

### In Scope
- One test that finds every tracked file with a pack version and fails when `version-files.txt` omits one.

### Out of Scope
- Changes to `version-files.mjs` or to the queue.

### Deferred
- None.

## Acceptance Criteria

- [ ] The test passes on the current repo.
- [ ] The test fails when a version-carrying file is missing from the list, and names the file.
- [ ] The test fails when a listed non-optional file does not exist.
