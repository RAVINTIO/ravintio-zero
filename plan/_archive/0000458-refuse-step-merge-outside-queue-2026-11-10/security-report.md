---
title: "Security Report - 0000458-refuse-step-merge-outside-queue"
summary: "Findings for the step-session refusal in merge-guard."
---
# Security Report - 0000458-refuse-step-merge-outside-queue

**Overall risk rating:** low. The change narrows a fail-closed guard.

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| The guard reads an environment variable. A session that unsets it escapes the refusal | `merge-guard.mjs` | Low | The old rules still apply: `--squash`, an `initiative/*` base, and no `main`. The driver sets the variable and a step cannot change its parent environment |
| The refusal runs after the raw-text wire and before the parser, so it handles no command text | `merge-guard.mjs` | none | The block path runs no command and calls no `gh` |
| Injection, credentials, path traversal, dependencies, data exposure | the changed files | none found | The change adds no library, no file access, and no network call |

## Risk register

- R-001 (block stops a no-driver step): accepted. That path leaves the variable unset.
- R-002 (hook lacks the variable): accepted. The guard keeps today's rules.

## Top actions before production

None.
