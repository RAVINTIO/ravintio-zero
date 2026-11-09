---
title: "ADR 0276: Clean clone through a script"
summary: "P3 runs the suite through clean-clone-test.mjs, which clones HEAD and removes the clone on every exit."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000385-faster-test-runs"
---
# ADR-0276 - Clean clone through a script

**Component:** ravintio-zero

## Context

P3 runs the suite in the working tree, so untracked files, ignored caches, and local OS differences change the result. CI runs in a fresh checkout.

## Decision

`clean-clone-test.mjs` clones the repository, checks out the commit `HEAD` names, runs the given command there, and removes the clone on every exit. It also reads `runs-on` values from `.github/workflows/ravintio.yml` and prints one line when the local OS differs from every CI OS.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `git worktree add` | Faster | Shares ignored state with the main tree | Not a clean checkout |
| Inline skill instructions | No new file | Each run repeats the steps and the cleanup | Cleanup gets skipped |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new script and a changed P3 step |

## Consequences

**Positive:**
- P3 matches CI for committed code.

**Negative:**
- Uncommitted work is not tested, so P3 needs a committed tree.

**Risks:**
- A crash can leave a temporary folder. The script removes it in a `finally` block and on signals.

## Related ADRs

- ADR-0275 - related-to

## Supersedes

- None

## Superseded By

- None
