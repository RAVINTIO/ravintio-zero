---
title: "Feature Brief - narrow the brand guard self-entry"
summary: "The brand guard skips its two allowlist files by exact path, and the allowlist row that passes every line of them goes."
status: "approved"
version: "0.1.0"
---
# Feature Brief - narrow the brand guard self-entry

**Feature ID:** 0000460-narrow-brand-guard-self-entry

Source: backlog entry 0000432, from the initiative 0000360 retrospective (evidence row 25). The human gave the instruction on 2026-11-08 and updated it on 2026-11-10 for step 34.

## Business Goal

The brand guard allowlist holds a row that lets every line of the allowlist file pass. No decision row approved that widening of a fail-closed guard. The guard now skips the two allowlist files by exact path in code, and the allowlist holds no self-entry. Any other file that names the retired word still fails.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Exact-path skip | As a maintainer of the pack, I see the guard skip only the two allowlist files by exact path, so that no pattern in the allowlist can widen the guard. | must-have | 1 |

## Wanted outcome

- `brand-guard.sh` skips `src/ravintio-zero/tests/brand-guard-allowlist.txt` and `ravintio-zero/tests/brand-guard-allowlist.txt` by exact path.
- The self-entry row and its comment leave the allowlist.
- The CI test and the pre-push hook apply the same skip.
- Tests show that a look-alike path still fails.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds `brand-guard.sh`, the allowlist, and their tests |

### Data Ownership

No data store.

### Integration Points

None. `pre-push` and the CI test already source `brand-guard.sh`.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash scripts and bash tests already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A path check in `brand-guard.sh` that names the two allowlist paths.
- The script and the CI test both call it.
- Removal of the self-entry row from the allowlist.
- Tests for the skip and for look-alike paths.
- Sync of `ravintio-zero/` with `sync-installed.mjs`.

### Out of Scope
- Any other allowlist row, including the row for the guard's own test.
- The excluded prefixes.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Guard strictness | No allowlist row or pattern can skip a file | A test plants the word in look-alike paths and expects a hit for each |

## Constraints and Assumptions

### Constraints
- No new library or service.
- The skip names exact paths and uses no pattern.

### Assumptions
- Paths reach the guard relative to the repo root, as `git ls-files` and `pre-push` give them. Impact if wrong: the skip misses an absolute path and the guard reports the allowlist file, which fails closed.

## Scenario Paths

**Happy path:** the guard sees either allowlist path and skips it. Every other path gets the allowlist check.

**Alternative path:** a consumer repo has only `ravintio-zero/tests/brand-guard-allowlist.txt`. The skip applies to that path.

**Error / sad path:** `brand-guard-allowlist.txt.bak`, or a copy of the file in another folder, names the word. The guard reports it.

**Cross-session continuity:** not applicable.

## Acceptance Criteria

- [ ] The allowlist holds no row that matches the allowlist file.
- [ ] The guard skips the two named paths and no others.
- [ ] A file that names the word at a look-alike path fails the guard.
- [ ] The CI test and `pre-push` use one skip rule.
