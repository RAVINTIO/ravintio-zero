---
title: "Security Report - 0000440-driver-reads-reply-blocks"
summary: "Advisory security review of the driver reply block read."
---
# Security Report - 0000440-driver-reads-reply-blocks

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000440-driver-reads-reply-blocks
**Version:** 0.78.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Reply text is untrusted model output. | `ravintio-zero/scripts/initiative-run.mjs` `readReply`, `blockIn` | Low | The text goes to a regex and a printed stop line only. It reaches no shell, path, or `spawn` argument. The test with `$(touch pwned)` shows it. |
| The stop line prints reply text to the terminal. | `initiative-run.mjs` stop line | Low | `blockIn` cuts the line at 500 characters (`MAX_LINE`). The existing build-log read printed the same kind of text. |
| An unbounded stdout line could use memory. | `initiative-run.mjs` `pending` buffer | Low | The buffer drops a line over `REPLY_MAX` (4 MiB). |
| The continue prompt names an archive folder. | `initiative-run.mjs` `logLine` | Low | The name comes from `readdirSync` of `plan/_archive` filtered by the feature id. The function skips a symlinked `plan` or archive and a symlinked log. |
| Dependency risk | none | None | No new dependency. |
| Credential handling | none | None | The change reads and writes no credential. |

## Risk register cross-reference

- R-001 (old block text stops a healthy step): the driver reads only the current session's reply. Mitigated.
- R-002 (malformed event line): each line parses in a try block. Mitigated.

## Top actions before production

None.
