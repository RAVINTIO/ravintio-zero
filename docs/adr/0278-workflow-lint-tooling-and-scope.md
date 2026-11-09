---
title: "ADR 278: Workflow lint tooling and scope"
summary: "A pinned actionlint and zizmor job in the repo's own workflow, not mirrored to consumers."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000394-github-security-and-ci-lint"
---
# ADR-0278 - Workflow lint tooling and scope

**Status:** accepted
**Component:** ravintio-zero

## Context

Nothing checks the workflows before they run. Entry 0000325 asks for `actionlint` and `zizmor`, both pinned.

## Decision

A `workflow-lint` job in `.github/workflows/ravintio.yml` installs `zizmor` from PyPI at a pinned version and `actionlint` from its release download script at a pinned commit and version. It runs `actionlint` and then `zizmor --no-online-audits .github/workflows`. The job is not copied to `ravintio-zero/hooks/ravintio.yml`, because consumers choose their own lint tools. Existing findings get fixed in the workflows. A finding that cannot be fixed gets an inline `zizmor: ignore` with a reason.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Third-party lint actions | One `uses:` line | Another action to pin and trust | The tools run from their own releases |
| Mirror the job to the template | Consumers lint too | Imposes tools on consumers | Out of the entry's scope |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One job in the repo workflow |

## Consequences

**Positive:**
- A new unpinned action or template injection fails the PR.

**Negative:**
- `--no-online-audits` skips the audits that need a token.

**Risks:**
- A new `zizmor` release adds an audit. The pinned version prevents surprise failures.

## Related ADRs

- ADR-0277 - related-to

## Supersedes

- None

## Superseded By

- None
