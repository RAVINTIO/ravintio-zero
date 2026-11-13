---
title: "ADR 003: Delete merged head branches from a scoped CI job"
summary: "A cleanup-branch job in ravintio.yml holds contents write on that job only."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000355-codeql-and-branch-cleanup"
---
# ADR-0253 - Delete merged head branches from a scoped CI job

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Date:** 2026-11-06

## Context

Merged head branches pile up on `origin`. Entry 0000323 asks each developer to turn on a repo setting. The human ruled that the pack solves it itself. The workflow needs a write token, and the repo default is read-only.

## Decision

Add a `cleanup-branch` job to `ravintio.yml`, in the pack template and in this repo. It runs when a PR into `main` or `initiative/**` closes as merged. It holds `contents: write` on that job only. It skips a fork head, refuses `main` and `master`, and reads the ref from `env`. It checks the ref against an allowed pattern and exits 0 if the branch is gone. Every pull request job gains `github.event.action != 'closed'` in its `if`. The job deletes an `initiative/*` head when its PR into `main` merges.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Repo setting | No code | Each developer sets it | The human ruled against it |
| Separate workflow file | Own permissions, no change to other jobs | Setup must install it, in `setup.sh` and `setup.ps1` | Kept as the fallback if the guard cannot hold |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two workflow files, one shape test |

## Consequences

**Positive:**
- Branches clear with no developer action.

**Negative:**
- One job holds write access. Every pull request job needs the extra guard.

**Risks:**
- A bad ref name or a missed guard. Tests check both.

## Related ADRs

- ADR-0251 - related-to

## Supersedes

None.

## Superseded By

None.
